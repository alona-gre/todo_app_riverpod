// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class AddedItem {
  final TaskID taskId;
  final Task task;

  AddedItem({required this.taskId, this.task = const Task()});

  @override
  bool operator ==(covariant AddedItem other) {
    if (identical(this, other)) return true;

    return other.taskId == taskId && other.task == task;
  }

  @override
  int get hashCode => taskId.hashCode ^ task.hashCode;
}
