
import 'package:purpose_blocs/database/app_database.dart';
import 'package:purpose_blocs/models/purpose.dart';
import 'package:sembast/sembast.dart';

class PurposeDao {

  static const String PURPOSE_STORE_NAME = 'purposes';

  final _purposeStore = intMapStoreFactory.store(PURPOSE_STORE_NAME);

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(Purpose purpose) async {
    await _purposeStore.add(await _db, purpose.toMap());
  }

  Future update(Purpose purpose) async {
    final finder = Finder(filter: Filter.byKey(purpose.id));
    await _purposeStore.update(
        await _db,
        purpose.toMap(),
        finder: finder
    );
  }

  Future delete(Purpose purpose) async {
    final finder = Finder(filter: Filter.byKey(purpose.id));
    await _purposeStore.delete(
        await _db,
        finder: finder
    );
  }

  Future<List<Purpose>> getAll() async {
    final snapshots = await _purposeStore.find(await _db);
    return snapshots.map((snapshot) {
      return Purpose.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  Future<List<Purpose>> getAllSortedByName() async {
    final finder = Finder(sortOrders: [SortOrder('name')]);
    final snapshots = await _purposeStore.find(await _db, finder: finder);
    return snapshots.map((snapshot) {
      return Purpose.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  Future<List<Purpose>> getForSelectedDay(int weekDay) async {
    final finder = Finder(filter: Filter.equals('repeatDays.$weekDay', true));
    final snapshots = await _purposeStore.find(await _db, finder: finder);
    return snapshots.map((snapshot) {
      return Purpose.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }
}