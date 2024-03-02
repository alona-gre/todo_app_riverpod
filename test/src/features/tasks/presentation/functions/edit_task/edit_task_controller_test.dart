import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/edit_task/edit_task_controller.dart';

import '../../../../../mocks.dart';

void main() {
  const testTask = Task(
    id: '1',
    title: 'title',
  );
  final tasksService = MockTasksService();

  group('edit a task', () {
    test('edit a task, success ', () async {
      // setup
      when(
        () => tasksService.updateTask(testTask),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = EditTaskController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.updateTask(testTask);

      verify(() => tasksService.updateTask(testTask)).called(1);
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
    });

    test('edit a task, failure ', () async {
      // setup
      when(
        () => tasksService.updateTask(testTask),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = EditTaskController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.updateTask(testTask);

      verify(() => tasksService.updateTask(testTask)).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<void>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });
}
