import 'package:flutter_test/flutter_test.dart';

import '../../../../../robot.dart';

void main() {
  const testTitle = 'task1';
  const testNotes = 'abc';

  group('starred screen', () {
    // * Note: All tests are wrapped with `runAsync` to prevent this error:
    // * A Timer is still pending even after the widget tree was disposed.
    testWidgets('Empty starred tasklist', (tester) async {
      final r = Robot(tester);
      await r.pumpMyApp();
      r.expectFindNTaskTiles(0);
      await r.openDrawer();
      await r.starredTasks.openStarred();
      await tester.runAsync(() async {
        r.starredTasks.expectStarredIsEmpty();
      });
    });

    testWidgets('Add task to starred from AllTasksScreen', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        // add a new task
        await r.openAddTaskWidget();
        await r.enterTaskTitle(testTitle);
        await r.enterTaskTitle(testNotes);
        await r.tapAddTaskButton();
        // verify the task is added
        r.expectFindNTaskTiles(1);
        // star a task
        await r.starredTasks.addToStarred();
        await r.openDrawer();
        await r.starredTasks.openStarred();
        r.expectFindNTaskTiles(1);
      });
    });

    testWidgets('Remove task from starred from AllTasksScreen', (tester) async {
      final r = Robot(tester);
      // add a new task
      await r.pumpMyApp();
      await r.openAddTaskWidget();
      await r.enterTaskTitle(testTitle);
      await r.enterTaskTitle(testNotes);
      await r.tapAddTaskButton();
      // verify the task is added
      r.expectFindNTaskTiles(1);
      // star a task
      await r.starredTasks.addToStarred();
      await r.openDrawer();
      await r.starredTasks.openStarred();
      r.expectFindNTaskTiles(1);
      // unstar a task
      await r.starredTasks.removeFromStarred();
      // verify the starred list is empty
      await tester.runAsync(() async {
        r.expectFindNTaskTiles(0);
        r.starredTasks.expectStarredIsEmpty();
      });
    });
  });
}
