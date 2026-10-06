# Spec: Recuperação de senha por e-mail (T01)

> Tarefa: `_specs/tasks/T01-recuperacao-senha.md` · Target: mobile · Plataformas: android + ios

## 1. Objetivo
Permitir que o usuário bloqueado por esquecimento de senha solicite um link de redefinição por e-mail e defina uma nova senha dentro do prazo de validade.

## 2. Regras de Negócio
- E-mail deve ter formato válido; normalizar (trim + lowercase) antes de enviar.
- Link de redefinição com expiração de 1 hora e uso único.
- Resposta do backend nunca revela se o e-mail está cadastrado (mensagem genérica), mas o app registra o evento para auditoria.
- Nova senha: mínimo 8 caracteres, com ao menos 1 letra e 1 número.

## 3. Critérios de Aceitação Obrigatórios
- [ ] **Sucesso**: e-mail válido → mensagem genérica de confirmação ("Se o e-mail estiver cadastrado, você receberá o link") e retorno ao login.
- [ ] **Loading**: skeleton/botão com spinner e bloqueio de reenvio durante a chamada.
- [ ] **Empty**: n/a (formulário sempre renderiza); campo vazio com validação inline ao submeter.
- [ ] **Erro**: e-mail inválido → mensagem inline em pt-BR; falha de rede → ErrorState com "Tentar novamente"; link expirado/usado → tela de erro com CTA "Solicitar novo link".
- [ ] **Redefinição**: link válido abre tela de nova senha; após salvar, sessão é invalidada em outros dispositivos.

## 4. Contratos (para a Fase RED)
- `PasswordResetRepository.requestReset(email: String): Future<void>` — lança `InvalidEmail`, `NetworkFailure`.
- `PasswordResetRepository.confirmReset(token: String, newPassword: String): Future<void>` — lança `ExpiredToken`, `WeakPassword`, `NetworkFailure`.
- `ResetPasswordNotifier : AsyncNotifier<void>` (Riverpod) expondo `AsyncValue` para os 4 estados.
