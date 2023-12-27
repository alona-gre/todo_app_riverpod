import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:riverpod_todo_app/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    GlobalKey? key,
    required this.task,
  }) : super(key: key);

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Checkbox(
                  value: task.isDone,
                  onChanged: (value) {
                    // TODO: Tap checkbox
                    showNotImplementedAlertDialog(context: context);
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          decoration:
                              task.isDone! ? TextDecoration.lineThrough : null,
                        ),
                      ),
                      task.createdDate != null
                          ? Text(
                              DateFormat()
                                  .add_yMMMEd()
                                  .add_Hms()
                                  .format(DateTime.parse(
                                    task.createdDate!,
                                  )),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            task.isFavorite == false
                ? IconButton(
                    icon: const Icon(Icons.star_outline),
                    onPressed: () {
                      /// TODO
                      showNotImplementedAlertDialog(context: context);
                    },
                  )
                : IconButton(
                    icon: const Icon(Icons.star),
                    onPressed: () {
                      /// To-Do
                    },
                  ),
          ],
        ),
      ],
    );
  }
}
