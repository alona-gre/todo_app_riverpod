import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/completed/complete_controller.dart';

import '../../../../../mocks.dart';

void main() {
  const taskId = '1';
  const task = Task(
    id: taskId,
  );
  final tasksService = MockTasksService();

  group('complete a task', () {
    test('complete a task, success ', () async {
      // setup

      when(
        () => tasksService.completeTask(task),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = CompleteController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.complete(
        const Task(id: taskId),
      );

      verify(() => tasksService.completeTask(
            const Task(id: taskId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(true),
      );
    });

    test('complete a task, failure ', () async {
      // setup

      when(
        () => tasksService.completeTask(task),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = CompleteController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.complete(
        const Task(id: taskId),
      );

      verify(() => tasksService.completeTask(
            const Task(id: taskId),
          )).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<bool>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });

  group('uncomplete a completed task', () {
    test('uncomplete a completed task, success ', () async {
      // setup
      when(
        () => tasksService.completeTask(task),
      ).thenAnswer((_) => Future.value());
      when(
        () => tasksService.uncompleteTask(task),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = CompleteController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.complete(const Task(id: taskId));
      await controller.uncomplete(const Task(id: taskId));

      verify(() => tasksService.uncompleteTask(
            const Task(id: taskId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(false),
      );
    });

    test('uncomplete a completed task, failure ', () async {
      // setup
      when(
        () => tasksService.completeTask(task),
      ).thenAnswer((_) => Future.value());
      when(
        () => tasksService.uncompleteTask(task),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = CompleteController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.complete(const Task(id: taskId));
      await controller.uncomplete(
        const Task(id: taskId),
      );

      verify(() => tasksService.uncompleteTask(
            const Task(id: taskId),
          )).called(1);
      expect(
        controller.state,
        predicate<AsyncValue<bool>>(
          (value) {
            expect(value.hasError, true);
            return true;
          },
        ),
      );
    });
  });
}
