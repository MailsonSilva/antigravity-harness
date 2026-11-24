# PROJECT BRAIN — Memória Curada do Projeto

> **Regra Anti-Inchaço (Máx. ~60 linhas):** Mantenha apenas blocos curados. Nunca faça append infinito — quando uma decisão mudar, substitua a linha antiga ou mova para `Padrões Depreciados`.

## 1. Visão Geral & Stack
- **Stack:** [Flutter / Web / Backend]
- **Domínio:** [Resumo em 1 linha]

## 2. Invariantes Arquiteturais Ativas
- [Ex.: Camada `domain/` pura, sem imports externos.]
- [Ex.: Toda tela implementa Loading, Empty, Error e Success.]

## 3. Padrões Depreciados / Não Usar
- [Ex.: Não usar `setState` para estado de feature; usar Riverpod.]

## 4. Contratos de Dados & Persistência
- [Ex.: Queries com `WHERE LIKE` ou `JOIN` exigem índice composto.]

## 5. Último Handoff & Decisões Recentes (Máx. 5 itens)
- **[YYYY-MM-DD]:** Projeto inicializado com Antigravity Harness v4.
