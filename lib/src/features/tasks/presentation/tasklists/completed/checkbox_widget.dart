import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/completed/complete_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/utils/show_snackbar.dart';

/// A widget that shows an [Icon] on next to the task name
/// Used to add a task to completed list.
class CheckboxWidget extends StatelessWidget {
  final Task task;
  const CheckboxWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final state = ref.watch(completeControllerProvider);
        // debugPrint(state.toString());
        var isCompleted = ref.watch(isCompletedProvider(task.id!));

        return SizedBox(
          child: state.isLoading
              ? const CircularProgressIndicator()
              : Checkbox(
                  value: isCompleted,
                  onChanged: (_) {
                    if (!isCompleted && !state.isLoading) {
                      ref.read(completeControllerProvider.notifier).complete(
                            task.copyWith(isCompleted: true),
                          );

                      !state.hasError && !state.isLoading
                          ? showSnackBar(context, 'Added to Completed list')
                          : null;
                    }
                    if (isCompleted && !state.isLoading) {
                      ref.read(completeControllerProvider.notifier).uncomplete(
                            task.copyWith(isCompleted: false),
                          );

                      !state.hasError && !state.isLoading
                          ? showSnackBar(context, 'Removed from Completed list')
                          : null;
                    }
                  }),
        );
      },
    );
  }
}
