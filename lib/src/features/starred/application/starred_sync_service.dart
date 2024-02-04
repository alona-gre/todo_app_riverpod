import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';
import 'package:riverpod_todo_app/src/features/starred/data/local/local_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/data/remote/remote_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/mutable_starred.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';

class StarredSyncService {
  final Ref ref;

  StarredSyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        _moveItemsToRemoteCart(user.uid);
      }
    });
  }

  /// moves all items from the local to remote starred
  void _moveItemsToRemoteCart(String uid) async {
    try {
      // get the local starred data
      final localStarredRepository = ref.read(localStarredRepositoryProvider);
      final localStarred = await localStarredRepository.fetchStarred();
      if (localStarred.items.isNotEmpty) {
        // get the remote starred data
        final remoteStarredRepository =
            ref.read(remoteStarredRepositoryProvider);
        final remoteStarred = await remoteStarredRepository.fetchStarred(uid);
        // add all the local starred items to the remote starred
        final updatedRemoteStarred = remoteStarred.addStarredItems(
          localStarred.toStarredItemsList(),
        );
        // write the updated remote starred data to the repository
        await remoteStarredRepository.setStarred(uid, updatedRemoteStarred);
        // remove all the items from the local starred
        await localStarredRepository.setStarred(const Starred());
      }
    } catch (e) {
      //ref.read(errorLoggerProvider).logError(e, st);
    }
  }
}

final starredSyncServiceProvider = Provider<StarredSyncService>(
  (ref) {
    return StarredSyncService(ref);
  },
);
