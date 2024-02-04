import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_todo_app/src/features/added/data/local/local_added_repository.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastAddedRepository implements LocalAddedRepository {
  final Database db;
  SembastAddedRepository(this.db);

  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastAddedRepository> makeDefault() async {
    return SembastAddedRepository(await createDatabase('added.db'));
  }

  static const addedTasksKey = 'addedTasks';

  @override
  Future<Added> fetchAdded() async {
    final addedJson = await store.record(addedTasksKey).get(db) as String?;
    if (addedJson != null) {
      return Added.fromJson(addedJson);
    } else {
      return const Added();
    }
  }

  @override
  Future<void> setAdded(Added added) {
    //throw Exception('');
    return store.record(addedTasksKey).put(db, added.toJson());
  }

  @override
  Stream<Added> watchAdded() {
    final record = store.record(addedTasksKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Added.fromJson(snapshot.value as String);
      } else {
        return const Added();
      }
    });
  }
}
