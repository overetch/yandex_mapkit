part of yandex_mapkit;

/// Contains information about a route constructed by the mass transit router.
/// A route consists of multiple sections
/// Each section has a corresponding annotation that describes the action at the beginning of the section.
class PedestrianRoute extends Equatable {
  /// Route geometry.
  final List<Point> geometry;

  /// The route metadata.
  final PedestrianRouteMetadata metadata;

  /// Vector of sections of the route
  final List<PedestrianSection> sections;

  /// List of route waypoints
  final List<PedestrianWayPoint> waypoints;

  const PedestrianRoute._(this.geometry, this.metadata, this.sections, this.waypoints);

  factory PedestrianRoute._fromJson(Map<dynamic, dynamic> json) {
    return PedestrianRoute._(
      json['geometry']
          .map<Point>((dynamic resultPoint) => Point._fromJson(resultPoint))
          .toList(),
      PedestrianRouteMetadata._fromJson(json['metadata']),
      List<PedestrianSection>.from(
          json['sections'].map((x) => PedestrianSection._fromJson(x))),
      List<PedestrianWayPoint>.from(
          json['waypoints'].map((x) => PedestrianWayPoint._fromJson(x))),
    );
  }

  @override
  List<Object> get props => [geometry, metadata, sections, waypoints];

  @override
  bool get stringify => true;
}
