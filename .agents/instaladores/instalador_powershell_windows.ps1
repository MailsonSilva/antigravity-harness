# ==============================================================================
# Antigravity Developer Harness - Instalador Nativo PowerShell (Windows)
# ==============================================================================

param(
    [string]$TargetDir = "."
)

$ErrorActionPreference = "Stop"

Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host "   🚀 Antigravity Developer Harness - Instalador     " -ForegroundColor Cyan
Write-Host "=====================================================" -ForegroundColor Cyan
Write-Host ""

Set-Location $TargetDir
Write-Host "📁 Criando estrutura de pastas no diretório: $(Get-Location)" -ForegroundColor Yellow

# 1. Criação das pastas
$dirs = @(
    ".agents\rules",
    ".agents\skills\spec-discovery",
    ".agents\skills\mobile-ux-stitch",
    ".agents\skills\web-performance-seo",
    ".agents\skills\clean-architecture-tdd",
    ".agents\workflows",
    ".agents\memory",
    "_specs\features",
    "_references\screens",
    "_references\brand",
    "apps\mobile",
    "apps\web",
    "apps\landing"
)

foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -ItemType Directory -Path $d -Force | Out-Null
    }
}

Write-Host "✔ Diretórios criados com sucesso." -ForegroundColor Green
Write-Host "📄 Gerando arquivos de configuração, regras e skills..." -ForegroundColor Yellow

# ------------------------------------------------------------------------------
# 2. _specs/prd-template.md
# ------------------------------------------------------------------------------
@'
---
project_name: "NomeDoProjeto"
version: "0.1.0"
date: "2026-10-01"
status: "draft" # draft | approved | in_progress | completed

# Alvos da aplicação (ativados na fase de descoberta)
targets:
  mobile: true        # apps/mobile
  web: false          # apps/web
  landing_page: true  # apps/landing

# Definição tecnológica aberta decidida na descoberta
technology_choices:
  persistence_type: "to_be_decided" 
  primary_database: "to_be_decided" # ex: sqlite, postgres, mysql, supabase, firebase, local_json, nenhum
  backend_strategy: "to_be_decided" # ex: direct_db, custom_api, edge_functions, baas, offline_only

  mobile_framework: "flutter" # ou react_native_expo, nativo, etc.
  web_framework: "nextjs"     # ou react_vite, astro, etc.
  styling_approach: "tokens"  # tailwind, design_tokens, material3
---

# PRD: {{project_name}}

## 1. Visão Geral e Proposta de Valor
- **Problema Central**: Qual é a dor ou gargalo real que o sistema resolve? Quem sofre com esse problema atualmente?
- **Solução Proposta**: O que a solução entrega para sanar esse problema com o menor atrito possível?
- **Público-Alvo e Persona (ICP)**: Quem utilizará ou pagará pelo produto?
- **Métrica de Sucesso (North Star Metric)**: Qual número ou resultado valida o sucesso do projeto?

---

## 2. Definição e Justificativa de Tecnologias (Tech Stack)
- **Persistência de Dados**: 
  - *Decisão*: [ex: Iniciar 100% local com SQLite para velocidade de MVP sem custo de servidor / Usar API externa já existente / Usar Postgres na nuvem]
  - *Justificativa*: [Por que essa escolha é ideal para o momento atual do projeto?]
- **Autenticação e Sessão**: [Local/Pin, JWT, OAuth, sessão de dispositivo ou sem autenticação]
- **Armazenamento de Arquivos/Imagens**: [Local no dispositivo, Bucket S3/R2 ou N/A]

---

## 3. Escopo dos Alvos (Targets)

### 3.1. Aplicativo Mobile (`apps/mobile`)
> *Status: [Ativo / Inativo]*
- **Papel no Produto**: 
- **Capacidades Críticas**: [Offline-first, notificações, acesso à câmera, biometria, etc.]

### 3.2. Painel Web / Dashboard (`apps/web`)
> *Status: [Ativo / Inativo]*
- **Papel no Produto**: 
- **Capacidades Críticas**: [Relatórios, dashboards gerenciais, operações em massa, desktop-friendly]

### 3.3. Landing Page / Site Institucional (`apps/landing`)
> *Status: [Ativo / Inativo]*
- **Papel no Produto**: 
- **Capacidades Críticas**: [Alta conversão, SEO semântico, carregamento instantâneo, captura de leads]

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
- **Quero** [realizar uma ação no app/web],
- **Para** [atingir determinado benefício].

