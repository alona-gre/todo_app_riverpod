import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/application/starred_service.dart';

class StarredScreenController extends StateNotifier<AsyncValue<void>> {
  final StarredService starredService;

  StarredScreenController({required this.starredService})
      : super(const AsyncData(null));

  Future<void> removeFromStarredScreenById(TaskID taskId) async {
    state = const AsyncLoading<bool>();
    final value = await AsyncValue.guard(
        () => starredService.removeStarredProductById(taskId));
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(null);
    }
  }
}

final starredScreenControllerProvider = StateNotifierProvider.autoDispose<
    StarredScreenController, AsyncValue<void>>((ref) {
  return StarredScreenController(
      starredService: ref.watch(starredServiceProvider));
});
