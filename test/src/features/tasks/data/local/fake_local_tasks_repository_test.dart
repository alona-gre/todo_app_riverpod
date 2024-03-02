import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/fake_local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

void main() {
  const testTask = Task(id: '1', title: 'abc', notes: 'notes');

  FakeLocalTasksRepository makeFakeLocalTasksRepository() =>
      FakeLocalTasksRepository(
        addDelay: false,
      );

  group('FakeLocalTasksRepository', () {
    test('current task list is null', () {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);

      expect(fakeLocalRepository.getTasks, []);
    });

    test('the task is added to the task list', () async {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);
      await fakeLocalRepository.insertTask(testTask);

      expect(fakeLocalRepository.getTasks, [testTask]);
    });

    test('the task is deleted to the task list', () async {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);
      await fakeLocalRepository.insertTask(testTask);
      await fakeLocalRepository.deleteTask(testTask.id!);

      expect(fakeLocalRepository.getTasks, []);
    });

    test('the task is completed in the task list', () async {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);
      await fakeLocalRepository.insertTask(testTask);
      await fakeLocalRepository.completeTask(testTask);
      final task = fakeLocalRepository.getTaskById(testTask.id!);
      expect(task.isCompleted, true);
    });

    test('the task is uncompleted in the task list of the given user',
        () async {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);
      await fakeLocalRepository.insertTask(testTask);
      await fakeLocalRepository.completeTask(testTask);
      await fakeLocalRepository.uncompleteTask(testTask);
      final task = fakeLocalRepository.getTaskById(testTask.id!);
      expect(task.isCompleted, false);
    });

    test('the task is starred in the task list of the given user', () async {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);
      await fakeLocalRepository.insertTask(testTask);
      await fakeLocalRepository.starTask(testTask);
      final task = fakeLocalRepository.getTaskById(testTask.id!);
      expect(task.isStarred, true);
    });

    test('the task is unstarred in the task list of the given user', () async {
      final fakeLocalRepository = makeFakeLocalTasksRepository();
      addTearDown(fakeLocalRepository.dispose);
      await fakeLocalRepository.insertTask(testTask);
      await fakeLocalRepository.starTask(testTask);
      await fakeLocalRepository.removeStarFromTask(testTask);
      final task = fakeLocalRepository.getTaskById(testTask.id!);
      expect(task.isStarred, false);
    });
  });
}
