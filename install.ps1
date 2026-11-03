# ==============================================================================
# Antigravity Developer Harness - Instalador Nativo PowerShell (Windows)
# 100% Autocontido: Instala ferramentas (ai-memory, graft), regras, skills e workflows
# v2.1: Dart MCP, 9 agentes, matriz 1:N, Kanban de 5 colunas e harness-studio.html.
# Opcional: .\install.ps1 -WithFlutterSkills instala os plugins oficiais do Flutter.
# ==============================================================================

param(
    [string]$TargetDir = ".",
    [switch]$WithFlutterSkills
)

$ErrorActionPreference = "Stop"

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   🚀 Antigravity Developer Harness - Instalador     " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $TargetDir
Write-Host "📁 Diretório de destino: $(Get-Location)" -ForegroundColor Yellow

# ------------------------------------------------------------------------------
# 1. Verificação e Instalação de Ferramentas Auxiliares (MCPs & CLI Tools)
# ------------------------------------------------------------------------------
Write-Host "`n🔍 Verificando ferramentas auxiliares..." -ForegroundColor Yellow

# 1.1 Checagem do Node / npm e ai-memory
if (Get-Command "npm" -ErrorAction SilentlyContinue) {
    if (-not (Get-Command "ai-memory" -ErrorAction SilentlyContinue)) {
        Write-Host "📦 Instalando ai-memory globalmente via npm..." -ForegroundColor Cyan
        try {
            npm install -g ai-memory
            Write-Host "✔ ai-memory instalado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Falha ao instalar ai-memory via npm global. Execute 'npm i -g ai-memory' manualmente se necessário." -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "✔ ai-memory já instalado no sistema." -ForegroundColor Green
    }
} else {
    Write-Host "⚠️ Node.js / npm não detectado. O servidor ai-memory precisará do Node instalado para rodar via npx/npm." -ForegroundColor DarkYellow
}

# 1.2 Checagem do Graft (AST Graph Navigator)
if (-not (Get-Command "graft" -ErrorAction SilentlyContinue)) {
    if (Get-Command "cargo" -ErrorAction SilentlyContinue) {
        Write-Host "📦 Compilando e instalando Graft via Cargo..." -ForegroundColor Cyan
        try {
            cargo install graft-cli
            Write-Host "✔ Graft instalado com sucesso." -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Falha ao compilar graft via cargo." -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "ℹ️ Cargo não detectado. O harness usará fallback para análise estática caso o binário do Graft não esteja no PATH." -ForegroundColor DarkYellow
    }
} else {
    Write-Host "✔ Graft já instalado no sistema." -ForegroundColor Green
}

# ------------------------------------------------------------------------------
# 1.3 Suporte opcional aos plugins oficiais do Flutter (npx skills)
# ------------------------------------------------------------------------------
if ($WithFlutterSkills) {
    if (Get-Command "npx" -ErrorAction SilentlyContinue) {
        Write-Host "🧩 Instalando plugins oficiais do Flutter via npx skills..." -ForegroundColor Cyan
        try {
            npx skills add flutter/agent-plugins --skill '*' --agent universal --yes
            if ($LASTEXITCODE -ne 0) { throw "npx skills retornou codigo $LASTEXITCODE" }
            Write-Host "✔ Plugins oficiais do Flutter instalados." -ForegroundColor Green
        } catch {
            Write-Host "⚠️ Falha ao instalar os plugins oficiais; o harness continua funcional." -ForegroundColor DarkYellow
        }
    } else {
        Write-Host "⚠️ npx não detectado; instale Node.js para usar os plugins oficiais." -ForegroundColor DarkYellow
    }
} else {
    Write-Host "ℹ️ Plugins oficiais do Flutter são opcionais. Ative com: .\install.ps1 -WithFlutterSkills" -ForegroundColor Gray
    Write-Host "   Ou execute: npx skills add flutter/agent-plugins --skill '*' --agent universal --yes" -ForegroundColor Gray
}
# ------------------------------------------------------------------------------
# 2. Criação da Estrutura de Diretórios
# ------------------------------------------------------------------------------
Write-Host "`n📁 Criando estrutura de pastas..." -ForegroundColor Yellow

$dirs = @(
    ".agents\rules",
    ".agents\skills\spec-discovery",
    ".agents\skills\mobile-ux",
    ".agents\skills\clean-architecture",
    ".agents\skills\code-quality-tests",
    ".agents\skills\antigravity-skill-orchestrator",
    ".agents\skills\flutter-state-riverpod",
    ".agents\skills\supabase-flutter",
    ".agents\skills\local-first-data",
    ".agents\skills\mobile-cicd",
    ".agents\skills\store-publishing",
    ".agents\skills\flutter-release",
    ".agents\skills\flutter-apply-architecture-best-practices",
    ".agents\skills\flutter-add-widget-test",
    ".agents\skills\flutter-add-integration-test",
    ".agents\skills\flutter-setup-declarative-routing",
    ".agents\skills\flutter-use-http-package",
    ".agents\skills\flutter-setup-localization",
    ".agents\skills\flutter-build-responsive-layout",
    ".agents\skills\dart-use-pattern-matching",
    ".agents\skills\dart-collect-coverage",
    ".agents\skills\harness-evolver",
    ".agents\skills\web-performance-seo",
    ".agents\workflows",
    ".agents\memory",
    "_specs\features",
    "_specs\tasks",
    "_references\screens",
    "_references\brand",
    "apps\mobile"
)

foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

# Criação de .gitkeep nas pastas de referências para garantir versionamento Git
Set-Content -Path "_references\screens\.gitkeep" -Value "" -Encoding UTF8
Set-Content -Path "_references\brand\.gitkeep" -Value "" -Encoding UTF8
Set-Content -Path ".agents\memory\.gitkeep" -Value "" -Encoding UTF8

Write-Host "✔ Diretórios criados com sucesso." -ForegroundColor Green
Write-Host "📄 Gerando arquivos de configuração, regras, skills e workflows..." -ForegroundColor Yellow

# ------------------------------------------------------------------------------
# 3. _specs/prd-template.md
# ------------------------------------------------------------------------------
@'
---
project_name: "NomeDoProjeto"
version: "0.1.0"
date: "2026-10-01"
status: "draft" # draft | approved | in_progress | completed

# Plataformas do aplicativo (ativadas na fase de descoberta)
platforms:
  android: true
  ios: true

# Definição tecnológica aberta decidida na descoberta
technology_choices:
  # Estratégia de dados definida conforme a necessidade do projeto:
  # Exemplos: local_first (SQLite, Drift, Hive, Realm) | cloud_only | hybrid_sync | serverless | rest_api | none
  persistence_type: "to_be_decided" 
  primary_database: "to_be_decided" # ex: sqlite, postgres, mysql, supabase, firebase, local_json, nenhum
  backend_strategy: "to_be_decided" # ex: direct_db, custom_api, edge_functions, baas, offline_only

  # Framework do app
  mobile_framework: "flutter" # ou react_native_expo, nativo, etc.
  styling_approach: "tokens"  # design_tokens, material3
---

# PRD: {{project_name}}

## 1. Visão Geral e Proposta de Valor
- **Problema Central**: Qual é a dor ou gargalo real que o sistema resolve? Quem sofre com esse problema atualmente?
- **Solução Proposta**: O que a solução entrega para sanar esse problema com o menor atrito possível?
- **Público-Alvo e Persona (ICP)**: Quem utilizará ou pagará pelo produto?
- **Métrica de Sucesso (North Star Metric)**: Qual número ou resultado valida o sucesso do projeto (ex.: usuários ativos, cadastros, conversão, tempo economizado)?

---

## 2. Definição e Justificativa de Tecnologias (Tech Stack)
*Esta seção é preenchida pelo agente de descoberta junto ao desenvolvedor antes do início da implementação:*

- **Persistência de Dados**: 
  - *Decisão*: [ex: Iniciar 100% local com SQLite para velocidade de MVP sem custo de servidor / Usar API externa já existente / Usar Postgres na nuvem]
  - *Justificativa*: [Por que essa escolha é ideal para o momento atual do projeto?]
- **Autenticação e Sessão**: [Local/Pin, JWT, OAuth, sessão de dispositivo ou sem autenticação]
- **Armazenamento de Arquivos/Imagens**: [Local no dispositivo, Bucket S3/R2 ou N/A]

---

## 3. Escopo do Aplicativo Mobile (`apps/mobile`)

- **Papel no Produto**:
- **Capacidades Críticas**: [Offline-first, notificações, acesso à câmera, biometria, etc.]
- **Plataformas**: [Android e/ou iOS, versão mínima do SO por plataforma]
- **Matriz de Devices**: [modelos e tamanhos de tela prioritários para teste]

---

## 4. Identidade Visual e Referências (`_references/`)
- **Referências em `_references/screens/`**: Telas de inspiração para leitura pelo Stitch MCP.
- **Paleta Preliminar & Tokens**:
  - Tom Primário: `#XXXXXX`
  - Tom Secundário / Destaque: `#XXXXXX`
  - Superfície / Fundo: `#XXXXXX`
  - Tipografia de Interface: [Inter, Roboto, Poppins, etc.]

---

## 5. Jornadas do Usuário e Épicos

### Épico 1: [Nome do Fluxo Principal]
- **Como** [perfil de usuário],
- **Quero** [realizar uma ação no app],
- **Para** [atingir determinado benefício].

**Critérios de Aceitação Obrigatórios**:
- [ ] Cenário de Sucesso (Caminho Feliz).
- [ ] Estado de Carregamento contextual (Skeleton ou loader não intrusivo).
- [ ] Estado Vazio (Empty State) informativo e com botão de ação rápida.
- [ ] Estado de Falha (Error State) com mensagem em pt-BR e opção de tentar novamente.

---

## 6. Diagrama Conceitual de Arquitetura (Archify)
- *Fluxo de dados documentado em HTML/SVG autocontido*:
  - Componente de Entrada -> Gerenciador de Estado -> Contrato de Repositório -> Mecanismo de Dados Escolhido.
'@ | Set-Content -Path "_specs\prd-template.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 4. .agents/harness.yaml
# ------------------------------------------------------------------------------
@'
version: "2.1-flutter-mobile"
name: "universal-flutter-mobile-harness"
description: "Harness Mobile Flutter oficial com Dart MCP Server, Kanban, TDD Loop e associação 1:N de Skills por Agente."

# ==============================================================================
# 1. Perfis de Modelos Abstratos (Agnóstico: Antigravity, Claude Code, Cursor, Codex)
# ==============================================================================
model_profiles:
  reasoning: "${AI_MODEL_REASONING:-inherit}"
  coding: "${AI_MODEL_CODING:-inherit}"
  multimodal_design: "${AI_MODEL_DESIGN:-inherit}"
  fast_ops: "${AI_MODEL_FAST:-inherit}"

# ==============================================================================
# 2. Configurações Globais e Caminhos do Projeto
# ==============================================================================
settings:
  language: "pt-BR"
  enforce_tdd: true
  max_repair_cycles: 3
  prd_path: "_specs/prd.md"
  task_board: "_specs/task-board.md"
  visual_studio_html: "harness-studio.html"
  memory_target: ".agents/PROJECT_BRAIN.md"
  recursive_learning: true

# ==============================================================================
# 3. Os 8 Componentes Canônicos (Google Research Harness² + Flutter AI)
# ==============================================================================
scaffolding:
  system_prompts:
    - ".agents/rules/global.md"
  guardrails:
    - ".agents/rules/mobile.md"
    - ".agents/rules/web.md"
  memory:
    brain: ".agents/PROJECT_BRAIN.md"
    db_path: ".agents/memory/context.db"
  tool_guidance: ".agents/mcp.json"
  subagents_ref: ".agents/harness.yaml#subagents"
  skills_ref: ".agents/skills/"
  scripts_ref:
    windows_install: "install.ps1"
    posix_install: "install.sh"
    windows_update: "update.ps1"
    posix_update: "update.sh"
  plugins_ref: ".agents/mcp.json"

# ==============================================================================
# 4. Workspaces
# ==============================================================================
workspaces:
  shared:
    paths:
      - "_specs/"
      - "_references/"
      - ".agents/"
  mobile:
    path: "./"
    test_command: "flutter test"
    lint_command: "dart analyze"
    format_command: "dart format ."

# ==============================================================================
# 5. Ferramentas e Servidores MCP Oficiais
# ==============================================================================
tools:
  dart:
    server_id: "dart"
    command: "dart mcp-server"
    description: "Servidor MCP oficial do Dart/Flutter SDK: analyzer, resolução de símbolos, test runner e inspeção de runtime."
  google_stitch_mcp:
    server_id: "google-stitch"
    description: "Leitor de referências visuais de telas e prototipagem de UI."
  graft:
    server_id: "graft-ast"
    description: "Grafo estático via AST Tree-sitter para consulta determinística de símbolos."
  ai_memory:
    server_id: "ai-memory"
    description: "Handoffs atômicos entre agentes e histórico de aprendizado do ciclo TDD."
  git:
    cli: "git"
    description: "Controle de versão e commits semânticos atômicos."

# ==============================================================================
# 6. Subagentes Especializados para Cada Fase do Projeto Flutter (1:N Skills)
# ==============================================================================
subagents:
  # FASE 1: Planejamento, Entrevista de Perguntas e Kanban
  product_architect:
    profile: "reasoning"
    phase: "Fase 1 - Descoberta, Specs & Kanban"
    role: "Orquestrador principal: analisa pedidos do desenvolvedor, formula perguntas de esclarecimento, cria specs em _specs/features/ e organiza o Kanban em _specs/task-board.md."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/spec-discovery/SKILL.md"
      - ".agents/skills/antigravity-skill-orchestrator/SKILL.md"
      - ".agents/skills/flutter-apply-architecture-best-practices/SKILL.md"
    tools: ["file_read", "file_write", "ai_memory"]

  # FASE 2: Design, UX, Layouts Responsivos e Rotas
  ui_ux_designer:
    profile: "multimodal_design"
    phase: "Fase 2 - UI/UX, Tokens, Responsividade & Rotas"
    role: "Extrai tokens de _references/screens/ via Stitch MCP, projeta layouts responsivos e implementa navegação declarativa respeitando os 4 estados de tela."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/mobile-ux/SKILL.md"
      - ".agents/skills/flutter-build-responsive-layout/SKILL.md"
      - ".agents/skills/flutter-setup-declarative-routing/SKILL.md"
      - ".agents/skills/flutter-setup-localization/SKILL.md"
    tools: ["google_stitch_mcp", "dart", "file_read", "file_write"]

  # FASE 3: TDD Fase Vermelha (Testes Antes do Código)
  tdd_tester:
    profile: "coding"
    phase: "Fase 3 - TDD Fase Vermelha (RED)"
    role: "Cria testes unitários (com sqflite_common_ffi isolado em memória), widget tests e integration tests que obrigatoriamente falham antes da implementação."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/code-quality-tests/SKILL.md"
      - ".agents/skills/flutter-add-widget-test/SKILL.md"
      - ".agents/skills/flutter-add-integration-test/SKILL.md"
      - ".agents/skills/dart-collect-coverage/SKILL.md"
    tools: ["dart", "file_read", "file_write", "bash", "graft"]

  # FASE 4A: Implementação de Domínio, Estado e UI Flutter (GREEN)
  mobile_builder:
    profile: "coding"
    phase: "Fase 4A - Construção Flutter & Gerenciamento de Estado (GREEN)"
    role: "Escreve código Dart 3 e Flutter estritamente tipado, desacoplado em Clean Architecture para fazer os testes da Fase RED passarem."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/clean-architecture/SKILL.md"
      - ".agents/skills/flutter-apply-architecture-best-practices/SKILL.md"
      - ".agents/skills/flutter-state-riverpod/SKILL.md"
      - ".agents/skills/dart-use-pattern-matching/SKILL.md"
    tools: ["dart", "file_read", "file_write", "graft"]

  # FASE 4B: Persistência Local SQLite, Performance de Busca e APIs
  data_offline_specialist:
    profile: "coding"
    phase: "Fase 4B - Banco Local SQLite, Índices, Sincronização & APIs"
    role: "Implementa DAOs, repositórios offline-first, índices de performance SQLite, pacotes .pac/FTP e integrações REST/Supabase."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/local-first-data/SKILL.md"
      - ".agents/skills/flutter-use-http-package/SKILL.md"
      - ".agents/skills/supabase-flutter/SKILL.md"
      - ".agents/skills/clean-architecture/SKILL.md"
    tools: ["dart", "file_read", "file_write", "graft"]

  # FASE 5: Loop de Autorreparo e Validação (QA)
  qa_validator:
    profile: "coding"
    phase: "Fase 5 - Validação, Linter & Loop de Autorreparo (REFACTOR)"
    role: "Executa dart analyze e flutter test via Dart MCP Server, conduzindo até 3 ciclos autônomos de autorreparo."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/code-quality-tests/SKILL.md"
      - ".agents/skills/dart-collect-coverage/SKILL.md"
    tools: ["dart", "bash", "file_read", "file_write"]

  # FASE 6: Acessibilidade Oficial Flutter (a11y)
  flutter_a11y_auditor:
    profile: "coding"
    phase: "Fase 6 - Auditoria de Acessibilidade (a11y) & Ergonomia"
    role: "Persona oficial recomendada pelo Flutter AI para auditar Semantics, leitores de tela, contraste WCAG AA e touch targets mínimos de 48x48dp."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/mobile-ux/SKILL.md"
      - ".agents/skills/flutter-build-responsive-layout/SKILL.md"
      - ".agents/skills/flutter-add-widget-test/SKILL.md"
    tools: ["dart", "file_read", "file_write"]

  # FASE 7: Auto-Aperfeiçoamento Recursivo (Harness²)
  harness_evolver:
    profile: "reasoning"
    phase: "Fase 7 - Evolução Propose-Probe-Compose"
    role: "Analisa falhas que exigiram autorreparo e atualiza as SKILL.md ou PROJECT_BRAIN.md para evitar reincidência."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/harness-evolver/SKILL.md"
      - ".agents/skills/antigravity-skill-orchestrator/SKILL.md"
    tools: ["file_read", "file_write"]

  # FASE 8: Fechamento Git, Build e Publicação nas Lojas
  git_committer:
    profile: "fast_ops"
    phase: "Fase 8 - Commit Atômico, CI/CD & Publicação"
    role: "Inspeciona o git diff, atualiza o Kanban para Concluído, executa commit semântico e prepara releases."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/flutter-release/SKILL.md"
      - ".agents/skills/mobile-cicd/SKILL.md"
      - ".agents/skills/store-publishing/SKILL.md"
    tools: ["git", "bash", "file_read", "file_write"]

workflows:
  dev_cycle:
    file: ".agents/workflows/dev-cycle.yaml"
    description: "Ciclo completo: Descoberta/Kanban -> Design -> TDD Red -> Green -> Repair Loop (3x) -> A11y -> Evolver -> Commit."
'@ | Set-Content -Path ".agents\harness.yaml" -Encoding UTF8

# ------------------------------------------------------------------------------
# 5. .agents/mcp.json
# ------------------------------------------------------------------------------
@'
{
  "mcpServers": {
    "dart": {
      "command": "dart",
      "args": ["mcp-server"],
      "description": "Servidor MCP oficial do Dart e Flutter SDK (analyzer, symbol resolution, test runner e runtime inspection)."
    },
    "google-stitch": {
      "command": "npx",
      "args": [
        "-y",
        "@google/stitch-mcp-server"
      ],
      "env": {
        "STITCH_REFERENCES_DIR": "./_references/screens",
        "STITCH_OUTPUT_DIR": "./_specs"
      },
      "description": "Servidor MCP do Google Stitch para extrair o Design DNA de referências em _references/screens/."
    },
    "graft-ast": {
      "command": "graft",
      "args": [
        "mcp",
        "--watch"
      ],
      "description": "Grafo estático do código com Tree-sitter para consulta determinística de símbolos."
    },
    "ai-memory": {
      "command": "ai-memory",
      "args": [
        "server"
      ],
      "env": {
        "AI_MEMORY_DB_PATH": "./.agents/memory/context.db"
      },
      "description": "Servidor de memória local para persistência de tickets de handoff entre subagentes."
    }
  }
}
'@ | Set-Content -Path ".agents\mcp.json" -Encoding UTF8

# ------------------------------------------------------------------------------
# 6. .agents/rules/ (global.md, mobile.md, web.md)
# ------------------------------------------------------------------------------
@'
# Diretrizes Globais do Harness de Engenharia

Este documento estabelece as regras universais e inegociáveis para todos os agentes, workflows e interações no workspace. A adesão a essas regras é obrigatória em todas as etapas do ciclo de vida do software.

---

## 1. Idioma e Comunicação (Regra de Ouro)
- **Interação com o Desenvolvedor**: Todas as conversas, explicações, resumos de progresso, relatórios de diagnóstico e comentários de handoff DEVEM ser estritamente em **Português do Brasil (pt-BR)**.
- **Artefatos e Código**:
  - Código-fonte, variáveis, funções, classes, interfaces e nomes de arquivos devem ser escritos em **inglês** (padrão universal da indústria).
  - Documentações de especificação técnica (`_specs/`), PRDs e notas de negócio são mantidos em **Português do Brasil (pt-BR)**.
  - Mensagens de commit seguem a convenção em **inglês** padronizada pelo Conventional Commits.

---

## 2. Princípio de Desenvolvimento Orientado a Especificações (Spec-Driven)
1. **Sem Spec, Sem Código**: Nenhum subagente de codificação (`builder`) tem permissão para escrever código de produção sem que exista uma especificação aprovada em `_specs/` com critérios de aceitação objetivos.
2. **Fidelidade ao Contrato**: O código implementado deve atender estritamente ao que foi pedido na spec — sem suposições arbitrárias (*scope creep*) e sem código desnecessário além do escopo.
3. **Identificação de Ambiguidade**: Se a especificação for ambígua ou contraditória, o agente deve interromper o fluxo e solicitar alinhamento antes de codificar.

---

## 3. Disciplina de TDD (Test-Driven Development)
1. **Ciclo Vermelho-Verde-Refatora (Red-Green-Refactor)**:
   - **Fase Vermelha (RED)**: O agente `tdd_tester` escreve a suíte de testes correspondente aos critérios da spec. Os testes DEVEM falhar comprovadamente antes do início da implementação.
   - **Fase Verde (GREEN)**: O agente construtor escreve a menor quantidade de código possível para satisfazer os testes e torná-los verdes.
   - **Fase de Refatoração (REFACTOR)**: O agente de QA limpa o código, remove duplicações e assegura que nenhum teste quebrou durante a limpeza.
2. **Cobertura de Casos Limítrofes**: Os testes devem cobrir obrigatoriamente fluxos principais (caminho feliz), valores nulos/inválidos, falhas de conectividade e cenários de borda.

---

## 4. Gestão de Contexto e Handoffs com `ai-memory`
1. **Registro Contínuo**: Cada etapa concluída no pipeline deve registrar um ticket ou atualização no `ai-memory`.
2. **Isolamento de Contexto**: Nenhum subagente deve reler o repositório inteiro; ele deve consultar o ticket do `ai-memory` e o grafo estático do **Graft** para obter apenas o contexto relevante para sua tarefa.
3. **Memória de Erros**: Toda falha que demandou correção no ciclo de autorreparo deve ser sintetizada como aprendizado para prevenir reincidência.

---

## 5. Padrão de Versionamento no Git (Conventional Commits)
- Todos os commits devem seguir a estrutura atômica:
  ```text
  <tipo>(<escopo>): <descrição curta no imperativo>

  - <detalhe da alteração ou critério da spec atendido>
  - Context Ticket: <id-do-ticket-ai-memory>
  ```
- **Tipos permitidos**:
  - `feat`: Nova funcionalidade implementada com cobertura de testes.
  - `fix`: Correção cirúrgica de defeito ou bug reportado.
  - `refactor`: Alteração de código sem impacto no comportamento externo ou nos testes.
  - `test`: Criação ou atualização de suítes de teste (fase Red).
  - `chore`: Atualização de configurações, builds, dependências ou scripts.
  - `docs`: Atualização de documentação, specs ou diagramas de arquitetura.

---

## 6. Segurança e Confidencialidade
1. **Segredos e Chaves**: Nenhuma chave de API, token de serviço, credencial de banco ou arquivo `.env` pode ser gravado em arquivos de código ou incluído na staging area do Git.
2. **Sanitização de Entradas**: Qualquer entrada de usuário ou parâmetro externo deve ser validada e higienizada antes do processamento ou persistência.
3. **Auditoria de Diff**: O agente `git_committer` deve inspecionar o `git diff --staged` antes da emissão do commit para garantir ausência de vazamentos.
'@ | Set-Content -Path ".agents\rules\global.md" -Encoding UTF8

@'
# Diretrizes Técnicas para Desenvolvimento Mobile (Flutter)

Este guia estabelece os padrões arquiteturais, convenções de código, gestão de estado, persistência de dados e ergonomia de interface para as aplicações em `apps/mobile/`.

---

## 1. Arquitetura de Software e Separação de Camadas
Adotamos uma abordagem modular e desacoplada inspirada em **Clean Architecture**:

```text
apps/mobile/lib/
├── core/                  # Serviços globais, tema, utilitários e clientes (HTTP/DB)
│   ├── database/          # SQLite (migrations, helpers, DAOs)
│   ├── network/           # Clientes HTTP / Supabase SDK
│   └── theme/             # Design Tokens, tipografia e estilos globais
├── features/              # Módulos funcionais isolados
│   └── [feature_name]/
│       ├── data/          # Models, DTOs, DataSources e Repositórios concretos
│       ├── domain/        # Entidades de negócio e Contratos de repositório (Interfaces)
│       └── presentation/  # Telas, Widgets atômicos e State Holders (Bloc/Notifier)
└── main.dart
```

### Regras de Dependência:
- A camada de **Apresentação (Presentation)** depende apenas do **Domínio (Domain)**. Nunca chame o SQLite, Supabase ou HTTP diretamente de dentro de um Widget.
- A camada de **Dados (Data)** implementa os contratos da camada de **Domínio**.
- O **Domínio (Domain)** é composto por Dart puro: livre de dependências do framework Flutter, widgets ou pacotes externos de terceiros.

---

## 2. Gerenciamento de Estados de Tela (Regra dos 4 Estados)
Toda tela que consulta, carrega ou submete informações DEVE implementar explicitamente os quatro estados visuais da UI:

1. **Estado de Carregamento (`LoadingState`)**:
   - Usar *shimmer skeleton* ou indicador visual de progresso contextualizado.
   - Evitar bloquear a tela inteira se parte do conteúdo já estiver em cache.
2. **Estado de Conteúdo Vazio (`EmptyState`)**:
   - Mensagem amigável explicando por que não há itens na lista.
   - Ação visual clara e direta (*Call to Action*), por exemplo: *"Nenhum agendamento encontrado. Clique no botão abaixo para agendar."*
3. **Estado de Falha/Erro (`ErrorState`)**:
   - Mensagem em Português claro, sem termos técnicos indecifráveis para o usuário final.
   - Botão obrigatório de *"Tentar Novamente"* para reexecutar a consulta.
4. **Estado de Sucesso/Dados (`SuccessState`)**:
   - Renderização limpa, com paginação sob demanda quando houver listas extensas.

---

## 3. Diretrizes de UI, Widgets e Performance
1. **Construtores `const`**: Sempre declare construtores `const` em Widgets sem estado mutável para evitar reconstruções desnecessárias na árvore de renderização.
2. **Tamanho Mínimo de Alvo de Toque (Touch Target)**:
    - Todo botão, ícone interativo ou elemento clicável deve ter uma área de toque de no mínimo **48x48 dp**, prevenindo toques acidentais ou frustração de uso.
3. **Alinhamento com Tokens Visuais**:
   - Cores, raios de borda, espaçamentos e fontes devem ser consumidos centralmente a partir de `core/theme/` (gerado a partir de `_specs/design-tokens.json`).
   - É proibido usar cores "mágicas" (`Color(0xFF123456)`) diretamente no corpo dos widgets.
4. **Desacoplamento de Widgets**:
   - Funções construtoras de widgets internas como `Widget _buildItem()` são desencorajadas para componentes complexos; prefira classes `StatelessWidget` dedicadas para isolar reconstruções.

---

## 4. Persistência de Dados e SQLite (Offline-First)
Quando o projeto utilizar persistência local em SQLite:

1. **Migrações Incrementais e Versionadas**:
   - Nunca altere o schema existente diretamente. Toda alteração de estrutura (coluna nova, índice novo) exige uma migration sequencial vinculada à versão do banco (`onUpgrade`).
2. **Índices Estruturados**:
   - Crie índices explícitos (`CREATE INDEX IF NOT EXISTS`) em qualquer campo utilizado com frequência em cláusulas `WHERE`, ordenações `ORDER BY` ou chaves estrangeiras.
3. **Operações em Lote (Transactions / Batch)**:
   - Mutações ou inserções de múltiplos registros devem obrigatoriamente ser executadas dentro de uma transação ou usando `batch.commit(noResult: true)` para evitar retenção de I/O em disco.
4. **Testabilidade do Banco de Dados**:
   - Testes unitários de repositórios e DAOs devem ser executados em memória utilizando `sqflite_common_ffi` (`databaseFactoryFfi`), garantindo execução em milissegundos sem depender de emulador ou dispositivo físico.

---

## 5. Qualidade de Código e Análise Estática
- O código deve compilar sem nenhum aviso de linter (`flutter analyze` deve retornar código de saída `0`).
- Use o formatador padrão do Dart (`dart format .`) antes de qualquer submissão de código.
- Nomes de classes em `UpperCamelCase`, nomes de variáveis e métodos em `lowerCamelCase`, e nomes de arquivos em `snake_case`.

---

## 6. Versionamento, Flavors e Assinatura de Release
1. **Versionamento Único**:
   - A versão do app vive no `pubspec.yaml` (`version: x.y.z+build`). Todo release incrementa o build number; toda entrega visível incrementa `x.y.z` seguindo semver.
2. **Flavors Obrigatórios (`dev` / `stg` / `prod`)**:
   - Nenhum build de produção pode apontar para backend de desenvolvimento. Use `--flavor` com entrypoints e bundle IDs/applicationIds distintos por ambiente.
3. **Assinatura**:
   - Android: App Bundle (`.aab`) assinado com upload key versionada fora do repo (nunca commitar keystore ou `key.properties`).
   - iOS: distribuição via certificado + provisioning profile gerenciados por `fastlane match`; segredos apenas em variáveis de ambiente do CI.
4. **Gate de Release**:
   - Nenhum build sobe para loja sem `flutter test` + `dart analyze` verdes na mesma revisão.
'@ | Set-Content -Path ".agents\rules\mobile.md" -Encoding UTF8

@'
# Diretrizes Técnicas para Desenvolvimento Web (React / Next.js)

Este guia estabelece os padrões de arquitetura, renderização, performance, SEO e segurança para as aplicações em `apps/web/` e `apps/landing/`.

---

## 1. Arquitetura e Separação de Camadas
Adotamos o App Router do Next.js com Server Components como padrão:

```text
apps/web/
├── app/                   # Rotas, layouts e metadata por segmento
├── components/            # Apresentação reutilizável (UI pura)
├── features/              # Módulos funcionais isolados
│   └── [feature_name]/
│       ├── components/    # Componentes específicos da feature
│       ├── data/          # Server actions, route handlers e clientes
│       └── domain/        # Tipos, regras e validações puras
├── lib/                   # Utilitários, clientes HTTP e configuração
└── styles/                # Tokens visuais e estilos globais
```

### Regras de Dependência:
- **Server Components por padrão**: use `"use client"` apenas quando houver estado local, efeitos ou APIs exclusivas do browser.
- A camada de **apresentação** (`components/`) não acessa banco de dados, SDKs ou `fetch` direto; dados entram por props ou server actions em `features/*/data/`.
- O **domínio** (`domain/`) é TypeScript puro: sem imports de React, Next.js ou SDKs externos.
- Segredos nunca no bundle do cliente: apenas variáveis de servidor. `NEXT_PUBLIC_*` é reservado a valores públicos.

---

## 2. Performance e Core Web Vitals
1. **Metas de qualidade (p75 mobile)**:
   - `LCP` ≤ 2,5 s · `INP` ≤ 200 ms · `CLS` ≤ 0,1.
2. **Imagens**: use `next/image` com `width`/`height` explícitos e formatos modernos; `priority` apenas na imagem hero.
3. **Fontes**: carregue via `next/font` com `display: swap`; sem requisições bloqueantes de terceiros.
4. **JavaScript**: orçamento de até 170 KB gzip no primeiro carregamento; use `dynamic import` para componentes pesados e bibliotecas de gráficos/editores.
5. **Dados**: prefira Server Components para busca; defina `revalidate` ou cache explícito e nunca dependa de cache implícito indefinido.

---

## 3. SEO Técnico
1. **Metadata por rota**: `title`, `description`, `canonical` e Open Graph definidos no `metadata` do segmento.
2. **Arquivos obrigatórios**: `app/sitemap.ts` e `app/robots.ts` mantidos atualizados.
3. **Conteúdo indexável**: a landing deve renderizar conteúdo principal no servidor, sem depender de JavaScript no cliente.
4. **Semântica**: um único `h1` por página, hierarquia de headings consistente e dados estruturados JSON-LD quando aplicável.
5. **URLs**: canônicas, sem duplicidade de barra final e sem parâmetros de rastreamento indexáveis.

---

## 4. Acessibilidade (a11y)
- Contraste mínimo AA, foco visível e navegação completa por teclado.
- Todo input com `label` associado; erros anunciados via `aria-live`.
- Elementos interativos não semânticos recebem `role` e tratamento de teclado.
- Respeite `prefers-reduced-motion` em animações e transições.

---

## 5. Tipagem e Qualidade de Código
- TypeScript em modo `strict`; proibido `any` implícito ou `@ts-ignore` sem justificativa documentada.
- Props sempre tipadas; sem lógica de negócio em componentes de apresentação.
- `npm run lint` e `npm test` devem passar antes de qualquer commit.
- `npm run build` de produção sem warnings bloqueantes.

---

## 6. Testes
1. **Unitários** (Vitest/Jest) para regras de domínio, formatadores e validadores.
2. **Componentes** com Testing Library, priorizando comportamento observável pelo usuário em vez de detalhes de implementação.
3. **E2E** (Playwright) para jornadas críticas: cadastro, login, checkout e formulários de conversão.

---

## 7. Segurança e Entrega
1. **Validação no servidor**: toda entrada é validada e higienizada no backend (ex.: Zod), nunca apenas no cliente.
2. **Headers de segurança**: CSP, `X-Content-Type-Options` e `Referrer-Policy` configurados no `next.config`.
3. **Gate de release**: nenhum deploy sobe sem build de produção, lint e testes verdes na mesma revisão.
'@ | Set-Content -Path ".agents\rules\web.md" -Encoding UTF8

if (-not (Test-Path ".agents\PROJECT_BRAIN.md")) {
@'
# PROJECT_BRAIN — Memória Persistente do Projeto

> Componente de **memory** do harness. Este arquivo é preservado integralmente por `update.ps1` e `update.sh`.
> Não apague e não o sobrescreva automaticamente: registre aqui apenas aprendizados consolidados.

---

## 1. Contexto do Projeto
- **Objetivo**: (preencher na descoberta inicial)
- **Stack principal**: (preencher — ex.: Flutter, Next.js)
- **Workspaces ativos**: `mobile` · `web` · `landing`
- **Idioma dos artefatos**: pt-BR (código e commits em inglês)

---

## 2. Decisões Arquiteturais (resumo de ADRs)
| Data | Decisão | Motivo | Impacto |
|---|---|---|---|
| — | — | — | — |

---

## 3. Aprendizados Recorrentes
> Alimentado pelo agente `harness_evolver` após ciclos de autorreparo.

- (erro observado) → (regra preventiva adotada em `.agents/rules/` ou skill)

---

## 4. Histórico de Evolução do Harness
> Seção obrigatória do ciclo **Propose–Probe–Compose** (skill `harness-evolver`).

| Data | Arquivo alterado | Gatilho | Validação | Resultado |
|---|---|---|---|---|
| — | — | — | — | — |
'@ | Set-Content -Path ".agents\PROJECT_BRAIN.md" -Encoding UTF8
}

# ------------------------------------------------------------------------------
# 7. .agents/skills/ (Skills Fundamentais e Especializadas)
# ------------------------------------------------------------------------------
@'
---
name: spec-discovery
description: Condução de entrevistas de descoberta, mapeamento de regras de negócio e geração do PRD com suporte ao Archify.
---

# Skill: Product Discovery & Specification

Esta skill guia o agente `product_architect` ao iniciar um projeto novo ou desenhar uma funcionalidade complexa.

## 1. Princípio da Descoberta Prática
- Não faça perguntas genéricas em excesso. Conduza uma conversa direta, estruturada e colaborativa em **Português do Brasil (pt-BR)**.
- Mapeie imediatamente:
  1. O problema central e a persona que sofre com ele.
  2. A métrica de valor e monetização (se aplicável).
  3. Quais plataformas (Android, iOS) e versões mínimas de SO.
  4. Qual a melhor estratégia de dados para o estágio atual (local simples, nuvem, híbrido).

## 2. Saídas Obrigatórias da Descoberta
Ao final da etapa de discovery, o agente deve obrigatoriamente ter preenchido:
1. `_specs/prd.md`: Baseado no modelo `_specs/prd-template.md`, com plataformas e tecnologias definidos.
2. Arquitetura Interativa via **Archify**: Um diagrama em arquivo HTML ou SVG autocontido detalhando o fluxo de dados entre os componentes.
3. Ticket inicial no `ai-memory` com a ementa do projeto aprovada.
'@ | Set-Content -Path ".agents\skills\spec-discovery\SKILL.md" -Encoding UTF8

@'
---
name: mobile-ux
description: Diretrizes de UX/UI mobile, extração de Design DNA com Google Stitch MCP a partir de prints e geração de tokens visuais.
---

# Skill: Mobile UX & Google Stitch Integration

Esta skill capacita o agente a atuar como um designer de produto e engenheiro de interface, integrando referências visuais em telas funcionais.

## 1. Fluxo de Extração com Google Stitch MCP
Quando existirem capturas ou imagens em `_references/screens/`:
1. **Inspeção de Referência**:
   - Acione a tool `google_stitch_mcp` com a ação `extract_design_context` apontando para o diretório `_references/screens/`.
   - Extraia a paleta de cores primárias, superfícies, contraste, pesos tipográficos e bordas.
2. **Exportação de Design Tokens**:
   - Salve os valores extraídos em `_specs/design-tokens.json` no formato padrão W3C:
     ```json
     {
       "color": {
         "brand": { "primary": { "value": "#..." }, "secondary": { "value": "#..." } },
         "background": { "screen": { "value": "#..." }, "card": { "value": "#..." } }
       },
       "radius": { "md": { "value": "12px" } },
       "spacing": { "base": { "value": "8px" } }
     }
     ```

## 2. Princípios Inegociáveis de Ergonomia Mobile (Touch & Layout)
- **Área Mínima de Toque (Touch Target)**: Todo botão, ícone ou linha clicável deve ter no mínimo 48x48 dp. Se o ícone for menor (ex: 24 dp), adicione padding transparente de padding/hit-test.
- **Zona de Alcance do Polegar (Thumb Zone)**: Ações primárias e botões de avanço/salvamento devem estar posicionados no terço inferior da tela. Evite botões críticos nos cantos superiores.
- **Feedback Háptico e Visual de Toque**: Todo elemento interativo deve ter indicação visual imediata de clique (ripple ou feedback de opacidade).

## 3. A Regra dos 4 Estados de Tela
Nenhuma tela mobile é entregue contendo apenas o estado de dados. A skill exige:
1. `LoadingState`: Uso de shimmers/skeletons para conteúdo assíncrono.
2. `EmptyState`: Ilustração ou ícone sutil, explicação curta em pt-BR e botão de ação primária (Call to Action).
3. `ErrorState`: Mensagem em linguagem humana amigável, ícone de aviso e botão com ação de retentativa.
4. `SuccessState`: Renderização fluida, com scroll desacoplado e animações suaves.
'@ | Set-Content -Path ".agents\skills\mobile-ux\SKILL.md" -Encoding UTF8

@'
---
name: clean-architecture
description: Práticas de Test-Driven Development (Red-Green-Refactor), desacoplamento de domínio e criação de suítes de teste de alta velocidade.
---

# Skill: Clean Architecture & Disciplina TDD

Esta skill dita o comportamento dos subagentes `tdd_tester`, `mobile_builder` e `qa_validator` durante a criação de funcionalidades.

## 1. Protocolo Red-Green-Refactor
1. **Fase Vermelha (RED)**:
   - O agente `tdd_tester` lê o arquivo de especificação da funcionalidade (`_specs/features/*.md`).
   - Identifica os contratos necessários (entidades, repositórios, use cases).
   - Escreve os testes unitários ou de widgets cobrindo os critérios de aceitação.
   - Executa a suíte de testes e valida que ela **FALHOU** pelos motivos corretos (ausência da classe ou método).
2. **Fase Verde (GREEN)**:
   - O agente construtor (`builder`) lê a falha e escreve **apenas** o código suficiente para satisfazer os testes.
   - Não invente funcionalidades secundárias que não estejam cobertas por um teste.
3. **Fase de Refatoração (REFACTOR)**:
   - Limpeza de nomes, extração de métodos duplicados, tipagem rigorosa.
   - Reexecução imediata dos testes para garantir que nada foi quebrado durante a limpeza.

## 2. Isolamento de Dependências
- **Camada de Domínio Puro**: Entidades e contratos de repositório não devem importar Flutter, SQLite, HTTP, Supabase ou bibliotecas de terceiros.
- **Testes de Banco Ultrarrápidos**:
  - Testes que envolvam banco de dados local (ex: SQLite) devem ser executados em memória utilizando fábrica em memória (`sqflite_common_ffi` ou equivalente), garantindo execução em menos de 100ms sem necessidade de emulador ou simulador.
- **Mocks Determinísticos**: Dependências externas (APIs, serviços de rede, GPS) devem ser simuladas via interfaces mockadas.
'@ | Set-Content -Path ".agents\skills\clean-architecture\SKILL.md" -Encoding UTF8

@'
---
name: antigravity-skill-orchestrator
description: Meta-orquestrador cognitivo para triagem de tarefas e ativação progressiva de skills. Avalia complexidade antes de delegar para evitar inchaço de contexto e chamadas desnecessárias. Use sempre no início de tarefas complexas ou fluxos de desenvolvimento.
---

# Antigravity Skill Orchestrator

Você atua como o avaliador prévio de execução no harness. Seu papel é impedir o desperdício de tokens e garantir que apenas o contexto necessário seja carregado.

## Regras de Triagem

1. **Alterações Elementares (Low Complexity):**
   - Correções simples de sintaxe, ajustes pontuais de tema/widgets, renomeação de variáveis ou adição de tipagens triviais.
   - **Ação:** NÃO ative skills adicionais. Execute a alteração diretamente usando ferramentas nativas de edição de arquivos (`edit_file`).

2. **Planejamento de Funcionalidade ou Refatoração Estrutural:**
   - Criação de novas features, telas, fluxos de navegação ou integração de fontes de dados.
   - **Ação:** Invoque a skill `spec-discovery` e/ou `clean-architecture`.

3. **Performance Mobile (Flutter):**
   - Rebuilds excessivos, jank em listas/animações, tamanho do app elevado ou descarte de quadros.
   - **Ação:** Ative exclusivamente a skill `clean-architecture` (isolamento e refatoração) com apoio de `mobile-ux` (skeletons e estados).

4. **Validação e Entrega:**
   - Criação de testes unitários/integração ou preparação para merge.
   - **Ação:** Ative a skill `code-quality-tests`.

## Tabela de Roteamento (tarefa → agente + skills)

Consulte esta tabela para delegar; ative no máximo 2 skills por turno, priorizando a primeira listada.

| Tarefa | Agente | Skills (ordem de prioridade) |
|---|---|---|
| Descobrir escopo, PRD, regras de negócio | `product_architect` | `spec-discovery` |
| Protótipo visual, tokens, Stitch | `ui_ux_designer` | `mobile-ux` |
| Breakpoints e telas grandes (design) | `ui_ux_designer` | `flutter-build-responsive-layout`, `mobile-ux` |
| Inventário de strings / idiomas (design) | `ui_ux_designer` | `flutter-setup-localization`, `mobile-ux` |
| Estruturar feature (camadas, pastas) | `mobile_builder` | `flutter-apply-architecture-best-practices`, `clean-architecture` |
| Estado com Riverpod / 4 estados | `mobile_builder` | `flutter-state-riverpod`, `mobile-ux` |
| Navegação, rotas, deep links | `mobile_builder` | `flutter-setup-declarative-routing` |
| Textos/i18n no código | `mobile_builder` | `flutter-setup-localization` |
| Layout adaptativo no código | `mobile_builder` | `flutter-build-responsive-layout` |
| REST/HTTP em services | `mobile_builder` | `flutter-use-http-package`, `local-first-data` |
| Supabase (auth, RLS, storage) | `mobile_builder` | `supabase-flutter`, `local-first-data` |
| Banco local, sync offline | `mobile_builder` | `local-first-data`, `supabase-flutter` |
| Refatorar if-else/JSON/sealed | `mobile_builder` ou `qa_validator` | `dart-use-pattern-matching`, `clean-architecture` |
| Testes RED (unit/widget) | `tdd_tester` | `clean-architecture`, `flutter-add-widget-test` |
| Teste E2E em device | `tdd_tester` | `flutter-add-integration-test`, `code-quality-tests` |
| QA, lint, autorreparo | `qa_validator` | `code-quality-tests`, `dart-use-pattern-matching` |
| Cobertura e gate de CI | `qa_validator` | `dart-collect-coverage`, `code-quality-tests` |
| Commit semântico | `git_committer` | (nenhuma — usa `ai-memory` + diff) |

## Protocolo de Decisão
- Nunca ative mais de duas skills simultaneamente no mesmo turno.
- Garanta que as regras contidas em `.agents/rules/global.md` e `.agents/rules/mobile.md` sejam o teto máximo de conformidade.
'@ | Set-Content -Path ".agents\skills\antigravity-skill-orchestrator\SKILL.md" -Encoding UTF8

@'
---
name: code-quality-tests
description: Automação de testes unitários, de widgets e de integração, além de revisão estática, para aplicativos Flutter. Use para gerar testes, validar regras de negócio e garantir cobertura antes de commits.
---

# Code Quality & Tests (Flutter)

Diretrizes para garantia de qualidade e estabilidade de código em aplicativos Flutter.

## Princípios de Testes
1. **Pirâmide Focada:** Priorize testes de regras de domínio e funções puras em Dart. Para widgets, teste comportamento do usuário (toques, estados renderizados) em vez de implementação interna.
2. **Camadas e Dependências:**
   - Domínio e repositórios: testes unitários com mocks das fontes de dados.
   - Telas: testes de widget cobrindo os 4 estados (loading, empty, error, success).
   - Fluxos críticos: testes de integração (`integration_test`) no caminho feliz.

## Checklist Pré-Entrega
- [ ] Executar análise estática (`flutter analyze` com zero avisos).
- [ ] Aplicar formatação (`dart format .`).
- [ ] Criar/atualizar testes para a funcionalidade recém-adicionada (`flutter test`).
'@ | Set-Content -Path ".agents\skills\code-quality-tests\SKILL.md" -Encoding UTF8

@'
---
name: flutter-state-riverpod
description: Padrão de gerência de estado com Riverpod em Flutter. Use ao criar providers, consumir estado em widgets, testar lógica de estado e ligar telas à regra dos 4 estados.
---

# Skill: Gerência de Estado com Riverpod (padrão do harness)

Riverpod é o padrão oficial de estado deste harness: testável, sem BuildContext global e com escopo por feature.

## 1. Tipos de Provider por Caso
- **Estado imutável simples** (filtros, seleções): `StateProvider` / `NotifierProvider`.
- **Estado assíncrono** (buscas, login): `AsyncNotifierProvider` — o `AsyncValue` casa direto com os 4 estados de tela (`loading` → LoadingState, `error` → ErrorState, `data` vazia → EmptyState, `data` → SuccessState).
- **Dependências** (repositórios, clientes): `Provider` puro, sobrescrito em testes via `ProviderScope(overrides: [...])`.
- **Parâmetros** (ex.: detalhe por id): `family` com parcimônia — prefira um Notifier que recebe o id no método.

## 2. Regras Inegociáveis
- Widgets **observam** (`ref.watch`) apenas o que renderizam; ações usam `ref.read(provider.notifier)` — nunca `watch` dentro de callbacks.
- Nenhum provider acessa SQLite, HTTP ou Supabase diretamente: ele chama o **repositório do domínio**.
- `autoDispose` por padrão em telas descartáveis para não vazar estado entre rotas.

## 3. Testabilidade
- Teste Notifiers com `ProviderContainer` puro (sem `pumpWidget`), sobrescrevendo o repositório por mock.
- Teste widgets com `ProviderScope` + `UncontrolledProviderScope` quando precisar de estado inicial fixo.
'@ | Set-Content -Path ".agents\skills\flutter-state-riverpod\SKILL.md" -Encoding UTF8

@'
---
name: supabase-flutter
description: Integração Flutter com Supabase (Auth, Database, Storage, Realtime). Use ao autenticar usuários, ler/escrever dados remotos, subir arquivos ou assinar mudanças em tempo real.
---

# Skill: Supabase no Flutter

Backend padrão deste harness para dados em nuvem. Combina com `local-first-data` para modo offline.

## 1. Setup Mínimo
- Pacote `supabase_flutter`; inicialização única no `main.dart` com URL e anon key via `--dart-define` (nunca hardcodadas no repo).
- Cliente acessível via repositório (`Supabase.instance.client`), nunca direto no widget.

## 2. Auth
- Login social e e-mail/senha via `supabase.auth`; sessão persistida automaticamente.
- Telas reagem a `onAuthStateChange` (ex.: redirecionar para login ao deslogar).
- JWT do usuário propaga o `auth.uid()` usado nas políticas RLS.

## 3. Database e RLS
- Toda tabela exposta ao app **exige RLS ativado** com políticas por `auth.uid()`; sem política, sem acesso.
- Leituras com paginação (`range`) e filtros no servidor — nunca baixar tabelas inteiras para filtrar no cliente.
- Escritas críticas via funções Postgres (`rpc`) quando precisarem de transação atômica.

## 4. Storage e Realtime
- Uploads com caminhos por usuário (`<uid>/<arquivo>`) e buckets com políticas RLS espelhadas.
- Realtime apenas em canais necessários (chat, notificações); fechar a subscription no `dispose`/`ref.onDispose`.
'@ | Set-Content -Path ".agents\skills\supabase-flutter\SKILL.md" -Encoding UTF8

@'
---
name: local-first-data
description: Persistência local-first em Flutter com Drift/SQLite (migrations, sync, batch). Use ao modelar banco local, versionar schema, operar offline ou sincronizar com a nuvem.
---

# Skill: Dados Local-First (Drift/SQLite + Sync)

Estende a seção 4 de `.agents/rules/mobile.md` com o protocolo operacional.

## 1. Modelagem com Drift
- Tabelas Drift espelham as entidades do domínio; DAOs expõem `Stream`s para a UI reagir a mudanças locais.
- Colunas de controle obrigatórias em tabelas sincronizáveis: `updated_at`, `deleted` (soft-delete) e `dirty` (pendente de envio).

## 2. Migrations
- `schemaVersion` incrementado a cada mudança; cada versão tem `MigrationStrategy` com `onUpgrade` testado.
- Teste de migration: banco antigo em asset → migra → valida dados preservados.

## 3. Operações
- Inserções/atualizações em lote dentro de transação (`batch`); leituras de lista sempre paginadas (`limit`/`offset`).
- Índices em toda coluna usada em `WHERE`, `ORDER BY` ou chave estrangeira.

## 4. Sincronização com Supabase
- Fila de saída: registros `dirty` enviados em ordem, com backoff em falha de rede.
- Fila de entrada: buscar por `updated_at > last_sync` (sync incremental, nunca full-refresh).
- Conflito: última escrita por `updated_at` vence; deleção remota propaga soft-delete local.
- Indicador de sync visível na UI (sincronizado / pendente / erro) — nunca falhar silenciosamente.
'@ | Set-Content -Path ".agents\skills\local-first-data\SKILL.md" -Encoding UTF8

@'
---
name: mobile-cicd
description: Pipeline CI/CD mobile com Fastlane + GitHub Actions (lanes beta e produção). Use ao configurar builds automatizados, gating por testes ou deploy contínuo para Firebase App Distribution, Play interna e TestFlight.
---

# Skill: CI/CD Mobile (Fastlane + GitHub Actions)

## 1. Estrutura de Lanes (por plataforma, em `android/fastlane` e `ios/fastlane`)
- `beta`: `flutter test` + `dart analyze` verdes → build → distribui em canal interno (Play Internal / TestFlight) a cada merge na `main`.
- `release`: exige tag `v*` → build com flavor `prod` → sobe para Play (track configurável) / App Store.
- Versionamento: `build_number` derivado do número do run do CI; `version_name` lido do `pubspec.yaml`.

## 2. Segredos (nunca no repo)
- Android: keystore em base64 + `key.properties` via GitHub Secrets.
- iOS: `fastlane match` (repositório privado de certificados) + App Store Connect API Key via Secrets.
- Supabase/URLs: via `--dart-define` a partir de Secrets por ambiente.

## 3. Template de Workflow (`.github/workflows/mobile-ci.yml`)
```yaml
name: mobile-ci
on:
  push:
    branches: [main]
  pull_request:
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { channel: stable }
      - run: flutter pub get
      - run: dart analyze
      - run: flutter test
  beta-android:
    needs: validate
    if: github.ref == 'refs/heads/main'
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: { channel: stable }
      - run: cd android && bundle exec fastlane beta
        env:
          KEYSTORE_BASE64: ${{ secrets.KEYSTORE_BASE64 }}
```

## 4. Gates
- PR não mergeia com `validate` vermelho (branch protection).
- Lane `release` nunca roda sem tag; build iOS exige runner `macos`.
'@ | Set-Content -Path ".agents\skills\mobile-cicd\SKILL.md" -Encoding UTF8

@'
---
name: store-publishing
description: Publicação na Play Store e App Store (tracks, TestFlight, review, screenshots). Use ao preparar releases, configurar fichas de loja ou responder a rejeições.
---

# Skill: Publicação em Lojas (Play + App Store)

## 1. Google Play
- Artefato: `.aab` assinado com upload key; `versionCode` sempre crescente.
- Trilhos em ordem: Internal → Closed → Open → Production com **staged rollout** (ex.: 10% → 50% → 100%), pausando em crash acima do baseline.
- Ficha: título, descrição curta/longa em pt-BR, screenshots por formato (telefone, tablet 7"/10"), ícone 512px e feature graphic 1024×500.

## 2. App Store
- Artefato: `.ipa` via Xcode Cloud/Fastlane; upload com App Store Connect API Key.
- Fluxo: build → TestFlight (grupo interno, depois externo com revisão beta) → App Store com **phased release**.
- Revisão: declarar permissões sensíveis (câmera, localização, biometria) com `NS*UsageDescription` em pt-BR claro; conta demo se houver login.

## 3. Screenshots Promocionais
- Gerar a partir de frames reais do app (golden tests ou device frames), nos tamanhos exigidos por cada loja; nunca mock desatualizado da UI.

## 4. Rejeições
- Registrar motivo + correção como aprendizado no `ai-memory`; re-submeter só após reproduzir a correção em build interno.
'@ | Set-Content -Path ".agents\skills\store-publishing\SKILL.md" -Encoding UTF8

@'
---
name: flutter-release
description: Pipeline de release Flutter de ponta a ponta (verificar, versionar, buildar, entregar). Use ao fechar uma versão: valida gates, incrementa versão, gera artefatos e entrega aos canais.
---

# Skill: Release Flutter (test → version → build → ship)

Checklist executado em ordem; qualquer etapa vermelha aborta as seguintes.

## 0. Verificação de Projeto
- `pubspec.yaml` existe; flavors `dev/stg/prod` configurados; segredos fora do repo.

## 1. Portões de Qualidade (Gates)
- `flutter test` verde + `dart analyze` com zero avisos na revisão exata a ser lançada.

## 2. Versionamento
- Incrementar `version: x.y.z+build` no `pubspec.yaml` (semver + build crescente); commit `chore(release): vX.Y.Z`.
- Criar tag `vX.Y.Z` — é ela que dispara a lane `release` no CI.

## 3. Build
- Android: `flutter build appbundle --flavor prod --dart-define=...`.
- iOS: `flutter build ipa --flavor prod --export-options-plist=...`.
- Registrar checksums dos artefatos na nota de release.

## 4. Entrega (Ship)
- Beta: Firebase App Distribution / Play Internal / TestFlight interno com notas em pt-BR.
- Produção: via `store-publishing` (staged rollout / phased release).
- Pós-release: monitorar crash nas primeiras 24h antes de expandir o rollout.
'@ | Set-Content -Path ".agents\skills\flutter-release\SKILL.md" -Encoding UTF8

@'
---
name: flutter-apply-architecture-best-practices
description: Arquitetura Flutter em camadas (UI, Lógica, Dados) com workflow de feature em 8 passos. Use ao estruturar um projeto novo ou refatorar para escalabilidade.
---

# Skill: Arquitetura Flutter em Camadas

> Adaptado de `flutter/agent-plugins` (time oficial do Flutter, licença BSD-3-Clause).
> Compatibilizado com este harness: pastas `core/` + `features/` (ver `.agents/rules/mobile.md`),
> estado via Riverpod (`flutter-state-riverpod`) e TDD obrigatório (`clean-architecture`).

## 1. Camadas (Separation of Concerns)

Nunca misture renderização de UI com regra de negócio ou acesso a dados.

### UI (Presentation) — `features/<feature>/presentation/`
- **Views:** widgets enxutos e reutilizáveis; só lógica de UI (animação, layout, navegação simples). Todo dado vem do state holder.
- **State holders:** neste harness, o papel de ViewModel é do `AsyncNotifier` (Riverpod). Expõe `AsyncValue` (casa com os 4 estados de tela) e recebe repositórios por injeção (provider/construtor).

### Dados — `features/<feature>/data/` (+ `core/database/`, `core/network/`)
- **Services:** classes sem estado que envelopam APIs externas (HTTP, banco local, plugins). Retornam modelos crus.
- **Repositories:** consomem um ou mais services, transformam em modelos de domínio, cuidam de cache, sync offline e retry. Expõem apenas modelos de domínio.

### Lógica (Domain) — `features/<feature>/domain/` — opcional por feature
- **Use cases:** só quando a lógica é complexa ou reutilizada entre telas; CRUD simples vai direto do state holder ao repositório.

## 2. Estrutura de Projeto (padrão do harness)

```text
lib/
├── core/
│   ├── database/   # SQLite/Drift: migrations, DAOs
│   ├── network/    # Clientes HTTP / Supabase
│   └── theme/      # Design tokens
└── features/
    └── [feature_name]/
        ├── data/          # Models crus, services, repositórios concretos
        ├── domain/        # Entidades + contratos (Dart puro, sem Flutter)
        └── presentation/  # Telas, widgets e Notifiers (Riverpod)
```

## 3. Workflow: Implementar uma Feature (8 passos + TDD)

Siga em ordem; cada passo de código nasce de um teste (`clean-architecture`):

- [ ] **1. Modelos de domínio:** entidades imutáveis em `domain/`.
- [ ] **2. Contratos:** interfaces de repositório em `domain/` (é contra elas que os testes RED são escritos).
- [ ] **3. Services:** acesso a API/banco em `data/` ou `core/`.
- [ ] **4. Repositórios:** implementações concretas; cache, retry e mapeamento para o domínio.
- [ ] **5. Lógica condicional:** use case em `domain/` se houver transformação complexa ou reuso; senão, pule.
- [ ] **6. State holder:** `AsyncNotifier` (Riverpod) com repositórios injetados; estados via `AsyncValue`.
- [ ] **7. View:** widget que observa o provider e renderiza os 4 estados (loading/empty/error/success).
- [ ] **8. Validador:** `flutter test` + `dart analyze` verdes; corrija e reexecute até passar.

## 4. Exemplo Mínimo (repositório + state holder)

```dart
// data: implementação contra o contrato do domínio
class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._api);
  final ApiClient _api;
  User? _cached;

  @override
  Future<User> getUser(String id) async {
    final cached = _cached;
    if (cached != null) return cached;
    final raw = await _api.fetchUser(id);
    return _cached = User(id: raw.id, name: raw.fullName);
  }
}

// presentation: AsyncNotifier no lugar do ViewModel
class ProfileNotifier extends AsyncNotifier<User?> {
  @override
  FutureOr<User?> build() => null;

  Future<void> load(String id) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(userRepositoryProvider).getUser(id),
    );
  }
}
```
'@ | Set-Content -Path ".agents\skills\flutter-apply-architecture-best-practices\SKILL.md" -Encoding UTF8

@'
---
name: flutter-add-widget-test
description: Testes de widget com WidgetTester (renderização e interações: tap, scroll, texto). Use ao validar que um widget exibe dados corretos e responde a eventos, incluindo os 4 estados de tela.
---

# Skill: Testes de Widget (WidgetTester)

> Adaptado de `flutter/agent-plugins` (time oficial do Flutter, licença BSD-3-Clause).

## 1. Setup
- `flutter_test` em `dev_dependencies`; arquivos em `test/` com sufixo `_test.dart`.
- Widgets com Riverpod: envolver em `ProviderScope` (com `overrides` para mocks). Telas com Material: envolver em `MaterialApp`.

## 2. Componentes
- **WidgetTester**: constrói e interage (`testWidgets`).
- **Finder**: localiza (`find.text`, `find.byType`, `find.byKey`). Prefira `ValueKey` semânticas nos widgets críticos.
- **Matcher**: `findsOneWidget`, `findsNothing`, `findsNWidgets`.

## 3. Workflow (checklist)
- [ ] 1. Definir com `testWidgets('descrição', (tester) async {...})`.
- [ ] 2. Renderizar com `await tester.pumpWidget(...)` (com `ProviderScope`/`MaterialApp` conforme preciso).
- [ ] 3. Verificar estado inicial com `expect(finder, matcher)`.
- [ ] 4. Interagir: `tap` → `pump`; animação/assíncrono → `pumpAndSettle`; texto → `enterText`; lista longa → `scrollUntilVisible`.
- [ ] 5. Verificar estado final.
- [ ] 6. Rodar `flutter test <arquivo>` e iterar até verde.

## 4. Padrão do Harness: Cobrir os 4 Estados
Todo teste de tela cobre: `LoadingState` (skeleton/spinner visível), `EmptyState` (mensagem + CTA),
`ErrorState` (mensagem pt-BR + tentar novamente) e `SuccessState` (dados renderizados).

## 5. Exemplo Mínimo (Riverpod + 4 estados)

```dart
testWidgets('Exibe ErrorState com retry em falha', (tester) async {
  final repo = MockRepo();
  when(() => repo.load()).thenThrow(const NetworkFailure());

  await tester.pumpWidget(
    ProviderScope(
      overrides: [repoProvider.overrideWithValue(repo)],
      child: const MaterialApp(home: ItemsScreen()),
    ),
  );
  await tester.pumpAndSettle();

  expect(find.text('Tentar novamente'), findsOneWidget);
  await tester.tap(find.text('Tentar novamente'));
  await tester.pump();
  verify(() => repo.load()).called(2);
});
```
'@ | Set-Content -Path ".agents\skills\flutter-add-widget-test\SKILL.md" -Encoding UTF8

@'
---
name: flutter-add-integration-test
description: Testes de integração end-to-end (integration_test) com fluxos de usuário e profiling. Use ao automatizar jornadas críticas (login, checkout, onboarding) em device/emulador.
---

# Skill: Testes de Integração (integration_test)

> Adaptado de `flutter/agent-plugins` (time oficial do Flutter, licença BSD-3-Clause).
> Foco mobile (Android/iOS); fluxos web/Chrome da fonte original foram removidos.

## 1. Setup
- `flutter pub add 'dev:integration_test:{"sdk":"flutter"}'`.
- Diretório `integration_test/` na raiz; arquivos `<nome>_test.dart`.
- `IntegrationTestWidgetsFlutterBinding.ensureInitialized()` no início do `main()`.
- `ValueKey`s nos widgets críticos (botões, campos, itens de lista).

## 2. Autoria
- Carregar o app real: `await tester.pumpWidget(const MyApp())`.
- Após cada interação (`tap`, `enterText`): `await tester.pumpAndSettle()`.
- Asserções por `find.byKey(ValueKey('...'))` + `findsOneWidget`/`findsNothing`.
- Listas: `scrollUntilVisible` antes de interagir com item fora da tela.

## 3. Execução (device/emulador conectado)
```bash
flutter test integration_test/app_test.dart
```
- Para profiling com `binding.traceAction()`, usar driver dedicado (`test_driver/perf_driver.dart`).
- `PumpAndSettleTimedOutException` → há animação infinita: isolar com `pump(duration)` ou desativar a animação no teste.

## 4. Workflow (checklist)
- [ ] Deps + `ValueKey`s nos alvos.
- [ ] Escrever `integration_test/<fluxo>_test.dart` cobrindo o caminho feliz + 1 falha (ex.: login inválido).
- [ ] Rodar em Android e iOS antes de considerar verde.
- [ ] Falhou? Revisar saída → `scrollUntilVisible`/`pump` → reexecutar.

## 5. Exemplo Mínimo

```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('login válido abre a home', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.enterText(find.byKey(const ValueKey('email')), 'user@mail.com');
    await tester.enterText(find.byKey(const ValueKey('password')), 'Senha123');
    await tester.tap(find.byKey(const ValueKey('login_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('home_screen')), findsOneWidget);
  });
}
```
'@ | Set-Content -Path ".agents\skills\flutter-add-integration-test\SKILL.md" -Encoding UTF8

@'
---
name: flutter-setup-declarative-routing
description: Roteamento declarativo com go_router (rotas, deep links Android/iOS, nested navigation). Use ao configurar navegação, receber links externos (push, e-mail) ou tabs com estado preservado.
---

# Skill: Roteamento Declarativo (go_router + Deep Links)

> Adaptado de `flutter/agent-plugins` (time oficial do Flutter, licença BSD-3-Clause).

## 1. Conceitos
- `GoRouter`: árvore de rotas; `GoRoute`: path → tela; `redirect`: guardas (ex.: sem sessão → `/login`).
- `StatefulShellRoute`: shell persistente (ex.: `NavigationBar`) com estado por aba.
- Navegação: `context.go` (substitui), `context.push` (empilha), `goNamed` + `pathParameters`, `pop`.

## 2. Setup
```bash
flutter pub add go_router
```
- App usa `MaterialApp.router(routerConfig: _router)`.
- Roteador vive em `lib/core/router/` (arquivo único por app, rotas por feature importadas).

## 3. Deep Links (Android + iOS)
- **Android** (`AndroidManifest.xml`): `intent-filter` com `autoVerify` + scheme/host; hospedar `assetlinks.json` em `/.well-known/`.
- **iOS** (`Info.plist` + `Runner.entitlements`): `FlutterDeepLinkingEnabled` + `applinks:dominio`; hospedar `apple-app-site-association` em `/.well-known/`.
- Validação: `adb shell am start -a VIEW -d "<url>" <package>`; `xcrun simctl openurl booted <url>`.
- Links de e-mail (ex.: recuperação de senha da T01): rota `/reset?token=...` que valida o token antes de renderizar.

## 4. Workflow (checklist)
- [ ] `go_router` + `MaterialApp.router`.
- [ ] Rotas por feature + `redirect` de auth + `errorBuilder` (tela 404 amigável pt-BR).
- [ ] Tabs com `StatefulShellRoute` quando houver bottom nav.
- [ ] Deep links nativos configurados e validados via adb/simctl.
- [ ] Teste de widget navegando (pump + `go` + `pumpAndSettle` + `expect` da tela destino).

## 5. Exemplo Mínimo (guarda de auth + deep link)

```dart
final router = GoRouter(
  initialLocation: '/home',
  redirect: (context, state) {
    final logged = container.read(sessionProvider).isLogged;
    if (!logged && state.matchedLocation != '/login') return '/login';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
    GoRoute(path: '/home', builder: (_, _) => const HomeScreen()),
    GoRoute(
      path: '/reset',
      builder: (_, s) => ResetScreen(token: s.uri.queryParameters['token']),
    ),
  ],
  errorBuilder: (_, _) => const NotFoundScreen(),
);
```
'@ | Set-Content -Path ".agents\skills\flutter-setup-declarative-routing\SKILL.md" -Encoding UTF8

@'
---
name: flutter-use-http-package
description: Networking REST com package:http (GET/POST/PUT/DELETE, erros, parsing isolado). Use ao consumir APIs remotas em services/repositórios da camada Data.
---

# Skill: Networking REST (package:http)

> Adaptado de `flutter/agent-plugins` (time oficial do Flutter, licença BSD-3-Clause).
> Regra do harness: HTTP vive em services (`data/` ou `core/network/`), nunca em widgets/Notifiers.

## 1. Setup e Permissões
```bash
flutter pub add http
```
- Android: `<uses-permission android:name="android.permission.INTERNET" />` no `AndroidManifest.xml`.
- Token/keys via `--dart-define`, nunca no código.

## 2. Execução e Erros
- URLs sempre com `Uri.parse`; headers de auth/content-type no parâmetro `headers`.
- POST/PUT com `jsonEncode`; sucesso = 200 (GET/PUT/DELETE) ou 201 (POST).
- **Falha nunca retorna null**: lança exceção de domínio (ex.: `NetworkFailure`) — o `AsyncValue.error` vira ErrorState na UI.
- Desserializa com `fromJson` tipado; listas grandes via `compute()` (isolate) para não derrubar frames.

## 3. Workflow (checklist)
- [ ] Model + `fromJson`.
- [ ] Método no service retornando `Future<Model>`.
- [ ] `statusCode` validado + exceção em falha.
- [ ] Teste unitário do service com cliente mockado (sucesso + 4xx/5xx + timeout).
- [ ] Repositório consome o service e expõe modelo de domínio.

## 4. Exemplo Mínimo (service + parsing isolado)

```dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

List<Item> parseItems(String body) => (jsonDecode(body) as List)
    .map((e) => Item.fromJson(e as Map<String, dynamic>))
    .toList();

class ItemApi {
  ItemApi(this._client, this._base);
  final http.Client _client;
  final Uri _base;

  Future<List<Item>> fetchAll(String token) async {
    final res = await _client.get(
      _base.replace(path: '/items'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (res.statusCode != 200) throw NetworkFailure();
    return compute(parseItems, res.body);
  }
}
```
'@ | Set-Content -Path ".agents\skills\flutter-use-http-package\SKILL.md" -Encoding UTF8

@'
---
name: flutter-setup-localization
description: Internacionalização com flutter_localizations + intl (ARB, l10n.yaml, plurais). Use ao criar ou alterar qualquer texto visível — o harness exige pt-BR como idioma base.
---

# Skill: Localização (i18n/l10n)

> Adaptado de `flutter/skills` (time oficial do Flutter, licença BSD-3-Clause).
> Regra do harness: **nenhum texto hardcoded em inglês/português solto na UI** — toda string passa por ARB, com pt-BR como template base.

## 1. Setup
```bash
flutter pub add flutter_localizations --sdk=flutter
flutter pub add intl:any
```
- `pubspec.yaml`: `flutter: { generate: true }`.
- `l10n.yaml` na raiz:
```yaml
arb-dir: lib/l10n
template-arb-file: app_pt.arb
output-localization-file: app_localizations.dart
synthetic-package: true
```
- `MaterialApp`: delegates (`AppLocalizations.delegate` + globais) e `supportedLocales` (pt primeiro).

## 2. Workflow
- [ ] Nova string: adicionar ao template `app_pt.arb` **com `@description`**; replicar a chave nos demais `.arb`.
- [ ] Editar string: atualizar **todos** os `.arb`, nunca só um.
- [ ] Rodar `flutter pub get` para regenerar; corrigir erro de sintaxe ARB e repetir.
- [ ] Consumir via `AppLocalizations.of(context)!.chave` — nunca `Text('literal')` em tela.
- [ ] Teste de widget de cada tela com locale pt e (se suportado) en.

## 3. Formatação Avançada (ARB)
- Placeholders: `"hello": "Olá {userName}"` + bloco `@hello` com tipo/exemplo.
- Plurais: `{count, plural, =0{...} =1{...} other{...}}` (`other` obrigatório).
- Selects: `{gender, select, male{...} female{...} other{...}}`.

## 4. Exemplo Mínimo

```json
// lib/l10n/app_pt.arb
{
  "retry": "Tentar novamente",
  "@retry": { "description": "Botão de retentativa do ErrorState" }
}
```

```dart
Text(AppLocalizations.of(context)!.retry)
```
'@ | Set-Content -Path ".agents\skills\flutter-setup-localization\SKILL.md" -Encoding UTF8

@'
---
name: flutter-build-responsive-layout
description: Layouts adaptativos (LayoutBuilder, breakpoints, telas grandes). Use ao construir telas que funcionam em celular, tablet e dobráveis, sem overflow.
---

# Skill: Layout Responsivo/Adaptativo

> Adaptado de `flutter/skills` (time oficial do Flutter, licença BSD-3-Clause).
> Foco mobile-first: celular → tablet/dobrável (form factors desktop são secundários).

## 1. Regras de Medição
- Decida pelo **espaço disponível**, não pelo device: `LayoutBuilder` + `constraints.maxWidth` (nunca "é tablet?" por hardware).
- `MediaQuery.sizeOf(context)` para a janela do app; **não** use `OrientationBuilder` no topo para trocar layout.
- Regra de ouro: constraints descem, tamanhos sobem, o pai posiciona.

## 2. Distribuição e Limites
- `Expanded` (preenche resto) vs `Flexible` (até o limite, com `flex` proporcional) em `Row`/`Column`.
- Telas grandes: `ConstrainedBox(maxWidth: ...)` centralizado para não esticar; listas viram `GridView.builder` com `SliverGridDelegateWithMaxCrossAxisExtent`.
- Listas sempre `builder` (lazy); nunca travar orientação (quebra dobráveis — letterboxing).

## 3. Workflow (checklist)
- [ ] Envolver em `LayoutBuilder`; breakpoint (ex.: `600` para 2 colunas/sidebar).
- [ ] `maxWidth > breakpoint` → layout expandido; senão → layout compacto.
- [ ] Redimensionar/rotacionar no emulador e corrigir overflows (`flutter-fix` conceitual: `Expanded`, `Flexible`, `SingleChildScrollView` onde couber scroll).
- [ ] Touch targets ≥ 48x48 dp preservados em todos os breakpoints.

## 4. Exemplo Mínimo

```dart
const largeMinWidth = 600.0;

LayoutBuilder(
  builder: (context, c) {
    if (c.maxWidth > largeMinWidth) {
      return const Row(children: [
        SizedBox(width: 250, child: NavRail()),
        VerticalDivider(width: 1),
        Expanded(child: Content()),
      ]);
    }
    return const Content();
  },
)
```
'@ | Set-Content -Path ".agents\skills\flutter-build-responsive-layout\SKILL.md" -Encoding UTF8

@'
---
name: dart-use-pattern-matching
description: Pattern matching Dart 3 (switch expressions, destructuring, sealed classes). Use ao refatorar if-else encadeados, validar JSON polimórfico ou garantir exaustividade.
---

# Skill: Pattern Matching (Dart 3)

> Adaptado de `dart-lang/skills` (time oficial do Dart, licença BSD-3-Clause).

## 1. Quando Usar (e Quando Não)
- **Usar**: validar + extrair de JSON (Map/List patterns), segmentos de rota (`['a', ...rest]`), payloads polimórficos (`switch` em chave discriminante → hierarquia `sealed`), múltiplos retornos (Records), faixas numéricas (relacionais), exaustividade em `sealed`/`enum`.
- **Não usar**: booleano simples (`?:`), promoção de 1 variável (`is`), filtro de coleção, 1 propriedade conhecida (`user.name`).

## 2. Statement vs Expression
- Produz valor → **switch expression** (`=>`, exaustivo, sem fallthrough).
- Efeito colateral → **switch statement** (cases vazios caem; demais dão break implícito).

## 3. Anti-Patterns (resumo)
- `if-case` com alias desnecessário → prefira `is` com promoção direta.
- Braço `null` redundante → case no tipo anulável (`String? s`).
- `if-case` que **silencia dado malformado** → fast-fail com `FormatException` explícito.
- `switch` de 1 case ou em booleano → `if`/`?:`.
- Map pattern valida **existência da chave** (`containsKey`): chave opcional omitida ≠ `null` — extraia do submapa (`map['k'] as String?`).

## 4. Workflow (checklist)
- [ ] Identificar estrutura (JSON, segmentos, Record, sealed, enum).
- [ ] Escolher constructo + patterns (Object/Map/List/Record) + guards (`when`).
- [ ] Ramo curinga `_` ou `default` quando fallback/erro for aceitável.
- [ ] `dart analyze` (exaustividade) + teste de runtime para Map/JSON.

## 5. Exemplo Mínimo (sealed + switch)

```dart
sealed class Shape {}
class Square implements Shape { final double length; Square(this.length); }
class Circle implements Shape { final double radius; Circle(this.radius); }

double area(Shape s) => switch (s) {
  Square(length: var l) => l * l,
  Circle(:var radius) => 3.14159 * radius * radius,
};
```
'@ | Set-Content -Path ".agents\skills\dart-use-pattern-matching\SKILL.md" -Encoding UTF8

@'
---
name: dart-collect-coverage
description: Cobertura de testes Flutter com relatório LCOV e gates de CI. Use ao medir cobertura do projeto ou exigir mínimo em pipeline.
---

# Skill: Cobertura de Testes (LCOV)

> Adaptado de `dart-lang/skills` (time oficial do Dart, licença BSD-3-Clause).

## 1. Coleta Rápida (Flutter)
```bash
flutter test --coverage
```
Gera `coverage/lcov.info`. Para HTML navegável (exige `lcov` instalado):
```bash
genhtml coverage/lcov.info -o coverage/html
```

## 2. Coleta Avançada (package:coverage)
```bash
flutter pub add dev:coverage
dart run coverage:test_with_coverage
```
Valida `coverage/coverage.json` + `coverage/lcov.info`. Em monorepo, passar os dirs de teste explicitamente.

## 3. Diretivas de Exclusão
- Linha: `// coverage:ignore-line` · Bloco: `ignore-start/end` · Arquivo: `// coverage:ignore-file`.
- Usar para gerados e `UnimplementedError` de providers base; **nunca** para esconder regra de negócio sem teste.

## 4. Gate de CI
- `validate` do `mobile-cicd` pode extrair o percentual do `lcov.info` e falhar abaixo do mínimo do projeto (sugestão inicial: 70% em `lib/`, excluídos gerados).
- Tendência > número absoluto: cobertura caindo em PR bloqueia merge.

## 5. Workflow (checklist)
- [ ] Rodar coleta e abrir relatório.
- [ ] Arquivos críticos (domain, repositories) com cobertura total.
- [ ] Adicionar testes onde a cobertura caiu antes de novas features.
'@ | Set-Content -Path ".agents\skills\dart-collect-coverage\SKILL.md" -Encoding UTF8

@'
---
name: harness-evolver
description: Implementa o ciclo recursivo Propose-Probe-Compose do Google Research Harness² para autoaperfeiçoamento contínuo das skills e diretrizes operacionais.
---

# Skill: Harness Recursive Self-Improvement (Propose–Probe–Compose)

Esta skill orienta o agente na autoevolução do ecossistema `.agents/` sempre que um ciclo de desenvolvimento encontrar arestas ou demandar autorreparo.

## 1. Gatilho de Ativação
Acionada automaticamente quando:
- Um ciclo de autorreparo de QA exigir 2 ou mais iterações para passar.
- Um bug corrigido for identificado como reincidente.
- Uma nova biblioteca for adicionada ao projeto sem diretriz prévia.

## 2. O Ciclo Propose–Probe–Compose
1. **Propose (Proposta de Ajuste no Harness)**:
   - Identifique a causa raiz da falha ou lentidão.
   - Formule uma regra preventiva clara para a respectiva skill em `.agents/skills/` ou adicione uma trava em `.agents/rules/`.
2. **Probe (Validação Experimental)**:
   - Execute a suíte de testes do projeto para certificar que a nova diretriz não introduz contradições nem quebra fluxos válidos.
3. **Compose (Consolidação Permanente)**:
   - Grave a adição defensiva no arquivo `.md` correspondente.
   - Registre o aprendizado na seção de histórico do `.agents/PROJECT_BRAIN.md`.
'@ | Set-Content -Path ".agents\skills\harness-evolver\SKILL.md" -Encoding UTF8

@'
---
name: web-performance-seo
description: Otimização de Core Web Vitals, renderização no servidor e SEO técnico em aplicações React/Next.js. Use ao criar rotas, componentes pesados ou revisar performance, indexação e acessibilidade do web.
---

# Skill: Performance Web e SEO Técnico

Esta skill orienta a construção e a revisão de aplicações web em `apps/web/` e `apps/landing/`, sempre subordinada às regras de `.agents/rules/web.md` e `.agents/rules/global.md`.

## 1. Gatilho de Ativação
Acione quando:
- Uma nova rota, layout ou landing page for criada.
- Houver regressão de Core Web Vitals ou aumento do bundle.
- For necessário revisar indexação, metadata ou dados estruturados.

## 2. Fluxo de Trabalho
1. **Medir antes de otimizar**:
   - Execute o build de produção e registre `LCP`, `INP` e `CLS` (p75 mobile).
   - Identifique o maior contribuinte do bundle com análise de build.
2. **Corrigir a causa raiz**:
   - Dados buscados em Server Components quando não houver interatividade.
   - `dynamic import` para bibliotecas pesadas; `next/image` e `next/font` sempre.
   - Elimine dependências duplicadas e código de cliente desnecessário.
3. **Validar SEO técnico**:
   - `metadata` por rota, `canonical`, `sitemap.ts` e `robots.ts` presentes.
   - Conteúdo principal renderizado no servidor; um único `h1`.
4. **Revalidar**:
   - Rebuild + nova medição; compare com a linha de base registrada.
   - `npm run lint` e `npm test` verdes antes de encerrar.

## 3. Checklist de Aceitação
- [ ] `LCP` ≤ 2,5 s, `INP` ≤ 200 ms e `CLS` ≤ 0,1 no p75 mobile.
- [ ] Nenhum segredo ou chave privada no bundle do cliente.
- [ ] Rotas commetadata única e canônica; `sitemap` e `robots` atualizados.
- [ ] Imagens com dimensões explícitas e formatos modernos.
- [ ] Navegação por teclado e contraste AA preservados.

## 4. Anti-Padrões
- `"use client"` no topo de árvores inteiras sem necessidade real.
- `fetch` em componente de apresentação ou acesso direto a SDK no cliente.
- Otimização baseada em percepção, sem medição antes/depois.
'@ | Set-Content -Path ".agents\skills\web-performance-seo\SKILL.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 8. .agents/workflows/dev-cycle.yaml (Pipeline Completo com TDD e Git)
# ------------------------------------------------------------------------------
@'
version: "1.0"
name: "dev-cycle"
description: "Pipeline orientado a Spec com TDD (Red-Green-Refactor), validação estática e Git commit semântico."

# 1. Parâmetros de Entrada
inputs:
  task_id:
    type: string
    description: "ID da tarefa em _specs/tasks/ (ex: T01). Se informado, a spec é derivada da tarefa e feature_spec torna-se opcional"
    required: false
    default: ""
  feature_spec:
    type: string
    description: "Caminho da especificação da funcionalidade (ex: _specs/prd-template.md ou _specs/features/nova-tela.md). Opcional quando task_id é informado"
    required: false
    default: ""
  target:
    type: string
    description: "Plataforma de destino do build: android | ios | both"
    default: "both"
  skip_design:
    type: boolean
    description: "Pular inspeção visual para tarefas puramente de lógica ou backend"
    default: false
  release:
    type: boolean
    description: "Executar a etapa de release ao final (gates, versionamento, build e entrega). Exige tag v* para produção"
    default: false

# 2. Pipeline Sequencial Unificado
steps:
  - id: validate_models
    name: "Pré-condição: Perfis de Modelo (inherit por padrão)"
    fail_fast: false
    description: "Os perfis definidos em .agents/harness.yaml usam 'inherit' como padrão: o agente herda o modelo já logado na CLI/IDE, sem exigir configuração. Opcionalmente, sobrescreva por tarefa com AI_MODEL_REASONING, AI_MODEL_CODING, AI_MODEL_DESIGN e AI_MODEL_FAST. Nenhuma variável ausente aborta o pipeline."
    actions:
      - description: "Exibe os perfis resolvidos (inherit quando a variável não estiver definida)"
        command: >
          for v in AI_MODEL_REASONING AI_MODEL_CODING AI_MODEL_DESIGN AI_MODEL_FAST; do
            printf '%s=%s\n' "$v" "${!v:-inherit}";
          done

  - id: select_task
    name: "Seleção da Tarefa (ranking por dificuldade × urgência)"
    fail_fast: true
    description: "Sem task_id: lê _specs/task-board.md, apresenta o ranking (score = urgência×10 − dificuldade) e pausa pedindo sua escolha (informe o ID ou confirme o top 1). Com task_id: valida que existe em _specs/tasks/ com status todo, deriva a spec do campo spec da tarefa e marca a tarefa como doing."
    actions:
      - description: "Aborta se nem task_id nem feature_spec foram informados"
        command: >
          if [ -z "${inputs.task_id}" ] && [ -z "${inputs.feature_spec}" ]; then echo "ERRO: informe task_id (ex: T01, veja o ranking em _specs/task-board.md) ou feature_spec."; exit 1; fi
      - description: "Com task_id: valida existência, status todo e deriva a spec da tarefa"
        command: >
          if [ -n "${inputs.task_id}" ]; then f=$(grep -rl "^id: \"${inputs.task_id}\"$" _specs/tasks/ | head -n 1); if [ -z "$f" ]; then echo "ERRO: tarefa ${inputs.task_id} não encontrada em _specs/tasks/."; exit 1; fi; st=$(grep "^status:" "$f" | head -n 1); case "$st" in *todo*) ;; *) echo "ERRO: tarefa ${inputs.task_id} não está com status todo ($st)."; exit 1;; esac; fi

  - id: triage
    name: "0. Triagem Cognitiva e Alocação de Contexto"
    skill: antigravity-skill-orchestrator
    thinking_budget: 1000
    description: "Avalia complexidade da tarefa e define a rota ideal evitando saturação de tokens."

  - id: spec_discovery
    name: "1. Leitura e Análise da Especificação"
    skill: spec-discovery
    thinking_budget: 4000
    description: "Lê ${inputs.feature_spec} (ou a spec derivada do campo spec da tarefa quando task_id foi informado) e mapeia critérios de aceitação e contratos de interface."

  - id: architecture_review
    name: "2. Arquitetura e Estrutura Limpa"
    skill: clean-architecture
    thinking_budget: 2000
    description: "Valida regras de design, separação de camadas e responsabilidades no código."

  - id: tdd_red_phase
    name: "3. TDD Fase Vermelha (RED) - Escrita de Testes"
    skill: code-quality-tests
    thinking_budget: 2000
    description: "Cria testes unitários ou de integração que devem falhar antes da implementação."

  - id: implementation_green
    name: "4. Implementação de Código (GREEN)"
    thinking_budget: 0
    description: "Escreve o código estritamente necessário para satisfazer os testes e a spec."

  - id: automated_validation_loop
    name: "6. Validação Contínua (Linter, Tipos e Testes)"
    skill: code-quality-tests
    thinking_budget: 1000
    description: "Executa os comandos de teste e lint do workspace alvo (mobile: flutter test / dart analyze; web: npm test / npm run lint) até garantir estabilidade completa."

  - id: git_semantic_commit
    name: "7. Versionamento Semântico no Git"
    thinking_budget: 0
    description: "Gera o commit convencional padronizado refletindo a spec implementada. Se task_id foi informado: marca a tarefa como done em _specs/tasks/ e regenera _specs/task-board.md (ranking, quadrantes e seção por target)."
    actions:
      - description: "Com task_id: marca status done na tarefa (todo/doing -> done)"
        command: >
          if [ -n "${inputs.task_id}" ]; then f=$(grep -rl "^id: \"${inputs.task_id}\"$" _specs/tasks/ | head -n 1); if [ -n "$f" ]; then sed -i 's/^status: .*/status: "done"/' "$f" && echo "Tarefa ${inputs.task_id} marcada como done em $f."; fi; fi

  - id: release
    name: "8. Release (gates, versionamento, build, entrega)"
    condition: "${inputs.release == true}"
    thinking_budget: 2000
    description: "Roda só com release: true. Segue flutter-release (gates via flutter test/dart analyze, bump no pubspec, tag v*, builds por platform com flavor prod) e entrega via mobile-cicd/store-publishing (beta interno ou produção com staged rollout)."
    skills:
      - flutter-release
      - mobile-cicd
      - store-publishing
