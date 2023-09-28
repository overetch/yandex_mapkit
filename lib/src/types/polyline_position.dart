part of yandex_mapkit;

/// The position on a polyline.
class PolylinePosition extends Equatable {
  /// Zero-based index of the polyline segment
  final int segmentIndex;

  /// Position in the specified segment
  final double segmentPosition;

  const PolylinePosition._(this.segmentIndex, this.segmentPosition);

  factory PolylinePosition._fromJson(Map<dynamic, dynamic> json) {
    return PolylinePosition._(
      json['segmentIndex'],
      json['segmentPosition'],
    );
  }

  @override
  List<Object?> get props => [segmentIndex, segmentPosition];

  @override
  bool? get stringify => true;
}
