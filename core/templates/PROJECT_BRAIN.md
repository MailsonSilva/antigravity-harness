# PROJECT BRAIN — Memória Curada do Projeto

> **Regra Anti-Inchaço (Máx. ~60 linhas):** Mantenha apenas blocos curados. Nunca faça append infinito — quando uma decisão mudar, substitua a linha antiga ou mova para `Padrões Depreciados`.

## 1. Visão Geral & Stack
- **Stack:** [Flutter / Web / Backend]
- **Domínio:** [Resumo em 1 linha]

## 2. Design System (Fonte Única de Verdade Visual)
- **Especificação Visual:** `_references/brand/DESIGN_SYSTEM.md` (cores semânticas Light/Dark, tipografia, espaçamentos, raios e padrões de componentes).
- **Regra:** Toda tela/widget em `lib/features/` consome exclusivamente `Theme.of(context)` e `ThemeExtension` (`context.tokens`).

## 3. Invariantes Arquiteturais Ativas
- [Ex.: Camada `domain/` pura, sem imports externos.]
- [Ex.: Toda tela implementa Loading, Empty, Error e Success.]

## 4. Padrões Depreciados / Não Usar
- [Ex.: Não usar `setState` para estado de feature; usar Riverpod.]

## 5. Contratos de Dados & Persistência
- [Ex.: Queries com `WHERE LIKE` ou `JOIN` exigem índice composto.]

## 6. Último Handoff & Decisões Recentes (Máx. 5 itens)
- **[YYYY-MM-DD]:** Projeto inicializado com Antigravity Harness v4.