**Critérios de Aceitação Obrigatórios**:
- [ ] Cenário de Sucesso (Caminho Feliz).
- [ ] Estado de Carregamento contextual (Skeleton ou loader não intrusivo).
- [ ] Estado Vazio (Empty State) informativo e com botão de ação rápida.
- [ ] Estado de Falha (Error State) com mensagem em pt-BR e opção de tentar novamente.

---

## 6. Diagrama Conceitual de Arquitetura (Archify)
- Componente de Entrada -> Gerenciador de Estado -> Contrato de Repositório -> Mecanismo de Dados Escolhido.
'@ | Set-Content -Path "_specs\prd-template.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 3. .agents/harness.yaml
# ------------------------------------------------------------------------------
@'
version: "1.0"
name: "unified-developer-harness"
description: "Harness unificado multi-alvo com alocação dinâmica de modelos de IA, TDD, Stitch MCP, Graft e ai-memory."

models:
  reasoning: "${MODEL_REASONING:-gemini-3.8-pro}"
  coding: "${MODEL_CODING:-gemini-3.8-flash}"
  multimodal_design: "${MODEL_DESIGN:-gemini-3.8-flash}"
  fast_ops: "${MODEL_OPS:-gemini-3.8-flash}"

settings:
  prd_path: "_specs/prd.md"
  language: "pt-BR"
  enforce_tdd: true
  max_repair_cycles: 3
  active_profile: "dynamic"

workspaces:
  shared:
    paths:
      - "_specs/"
      - "_references/"
      - ".agents/"
  mobile:
    path: "apps/mobile/"
    active_when: "targets.mobile == true"
    test_command: "cd apps/mobile && flutter test"
    lint_command: "cd apps/mobile && dart analyze"
  web:
    path: "apps/web/"
    active_when: "targets.web == true"
    test_command: "cd apps/web && npm test"
    lint_command: "cd apps/web && npm run lint"
  landing:
    path: "apps/landing/"
    active_when: "targets.landing_page == true"
    test_command: "cd apps/landing && npm test"
    lint_command: "cd apps/landing && npm run lint"

tools:
  ai_memory:
    cli: "ai-memory"
    description: "Handoffs atômicos entre agentes e histórico de aprendizado do ciclo TDD."
  graft:
    cli: "graft"
    description: "Grafo de símbolos e chamadas via AST Tree-sitter para navegação precisa no código."
  google_stitch_mcp:
    server_id: "google-stitch"
    description: "Leitor de referências visuais de telas e prototipagem de UI."
  git:
    cli: "git"
    description: "Controle de versão e commits semânticos atômicos."

subagents:
  product_architect:
    model: "${models.reasoning}"
    role: "Entrevista o desenvolvedor, define requisitos de negócio e gera o PRD agnóstico em _specs/ com diagramas Archify."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/spec-discovery/SKILL.md"
    tools: ["file_read", "file_write", "ai_memory"]

  ui_ux_designer:
    model: "${models.multimodal_design}"
    role: "Inspeciona capturas em _references/screens/ usando Google Stitch MCP e gera os tokens de design em _specs/design-tokens.json."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/mobile-ux-stitch/SKILL.md"
    tools: ["google_stitch_mcp", "file_read", "file_write", "ai_memory"]

  tdd_tester:
    model: "${models.coding}"
    role: "Lê a spec da feature e cria testes unitários/widgets/componentes que obrigatoriamente falham antes do código."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/clean-architecture-tdd/SKILL.md"
    tools: ["file_read", "file_write", "bash", "graft", "ai_memory"]

  mobile_builder:
    model: "${models.coding}"
    role: "Escreve código Flutter estritamente tipado, modular e aderente à Clean Architecture para passar nos testes."
    active_when: "targets.mobile == true"
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/mobile-ux-stitch/SKILL.md"
      - ".agents/skills/clean-architecture-tdd/SKILL.md"
    tools: ["file_read", "file_write", "graft", "ai_memory"]

  web_builder:
    model: "${models.coding}"
    role: "Escreve componentes Next.js/React com Server Components e boas práticas de Core Web Vitals (Addy Osmani)."
    active_when: "targets.web == true || targets.landing_page == true"
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/web.md"
    skills:
      - ".agents/skills/web-performance-seo/SKILL.md"
    tools: ["file_read", "file_write", "graft", "ai_memory"]

  qa_validator:
    model: "${models.coding}"
    role: "Executa testes e linters do target ativo, orquestrando até 3 ciclos de autorreparo automático caso algo quebre."
    rules:
      - ".agents/rules/global.md"
    tools: ["bash", "file_read", "file_write", "ai_memory"]

  git_committer:
    model: "${models.fast_ops}"
    role: "Inspeciona o diff staged, extrai o contexto do ticket no ai-memory e cria o commit semântico atômico."
    rules:
      - ".agents/rules/global.md"
    tools: ["git", "ai_memory", "bash"]

