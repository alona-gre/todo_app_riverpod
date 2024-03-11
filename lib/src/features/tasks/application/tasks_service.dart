import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class TasksService {
  final Ref ref;
  TasksService(this.ref);

  Future insertTask(Task task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteTasksRepositoryProvider).insertTask(user.uid, task);
    } else {
      return ref.read(localTasksRepositoryProvider).insertTask(task);
    }
  }

  Future<void> starTask(Task task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      await ref.read(remoteTasksRepositoryProvider).starTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).starTask(task);
    }
  }

  Future<void> removeStarFromTask(Task task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      await ref
          .read(remoteTasksRepositoryProvider)
          .removeStarFromTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).removeStarFromTask(task);
    }
  }

  Future<void> completeTask(Task task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      await ref
          .read(remoteTasksRepositoryProvider)
          .completeTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).completeTask(task);
    }
  }

  Future<void> uncompleteTask(Task task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      await ref
          .read(remoteTasksRepositoryProvider)
          .uncompleteTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).uncompleteTask(task);
    }
  }

  Future<void> updateTask(Task task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      await ref.read(remoteTasksRepositoryProvider).updateTask(user.uid, task);
    } else {
      await ref.read(localTasksRepositoryProvider).updateTask(task);
    }
  }

  Future<void> deleteTask(String task) async {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
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

  Stream<List<Task>> watchTasks() {
    //final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteTasksRepositoryProvider).watchTasks(user.uid);
    } else {
      return ref.read(localTasksRepositoryProvider).watchTasks();
    }
  }

  Stream<List<Task>> watchStarred() {
    //final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteTasksRepositoryProvider).watchStarred(user.uid);
    } else {
      return ref.read(localTasksRepositoryProvider).watchStarred();
    }
  }

  Stream<List<Task>> watchCompletedTasksStream() {
    //final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteTasksRepositoryProvider).watchCompleted(user.uid);
    } else {
      return ref.read(localTasksRepositoryProvider).watchCompleted();
    }
  }

  Stream<Task?> watchTask(String taskId) {
    return watchTasks().map((tasks) => _getTask(tasks, taskId));
  }

  Stream<List<Task>> searchTasks(String query) {
    // final user = ref.read(authRepositoryProvider).currentUser;
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref
          .read(remoteTasksRepositoryProvider)
          .searchTasks(user.uid, query);
    } else {
      return ref.read(localTasksRepositoryProvider).searchTasks(query);
    }
  }
}

final tasksServiceProvider = Provider<TasksService>(
  (ref) {
    return TasksService(ref);
  },
);

final tasksProvider = StreamProvider(
  (ref) => ref.watch(tasksServiceProvider).watchTasks(),
);

final starredProvider = StreamProvider((ref) {
  final starredTasks = ref.watch(tasksServiceProvider).watchStarred();
  return starredTasks;
});

final completedProvider = StreamProvider((ref) {
  final completedTasks =
      ref.watch(tasksServiceProvider).watchCompletedTasksStream();
  return completedTasks;
});

final isStarredProvider = Provider.family<bool, String>((ref, taskId) {
  final tasks = ref.watch(tasksProvider).value;
  final task = tasks!.firstWhere(
    (tsk) => tsk.id == taskId,
    // orElse: () => const Task(),
  );
  final isStarred = task.isStarred;
  return isStarred ?? false;
});

final isCompletedProvider = Provider.family<bool, String>((ref, taskId) {
  final tasks = ref.watch(tasksProvider).value;
  final task = tasks!.firstWhere(
    (tsk) => tsk.id == taskId,
    // orElse: () => const Task(),
  );
  final isCompleted = task.isCompleted;
  return isCompleted ?? false;
});

final taskProvider = StreamProvider.family<Task?, String>(
  (ref, taskId) {
    return ref.watch(tasksServiceProvider).watchTask(taskId);
  },
);

final searchTasksProvider =
    StreamProvider.autoDispose.family<List<Task>, String>(
  (ref, query) {
    // ref.onDispose(() => debugPrint('onDisposed: $query'));
    // ref.onCancel(() => debugPrint('cancel: $query'));
    final link = ref.keepAlive();
    Timer(const Duration(seconds: 5), () {
      link.close();
    });

    // * debounce/delay network requests
    // * only works in combination with a CancelToken
    return ref.watch(tasksServiceProvider).searchTasks(query);
  },
);
