import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';

class SyncService {
  final Ref ref;

  SyncService(this.ref) {
    _init();
  }

  void _init() {
    ref.listen<AsyncValue<AppUser?>>(authStateChangesProvider,
        (previous, next) {
      final previousUser = previous?.value;
      final user = next.value;
      if (previousUser == null && user != null) {
        debugPrint('signed in: ${user.uid}');
      }
    });
  }
}

final syncServiceProvider = Provider<SyncService>(
  (ref) {
    return SyncService(ref);
  },
);
