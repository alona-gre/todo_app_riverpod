import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_todo_app/src/features/starred/data/local/local_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastStarredRepository implements LocalStarredRepository {
  final Database db;
  SembastStarredRepository(this.db);

  final store = StoreRef.main();

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastStarredRepository> makeDefault() async {
    return SembastStarredRepository(await createDatabase('starred.db'));
  }

  static const starredTasksKey = 'starredTasks';

  @override
  Future<Starred> fetchStarred() async {
    final starredJson = await store.record(starredTasksKey).get(db) as String?;
    if (starredJson != null) {
      return Starred.fromJson(starredJson);
    } else {
      return const Starred();
    }
  }

  @override
  Future<void> setStarred(Starred starred) {
    //throw Exception('');
    return store.record(starredTasksKey).put(db, starred.toJson());
  }

  @override
  Stream<Starred> watchStarred() {
    final record = store.record(starredTasksKey);
    return record.onSnapshot(db).map((snapshot) {
      if (snapshot != null) {
        return Starred.fromJson(snapshot.value as String);
      } else {
        return const Starred();
      }
    });
  }
}
