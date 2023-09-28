part of yandex_mapkit;

class WayPoint extends Equatable {
  final int segmentIndex;
  final double segmentPosition;

  const WayPoint._(this.segmentIndex, this.segmentPosition);

  factory WayPoint._fromJson(Map<dynamic, dynamic> json) {
    return WayPoint._(
      json["segmentIndex"],
      json["segmentPosition"],
    );
  }

  @override
  List<Object?> get props => [segmentIndex, segmentPosition];

  @override
  bool? get stringify => true;
}
