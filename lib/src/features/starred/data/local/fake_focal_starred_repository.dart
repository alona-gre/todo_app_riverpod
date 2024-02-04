import 'package:riverpod_todo_app/src/features/starred/data/local/local_starred_repository.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';
import 'package:riverpod_todo_app/src/utils/delay.dart';
import 'package:riverpod_todo_app/src/utils/in_memory_store.dart';

class FakeLocalStarredRepository implements LocalStarredRepository {
  final bool addDelay;

  FakeLocalStarredRepository({this.addDelay = true});

  final _starred = InMemoryStore<Starred>(const Starred());

  /// we fetch the latest version of the Starred
  @override
  Future<Starred> fetchStarred() => Future.value(_starred.value);

  /// we watch the changes to the Starred
  @override
  Stream<Starred> watchStarred() => _starred.stream;

  /// we set a new value of the Starred
  @override
  Future<void> setStarred(Starred starred) async {
    await delay(addDelay);
    _starred.value = starred;
  }
}
