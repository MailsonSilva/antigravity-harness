# 📋 Kanban de Desenvolvimento do Projeto (`task-board.md`)

> Sincronizado com `harness-studio.html` e gerenciado pelo `@product_architect` durante o `dev-cycle`.
> **Regra de ouro:** nenhum card avança de coluna sem cumprir o gate de saída da coluna atual.

```text
Backlog ──▶ TDD RED ──▶ TDD GREEN ──▶ Loop QA/A11y ──▶ Concluído
```

## 🗂️ 1. Backlog & Especificação (`@product_architect`) — WIP livre
> **Gate de saída:** PRD/spec aprovada, critérios de aceitação objetivos e skills 1:N definidas.

- [ ] **T01** — [Recuperação de Senha](tasks/T01-recuperacao-senha.md) | Skills: `spec-discovery`, `clean-architecture`
- [ ] **T02** — [Dashboard Gerencial](tasks/T02-dashboard-gerencial.md) | Skills: `mobile-ux`, `flutter-build-responsive-layout`
- [ ] **T03** — [Push Notifications](tasks/T03-push-notifications.md) | Skills: `local-first-data`
- [ ] **T04** — [In-App Purchases](tasks/T04-in-app-purchases.md) | Skills: `store-publishing`
- [ ] **T05** — [Backend Alternativo / Sync](tasks/T05-firebase-alternativo.md) | Skills: `supabase-flutter`

## 🔴 2. TDD Fase RED — Testes Falhos (`@tdd_tester`) — WIP 2
> **Gate de saída:** suíte criada e executada com falha comprovada pelo motivo correto (RED).

*(Nenhuma tarefa ativa nesta coluna)*

## 🟢 3. TDD Fase GREEN — Em Implementação (`@mobile_builder` / `@data_offline_specialist`) — WIP 2
> **Gate de saída:** menor código possível para a suíte ficar verde; `dart analyze` sem erros.

*(Nenhuma tarefa ativa nesta coluna)*

## 🔁 4. Loop de Autorreparo QA & Acessibilidade (`@qa_validator` / `@flutter_a11y_auditor`) — WIP 1
> **Gate de saída:** até 3 ciclos de autorreparo, cobertura mínima, Semantics/contraste/touch targets validados.

*(Nenhuma tarefa ativa nesta coluna)*

## ✅ 5. Concluído & Commitado (`@git_committer`) — arquivo
> **Gate de saída:** commit semântico atômico, Kanban atualizado e `PROJECT_BRAIN.md` com o aprendizado.

- [x] **T00** — Unificação do Harness v2.1 com Dart MCP Server e Matriz 1:N de Agentes/Skills.

---

### Legenda de skills por card
| Campo | Significado |
|---|---|
| `Skills:` | Lista 1:N de skills ativadas para o card (editável no `harness-studio.html`). |
| `WIP` | Limite de trabalho em progresso da coluna; exceder exige justificativa no `ai-memory`. |
| `@agente` | Subagente responsável pela coluna, conforme `.agents/harness.yaml#subagents`. |
