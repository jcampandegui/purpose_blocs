import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:purpose_blocs/blocs/user_preferences/user_preferences_barrel.dart';

class UserPreferencesBloc extends Bloc<UserPreferencesEvent, UserPreferencesState> {

  UserPreferencesBloc() : super(LoadingPreferences());

  @override
  Stream<UserPreferencesState> mapEventToState(UserPreferencesEvent event) async* {
    if (event is UpdatePreferences) {
      yield* _mapUpdatePreferencesToState(event);
    }
  }

  Stream<UserPreferencesState> _mapUpdatePreferencesToState(UserPreferencesEvent event) {

  }
}