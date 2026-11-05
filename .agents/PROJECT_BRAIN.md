# 🧠 PROJECT BRAIN — Memória Viva e Decisões Técnicas

Este documento é a fonte única de verdade do projeto. Ele preserva o contexto entre diferentes sessões de IA, desenvolvedores e máquinas.

---

## 1. Visão Geral do Produto
- **Stack**: Flutter (Dart 3), SQLite local (Offline-first), Clean Architecture.
- **Domínio Principal**: Força de Vendas e Catálogo Comercial Mobile.

---

## 2. Invariantes Arquiteturais Inegociáveis
1. **Domain Purity**: A pasta `domain/` não importa pacotes externos, HTTP ou SQLite.
2. **Cálculo Único**: Preços e regras de negócio nunca são calculados na camada de apresentação (UI).
3. **Ergonomia Mobile**: Alvos de toque com no mínimo $48 \times 48\text{ dp}$ e regra dos 4 estados de tela (Loading, Empty, Error, Success).

---

## 3. Contratos de Banco Local (SQLite)
- Toda query com filtro de texto (`WHERE LIKE`) ou chave estrangeira (`JOIN`) deve ter índice composto (`CREATE INDEX IF NOT EXISTS`).
- Operações de importação em massa devem rodar dentro de `db.transaction` usando `Batch`.

---

## 4. Servidores MCP Ativos
- `dart`: Daemon oficial do SDK para diagnósticos e testes.
- `google-stitch`: Leitor visual de telas em `_references/screens/`.
- `graft-ast`: Navegação estática de símbolos.
- `ai-memory`: Histórico local de tickets.

---

## 5. Decisões Arquiteturais Recentes (Histórico Autônomo)
*(Preenchido automaticamente pelo Orquestrador ao finalizar tarefas no Kanban)*
- **[2026-11-05]**: Aprovado o isolamento local do harness via `.gitignore` para manter o GitHub do projeto limpo.
- **[2026-11-05]**: Formalizado o protocolo anti-alucinação de ferramentas no `.agents/rules/global.md`.
