import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/password_reset_repository.dart';

/// Repositório injetável (sobrescrito no app real e nos testes).
final passwordResetRepositoryProvider = Provider<PasswordResetRepository>(
  (_) => throw UnimplementedError(
      'Sobrescreva passwordResetRepositoryProvider na inicialização.'),
);

/// State holder da recuperação de senha.
/// O [AsyncValue] mapeia direto para os 4 estados de tela:
/// loading → LoadingState, error → ErrorState, data → SuccessState.
final resetPasswordNotifierProvider =
    AsyncNotifierProvider<ResetPasswordNotifier, void>(
  ResetPasswordNotifier.new,
);

class ResetPasswordNotifier extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {}

  Future<void> requestReset(String email) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(passwordResetRepositoryProvider).requestReset(email),
    );
  }
}
