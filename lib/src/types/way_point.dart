part of yandex_mapkit;

class WayPoint {
  final int segmentIndex;
  final double segmentPosition;

  WayPoint._(this.segmentIndex, this.segmentPosition);

  factory WayPoint._fromJson(Map<dynamic, dynamic> json) {
    return WayPoint._(
      json["segmentIndex"],
      json["segmentPosition"],
    );
  }
}
