import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_todo_app/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/presentation/add_to_starred/add_to_starred_widget.dart';
import 'package:riverpod_todo_app/src/routing/app_router.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    GlobalKey? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () {
            context.pushNamed(
              AppRoute.task.name,
              pathParameters: {'id': task.id!},
            );
          },

          leading: Checkbox(
            value: task.isDone,
            onChanged: (value) {
              // TODO: Tap checkbox
              showNotImplementedAlertDialog(context: context);
            },
          ),
          title: Text(
            task.title ?? '',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 18,
              decoration: task.isDone! ? TextDecoration.lineThrough : null,
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
          trailing: AddToStarredWidget(task: task),
        ),
        const Divider(
          height: 0,
        ),
      ],
    );
  }
}
