part of yandex_mapkit;

/// Contains information about an individual section of a mass transit [PedestrianRoute].
class PedestrianSection extends Equatable {

  /// General information about a section of a route
  final PedestrianSectionMetadata metadata;

  /// Geometry of the section as a fragment of a [PedestrianRoute] polyline
  final Subpolyline geometry;

  const PedestrianSection._(this.metadata, this.geometry);

  factory PedestrianSection._fromJson(Map<String, dynamic> json) {
    return PedestrianSection._(
      PedestrianSectionMetadata._fromJson(json['metadata']),
      Subpolyline._fromJson(json['geometry']),
    );
  }

  @override
  List<Object?> get props => [metadata, geometry];

  @override
  bool? get stringify => true;
}
