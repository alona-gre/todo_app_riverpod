import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/added/domain/mutable_added_tasks.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/tasks/domain/task.dart';
import 'package:riverpod_todo_app/src/features/added/data/local/local_added_repository.dart';
import 'package:riverpod_todo_app/src/features/added/data/remote/remote_added_repository.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';
import 'package:riverpod_todo_app/src/features/added/domain/addedItem.dart';

class AddedService {
  final Ref ref;
  AddedService(this.ref);

  /// fetch the Added from remote or local repository
  /// depending on the user auth state
  Future<Added> _fetchAdded() {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      return ref.read(remoteAddedRepositoryProvider).fetchAdded(user.uid);
    } else {
      return ref.read(localAddedRepositoryProvider).fetchAdded();
    }
  }

  /// sets the Added to remote or local repository
  /// depending on the user auth state
  Future<void> _setAdded(Added added) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user != null) {
      await ref.read(remoteAddedRepositoryProvider).setAdded(user.uid, added);
    } else {
      await ref.read(localAddedRepositoryProvider).setAdded(added);
    }
  }

  /// adds a product to added in remote or local repository
  /// depending on the user auth state
  Future<void> setAddedProduct(AddedItem addedItem) async {
    final added = await _fetchAdded();
    final updatedAdded = added.addItem(addedItem);
    await _setAdded(updatedAdded);
  }

  // // removes a Product from added in remote or local repository
  // // depending on the user auth state
  // Future<void> removeAddedProduct(AddedItem addedItem) async {
  //   final added = await _fetchAdded();
  //   final updatedAdded = added.removeFromAddedById(addedItem.taskId);
  //   await _setAdded(updatedAdded);
  // }

  // // removes a Product from added in remote or local repository
  // // depending on the user auth state
  // Future<void> removeAddedProductById(TaskID productId) async {
  //   final added = await _fetchAdded();
  //   final updatedAdded = added.removeFromAddedById(productId);
  //   await _setAdded(updatedAdded);
  // }
}

final addedServiceProvider = Provider<AddedService>(
  (ref) {
    return AddedService(ref);
  },
);

final addedProvider = StreamProvider<Added>(
  (ref) {
    final user = ref.watch(authStateChangesProvider).value;
    if (user != null) {
      return ref.read(remoteAddedRepositoryProvider).watchAdded(user.uid);
    } else {
      return ref.read(localAddedRepositoryProvider).watchAdded();
    }
  },
);

final addedItemsCountProvider = Provider<int>((ref) {
  return ref.watch(addedProvider).maybeMap(
        data: (cart) => cart.value.items.length,
        orElse: () => 0,
      );
});

final isAddedProvider = Provider.family<Task?, TaskID>((ref, productId) {
  final added = ref.watch(addedProvider).value ?? const Added();

  return added.items[productId];
});
