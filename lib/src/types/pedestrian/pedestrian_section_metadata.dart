part of yandex_mapkit;

/// General information about a section of a route.
class PedestrianSectionMetadata extends Equatable {
  /// Contains the route traveling time, distance of the walking part, and the number of transfers
  final PedestrianWeight weight;

  /// Arrival and departure time estimations
  final PedestrianTravelEstimation? estimation;

  /// Part of the route polyline for the route leg
  final int legIndex;

  const PedestrianSectionMetadata._(this.weight, this.estimation, this.legIndex);

  factory PedestrianSectionMetadata._fromJson(Map<dynamic, dynamic> json) {
    final estimation = json['estimation'] != null
        ? PedestrianTravelEstimation._fromJson(json['estimation'])
        : null;
    return PedestrianSectionMetadata._(
      PedestrianWeight._fromJson(json['weight']),
      estimation,
      int.tryParse(json['legIndex'].toString()) ?? 0,
    );
  }

  @override
  List<Object?> get props => [weight, estimation, legIndex];

  @override
  bool get stringify => true;
}
