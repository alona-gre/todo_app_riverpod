import 'package:riverpod_todo_app/src/constants/test_products.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class FakeTasksRepository {
  FakeTasksRepository._();
  static FakeTasksRepository instance = FakeTasksRepository._();

  final List<Task> _tasks = kTestTasks;

  List<Task> getTasksList() {
    return _tasks;
  }

  Task? getTask(String id) {
    return _tasks.firstWhere((tsk) => tsk.id == id);
  }

  Future<List<Task>> fetchTasks() {
    return Future.value(_tasks);
  }

  Stream<List<Task>> watchTasksList() {
    return Stream.value(_tasks);
  }

  Stream<Task?> watchTask(String id) {
    return watchTasksList().map(
      (tasks) => tasks.firstWhere(
        (tsk) => tsk.id == id,
      ),
    );
  }
}
