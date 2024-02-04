import 'package:riverpod_todo_app/src/features/starred/data/remote/remote_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeRemoteStarredRepository implements RemoteStarredRepository {
  final bool addDelay;

  FakeRemoteStarredRepository({this.addDelay = true});

  /// An InMemoryStore containing the shopping cart data for all users, where:
  /// key: uid of the user,
  /// value: Starred of that user
  final _wishlists = InMemoryStore<Map<String, Starred>>({});

  @override
  Future<Starred> fetchStarred(String uid) {
    return Future.value(_wishlists.value[uid] ?? const Starred());
  }

  @override
  Stream<Starred> watchStarred(String uid) {
    return _wishlists.stream
        .map((wishlistData) => wishlistData[uid] ?? const Starred());
  }

  @override
  Future<void> setStarred(String uid, Starred wishlist) async {
    await delay(addDelay);
    // First, get the current wishlists data for all users
    final wishlists = _wishlists.value;
    // Then, set the wishlist for the given uid
    wishlists[uid] = wishlist;
    // Finally, update the wishlists data (will emit a new value)
    _wishlists.value = wishlists;
  }
}