'@ | Set-Content -Path ".agents\workflows\dev-cycle.yaml" -Encoding UTF8

# ------------------------------------------------------------------------------
# 8.1 harness-studio.html (Kanban, matriz 1:N, ciclo TDD e analisador de spec)
# ------------------------------------------------------------------------------
@'
<!DOCTYPE html>
<html lang="pt-BR">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Flutter Mobile Harness Studio v2.1</title>
<style>
  :root {
    --bg: #0b1020;
    --bg-2: #10182f;
    --panel: #151f3a;
    --panel-2: #1b2747;
    --line: #2a3a63;
    --text: #e8eefc;
    --muted: #9fb0d0;
    --brand: #4dd4ff;
    --brand-2: #7c5cff;
    --green: #35d07f;
    --red: #ff5c7a;
    --amber: #ffb84d;
    --violet: #b388ff;
    --shadow: 0 18px 45px rgba(0, 0, 0, .35);
    --radius: 16px;
    --mono: ui-monospace, SFMono-Regular, Menlo, Consolas, "Liberation Mono", monospace;
  }
  * { box-sizing: border-box; }
  html, body { margin: 0; padding: 0; }
  body {
    min-height: 100vh;
    background:
      radial-gradient(1100px 600px at 8% -10%, rgba(124, 92, 255, .22), transparent 60%),
      radial-gradient(900px 500px at 95% 0%, rgba(77, 212, 255, .16), transparent 55%),
      linear-gradient(180deg, #0a0f1e 0%, var(--bg) 45%, #080c18 100%);
    color: var(--text);
    font-family: Inter, "Segoe UI", system-ui, -apple-system, sans-serif;
    line-height: 1.5;
  }
  a { color: var(--brand); }
  button, input, select, textarea { font: inherit; color: inherit; }
  button { cursor: pointer; }
  :focus-visible { outline: 2px solid var(--brand); outline-offset: 2px; }
  .app { max-width: 1500px; margin: 0 auto; padding: 22px 20px 60px; }

  /* ---------- Header ---------- */
  header.hero {
    position: relative;
    overflow: hidden;
    border: 1px solid rgba(77, 212, 255, .22);
    border-radius: 22px;
    background: linear-gradient(120deg, rgba(21, 31, 58, .95), rgba(13, 20, 40, .95));
    box-shadow: var(--shadow);
    padding: 26px 28px;
  }
  header.hero::after {
    content: "";
    position: absolute;
    inset: -60% -20% auto auto;
    width: 520px; height: 520px;
    background: conic-gradient(from 90deg, rgba(77,212,255,.35), rgba(124,92,255,.35), transparent 60%);
    filter: blur(50px);
    opacity: .55;
    pointer-events: none;
  }
  .hero-top { display: flex; gap: 18px; align-items: flex-start; justify-content: space-between; flex-wrap: wrap; position: relative; z-index: 1; }
  .brand { display: flex; gap: 14px; align-items: center; }
  .logo {
    width: 54px; height: 54px; border-radius: 16px; display: grid; place-items: center;
    background: linear-gradient(135deg, var(--brand), var(--brand-2));
    color: #061021; font-weight: 900; font-size: 22px;
    box-shadow: 0 10px 30px rgba(77, 212, 255, .28);
  }
  h1 { margin: 0; font-size: clamp(1.35rem, 2.6vw, 2rem); letter-spacing: -.02em; }
  .subtitle { margin: 4px 0 0; color: var(--muted); font-size: .92rem; }
  .hero-actions { display: flex; gap: 10px; flex-wrap: wrap; }
  .pill-row { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 18px; position: relative; z-index: 1; }
  .pill {
    display: inline-flex; align-items: center; gap: 7px;
    padding: 6px 11px; border-radius: 999px; font-size: .78rem; font-weight: 600;
    border: 1px solid var(--line); background: rgba(11, 16, 32, .55); color: var(--muted);
  }
  .dot { width: 8px; height: 8px; border-radius: 50%; background: var(--green); box-shadow: 0 0 12px currentColor; }
  .dot.blue { background: var(--brand); }
  .dot.violet { background: var(--violet); }
  .dot.amber { background: var(--amber); }

  /* ---------- Buttons ---------- */
  .btn {
    border: 1px solid var(--line); background: var(--panel-2); color: var(--text);
    border-radius: 11px; padding: 9px 14px; font-weight: 650; font-size: .86rem;
    transition: transform .15s ease, border-color .15s ease, background .15s ease;
  }
  .btn:hover { transform: translateY(-1px); border-color: var(--brand); }
  .btn.primary { background: linear-gradient(135deg, var(--brand), #3aa8ff); border-color: transparent; color: #05101f; }
  .btn.violet { background: linear-gradient(135deg, var(--brand-2), #a06bff); border-color: transparent; color: #fff; }
  .btn.ghost { background: transparent; }
  .btn.danger { border-color: rgba(255, 92, 122, .45); color: #ffb3c1; }
  .btn.small { padding: 5px 9px; font-size: .76rem; border-radius: 8px; }
  .icon-btn {
    width: 30px; height: 30px; display: grid; place-items: center; border-radius: 8px;
    border: 1px solid var(--line); background: rgba(11, 16, 32, .5); color: var(--muted);
    font-size: .9rem; transition: .15s ease;
  }
  .icon-btn:hover { color: var(--text); border-color: var(--brand); }

  /* ---------- Tabs ---------- */
  nav.tabs { display: flex; gap: 8px; flex-wrap: wrap; margin: 22px 0 18px; }
  .tab {
    border: 1px solid var(--line); background: rgba(21, 31, 58, .6); color: var(--muted);
    padding: 10px 15px; border-radius: 12px; font-weight: 700; font-size: .88rem;
    display: inline-flex; align-items: center; gap: 8px; transition: .15s ease;
  }
  .tab:hover { color: var(--text); border-color: var(--brand); }
  .tab.active { color: #061021; background: linear-gradient(135deg, var(--brand), #7ee3ff); border-color: transparent; }
  .tab .badge { background: rgba(0,0,0,.18); padding: 1px 7px; border-radius: 999px; font-size: .72rem; }

  .view { display: none; animation: fade .22s ease; }
  .view.active { display: block; }
  @keyframes fade { from { opacity: 0; transform: translateY(6px); } to { opacity: 1; transform: none; } }

  /* ---------- Panels ---------- */
  .panel {
    background: linear-gradient(180deg, rgba(21, 31, 58, .92), rgba(16, 24, 47, .92));
    border: 1px solid var(--line); border-radius: var(--radius); box-shadow: var(--shadow);
    padding: 18px;
  }
  .panel + .panel { margin-top: 16px; }
  .panel-title { display: flex; align-items: center; justify-content: space-between; gap: 12px; flex-wrap: wrap; margin-bottom: 12px; }
  .panel-title h2 { margin: 0; font-size: 1.05rem; letter-spacing: -.01em; }
  .hint { color: var(--muted); font-size: .82rem; margin: 0; }
  .grid-2 { display: grid; grid-template-columns: minmax(0, 1.25fr) minmax(0, .75fr); gap: 16px; }
  @media (max-width: 980px) { .grid-2 { grid-template-columns: 1fr; } }

  /* ---------- Kanban ---------- */
  .kanban { display: grid; grid-template-columns: repeat(5, minmax(230px, 1fr)); gap: 12px; overflow-x: auto; padding-bottom: 8px; }
  @media (max-width: 1180px) { .kanban { grid-template-columns: repeat(5, 250px); } }
  .column {
    background: rgba(9, 14, 28, .55); border: 1px solid var(--line); border-radius: 14px;
    display: flex; flex-direction: column; min-height: 420px; overflow: hidden;
  }
  .column-head { padding: 12px 12px 10px; border-bottom: 1px solid var(--line); background: rgba(21, 31, 58, .6); }
  .column-title { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
  .column-title strong { font-size: .86rem; letter-spacing: .01em; }
  .column-title .count { font-size: .72rem; color: var(--muted); background: rgba(255,255,255,.06); border-radius: 999px; padding: 2px 8px; }
  .column-agent { display: block; margin-top: 4px; font-size: .7rem; color: var(--muted); }
  .column-body { padding: 10px; display: flex; flex-direction: column; gap: 9px; flex: 1; }
  .column.drag-over { border-color: var(--brand); box-shadow: inset 0 0 0 1px var(--brand); }
  .col-backlog { border-top: 3px solid #5b8cff; }
  .col-red { border-top: 3px solid var(--red); }
  .col-green { border-top: 3px solid var(--green); }
  .col-qa { border-top: 3px solid var(--amber); }
  .col-done { border-top: 3px solid var(--violet); }
  .card {
    background: linear-gradient(180deg, var(--panel-2), #18233f);
    border: 1px solid var(--line); border-radius: 12px; padding: 11px;
    cursor: grab; transition: transform .14s ease, border-color .14s ease, box-shadow .14s ease;
  }
  .card:hover { transform: translateY(-1px); border-color: rgba(77,212,255,.5); box-shadow: 0 8px 20px rgba(0,0,0,.25); }
  .card.dragging { opacity: .45; }
  .card-top { display: flex; align-items: center; justify-content: space-between; gap: 8px; }
  .card-id { font-family: var(--mono); font-size: .72rem; color: var(--brand); font-weight: 700; }
  .priority { font-size: .66rem; font-weight: 800; padding: 2px 7px; border-radius: 999px; }
  .p0 { background: rgba(255,92,122,.16); color: #ff9fb2; }
  .p1 { background: rgba(255,184,77,.16); color: #ffd18a; }
  .p2 { background: rgba(77,212,255,.14); color: #9fe9ff; }
  .card-title { margin: 7px 0 5px; font-size: .84rem; font-weight: 700; line-height: 1.3; }
  .card-desc { margin: 0; color: var(--muted); font-size: .73rem; line-height: 1.4; }
  .chips { display: flex; flex-wrap: wrap; gap: 4px; margin-top: 8px; }
  .chip { font-size: .64rem; color: #b9c7e6; background: rgba(255,255,255,.055); border: 1px solid rgba(255,255,255,.06); padding: 2px 6px; border-radius: 999px; }
  .card-foot { display: flex; align-items: center; justify-content: space-between; gap: 6px; margin-top: 9px; }
  .card-agent { font-size: .66rem; color: var(--muted); }
  .card-actions { display: flex; gap: 4px; }
  .empty-col { border: 1px dashed var(--line); border-radius: 10px; padding: 14px 10px; text-align: center; color: var(--muted); font-size: .74rem; }
  .wip-alert { color: #ffb3c1; font-size: .68rem; margin-top: 5px; display: none; }
  .wip-alert.show { display: block; }

  /* ---------- Forms ---------- */
  .form-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 10px; }
  @media (max-width: 760px) { .form-grid { grid-template-columns: 1fr; } }
  .field { display: flex; flex-direction: column; gap: 5px; }
  .field label { font-size: .72rem; font-weight: 700; color: var(--muted); text-transform: uppercase; letter-spacing: .05em; }
  .field input, .field select, .field textarea {
    background: #0b1225; border: 1px solid var(--line); border-radius: 9px; padding: 9px 10px;
    color: var(--text); outline: none; transition: border-color .15s ease;
  }
  .field input:focus, .field select:focus, .field textarea:focus { border-color: var(--brand); }
  .field textarea { resize: vertical; min-height: 90px; }
  .field select[multiple] { min-height: 110px; }
  .form-actions { display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px; }
  .inline { display: flex; gap: 8px; flex-wrap: wrap; align-items: center; }

  /* ---------- Agents ---------- */
  .agents-grid { display: grid; grid-template-columns: repeat(2, minmax(0, 1fr)); gap: 12px; }
  @media (max-width: 980px) { .agents-grid { grid-template-columns: 1fr; } }
  .agent-card { background: rgba(9, 14, 28, .55); border: 1px solid var(--line); border-radius: 13px; padding: 13px; }
  .agent-head { display: flex; align-items: flex-start; justify-content: space-between; gap: 10px; }
  .agent-name { margin: 0; font-size: .92rem; }
  .agent-phase { margin: 2px 0 0; font-size: .7rem; color: var(--muted); }
  .profile { font-size: .64rem; font-weight: 800; padding: 3px 8px; border-radius: 999px; background: rgba(124,92,255,.16); color: #c9b6ff; white-space: nowrap; }
  .skill-list { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 11px; max-height: 190px; overflow: auto; padding-right: 3px; }
  .skill-check {
    display: inline-flex; align-items: center; gap: 6px; padding: 4px 8px; border-radius: 999px;
    border: 1px solid var(--line); background: rgba(255,255,255,.03); font-size: .68rem; color: var(--muted);
    cursor: pointer; user-select: none;
  }
  .skill-check input { accent-color: var(--brand); width: 13px; height: 13px; }
  .skill-check.on { color: var(--text); border-color: rgba(77,212,255,.55); background: rgba(77,212,255,.1); }
  .agent-foot { display: flex; gap: 6px; margin-top: 10px; align-items: center; }
  .agent-foot input { flex: 1; min-width: 0; background: #0b1225; border: 1px solid var(--line); border-radius: 8px; padding: 6px 8px; font-size: .74rem; }
  .count-badge { font-size: .68rem; color: var(--brand); font-weight: 800; }
  .yaml-preview { width: 100%; min-height: 280px; background: #070d1c; border: 1px solid var(--line); border-radius: 11px; padding: 12px; font-family: var(--mono); font-size: .72rem; color: #b9d7ff; resize: vertical; }

  /* ---------- TDD ---------- */
  .tdd-flow { display: grid; grid-template-columns: repeat(3, minmax(0, 1fr)); gap: 12px; }
  @media (max-width: 860px) { .tdd-flow { grid-template-columns: 1fr; } }
  .tdd-step {
    position: relative; border: 1px solid var(--line); border-radius: 14px; padding: 16px;
    background: rgba(9, 14, 28, .55); transition: .2s ease; overflow: hidden;
  }
  .tdd-step::before { content: ""; position: absolute; inset: 0 auto 0 0; width: 4px; background: var(--line); }
  .tdd-step.active { border-color: rgba(77,212,255,.65); box-shadow: 0 0 0 1px rgba(77,212,255,.18), 0 14px 30px rgba(0,0,0,.22); transform: translateY(-2px); }
  .tdd-step.active::before { background: var(--brand); }
  .tdd-step.red.active { border-color: rgba(255,92,122,.65); }
  .tdd-step.red.active::before { background: var(--red); }
  .tdd-step.green.active { border-color: rgba(53,208,127,.65); }
  .tdd-step.green.active::before { background: var(--green); }
  .tdd-step.refactor.active { border-color: rgba(255,184,77,.65); }
  .tdd-step.refactor.active::before { background: var(--amber); }
  .tdd-kicker { font-size: .68rem; font-weight: 800; letter-spacing: .08em; text-transform: uppercase; color: var(--muted); }
  .tdd-step h3 { margin: 4px 0 6px; font-size: 1.05rem; }
  .tdd-step p { margin: 0; color: var(--muted); font-size: .8rem; }
  .tdd-cmd { display: block; margin-top: 10px; font-family: var(--mono); font-size: .72rem; color: #9fe9ff; background: #071022; border: 1px solid var(--line); border-radius: 8px; padding: 7px 9px; }
  .tdd-status { display: flex; align-items: center; gap: 12px; flex-wrap: wrap; margin-top: 14px; }
  .progress { flex: 1; min-width: 180px; height: 9px; border-radius: 999px; background: #0a1122; border: 1px solid var(--line); overflow: hidden; }
  .progress > span { display: block; height: 100%; width: 0; background: linear-gradient(90deg, var(--red), var(--green), var(--amber)); transition: width .3s ease; }
  .log { margin: 12px 0 0; padding: 0; list-style: none; max-height: 210px; overflow: auto; display: flex; flex-direction: column; gap: 6px; }
  .log li { font-family: var(--mono); font-size: .72rem; color: var(--muted); border-left: 2px solid var(--line); padding: 3px 0 3px 9px; }
  .log li strong { color: var(--text); }

  /* ---------- Spec analyzer ---------- */
  .analyzer-grid { display: grid; grid-template-columns: minmax(0, 1fr) minmax(0, .85fr); gap: 14px; }
  @media (max-width: 980px) { .analyzer-grid { grid-template-columns: 1fr; } }
  .score-wrap { display: flex; align-items: center; gap: 16px; flex-wrap: wrap; }
  .score-ring {
    --p: 0; width: 118px; height: 118px; border-radius: 50%; display: grid; place-items: center;
    background: conic-gradient(var(--brand) calc(var(--p) * 1%), #1a2544 0);
    position: relative; flex: 0 0 auto;
  }
  .score-ring::before { content: ""; position: absolute; inset: 9px; border-radius: 50%; background: #0c1428; }
  .score-ring strong { position: relative; font-size: 1.6rem; }
  .score-meta h3 { margin: 0 0 3px; font-size: 1rem; }
  .score-meta p { margin: 0; color: var(--muted); font-size: .8rem; }
  .check-list { display: flex; flex-direction: column; gap: 7px; margin-top: 12px; }
  .check-item { display: flex; gap: 8px; align-items: flex-start; font-size: .78rem; padding: 7px 9px; border-radius: 9px; border: 1px solid var(--line); background: rgba(255,255,255,.02); }
  .check-item.ok { border-color: rgba(53,208,127,.28); background: rgba(53,208,127,.06); }
  .check-item.miss { border-color: rgba(255,184,77,.28); background: rgba(255,184,77,.06); }
  .check-icon { flex: 0 0 auto; }
  .questions { margin: 12px 0 0; padding-left: 18px; display: flex; flex-direction: column; gap: 7px; color: #dbe6ff; font-size: .8rem; }
  .questions li::marker { color: var(--amber); }
  .vague { margin-top: 12px; display: flex; flex-wrap: wrap; gap: 6px; }
  .vague span { font-size: .68rem; border: 1px dashed rgba(255,184,77,.45); color: #ffd18a; padding: 3px 7px; border-radius: 999px; }
  .score-note { margin-top: 10px; font-size: .74rem; color: var(--muted); }

  /* ---------- Toast ---------- */
  .toast {
    position: fixed; right: 18px; bottom: 18px; z-index: 50; max-width: 360px;
    background: #101a33; border: 1px solid var(--brand); border-radius: 12px; padding: 11px 14px;
    box-shadow: var(--shadow); font-size: .82rem; transform: translateY(20px); opacity: 0; pointer-events: none;
    transition: .2s ease;
  }
  .toast.show { transform: none; opacity: 1; }
  .sr-only { position: absolute; width: 1px; height: 1px; padding: 0; margin: -1px; overflow: hidden; clip: rect(0,0,0,0); border: 0; }
  .footer { margin-top: 26px; color: var(--muted); font-size: .74rem; text-align: center; }
  .footer code { font-family: var(--mono); color: #b9d7ff; }
  ::-webkit-scrollbar { width: 9px; height: 9px; }
  ::-webkit-scrollbar-thumb { background: #2a3a63; border-radius: 999px; }
  ::-webkit-scrollbar-track { background: transparent; }
</style>
</head>
<body>
<div class="app">
  <header class="hero">
    <div class="hero-top">
      <div class="brand">
        <div class="logo" aria-hidden="true">F</div>
        <div>
          <h1>Flutter Mobile Harness Studio <span style="color:var(--brand)">v2.1</span></h1>
          <p class="subtitle">Kanban do ciclo Flutter, matriz 1:N de Agentes × Skills, visualizador TDD e analisador de especificação.</p>
        </div>
      </div>
      <div class="hero-actions">
        <button class="btn" id="btn-export" type="button">⬇ Exportar Kanban</button>
        <button class="btn ghost danger" id="btn-reset" type="button">↺ Resetar</button>
      </div>
    </div>
    <div class="pill-row" aria-label="Status do harness">
      <span class="pill"><span class="dot"></span> Dart MCP Server</span>
      <span class="pill"><span class="dot blue"></span> 9 subagentes</span>
      <span class="pill"><span class="dot violet"></span> 22 skills</span>
      <span class="pill"><span class="dot amber"></span> TDD Red → Green → Refactor</span>
      <span class="pill">model_profiles: <strong>inherit</strong></span>
    </div>
  </header>

  <nav class="tabs" role="tablist" aria-label="Seções do studio">
    <button class="tab active" data-tab="kanban" role="tab" aria-selected="true">🗂️ Kanban <span class="badge" id="tab-kanban-count">0</span></button>
    <button class="tab" data-tab="agents" role="tab" aria-selected="false">🧩 Agentes &amp; Skills <span class="badge">1:N</span></button>
    <button class="tab" data-tab="tdd" role="tab" aria-selected="false">🔁 Ciclo TDD</button>
    <button class="tab" data-tab="spec" role="tab" aria-selected="false">🔎 Analisador de Spec</button>
  </nav>

  <!-- ============================= KANBAN ============================= -->
  <section class="view active" id="view-kanban" role="tabpanel" aria-label="Kanban">
    <div class="panel">
      <div class="panel-title">
        <div>
          <h2>Kanban do ciclo Flutter</h2>
          <p class="hint">Arraste os cards entre as colunas ou use os botões de ação. Tudo é salvo no <code>localStorage</code>.</p>
        </div>
        <div class="inline">
          <button class="btn small" id="btn-add-card" type="button">＋ Novo card</button>
        </div>
      </div>

      <form id="card-form" class="panel" style="display:none; margin-bottom:14px; box-shadow:none; background:rgba(9,14,28,.55)">
        <input type="hidden" id="card-edit-id" />
        <div class="form-grid">
          <div class="field">
            <label for="card-title">Título</label>
            <input id="card-title" required maxlength="90" placeholder="Ex.: Recuperação de senha com deep link" />
          </div>
          <div class="field">
            <label for="card-agent">Agente responsável</label>
            <select id="card-agent"></select>
          </div>
          <div class="field">
            <label for="card-priority">Prioridade</label>
            <select id="card-priority">
              <option value="P0">P0 — crítico</option>
              <option value="P1" selected>P1 — alto</option>
              <option value="P2">P2 — normal</option>
            </select>
          </div>
          <div class="field">
            <label for="card-status">Coluna</label>
            <select id="card-status"></select>
          </div>
          <div class="field" style="grid-column:1/-1">
            <label for="card-skills">Skills (Ctrl/Cmd para múltiplas)</label>
            <select id="card-skills" multiple></select>
          </div>
          <div class="field" style="grid-column:1/-1">
            <label for="card-desc">Descrição / critério de aceitação</label>
            <textarea id="card-desc" maxlength="240" placeholder="O que precisa estar verdadeiro para o card avançar?"></textarea>
          </div>
        </div>
        <div class="form-actions">
          <button class="btn primary" type="submit" id="card-submit">Salvar card</button>
          <button class="btn ghost" type="button" id="card-cancel">Cancelar</button>
        </div>
      </form>

      <div class="kanban" id="kanban" aria-live="polite"></div>
    </div>
  </section>

  <!-- ============================= AGENTS ============================= -->
  <section class="view" id="view-agents" role="tabpanel" aria-label="Agentes e Skills">
    <div class="panel">
      <div class="panel-title">
        <div>
          <h2>Matriz 1:N — Agentes × Skills</h2>
          <p class="hint">Cada subagente pode ativar 1 ou mais skills. As alterações são refletidas no preview YAML abaixo.</p>
        </div>
        <div class="inline">
          <button class="btn small" id="btn-copy-yaml" type="button">📋 Copiar YAML</button>
          <button class="btn small ghost" id="btn-reset-agents" type="button">Restaurar padrão</button>
        </div>
      </div>
      <div class="agents-grid" id="agents-grid"></div>
    </div>
    <div class="panel">
      <div class="panel-title">
        <div>
          <h2>Preview editável — <code>subagents</code></h2>
          <p class="hint">Bloco pronto para colar em <code>.agents/harness.yaml</code>. Perfis permanecem <code>inherit</code>.</p>
        </div>
      </div>
      <textarea class="yaml-preview" id="yaml-preview" spellcheck="false" aria-label="Preview YAML dos subagentes"></textarea>
    </div>
  </section>

  <!-- ============================= TDD ============================= -->
  <section class="view" id="view-tdd" role="tabpanel" aria-label="Ciclo TDD">
    <div class="panel">
      <div class="panel-title">
        <div>
          <h2>Visualizador do ciclo TDD</h2>
          <p class="hint">Avança somente quando o gate da fase atual estiver comprovado. O log registra cada transição.</p>
        </div>
        <div class="inline">
          <button class="btn primary" id="btn-tdd-next" type="button">Avançar fase →</button>
          <button class="btn ghost" id="btn-tdd-reset" type="button">Resetar ciclo</button>
        </div>
      </div>
      <div class="tdd-flow" id="tdd-flow"></div>
      <div class="tdd-status">
        <div class="progress" aria-hidden="true"><span id="tdd-progress"></span></div>
        <span class="pill" id="tdd-phase-label">Fase: RED</span>
        <span class="pill" id="tdd-cycle-label">Ciclo: 1</span>
      </div>
      <ul class="log" id="tdd-log" aria-live="polite"></ul>
    </div>
  </section>

  <!-- ============================= SPEC ============================= -->
  <section class="view" id="view-spec" role="tabpanel" aria-label="Analisador de especificação">
    <div class="panel">
      <div class="panel-title">
        <div>
          <h2>Analisador de perguntas de especificação</h2>
          <p class="hint">Cole a spec/PRD. O analisador aponta lacunas e gera perguntas objetivas em pt-BR antes do código.</p>
        </div>
        <div class="inline">
          <button class="btn small" id="btn-sample-spec" type="button">Carregar exemplo</button>
          <button class="btn primary" id="btn-analyze" type="button">Analisar spec</button>
        </div>
      </div>
      <div class="analyzer-grid">
        <div class="field">
          <label for="spec-input">Spec / PRD / descrição da feature</label>
          <textarea id="spec-input" style="min-height:340px" placeholder="Cole aqui o PRD, a spec da feature ou a descrição do pedido. Ex.: 'Quero uma tela de recuperação de senha com e-mail e código.'"></textarea>
          <div class="form-actions">
            <button class="btn small" id="btn-copy-questions" type="button">Copiar perguntas</button>
            <span class="hint" id="spec-char-count">0 caracteres</span>
          </div>
        </div>
        <div>
          <div class="score-wrap">
            <div class="score-ring" id="score-ring" aria-hidden="true"><strong id="score-value">0%</strong></div>
            <div class="score-meta">
              <h3 id="score-title" aria-live="polite">Aguardando análise</h3>
              <p id="score-subtitle">Cole uma spec e clique em “Analisar spec”.</p>
            </div>
          </div>
          <div class="check-list" id="check-list"></div>
          <div class="vague" id="vague-list"></div>
          <ol class="questions" id="questions-list"></ol>
          <p class="score-note" id="score-note"></p>
        </div>
      </div>
    </div>
  </section>

  <p class="footer">
    Gerado pelo <strong>Flutter Mobile Harness v2.1</strong> · Arquivos relacionados:
    <code>.agents/harness.yaml</code> · <code>.agents/mcp.json</code> · <code>_specs/task-board.md</code>
  </p>
</div>

<div class="toast" id="toast" role="status" aria-live="polite"></div>

<script>
(function () {
  "use strict";

  /* ============================================================
     Catálogo canônico
     ============================================================ */
  const SKILLS = [
    { id: "spec-discovery", label: "Spec Discovery", group: "Produto" },
    { id: "antigravity-skill-orchestrator", label: "Skill Orchestrator", group: "Produto" },
    { id: "mobile-ux", label: "Mobile UX / Stitch", group: "Design" },
    { id: "flutter-build-responsive-layout", label: "Responsive Layout", group: "Design" },
    { id: "flutter-setup-declarative-routing", label: "Declarative Routing", group: "Design" },
    { id: "flutter-setup-localization", label: "Localization", group: "Design" },
    { id: "flutter-apply-architecture-best-practices", label: "Flutter Architecture", group: "Build" },
    { id: "clean-architecture", label: "Clean Architecture", group: "Build" },
    { id: "flutter-state-riverpod", label: "Riverpod State", group: "Build" },
    { id: "dart-use-pattern-matching", label: "Pattern Matching", group: "Build" },
    { id: "flutter-use-http-package", label: "HTTP Package", group: "Data" },
    { id: "local-first-data", label: "Local-First / Drift", group: "Data" },
    { id: "supabase-flutter", label: "Supabase Flutter", group: "Data" },
    { id: "code-quality-tests", label: "Code Quality & Tests", group: "Qualidade" },
    { id: "flutter-add-widget-test", label: "Widget Tests", group: "Qualidade" },
    { id: "flutter-add-integration-test", label: "Integration Tests", group: "Qualidade" },
    { id: "dart-collect-coverage", label: "Coverage / LCOV", group: "Qualidade" },
    { id: "flutter-release", label: "Flutter Release", group: "Entrega" },
    { id: "mobile-cicd", label: "Mobile CI/CD", group: "Entrega" },
    { id: "store-publishing", label: "Store Publishing", group: "Entrega" },
    { id: "harness-evolver", label: "Harness Evolver", group: "Evolução" },
    { id: "web-performance-seo", label: "Web Performance/SEO", group: "Web" }
  ];

  const AGENTS = [
    {
      id: "product_architect", name: "Product Architect", phase: "Fase 1 — Descoberta, Specs & Kanban",
      profile: "reasoning", color: "#5b8cff",
      role: "Entrevista o desenvolvedor, formula perguntas, cria specs e organiza o Kanban.",
      skills: ["spec-discovery", "antigravity-skill-orchestrator", "flutter-apply-architecture-best-practices"]
    },
    {
      id: "ui_ux_designer", name: "UI/UX Designer", phase: "Fase 2 — UI/UX, Tokens, Responsividade & Rotas",
      profile: "multimodal_design", color: "#b388ff",
      role: "Extrai Design DNA via Stitch MCP, projeta layouts e navegação declarativa.",
      skills: ["mobile-ux", "flutter-build-responsive-layout", "flutter-setup-declarative-routing", "flutter-setup-localization"]
    },
    {
      id: "tdd_tester", name: "TDD Tester", phase: "Fase 3 — TDD Vermelho (RED)",
      profile: "coding", color: "#ff5c7a",
      role: "Cria testes unitários, widget e integration que falham antes do código.",
      skills: ["code-quality-tests", "flutter-add-widget-test", "flutter-add-integration-test", "dart-collect-coverage"]
    },
    {
      id: "mobile_builder", name: "Mobile Builder", phase: "Fase 4A — Construção Flutter (GREEN)",
      profile: "coding", color: "#35d07f",
      role: "Escreve Dart 3/Flutter tipado e desacoplado para os testes ficarem verdes.",
      skills: ["clean-architecture", "flutter-apply-architecture-best-practices", "flutter-state-riverpod", "dart-use-pattern-matching"]
    },
    {
      id: "data_offline_specialist", name: "Data & Offline Specialist", phase: "Fase 4B — SQLite, Sync & APIs",
      profile: "coding", color: "#2fb6c9",
      role: "Implementa DAOs, repositórios offline-first, índices SQLite, REST/Supabase.",
      skills: ["local-first-data", "flutter-use-http-package", "supabase-flutter", "clean-architecture"]
    },
    {
      id: "qa_validator", name: "QA Validator", phase: "Fase 5 — Validação & Autorreparo (REFACTOR)",
      profile: "coding", color: "#ffb84d",
      role: "Executa dart analyze/flutter test via Dart MCP e conduz até 3 ciclos de reparo.",
      skills: ["code-quality-tests", "dart-collect-coverage"]
    },
    {
      id: "flutter_a11y_auditor", name: "Flutter A11y Auditor", phase: "Fase 6 — Acessibilidade & Ergonomia",
      profile: "coding", color: "#ff8a65",
      role: "Audita Semantics, leitores de tela, contraste WCAG AA e touch targets 48x48dp.",
      skills: ["mobile-ux", "flutter-build-responsive-layout", "flutter-add-widget-test"]
    },
    {
      id: "harness_evolver", name: "Harness Evolver", phase: "Fase 7 — Evolução Propose-Probe-Compose",
      profile: "reasoning", color: "#7c5cff",
      role: "Analisa falhas recorrentes e atualiza SKILL.md/PROJECT_BRAIN.md.",
      skills: ["harness-evolver", "antigravity-skill-orchestrator"]
    },
    {
      id: "git_committer", name: "Git Committer", phase: "Fase 8 — Commit, CI/CD & Publicação",
      profile: "fast_ops", color: "#9fb0d0",
      role: "Inspeciona o diff, atualiza o Kanban e cria o commit semântico atômico.",
      skills: ["flutter-release", "mobile-cicd", "store-publishing"]
    }
  ];

  const COLUMNS = [
    { id: "backlog", title: "Backlog", icon: "🗂️", agent: "@product_architect", cls: "col-backlog", wip: 99, desc: "Spec & critérios" },
    { id: "red", title: "TDD RED", icon: "🔴", agent: "@tdd_tester", cls: "col-red", wip: 2, desc: "Teste falha" },
    { id: "green", title: "TDD GREEN", icon: "🟢", agent: "@mobile_builder", cls: "col-green", wip: 2, desc: "Código mínimo" },
    { id: "qa", title: "Loop QA/A11y", icon: "🔁", agent: "@qa_validator", cls: "col-qa", wip: 1, desc: "Reparo & a11y" },
    { id: "done", title: "Concluído", icon: "✅", agent: "@git_committer", cls: "col-done", wip: 99, desc: "Commit atômico" }
  ];

  const TDD_PHASES = [
    { id: "red", title: "RED", kicker: "1. Falha primeiro", desc: "Escreva o teste que representa o critério de aceitação e prove que ele falha pelo motivo correto.", cmd: "flutter test test/feature_test.dart", color: "#ff5c7a" },
    { id: "green", title: "GREEN", kicker: "2. Código mínimo", desc: "Implemente apenas o necessário para a suíte ficar verde. Sem scope creep, sem otimização prematura.", cmd: "flutter test", color: "#35d07f" },
    { id: "refactor", title: "REFACTOR", kicker: "3. Limpeza segura", desc: "Remova duplicação, melhore nomes e mantenha a suíte verde. QA roda analyze + cobertura + a11y.", cmd: "dart analyze && flutter test --coverage", color: "#ffb84d" }
  ];

  const DEFAULT_CARDS = [
    { id: "T01", title: "Recuperação de Senha", status: "backlog", agent: "product_architect", priority: "P1", skills: ["spec-discovery", "clean-architecture"], desc: "Fluxo de e-mail + código com deep link e expiração." },
    { id: "T02", title: "Dashboard Gerencial", status: "backlog", agent: "ui_ux_designer", priority: "P1", skills: ["mobile-ux", "flutter-build-responsive-layout"], desc: "Cards responsivos com os 4 estados de tela." },
    { id: "T03", title: "Push Notifications", status: "backlog", agent: "data_offline_specialist", priority: "P2", skills: ["local-first-data"], desc: "Permissão, token e fila offline de notificações." },
    { id: "T04", title: "In-App Purchases", status: "backlog", agent: "git_committer", priority: "P2", skills: ["store-publishing"], desc: "Produtos, restore e validação de recibos." },
    { id: "T05", title: "Backend Alternativo / Sync", status: "backlog", agent: "data_offline_specialist", priority: "P1", skills: ["supabase-flutter", "local-first-data"], desc: "Sync incremental com RLS e resolução de conflitos." },
    { id: "T00", title: "Unificação do Harness v2.1", status: "done", agent: "harness_evolver", priority: "P0", skills: ["harness-evolver", "antigravity-skill-orchestrator"], desc: "Dart MCP Server, 9 agentes, matriz 1:N e studio HTML." }
  ];

  const STORAGE_KEY = "flutter-mobile-harness-studio-v2.1";
  const DEFAULT_STATE = {
    cards: DEFAULT_CARDS,
    agentSkills: Object.fromEntries(AGENTS.map(a => [a.id, a.skills.slice()])),
    tdd: { phase: 0, cycle: 1, log: [] },
    specText: ""
  };

  let state = loadState();
  let toastTimer = null;

  /* ============================================================
     Persistência
     ============================================================ */
  function clone(value) { return JSON.parse(JSON.stringify(value)); }

  function loadState() {
    try {
      const raw = localStorage.getItem(STORAGE_KEY);
      if (!raw) return clone(DEFAULT_STATE);
      const parsed = JSON.parse(raw);
      return {
        cards: Array.isArray(parsed.cards) ? parsed.cards : clone(DEFAULT_CARDS),
        agentSkills: Object.assign(
          Object.fromEntries(AGENTS.map(a => [a.id, a.skills.slice()])),
          parsed.agentSkills || {}
        ),
        tdd: Object.assign({ phase: 0, cycle: 1, log: [] }, parsed.tdd || {}),
        specText: typeof parsed.specText === "string" ? parsed.specText : ""
      };
    } catch (error) {
      return clone(DEFAULT_STATE);
    }
  }

  function saveState() {
    try {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(state));
    } catch (error) {
      toast("Não foi possível salvar no localStorage.");
    }
  }

  function toast(message) {
    const el = document.getElementById("toast");
    el.textContent = message;
    el.classList.add("show");
    clearTimeout(toastTimer);
    toastTimer = setTimeout(() => el.classList.remove("show"), 2600);
  }

  function escapeHtml(value) {
    return String(value == null ? "" : value)
      .replace(/&/g, "&amp;")
      .replace(/</g, "&lt;")
      .replace(/>/g, "&gt;")
      .replace(/"/g, "&quot;")
      .replace(/'/g, "&#039;");
  }

  function agentById(id) { return AGENTS.find(a => a.id === id) || AGENTS[0]; }
  function skillLabel(id) { const s = SKILLS.find(x => x.id === id); return s ? s.label : id; }

  /* ============================================================
     Tabs
     ============================================================ */
  document.querySelectorAll(".tab").forEach(tab => {
    tab.addEventListener("click", () => {
      document.querySelectorAll(".tab").forEach(t => {
        t.classList.toggle("active", t === tab);
        t.setAttribute("aria-selected", String(t === tab));
      });
      document.querySelectorAll(".view").forEach(view => view.classList.remove("active"));
      document.getElementById("view-" + tab.dataset.tab).classList.add("active");
    });
  });

  /* ============================================================
     Kanban
     ============================================================ */
  const kanbanEl = document.getElementById("kanban");
  const cardForm = document.getElementById("card-form");
  const cardEditId = document.getElementById("card-edit-id");
  const cardTitle = document.getElementById("card-title");
  const cardAgent = document.getElementById("card-agent");
  const cardPriority = document.getElementById("card-priority");
  const cardStatus = document.getElementById("card-status");
  const cardSkills = document.getElementById("card-skills");
  const cardDesc = document.getElementById("card-desc");
  const cardSubmit = document.getElementById("card-submit");

  function fillSelect(select, options, value) {
    select.innerHTML = options.map(o => `<option value="${escapeHtml(o.value)}">${escapeHtml(o.label)}</option>`).join("");
    if (value != null) select.value = value;
  }

  fillSelect(cardAgent, AGENTS.map(a => ({ value: a.id, label: a.name + " — " + a.phase })));
  fillSelect(cardStatus, COLUMNS.map(c => ({ value: c.id, label: c.icon + " " + c.title })));
  cardSkills.innerHTML = SKILLS.map(s => `<option value="${escapeHtml(s.id)}">${escapeHtml(s.label)} (${escapeHtml(s.group)})</option>`).join("");

  function openCardForm(status, card) {
    cardForm.style.display = "block";
    cardEditId.value = card ? card.id : "";
    cardTitle.value = card ? card.title : "";
    cardAgent.value = card ? card.agent : "product_architect";
    cardPriority.value = card ? card.priority : "P1";
    cardStatus.value = card ? card.status : (status || "backlog");
    cardDesc.value = card ? card.desc : "";
    Array.from(cardSkills.options).forEach(o => { o.selected = card ? card.skills.includes(o.value) : false; });
    cardSubmit.textContent = card ? "Atualizar card" : "Salvar card";
    cardTitle.focus();
  }

  function closeCardForm() {
    cardForm.style.display = "none";
    cardForm.reset();
    cardEditId.value = "";
    cardSubmit.textContent = "Salvar card";
  }

  document.getElementById("btn-add-card").addEventListener("click", () => openCardForm("backlog", null));
  document.getElementById("card-cancel").addEventListener("click", closeCardForm);

  cardForm.addEventListener("submit", event => {
    event.preventDefault();
    const editing = cardEditId.value;
    const selectedSkills = Array.from(cardSkills.selectedOptions).map(o => o.value);
    const payload = {
      title: cardTitle.value.trim(),
      agent: cardAgent.value,
      priority: cardPriority.value,
      status: cardStatus.value,
      desc: cardDesc.value.trim(),
      skills: selectedSkills.length ? selectedSkills : ["spec-discovery"]
    };
    if (!payload.title) return;

    if (editing) {
      const card = state.cards.find(c => c.id === editing);
      if (card) Object.assign(card, payload);
      toast("Card " + editing + " atualizado.");
    } else {
      const nextNumber = state.cards.reduce((max, c) => {
        const n = parseInt(String(c.id).replace(/\D/g, ""), 10);
        return Number.isFinite(n) ? Math.max(max, n) : max;
      }, 0) + 1;
      state.cards.push(Object.assign({ id: "T" + String(nextNumber).padStart(2, "0") }, payload));
      toast("Card criado no backlog do ciclo.");
    }
    saveState();
    renderKanban();
    closeCardForm();
  });

  function renderKanban() {
    kanbanEl.innerHTML = "";
    COLUMNS.forEach(column => {
      const cards = state.cards.filter(c => c.status === column.id);
      const col = document.createElement("section");
      col.className = "column " + column.cls;
      col.dataset.status = column.id;
      col.innerHTML = `
        <div class="column-head">
          <div class="column-title">
            <strong>${column.icon} ${escapeHtml(column.title)}</strong>
            <span class="count">${cards.length}${column.wip < 99 ? "/" + column.wip : ""}</span>
          </div>
          <span class="column-agent">${escapeHtml(column.agent)} · ${escapeHtml(column.desc)}</span>
          <span class="wip-alert ${cards.length > column.wip ? "show" : ""}">WIP excedido: reduza o trabalho em progresso.</span>
        </div>
        <div class="column-body" data-drop="${column.id}"></div>
      `;
      const body = col.querySelector(".column-body");
      if (!cards.length) {
        body.innerHTML = `<div class="empty-col">Nenhuma tarefa ativa.<br>Arraste um card ou clique em ＋.</div>`;
      } else {
        cards.forEach(card => body.appendChild(renderCard(card)));
      }

      col.addEventListener("dragover", event => {
        event.preventDefault();
        col.classList.add("drag-over");
      });
      col.addEventListener("dragleave", () => col.classList.remove("drag-over"));
      col.addEventListener("drop", event => {
        event.preventDefault();
        col.classList.remove("drag-over");
        const id = event.dataTransfer.getData("text/plain");
        moveCard(id, column.id);
      });
      kanbanEl.appendChild(col);
    });
    document.getElementById("tab-kanban-count").textContent = String(state.cards.length);
  }

  function renderCard(card) {
    const el = document.createElement("article");
    el.className = "card";
    el.draggable = true;
    el.dataset.id = card.id;
    el.innerHTML = `
      <div class="card-top">
        <span class="card-id">${escapeHtml(card.id)}</span>
        <span class="priority ${String(card.priority).toLowerCase()}">${escapeHtml(card.priority)}</span>
      </div>
      <h3 class="card-title">${escapeHtml(card.title)}</h3>
      ${card.desc ? `<p class="card-desc">${escapeHtml(card.desc)}</p>` : ""}
      <div class="chips">${(card.skills || []).map(s => `<span class="chip">${escapeHtml(skillLabel(s))}</span>`).join("")}</div>
      <div class="card-foot">
        <span class="card-agent">@${escapeHtml(agentById(card.agent).id)}</span>
        <span class="card-actions">
          <button class="icon-btn" data-action="edit" data-id="${escapeHtml(card.id)}" title="Editar" aria-label="Editar ${escapeHtml(card.id)}">✎</button>
          <button class="icon-btn" data-action="advance" data-id="${escapeHtml(card.id)}" title="Avançar coluna" aria-label="Avançar ${escapeHtml(card.id)}">→</button>
          <button class="icon-btn" data-action="delete" data-id="${escapeHtml(card.id)}" title="Excluir" aria-label="Excluir ${escapeHtml(card.id)}">×</button>
        </span>
      </div>
    `;
    el.addEventListener("dragstart", event => {
      el.classList.add("dragging");
      event.dataTransfer.setData("text/plain", card.id);
      event.dataTransfer.effectAllowed = "move";
    });
    el.addEventListener("dragend", () => el.classList.remove("dragging"));
    return el;
  }

  kanbanEl.addEventListener("click", event => {
    const button = event.target.closest("[data-action]");
    if (!button) return;
    const card = state.cards.find(c => c.id === button.dataset.id);
    if (!card) return;
    if (button.dataset.action === "edit") openCardForm(card.status, card);
    if (button.dataset.action === "advance") {
      const index = COLUMNS.findIndex(c => c.id === card.status);
      const next = COLUMNS[Math.min(index + 1, COLUMNS.length - 1)];
      moveCard(card.id, next.id);
    }
    if (button.dataset.action === "delete") {
      if (!confirm("Excluir o card " + card.id + "?")) return;
      state.cards = state.cards.filter(c => c.id !== card.id);
      saveState();
      renderKanban();
      toast("Card " + card.id + " excluído.");
    }
  });

  function moveCard(id, status) {
    const card = state.cards.find(c => c.id === id);
    if (!card || card.status === status) return;
    card.status = status;
    saveState();
    renderKanban();
    toast(card.id + " movido para " + COLUMNS.find(c => c.id === status).title + ".");
  }

  function exportKanban() {
    const lines = [
      "# 📋 Kanban de Desenvolvimento do Projeto (`task-board.md`)",
      "",
      "> Exportado do `harness-studio.html` — Flutter Mobile Harness v2.1.",
      ""
    ];
    COLUMNS.forEach(column => {
      const cards = state.cards.filter(c => c.status === column.id);
      lines.push("## " + column.icon + " " + column.title + " (`" + column.agent + "`)");
      if (!cards.length) {
        lines.push("*(Nenhuma tarefa ativa nesta coluna)*", "");
        return;
      }
      cards.forEach(card => {
        const mark = column.id === "done" ? "x" : " ";
        lines.push("- [" + mark + "] **" + card.id + "** — " + card.title +
          " | Agente: `@" + card.agent + "` | Skills: " +
          (card.skills || []).map(s => "`" + s + "`").join(", ") +
          " | Prioridade: " + card.priority);
        if (card.desc) lines.push("  - " + card.desc);
      });
      lines.push("");
    });
    lines.push("---", "", "Gerado por `harness-studio.html` em " + new Date().toLocaleString("pt-BR") + ".");
    const blob = new Blob([lines.join("\n")], { type: "text/markdown;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "task-board.md";
    a.click();
    URL.revokeObjectURL(url);
    toast("Kanban exportado como task-board.md.");
  }

  document.getElementById("btn-export").addEventListener("click", exportKanban);

  /* ============================================================
     Agentes & Skills (1:N)
     ============================================================ */
  const agentsGrid = document.getElementById("agents-grid");
  const yamlPreview = document.getElementById("yaml-preview");

  function renderAgents() {
    agentsGrid.innerHTML = "";
    AGENTS.forEach(agent => {
      const selected = state.agentSkills[agent.id] || [];
      const card = document.createElement("article");
      card.className = "agent-card";
      card.style.borderTop = "3px solid " + agent.color;
      card.innerHTML = `
        <div class="agent-head">
          <div>
            <h3 class="agent-name">${escapeHtml(agent.name)}</h3>
            <p class="agent-phase">${escapeHtml(agent.phase)}</p>
          </div>
          <span class="profile">${escapeHtml(agent.profile)}</span>
        </div>
        <p class="hint" style="margin-top:6px">${escapeHtml(agent.role)}</p>
        <div class="skill-list">
          ${SKILLS.map(skill => {
            const on = selected.includes(skill.id);
            return `<label class="skill-check ${on ? "on" : ""}" title="${escapeHtml(skill.group)}">
              <input type="checkbox" data-agent="${escapeHtml(agent.id)}" value="${escapeHtml(skill.id)}" ${on ? "checked" : ""} />
              ${escapeHtml(skill.label)}
            </label>`;
          }).join("")}
          ${selected.filter(id => !SKILLS.some(skill => skill.id === id)).map(id => `
            <label class="skill-check on" title="Skill customizada">
              <input type="checkbox" data-agent="${escapeHtml(agent.id)}" value="${escapeHtml(id)}" checked />
              ${escapeHtml(id)}
            </label>
          `).join("")}
        </div>
        <div class="agent-foot">
          <input type="text" placeholder="Adicionar skill customizada…" data-custom-agent="${escapeHtml(agent.id)}" aria-label="Adicionar skill customizada para ${escapeHtml(agent.name)}" />
          <button class="btn small" data-add-skill="${escapeHtml(agent.id)}" type="button">＋</button>
          <span class="count-badge">${selected.length} skill(s)</span>
        </div>
      `;
      agentsGrid.appendChild(card);
    });
    updateYamlPreview();
  }

  agentsGrid.addEventListener("change", event => {
    const input = event.target.closest("input[type=checkbox][data-agent]");
    if (!input) return;
    const agentId = input.dataset.agent;
    const set = new Set(state.agentSkills[agentId] || []);
    if (input.checked) set.add(input.value);
    else set.delete(input.value);
    if (!set.size) {
      input.checked = true;
      toast("Cada agente precisa de pelo menos 1 skill (regra 1:N).");
      return;
    }
    state.agentSkills[agentId] = Array.from(set);
    saveState();
    renderAgents();
  });

  agentsGrid.addEventListener("click", event => {
    const button = event.target.closest("[data-add-skill]");
    if (!button) return;
    const agentId = button.dataset.addSkill;
    const input = agentsGrid.querySelector('[data-custom-agent="' + agentId + '"]');
    const value = input.value.trim();
    if (!value) return;
    const slug = value.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/^-|-$/g, "");
    if (!slug) return;
    if (!state.agentSkills[agentId].includes(slug)) {
      state.agentSkills[agentId].push(slug);
      saveState();
      renderAgents();
      toast("Skill customizada '" + slug + "' adicionada.");
    } else {
      toast("Essa skill já está ativa neste agente.");
    }
  });

  function updateYamlPreview() {
    const lines = ["subagents:"];
    AGENTS.forEach(agent => {
      lines.push("  " + agent.id + ":");
      lines.push('    profile: "' + agent.profile + '"');
      lines.push('    phase: "' + agent.phase + '"');
      lines.push('    skills:');
      (state.agentSkills[agent.id] || []).forEach(skill => {
        lines.push('      - ".agents/skills/' + skill + '/SKILL.md"');
      });
    });
    yamlPreview.value = lines.join("\n");
  }

  document.getElementById("btn-copy-yaml").addEventListener("click", async () => {
    try {
      await navigator.clipboard.writeText(yamlPreview.value);
      toast("YAML copiado para a área de transferência.");
    } catch (error) {
      yamlPreview.select();
      document.execCommand("copy");
      toast("YAML copiado (fallback).");
    }
  });

  document.getElementById("btn-reset-agents").addEventListener("click", () => {
    if (!confirm("Restaurar a matriz 1:N padrão de todos os agentes?")) return;
    state.agentSkills = Object.fromEntries(AGENTS.map(a => [a.id, a.skills.slice()]));
    saveState();
    renderAgents();
    toast("Matriz de skills restaurada.");
  });

  /* ============================================================
     TDD
     ============================================================ */
  const tddFlow = document.getElementById("tdd-flow");
  const tddLog = document.getElementById("tdd-log");
  const tddProgress = document.getElementById("tdd-progress");
  const tddPhaseLabel = document.getElementById("tdd-phase-label");
  const tddCycleLabel = document.getElementById("tdd-cycle-label");

  function renderTdd() {
    tddFlow.innerHTML = "";
    TDD_PHASES.forEach((phase, index) => {
      const step = document.createElement("article");
      step.className = "tdd-step " + phase.id + (state.tdd.phase === index ? " active" : "");
      step.innerHTML = `
        <span class="tdd-kicker">${escapeHtml(phase.kicker)}</span>
        <h3 style="color:${phase.color}">${escapeHtml(phase.title)}</h3>
        <p>${escapeHtml(phase.desc)}</p>
        <code class="tdd-cmd">$ ${escapeHtml(phase.cmd)}</code>
      `;
      tddFlow.appendChild(step);
    });
    const phase = TDD_PHASES[state.tdd.phase] || TDD_PHASES[0];
    tddProgress.style.width = Math.round(((state.tdd.phase + 1) / TDD_PHASES.length) * 100) + "%";
    tddPhaseLabel.textContent = "Fase: " + phase.title;
    tddCycleLabel.textContent = "Ciclo: " + state.tdd.cycle;
    tddLog.innerHTML = state.tdd.log.length
      ? state.tdd.log.map(entry => `<li><strong>${escapeHtml(entry.time)}</strong> — ${escapeHtml(entry.message)}</li>`).join("")
      : `<li>Aguardando o primeiro avanço do ciclo.</li>`;
  }

  function pushTddLog(message) {
    state.tdd.log.unshift({ time: new Date().toLocaleTimeString("pt-BR"), message });
    state.tdd.log = state.tdd.log.slice(0, 40);
  }

  document.getElementById("btn-tdd-next").addEventListener("click", () => {
    const current = TDD_PHASES[state.tdd.phase];
    state.tdd.phase += 1;
    if (state.tdd.phase >= TDD_PHASES.length) {
      state.tdd.phase = 0;
      state.tdd.cycle += 1;
      pushTddLog("Ciclo " + (state.tdd.cycle - 1) + " concluído. Iniciando ciclo " + state.tdd.cycle + " em RED.");
    } else {
      pushTddLog("Gate de " + current.title + " aprovado. Avançando para " + TDD_PHASES[state.tdd.phase].title + ".");
    }
    saveState();
    renderTdd();
  });

  document.getElementById("btn-tdd-reset").addEventListener("click", () => {
    if (!confirm("Resetar o ciclo TDD para RED e limpar o log?")) return;
    state.tdd = { phase: 0, cycle: 1, log: [] };
    saveState();
    renderTdd();
    toast("Ciclo TDD resetado.");
  });

  /* ============================================================
     Analisador de Spec
     ============================================================ */
  const specInput = document.getElementById("spec-input");
  const specCharCount = document.getElementById("spec-char-count");
  const scoreRing = document.getElementById("score-ring");
  const scoreValue = document.getElementById("score-value");
  const scoreTitle = document.getElementById("score-title");
  const scoreSubtitle = document.getElementById("score-subtitle");
  const checkList = document.getElementById("check-list");
  const vagueList = document.getElementById("vague-list");
  const questionsList = document.getElementById("questions-list");
  const scoreNote = document.getElementById("score-note");

  const SPEC_CHECKS = [
    { id: "problem", label: "Problema / objetivo de negócio", re: /(problema|objetivo|dor|proposta de valor|por que|para qu[eê])/i, question: "Qual é o problema central que esta feature resolve e como mediremos o sucesso?" },
    { id: "persona", label: "Público-alvo / persona", re: /(p[uú]blico|persona|usu[aá]rio|cliente|perfil)/i, question: "Quem usa esta feature (persona) e qual é o contexto de uso?" },
    { id: "platform", label: "Plataformas e versões mínimas", re: /(android|ios|plataforma|vers[aã]o m[ií]nima|tablet|web)/i, question: "Quais plataformas e versões mínimas de SO precisam ser suportadas?" },
    { id: "data", label: "Estratégia de dados / persistência", re: /(sqlite|drift|banco|persist[eê]ncia|supabase|firebase|api|rest|local|offline|nuvem)/i, question: "Onde os dados vivem (local, nuvem ou híbrido) e qual é a estratégia de sincronização?" },
    { id: "auth", label: "Autenticação / sessão", re: /(autentica|login|senha|sess[aã]o|token|oauth|biometria|jwt)/i, question: "Como o usuário se autentica e o que acontece quando a sessão expira?" },
    { id: "offline", label: "Comportamento offline / sync", re: /(offline|sincron|sync|conflito|fila|retry|backoff)/i, question: "Qual é o comportamento offline e como conflitos de sincronização são resolvidos?" },
    { id: "states", label: "4 estados de tela (loading/empty/error/success)", re: /(loading|carregamento|empty|vazio|error|erro|falha|sucesso|skeleton|shimmer)/i, question: "Como serão os estados de carregamento, vazio, erro e sucesso desta tela?" },
    { id: "a11y", label: "Acessibilidade (Semantics, contraste, touch)", re: /(acessibilidade|a11y|semantics|contraste|wcag|touch target|leitor de tela|teclado)/i, question: "Quais requisitos de acessibilidade (contraste AA, Semantics, touch 48x48dp) são obrigatórios?" },
    { id: "acceptance", label: "Critérios de aceitação verificáveis", re: /(crit[eé]rio|aceita|dado que|quando|ent[aã]o|deve|obrigat[oó]rio)/i, question: "Quais são os critérios de aceitação objetivos, incluindo casos de borda e falha?" },
    { id: "metric", label: "Métrica de sucesso / North Star", re: /(m[eé]trica|kpi|north star|convers[aã]o|reten[cç][aã]o|tempo|n[uú]mero)/i, question: "Qual número ou resultado valida o sucesso desta entrega?" },
    { id: "i18n", label: "Idioma e textos (pt-BR / i18n)", re: /(pt-br|portugu[eê]s|idioma|i18n|localiza|texto)/i, question: "Todos os textos estarão em pt-BR e passíveis de localização via ARB?" },
    { id: "security", label: "Segurança e segredos", re: /(seguran[cç]a|segredo|chave|token|rls|permiss[aã]o|criptograf|sanitiz)/i, question: "Quais dados são sensíveis e como chaves/segredos e permissões (RLS) serão protegidos?" },
    { id: "performance", label: "Performance e limites", re: /(performance|desempenho|lat[eê]ncia|fps|jank|pagina[cç][aã]o|limite|tamanho)/i, question: "Quais são os limites de performance (latência, FPS, paginação, tamanho) e como serão medidos?" },
    { id: "notifications", label: "Integrações e permissões do device", re: /(notifica|c[aâ]mera|gps|localiza[cç][aã]o|biometria|bluetooth|permiss[aã]o)/i, question: "Quais permissões/integrações do dispositivo serão usadas e como o usuário será informado?" }
  ];

  const VAGUE_TERMS = [
    { term: "rápido", hint: "Defina latência alvo (ex.: < 300 ms)." },
    { term: "bonito", hint: "Anexe referência visual/tokens no _references/screens." },
    { term: "vários", hint: "Liste os itens e a quantidade esperada." },
    { term: "alguns", hint: "Quantifique os casos de uso." },
    { term: "etc", hint: "Substitua por uma lista fechada de requisitos." },
    { term: "melhor", hint: "Defina o critério objetivo de comparação." },
    { term: "simples", hint: "Descreva o escopo mínimo verificável." },
    { term: "moderno", hint: "Aponte o design system e os tokens." }
  ];

  function analyzeSpec() {
    const text = specInput.value.trim();
    state.specText = text;
    saveState();
    if (!text) {
      scoreRing.style.setProperty("--p", "0");
      scoreValue.textContent = "0%";
      scoreTitle.textContent = "Nenhum texto informado";
      scoreSubtitle.textContent = "Cole uma spec ou carregue o exemplo para começar.";
      checkList.innerHTML = "";
      vagueList.innerHTML = "";
      questionsList.innerHTML = "";
      scoreNote.textContent = "";
      return;
    }

    const passed = SPEC_CHECKS.filter(check => check.re.test(text));
    const missing = SPEC_CHECKS.filter(check => !check.re.test(text));
    const score = Math.round((passed.length / SPEC_CHECKS.length) * 100);

    scoreRing.style.setProperty("--p", String(score));
    scoreValue.textContent = score + "%";
    scoreTitle.textContent = score >= 80 ? "Spec pronta para TDD" : score >= 50 ? "Spec precisa de ajustes" : "Spec incompleta — não codifique ainda";
    scoreSubtitle.textContent = passed.length + " de " + SPEC_CHECKS.length + " dimensões cobertas.";

    checkList.innerHTML = SPEC_CHECKS.map(check => {
      const ok = passed.includes(check);
      return `<div class="check-item ${ok ? "ok" : "miss"}">
        <span class="check-icon">${ok ? "✅" : "⚠️"}</span>
        <span><strong>${escapeHtml(check.label)}</strong>${ok ? "" : "<br>" + escapeHtml(check.question)}</span>
      </div>`;
    }).join("");

    const foundVague = VAGUE_TERMS.filter(item => new RegExp("\\b" + item.term + "\\b", "i").test(text));
    vagueList.innerHTML = foundVague.length
      ? foundVague.map(item => `<span title="${escapeHtml(item.hint)}">“${escapeHtml(item.term)}” → quantificar</span>`).join("")
      : "";

    questionsList.innerHTML = missing.length
      ? missing.map(check => `<li>${escapeHtml(check.question)}</li>`).join("")
      : `<li>Nenhuma pergunta crítica pendente. Valide os critérios de aceitação com o desenvolvedor e inicie o TDD RED.</li>`;

    scoreNote.textContent = missing.length
      ? "Regra do harness: sem spec aprovada, nenhum builder escreve código de produção."
      : "Próximo passo: levar os critérios para a coluna TDD RED do Kanban.";
  }

  document.getElementById("btn-analyze").addEventListener("click", analyzeSpec);

  specInput.addEventListener("input", () => {
    specCharCount.textContent = specInput.value.length + " caracteres";
    state.specText = specInput.value;
  });

  document.getElementById("btn-sample-spec").addEventListener("click", () => {
    specInput.value = [
      "Feature: Recuperação de senha",
      "",
      "Problema: usuários esquecem a senha e abandonam o app.",
      "Público-alvo: clientes do app Android e iOS (Android 8+, iOS 15+).",
      "Fluxo: o usuário informa o e-mail, recebe um código de 6 dígitos e define uma nova senha.",
      "Dados: Supabase Auth para sessão; nenhum dado sensível em log.",
      "Offline: se estiver sem rede, exibir erro amigável com botão Tentar novamente.",
      "Estados: loading com skeleton, empty state, error state e success state.",
      "Acessibilidade: contraste WCAG AA, Semantics nos campos e touch target 48x48dp.",
      "Critérios de aceitação: Dado que o e-mail existe, quando o código válido for enviado, então a senha é atualizada.",
      "Métrica de sucesso: reduzir em 30% o abandono no fluxo de login.",
      "Idioma: todos os textos em pt-BR com i18n via ARB.",
      "Segurança: token expira em 15 minutos e RLS ativo.",
      "Performance: resposta percebida abaixo de 300 ms.",
      "Notificações: nenhuma permissão de device necessária."
    ].join("\n");
    specCharCount.textContent = specInput.value.length + " caracteres";
    analyzeSpec();
    toast("Exemplo carregado e analisado.");
  });

  document.getElementById("btn-copy-questions").addEventListener("click", async () => {
    const questions = Array.from(questionsList.querySelectorAll("li")).map(li => "- " + li.textContent).join("\n");
    if (!questions) { toast("Nada para copiar ainda."); return; }
    try {
      await navigator.clipboard.writeText(questions);
      toast("Perguntas copiadas.");
    } catch (error) {
      toast("Não foi possível copiar automaticamente.");
    }
  });

  /* ============================================================
     Reset geral e inicialização
     ============================================================ */
  document.getElementById("btn-reset").addEventListener("click", () => {
    if (!confirm("Resetar Kanban, matriz de skills, ciclo TDD e análise de spec?")) return;
    localStorage.removeItem(STORAGE_KEY);
    state = clone(DEFAULT_STATE);
    specInput.value = "";
    specCharCount.textContent = "0 caracteres";
    analyzeSpec();
    renderAll();
    toast("Studio restaurado ao estado padrão.");
  });

  function renderAll() {
    renderKanban();
    renderAgents();
    renderTdd();
    if (state.specText) {
      specInput.value = state.specText;
      specCharCount.textContent = state.specText.length + " caracteres";
      analyzeSpec();
    }
  }

  renderAll();
})();
</script>
</body>
</html>
'@ | Set-Content -Path "harness-studio.html" -Encoding UTF8

# ------------------------------------------------------------------------------
# 8.2 _specs/task-board.md (5 colunas do ciclo Flutter)
# ------------------------------------------------------------------------------
@'
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
'@ | Set-Content -Path "_specs\task-board.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 9. .gitignore recomendado
# ------------------------------------------------------------------------------
if (-not (Test-Path ".gitignore")) {
@'
# Ambientes e Dependências
.env
.env*.local
node_modules/
.dart_tool/
.packages
build/

# Antigravity & Memória Local
.agents/memory/*.db
.agents/memory/*.db-journal

# IDEs e OS
.DS_Store
Thumbs.db
.vscode/
.idea/
'@ | Set-Content -Path ".gitignore" -Encoding UTF8
    Write-Host "✔ .gitignore padrão criado." -ForegroundColor Green
}

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "  🎉 Harness configurado com sucesso no Windows!     " -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Próximos passos recomendados:"
Write-Host " 1. Adicione capturas de telas em:  _references\screens\" -ForegroundColor Cyan
Write-Host " 2. Inicie a descoberta do produto: Copie _specs\prd-template.md para _specs\prd.md" -ForegroundColor Cyan
Write-Host " 3. Modelos: herda o modelo logado por padrão (inherit). Opcional: `$env:AI_MODEL_REASONING, AI_MODEL_CODING, AI_MODEL_DESIGN e AI_MODEL_FAST." -ForegroundColor Cyan
Write-Host " 4. Studio visual: abra harness-studio.html no navegador para gerenciar Kanban, agentes e skills." -ForegroundColor Cyan
Write-Host ""