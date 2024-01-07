import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/constants/test_products.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class FakeTasksRepository {
  final List<Task> _tasks = kTestTasks;

  List<Task> getTasksList() {
    return _tasks;
  }

  Task? getTask(String id) {
    return _tasks.firstWhere((tsk) => tsk.id == id);
  }

  Future<List<Task>> fetchTasks() async {
    await Future.delayed(const Duration(seconds: 2));
    // throw Exception('Something is wrong');
    return Future.value(_tasks);
  }

  Stream<List<Task>> watchTasksList() async* {
    await Future.delayed(const Duration(seconds: 2));
    yield _tasks;
    // return Stream.value(_tasks);
  }

  Stream<Task?> watchTask(String id) {
    return watchTasksList().map(
      (tasks) => tasks.firstWhere(
        (tsk) => tsk.id == id,
      ),
    );
  }
}

final tasksRepositoryProvider = Provider<FakeTasksRepository>((ref) {
  return FakeTasksRepository();
});

final tasksListStreamProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.watchTasksList();
});

final tasksListFutureProvider = FutureProvider.autoDispose<List<Task>>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.fetchTasks();
});

final taskProvider =
    StreamProvider.autoDispose.family<Task?, String>((ref, id) {
  final link = ref.keepAlive();
  // * keep previous search results in memory for 60 seconds
  final timer = Timer(const Duration(seconds: 60), () {
    link.close();
  });
  ref.onDispose(() => timer.cancel());
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.watchTask(id);
});
