import Foundation
import YandexMapsMobile

public class YandexPedestrianSession: NSObject {
    private var id: Int
    private var session: YMKMasstransitSession
    private let methodChannel: FlutterMethodChannel!
    private var onClose: (Int) -> ()

    public required init(
        id: Int,
        session: YMKMasstransitSession,
        registrar: FlutterPluginRegistrar,
        onClose: @escaping ((Int) -> ())
    ) {
        self.id = id
        self.session = session
        self.onClose = onClose

        methodChannel = FlutterMethodChannel(
            name: "yandex_mapkit/yandex_pedestrian_session_\(id)",
            binaryMessenger: registrar.messenger()
        )

        super.init()

        weak var weakSelf = self
        self.methodChannel.setMethodCallHandler({ weakSelf?.handle($0, result: $1) })
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "cancel":
            cancel()
            result(nil)
        case "retry":
            retry(result)
        case "close":
            close()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    public func cancel() {
        session.cancel()
    }

    public func retry(_ result: @escaping FlutterResult) {
        session.retry(routeHandler: {(pedestrianResponse: [YMKMasstransitRoute]?, error: Error?) -> Void in
            self.handleResponse(pedestrianResponse: pedestrianResponse, error: error, result: result)
        })
    }

    public func close() {
        session.cancel()

        onClose(id)
    }

    public func handleResponse(pedestrianResponse: [YMKMasstransitRoute]?, error: Error?, result: @escaping FlutterResult) {
        if let response = pedestrianResponse {
            onSuccess(response, result)
        } else {
            onError(error!, result)
        }
    }

    private func onSuccess(_ res: [YMKMasstransitRoute], _ result: @escaping FlutterResult) {
        let routes = res.map { (route) -> [String: Any] in
            let weight = route.metadata.weight
            let wayPoints = route.wayPoints.map{(point) -> [String: Any] in
                var selectedArrivalPoint: [String: Any]? = nil
                var selectedDeparturePoint: [String: Any]? = nil

                if let arrivalPoint = point.selectedArrivalPoint {
                    selectedArrivalPoint = [
                        "latitude": arrivalPoint.latitude,
                        "longitude": arrivalPoint.longitude
                    ]
                }

                if let departurePoint = point.selectedDeparturePoint {
                    selectedDeparturePoint = [
                        "latitude": departurePoint.latitude,
                        "longitude": departurePoint.longitude
                    ]
                }

                return [
                    "position": [
                        "latitude": point.position.latitude,
                        "longitude": point.position.longitude,
                    ],
                    "selectedArrivalPoint": selectedArrivalPoint as Any,
                    "selectedDeparturePoint": selectedDeparturePoint as Any,
                ]
            }

            let sections = route.sections.map{(section) -> [String: Any] in
                let weight = section.metadata.weight
                let geometry = section.geometry
                var estimation: [String: Any]? = nil

                if let e = section.metadata.estimation {
                    estimation = [
                        "departureTime": [
                            "value": e.departureTime.value,
                            "tzOffset": e.departureTime.tzOffset,
                            "text": e.departureTime.text,
                        ] as [String : Any],
                        "arrivalTime": [
                            "value": e.arrivalTime.value,
                            "tzOffset": e.arrivalTime.tzOffset,
                            "text": e.arrivalTime.text,
                        ] as [String : Any]
                    ]
                }

                return [
                    "metadata": [
                        "weight": [
                            "time": Utils.localizedValueToJson(weight.time),
                            "walkingDistance": Utils.localizedValueToJson(weight.walkingDistance),
                            "transfersCount": weight.transfersCount,
                        ] as [String : Any],
                        "estimation": estimation as Any,
                        "legIndex": section.metadata.legIndex,
                    ],
                    "geometry": [
                        "begin": [
                            "segmentIndex": geometry.begin.segmentIndex,
                            "segmentPosition": geometry.begin.segmentPosition,
                        ] as [String : Any],
                        "end": [
                            "segmentIndex": geometry.end.segmentIndex,
                            "segmentPosition": geometry.end.segmentPosition,
                        ] as [String : Any],
                    ]
                ]
            }

            return [
                "waypoints": wayPoints,
                "sections": sections,
                "geometry": route.geometry.points.map {
                    (point) -> [String: Any] in Utils.pointToJson(point)
                },
                "metadata": [
                    "weight": [
                        "time": Utils.localizedValueToJson(weight.time),
                        "walkingDistance": Utils.localizedValueToJson(weight.walkingDistance),
                        "transfersCount": weight.transfersCount,
                    ] as [String : Any]
                ]
            ]
        }

        let arguments: [String: Any] = [
            "routes": routes
        ]

        result(arguments)
    }
    private func onError(_ error: Error, _ result: @escaping FlutterResult) {
        var errorMessage = "Unknown error"

        if let underlyingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as? YRTError {
            if underlyingError.isKind(of: YRTNetworkError.self) {
                errorMessage = "Network error"
            } else if underlyingError.isKind(of: YRTRemoteError.self) {
                errorMessage = "Remote server error"
            }
        } else if let msg = (error as NSError).userInfo["message"] {
            errorMessage = msg as! String
        }

        let arguments: [String: Any?] = [
            "error": errorMessage
        ]

        result(arguments)
    }
}
