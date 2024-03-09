import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_todo_app/src/features/sync_service/sync_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

import '../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late MockRemoteTasksRepository remoteTasksRepository;
  late MockLocalTasksRepository localTasksRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    remoteTasksRepository = MockRemoteTasksRepository();
    localTasksRepository = MockLocalTasksRepository();
  });

  SyncService makeSyncService() {
    final container = ProviderContainer(overrides: [
      authRepositoryProvider.overrideWithValue(authRepository),
      localTasksRepositoryProvider.overrideWithValue(localTasksRepository),
      remoteTasksRepositoryProvider.overrideWithValue(remoteTasksRepository),
    ]);
    addTearDown(container.dispose);
    return container.read(syncServiceProvider);
  }

  group('TasksSyncService', () {
    Future<void> runTasksSyncTest({
      required List<Task> localTasks,
      required List<Task> remoteTasks,
      required List<Task> expectedRemoteTasks,
    }) async {
      const uid = '123';
      when(authRepository.authStateChanges).thenAnswer(
        (_) => Stream.value(const AppUser(uid: uid, email: 'test@test.com')),
      );
      when(localTasksRepository.fetchTasks)
          .thenAnswer((_) => Future.value(localTasks));
      when(() => remoteTasksRepository.fetchTasks(uid))
          .thenAnswer((_) => Future.value(remoteTasks));
      when(() => remoteTasksRepository.setTasks(uid, expectedRemoteTasks))
          .thenAnswer((_) => Future.value());
      when(() => localTasksRepository.setTasks(const []))
          .thenAnswer((_) => Future.value());
      // create cart sync service (return value not needed)
      makeSyncService();
      // wait for all the stubbed methods to return a value
      await Future.delayed(const Duration());
      // verify
      verify(() => remoteTasksRepository.setTasks(
            uid,
            expectedRemoteTasks,
          )).called(1);
      verify(() => localTasksRepository.setTasks(
            const [],
          )).called(1);
    }

    test('local and remote tasks are not empty', () async {
      await runTasksSyncTest(
        localTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '2', title: 'task2'),
        ],
        remoteTasks: [
          const Task(id: '3', title: 'task3'),
          const Task(id: '4', title: 'task4'),
        ],
        expectedRemoteTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '2', title: 'task2'),
          const Task(id: '3', title: 'task3'),
          const Task(id: '4', title: 'task4'),
        ],
      );
    });

    test('local not empty, remote is empty', () async {
      await runTasksSyncTest(
        localTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '2', title: 'task2'),
        ],
        remoteTasks: [],
        expectedRemoteTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '2', title: 'task2'),
        ],
      );
    });

    test('local and remote have the same task', () async {
      await runTasksSyncTest(
        localTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '2', title: 'task2'),
        ],
        remoteTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '3', title: 'task3'),
        ],
        expectedRemoteTasks: [
          const Task(id: '1', title: 'task1'),
          const Task(id: '2', title: 'task2'),
          const Task(id: '3', title: 'task3'),
        ],
      );
    });
  });
}
