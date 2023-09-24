part of yandex_mapkit;

class DrivingSection {
  // metadata
  final DrivingSectionsMetadata metadata;

  // geometry
  final Subpolyline geometry;

  DrivingSection._(this.metadata, this.geometry);

  factory DrivingSection._fromJson(Map<dynamic, dynamic> json) {
    return DrivingSection._(
      DrivingSectionsMetadata._fromJson(json["metadata"]),
      Subpolyline._fromJson(json["geometry"]),
    );
  }

}
