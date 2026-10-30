# Guia de Alterações — Harness Universal (v2)

> Documento de referência da modernização do harness para o padrão **provider-agnostic**,
> baseado nos 8 componentes canônicos do Google Research Harness² e na política de
> herança de modelos (`inherit`). Este arquivo é versionado e serve como fonte de verdade
> para instaladores, atualizadores e agentes.

---

## 1. Objetivo

Eliminar qualquer acoplamento a fornecedor de IA (modelos fixos, IDs de vendor ou
nomenclatura proprietária) mantendo um único scaffold reutilizável em Claude Code,
Codex, Antigravity, Cursor e CLIs equivalentes. O harness **não escolhe modelo**:
ele herda o modelo já autenticado no ambiente e permite sobrescrita explícita por perfil.

---

## 2. Os 8 Componentes Canônicos

| # | Componente | Arquivo(s) de referência | Responsabilidade |
|---|---|---|---|
| 1 | **System Prompts** | `.agents/rules/global.md` | Idioma (pt-BR), spec-driven, TDD, handoffs, commits convencionais e segurança. |
| 2 | **Guardrails** | `.agents/rules/mobile.md`, `.agents/rules/web.md` | Padrões técnicos por plataforma: arquitetura em camadas, 4 estados de UI, performance, a11y, SEO e gates de qualidade. |
| 3 | **Memory** | `.agents/PROJECT_BRAIN.md`, `.agents/memory/context.db` | Memória persistente do projeto (aprendizados e histórico de evolução) e banco local de tickets do `ai-memory`. |
| 4 | **Tool Guidance** | `.agents/mcp.json` | Declaração dos servidores MCP (`google-stitch`, `graft-ast`, `ai-memory`) e instruções de uso. |
| 5 | **Subagents** | `.agents/harness.yaml#subagents` | Elenco de papéis, perfil de modelo abstrato, regras, skills e ferramentas permitidas. |
| 6 | **Skills** | `.agents/skills/**/SKILL.md` | Capacidades reutilizáveis com gatilho, fluxo de trabalho e checklist. |
| 7 | **Scripts** | `install.ps1`, `install.sh`, `update.ps1`, `update.sh` | Instalação e sincronização idempotentes, com preservação de dados locais. |
| 8 | **Plugins** | `.agents/mcp.json` | Extensões e integrações externas carregadas via MCP. |

### 2.1 Mapa de diretórios

```text
.agents/
├── harness.yaml              # componentes 5 e 6 (referências) + perfis de modelo
├── mcp.json                  # componentes 4 e 8
├── PROJECT_BRAIN.md          # componente 3 (memória consolidada)
├── memory/                   # componente 3 (banco local, não versionado)
├── rules/
│   ├── global.md             # componente 1
│   ├── mobile.md             # componente 2
│   └── web.md                # componente 2
├── skills/                   # componente 6
└── workflows/
    └── dev-cycle.yaml        # orquestração ponta a ponta
```

---

## 3. Política de Herança de Modelos (`inherit`)

### 3.1 Padrão

```yaml
model_profiles:
  reasoning: "${AI_MODEL_REASONING:-inherit}"
  coding: "${AI_MODEL_CODING:-inherit}"
  multimodal_design: "${AI_MODEL_DESIGN:-inherit}"
  fast_ops: "${AI_MODEL_FAST:-inherit}"
```

- `inherit` significa **usar o modelo atualmente logado** na CLI/IDE, sem nenhuma
  suposição de fornecedor, versão ou nome comercial.
- Nenhum arquivo do harness pode conter identificador de modelo fixo (ex.: `gemini-*`,
  `gpt-*`, `claude-*`).
- Nenhuma variável é obrigatória: o pipeline nunca aborta por perfil não configurado.

### 3.2 Sobrescrita opcional por perfil

| Perfil | Variável | Uso típico |
|---|---|---|
| `reasoning` | `AI_MODEL_REASONING` | PRD, arquitetura, decisões e autoevolução do harness. |
| `coding` | `AI_MODEL_CODING` | TDD, builders e refatoração. |
| `multimodal_design` | `AI_MODEL_DESIGN` | Extração de Design DNA e prototipagem visual. |
| `fast_ops` | `AI_MODEL_FAST` | Commits semânticos e comandos rápidos. |

PowerShell:

```powershell
$env:AI_MODEL_REASONING = "seu-modelo-forte"
$env:AI_MODEL_CODING    = "seu-modelo-rapido"
```

Bash:

```bash
export AI_MODEL_REASONING="seu-modelo-forte" AI_MODEL_CODING="seu-modelo-rapido"
```

### 3.3 Regras de consistência

1. Todo subagente declara `profile` (nunca `model`) e o perfil precisa existir em
   `model_profiles`.
2. Workflows não exigem variáveis de modelo; apenas exibem o perfil resolvido.
3. Instaladores e atualizadores não podem reintroduzir nomes de modelo ou agentes
   removidos do elenco.

---

## 4. Contrato dos Scripts

### 4.1 `install.ps1` / `install.sh`

- Criam a estrutura canônica e gravam **exatamente** os arquivos versionados em `.agents/`.
- Preservam `.agents/PROJECT_BRAIN.md` caso já exista (nunca sobrescrevem memória).
- São compatíveis com PowerShell 5.1 (sem `&&`, arquivo salvo em UTF-8 **com BOM**).

### 4.2 `update.ps1` / `update.sh`

Sincronizam com o upstream via clone raso em diretório temporário:

| Categoria | Comportamento |
|---|---|
| `.agents/PROJECT_BRAIN.md` | **Preservado** integralmente. |
| `.agents/skills/**` | **Preservado**; apenas skills novas do upstream são adicionadas. |
| `.agents/memory/**` | **Preservado** integralmente (nunca copiado nem apagado). |
| `.agents/harness.yaml`, `mcp.json`, `rules/**`, `workflows/**` | Atualizados (backup prévio). |
| `_specs/prd.md`, `features/`, `tasks/T*.md`, `apps/`, `_references/` | Preservados. |

- O repositório aceita `owner/repo`, URL completa ou caminho local (`-Repo` / `REPO`).
- Falha de clone aborta sem alterar o projeto (o `try/finally` limpa o temporário).

---

## 5. Critérios de Aceitação

- [ ] `harness.yaml` declara os 8 componentes em `scaffolding`.
- [ ] Todos os perfis usam `:-inherit`.
- [ ] Nenhuma ocorrência de modelo fixo ou `release_manager` em scripts geradores.
- [ ] `install.ps1` parseia sem erros no PowerShell 5.1 e possui BOM.
- [ ] `bash -n install.sh` e `bash -n update.sh` retornam código 0.
- [ ] Instalação limpa gera harness idêntico ao do repositório.
- [ ] Atualização preserva `PROJECT_BRAIN.md`, skills existentes e `memory/`.

---

## 6. Histórico

| Data | Alteração |
|---|---|
| 2026-10-30 | Harness v2 agnóstico: 8 componentes, perfis `inherit`, instaladores alinhados, atualizadores com sincronização real e correção de compatibilidade com PowerShell 5.1. |
