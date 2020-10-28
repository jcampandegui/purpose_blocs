import 'package:equatable/equatable.dart';

class UserPreferences extends Equatable {
  final int id;
  final bool blockAddVibration;

  UserPreferences(this.id, this.blockAddVibration);

  UserPreferences copyWith({String id, bool blockAddVibration}) {
    return UserPreferences(
      id ?? this.id,
      blockAddVibration ?? this.blockAddVibration
    );
  }

  @override
  List<Object> get props => [id, blockAddVibration];

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
        id,
        map['blockAddVibration']
    );
  }

  /*Purpose addStreak(DateTime date) {
    Map<String, bool> updatedStreak = new Map.from(this.streak);
    updatedStreak[_dateToStreakKey(date)] = true;
    return this.copyWith(streak: updatedStreak);
  }*/
}