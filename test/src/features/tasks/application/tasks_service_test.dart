import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/remote_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';

import '../../../mocks.dart';

void main() {
  setUpAll(() {
    registerFallbackValue(const Task());
  });
  const testUser = AppUser(uid: 'abc', email: 'abc@test.com');

  late MockAuthRepository authRepository;
  late MockRemoteTasksRepository remoteTasksRepository;
  late MockLocalTasksRepository localTasksRepository;
  setUp(() {
    authRepository = MockAuthRepository();
    remoteTasksRepository = MockRemoteTasksRepository();
    localTasksRepository = MockLocalTasksRepository();
  });

  TasksService makeTasksService() {
    final container = ProviderContainer(
      overrides: [
        authRepositoryProvider.overrideWithValue(authRepository),
        localTasksRepositoryProvider.overrideWithValue(localTasksRepository),
        remoteTasksRepositoryProvider.overrideWithValue(remoteTasksRepository),
      ],
    );
    addTearDown(container.dispose);
    return container.read(tasksServiceProvider);
  }

  group('insertTask', () {
    test('null user, inserts task to local repository', () async {
      // setup
      const expectedTask = Task(title: 'abc', notes: 'notes');
      when(() => authRepository.authStateChanges())
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.insertTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.insertTask(
        const Task(title: 'abc', notes: 'notes'),
      );
      // verify
      verify(
        () => localTasksRepository.insertTask(expectedTask),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.insertTask(any(), any()),
      );
    });

    test(
      'non-null user, inserts task to remote repository',
      () async {
        // setup
        const expectedTask = Task(title: 'abc', notes: 'notes');
        // TODO: fix. Works with the following
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() => remoteTasksRepository.insertTask(testUser.uid, expectedTask))
            .thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.insertTask(
          const Task(title: 'abc', notes: 'notes'),
        );
        // verify
        verify(
          () => remoteTasksRepository.insertTask(testUser.uid, expectedTask),
        ).called(1);
        verifyNever(
          () => localTasksRepository.insertTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });

  group('starTask', () {
    test('null user, stars task in local repository', () async {
      // setup
      const expectedTask = Task(title: 'abc', notes: 'notes');
      // when(() => authRepository.currentUser).thenReturn(null);
      when(() => authRepository.authStateChanges())
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.starTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.starTask(
        const Task(title: 'abc', notes: 'notes'),
      );
      // verify
      verify(
        () => localTasksRepository.starTask(expectedTask),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.starTask(any(), any()),
      );
    });

    test(
      'non-null user, stars task in remote repository',
      () async {
        // setup
        const expectedTask = Task(title: 'abc', notes: 'notes');
        // TODO: fix. Works with the following
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() => remoteTasksRepository.starTask(testUser.uid, expectedTask))
            .thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.starTask(
          const Task(title: 'abc', notes: 'notes'),
        );
        // verify
        verify(
          () => remoteTasksRepository.starTask(testUser.uid, expectedTask),
        ).called(1);
        verifyNever(
          () => localTasksRepository.starTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });

  group('removes star from a task', () {
    test('null user, unstars task in local repository', () async {
      // setup
      const expectedTask = Task(title: 'abc', notes: 'notes');
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.removeStarFromTask(expectedTask))
          .thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.removeStarFromTask(
        const Task(title: 'abc', notes: 'notes'),
      );
      // verify
      verify(
        () => localTasksRepository.removeStarFromTask(expectedTask),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.removeStarFromTask(any(), any()),
      );
    });

    test(
      'non-null user, unstars task in remote repository',
      () async {
        // setup
        const expectedTask = Task(title: 'abc', notes: 'notes');
        // TODO: fix. Works with the following
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() => remoteTasksRepository.removeStarFromTask(
            testUser.uid, expectedTask)).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.removeStarFromTask(
          const Task(title: 'abc', notes: 'notes'),
        );
        // verify
        verify(
          () => remoteTasksRepository.removeStarFromTask(
              testUser.uid, expectedTask),
        ).called(1);
        verifyNever(
          () => localTasksRepository.removeStarFromTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });

  group('completes  a task', () {
    test('null user, completes task in local repository', () async {
      // setup
      const expectedTask = Task(title: 'abc', notes: 'notes');
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.completeTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.completeTask(
        const Task(title: 'abc', notes: 'notes'),
      );
      // verify
      verify(
        () => localTasksRepository.completeTask(expectedTask),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.completeTask(any(), any()),
      );
    });

    test(
      'non-null user, completes task in remote repository',
      () async {
        // setup
        const expectedTask = Task(title: 'abc', notes: 'notes');
        // TODO: fix. Works with the following
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() =>
                remoteTasksRepository.completeTask(testUser.uid, expectedTask))
            .thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.completeTask(
          const Task(title: 'abc', notes: 'notes'),
        );
        // verify
        verify(
          () => remoteTasksRepository.completeTask(testUser.uid, expectedTask),
        ).called(1);
        verifyNever(
          () => localTasksRepository.completeTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });

  group('uncompletes a task', () {
    test('null user, uncompletes task in local repository', () async {
      // setup
      const expectedTask = Task(title: 'abc', notes: 'notes');
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.uncompleteTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.uncompleteTask(
        const Task(title: 'abc', notes: 'notes'),
      );
      // verify
      verify(
        () => localTasksRepository.uncompleteTask(expectedTask),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.uncompleteTask(any(), any()),
      );
    });

// TODO: fix (see commented)
    test(
      'non-null user, uncompletes task in remote repository',
      () async {
        // setup
        const expectedTask = Task(title: 'abc', notes: 'notes');
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() => remoteTasksRepository.uncompleteTask(
            testUser.uid, expectedTask)).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.uncompleteTask(
          const Task(title: 'abc', notes: 'notes'),
        );
        // verify
        verify(
          () =>
              remoteTasksRepository.uncompleteTask(testUser.uid, expectedTask),
        ).called(1);
        verifyNever(
          () => localTasksRepository.uncompleteTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });

  group('updateTask', () {
    test('null user, unpdates task in local repository', () async {
      // setup
      const expectedTask = Task(title: 'abc', notes: 'notes');
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.updateTask(expectedTask)).thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.updateTask(
        const Task(title: 'abc', notes: 'notes'),
      );
      // verify
      verify(
        () => localTasksRepository.updateTask(expectedTask),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.updateTask(any(), any()),
      );
    });

// TODO: fix (see commented)
    test(
      'non-null user, updates task in remote repository',
      () async {
        // setup
        const expectedTask = Task(title: 'abc', notes: 'notes');
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() => remoteTasksRepository.updateTask(testUser.uid, expectedTask))
            .thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.updateTask(
          const Task(title: 'abc', notes: 'notes'),
        );
        // verify
        verify(
          () => remoteTasksRepository.updateTask(testUser.uid, expectedTask),
        ).called(1);
        verifyNever(
          () => localTasksRepository.updateTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });

  group('deleteTask', () {
    test('null user, deletes task to local repository', () async {
      // setup
      const expectedTask = Task(id: '1', title: 'abc', notes: 'notes');
      when(authRepository.authStateChanges)
          .thenAnswer((_) => Stream.value(null));
      when(() => localTasksRepository.deleteTask(expectedTask.id!)).thenAnswer(
        (_) => Future.value(),
      );
      final tasksService = makeTasksService();
      // run
      await tasksService.deleteTask('1');
      // verify
      verify(
        () => localTasksRepository.deleteTask(expectedTask.id!),
      ).called(1);
      verifyNever(
        () => remoteTasksRepository.deleteTask(any(), any()),
      );
    });

// TODO: fix (see commented)
    test(
      'non-null user, deletes task from remote repository',
      () async {
        // setup
        const expectedTask = Task(id: '1', title: 'abc', notes: 'notes');
        // when(() => authRepository.currentUser).thenReturn(testUser);
        when(authRepository.authStateChanges)
            .thenAnswer((_) => Stream.value(testUser));
        when(() => remoteTasksRepository.deleteTask(
            testUser.uid, expectedTask.id!)).thenAnswer(
          (_) => Future.value(),
        );
        final tasksService = makeTasksService();
        // run
        await tasksService.deleteTask('1');

        // verify
        verify(
          () =>
              remoteTasksRepository.deleteTask(testUser.uid, expectedTask.id!),
        ).called(1);
        verifyNever(
          () => localTasksRepository.deleteTask(
            any(),
          ),
        );
      },
      skip: true,
    );
  });
}
