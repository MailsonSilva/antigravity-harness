---
name: mobile-ux
description: Usabilidade mobile, os 4 estados obrigatórios de tela (Loading, Empty, Error, Success), ergonomia de toque (48dp) e micro-interações em Flutter. NÃO use para arquitetura de tokens ou ThemeData/ThemeExtension (use flutter-design-system).
category: UI/UX & Frontend
---

# Skill: Mobile UX & Ergonomia de Interação

## 1. Quando Acionar Esta Skill
- Ao desenhar ou revisar fluxos de tela, formulários, listas, BottomSheets e micro-interações de usuário.
- Ao garantir tratamento completo dos 4 estados visuais, acessibilidade e ergonomia de toque (`48x48dp`).
- NÃO acione quando: o foco for definir paleta, tipografia, `ThemeData` ou `ThemeExtension` em `lib/core/theme/` (use **`flutter-design-system`**).

## 2. Arquitetura e Diretrizes Técnicas
1. **Os 4 Estados Obrigatórios de Qualquer Tela ou BottomSheet:**
   - **Loading**: Skeleton / Shimmer que preserva a geometria do card real, evitando *Layout Shift*.
   - **Empty (Vazio)**: Ícone semântico, título claro ("Nenhum item encontrado para 'X'") e CTA para inclusão ou limpeza de filtros.
   - **Error (Falha)**: Mensagem amigável em pt-BR + botão obrigatório de retentativa (`onRetry`).
   - **Success (Dados)**: Hierarquia visual clara respeitando os tokens de `flutter-design-system`.
2. **Checklist de Ergonomia e Acessibilidade:**
   - [ ] Alvos de toque (`IconButton`, `InkWell`, chips) com mínimo de `48x48dp`.
   - [ ] Campos numéricos (quantidade, preço, desconto) abrem teclado apropriado (`TextInputType.numberWithOptions(decimal: true)`) e selecionam texto ao focar.
   - [ ] Listas com scroll fecham teclado ao arrastar (`keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`).
   - [ ] Textos dinâmicos usam `maxLines` e `TextOverflow.ellipsis` dentro de `Expanded`/`Flexible` para evitar `RenderFlex overflowed`.

## 3. Código Canônico (Dart 3 / Flutter)
```dart
class AsyncStateView<T> extends StatelessWidget {
  const AsyncStateView({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    required this.isEmpty,
    required this.onRetry,
    required this.builder,
  });

  final bool isLoading;
  final String? errorMessage;
  final bool isEmpty;
  final VoidCallback onRetry;
  final WidgetBuilder builder;

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(errorMessage!, textAlign: TextAlign.center),
            SizedBox(height: context.tokens.md),
            FilledButton(onPressed: onRetry, child: const Text('Tentar Novamente')),
          ],
        ),
      );
    }
    if (isEmpty) return const Center(child: Text('Nenhum registro encontrado.'));
    return builder(context);
  }
}
```

## 4. Antipadrões Proibidos
- ❌ Entregar tela cobrindo apenas o estado `Success` (caminho feliz) sem `Loading`, `Empty` e `Error`.
- ❌ Botões ou ícones clicáveis menores que `48x48dp`.
- ❌ `Row` com `Text` dinâmico sem `Expanded`/`Flexible` causando *RenderFlex overflow*.
