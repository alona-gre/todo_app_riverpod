import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

final tasksSearchQueryStateProvider = StateProvider.autoDispose<String>((ref) {
  return '';
});

final tasksSearchResultsProvider =
    StreamProvider.autoDispose<List<Task>>((ref) {
  final searchQuery = ref.watch(tasksSearchQueryStateProvider);
  return ref.watch(searchTasksProvider(searchQuery).stream);
});
