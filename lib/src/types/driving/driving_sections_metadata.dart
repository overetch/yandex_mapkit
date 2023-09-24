part of yandex_mapkit;

class DrivingSectionsMetadata {
  //annotation
  final Annotation annotation;

  //weight
  final DrivingWeight weight;

  DrivingSectionsMetadata._(this.annotation, this.weight);

  factory DrivingSectionsMetadata._fromJson(Map<dynamic, dynamic> json) {
    return DrivingSectionsMetadata._(
      Annotation._fromJson(json["annotation"]),
      DrivingWeight._fromJson(json["weight"]),
    );
  }
}
