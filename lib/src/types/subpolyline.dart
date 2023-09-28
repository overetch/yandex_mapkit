part of yandex_mapkit;

/// A part of a polyline.
class Subpolyline extends Equatable {
  /// The start of the selected part of the polyline
  final PolylinePosition begin;

  /// The end of the selected part of the polyline
  final PolylinePosition end;

  Subpolyline._(this.begin, this.end);

  factory Subpolyline._fromJson(Map<dynamic, dynamic> json) {
    return Subpolyline._(
      PolylinePosition._fromJson(json['begin']),
      PolylinePosition._fromJson(json['end']),
    );
  }

  @override
  List<Object?> get props => [begin, end];

  @override
  bool? get stringify => true;
}