workflows:
  dev_cycle:
    file: ".agents/workflows/dev-cycle.yaml"
    description: "Ciclo ponta a ponta: Ingestão -> Design -> TDD Red -> Green -> Refactor -> Commit."
'@ | Set-Content -Path ".agents\harness.yaml" -Encoding UTF8

# ------------------------------------------------------------------------------
# 4. .agents/mcp.json
# ------------------------------------------------------------------------------
@'
{
  "mcpServers": {
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
      "description": "Servidor MCP do Google Stitch para extrair o Design DNA de referências em _references/screens/ e gerar protótipos visuais de telas."
    },
    "graft-ast": {
      "command": "graft",
      "args": [
        "mcp",
        "--watch"
      ],
      "description": "Grafo estático do código com Tree-sitter para consulta determinística de símbolos, funções e contratos sem consumir tokens desnecessários."
    },
    "ai-memory": {
      "command": "ai-memory",
      "args": [
        "server"
      ],
      "env": {
        "AI_MEMORY_DB_PATH": "./.agents/memory/context.db"
      },
      "description": "Servidor de memória local para persistência de tickets de handoff entre subagentes e histórico de aprendizados do ciclo TDD."
    }
  }
}
'@ | Set-Content -Path ".agents\mcp.json" -Encoding UTF8

# ------------------------------------------------------------------------------
# 5. .agents/rules/ (global.md, mobile.md, web.md)
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
1. **Sem Spec, Sem Código**: Nenhum subagente de codificação tem permissão para escrever código de produção sem uma especificação aprovada em `_specs/`.
2. **Fidelidade ao Contrato**: O código implementado deve atender estritamente ao que foi pedido na spec.
3. **Identificação de Ambiguidade**: Se a especificação for ambígua, interrompa o fluxo e solicite alinhamento antes de codificar.

---

## 3. Disciplina de TDD (Test-Driven Development)
1. **Ciclo Vermelho-Verde-Refatora (Red-Green-Refactor)**:
   - **Fase Vermelha (RED)**: O agente `tdd_tester` escreve a suíte de testes correspondente aos critérios da spec. Os testes DEVEM falhar comprovadamente antes do código.
   - **Fase Verde (GREEN)**: O agente construtor escreve a menor quantidade de código possível para satisfazer os testes.
   - **Fase de Refatoração (REFACTOR)**: O agente de QA limpa o código, remove duplicações e assegura que nenhum teste quebrou.
2. **Cobertura de Casos Limítrofes**: Os testes devem cobrir obrigatoriamente fluxos felizes, valores nulos/inválidos e cenários de borda.

---

## 4. Gestão de Contexto e Handoffs com `ai-memory`
1. **Registro Contínuo**: Cada etapa concluída no pipeline deve registrar um ticket ou atualização no `ai-memory`.
2. **Isolamento de Contexto**: O agente consulta o ticket do `ai-memory` e o grafo do **Graft** para obter apenas o contexto relevante.

---

## 5. Padrão de Versionamento no Git (Conventional Commits)
- Commits atômicos no formato: `<tipo>(<escopo>): <descrição no imperativo>` seguido dos critérios atendidos.
'@ | Set-Content -Path ".agents\rules\global.md" -Encoding UTF8

@'
# Diretrizes Técnicas para Desenvolvimento Mobile (Flutter)

## 1. Arquitetura de Software e Separação de Camadas
- Presentation depende apenas de Domain.
- Data implementa os contratos de Domain.
- Domain é Dart puro, sem widgets ou dependências externas.

## 2. Gerenciamento de Estados de Tela (Regra dos 4 Estados)
Toda tela assíncrona DEVE implementar:
1. `LoadingState`: Shimmer skeleton contextual.
2. `EmptyState`: Mensagem clara em pt-BR com botão de ação rápida.
3. `ErrorState`: Mensagem humana amigável e botão obrigatório de tentar novamente.
4. `SuccessState`: Renderização fluida e performática.

