import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

abstract class RemoteTasksRepository {
  Future completeTask(String uid, Task task);

  Future uncompleteTask(String uid, Task task);

  Future deleteTask(String uid, String taskId);

  Future insertTask(String uid, Task task);

  Future starTask(String uid, Task task);

  Future removeStarFromTask(String uid, Task task);

  Future updateTask(String uid, Task task);

  Stream<List<Task>> watchAllTasksStream(
    String uid,
  );

  Stream<List<Task>> watchStarredTasksStream(
    String uid,
  );

  Stream<List<Task>> watchCompletedTasksStream(
    String uid,
  );
}

final remoteTasksRepositoryProvider =
    Provider.autoDispose<RemoteTasksRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);
