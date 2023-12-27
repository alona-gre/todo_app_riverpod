import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/constants/test_products.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list/task_list.dart';

class AllTasksList extends StatelessWidget {
  const AllTasksList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const List<Task> taskList = kTestTasks;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Chip(
            label:
                Text('${taskList.length} Completed | ${taskList.length} All'),
          ),
        ),
        const TasksList(taskList: taskList)
      ],
    );
  }
}
