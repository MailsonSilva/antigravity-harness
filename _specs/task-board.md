# 📋 Kanban de Desenvolvimento do Projeto (`task-board.md`)

> Sincronizado via Antigravity Harness Studio v3.0 e gerenciado pelo `master_orchestrator`.
> **Regra de ouro:** nenhum card avança de coluna sem cumprir o gate de saída da coluna atual.

```text
Backlog ──▶ TDD RED ──▶ TDD GREEN ──▶ Loop QA/A11y ──▶ Concluído
```

## 1. Backlog & Specs
> **Gate de saída:** PRD/spec aprovada, critérios de aceitação objetivos e skills 1:N definidas.

- **[T01] Recuperação de Senha** — *Agente:* `mobile_domain_builder` (Senior Flutter & Domain Engineer) | *Skills:* `spec_discovery, clean_architecture`
  - Fluxo completo de reset de senha com Supabase Auth, deep link e os 4 estados de tela. Spec: _specs/tasks/T01-recuperacao-senha.md
- **[T02] Dashboard Gerencial** — *Agente:* `ui_ux_specialist` (Senior UI/UX & Design System Engineer) | *Skills:* `mobile_ux_design_system, stitch_visual_ingest`
  - Painel responsivo com Design Tokens, gráficos e estados de carregamento. Spec: _specs/tasks/T02-dashboard-gerencial.md
- **[T03] Push Notifications** — *Agente:* `mobile_domain_builder` (Senior Flutter & Domain Engineer) | *Skills:* `flutter_riverpod_state, clean_architecture`
  - Notificações com fila offline, permissões e deep link para a tela de destino. Spec: _specs/tasks/T03-push-notifications.md
- **[T04] In-App Purchases** — *Agente:* `mobile_domain_builder` (Senior Flutter & Domain Engineer) | *Skills:* `clean_architecture, flutter_riverpod_state`
  - Compra de assinatura com validação de recibo e restauração de compras. Spec: _specs/tasks/T04-in-app-purchases.md
- **[T05] Backend Alternativo / Sync** — *Agente:* `data_supabase_specialist` (Offline-First SQLite & Supabase Architect) | *Skills:* `supabase_fullstack, local_first_sqlite`
  - Sincronização incremental Supabase + cache local SQLite com políticas RLS. Spec: _specs/tasks/T05-firebase-alternativo.md

## 2. TDD Fase RED (Testes Falhos)
> **Gate de saída:** Suíte criada e executada com falha comprovada pelo motivo correto (RED).

- *(Nenhuma tarefa ativa nesta coluna)*

## 3. TDD Fase GREEN (Implementação)
> **Gate de saída:** Menor código possível para a suíte ficar verde; `dart analyze` sem erros.

- *(Nenhuma tarefa ativa nesta coluna)*

## 4. Loop QA/A11y & Gate Humano
> **Gate de saída:** Até 3 ciclos de autorreparo, cobertura mínima, Semantics/contraste/touch targets validados.

- *(Nenhuma tarefa ativa nesta coluna)*

## 5. Concluído & Evoluído
> **Gate de saída:** Commit semântico atômico, Kanban atualizado e PROJECT_BRAIN.md com o aprendizado.

- **[T00] Unificação do Harness v2.1 com Dart MCP Server e Matriz 1:N** — *Agente:* `master_orchestrator` (Master Orchestrator & Principal Architect) | *Skills:* `spec_discovery, clean_architecture`
  - Base do Flutter Mobile Harness v2.1 consolidada, validada e commitada.
  - ⚠️ **Feedback de Revisão**: Aprovado e commitado.

---

### Legenda de skills por card
| Campo | Significado |
|---|---|
| `Skills:` | Lista 1:N de skills ativadas para o card (editável no `harness-studio.html`). |
| `WIP` | Limite de trabalho em progresso da coluna; exceder exige justificativa no `ai_memory`. |
| `@agente` | Subagente responsável pela coluna, conforme `.agents/harness.yaml#subagents`. |
