import 'package:flutter/material.dart';
import 'package:riverpod_todo_app/src/common_widgets/alert_dialogs.dart';

class AddTask extends StatelessWidget {
  const AddTask({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController titleController = TextEditingController();
    TextEditingController notesController = TextEditingController();

    return Container(
      /// ToDo: use responsive Center Widget
      width: 600,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'Add task',
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
    );
  }
}
