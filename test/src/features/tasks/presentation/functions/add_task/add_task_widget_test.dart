import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

// import '../../../../../mocks.dart';
import '../../../../../robot.dart';

void main() {
  const testTitle = 'task1';
  const testNotes = 'abc';
  // const testTask = Task(title: testTitle, notes: testNotes);

  // late MockLocalTasksRepository localTasksRepository;
  // setUp(() {
  //   localTasksRepository = MockLocalTasksRepository();
  // });

  group('add task', () {
    testWidgets('add a task', (tester) async {
      final r = Robot(tester);
      await r.pumpMyApp();
      await r.openAddTaskWidget();
      await r.enterTaskTitle(testTitle);
      await r.enterTaskTitle(testNotes);
      await r.tapAddTaskButton();
      // TODO:
      // verify(() => localTasksRepository.insertTask(testTask)).called(1);
    });
  });
}
