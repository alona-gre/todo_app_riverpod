import 'package:flutter_test/flutter_test.dart';

import '../../../../../robot.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

// import '../../../../../mocks.dart';

void main() {
  const testTitle = 'task1';
  const testNotes = 'abc';

  //const testTask = Task(title: testTitle, notes: testNotes);

  // late MockLocalTasksRepository localTasksRepository;
  // setUp(() {
  //   localTasksRepository = MockLocalTasksRepository();
  // });

  group('edit a task', () {
    testWidgets('edit a task', (tester) async {
      await tester.runAsync(() async {
        final r = Robot(tester);
        await r.pumpMyApp();
        await r.openAddTaskWidget();
        await r.enterTaskTitle(testTitle);
        await r.tapAddTaskButton();
        await r.selectTask();
        await r.editTaskNotes(testNotes);
        await r.tapEditTaskButton();
        // TODO:
        // verify(() => localTasksRepository.updateTask(testTask)).called(1);
      });
    });
  });
}
