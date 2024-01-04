import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list/task_list.dart';

class AllTasksList extends StatelessWidget {
  const AllTasksList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final taskList = FakeTasksRepository.instance.getTasksList();

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
        TasksList(taskList: taskList)
      ],
    );
  }
}
