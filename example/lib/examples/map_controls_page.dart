import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import 'package:yandex_mapkit_example/examples/widgets/control_button.dart';
import 'package:yandex_mapkit_example/examples/widgets/map_page.dart';

class MapControlsPage extends MapPage {
  const MapControlsPage() : super('Map controls example');

  @override
  Widget build(BuildContext context) {
    return _MapControlsExample();
  }
}

class _MapControlsExample extends StatefulWidget {
  @override
  _MapControlsExampleState createState() => _MapControlsExampleState();
}

class _MapControlsExampleState extends State<_MapControlsExample> {
  late YandexMapController controller;
  final List<MapObject> mapObjects = [];

  final MapObjectId targetMapObjectId = MapObjectId('target_placemark');
  static const Point _point = Point(latitude: 59.945933, longitude: 30.320045);
  bool isNightModeEnabled = false;
  bool isZoomGesturesEnabled = false;
  bool isTiltGesturesEnabled = false;
  final String emptyStyle = '''
    [
      {
        "tags": {
          "all": ["landscape"]
        },
        "stylers": {
          "saturation": 0,
          "lightness": 0
        }
      }
    ]
  ''';
  final String nonEmptyStyle = '''
    [
      {
        "tags": {
          "all": ["landscape"]
        },
        "stylers": {
          "color": "f00",
          "saturation": 0.5,
          "lightness": 0.5
        }
      }
    ]
  ''';
  double _height = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          child: YandexMap(
            onMapCreated: (YandexMapController yandexMapController) async {
              controller = yandexMapController;
              final tiltGesturesEnabled = await controller.isTiltGesturesEnabled();
              final zoomGesturesEnabled = await controller.isZoomGesturesEnabled();

              final cameraPosition = await controller.getCameraPosition();
              final minZoom = await controller.getMinZoom();
              final maxZoom = await controller.getMaxZoom();

              print('Camera position: $cameraPosition');
              print('Min zoom: $minZoom, Max zoom: $maxZoom');

              setState(() {
                isTiltGesturesEnabled = tiltGesturesEnabled;
                isZoomGesturesEnabled = zoomGesturesEnabled;
              });
            },
            onMapSizeChanged: (MapSize size) => print('Map size changed to $size'),
            onMapTap: (Point point) => print('Tapped map at $point'),
            onMapLongTap: (Point point) => print('Long tapped map at $point'),
            onCameraPositionChanged: (CameraPosition cameraPosition, CameraUpdateReason reason, bool finished) {
              print('Camera position: $cameraPosition, Reason: $reason');

              if (finished) {
                print('Camera position movement has been finished');
              }
            },
          )
        ),
        SizedBox(height: _height),
        const SizedBox(height: 20),
        Expanded(
          child: SingleChildScrollView(
            child: Table(
              children: <TableRow>[
                TableRow(children: <Widget>[
                  ControlButton(
                    onPressed: () async {
                      await controller.setBounds(
                        boundingBox: BoundingBox(
                          northEast: const Point(latitude: 65.0, longitude: 40.0),
                          southWest: const Point(latitude: 60.0, longitude: 30.0),
                        )
                      );
                    },
                    title: 'Set bounds'
                  ),
                  ControlButton(
                    onPressed: () async {
                      await controller.move(
                        cameraPosition: const CameraPosition(target: _point),
                        animation: const MapAnimation(smooth: true, duration: 2.0)
                      );
                    },
                    title: 'Move'
                  ),
                ]),
                TableRow(children: <Widget>[
                  ControlButton(
                    onPressed: () => controller.zoomIn(),
                    title: 'Zoom in'
                  ),
                  ControlButton(
                    onPressed: () => controller.zoomOut(),
                    title: 'Zoom out'
                  ),
                ]),
                TableRow(children: <Widget>[
                  ControlButton(
                    onPressed: () async {
                      setState(() {
                        isZoomGesturesEnabled = !isZoomGesturesEnabled;
                      });
                      await controller.toggleZoomGestures(enabled: isZoomGesturesEnabled);
                    },
                    title: 'Zoom gestures: ${isZoomGesturesEnabled ? 'on' : 'off'}'
                  ),
                  ControlButton(
                    onPressed: () async {
                      final region = await controller.getVisibleRegion();
                      print('TopLeft: ${region.topLeft}, BottomRight: ${region.bottomRight}');
                    },
                    title: 'Visible map region'
                  ),
                ]),
                TableRow(children: <Widget>[
                  ControlButton(
                    onPressed: () async {
                      final placemark = Placemark(
                        mapId: targetMapObjectId,
                        point: (await controller.getCameraPosition()).target,
                        style: PlacemarkStyle(
                          opacity: 0.7,
                          icon: PlacemarkIcon.fromIconName(iconName: 'lib/assets/place.png'),
                        ),
                      );

                      mapObjects.removeWhere((el) => el.mapId == targetMapObjectId);
                      mapObjects.add(placemark);
                      await controller.updateMapObjects(mapObjects);
                    },
                    title: 'Target point'
                  ),
                  ControlButton(
                    onPressed: () async {
                      await controller.logoAlignment(
                        alignment: MapAlignment(
                          horizontal: HorizontalAlignment.center,
                          vertical: VerticalAlignment.bottom
                        )
                      );
                    },
                    title: 'Logo position'
                  ),
                ]),
                TableRow(children: <Widget>[
                  ControlButton(
                    onPressed: () async {
                      await controller.setMapStyle(style: nonEmptyStyle);
                    },
                    title: 'Set Style'
                  ),
                  ControlButton(
                    onPressed: () async {
                      await controller.setMapStyle(style: emptyStyle);
                    },
                    title: 'Remove style'
                  ),
                ]),
                TableRow(children: <Widget>[
                  ControlButton(
                    onPressed: () async {
                      isNightModeEnabled = !isNightModeEnabled;
                      await controller.toggleNightMode(enabled: isNightModeEnabled);
                    },
                    title: 'Night mode'
                  ),
                  ControlButton(
                    onPressed: () async {
                      setState(() {
                        _height = _height == 0 ? 10 : 0;
                      });
                    },
                    title: 'Change size'
                  )
                ]),
                TableRow(
                  children: <Widget>[
                    ControlButton(
                      onPressed: () async {
                        await controller.setFocusRect(
                          screenRect: const ScreenRect(
                            bottomRight: ScreenPoint(x: 600, y: 600),
                            topLeft: ScreenPoint(x: 200, y: 200)
                          )
                        );
                      },
                      title: 'Focus rect'
                    ),
                    ControlButton(
                      onPressed: () async {
                        await controller.clearFocusRect();
                      },
                      title: 'Clear focus rect'
                    )
                  ],
                ),
                TableRow(children: <Widget>[
                  ControlButton(
                      onPressed: () async {
                        setState(() {
                          isTiltGesturesEnabled = !isTiltGesturesEnabled;
                        });
                        await controller.toggleTiltGestures(enabled: isTiltGesturesEnabled);
                      },
                      title: 'Tilt gestures: ${isTiltGesturesEnabled ? 'on' : 'off'}'
                  ),
                  Container(),
                ]),
              ],
            ),
          ),
        )
      ]
    );
  }
}
