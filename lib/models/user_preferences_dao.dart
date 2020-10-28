import 'package:purpose_blocs/database/app_database.dart';
import 'package:purpose_blocs/models/user_preferences.dart';
import 'package:sembast/sembast.dart';

class UserPreferencesDao {

  static const String USER_PREFERENCES_STORE_NAME = 'userPreferences';

  final _userPreferencesStore = intMapStoreFactory.store(USER_PREFERENCES_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(UserPreferences preferences) async {
    await _userPreferencesStore.add(await _db, preferences.toMap());
  }

  Future update(UserPreferences preferences) async {
    final finder = Finder(filter: Filter.byKey(preferences.id));
    await _userPreferencesStore.update(
        await _db,
        preferences.toMap(),
        finder: finder
    );
  }

  Future delete(UserPreferences preferences) async {
    final finder = Finder(filter: Filter.byKey(preferences.id));
    await _userPreferencesStore.delete(
        await _db,
        finder: finder
    );
  }

  Future<UserPreferences> getPreferences() async {
    final snapshots = await _userPreferencesStore.find(await _db);
    return UserPreferences.fromMap(snapshots[0].key, snapshots[0].value);
  }
}