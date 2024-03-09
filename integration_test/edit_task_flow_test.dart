import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/src/robot.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  const testTitle = 'task1';
  const testNotes = 'abc';
  testWidgets('Add and edit a task', (tester) async {
    final r = Robot(tester);
    await r.pumpMyApp();

    // add a new task
    await r.openAddTaskWidget();
    await r.enterTaskTitle(testTitle);
    await r.tapAddTaskButton();
    // verify the task is added
    r.expectFindNTaskTiles(1);

    // edit a task by adding notes
    await r.selectTask();
    await r.editTaskNotes(testNotes);
    await r.tapEditTaskButton();

    // star a task
    await r.starredTasks.addToStarred();
    await r.openDrawer();
    await r.starredTasks.openStarred();
    r.expectFindNTaskTiles(1);
    // unstar a task
    await r.starredTasks.removeFromStarred();
    // verify the starred list is empty
    await tester.runAsync(() async {
      // r.expectFindNTaskTiles(0);
      r.starredTasks.expectStarredIsEmpty();
    });

    await r.openDrawer();
    await r.openAllTasks();
    // complete a task
    await r.completedTasks.addToCompleted();
    await r.openDrawer();
    await r.completedTasks.openCompleted();
    r.expectFindNTaskTiles(1);
    // uncomplete a task
    await r.completedTasks.removeFromCompleted();
    // verify the completed list is empty
    await tester.runAsync(() async {
      // r.expectFindNTaskTiles(0);
      r.completedTasks.expectCompletedIsEmpty();

      /// TODO swipe to delete a task
      // await r.swipeToDelete();
      // r.expectFindNTaskTiles(0);

      await r.openDrawer();
      await r.openAllTasks();
      r.expectFindNTaskTiles(1);

      // TODO: log in and verify the tasks are synced
      // await r.openPopupMenu();
      // await r.auth.openEmailPasswordSignInScreen();
      // await r.auth.signInWithEmailAndPassword();

      // await tester.runAsync(() async {
      //   r.expectFindNTaskTiles(1);
      // });

      // await r.openPopupMenu();
      // await r.auth.openAccountScreen();
      // await r.auth.tapLogoutButton();
      // await r.auth.tapDialogLogoutButton();

      // r.expectFindNTaskTiles(1);

      /// TODO swipe to delete a task
      // await r.swipeToDelete();
      // r.expectFindNTaskTiles(0);
    });
  });
}
