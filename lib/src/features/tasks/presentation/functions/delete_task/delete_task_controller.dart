import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';

class DeleteTaskController extends StateNotifier<AsyncValue<void>> {
  final TasksService tasksService;

  DeleteTaskController({
    required this.tasksService,
  }) : super(const AsyncData(null));

  Future<void> deleteTask(String taskId) async {
    state = const AsyncValue.loading();
    try {
      final value = await AsyncValue.guard(
        () => tasksService.deleteTask(taskId),
      );
      if (mounted) {
        state = value;
      }
    } catch (e, s) {
      state = AsyncError(e, s);
    }
  }
}

final deleteTaskControllerProvider =
    StateNotifierProvider.autoDispose<DeleteTaskController, AsyncValue<void>>(
        (ref) {
  return DeleteTaskController(tasksService: ref.watch(tasksServiceProvider));
});
