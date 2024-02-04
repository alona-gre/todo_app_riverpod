import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/added/data/remote/fake_remote_added_repository.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';

abstract class RemoteAddedRepository {
  /// API for reading, watching and writing added list data for a specific user ID
  Future<Added> fetchAdded(String uid);
  Stream<Added> watchAdded(String uid);
  Future<void> setAdded(String uid, Added added);
}

final remoteAddedRepositoryProvider = Provider<RemoteAddedRepository>((ref) {
  // TODO: replace with a 'real' remote repository for added tasks
  return FakeRemoteAddedRepository();
});
