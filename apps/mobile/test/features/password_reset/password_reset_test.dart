// Fase RED (T01): estes testes DEVEM falhar — as classes ainda não existem.
// Spec: _specs/features/recuperacao-senha.md
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/features/password_reset/data/password_reset_exceptions.dart';
import 'package:mobile_app/features/password_reset/domain/password_reset_repository.dart';
import 'package:mobile_app/features/password_reset/presentation/reset_password_notifier.dart';
import 'package:mocktail/mocktail.dart';

class _MockRepo extends Mock implements PasswordResetRepository {}

void main() {
  group('requestReset', () {
    test('e-mail com formato inválido lança InvalidEmail', () async {
      final repo = _MockRepo();
      when(() => repo.requestReset('not-an-email'))
          .thenThrow(InvalidEmail());

      await expectLater(
        () => repo.requestReset('not-an-email'),
        throwsA(isA<InvalidEmail>()),
      );
    });

    test('falha de rede lança NetworkFailure', () async {
      final repo = _MockRepo();
      when(() => repo.requestReset('user@mail.com'))
          .thenThrow(NetworkFailure());

      await expectLater(
        () => repo.requestReset('user@mail.com'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test('e-mail válido e normalizado completa sem erro', () async {
      final repo = _MockRepo();
      when(() => repo.requestReset('user@mail.com'))
          .thenAnswer((_) async {});

      await expectLater(repo.requestReset('user@mail.com'), completes);
      verify(() => repo.requestReset('user@mail.com')).called(1);
    });
  });

  group('confirmReset', () {
    test('token expirado ou usado lança ExpiredToken', () async {
      final repo = _MockRepo();
      when(() => repo.confirmReset('expired-token', 'Senha123'))
          .thenThrow(ExpiredToken());

      await expectLater(
        () => repo.confirmReset('expired-token', 'Senha123'),
        throwsA(isA<ExpiredToken>()),
      );
    });

    test('senha fraca lança WeakPassword', () async {
      final repo = _MockRepo();
      when(() => repo.confirmReset('valid-token', '123'))
          .thenThrow(WeakPassword());

      await expectLater(
        () => repo.confirmReset('valid-token', '123'),
        throwsA(isA<WeakPassword>()),
      );
    });

    test('token válido e senha forte completa sem erro', () async {
      final repo = _MockRepo();
      when(() => repo.confirmReset('valid-token', 'Senha123'))
          .thenAnswer((_) async {});

      await expectLater(
        repo.confirmReset('valid-token', 'Senha123'),
        completes,
      );
    });
  });

  group('ResetPasswordNotifier (4 estados)', () {
    test('solicitação válida emite AsyncData (SuccessState)', () async {
      final repo = _MockRepo();
      when(() => repo.requestReset(any())).thenAnswer((_) async {});
      final container = ProviderContainer(
        overrides: [passwordResetRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(resetPasswordNotifierProvider.notifier)
          .requestReset('user@mail.com');

      expect(container.read(resetPasswordNotifierProvider),
          isA<AsyncData<void>>());
    });

    test('e-mail inválido emite AsyncError (ErrorState)', () async {
      final repo = _MockRepo();
      when(() => repo.requestReset(any())).thenThrow(InvalidEmail());
      final container = ProviderContainer(
        overrides: [passwordResetRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container
          .read(resetPasswordNotifierProvider.notifier)
          .requestReset('bad');

      expect(container.read(resetPasswordNotifierProvider), isA<AsyncError>());
      expect(
        container.read(resetPasswordNotifierProvider).error,
        isA<InvalidEmail>(),
      );
    });
  });
}
