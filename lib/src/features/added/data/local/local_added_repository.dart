import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/added/domain/added.dart';

abstract class LocalAddedRepository {
  /// API for reading, watching and writing local added data (guest user)
  Future<Added> fetchAdded();

  Stream<Added> watchAdded();

  Future<void> setAdded(Added added);
}

final localAddedRepositoryProvider = Provider<LocalAddedRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);
