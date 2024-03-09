import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeRemoteTasksRepository implements RemoteTasksRepository {
  final bool addDelay;

  /// An InMemoryStore containing the tasks data for all users, where:
  /// key: uid of the user
  /// value: List<Task> of that user
  FakeRemoteTasksRepository({this.addDelay = true});

  final _tasks = InMemoryStore<Map<String, List<Task>>>({});

  // List to keep track of all tasks in the repository
  List<Task> getTasksByUserId(String userId) => _tasks.value[userId] ?? [];
  Task getTaskById(String userId, String taskId) =>
      getTasksByUserId(userId).firstWhere((tsk) => tsk.id == taskId);

  @override
  Future<void> insertTask(String uid, Task task) async {
    // Get current data from the store
    final currentData = _tasks.value;

    // Create a new list for the user if it doesn't exist
    if (currentData[uid] == null) {
      currentData[uid] = [];
    }

    // Add the task to the user's task list
    currentData[uid]!.add(task);

    // Update the store with the modified data
    _tasks.value = currentData;
  }

  @override
  Future deleteTask(String uid, String taskId) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid];

    allTasks!.removeWhere((tsk) => tsk.id == taskId);
    final updatedTasks = allTasks;

    _tasks.value[uid] = updatedTasks;
  }

  @override
  Future<void> completeTask(String uid, Task task) async {
    await delay(addDelay);
    // Get current data from the store
    final currentData = _tasks.value;
    final userData = currentData[uid] ?? [];

    for (int i = 0; i < userData.length; i++) {
      if (userData[i].id == task.id) {
        userData[i] = userData[i].copyWith(isCompleted: true);
        break;
      }
    }

    _tasks.value = currentData;
  }

  @override
  Future uncompleteTask(String uid, Task task) async {
    await delay(addDelay);
    // Get current data from the store
    final currentData = _tasks.value;
    final userData = currentData[uid] ?? [];

    for (int i = 0; i < userData.length; i++) {
      if (userData[i].id == task.id) {
        userData[i] = userData[i].copyWith(isCompleted: false);
        break;
      }
    }

    _tasks.value = currentData;
  }

  @override
  Future starTask(String uid, Task task) async {
    await delay(addDelay);
    // Get current data from the store
    final currentData = _tasks.value;
    final userData = currentData[uid] ?? [];

    for (int i = 0; i < userData.length; i++) {
      if (userData[i].id == task.id) {
        userData[i] = userData[i].copyWith(isStarred: true);
        break;
      }
    }

    _tasks.value = currentData;
  }

  @override
  Future removeStarFromTask(String uid, Task task) async {
    await delay(addDelay);
    // Get current data from the store
    final currentData = _tasks.value;
    final userData = currentData[uid] ?? [];

    for (int i = 0; i < userData.length; i++) {
      if (userData[i].id == task.id) {
        userData[i] = userData[i].copyWith(isStarred: false);
        break;
      }
    }

    _tasks.value = currentData;
  }

  @override
  Future updateTask(String uid, Task task) async {
    await delay(addDelay);
    // Get current data from the store
    final currentData = _tasks.value;
    final userData = currentData[uid] ?? [];

    for (int i = 0; i < userData.length; i++) {
      if (userData[i].id == task.id) {
        userData[i] = task;
        break;
      }
    }
  }

  @override
  Future<List<Task>> fetchTasks(
    String uid,
  ) =>
      Future.value(_tasks.value[uid] ?? const []);

  @override
  Stream<List<Task>> watchTasks(
    String uid,
  ) {
    return _tasks.stream.map(
      (tasksData) => tasksData[uid] ?? const [],
    );
  }

  @override
  Stream<List<Task>> watchCompleted(String uid) {
    final userTasks = _tasks.stream.map(
      (tasksData) => tasksData[uid] ?? const [],
    );
    final completedUserTasks = userTasks.map(
      (tasks) => tasks
          .where(
            (tsk) => tsk.isCompleted == true,
          )
          .toList(),
    );

    return completedUserTasks;
  }

  @override
  Stream<List<Task>> watchStarred(
    String uid,
  ) {
    final userTasks = _tasks.stream.map(
      (tasksData) => tasksData[uid] ?? const [],
    );
    final starredUserTasks = userTasks.map(
      (tasks) => tasks
          .where(
            (tsk) => tsk.isStarred == true,
          )
          .toList(),
    );

    return starredUserTasks;
  }

  void dispose() => _tasks.close();

  @override
  Future<void> setTasks(String uid, List<Task> updatedRemoteTasks) async {
    await delay(addDelay);
    // First, get the current tasks data for all users
    final tasks = _tasks.value;
    // Then, set the tasks for the given uid
    tasks[uid] = updatedRemoteTasks;
    // Finally, update the tasks data (will emit a new value)
    _tasks.value = tasks;
  }
}
