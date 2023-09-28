part of yandex_mapkit;

/// A waypoint is the origin, destination or intermediate destination on the route.
/// For each waypoint, the corresponding selected arrival point can be stored.
class PedestrianWayPoint extends Equatable {
  /// Coordinates of the original waypoint from the request
  final Point position;

  /// Coordinates of the arrival point that was selected for arrival at the waypoint
  final Point? selectedArrivalPoint;

  /// Coordinates of the arrival point that was selected for departure from the waypoint
  final Point? selectedDeparturePoint;

  const PedestrianWayPoint._(
      this.position, this.selectedArrivalPoint, this.selectedDeparturePoint);

  factory PedestrianWayPoint._fromJson(Map<dynamic, dynamic> json) {
    final selectedArrivalPoint = json['selectedArrivalPoint'] != null
        ? Point._fromJson(json['selectedArrivalPoint'])
        : null;
    final selectedDeparturePoint = json['selectedDeparturePoint'] != null
        ? Point._fromJson(json['selectedDeparturePoint'])
        : null;
    return PedestrianWayPoint._(
      Point._fromJson(json['position']),
      selectedArrivalPoint,
      selectedDeparturePoint,
    );
  }

  @override
  List<Object?> get props => [position, selectedArrivalPoint, selectedDeparturePoint];

  @override
  bool? get stringify => true;
}
