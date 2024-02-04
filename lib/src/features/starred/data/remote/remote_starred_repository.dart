import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/starred/data/remote/fake_remote_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';

abstract class RemoteStarredRepository {
  /// API for reading, watching and writing starred list data for a specific user ID
  Future<Starred> fetchStarred(String uid);
  Stream<Starred> watchStarred(String uid);
  Future<void> setStarred(String uid, Starred wishlist);
}

final remoteStarredRepositoryProvider =
    Provider<RemoteStarredRepository>((ref) {
  // TODO: replace with a 'real' remote wishlist repository
  return FakeRemoteStarredRepository();
});
