# 🚀 Antigravity Mobile Harness (Flutter)

Harness modular para desenvolvimento autónomo de **aplicativos mobile em Flutter** (Android + iOS).

Projetado para orquestrar subagentes especializados através de ciclos estritos de **TDD (Red-Green-Refactor)**, prototipagem visual orientada por referências (**Google Stitch MCP**), navegação precisa por AST (**Graft**) e persistência contextual entre agentes (**ai-memory**).

---

## 🎯 Arquitetura Mobile-First (Flutter)

O harness centraliza as regras de negócio e a identidade de produto, com o app definido em `_specs/prd-template.md`:

* **`apps/mobile`**: Aplicações móveis em Flutter com Clean Architecture, tratamento dos 4 estados de ecrã (*loading, empty, error, success*), flavors `dev/stg/prod` e suporte a bases de dados locais/remotas (SQLite/Drift, Supabase, etc.).
* **Plataformas**: Android e iOS a partir da mesma base de código, com builds assinados via Fastlane e publicação na Play Store e App Store.

---

## 📂 Estrutura do Repositório

```text
antigravity-harness-base/
├── _references/                     # Ativos visuais e capturas para leitura por IA
│   ├── brand/                       # Guias visuais, identidades e logótipos
│   └── screens/                     # Capturas de ecrã para o Google Stitch MCP
├── _specs/                          # Contratos técnicos e especificações de produto
│   └── prd-template.md              # Template agnóstico de descoberta de produto
├── .agents/
│   ├── harness.yaml                 # Orquestrador mestre e mapeamento de subagentes
│   ├── mcp.json                     # Configuração dos servidores MCP (Stitch, Graft, ai-memory)
│   ├── rules/                       # Diretrizes e restrições técnicas
│   │   ├── global.md                # TDD, Conventional Commits e pt-BR
│   │   │   └── mobile.md                # Normas de arquitetura Flutter e padrões de UI
│   ├── skills/                      # Competências modulares padronizadas
│   │   ├── antigravity-skill-orchestrator/ # SKILL.md (Triagem cognitiva e roteamento)
│   │   ├── clean-architecture/      # SKILL.md (Fase Red-Green e testes isolados)
│   │   ├── code-quality-tests/      # SKILL.md (QA mobile, testes e análise)
│   │   ├── flutter-release/         # SKILL.md (Pipeline test→version→build→ship)
│   │   ├── flutter-state-riverpod/  # SKILL.md (Estado padrão com Riverpod)
│   │   ├── local-first-data/        # SKILL.md (Drift/SQLite, sync offline)
│   │   ├── mobile-cicd/             # SKILL.md (Fastlane + GitHub Actions)
│   │   ├── mobile-ux/               # SKILL.md (Ergonomia móvel e ligação Stitch)
│   │   ├── spec-discovery/          # SKILL.md (Entrevista e definição de PRD)
│   │   └── store-publishing/        # SKILL.md (Play Store + App Store)
│   │   └── supabase-flutter/        # SKILL.md (Auth, DB, Storage, Realtime)
│   └── workflows/
│       └── dev-cycle.yaml           # Ciclo fechado: Spec ➔ Red ➔ Green ➔ QA ➔ Git
├── install.ps1                      # Script de instalação para Windows
└── install.sh                       # Script de instalação para ambientes Unix/WSL

⚡ Instalação Rápida em Qualquer Computador
Para configurar um novo projeto a partir de uma pasta limpa, execute o comando correspondente ao seu sistema operativo no terminal:

Windows (PowerShell)
```powershell
irm https://raw.githubusercontent.com/MailsonSilva/antigravity-harness-base/main/install.ps1 | iex
```
Linux / macOS / WSL
```bash
curl -sSL https://raw.githubusercontent.com/MailsonSilva/antigravity-harness-base/main/install.sh | bash
```
> Ajuste `MailsonSilva/antigravity-harness-base` para o seu `USUARIO/REPO` se fizer fork.

## 🤖 Seleção de Modelos por Tarefa

O harness **não fixa nenhum modelo**. Você escolhe qual modelo cada subagente usa na hora de executar, via variáveis de ambiente — sem editar arquivos:

```powershell
# Windows (PowerShell) — vale para a sessão atual
$env:MODEL_REASONING = "seu-modelo-forte"    # PRD, arquitetura (product_architect)
$env:MODEL_CODING = "seu-modelo-rapido"      # TDD e builders (tdd_tester, mobile_builder, qa)
$env:MODEL_DESIGN = "seu-modelo-com-visao"   # Protótipos visuais (ui_ux_designer)
$env:MODEL_OPS = "seu-modelo-leve"           # Commits e comandos (git_committer)
```

```bash
# Linux / macOS / WSL
export MODEL_REASONING="seu-modelo-forte" MODEL_CODING="seu-modelo-rapido" \
       MODEL_DESIGN="seu-modelo-com-visao" MODEL_OPS="seu-modelo-leve"
```

Troque os valores a cada tarefa conforme custo/qualidade desejados; o `harness.yaml` apenas lê essas variáveis.

## 📋 Tarefas e priorização (dificuldade × urgência)

1. **Crie uma tarefa** copiando `_specs/tasks/_template.md` para `_specs/tasks/<ID>-<slug>.md` e preenchendo `difficulty` (1–5), `urgency` (1–4), `target` e `status`.
2. **Visualize o quadro** em `_specs/task-board.md`: ranking por `score = urgência×10 − dificuldade` (quick wins primeiro), quadrantes e visão por target.
3. **Execute escolhendo a ordem**: rode o `dev-cycle` sem `task_id` para ver o ranking e escolher, ou com `task_id` (ex: `T01`) para ir direto — a spec é derivada da tarefa e o status vira `done` ao final.

🔄 Fluxo de Desenvolvimento (Pipeline dev-cycle)
O desenvolvimento opera através de transições estruturadas entre subagentes especializados:

Plaintext
[Descoberta / PRD] ──► [Design & Stitch] ──► [Fase RED (TDD)]
                                                   │
[Git Commit] ◄── [Auditoria / QA] ◄── [Fase GREEN (Código)]
Descoberta (product_architect): Conduz a análise dos requisitos e preenche _specs/prd-template.md.

Design Visual (ui_ux_designer): Inspeciona _references/screens/, interage com o Google Stitch MCP e gera os tokens visuais.

Fase Vermelha (tdd_tester): Cria a bateria de testes unitários ou de widgets que inicialmente falham.

Fase Verde (mobile_builder): Implementa o código mínimo necessário com auxílio do Graft para satisfazer os testes.

Auditoria e Autorreparo (qa-validator): Executa validações estáticas e testes; em caso de falha, aciona o ciclo de correção automática (limite de 3 tentativas).

Registo Semântico (git_committer): Valida as alterações pendentes no Git e cria commits atómicos no formato Conventional Commits baseando-se no contexto registado pelo ai-memory.

🛠️ Ferramentas e Protocolos Integrados
Google Stitch MCP: Prototipagem e extração de padrões visuais a partir de imagens.

Graft: Navegação eficiente na árvore sintática abstrata (AST) sem dispersão de contexto.

ai-memory: Gestão de transferências formais (handoffs) entre subagentes e retenção de decisões técnicas.
