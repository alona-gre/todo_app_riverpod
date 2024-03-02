import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/common_widgets/task_list_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

class StarredTasksScreen extends ConsumerWidget {
  const StarredTasksScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTasks = ref.watch(tasksServiceStreamProvider);
    final starredTasks = ref.watch(starredTasksServiceStreamProvider);

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AsyncValueWidget(
            value: starredTasks,
            data: (starredTasks) => starredTasks.toList().isEmpty
                ? Center(
                    child: Text(
                      'Your starred task list is empty'.hardcoded,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Chip(
                          label: Text(
                              '${starredTasks.length} Starred | ${allTasks.value!.length} All'),
                        ),
                      ),
                      TaskListWidget(tasks: starredTasks),
                    ],
                  ),
          ),
        ]);
  }
}
