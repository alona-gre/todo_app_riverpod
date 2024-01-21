import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';

class AccountScreenController extends StateNotifier<AsyncValue<void>> {
  final FakeAuthRepository authRepository;

  AccountScreenController({required this.authRepository})
      : super(const AsyncData<void>(null));

  Future<void> signOut() async {
    // set state to loading
    // sign out(using auth repository) via AsyncValue.guard(()

    state = const AsyncLoading();
    state = await AsyncValue.guard(() => authRepository.signOut());
  }
}

final accountScreenControllerProvider = StateNotifierProvider.autoDispose<
    AccountScreenController, AsyncValue<void>>((ref) {
  final authRepository = ref.watch(authRepositoryProvider);
  return AccountScreenController(authRepository: authRepository);
});
