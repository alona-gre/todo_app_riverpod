import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod_todo_app/src/features/authentication/data/fake_auth_repository.dart';
import 'package:riverpod_todo_app/src/features/authentication/domain/app_user.dart';

void main() {
  const testEmail = 'test@test.com';
  const password = '123456789';
  final testUser = AppUser(
    email: testEmail,
    uid: testEmail.split('').reversed.join(),
  );

  group(
    'FakeAuthRepository',
    () {
      FakeAuthRepository makeAuthRepository() =>
          FakeAuthRepository(hasDelay: false);
      test('current user is null', () async {
        final authRepository = makeAuthRepository();
        addTearDown(authRepository.dispose);
        expect(authRepository.currentUser, null);
        expect(authRepository.authStateChanges(), emits(null));
      });
      test('current user is  not null after signIn', () async {
        final authRepository = makeAuthRepository();
        await authRepository.signInWithEmailAndPassword(
          testEmail,
          password,
        );
        expect(
          authRepository.currentUser,
          testUser,
        );
        expect(authRepository.authStateChanges(), emits(testUser));
      });

      test('current user is  not null after creating account', () async {
        final authRepository = makeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.createUserWithEmailAndPassword(
          testEmail,
          password,
        );
        expect(
          authRepository.currentUser,
          testUser,
        );
        expect(authRepository.authStateChanges(), emits(testUser));
      });

      test('current user is null after signOut', () async {
        final authRepository = makeAuthRepository();
        addTearDown(authRepository.dispose);
        await authRepository.signInWithEmailAndPassword(
          testEmail,
          password,
        );
        expect(authRepository.currentUser, testUser);
        expect(authRepository.authStateChanges(), emits(testUser));

        await authRepository.signOut();
        expect(authRepository.currentUser, null);
        expect(authRepository.authStateChanges(), emits(null));
      });

      test('signIn after dispose  throws an error', () async {
        final authRepository = makeAuthRepository();
        authRepository.dispose();

        expect(
            () =>
                authRepository.signInWithEmailAndPassword(testEmail, password),
            throwsStateError);
      });
    },
  );
}
