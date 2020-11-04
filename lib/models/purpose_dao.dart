
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

  Future<List<Purpose>> getForSelectedDay(DateTime date) async {
    var laterDate = new DateTime(date.year, date.month, date.day, 23, 59, 59);
    final finder = Finder(filter: Filter.and([
      Filter.lessThanOrEquals('creationDate', laterDate.millisecondsSinceEpoch),
        Filter.equals('repeatDays.${date.weekday}', true)
    ]));
    final snapshots = await _purposeStore.find(await _db, finder: finder);
    return snapshots.map((snapshot) {
      return Purpose.fromMap(snapshot.key, snapshot.value);
    }).toList();
  }

  Future<int> markBroken() async {
    try {
      DateTime now = DateTime.now();
      DateTime startOfToday = new DateTime(now.year, now.month, now.day, 0, 0, 1);
      DateTime yesterday = now.subtract(Duration(days: 1));
      final finder = Finder(filter: Filter.and([
        Filter.lessThanOrEquals('creationDate', startOfToday.millisecondsSinceEpoch),
        Filter.equals('repeatDays.${yesterday.weekday}', true),
        Filter.equals('streak.${_dateToStreakKey(yesterday)}', true)
      ]));
      final snapshots = await _purposeStore.find(await _db, finder: finder);
      List<Purpose> toUpdate = snapshots.map((snapshot) {
        return Purpose.fromMap(snapshot.key, snapshot.value);
      }).toList();
      List<Future> updates = [];
      toUpdate.forEach((element) {
        updates.add(update(element.copyWith(broken: true)));
      });
      await Future.wait(updates);
      return 0;
    } catch(e) {
      print(e);
      return -1;
    }
  }

  String _dateToStreakKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}