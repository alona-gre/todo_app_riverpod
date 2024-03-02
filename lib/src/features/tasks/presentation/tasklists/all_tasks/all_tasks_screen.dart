import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/common_widgets/task_list_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(tasksServiceStreamProvider);
    final completedTasks = ref.watch(completedTasksServiceStreamProvider);

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AsyncValueWidget(
            value: allTasks,
            data: (starred) => Column(
              children: [
                Center(
                  child: Chip(
                    label: Text(
                        '${completedTasks.value!.length} Completed | ${allTasks.value!.length} All'),
                  ),
                ),
                TaskListWidget(tasks: allTasks.value ?? []),
              ],
            ),
          ),
        ]);
  }
}
