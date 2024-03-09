import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/common_widgets/task_list_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(tasksProvider);
    final completedTasks = ref.watch(completedProvider);

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AsyncValueWidget(
            value: allTasks,
            data: (tasks) => tasks.toList().isEmpty
                ? Center(
                    child: Text(
                      'Your  task list is empty'.hardcoded,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                : Column(
                    children: [
                      Center(
                        child: Chip(
                          label: Text(
                              '${completedTasks.value?.length ?? 0} Completed | ${allTasks.value?.length ?? 0} All'),
                        ),
                      ),
                      TaskListWidget(tasks: allTasks.value ?? []),
                    ],
                  ),
          ),
        ]);
  }
}
