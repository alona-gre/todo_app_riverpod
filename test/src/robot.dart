import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/app.dart';
import 'package:riverpod_todo_app/src/common_widgets/primary_button.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/fake_local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/home_app_bar/more_menu_button.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/fake_remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/add_task/add_task_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/functions/edit_task/edit_task_widget.dart';
import 'package:riverpod_todo_app/src/features/tasks/presentation/tasklists/task_tile.dart';

import 'features/authentication/auth_robot.dart';
import 'features/tasks/presentation/tasklists/completed/completed_robot.dart';
import 'features/tasks/presentation/tasklists/starred/starred_robot.dart';

class Robot {
  Robot(this.tester)
      : auth = AuthRobot(tester),
        starredTasks = StarredRobot(tester),
        completedTasks = CompletedRobot(tester);

  final WidgetTester tester;
  final AuthRobot auth;
  final StarredRobot starredTasks;
  final CompletedRobot completedTasks;

  Future<void> pumpMyApp() async {
    // Override repositories

    final authRepository = FakeAuthRepository(hasDelay: false);
    final localTasksRepository = FakeLocalTasksRepository(addDelay: false);
    final remoteTasksRepository = FakeRemoteTasksRepository(addDelay: false);
    // * Create ProviderContainer with any required overrides
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localTasksRepositoryProvider.overrideWithValue(localTasksRepository),
        remoteTasksRepositoryProvider.overrideWithValue(remoteTasksRepository),
      ],
    );
    // * Entry point of the app
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();
  }

  void expectFindNTaskTiles(int number) async {
    final finder = find.byType(TaskTile);
    expect(finder, findsNWidgets(number));
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

  Future<void> openDrawer() async {
    final finder = find.byIcon(Icons.menu);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap to reveal the menu
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else no-op, as the items are already visible
  }

  void expectTaskListIsEmpty() {
    final finder = find.text('Your task list is empty');
    expect(finder, findsOneWidget);
  }

  // starred screen
  Future<void> openAllTasks() async {
    final finder = find.byKey(MyDrawer.allTasks);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // task list
  Future<void> selectTask({int atIndex = 0}) async {
    final finder = find.byKey(TaskTile.taskTileKey);
    await tester.tap(finder.at(atIndex));
    await tester.pumpAndSettle();
  }

  Future<void> openAddTaskWidget() async {
    final finder = find.byType(FloatingActionButton);
    final matches = finder.evaluate();
    // if an item is found, it means that we're running
    // on a small window and can tap FloatingActionButton to add a task
    if (matches.isNotEmpty) {
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }
    // else open drawer to add task
    else {
      await addTaskFromDrawer();
    }
  }

  Future<void> addTaskFromDrawer() async {
    await openDrawer();
    final finder = find.byIcon(Icons.add);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> enterTaskTitle(String title) async {
    final titleField = find.byKey(AddTaskWidget.titleKey);
    expect(titleField, findsOneWidget);
    await tester.enterText(titleField, title);
  }

  Future<void> enterTaskNotes(String notes) async {
    final notesField = find.byKey(AddTaskWidget.notesKey);
    expect(notesField, findsOneWidget);
    await tester.enterText(notesField, notes);
  }

  Future<void> editTaskNotes(String notes) async {
    final notesField = find.byKey(EditTaskWidget.notesKey);
    expect(notesField, findsOneWidget);
    await tester.enterText(notesField, notes);
  }

  Future<void> tapAddTaskButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pumpAndSettle();
  }

  Future<void> tapEditTaskButton() async {
    final primaryButton = find.byType(PrimaryButton);
    expect(primaryButton, findsOneWidget);
    await tester.tap(primaryButton);
    await tester.pumpAndSettle();
  }

  /// TODO: test swipe to delete
  // Future<void> swipeToDelete() async {
  //   final widgetSize =
  //       tester.getSize(find.byKey(TaskTile.taskTileKey)).width / 3;

  //   await tester.drag(
  //     find.byKey(TaskTile.taskTileKey),
  //     Offset(-widgetSize, 0),
  //   );

  //   await tester.pumpAndSettle();
  // }
}
