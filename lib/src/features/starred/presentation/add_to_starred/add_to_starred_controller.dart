import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/starred/application/starred_service.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';

class AddToStarredController extends StateNotifier<AsyncValue<bool>> {
  final StarredService starredService;

  AddToStarredController({
    required this.starredService,
  }) : super(const AsyncData(false));

  Future<void> addProductToStarred(StarredItem starredItem) async {
    state = const AsyncLoading<bool>().copyWithPrevious(state);
    final value = await AsyncValue.guard(
      () => starredService.setStarredProduct(starredItem),
    );
    if (value.hasError) {
      state = AsyncError(value.error!, StackTrace.current);
    } else {
      state = const AsyncData(true);
    }
  }

  Future<void> removeProductFromStarred(StarredItem starredItem) async {
    state = const AsyncLoading<bool>().copyWithPrevious(state);
    final value = await AsyncValue.guard(
      () => starredService.removeStarredProduct(starredItem),
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
  return AddToStarredController(
      starredService: ref.watch(starredServiceProvider));
});
