import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/add_task/add_task_controller.dart';

import '../../../../../mocks.dart';

void main() {
  const testTask = Task(
    id: '1',
    title: 'title',
  );
  final tasksService = MockTasksService();

  group('add a task', () {
    test('add a task, success ', () async {
      // setup
      when(
        () => tasksService.insertTask(testTask),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = AddTaskController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.addTask(testTask);

      verify(() => tasksService.insertTask(testTask)).called(1);
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
    });

    test('adds a task, failure ', () async {
      // setup
      when(
        () => tasksService.insertTask(testTask),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = AddTaskController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.addTask(testTask);

      verify(() => tasksService.insertTask(testTask)).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<dynamic>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });
}
