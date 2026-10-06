// Contrato do repositório de recuperação de senha (camada Domain, Dart puro).
// Implementado pela camada Data; consumido via Riverpod, nunca pelo widget.

abstract class PasswordResetRepository {
  /// Solicita o link de redefinição. Lança [InvalidEmail] ou [NetworkFailure].
  Future<void> requestReset(String email);

  /// Confirma a redefinição com token + nova senha.
  /// Lança [ExpiredToken], [WeakPassword] ou [NetworkFailure].
  Future<void> confirmReset(String token, String newPassword);
}
