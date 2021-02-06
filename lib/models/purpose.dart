import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Purpose extends Equatable {
  final int id;
  final String name;
  final int creationDate;
  final Map<String, bool> streak;
  final Map<String, bool> repeatDays; // [ '1', '2', ... '7' ]
  final bool broken;
  final Color color;
  final Color colorDarker;

  Purpose(this.name, {int creationDate, Map<String, bool> streak, int id, Map<String, bool> repeatDays, bool broken, Color color, Color colorDarker}) :
        this.id = id ?? null,
        this.creationDate = creationDate ?? DateTime.now().millisecondsSinceEpoch,
        //this.streak = streak ?? {},
        this.streak = initStreak(streak, creationDate, repeatDays),
        this.repeatDays = repeatDays ?? {'1': true, '2': true, '3': true, '4': true, '5': true, '6': true, '7': true},
        this.broken = broken ?? false,
        this.color = color ?? Color.fromARGB(255, 255, 100, 100),
        this.colorDarker = colorDarker ?? Color.fromARGB(255, 225, 70, 70);

  Purpose copyWith({String id, String name, Map<String, bool> streak, Map<String, bool> repeatDays, bool broken, Color color, Color colorDarker}) {
    return Purpose(
      name ?? this.name,
      creationDate: creationDate ?? this.creationDate,
      streak: streak ?? this.streak,
      repeatDays: repeatDays ?? this.repeatDays,
      broken: broken ?? this.broken,
      color: color ?? this.color,
      colorDarker: colorDarker ?? this.colorDarker,
      id: id ?? this.id,
    );
  }

  @override
  List<Object> get props => [id, name, creationDate, streak, repeatDays, broken, color, colorDarker];

  @override
  String toString() {
    return 'Purpose { name: $name, creationDate: $creationDate, streak: $streak, repeatDays. $repeatDays, broken: $broken, color: $color, colorDarker: $colorDarker, id: $id }';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': this.name,
      'creationDate': this.creationDate,
      'streak': this.streak,
      'repeatDays': this.repeatDays,
      'broken': this.broken,
      'color': [this.color.alpha, this.color.red, this.color.green, this.color.blue],
      'colorDarker': [this.colorDarker.alpha, this.colorDarker.red, this.colorDarker.green, this.colorDarker.blue]
    };
  }

  factory Purpose.fromMap(int id, Map<String, dynamic> map) {
    return Purpose(
        map['name'],
        creationDate: map['creationDate'],
        streak: map['streak'].cast<String, bool>(),
        repeatDays: map['repeatDays'].cast<String, bool>(),
        broken: map['broken'],
        color: Color.fromARGB(map['color'][0], map['color'][1], map['color'][2], map['color'][3]),
        colorDarker: Color.fromARGB(map['colorDarker'][0], map['colorDarker'][1], map['colorDarker'][2], map['colorDarker'][3]),
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

Map<String, bool> initStreak(Map<String, bool> streak, int creationDateMs, Map<String, bool> repeatDays) {
  if(streak == null) { // Initializer called without preset streak
    DateTime creationDate = DateTime.fromMillisecondsSinceEpoch(creationDateMs);
    DateTime today = DateTime.now();
    bool pastFlag = false;
    if(creationDate.year < today.year) pastFlag = true;
    else if(creationDate.year == today.year && creationDate.month < today.month) pastFlag = true;
    else if(creationDate.year == today.year && creationDate.month == today.month && creationDate.day < today.day) pastFlag = true;
    if(pastFlag) {
      // Creation date is in the past ==> Rebuild blocks til today
      DateTime regressingTime = creationDate;
      Map<String, bool> regressingStreak = {};
      while(!(regressingTime.year == today.year && regressingTime.month == today.month && regressingTime.day == today.day)) {
        if(repeatDays[regressingTime.weekday.toString()]) {
          regressingStreak[dateToStreakKey(regressingTime)] = true;
        }
        regressingTime = regressingTime.add(Duration(days: 1));
      }
      return regressingStreak;
    } else {
      return {};
    }
  } else {
    return streak;
  }
}

String dateToStreakKey(DateTime date) {
  return '${date.year}-${date.month}-${date.day}';
}
