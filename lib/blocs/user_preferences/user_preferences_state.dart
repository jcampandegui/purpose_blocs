import 'package:equatable/equatable.dart';
import 'package:purpose_blocs/models/user_preferences.dart';

abstract class UserPreferencesState extends Equatable {
  const UserPreferencesState();

  @override
  List<Object> get props => [];
}

class LoadingPreferences extends UserPreferencesState {}

class PreferencesLoaded extends UserPreferencesState {
  final UserPreferences preferences;

  const PreferencesLoaded(this.preferences);

  @override
  List<Object> get props => [preferences];

  @override
  String toString() => 'PreferencesLoaded { preferences: $preferences }';
}