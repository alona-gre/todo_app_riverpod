import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/favorite_button.dart';
import 'package:riverpod_todo_app/src/features/starred/presentation/starred/starred_screen_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/application/starred_service.dart';
import 'package:riverpod_todo_app/src/utils/show_snackbar.dart';

/// A widget that shows an [Icon] on top of the product image on the home page,
/// and next to the product title on teh ProductScreen.
/// Used to add a product to starred.
class RemoveFromStarredScreenWidget extends ConsumerWidget {
  final Task task;
  const RemoveFromStarredScreenWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(starredScreenControllerProvider);
    final isStarred = ref.watch(isStarredProvider(task.id!));

    return StarredButton(
      isLoading: state.isLoading,
      isStarred: isStarred,
      onPressed: state.isLoading
          ? null
          : () {
              ref
                  .read(starredScreenControllerProvider.notifier)
                  .removeFromStarredScreenById(task.id!);

              state.copyWithPrevious(state).hasError
                  ? null
                  : showSnackBar(context, 'Removed from Starred');
            },
    );
  }
}
