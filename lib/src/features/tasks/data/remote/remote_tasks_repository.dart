import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/fake_remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

abstract class RemoteTasksRepository {
  Future completeTask(String uid, Task task);

  Future uncompleteTask(String uid, Task task);

  Future deleteTask(String uid, String taskId);

  Future insertTask(String uid, Task task);

  Future starTask(String uid, Task task);

  Future removeStarFromTask(String uid, Task task);

  Future updateTask(String uid, Task task);

  Future<List<Task>> fetchTasks(
    String uid,
  );

  Stream<List<Task>> watchTasks(
    String uid,
  );

  Stream<List<Task>> watchStarred(
    String uid,
  );

  Stream<List<Task>> watchCompleted(
    String uid,
  );

  Future<void> setTasks(
    String uid,
    List<Task> updatedRemoteTasks,
  );
}

final remoteTasksRepositoryProvider = Provider<RemoteTasksRepository>(
  (ref) {
    // TODO: replace with "real" remote cart repository
    return FakeRemoteTasksRepository(addDelay: false);
  },
);
