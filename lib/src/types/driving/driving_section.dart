part of yandex_mapkit;

class DrivingSection extends Equatable {
  // metadata
  final DrivingSectionsMetadata metadata;

  // geometry
  final Subpolyline geometry;

  const DrivingSection._(this.metadata, this.geometry);

  factory DrivingSection._fromJson(Map<dynamic, dynamic> json) {
    return DrivingSection._(
      DrivingSectionsMetadata._fromJson(json["metadata"]),
      Subpolyline._fromJson(json["geometry"]),
    );
  }

  @override
  List<Object?> get props => [metadata, geometry];

  @override
  bool? get stringify => true;
}
