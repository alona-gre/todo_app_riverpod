import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/starred_button.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/starred/add_to_starred_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/utils/show_snackbar.dart';

/// A widget that shows an [Icon] on next to the task name
/// Used to add a task to starred list.
class StarWidget extends ConsumerWidget {
  final Task task;
  const StarWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addToStarredControllerProvider);
    // debugPrint(state.toString());
    final isStarred = ref.read(isStarredProvider(task.id!));

    return StarredButton(
      isLoading: state.isLoading,
      isStarred: isStarred,
      onPressed: !isStarred && !state.isLoading
          ? () {
              ref.read(addToStarredControllerProvider.notifier).addToStarred(
                    task.copyWith(isStarred: true),
                  );

              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Added to Starred')
                  : null;
            }
          : () {
              ref
                  .read(addToStarredControllerProvider.notifier)
                  .removeFromStarred(
                    task.copyWith(isStarred: false),
                  );

              !state.hasError && !state.isLoading
                  ? showSnackBar(context, 'Removed from Starred')
                  : null;
            },
    );
  }
}
