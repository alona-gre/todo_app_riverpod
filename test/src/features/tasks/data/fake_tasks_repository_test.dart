import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/constants/test_tasks.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/fake_tasks_repository.dart';

void main() {
  FakeTasksRepository makeTasksRepository() {
    return FakeTasksRepository(addDelay: false);
  }

  group('FakeTasksRepository', () {
    // test('getTasksList returns global list', () {
    //   final tasksRepository = makeTasksRepository();

    //   expect(
    //     tasksRepository.getTasksList(),
    //     kTestTasks,
    //   );
    // });

    // test('getTask(1) returns first item', () {
    //   final tasksRepository = makeTasksRepository();
    //   expect(
    //     tasksRepository.getTask('t1'),
    //     kTestTasks[0],
    //   );
    // });

    // test('getTask(100) returns null', () {
    //   final tasksRepository = makeTasksRepository();
    //   expect(
    //     tasksRepository.getTask('100'),
    //     null,
    //   );
    // });

    test('fetchTasksList returns global list', () async {
      final tasksRepository = makeTasksRepository();
      expect(
        await tasksRepository.fetchTasksList(),
        kTestTasks,
      );
    });
    test('watchTasksList emits global list', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTasksList(),
        emits(kTestTasks),
      );
    });

    test('watchTask(1) returns first item', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTask('t1'),
        emits(kTestTasks[0]),
      );
    });

    test('watchTask(100) returns null', () {
      final tasksRepository = makeTasksRepository();
      expect(
        tasksRepository.watchTask('100'),
        emits(null),
      );
    });
  });
}
