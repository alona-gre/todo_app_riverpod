import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/primary_button.dart';
import 'package:riverpod_todo_app/src/features/added/domain/addedItem.dart';
import 'package:riverpod_todo_app/src/features/added/presentation/add_tasks/add_task_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/utils/show_snackbar.dart';
import 'package:uuid/uuid.dart';

class AddTaskWidget extends ConsumerWidget {
  const AddTaskWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController titleController = TextEditingController();
    TextEditingController notesController = TextEditingController();

    final state = ref.watch(addTaskControllerProvider);
    // debugPrint(state.toString());

    return Container(
      /// TODO: use responsive Center Widget
      width: 600,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Add task'.hardcoded,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: TextField(
              autofocus: true,
              controller: titleController,
              decoration: InputDecoration(
                label: Text('Title'.hardcoded),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            autofocus: true,
            controller: notesController,
            minLines: 3,
            maxLines: 5,
            decoration: InputDecoration(
              label: Text('Notes'.hardcoded),
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'.hardcoded),
              ),
              PrimaryButton(
                isLoading: state.isLoading,
                onPressed: () {
                  final Task newTask = Task(
                    id: const Uuid().v4().toString(),
                    title: titleController.text,
                    notes: notesController.text,
                  );
                  final addedItem =
                      AddedItem(taskId: newTask.id!, task: newTask);

                  /// TODO verify adding tasks
                  ref
                      .read(addTaskControllerProvider.notifier)
                      .addTask(addedItem);
                  !state.hasError && !state.isLoading
                      ? showSnackBar(
                          context, 'The task has been added'.hardcoded)
                      : null;

                  Navigator.pop(context);

                  // showNotImplementedAlertDialog(context: context);
                },
                text: 'Add a new task'.hardcoded,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
