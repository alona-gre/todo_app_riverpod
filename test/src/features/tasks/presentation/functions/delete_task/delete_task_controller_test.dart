import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/delete_task/delete_task_controller.dart';

import '../../../../../mocks.dart';

void main() {
  const taskId = '1';
  final tasksService = MockTasksService();

  group('delete a task', () {
    test('delete a task, success ', () async {
      // setup
      when(
        () => tasksService.deleteTask(taskId),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = DeleteTaskController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.deleteTask(taskId);

      verify(() => tasksService.deleteTask(taskId)).called(1);
      expect(
        controller.state,
        const AsyncData<void>(null),
      );
    });

    test('delete a task, failure ', () async {
      // setup
      when(
        () => tasksService.deleteTask(taskId),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = DeleteTaskController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData<void>(null),
      );
      await controller.deleteTask(taskId);

      verify(() => tasksService.deleteTask(taskId)).called(1);
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
