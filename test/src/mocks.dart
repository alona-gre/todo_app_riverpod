import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/application/tasks_service.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/local/fake_local_tasks_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/data/remote/fake_remote_tasks_repository.dart';

class MockAuthRepository extends Mock implements FakeAuthRepository {}

class MockLocalTasksRepository extends Mock
    implements FakeLocalTasksRepository {}

class MockRemoteTasksRepository extends Mock
    implements FakeRemoteTasksRepository {}

class MockTasksService extends Mock implements TasksService {}
