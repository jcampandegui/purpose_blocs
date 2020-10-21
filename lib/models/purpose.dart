import 'package:equatable/equatable.dart';

// TODO: id should be set by db not here
class Purpose extends Equatable {
  final int id;
  final String name;
  final int creationDate;
  final Map<String, bool> streak;
  final Map<String, bool> repeatDays; // [ monday, tuesday, ... sunday ]

  Purpose(this.name, {int creationDate, Map<String, bool> streak, int id, Map<String, bool> repeatDays}) :
        this.id = id ?? null,
        this.creationDate = creationDate ?? DateTime.now().millisecondsSinceEpoch,
        this.streak = streak ?? {},
        this.repeatDays = repeatDays ?? {'1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true};

  Purpose copyWith({String id, String name, Map<String, bool> streak, Map<String, bool> repeatDays}) {
    return Purpose(
      name ?? this.name,
      creationDate: creationDate ?? this.creationDate,
      streak: streak ?? this.streak,
      repeatDays: repeatDays ?? this.repeatDays,
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id, name, creationDate, streak, repeatDays];

  @override
  String toString() {
    return 'Purpose { name: $name, creationDate: $creationDate, streak: $streak, repeatDays. $repeatDays, id: $id }';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'creationDate': this.creationDate,
      'streak': this.streak,
      'repeatDays': this.repeatDays
    };
  }

  factory Purpose.fromMap(int id, Map<String, dynamic> map) {
    return Purpose(
        map['name'],
        creationDate: map['creationDate'],
        streak: map['streak'].cast<String, bool>(),
        repeatDays: map['repeatDays'].cast<String, bool>(),
        id: id
    );
  }

  int getStreakNumber() {
    int streak = 0;
    this.streak.forEach((key, value) => streak += value ? 1 : 0);
    return streak;
  }

  bool existedBefore(DateTime date) {
    int toMillis = date.millisecondsSinceEpoch;
    return this.creationDate >= toMillis;
  }

  bool isCompletedForDate(DateTime date) {
    String converted = _dateToStreakKey(date);
    return this.streak[converted] != null && this.streak[converted];
  }

  String _dateToStreakKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  Purpose addStreak(DateTime date) {
    Map<String, bool> updatedStreak = new Map.from(this.streak);
    updatedStreak[_dateToStreakKey(date)] = true;
    return this.copyWith(streak: updatedStreak);
  }

  Purpose removeStreak(DateTime date) {
    Map<String, bool> updatedStreak = new Map.from(this.streak);
    updatedStreak[_dateToStreakKey(date)] = false;
    return this.copyWith(streak: updatedStreak);
  }

  /*PurposeEntity toEntity() {
    return PurposeEntity(id, name, streak);
  }

  static Purpose fromEntity(PurposeEntity entity) {
    return Purpose(
      entity.name,
      streak: entity.streak ?? 0,
      id: entity.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
    );
  }*/
}