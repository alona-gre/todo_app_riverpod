import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/features/app_drawer/presentation/app_drawer.dart';

class CompletedRobot {
  final WidgetTester tester;

  CompletedRobot(this.tester);

  Future<void> addTaskToCompleted() async {
    final finder = find.byType(Checkbox);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> removeTaskFromCompleted() async {
    final finder = find.byType(Checkbox);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  // completed screen
  Future<void> openCompleted() async {
    final finder = find.byKey(MyDrawer.completedTaskList);
    expect(finder, findsOneWidget);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  void expectCompletedIsLoading() {
    final finder = find.byType(CircularProgressIndicator);
    expect(finder, findsOneWidget);
  }

  void expectCompletedIsEmpty() {
    final finder = find.text('Your completed task list is empty');
    expect(finder, findsOneWidget);
  }

  Future<void> addToCompleted() async {
    final finder = find.byType(Checkbox);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> removeFromCompleted() async {
    final finder = find.byType(Checkbox);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }
}
