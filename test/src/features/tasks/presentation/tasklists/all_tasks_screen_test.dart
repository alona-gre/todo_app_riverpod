import 'package:flutter_test/flutter_test.dart';

import '../../../../robot.dart';

void main() {
  const testTitle = 'task1';
  group('AllTasks screen', () {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.
    testWidgets('Empty all tasks list', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        r.expectFindNTaskTiles(0);
        r.expectTaskListIsEmpty;
      });
    });

    testWidgets('Add a new task', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        r.expectFindNTaskTiles(0);
        r.expectTaskListIsEmpty;

        // add a new task
        await r.openAddTaskWidget();
        await r.enterTaskTitle(testTitle);
        await r.tapAddTaskButton();
        // verify the task is added
        r.expectFindNTaskTiles(1);
      });
    });

    testWidgets('Delete a task', (tester) async {
      final r = Robot(tester);
      await r.pumpMyApp();
      await tester.runAsync(() async {
        r.expectFindNTaskTiles(0);
        r.expectTaskListIsEmpty;
      });
      // add a new task
      await r.openAddTaskWidget();
      await r.enterTaskTitle(testTitle);
      await r.tapAddTaskButton();
      // verify the task is added
      await tester.runAsync(() async {
        r.expectFindNTaskTiles(1);
      });

      /// TODO swipe to delete a task
      // await tester.runAsync(() async {
      //   await r.swipeToDelete();
      //   r.expectFindNTaskTiles(0);
      // });
    });
  });
}
