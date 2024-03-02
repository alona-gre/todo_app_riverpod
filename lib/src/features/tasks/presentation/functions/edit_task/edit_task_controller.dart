import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class EditTaskController extends StateNotifier<AsyncValue<void>> {
  final TasksService tasksService;

  EditTaskController({
    required this.tasksService,
  }) : super(const AsyncData(null));

  Future<void> updateTask(Task task) async {
    state = const AsyncLoading<void>();

    final updatedTask = task.copyWith(title: task.title, notes: task.notes);

    final value = await AsyncValue.guard(
      () => tasksService.updateTask(updatedTask),
    );

    if (mounted) {
      state = value;
    }
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData<void>(null);
    }
  }
}

final editTaskControllerProvider =
    StateNotifierProvider.autoDispose<EditTaskController, AsyncValue<void>>(
        (ref) {
  return EditTaskController(tasksService: ref.watch(tasksServiceProvider));
});
