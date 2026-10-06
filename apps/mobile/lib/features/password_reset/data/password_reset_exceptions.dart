/// Exceções do fluxo de recuperação de senha (camada Data).
/// Lançadas pelo [PasswordResetRepository] e mapeadas para ErrorState na UI.

/// E-mail com formato inválido (validação local antes do envio).
class InvalidEmail implements Exception {
  const InvalidEmail();
}

/// Falha de conectividade ou erro inesperado de rede/servidor.
class NetworkFailure implements Exception {
  const NetworkFailure();
}

/// Link de redefinição expirado ou já utilizado.
class ExpiredToken implements Exception {
  const ExpiredToken();
}

/// Nova senha abaixo da política mínima (8+ caracteres, letra e número).
class WeakPassword implements Exception {
  const WeakPassword();
}
