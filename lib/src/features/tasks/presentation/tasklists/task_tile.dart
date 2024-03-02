import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/completed/checkbox_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/starred/star_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    GlobalKey? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  // * Keys for testing using find.byKey()
  static const taskTileKey = Key('task-tile');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          key: taskTileKey,
          onTap: () {
            context.pushNamed(
              AppRoute.task.name,
              pathParameters: {'id': task.id!},
            );
          },

          leading: CheckboxWidget(task: task),

          title: Text(
            task.title ?? '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              decoration: task.isCompleted! ? TextDecoration.lineThrough : null,
            ),
          ),
          // subtitle: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //   children: <Widget>[
          //     Text(
          //       task.context.toString(),
          //       style: TextStyle(color: Colors.grey[800]),
          //     ),
          //     Text(
          //       task.dueDate != null
          //           ? DateFormat.MMMEd().format(task.dueDate as DateTime)
          //           : '',
          //       style: TextStyle(color: Colors.grey[800]),
          //     ),
          //   ],
          // ),

          trailing: StarWidget(task: task),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
