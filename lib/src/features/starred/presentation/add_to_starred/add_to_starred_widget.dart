import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/favorite_button.dart';
import 'package:riverpod_todo_app/src/features/starred/presentation/add_to_starred/add_to_starred_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/application/starred_service.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';

/// A widget that shows an [Icon] on next to the task name
/// Used to add a task to starred list.
class AddToStarredWidget extends ConsumerWidget {
  final Task task;
  const AddToStarredWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addToStarredControllerProvider);
    // debugPrint(state.toString());
    final isStarred = ref.watch(isStarredProvider(task.id!));

    return StarredButton(
      isLoading: state.isLoading,
      isStarred: isStarred,
      onPressed: !isStarred && !state.isLoading
          ? () {
              ref
                  .read(addToStarredControllerProvider.notifier)
                  .addProductToStarred(
                    StarredItem(
                      taskId: task.id!,
                    ),
                  );
              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Added to Starred')
                  : null;
            }
          : () {
              ref
                  .read(addToStarredControllerProvider.notifier)
                  .removeProductFromStarred(
                    StarredItem(
                      taskId: task.id!,
                    ),
                  );

              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Removed from Starred')
                  : null;
            },
    );
  }

  showSnackBar(BuildContext context, String s) {}
}
