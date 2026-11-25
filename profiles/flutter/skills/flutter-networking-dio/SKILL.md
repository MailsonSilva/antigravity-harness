---
name: flutter-networking-dio
description: Padrão principal de camada de rede em produção com Dio (timeouts, QueuedInterceptorsWrapper para auth/refresh token, retry, tratamento tipado de DioException e logs seguros). Use para APIs REST em apps de produção.
category: Dados & Rede
---

# Skill: Networking de Produção com Dio

## 1. Quando Acionar Esta Skill
- Como **padrão principal** para consumo de APIs REST em produção (autenticação Bearer, refresh token automático, interceptors, retry, upload/download e cancelamento).
- Ao mapear erros HTTP/rede (`DioException`) para falhas tipadas de domínio.
- NÃO acione quando: o app precisar apenas de 1–2 chamadas GET/POST triviais sem autenticação ou interceptors (use `flutter-use-http-package`), ou quando o backend for exclusivamente SDK Supabase (`supabase-flutter`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Cliente Centralizado (`core/network/dio_client.dart`)**:
   - Configure `BaseOptions` com `baseUrl` via `AppEnv`, `connectTimeout`, `receiveTimeout` e `sendTimeout` explícitos (ex.: 15s).
2. **Autenticação & Refresh Seguro (`QueuedInterceptorsWrapper`)**:
   - Use `QueuedInterceptorsWrapper` (nunca `InterceptorsWrapper` comum) para refresh token, evitando múltiplas chamadas simultâneas de `/refresh` quando várias requisições recebem `401` ao mesmo tempo.
3. **Retry Controlado & Erros Tipados**:
   - Aplique retry com *backoff* apenas para métodos idempotentes (`GET`) em timeouts/falhas transitórias (`502`, `503`, `504`).
   - Converta `DioException` em `NetworkFailure` tipada (timeout, sem conexão, 401, 4xx, 5xx) antes de cruzar para `domain/`.
4. **Logs Seguros**:
   - Habilite logs apenas em `dev` (`AppEnv.enableLogs`) e mascare obrigatoriamente headers sensíveis (`Authorization`, `Cookie`, `x-api-key`) e campos de senha no body.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// core/network/auth_interceptor.dart
import 'package:dio/dio.dart';

class AuthInterceptor extends QueuedInterceptorsWrapper {
  AuthInterceptor({
    required Future<String?> Function() readToken,
    required Future<String?> Function() refreshToken,
    required Dio retryDio,
  })  : _readToken = readToken,
        _refreshToken = refreshToken,
        _retryDio = retryDio;

  final Future<String?> Function() _readToken;
  final Future<String?> Function() _refreshToken;
  final Dio _retryDio;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final alreadyRetried = err.requestOptions.extra['_retried'] == true;
    if (err.response?.statusCode == 401 && !alreadyRetried) {
      final newToken = await _refreshToken();
      if (newToken != null && newToken.isNotEmpty) {
        final opts = err.requestOptions..extra['_retried'] = true;
        opts.headers['Authorization'] = 'Bearer $newToken';
        try {
          final response = await _retryDio.fetch(opts);
          return handler.resolve(response);
        } on DioException catch (retryErr) {
          return handler.next(retryErr);
        }
      }
    }
    handler.next(err);
  }
}
```

## 4. Antipadrões Proibidos
- ❌ Imprimir token JWT, senha ou payload sensível em `LogInterceptor(requestHeader: true)` em produção.
- ❌ Usar `InterceptorsWrapper` comum para refresh token causando loop infinito de `401` ou múltiplas renovações paralelas.
- ❌ Instanciar `Dio()` dentro de Widgets/Notifiers ou deixar timeouts infinitos.
- ❌ Vazar `DioException` crua para a camada `domain/` ou `presentation/`.
