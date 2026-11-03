---
name: mobile-ux
description: Engenharia de Experiência do Usuário Mobile em Flutter: Material 3, Design Tokens, 4 estados obrigatórios de tela, ergonomia de toque (48dp) e micro-interações.
category: UI/UX & Frontend
---

# Skill: Mobile UX, Ergonomia & Design Systems

## 1. Os 4 Estados Obrigatórios de Qualquer Tela ou BottomSheet
Nenhuma tela está pronta se apenas o caminho feliz foi desenhado. Implemente obrigatoriamente:
1. **Estado Loading**: Skeleton / Shimmer que preserva a geometria do card real, evitando saltos de layout (Layout Shift).
2. **Estado Empty (Vazio)**: Ícone semântico, título claro ("Nenhum produto encontrado para 'X'") e botão para limpar filtros.
3. **Estado Error (Falha)**: Card informativo com o motivo claro e botão de retentativa (`onRetry`).
4. **Estado Success (Dados)**: Hierarquia tipográfica clara (Título em destaque, código/embalagem secundários, preço final em evidência e badge de estoque colorido).

## 2. Checklist de Ergonomia e Acessibilidade
- [ ] Alvos de toque (`IconButton`, `InkWell`, chips) possuem no mínimo `48x48dp`.
- [ ] Campos numéricos (quantidade, desconto, preço) abrem teclado numérico apropriado (`TextInputType.numberWithOptions(decimal: true)`) e selecionam o texto ao receber foco.
- [ ] Listas com scroll fecham o teclado automaticamente ao arrastar (`keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag`).
- [ ] Textos dinâmicos usam `maxLines` e `TextOverflow.ellipsis` dentro de `Expanded`/`Flexible` para jamais causar erro de faixa amarela/preta (`RenderFlex overflowed`).
