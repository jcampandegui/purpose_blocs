import 'package:equatable/equatable.dart';

class UserPreferences extends Equatable {
  final int id;
  final bool blockAddVibration;

  UserPreferences(this.blockAddVibration, {int id}) :
        this.id = id ?? null;

  UserPreferences copyWith({bool blockAddVibration, String id}) {
    return UserPreferences(
      blockAddVibration ?? this.blockAddVibration,
      id: id ?? this.id
    );
  }

  @override
  List<Object> get props => [blockAddVibration, id];

  @override
  String toString() {
    return 'UserPreferences { id: $id, blockAddVibration: $blockAddVibration }';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'blockAddVibration': this.blockAddVibration
    };
  }

  factory UserPreferences.fromMap(int id, Map<String, dynamic> map) {
    return UserPreferences(
      map['blockAddVibration'],
      id: id,
    );
  }

  /*Purpose addStreak(DateTime date) {
    Map<String, bool> updatedStreak = new Map.from(this.streak);
    updatedStreak[_dateToStreakKey(date)] = true;
    return this.copyWith(streak: updatedStreak);
  }*/
}