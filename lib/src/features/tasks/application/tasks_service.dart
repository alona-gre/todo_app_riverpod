import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class TasksService {
  final Ref ref;
  TasksService(this.ref);

  Future insertTask(Task task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteTasksRepositoryProvider).insertTask(user.uid, task);
    } else {
      return ref.read(localTasksRepositoryProvider).insertTask(task);
    }
  }

  Future<void> starTask(Task task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteTasksRepositoryProvider).starTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).starTask(task);
    }
  }

  Future<void> removeStarFromTask(Task task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteTasksRepositoryProvider)
          .removeStarFromTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).removeStarFromTask(task);
    }
  }

  Future<void> completeTask(Task task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteTasksRepositoryProvider)
          .completeTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).completeTask(task);
    }
  }

  Future<void> uncompleteTask(Task task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteTasksRepositoryProvider)
          .uncompleteTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).uncompleteTask(task);
    }
  }

  Future<void> updateTask(Task task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteTasksRepositoryProvider).updateTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).updateTask(task);
    }
  }

  Future<void> deleteTask(String task) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteTasksRepositoryProvider).deleteTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).deleteTask(task);
    }
  }

  static Task? _getTask(List<Task> tasks, String id) {
    try {
      return tasks.firstWhere((tsk) => tsk.id == id);
    } catch (e) {
      return null;
    }
  }

  Stream<List<Task>> watchAllTasksStream() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref
          .read(remoteTasksRepositoryProvider)
          .watchAllTasksStream(user.uid);
    } else {
      return ref.read(localTasksRepositoryProvider).watchAllTasksStream();
    }
  }

  Stream<List<Task>> watchStarredTasksStream() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref
          .read(remoteTasksRepositoryProvider)
          .watchStarredTasksStream(user.uid);
    } else {
      return ref.read(localTasksRepositoryProvider).watchStarredTasksStream();
    }
  }

  Stream<List<Task>> watchCompletedTasksStream() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref
          .read(remoteTasksRepositoryProvider)
          .watchCompletedTasksStream(user.uid);
    } else {
      return ref.read(localTasksRepositoryProvider).watchCompletedTasksStream();
    }
  }

  Stream<Task?> watchTask(String taskId) {
    return watchAllTasksStream().map((tasks) => _getTask(tasks, taskId));
  }
}

final tasksServiceProvider = Provider<TasksService>(
  (ref) {
    return TasksService(ref);
  },
);

final tasksServiceStreamProvider = StreamProvider(
  (ref) => ref.watch(tasksServiceProvider).watchAllTasksStream(),
);

final starredTasksServiceStreamProvider = StreamProvider((ref) {
  final starredTasks =
      ref.watch(tasksServiceProvider).watchStarredTasksStream();
  return starredTasks;
});

final completedTasksServiceStreamProvider = StreamProvider((ref) {
  final completedTasks =
      ref.watch(tasksServiceProvider).watchCompletedTasksStream();
  return completedTasks;
});

final isStarredProvider = Provider.family<bool, String>((ref, taskId) {
  final tasks = ref.watch(tasksServiceStreamProvider).value;
  final task = tasks!.firstWhere((tsk) => tsk.id == taskId);
  final isStarred = task.isStarred;
  return isStarred ?? false;
});

final isCompletedProvider = Provider.family<bool, String>((ref, taskId) {
  final tasks = ref.watch(tasksServiceStreamProvider).value;
  final task = tasks!.firstWhere((tsk) => tsk.id == taskId);
  final isCompleted = task.isCompleted;
  return isCompleted ?? false;
});

final taskProvider = StreamProvider.family<Task?, String>(
  (ref, taskId) {
    return ref.watch(tasksServiceProvider).watchTask(taskId);
  },
);
