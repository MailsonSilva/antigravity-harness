---
name: flutter-apply-architecture-best-practices
description: Convenções de código Dart 3, imutabilidade, composição Services → Repositories → AsyncNotifier e workflow de implementação de feature em 8 passos. NÃO use para definir topologia de pastas Clean Architecture ou pureza de domínio (use clean-architecture).
category: Arquitetura & Domínio
---

# Skill: Convenções de Implementação Flutter & Fluxo de Feature

## 1. Quando Acionar Esta Skill
- Ao implementar uma feature passo a passo após os contratos de `clean-architecture` estarem definidos.
- Ao padronizar Services, Repositories concretos e State Holders (`AsyncNotifier`) em Dart 3.
- Ao revisar imutabilidade, injeção de dependência e separação entre View e lógica de estado.
- NÃO acione quando: precisar definir fronteiras de `domain/`/`data/`/`presentation/` ou modelar `Result<T>` (use `clean-architecture`), nem para regras específicas de `build_runner` (use `flutter-code-generation`).

## 2. Arquitetura e Diretrizes Técnicas
1. **Papéis de Execução (sem sobrepor camadas)**:
   - **Views (`pages/`, `widgets/`)**: widgets enxutos com `const` sempre que possível; apenas layout, animação e despacho de ações ao Notifier.
   - **State Holders (`AsyncNotifier`)**: expõem `AsyncValue` (casando com Loading, Empty, Error e Success) e recebem repositórios via `ref.read(...)`.
   - **Services**: classes sem estado que encapsulam I/O externo (HTTP/Dio, SQLite, plugins) e retornam DTOs/Models crus.
   - **Repositories (Implementação)**: orquestram Services, aplicam cache/retry/offline e expõem apenas entidades ou `Result<T>`.
   - **Use Cases (Opcional)**: crie apenas quando houver regra reutilizada entre múltiplas features ou orquestração complexa; CRUD simples vai direto do Notifier ao Repositório.
2. **Workflow Operacional de Feature (8 Passos + TDD)**:
   - [ ] 1. Entidades imutáveis (`const`, `final`) em `domain/`.
   - [ ] 2. Interfaces de repositório em `domain/` (base para os testes RED).
   - [ ] 3. Services de I/O em `data/` ou `core/`.
   - [ ] 4. Repositórios concretos em `data/` com mapeamento para domínio.
   - [ ] 5. `DomainService`/UseCase (somente se houver regra complexa ou reuso).
   - [ ] 6. `AsyncNotifier` (Riverpod) injetando o repositório.
   - [ ] 7. View observando o provider e tratando os 4 estados de UI.
   - [ ] 8. Gate verde: `.agents/scripts/verify.ps1` (ou `verify.sh`).

## 3. Código Canônico (Dart 3 / Flutter)
```dart
// data/repositories/user_repository_impl.dart
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._api);

  final UserApiService _api;
  User? _cached;

  @override
  Future<User> getUser(String id) async {
    final cached = _cached;
    if (cached != null && cached.id == id) return cached;
    final dto = await _api.fetchUser(id);
    return _cached = dto.toEntity();
  }
}

// presentation/controllers/profile_notifier.dart
class ProfileNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() => null;

  Future<void> load(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).getUser(id),
    );
  }
}
```

## 4. Antipadrões Proibidos
- ❌ Misturar chamadas de `Dio`/`Database` diretamente dentro de Widgets ou `AsyncNotifier` pulando o Repositório.
- ❌ Criar `UseCase` pass-through para todo método trivial de CRUD.
- ❌ Usar campos mutáveis sem `final` em entidades e estados.
