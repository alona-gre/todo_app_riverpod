import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/starred/data/local/local_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/data/remote/remote_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/mutable_starred.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starredItem.dart';

class StarredService {
  final Ref ref;
  StarredService(this.ref);

  /// fetch the Starred from remote or local repository
  /// depending on the user auth state
  Future<Starred> _fetchStarred() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteStarredRepositoryProvider).fetchStarred(user.uid);
    } else {
      return ref.read(localStarredRepositoryProvider).fetchStarred();
    }
  }

  /// sets the Starred to remote or local repository
  /// depending on the user auth state
  Future<void> _setStarred(Starred starred) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref
          .read(remoteStarredRepositoryProvider)
          .setStarred(user.uid, starred);
    } else {
      await ref.read(localStarredRepositoryProvider).setStarred(starred);
    }
  }

  /// adds a product to starred in remote or local repository
  /// depending on the user auth state
  Future<void> setStarredProduct(StarredItem starredItem) async {
    final starred = await _fetchStarred();
    final updatedStarred = starred.setStarredItem(starredItem);
    await _setStarred(updatedStarred);
  }

  // removes a Product from starred in remote or local repository
  // depending on the user auth state
  Future<void> removeStarredProduct(StarredItem starredItem) async {
    final starred = await _fetchStarred();
    final updatedStarred = starred.removeFromStarredById(starredItem.taskId);
    await _setStarred(updatedStarred);
  }

  // removes a Product from starred in remote or local repository
  // depending on the user auth state
  Future<void> removeStarredProductById(TaskID productId) async {
    final starred = await _fetchStarred();
    final updatedStarred = starred.removeFromStarredById(productId);
    await _setStarred(updatedStarred);
  }
}

final starredServiceProvider = Provider<StarredService>(
  (ref) {
    return StarredService(ref);
  },
);

final starredProvider = StreamProvider<Starred>(
  (ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteStarredRepositoryProvider).watchStarred(user.uid);
    } else {
      return ref.read(localStarredRepositoryProvider).watchStarred();
    }
  },
);

final starredItemsCountProvider = Provider<int>((ref) {
  return ref.watch(starredProvider).maybeMap(
        data: (cart) => cart.value.items.length,
        orElse: () => 0,
      );
});

final isStarredProvider = Provider.family<bool, TaskID>((ref, productId) {
  final starred = ref.watch(starredProvider).value ?? const Starred();

  return starred.items[productId] ?? false;
});
