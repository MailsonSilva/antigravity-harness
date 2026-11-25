# Guia de Alterações — Antigravity Harness (v4 Modular)

> Documento de referência da arquitetura **v4 Modular**, orientada a SDD (`_specs/SPEC.md`), TDD (`RED → GREEN`), memória curada File-First (`.agents/PROJECT_BRAIN.md`), auto-evolução (`.agents/HARNESS_FEEDBACK.md`) e isolamento estrito de perfis (`core/` + `profiles/<stack>/`).

---

## 1. Objetivo

Fornecer uma **Fonte Única de Verdade (SSOT)** modular e agnóstica de modelo que:
- Elimina duplicação entre repositório-fonte e projetos consumidores via `setup.ps1` (Windows) e `init.sh` (Linux/macOS/WSL).
- Evita inchaço de contexto (*Progressive Disclosure*): consolida regras globais + stack em um único `GEMINI.md` na raiz e carrega no máximo 2 skills sob demanda via `antigravity-skill-orchestrator`.
- Garante atualizações seguras e idempotentes controladas pelo manifesto `.agents/.harness-manifest.json`.

---

## 2. Componentes Canônicos v4

| # | Componente | Caminho no Repositório-Fonte | Papel no Projeto Consumidor |
|---|---|---|---|
| 1 | **Diretrizes Base & Stack** | `core/GEMINI.base.md` + `profiles/<stack>/GEMINI.<stack>.md` | Concatenados em `GEMINI.md` na raiz do projeto (com detecção de `-AppDir`). |
| 2 | **Manifesto de Perfil** | `profiles/<stack>/profile.yaml` | Declara `aliases`, `gemini_file`, `skills` e `mcps` (`default` vs `optional`). |
| 3 | **Workflows SDD/TDD** | `core/workflows/{plan,orchestrate}.md` | Copiados para `.agents/workflows/` (Micro-Spec → Ondas `RED → GREEN → Gate`). |
| 4 | **Skills Modulares** | `core/skills/` (4) + `profiles/<stack>/skills/` (23 Flutter / 3 Web) | Copiadas para `.agents/skills/` e roteadas pelo `antigravity-skill-orchestrator`. |
| 5 | **Memória & Feedback** | `core/templates/{PROJECT_BRAIN,HARNESS_FEEDBACK}.md` | Inicializados em `.agents/` e **preservados** em updates. |
| 6 | **Kanban & Spec Viewer** | `harness-studio.html` + `core/templates/board.json` | Studio zero-build conectado a `_specs/board.json` (trava otimista `lastModified`) e `_specs/SPEC.md` (leitura). |
| 7 | **Quality Gates** | `.agents/scripts/{verify.ps1,verify.sh}` | Executam `dart analyze` e `flutter test -j 1` (Windows, Linux/macOS e CI). |
| 8 | **Instaladores Unificados** | `setup.ps1` (UTF-8 BOM) e `init.sh` | Suportam execução local ou remota (`git clone --depth 1`), `-InitApp` e `-WithOptionalMcps`. |

### 2.1 Estrutura Gerada no Projeto Consumidor
```text
projeto-alvo/
├── GEMINI.md                         # Diretrizes unificadas (Core + Perfil + Workspace)
├── harness-studio.html               # Kanban visual e leitor de SPEC.md
├── _specs/
│   ├── board.json                    # Estado das tarefas (schemaVersion: 1, lastModified)
│   └── SPEC.md                       # Micro-Spec ativa da feature
└── .agents/
    ├── .harness-manifest.json        # Controle de arquivos/skills gerenciados (SHA-256)
    ├── PROJECT_BRAIN.md              # Memória curada por blocos fixos (~60 linhas)
    ├── HARNESS_FEEDBACK.md           # Sugestões para promoção ao antigravity-harness
    ├── COMANDOS.md                   # Cola operacional de início/fim de sessão e prompts
    ├── mcp.json                      # MCPs default (e optional sob -WithOptionalMcps)
    ├── scripts/{verify.ps1,verify.sh}
    ├── workflows/{plan,orchestrate}.md
    └── skills/                       # Skills do core + perfil + skills customizadas locais
```

