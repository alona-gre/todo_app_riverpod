import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/constants/test_tasks.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeTasksRepository {
  FakeTasksRepository({this.addDelay = true});
  final bool addDelay;

  /// Preload with the default list of tasks when the app starts
  final _tasks = InMemoryStore<List<Task>>(List.from(kTestTasks));

  List<Task> getTasksList() {
    return _tasks.value;
  }

  Task? getTask(String id) {
    return _getTask(_tasks.value, id);
  }

  Future<List<Task>> fetchTasksList() async {
    return Future.value(_tasks.value);
  }

  Stream<List<Task>> watchTasksList() {
    return _tasks.stream;
  }

  Stream<Task?> watchTask(String id) {
    return watchTasksList().map((tasks) => _getTask(tasks, id));
  }

  // /// Update product or add a new one
  // Future<void> setTask(Task product) async {
  //   await delay(addDelay);
  //   final tasks = _tasks.value;
  //   final index = tasks.indexWhere((p) => p.id == product.id);
  //   if (index == -1) {
  //     // if not found, add as a new product
  //     tasks.add(product);
  //   } else {
  //     // else, overwrite previous product
  //     tasks[index] = product;
  //   }
  //   _tasks.value = tasks;
  // }

  // /// Search for tasks where the title contains the search query
  // Future<List<Task>> searchTasks(String query) async {
  //   assert(
  //     _tasks.value.length <= 100,
  //     'Client-side search should only be performed if the number of tasks is small. '
  //     'Consider doing server-side search for larger datasets.',
  //   );
  //   // Get all tasks
  //   final tasksList = await fetchTasksList();
  //   // Match all tasks where the title contains the query
  //   return tasksList
  //       .where((product) =>
  //           product.title.toLowerCase().contains(query.toLowerCase()))
  //       .toList();
  // }

  static Task? _getTask(List<Task> tasks, String id) {
    try {
      return tasks.firstWhere((product) => product.id == id);
    } catch (e) {
      return null;
    }
  }
}

final tasksRepositoryProvider = Provider<FakeTasksRepository>((ref) {
  // * Set addDelay to false for faster loading
  return FakeTasksRepository(addDelay: false);
});

final tasksListStreamProvider = StreamProvider.autoDispose<List<Task>>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.watchTasksList();
});

final tasksListFutureProvider = FutureProvider.autoDispose<List<Task>>((ref) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.fetchTasksList();
});

final taskProvider =
    StreamProvider.autoDispose.family<Task?, String>((ref, id) {
  final tasksRepository = ref.watch(tasksRepositoryProvider);
  return tasksRepository.watchTask(id);
});

// final tasksListSearchProvider =
//     FutureProvider.autoDispose.family<List<Task>, String>((ref, query) async {
//   final link = ref.keepAlive();
//   // * keep previous search results in memory for 60 seconds
//   final timer = Timer(const Duration(seconds: 60), () {
//     link.close();
//   });
//   ref.onDispose(() => timer.cancel());
//   final tasksRepository = ref.watch(tasksRepositoryProvider);
//   return tasksRepository.searchTasks(query);
// });
