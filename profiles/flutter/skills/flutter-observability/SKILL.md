---
name: flutter-observability
description: Observabilidade em produção com captura global de erros (FlutterError.onError e PlatformDispatcher.instance.onError), Sentry ou Crashlytics por flavor, breadcrumbs e retroalimentação para HARNESS_FEEDBACK.md e PROJECT_BRAIN.md.
category: Observabilidade & Pós-Deploy
---

# Skill: Observabilidade, Crash Reporting & Retroalimentação

## 1. Quando Acionar Esta Skill
- Ao estruturar o `main.dart` e o tratamento global de exceções não capturadas em Flutter.
- Ao integrar Sentry (`sentry_flutter`) ou Firebase Crashlytics por flavor (`staging`/`prod`) com breadcrumbs de navegação.
- Ao analisar bugs ou crashes de produção para transformar a causa raiz em guardrail do projeto e do harness.
- NÃO acione quando: tratar apenas erros locais esperados de UI/formulário (`clean-architecture` com `Result<T>`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Captura Global Obrigatória no Bootstrap (`main.dart`)**:
   - Configure `FlutterError.onError` para erros síncronos do framework de widgets.
   - Configure `PlatformDispatcher.instance.onError` para erros assíncronos não capturados (retornando `true` após enviar ao reporter).
2. **Isolamento por Flavor & Privacidade (LGPD/PII)**:
   - Desative envio remoto em `dev` (logue no console); habilite apenas em `staging` e `prod` com `environment: AppEnv.flavor`.
   - Registre breadcrumbs de navegação (`NavigatorObserver` / `GoRouter` observer) e ID anônimo/opaco do usuário — **nunca** envie CPF, e-mail completo, tokens ou senhas em tags/breadcrumbs.
3. **Retroalimentação Pós-Deploy (Loop de Aprendizado)**:
   - Ao corrigir um crash real de produção:
     1. Adicione teste de regressão reproduzindo a falha (TDD).
     2. Registre o invariante/causa raiz em `.agents/PROJECT_BRAIN.md`.
     3. Se a falha veio de lacuna em alguma skill/workflow, registre uma sugestão (`Status: pendente`) em `.agents/HARNESS_FEEDBACK.md`.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// lib/core/observability/crash_reporter.dart
import 'dart:ui';

import 'package:flutter/foundation.dart';

abstract interface class CrashReporter {
  Future<void> recordError(Object error, StackTrace stack, {bool fatal = false});
  void addBreadcrumb(String message, {Map<String, Object?> data = const {}});
}

void setupGlobalErrorHandlers(CrashReporter reporter) {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    reporter.recordError(
      details.exception,
      details.stack ?? StackTrace.current,
      fatal: true,
    );
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    reporter.recordError(error, stack, fatal: true);
    return true;
  };
}
```

## 4. Antipadrões Proibidos
- ❌ Enviar eventos de crash de ambiente `dev` poluindo o painel de `prod`.
- ❌ Anexar tokens Bearer, senhas ou dados pessoais (PII) em logs/breadcrumbs/extras do Sentry ou Crashlytics.
- ❌ Engolir exceções críticas no `PlatformDispatcher.onError` retornando `true` sem registrar ou reportar.
- ❌ Corrigir bug recorrente de produção sem adicionar teste de regressão e atualizar `.agents/PROJECT_BRAIN.md`.
