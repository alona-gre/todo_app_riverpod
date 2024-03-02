import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/starred/add_to_starred_controller.dart';

import '../../../../../mocks.dart';

void main() {
  const taskId = '1';
  const task = Task(
    id: taskId,
  );
  final tasksService = MockTasksService();

  group('star a task', () {
    test('star a task, success ', () async {
      // setup
      when(
        () => tasksService.starTask(task),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = AddToStarredController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addToStarred(
        const Task(id: taskId),
      );

      verify(() => tasksService.starTask(
            const Task(id: taskId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(true),
      );
    });

    test('star a task, failure ', () async {
      // setup

      when(
        () => tasksService.starTask(task),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = AddToStarredController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addToStarred(
        const Task(id: taskId),
      );

      verify(() => tasksService.starTask(
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

  group('unstar a task', () {
    test('unstar a starred task, success ', () async {
      // setup
      when(
        () => tasksService.starTask(task),
      ).thenAnswer((_) => Future.value());
      when(
        () => tasksService.removeStarFromTask(task),
      ).thenAnswer((_) => Future.value());

      // run & verify
      final controller = AddToStarredController(
        tasksService: tasksService,
      );
      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addToStarred(const Task(id: taskId));
      await controller.removeFromStarred(const Task(id: taskId));

      verify(() => tasksService.removeStarFromTask(
            const Task(id: taskId),
          )).called(1);
      expect(
        controller.state,
        const AsyncData(false),
      );
    });

    test('unstar a starred task, failure ', () async {
      // setup
      when(
        () => tasksService.starTask(task),
      ).thenAnswer((_) => Future.value());
      when(
        () => tasksService.removeStarFromTask(task),
      ).thenThrow((_) => Exception('Connection failed'));

      // run & verify
      final controller = AddToStarredController(
        tasksService: tasksService,
      );

      expect(
        controller.state,
        const AsyncData(false),
      );
      await controller.addToStarred(const Task(id: taskId));
      await controller.removeFromStarred(
        const Task(id: taskId),
      );

      verify(() => tasksService.removeStarFromTask(
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
