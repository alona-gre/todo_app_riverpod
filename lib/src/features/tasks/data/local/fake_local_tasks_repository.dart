import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeLocalTasksRepository implements LocalTasksRepository {
  final bool addDelay;

  FakeLocalTasksRepository({this.addDelay = true});

  final _tasks = InMemoryStore<List<Task>>([]);

  // List to keep track of all tasks in the repository
  List<Task> get getTasks => _tasks.value;
  Task getTaskById(String taskId) =>
      getTasks.firstWhere((tsk) => tsk.id == taskId);

  @override
  Future completeTask(Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value;
    final completedTask = allTasks
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isCompleted: true);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, completedTask);
    final updatedAllTasks = allTasks;

    _tasks.value = updatedAllTasks;
  }

  @override
  Future uncompleteTask(Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value;
    final completedTask = allTasks
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isCompleted: false);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, completedTask);
    final updatedTasks = allTasks;

    _tasks.value = updatedTasks;
  }

  @override
  Future deleteTask(String taskId) async {
    await delay(addDelay);
    final allTasks = _tasks.value;

    allTasks.removeWhere((tsk) => tsk.id == taskId);
    final updatedTasks = allTasks;

    _tasks.value = updatedTasks;
  }

  @override
  Future insertTask(Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value;

    allTasks.add(task);
    final updatedTasks = allTasks;

    _tasks.value = updatedTasks;
  }

  @override
  Future removeStarFromTask(Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value;
    final starredTask = allTasks
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isStarred: false);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, starredTask);
    final updatedTasks = allTasks;

    _tasks.value = updatedTasks;
  }

  @override
  Future starTask(Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value;
    final starredTask = allTasks
        .firstWhere((tsk) => tsk.id == task.id)
        .copyWith(isStarred: true);
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, starredTask);
    final updatedTasks = allTasks;

    _tasks.value = updatedTasks;
  }

  @override
  Future updateTask(Task task) async {
    await delay(addDelay);
    final allTasks = _tasks.value;
    final taskIndex = allTasks.indexWhere((tsk) => tsk.id == task.id);
    allTasks.removeAt(taskIndex);
    allTasks.insert(taskIndex, task);
    final updatedTasks = allTasks;

    _tasks.value = updatedTasks;
  }

  @override
  Future<List<Task>> fetchTasks() async {
    return _tasks.value;
  }

  @override
  Stream<List<Task>> watchTasks() {
    return _tasks.stream;
  }

  @override
  Stream<List<Task>> watchCompleted() {
    final completedTasks = watchTasks().map((tasks) => tasks
        .where(
          (tsk) => tsk.isCompleted!,
        )
        .toList());

    return completedTasks;
  }

  @override
  Stream<List<Task>> watchStarred() {
    final starredTasks = watchTasks().map((tasks) => tasks
        .where(
          (tsk) => tsk.isStarred!,
        )
        .toList());

    return starredTasks;
  }

  void dispose() => _tasks.close();

  @override
  Future<void> setTasks(List<Task> updatedTasks) async {
    await delay(addDelay);
    _tasks.value = updatedTasks;
  }

  @override

  /// Search for tasks where the title contains the search query
  Stream<List<Task>> searchTasks(String query) {
    assert(
      _tasks.value.length <= 100,
      'Client-side search should only be performed if the number of products is small. '
      'Consider doing server-side search for larger datasets.',
    );
    // Get all tasks
    final data = watchTasks();
    // Match all tasks where the title contains the query
    final result = data.map(
      (tasks) => tasks
          .where(
            (tsk) => tsk.title!.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList(),
    );

    return result;
  }
}
