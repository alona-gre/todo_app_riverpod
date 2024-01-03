import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'task_tile.dart';

class TasksList extends StatelessWidget {
  final List<Task> taskList;

  const TasksList({
    Key? key,
    required this.taskList,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.loose,
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: taskList.length,
          itemBuilder: (context, index) => TaskTile(
            task: taskList[index],
          ),
        ),
      ),
    );
  }
}
