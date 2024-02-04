import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/added/application/added_service.dart';
import 'package:riverpod_todo_app/src/features/added/domain/addedItem.dart';

class AddTaskController extends StateNotifier<AsyncValue<void>> {
  final AddedService addedService;

  AddTaskController({
    required this.addedService,
  }) : super(const AsyncData(null));

  Future<void> addTask(AddedItem addedItem) async {
    state = const AsyncLoading<void>();
    final value = await AsyncValue.guard(
      () => addedService.setAddedProduct(addedItem),
    );

    if (mounted) {
      state = value;
    }
    // if (value.hasError) {
    //   state = AsyncError(value.error!, StackTrace.current);
    // } else {
    //   state = const AsyncData(Task());
    // }
  }

  // Future<void> removeProductFromStarred(AddedItem addedItem) async {
  //   state = const AsyncLoading<bool>().copyWithPrevious(state);
  //   final value = await AsyncValue.guard(
  //     () => addedService.removeAddedProduct(addedItem),
  //   );
  //   if (value.hasError) {
  //     state = AsyncError(value.error!, StackTrace.current);
  //   } else {
  //     state = const AsyncData(false);
  //   }
  // }
}

final addTaskControllerProvider =
    StateNotifierProvider<AddTaskController, AsyncValue<void>>((ref) {
  return AddTaskController(addedService: ref.watch(addedServiceProvider));
});
