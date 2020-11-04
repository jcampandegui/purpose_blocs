import 'package:equatable/equatable.dart';

class Purpose extends Equatable {
  final int id;
  final String name;
  final int creationDate;
  final Map<String, bool> streak;
  final Map<String, bool> repeatDays; // [ monday, tuesday, ... sunday ]
  final bool broken;

  Purpose(this.name, {int creationDate, Map<String, bool> streak, int id, Map<String, bool> repeatDays, bool broken}) :
        this.id = id ?? null,
        this.creationDate = creationDate ?? DateTime.now().millisecondsSinceEpoch,
        this.streak = streak ?? {},
        this.repeatDays = repeatDays ?? {'1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true},
        this.broken = broken ?? false;

  Purpose copyWith({String id, String name, Map<String, bool> streak, Map<String, bool> repeatDays, bool broken}) {
    return Purpose(
      name ?? this.name,
      creationDate: creationDate ?? this.creationDate,
      streak: streak ?? this.streak,
      repeatDays: repeatDays ?? this.repeatDays,
      broken: broken ?? this.broken,
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id, name, creationDate, streak, repeatDays, broken];

  @override
  String toString() {
    return 'Purpose { name: $name, creationDate: $creationDate, streak: $streak, repeatDays. $repeatDays, broken: $broken, id: $id }';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'creationDate': this.creationDate,
      'streak': this.streak,
      'repeatDays': this.repeatDays,
      'broken': this.broken
    };
  }

  factory Purpose.fromMap(int id, Map<String, dynamic> map) {
    return Purpose(
        map['name'],
        creationDate: map['creationDate'],
        streak: map['streak'].cast<String, bool>(),
        repeatDays: map['repeatDays'].cast<String, bool>(),
        broken:  map['broken'],
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

  bool canBeEdited(DateTime date) {
    String requestDate = _dateToStreakKey(date);
    String today = _dateToStreakKey(DateTime.now());
    return requestDate == today;
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