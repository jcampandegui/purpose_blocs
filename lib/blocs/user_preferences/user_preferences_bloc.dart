import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:purpose_blocs/blocs/user_preferences/user_preferences_barrel.dart';
import 'package:purpose_blocs/models/user_preferences.dart';
import 'package:purpose_blocs/models/user_preferences_dao.dart';

class UserPreferencesBloc extends Bloc<UserPreferencesEvent, UserPreferencesState> {
  UserPreferencesDao _preferencesDao = UserPreferencesDao();
  
  UserPreferencesBloc() : super(LoadingPreferences());

  @override
  Stream<UserPreferencesState> mapEventToState(UserPreferencesEvent event) async* {
    if (event is UpdatePreferences) {
      yield* _mapUpdatePreferencesToState(event);
    } else if (event is LoadPreferences) {
      yield* _mapLoadPreferencesToState();
    }
  }

  Stream<UserPreferencesState> _mapUpdatePreferencesToState(UpdatePreferences event) async* {
    await _preferencesDao.update(event.preferences);
    yield* _reloadPreferences();
  }

  Stream<UserPreferencesState> _mapLoadPreferencesToState() async* {
    yield* _reloadPreferences();
  }
  
  Stream<UserPreferencesState> _reloadPreferences() async* {
    UserPreferences preferences = await _preferencesDao.getPreferences();
    if(preferences == null) yield* _initializePreferences();
    else yield PreferencesLoaded(preferences);
  }
  
  Stream<UserPreferencesState> _initializePreferences() async* {
    print('creting new preferences');
    await _preferencesDao.insert(new UserPreferences(true));
    yield* _reloadPreferences();
  }
}