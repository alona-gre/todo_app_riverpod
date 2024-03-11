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

  Stream<List<Task>> watchTasks();

  Future<List<Task>> fetchTasks();

  Stream<List<Task>> watchStarred();

  Stream<List<Task>> watchCompleted();

  Future<void> setTasks(
    List<Task> updatedCart,
  );

  Stream<List<Task>> searchTasks(String query);
}

final localTasksRepositoryProvider = Provider<LocalTasksRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);