---

## 3. Contrato dos Scripts (`setup.ps1` e `init.sh`)

### 3.1 Flags Suportadas
- **`-Profile` / `<perfil>`**: resolvido dinamicamente via `profiles/*/profile.yaml` (`flutter`/`mobile`, `web-sites`/`web`).
- **`-InitApp` / `--init-app`**: para Flutter, executa `flutter create` (se `pubspec.yaml` ausente e `flutter` no `PATH`) e cria `lib/core/{database,errors,network,theme}`, `lib/features`, `test/{core,features}`, `integration_test` e `_references/{brand,screens}`.
- **`-WithOptionalMcps` / `--with-optional-mcps`**: habilita MCPs opcionais (`supabase_mcp`, `google_stitch`, `patrol_mcp`, `graft_ast`, `ai_memory`); por padrão instala apenas `mcps.default` (`dart_mcp` no Flutter).
- **`-AppDir` / `--app-dir`**: define o pacote Dart/Flutter em monorepos (autodetecta `apps/mobile/pubspec.yaml` quando presente).

### 3.2 Regras de Atualização e Preservação
Antes de sobrescrever arquivos gerenciados, um backup é criado em `%TEMP%/harness-backup-*` (ou `/tmp/harness-backup-*`). Nenhuma mutação automática é feita em `.gitignore` ou no índice Git (`git rm --cached`).

| Artefato | Comportamento no Update |
|---|---|
| `GEMINI.md`, `.agents/workflows/*`, `.agents/scripts/*`, `.agents/mcp.json`, `.agents/COMANDOS.md`, `harness-studio.html` | **Atualizados** (com backup prévio) e registrados em `managedFiles`. |
| `.agents/skills/*` listadas em `managedSkills` | **Atualizadas**; skills removidas do perfil upstream são limpas apenas se constavam no manifesto anterior. |
| Skills customizadas do projeto (fora de `managedSkills`) | **Preservadas** integralmente. |
| `.agents/PROJECT_BRAIN.md`, `.agents/HARNESS_FEEDBACK.md`, `_specs/*`, `_references/*` | **Preservados** integralmente (criados apenas se ausentes). |

---

## 4. Critérios de Aceitação v4

- [x] `setup.ps1` compatível com PowerShell 5.1 (salvo em UTF-8 **com BOM**, JSONs gravados em UTF-8 **sem BOM**).
- [x] `bash -n init.sh` e `bash -n .agents/scripts/verify.sh` retornando código `0`.
- [x] Instalação limpa com `-Profile flutter` materializando as **27 skills** (4 `core` + 23 `flutter`), `verify.ps1`, `verify.sh` e `COMANDOS.md`.
- [x] Atualização preservando `PROJECT_BRAIN.md`, `HARNESS_FEEDBACK.md`, `_specs/board.json`, `_specs/SPEC.md` e skills customizadas.
- [x] Todas as `SKILL.md` seguindo o template canônico de `core/skills/skill-creator/SKILL.md`.

---

## 5. Histórico

| Data | Versão | Alteração |
|---|---|---|
| 2026-10-30 | v2 | Padronização agnóstica inicial (`inherit`, 8 componentes). |
| 2026-11-24 | v4.0 | Consolidação `core/` + `profiles/`, unificação `setup.ps1`/`init.sh` com manifesto, `harness-studio.html` em `_specs/board.json`, fluxo SDD/TDD (`RED → GREEN`), `PROJECT_BRAIN.md`, `HARNESS_FEEDBACK.md` e `COMANDOS.md`. |
| 2026-11-25 | v4.1 | Perfil Flutter expandido para 23 skills (arquitetura consolidada, `flutter-environments-security`, `flutter-golden-tests`, `flutter-code-generation`, `flutter-networking-dio`, `flutter-observability`) e paridade Linux/CI com `.agents/scripts/verify.sh`. |
