import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

class SembastTasksRepository implements LocalTasksRepository {
  final Database db;
  SembastTasksRepository(this.db);

  final store = StoreRef<String, Map<String, dynamic>>.main();

  static Future<Database> createDatabase(String filename) async {
    if (!kIsWeb) {
      final appDocDir = await getApplicationDocumentsDirectory();
      return databaseFactoryIo.openDatabase('${appDocDir.path}/$filename');
    } else {
      return databaseFactoryWeb.openDatabase(filename);
    }
  }

  static Future<SembastTasksRepository> makeDefault() async {
    return SembastTasksRepository(await createDatabase('tasks.db'));
  }

  static const tasksKey = 'tasks';

  @override
  Future<String> insertTask(Task task) => store.add(db, task.toJson());

  @override
  Future<void> starTask(Task task) =>
      store.record(task.id!).update(db, task.toJson());

  @override
  Future<void> removeStarFromTask(Task task) =>
      store.record(task.id!).update(db, task.toJson());

  @override
  Future<void> completeTask(Task task) =>
      store.record(task.id!).update(db, task.toJson());

  @override
  Future<void> uncompleteTask(Task task) =>
      store.record(task.id!).update(db, task.toJson());

  @override
  Future<void> updateTask(Task task) =>
      store.record(task.id!).update(db, task.toJson());

  @override
  Future deleteTask(String taskId) => store.record(taskId).delete(db);

  @override
  Stream<List<Task>> watchAllTasksStream() => store.query().onSnapshots(db).map(
        (snapshot) => snapshot
            .map((task) => Task.fromJson(task.value).copyWith(id: task.key))
            .toList(growable: false),
      );

  @override
  Stream<List<Task>> watchStarredTasksStream() =>
      store.query().onSnapshots(db).map(
            (snapshot) => snapshot
                .map((task) => Task.fromJson(task.value).copyWith(id: task.key))
                .where((tsk) => tsk.isStarred == true)
                .toList(growable: false),
          );

  @override
  Stream<List<Task>> watchCompletedTasksStream() =>
      store.query().onSnapshots(db).map(
            (snapshot) => snapshot
                .map((task) => Task.fromJson(task.value).copyWith(id: task.key))
                .where((tsk) => tsk.isCompleted == true)
                .toList(growable: false),
          );
}
