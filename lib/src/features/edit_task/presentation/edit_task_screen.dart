import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/common_widgets/alert_dialogs.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/fake_tasks_repository.dart';

class EditTaskScreen extends StatefulWidget {
  final String taskId;

  const EditTaskScreen({super.key, required this.taskId});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  @override
  Widget build(BuildContext context) {
    final task = FakeTasksRepository.instance.getTask(widget.taskId);
    TextEditingController titleController = TextEditingController(
      text: task!.title,
    );
    TextEditingController notesController =
        TextEditingController(text: task.notes);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
                    autofocus: true,
                    controller: titleController,
                    decoration: const InputDecoration(
                      label: Text('Title'),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                TextField(
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
                      child: const Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        /// TODO adding tasks
                        showNotImplementedAlertDialog(context: context);
                      },
                      child: const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
