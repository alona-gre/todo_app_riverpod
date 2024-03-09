import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/task_list.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

class AllTasksScreen extends ConsumerWidget {
  const AllTasksScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksListValue = ref.watch(tasksProvider);
    // debugPrint(tasksListValue.toString());
    return AsyncValueWidget(
      value: tasksListValue,
      data: (taskList) => taskList.toList().isEmpty
          ? Center(
              child: Text(
                'Your task list is empty. Add a new task!'.hardcoded,
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
                        '${taskList.toList().length} Completed | ${taskList.toList().length} All'),
                  ),
                ),
                TasksList(taskList: taskList)
              ],
            ),
    );
  }
}
