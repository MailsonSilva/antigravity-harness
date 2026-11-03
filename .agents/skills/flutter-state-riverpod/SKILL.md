---
name: flutter-state-riverpod
description: Gerenciamento de estado reativo, previsível e testável em Flutter usando Riverpod (Notifier, AsyncNotifier, paginação e descarte automático).
category: Engenharia Mobile
---

# Skill: Reactive State Management com Riverpod

## 1. Diretrizes Técnicas
1. **Prefira `AsyncNotifier` e `Notifier`**: Evite `StateNotifierProvider` e `ChangeNotifierProvider` legados.
2. **Imutabilidade**: O estado exposto deve ser imutável (`final` fields + método `copyWith`).
3. **Sem Lógica de UI no Notifier**: Nunca passe `BuildContext`, `TextEditingController` ou `Navigator` para dentro de um Notifier.
4. **Uso de `ref.watch` vs `ref.read`**:
   - Dentro do método `build()`: use SEMPRE `ref.watch(provider)`.
   - Dentro de callbacks (`onPressed`, `onSubmitted`): use SEMPRE `ref.read(provider.notifier).acao()`.

## 2. Padrão Canônico de State Imutável
```dart
class CatalogoState {
  final List<ProdutoEntity> itens;
  final bool carregandoMais;
  final bool temMais;
  final String termoBusca;

  const CatalogoState({
    this.itens = const [],
    this.carregandoMais = false,
    this.temMais = true,
    this.termoBusca = '',
  });

  CatalogoState copyWith({
    List<ProdutoEntity>? itens,
    bool? carregandoMais,
    bool? temMais,
    String? termoBusca,
  }) {
    return CatalogoState(
      itens: itens ?? this.itens,
      carregandoMais: carregandoMais ?? this.carregandoMais,
      temMais: temMais ?? this.temMais,
      termoBusca: termoBusca ?? this.termoBusca,
    );
  }
}
```
