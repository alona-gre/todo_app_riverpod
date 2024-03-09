import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

class SyncService {
  final Ref ref;

  SyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveTasksToRemote(user.uid);
      }
    });
  }

  /// moves all tasks from the local to the remote repository
  Future<void> _moveTasksToRemote(String uid) async {
    try {
      // Get the local tasks data
      final localTasksRepository = ref.read(localTasksRepositoryProvider);
      final localTasks = await localTasksRepository.fetchTasks();
      if (localTasks.isNotEmpty) {
        // Get the remote tasks data
        final remoteTasksRepository = ref.read(remoteTasksRepositoryProvider);
        final remoteTasks = await remoteTasksRepository.fetchTasks(uid);
        // Merge local with remote repository

        final mergedTasks = _mergeTasks(localTasks, remoteTasks);

        // Write the updated remote repository data to the repository
        await remoteTasksRepository.setTasks(uid, mergedTasks);
        // Remove all items from the local repository
        await localTasksRepository.setTasks(const []);
      }
    } catch (e, _) {
      throw e.toString();
      // ref.read(errorLoggerProvider).logError(e, st);
    }
  }

  List<Task> _mergeTasks(List<Task> localTasks, List<Task> remoteTasks) {
    // Create a temporary set to hold unique tasks by ID
    final uniqueTasks = <String, Task>{};

    if (localTasks.isNotEmpty) {
      // Add local tasks to the set
      for (final task in localTasks) {
        uniqueTasks[task.id!] = task;
      }
    }

    if (remoteTasks.isNotEmpty) {
      // Add remote tasks to the set, keeping the task with the latest timestamp
      for (final task in remoteTasks) {
        if (!uniqueTasks.containsKey(task.id)
            // TODO: add timestamp of the latest modification
            // || uniqueTasks[task.id]!.timestamp.isBefore(task.timestamp))
            ) {
          uniqueTasks[task.id!] = task;
        }
      }
    }

    // Convert the set back to a list
    return uniqueTasks.values.toList();
  }
}

final syncServiceProvider = Provider<SyncService>(
  (ref) {
    return SyncService(ref);
  },
);
