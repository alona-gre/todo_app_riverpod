import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/common_widgets/task_list_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/all_tasks/tasks_search_state_provider.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchedTasks = ref.watch(tasksSearchResultsProvider);

    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AsyncValueWidget(
            value: searchedTasks,
            data: (tasks) => tasks.toList().isEmpty
                ? Center(
                    child: Text('0 tasks found'.hardcoded,
                        style: Theme.of(context).textTheme.bodyLarge),
                  )
                : Column(
                    children: [
                      TaskListWidget(tasks: searchedTasks.value ?? []),
                    ],
                  ),
          ),
        ]);
  }
}
