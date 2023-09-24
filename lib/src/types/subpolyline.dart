part of yandex_mapkit;

class Subpolyline {

  final PolylinePosition begin;

  final PolylinePosition end;

  Subpolyline._(this.begin, this.end);

  factory Subpolyline._fromJson(Map<dynamic, dynamic> json) {
    return Subpolyline._(
      PolylinePosition._fromJson(json['begin']),
      PolylinePosition._fromJson(json['end']),
    );
  }


}