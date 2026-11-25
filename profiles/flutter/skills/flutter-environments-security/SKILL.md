---
name: flutter-environments-security
description: Configuração de múltiplos ambientes (dev, staging, prod) com --dart-define-from-file, flavors Android/iOS e proteção de secrets no .gitignore. Use ao configurar builds, variáveis de ambiente ou credenciais no app Flutter.
category: Segurança & Infraestrutura
---

# Skill: Ambientes, Flavors & Segurança Mobile

## 1. Quando Acionar Esta Skill
- Ao configurar ambientes separados (`dev`, `staging`, `prod`) com URLs, chaves públicas ou feature flags distintas.
- Ao estruturar flavors no Android (`productFlavors`) e schemes no iOS (`Runner.xcodeproj` / `.xcconfig`).
- Ao revisar `.gitignore` e impedir vazamento de chaves de assinatura ou tokens no repositório.
- NÃO acione quando: a tarefa for apenas chamada HTTP de endpoint já configurado (`flutter-networking-dio`) ou pipeline de publicação em loja (`store-publishing`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Injeção de Variáveis em Tempo de Compilação**:
   - Use arquivos JSON por ambiente fora do controle de versão: `env/dev.json`, `env/staging.json`, `env/prod.json` (versionando apenas `env/example.json`).
   - Execute e compile com `--dart-define-from-file=env/dev.json` e `--flavor dev`.
   - Leia valores exclusivamente via `const String.fromEnvironment(...)` e `const bool.fromEnvironment(...)` em `lib/core/config/app_env.dart`.
2. **Flavors Nativos (Android & iOS)**:
   - **Android (`android/app/build.gradle.kts`)**: defina `flavorDimensions += "app"` com `productFlavors` (`dev`, `staging`, `prod`), `applicationIdSuffix` (`.dev`, `.stg`) e nomes distintos no app.
   - **iOS (`ios/Runner.xcodeproj`)**: crie Schemes `dev`, `staging` e `prod` apontando para configurações `.xcconfig` próprias com `PRODUCT_BUNDLE_IDENTIFIER` isolado.
3. **Guardrails Rígidos de Segurança (`.gitignore`)**:
   - Bloqueie obrigatoriamente no `.gitignore`: `env/*.json` (exceto `!env/example.json`), `.env*`, `android/key.properties`, `*.jks`, `*.keystore`, `*.p12`, `*.mobileprovision`, `GoogleService-Info.plist` / `google-services.json` sensíveis quando não públicos.
   - Dados sensíveis em runtime (tokens JWT, refresh tokens) vão para `flutter_secure_storage`, nunca em `SharedPreferences` ou código Dart.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// lib/core/config/app_env.dart
abstract final class AppEnv {
  static const String flavor = String.fromEnvironment(
    'APP_FLAVOR',
    defaultValue: 'dev',
  );

  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static const bool enableLogs = bool.fromEnvironment(
    'ENABLE_LOGS',
    defaultValue: false,
  );

  static void validate() {
    if (apiBaseUrl.isEmpty) {
      throw StateError(
        'API_BASE_URL não definida. Execute com --dart-define-from-file=env/<flavor>.json',
      );
    }
  }
}
```

## 4. Antipadrões Proibidos
- ❌ Fazer commit de `.env`, `env/prod.json`, `key.properties`, `.jks` ou `.p12` no Git.
- ❌ Colocar chaves de API privadas, segredos OAuth ou senhas hardcoded em arquivos `.dart`.
- ❌ Usar `flutter_dotenv` empacotando `.env` dentro de `assets:` no `pubspec.yaml` para segredos de produção.
- ❌ Apontar ambiente `dev` para a URL/banco de `prod` por falta de validação de flavor.
