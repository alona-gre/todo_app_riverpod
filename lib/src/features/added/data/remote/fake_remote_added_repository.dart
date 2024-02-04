import 'package:riverpod_todo_app/src/features/added/data/remote/remote_added_repository.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeRemoteAddedRepository implements RemoteAddedRepository {
  final bool addDelay;

  FakeRemoteAddedRepository({this.addDelay = true});

  /// An InMemoryStore containing the shopping cart data for all users, where:
  /// key: uid of the user,
  /// value: Added of that user
  final _addedTasks = InMemoryStore<Map<String, Added>>({});

  @override
  Future<Added> fetchAdded(String uid) {
    return Future.value(_addedTasks.value[uid] ?? const Added());
  }

  @override
  Stream<Added> watchAdded(String uid) {
    return _addedTasks.stream
        .map((wishlistData) => wishlistData[uid] ?? const Added());
  }

  @override
  Future<void> setAdded(String uid, Added wishlist) async {
    await delay(addDelay);
    // First, get the current wishlists data for all users
    final wishlists = _addedTasks.value;
    // Then, set the wishlist for the given uid
    wishlists[uid] = wishlist;
    // Finally, update the wishlists data (will emit a new value)
    _addedTasks.value = wishlists;
  }
}
