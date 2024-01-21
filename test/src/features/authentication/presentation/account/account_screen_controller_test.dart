import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:riverpod_todo_app/src/features/authentication/presentation/account/account_screen_controller.dart';

import '../../../../mocks.dart';

void main() {
  late MockAuthRepository authRepository;
  late AccountScreenController controller;
  setUp(() {
    authRepository = MockAuthRepository();
    controller = AccountScreenController(authRepository: authRepository);
  });

  group('AccountScreenController', () {
    test('initial state is AsyncValue.data', () {
      // setup

      // verify
      verifyNever(authRepository.signOut);
      expect(controller.state, const AsyncData<void>(null));
    });

    test(
      'signOut success',
      () async {
        // setup

        when(authRepository.signOut).thenAnswer(
          (_) => Future.value(),
        );

        expectLater(
          controller.stream,
          emitsInOrder(const [
            AsyncLoading<void>(),
            AsyncData<void>(null),
          ]),
        );

        // run
        await controller.signOut();

        // verify
        expect(controller.state, const AsyncData<void>(null));
        verify(authRepository.signOut).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );

    test(
      'signOut throws an error',
      () async {
        // set up

        final exception = Exception('Connection failed');

        when(authRepository.signOut).thenThrow(exception);
        expectLater(
          controller.stream,
          emitsInOrder([
            const AsyncLoading<void>(),
            predicate<AsyncValue<void>>((value) {
              expect(value.hasError, true);
              return true;
            }),
          ]),
        );

        // run
        await controller.signOut();

        // verify
        expect(
          controller.state.hasError,
          true,
        );
        verify(authRepository.signOut).called(1);
      },
      timeout: const Timeout(Duration(milliseconds: 500)),
    );
  });
}
