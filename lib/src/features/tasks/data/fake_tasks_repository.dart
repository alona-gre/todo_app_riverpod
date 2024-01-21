import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/constants/test_tasks.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';

class FakeTasksRepository {
  final bool hasDelay;
  final List<Task> _tasks = kTestTasks;

  FakeTasksRepository({this.hasDelay = true});

  List<Task> getTasksList() {
    return _tasks;
  }

  Task? getTask(String id) {
    return _getTask(_tasks, id);
  }

  Future<List<Task>> fetchTasks() async {
    await delay(hasDelay);
    // throw Exception('Something is wrong');
    return Future.value(_tasks);
  }

  Stream<List<Task>> watchTasksList() async* {
    await delay(hasDelay);
    yield _tasks;
    // return Stream.value(_tasks);
  }

  Stream<Task?> watchTask(String id) {
    return watchTasksList().map(
      (tasks) => _getTask(tasks, id),
    );
  }

  static Task? _getTask(List<Task> tasks, String id) {
    try {
      return tasks.firstWhere((tsk) => tsk.id == id);
    } catch (e) {
      return null;
    }
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
