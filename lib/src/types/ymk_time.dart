part of yandex_mapkit;

/// Time in I18nTime format.
class YMKTime extends Equatable {
  /// Time value
  final num value;

  /// Time offset to account for time zones
  final int tzOffset;

  /// The description of the timer
  final String text;

  const YMKTime._(this.value, this.tzOffset, this.text);

  factory YMKTime._fromJson(Map<dynamic, dynamic> json) {
    return YMKTime._(
      num.tryParse(json['value']) ?? 0,
      int.tryParse(json['tzOffset']) ?? 0,
      json['text'],
    );
  }

  @override
  List<Object?> get props => [value, tzOffset, text];

  @override
  bool? get stringify => true;
}
