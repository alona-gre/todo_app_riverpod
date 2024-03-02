import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class AddToStarredController extends StateNotifier<AsyncValue<bool>> {
  final TasksService tasksService;

  AddToStarredController({
    required this.tasksService,
  }) : super(const AsyncData(false));

  Future<void> addToStarred(Task task) async {
    state = const AsyncLoading<bool>();
    final value = await AsyncValue.guard(
      () => tasksService.starTask(task),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(true);
    }
  }

  Future<void> removeFromStarred(Task task) async {
    state = const AsyncLoading<bool>();
    final value = await AsyncValue.guard(
      () => tasksService.removeStarFromTask(task),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(false);
    }
  }
}

final addToStarredControllerProvider =
    StateNotifierProvider<AddToStarredController, AsyncValue<bool>>((ref) {
  return AddToStarredController(tasksService: ref.watch(tasksServiceProvider));
});
