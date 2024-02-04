// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class StarredItem {
  final TaskID taskId;
  final bool isStarred;

  StarredItem({required this.taskId, this.isStarred = false});

  @override
  bool operator ==(covariant StarredItem other) {
    if (identical(this, other)) return true;

    return other.taskId == taskId && other.isStarred == isStarred;
  }

  @override
  int get hashCode => taskId.hashCode ^ isStarred.hashCode;
}
