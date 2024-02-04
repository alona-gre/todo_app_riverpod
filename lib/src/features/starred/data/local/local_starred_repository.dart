import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/starred/domain/starred.dart';

abstract class LocalStarredRepository {
  /// API for reading, watching and writing local starred data (guest user)
  Future<Starred> fetchStarred();

  Stream<Starred> watchStarred();

  Future<void> setStarred(Starred starred);
}

final localStarredRepositoryProvider = Provider<LocalStarredRepository>(
  (ref) {
    // * Override this in the main method
    throw UnimplementedError();
  },
);
