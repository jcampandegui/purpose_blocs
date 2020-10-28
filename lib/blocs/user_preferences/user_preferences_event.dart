import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/user_preferences.dart';

abstract class UserPreferencesEvent extends Equatable {
  const UserPreferencesEvent();

  @override
  List<Object> get props => [];
}

class UpdatePreferences extends UserPreferencesEvent {
  final UserPreferences preferences;

  const UpdatePreferences(this.preferences);

  @override
  List<Object> get props => [preferences];

  @override
  String toString() => 'UpdatePreferences { preferences: $preferences }';
}