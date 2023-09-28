part of yandex_mapkit;

class DrivingSectionsMetadata extends Equatable {
  //annotation
  final Annotation annotation;

  //weight
  final DrivingWeight weight;

  const DrivingSectionsMetadata._(this.annotation, this.weight);

  factory DrivingSectionsMetadata._fromJson(Map<dynamic, dynamic> json) {
    return DrivingSectionsMetadata._(
      Annotation._fromJson(json["annotation"]),
      DrivingWeight._fromJson(json["weight"]),
    );
  }

  @override
  List<Object?> get props => [annotation, weight];

  @override
  bool? get stringify => true;
}
