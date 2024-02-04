import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/added/application/added_service.dart';
import 'package:riverpod_todo_app/src/features/added/domain/addedItem.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class AddedScreenController extends StateNotifier<AsyncValue<void>> {
  final AddedService addedService;

  AddedScreenController({required this.addedService})
      : super(const AsyncData(null));

  Future<void> addToAddedScreen(Task task) async {
    state = const AsyncLoading<Task>();
    final value = await AsyncValue.guard(
        () => addedService.setAddedProduct(AddedItem(taskId: task.id!)));

    if (mounted) {
      state = value;
    }
    // if (value.hasError) {
    //   state = AsyncError(value.error!, StackTrace.current);
    // } else {
    //   state = const AsyncData(null);
    // }
  }

  // Future<void> removeFromAddedScreenById(TaskID taskId) async {
  //   state = const AsyncLoading<bool>();
  //   final value = await AsyncValue.guard(
  //       () => addedService.removeAddedProductById(taskId));
  //   if (value.hasError) {
  //     state = AsyncError(value.error!, StackTrace.current);
  //   } else {
  //     state = const AsyncData(null);
  //   }
  // }
}

///TODO: add auto-dispose?
final addedTasksScreenControllerProvider =
    StateNotifierProvider.autoDispose<AddedScreenController, AsyncValue<void>>(
        (ref) {
  return AddedScreenController(addedService: ref.watch(addedServiceProvider));
});
