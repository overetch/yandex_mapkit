part of yandex_mapkit;

class Annotation {
  final String? toponym;
  final Action action;
  final String descriptionText;

  Annotation._(this.toponym, this.action, this.descriptionText);

  factory Annotation._fromJson(Map<dynamic, dynamic> json) {
    return Annotation._(
      json['toponym'],
      Action.values[json['action']],
      json['descriptionText'],
    );
  }
}
