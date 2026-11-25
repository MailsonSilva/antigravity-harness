# PROJECT BRAIN — Memória Curada do Antigravity Harness

> **Regra Anti-Inchaço (Máx. ~60 linhas):** Mantenha apenas blocos curados. Decisões superadas devem ser substituídas ou movidas para `Padrões Depreciados`.

## 1. Visão Geral & Stack
- **Projeto:** `antigravity-harness` (Harness modular v4 para Google Antigravity).
- **Foco Principal:** Desenvolvimento Mobile Flutter com SDD (`_specs/SPEC.md`), TDD (`RED → GREEN`) e Studio Kanban (`_specs/board.json`).

## 2. Invariantes Arquiteturais Ativas
1. **SSOT Modular v4:** Toda regra/workflow/skill mora em `core/` e `profiles/<stack>/`, materializada nos projetos-alvo via `setup.ps1` ou `init.sh`.
2. **Triagem Progressiva:** Máximo de 2 skills carregadas por turno via `core/skills/antigravity-skill-orchestrator/SKILL.md`, delegando com `TypeName` nativo (`self` / `research`).
3. **Atualização Segura:** `.agents/.harness-manifest.json` controla arquivos gerenciados; `_specs/`, `_references/`, `.agents/PROJECT_BRAIN.md` e skills customizadas nunca são sobrescritos.

## 3. Padrões Depreciados / Não Usar
- Instaladores por heredoc (`install.ps1`, `install.sh`), `update.ps1`/`update.sh`, `.agents/harness.yaml`, `.agents/rules/` e `_specs/task-board.md` (substituídos pela v4 Modular + `_specs/board.json`).
- Alteração automática de `.gitignore` ou execução de `git rm --cached` nos scripts de setup.

## 4. Contratos de Dados, Visual & Persistência
- **Design System (SSOT Visual):** `_references/brand/DESIGN_SYSTEM.md` (cores semânticas, tipografia, espaçamentos e bordas; validado automaticamente por `verify.ps1` / `verify.sh` em `lib/features/`).
- **Perfis:** `profiles/<stack>/profile.yaml` (sem `if` hardcoded nos instaladores).
- **Kanban Studio:** `_specs/board.json` (`schemaVersion: 1`, `lastModified` com trava otimista).
- **MCP Padrão Flutter:** `dart_mcp`; pesados (`supabase_mcp`, `google_stitch`, `patrol_mcp`, `graft_ast`, `ai_memory`) apenas via `-WithOptionalMcps`.

## 5. Último Handoff & Decisões Recentes (Máx. 5 itens)
- **[2026-11-24]:** Consolidada arquitetura v4 Modular (`core/` + `profiles/`) com `setup.ps1`/`init.sh` unificados.
- **[2026-11-24]:** Migrado `harness-studio.html` para `_specs/board.json` com trava otimista e visualizador read-only de `SPEC.md`.
- **[2026-11-24]:** Adotado fluxo SDD/TDD (`RED → GREEN`), Guardrails Negativos, `patrol_mcp` opcional e Golden Tests.
- **[2026-11-24]:** Formalizada memória curada File-First em `.agents/PROJECT_BRAIN.md`.
