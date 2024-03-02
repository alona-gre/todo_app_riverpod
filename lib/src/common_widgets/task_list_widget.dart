import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/delete_task/delete_task_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/task_tile.dart';
import 'package:riverpod_todo_app/src/utils/show_snackbar.dart';

class TaskListWidget extends ConsumerWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
  });

  final List<Task> tasks;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) => Dismissible(
          // Each Dismissible must contain a Key. Keys allow Flutter to
          // uniquely identify widgets.

          key: ValueKey('${tasks[index].id} '),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) {
              await ref
                  .read(deleteTaskControllerProvider.notifier)
                  .deleteTask(tasks[index].id!)
                  .then(
                    (value) => showSnackBar(
                        context, '${tasks[index].title} has been deleted'),
                  );
              return true;
            } else {
              showNotImplementedAlertDialog(context: context);
              return false;

              /// TODO: add calendar action
            }
          },

          background: Container(
            color: Colors.blue,
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Icon(
                  Icons.calendar_month,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // Show a red background as the item is swiped away.
          secondaryBackground: Container(
            color: Colors.red,
            child: const Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          child: TaskTile(
            task: tasks[index],
          ),
        ),
      ),
    );
  }
}
