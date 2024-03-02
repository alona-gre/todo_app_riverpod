import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class CompleteController extends StateNotifier<AsyncValue<bool>> {
  final TasksService tasksService;

  CompleteController({
    required this.tasksService,
  }) : super(const AsyncData(false));

  Future<void> complete(Task task) async {
    state = const AsyncLoading<bool>();
    final value = await AsyncValue.guard(
      () => tasksService.completeTask(task),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(true);
    }
  }

  Future<void> uncomplete(Task task) async {
    state = const AsyncLoading<bool>();
    final value = await AsyncValue.guard(
      () => tasksService.uncompleteTask(task),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(false);
    }
  }
}

final completeControllerProvider =
    StateNotifierProvider<CompleteController, AsyncValue<bool>>((ref) {
  return CompleteController(tasksService: ref.watch(tasksServiceProvider));
});