## 3. Ergonomia e UI
- Touch Target mínimo de 48x48 dp.
- Ações principais na Thumb Zone (terço inferior da tela).
- Cores e fontes importadas exclusivamente dos tokens em `core/theme/`.
'@ | Set-Content -Path ".agents\rules\mobile.md" -Encoding UTF8

@'
# Diretrizes Técnicas para Desenvolvimento Web e Landing Pages (Next.js / React)

## 1. Paradigma Server-First (RSC)
- Componentes são Server Components por padrão.
- `'use client'` restrito exclusivamente às folhas interativas.
- Mutações via Server Actions tipadas com Zod.

## 2. Core Web Vitals (Padrão Addy Osmani)
- Imagens com `priority` na primeira dobra (LCP < 2.5s).
- Fontes locais com display swap e mídias dimensionadas (CLS < 0.1).

## 3. Landing Pages de Alta Conversão
- Estrutura clara: Proposta de Valor na primeira dobra, Prova Social, Oferta/Planos e FAQ com acordeão.
'@ | Set-Content -Path ".agents\rules\web.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 6. .agents/skills/
# ------------------------------------------------------------------------------
@'
---
name: spec-discovery
description: Conduz a entrevista de produto inicial, define requisitos de negócio e gera o PRD estruturado em _specs/prd.md com diagramas conceituais Archify.
---
# Skill: Descoberta de Produto e PRD
Orienta o agente product_architect a entrevistar o desenvolvedor sobre alvos (mobile/web/landing), banco e proposta de valor.
'@ | Set-Content -Path ".agents\skills\spec-discovery\SKILL.md" -Encoding UTF8

@'
---
name: mobile-ux-stitch
description: Diretrizes de UX/UI mobile, extração de Design DNA com Google Stitch MCP a partir de prints e geração de tokens visuais.
---
# Skill: Mobile UX & Google Stitch Integration
Inspeciona referências visuais em _references/screens/ e gera os tokens em _specs/design-tokens.json respeitando a ergonomia mobile e a regra dos 4 estados.
'@ | Set-Content -Path ".agents\skills\mobile-ux-stitch\SKILL.md" -Encoding UTF8

@'
---
name: web-performance-seo
description: Padrões de alta performance web, otimização de Core Web Vitals, SSR/RSC e SEO técnico inspirados nas diretrizes de Addy Osmani.
---
# Skill: Web Performance & SEO Optimization
Garante Core Web Vitals otimizados, acessibilidade WCAG AA e Server Actions tipadas.
'@ | Set-Content -Path ".agents\skills\web-performance-seo\SKILL.md" -Encoding UTF8

@'
---
name: clean-architecture-tdd
description: Práticas de Test-Driven Development (Red-Green-Refactor), desacoplamento de domínio e criação de suítes de teste de alta velocidade.
---
# Skill: Clean Architecture & Disciplina TDD
Coordena a fase Vermelha (testes falhos primeiro), Verde (código mínimo) e Refatoração.
'@ | Set-Content -Path ".agents\skills\clean-architecture-tdd\SKILL.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 7. .agents/workflows/dev-cycle.yaml
# ------------------------------------------------------------------------------
@'
version: "1.0"
name: "dev-cycle"
description: "Pipeline completo orientado a Spec com TDD (Red-Green-Refactor), loop autônomo de autorreparo e Git committer semântico."

inputs:
  feature_spec:
    type: string
    description: "Caminho da spec da feature"
    required: true
  target:
    type: string
    description: "mobile | web | landing"
    required: false

steps:
  - id: step_ingest_context
    name: "1. Ingestão de Contexto e Grafo"
    agent: "product_architect"
  - id: step_tdd_red
    name: "2. Fase Vermelha (RED) - Testes Falhos"
    agent: "tdd_tester"
  - id: step_tdd_green
    name: "3. Fase Verde (GREEN) - Implementação"
    agent: "mobile_builder"
  - id: step_repair_loop
    name: "4. Validação e Autorreparo"
    agent: "qa_validator"
  - id: step_git_commit
    name: "5. Commit Semântico"
    agent: "git_committer"
'@ | Set-Content -Path ".agents\workflows\dev-cycle.yaml" -Encoding UTF8

Write-Host "`n=====================================================" -ForegroundColor Green
Write-Host "  🎉 Harness configurado com sucesso no Windows!     " -ForegroundColor Green
Write-Host "=====================================================" -ForegroundColor Green
'@