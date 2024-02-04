import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/app.dart';
import 'package:riverpod_todo_app/src/constants/test_tasks.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/fake_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/home_app_bar/more_menu_button.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/task_list/task_tile.dart';

import 'features/authentication/auth_robot.dart';

class Robot {
  Robot(this.tester) : auth = AuthRobot(tester);

  final WidgetTester tester;
  final AuthRobot auth;

  Future<void> pumpMyApp() async {
    // Override repositories
    final tasksRepository = FakeTasksRepository(addDelay: false);
    final authRepository = FakeAuthRepository(hasDelay: false);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          tasksRepositoryProvider.overrideWithValue(tasksRepository),
          authRepositoryProvider.overrideWithValue(authRepository),
        ],
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectFindAllTaskTiles() {
    final finder = find.byType(TaskTile);
    expect(finder, findsNWidgets(kTestTasks.length));
  }

  Future<void> openPopupMenu() async {
    final finder = find.byType(MoreMenuButton);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap to reveal the menu
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }
}
