part of yandex_mapkit;

/// Information about pedestrian route metadata.
class PedestrianRouteMetadata extends Equatable {
  /// Route "weight".
  final PedestrianWeight weight;

  const PedestrianRouteMetadata._(this.weight);

  factory PedestrianRouteMetadata._fromJson(Map<dynamic, dynamic> json) {
    return PedestrianRouteMetadata._(PedestrianWeight._fromJson(json['weight']));
  }

  @override
  List<Object> get props => <Object>[weight];

  @override
  bool get stringify => true;
}
