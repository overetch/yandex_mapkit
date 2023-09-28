part of yandex_mapkit;

/// Arrival and departure time estimations for time-dependent routes or sections of time-dependent routes.
class PedestrianTravelEstimation extends Equatable {
  /// Departure time for a route or a route section
  final YMKTime departureTime;

  /// Arrival time for a route or a route section
  final YMKTime arrivalTime;

  const PedestrianTravelEstimation._(this.departureTime, this.arrivalTime);

  factory PedestrianTravelEstimation._fromJson(Map<String, dynamic> json) {
    return PedestrianTravelEstimation._(
      YMKTime._fromJson(json['departureTime']),
      YMKTime._fromJson(json['arrivalTime']),
    );
  }

  @override
  List<Object?> get props => [departureTime, arrivalTime];

  @override
  bool? get stringify => true;
}
