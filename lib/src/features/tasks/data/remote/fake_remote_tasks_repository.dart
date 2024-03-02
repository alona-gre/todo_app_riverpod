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
  Future insertTask(String uid, Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid] ?? [];

    allTasks.add(task);
    final updatedTasks = allTasks;

    _tasks.value[uid] = updatedTasks;
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
  Future completeTask(String uid, Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid] ?? [];
    final completedTask = allTasks
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isCompleted: true);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, completedTask);
    final updatedAllTasks = allTasks;

    _tasks.value[uid] = updatedAllTasks;
  }

  @override
  Future uncompleteTask(String uid, Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid];
    final completedTask = allTasks!
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isCompleted: false);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, completedTask);
    final updatedTasks = allTasks;

    _tasks.value[uid] = updatedTasks;
  }

  @override
  Future starTask(String uid, Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid];
    final starredTask = allTasks!
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isStarred: true);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, starredTask);
    final updatedTasks = allTasks;

    _tasks.value[uid] = updatedTasks;
  }

  @override
  Future removeStarFromTask(String uid, Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid];
    final starredTask = allTasks!
        .firstWhere(
          (tsk) => tsk.id == task.id,
        )
        .copyWith(isStarred: false);

    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, starredTask);
    final updatedTasks = allTasks;

    _tasks.value[uid] = updatedTasks;
  }

  @override
  Future updateTask(String uid, Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value[uid];
    final taskIndex = allTasks!.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, task);
    final updatedTasks = allTasks;

    _tasks.value[uid] = updatedTasks;
  }

  @override
  Stream<List<Task>> watchAllTasksStream(
    String uid,
  ) =>
      _tasks.stream.map(
        (tasksData) => tasksData[uid] ?? const [],
      );

  @override
  Stream<List<Task>> watchCompletedTasksStream(String uid) {
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
  Stream<List<Task>> watchStarredTasksStream(
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
}