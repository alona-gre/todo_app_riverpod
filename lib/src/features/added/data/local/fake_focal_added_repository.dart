import 'package:riverpod_todo_app/src/features/added/data/local/local_added_repository.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeLocalAddedRepository implements LocalAddedRepository {
  final bool addDelay;

  FakeLocalAddedRepository({this.addDelay = true});

  final _added = InMemoryStore<Added>(const Added());

  /// we fetch the latest version of the Added
  @override
  Future<Added> fetchAdded() => Future.value(_added.value);

  /// we watch the changes to the Added
  @override
  Stream<Added> watchAdded() => _added.stream;

  /// we set a new value of the Added
  @override
  Future<void> setAdded(Added added) async {
    await delay(addDelay);
    _added.value = added;
  }
}
