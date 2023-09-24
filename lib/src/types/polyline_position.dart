part of yandex_mapkit;

class PolylinePosition {
  final int segmentIndex;
  final double segmentPosition;

  PolylinePosition._(this.segmentIndex, this.segmentPosition);

  factory PolylinePosition._fromJson(Map<dynamic, dynamic> json) {
    return PolylinePosition._(
      json['segmentIndex'],
      json['segmentPosition'],
    );
  }



}