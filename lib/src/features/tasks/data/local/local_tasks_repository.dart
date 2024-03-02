import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

abstract class LocalTasksRepository {
  Future insertTask(Task task);

  Future starTask(Task task);

  Future removeStarFromTask(Task task);

  Future completeTask(Task task);

  Future uncompleteTask(Task task);

  Future updateTask(Task task);

  Future deleteTask(String taskId);

  Stream<List<Task>> watchAllTasksStream();

  Stream<List<Task>> watchStarredTasksStream();

  Stream<List<Task>> watchCompletedTasksStream();
}

final localTasksRepositoryProvider = Provider.autoDispose<LocalTasksRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);
