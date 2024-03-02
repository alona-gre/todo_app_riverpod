import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/fake_remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

void main() {
  const testEmail = 'test@test.com';
  final testUser = AppUser(
    uid: testEmail.split('').reversed.join(),
    email: testEmail,
  );

  const testTask = Task(id: '1', title: 'abc', notes: 'notes');

  FakeRemoteTasksRepository makeFakeRemoteTasksRepository() =>
      FakeRemoteTasksRepository(
        addDelay: false,
      );

  group('FakeRemoteTasksRepository', () {
    test('current task list of the given user is null', () {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);

      expect(fakeRemoteRepository.getTasksByUserId(testUser.uid), []);
    });

    test('the task is added to the task list of the given user', () async {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);
      await fakeRemoteRepository.insertTask(testUser.uid, testTask);

      expect(fakeRemoteRepository.getTasksByUserId(testUser.uid), [testTask]);
    });

    test('the task is deleted to the task list of the given user', () async {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);
      await fakeRemoteRepository.insertTask(testUser.uid, testTask);
      await fakeRemoteRepository.deleteTask(testUser.uid, testTask.id!);

      expect(fakeRemoteRepository.getTasksByUserId(testUser.uid), []);
    });

    test('the task is completed in the task list of the given user', () async {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);
      await fakeRemoteRepository.insertTask(testUser.uid, testTask);
      await fakeRemoteRepository.completeTask(testUser.uid, testTask);
      final task = fakeRemoteRepository.getTaskById(testUser.uid, testTask.id!);
      expect(task.isCompleted, true);
    });

    test('the task is uncompleted in the task list of the given user',
        () async {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);
      await fakeRemoteRepository.insertTask(testUser.uid, testTask);
      await fakeRemoteRepository.completeTask(testUser.uid, testTask);
      await fakeRemoteRepository.uncompleteTask(testUser.uid, testTask);
      final task = fakeRemoteRepository.getTaskById(testUser.uid, testTask.id!);
      expect(task.isCompleted, false);
    });

    test('the task is starred in the task list of the given user', () async {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);
      await fakeRemoteRepository.insertTask(testUser.uid, testTask);
      await fakeRemoteRepository.starTask(testUser.uid, testTask);
      final task = fakeRemoteRepository.getTaskById(testUser.uid, testTask.id!);
      expect(task.isStarred, true);
    });

    test('the task is unstarred in the task list of the given user', () async {
      final fakeRemoteRepository = makeFakeRemoteTasksRepository();
      addTearDown(fakeRemoteRepository.dispose);
      await fakeRemoteRepository.insertTask(testUser.uid, testTask);
      await fakeRemoteRepository.starTask(testUser.uid, testTask);
      await fakeRemoteRepository.removeStarFromTask(testUser.uid, testTask);
      final task = fakeRemoteRepository.getTaskById(testUser.uid, testTask.id!);
      expect(task.isStarred, false);
    });
  });
}
