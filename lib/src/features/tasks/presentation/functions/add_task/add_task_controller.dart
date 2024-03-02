import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:uuid/uuid.dart';

class AddTaskController extends StateNotifier<AsyncValue<void>> {
  final TasksService tasksService;

  AddTaskController({
    required this.tasksService,
  }) : super(const AsyncData(null));

  Future<void> addTask(Task task) async {
    state = const AsyncLoading<void>();

    final newTask = Task(
      id: task.id ?? const Uuid().v4().toString(),
      title: task.title,
      notes: task.notes,
      isStarred: task.isStarred,
    );

    final value = await AsyncValue.guard(
      () => tasksService.insertTask(newTask),
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

final addTaskControllerProvider =
    StateNotifierProvider.autoDispose<AddTaskController, AsyncValue<void>>(
        (ref) {
  return AddTaskController(tasksService: ref.watch(tasksServiceProvider));
});
