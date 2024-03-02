import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/common_widgets/async_value_widget.dart';
import 'package:riverpod_todo_app/src/common_widgets/primary_button.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/edit_task/edit_task_controller.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/localization/string_hardcoded.dart';
import 'package:riverpod_todo_app/src/utils/show_snackbar.dart';

class EditTaskWidget extends ConsumerStatefulWidget {
  final String taskId;

  const EditTaskWidget({super.key, required this.taskId});

  // * Keys for testing using find.byKey()
  static const titleKey = Key('title');
  static const notesKey = Key('notes');

  @override
  ConsumerState<EditTaskWidget> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends ConsumerState<EditTaskWidget> {
  @override
  Widget build(BuildContext context) {
    final taskValue = ref.watch(taskProvider(widget.taskId));

    final state = ref.watch(editTaskControllerProvider);

    return AsyncValueWidget(
      value: taskValue,
      data: (task) {
        if (task == null) {
          return AlertDialog(
            title: Text(
              'Task is not found'.hardcoded,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          );
        } else {
          TextEditingController titleController = TextEditingController(
            text: task.title,
          );
          TextEditingController notesController =
              TextEditingController(text: task.notes);
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  /// TODO: use responsive Center Widget
                  width: 600,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Text(
                        'Edit task',
                        style: TextStyle(fontSize: 24),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: TextField(
                          key: EditTaskWidget.titleKey,
                          autofocus: true,
                          controller: titleController,
                          decoration: const InputDecoration(
                            label: Text('Title'),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      TextField(
                        key: EditTaskWidget.notesKey,
                        autofocus: true,
                        controller: notesController,
                        minLines: 3,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          label: Text('Notes'),
                          border: OutlineInputBorder(),
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
                            child: Text(
                              'Cancel'.hardcoded,
                            ),
                          ),
                          PrimaryButton(
                              text: 'Save'.hardcoded,
                              isLoading: state.isLoading,
                              onPressed: () {
                                final Task updatedTask = task.copyWith(
                                  id: task.id,
                                  title: titleController.text,
                                  notes: notesController.text,
                                );
                                ref
                                    .read(editTaskControllerProvider.notifier)
                                    .updateTask(updatedTask);
                                !state.hasError && !state.isLoading
                                    ? showSnackBar(context,
                                        'The changes are saved'.hardcoded)
                                    : null;

                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
