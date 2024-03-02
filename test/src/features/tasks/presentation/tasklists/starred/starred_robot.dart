import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/common_widgets/starred_button.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';

class StarredRobot {
  final WidgetTester tester;

  StarredRobot(this.tester);

  Future<void> addTaskToStarred() async {
    final finder = find.byKey(StarredButton.addToStarredButtonKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> removeTaskFromStarred() async {
    final finder = find.byKey(StarredButton.removeFromStarredButtonKey);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // starred screen
  Future<void> openStarred() async {
    final finder = find.byKey(MyDrawer.starredTaskList);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectStarredIsLoading() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  void expectStarredIsEmpty() {
    // await tester.pumpAndSettle();
    final finder = find.text('Your starred task list is empty');
    expect(finder, findsOneWidget);
  }

  Future<void> addToStarred() async {
    final finder = find.byKey(StarredButton.addToStarredButtonKey);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> removeFromStarred() async {
    final finder = find.byKey(StarredButton.removeFromStarredButtonKey);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
