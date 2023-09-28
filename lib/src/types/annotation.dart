part of yandex_mapkit;

class Annotation extends Equatable {
  final String? toponym;
  final Action action;
  final String descriptionText;

  const Annotation._(this.toponym, this.action, this.descriptionText);

  factory Annotation._fromJson(Map<dynamic, dynamic> json) {
    return Annotation._(
      json['toponym'],
      Action.values[json['action']],
      json['descriptionText'],
    );
  }

  @override
  List<Object?> get props => [toponym, action, descriptionText];

  @override
  bool? get stringify => true;
}
