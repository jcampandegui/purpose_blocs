import 'package:equatable/equatable.dart';

class Purpose extends Equatable {
  final String id;
  final String name;
  final int streak;

  Purpose(this.name, {this.streak = 0, String id}) :
    this.id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  Purpose copyWith({String id, String name, int streak}) {
    return Purpose(
      name ?? this.name,
      streak: streak ?? this.streak,
      id: id ?? this.id
    );
  }

  @override
  List<Object> get props => [id, name, streak];

  @override
  String toString() {
    return 'Purpose { name: $name, streak: $streak, id: $id }';
  }

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'name': this.name,
      'streak': this.streak
    };
  }

  factory Purpose.fromMap(Map<String, dynamic> map) {
    return Purpose(map['name'], streak: map['streak'], id: map['id']);
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