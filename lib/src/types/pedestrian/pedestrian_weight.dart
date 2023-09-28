part of yandex_mapkit;

/// Numeric characteristics of a route or a route section.
class PedestrianWeight extends Equatable {
  /// Travel time for a route or a route section
  final LocalizedValue time;

  /// Distance of the pedestrian part of the route or a route section
  final LocalizedValue walkingDistance;

  /// The number of transfers for a route or a route section
  final int transfersCount;

  const PedestrianWeight._(this.time, this.walkingDistance, this.transfersCount);

  factory PedestrianWeight._fromJson(Map<dynamic, dynamic> json) {
    return PedestrianWeight._(
      LocalizedValue._fromJson(json['time']),
      LocalizedValue._fromJson(json['distance']),
      int.tryParse(json['transfersCount'].toString()) ?? 0,
    );
  }

  @override
  List<Object> get props => [time, walkingDistance, transfersCount];

  @override
  bool get stringify => true;
}
