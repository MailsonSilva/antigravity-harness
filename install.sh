#!/usr/bin/env bash
# ==============================================================================
# Antigravity Developer Harness - Instalador Universal (Linux / macOS / WSL / Git Bash)
# 100% Autocontido: Instala ferramentas (ai-memory, graft), regras, skills e workflows
# v3.2: Isolamento Git nativo, Studio sem loop de refresh, 5 MCPs, catalogo desacoplado de agentes/skills (1:N).
# Opcional: INSTALL_FLUTTER_SKILLS=1 ./install.sh instala os plugins oficiais do Flutter.
# ==============================================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GRAY='\033[0;37m'
NC='\033[0m' # No Color

echo -e "${CYAN}=====================================================${NC}"
echo -e "${CYAN}   🚀 Antigravity Developer Harness - Instalador    ${NC}"
echo -e "${CYAN}=====================================================${NC}"
echo ""

TARGET_DIR="${1:-.}"
cd "$TARGET_DIR"

echo -e "${YELLOW}📁 Criando estrutura de pastas no diretório: $(pwd)${NC}"

# ------------------------------------------------------------------------------
# 1. Verificação e Instalação de Ferramentas Auxiliares (MCPs & CLI Tools)
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}🔍 Verificando ferramentas auxiliares...${NC}"

# 1.1 Checagem do Node / npm e ai-memory
if command -v npm &> /dev/null; then
    if ! command -v ai-memory &> /dev/null; then
        echo -e "${CYAN}📦 Instalando ai-memory globalmente via npm...${NC}"
        npm install -g ai-memory || echo -e "${YELLOW}⚠️ Falha ao instalar ai-memory globalmente. Execute 'npm i -g ai-memory' com permissões adequadas se necessário.${NC}"
    else
        echo -e "${GREEN}✔ ai-memory já instalado no sistema.${NC}"
    fi
else
    echo -e "${YELLOW}⚠️ Node.js / npm não detectado. O servidor ai-memory precisará do Node instalado para rodar.${NC}"
fi

# 1.2 Checagem do Graft (AST Graph Navigator)
if ! command -v graft &> /dev/null; then
    if command -v cargo &> /dev/null; then
        echo -e "${CYAN}📦 Compilando e instalando Graft via Cargo...${NC}"
        cargo install graft-cli || echo -e "${YELLOW}⚠️️ Falha ao compilar graft via cargo.${NC}"
    else
        echo -e "${YELLOW}ℹ️️ Cargo não detectado. O harness usará fallback para análise estática nativa caso o binário do Graft não esteja no PATH.${NC}"
    fi
else
    echo -e "${GREEN}✔ Graft já instalado no sistema.${NC}"
fi

# ------------------------------------------------------------------------------
# 1.3 Suporte opcional aos plugins oficiais do Flutter (npx skills)
# ------------------------------------------------------------------------------
if [ "${INSTALL_FLUTTER_SKILLS:-0}" = "1" ]; then
    if command -v npx &> /dev/null; then
        echo -e "${CYAN}🧩 Instalando plugins oficiais do Flutter via npx skills...${NC}"
        npx skills add flutter/agent-plugins --skill '*' --agent universal --yes || echo -e "${YELLOW}⚠️ Falha ao instalar os plugins oficiais; o harness continua funcional.${NC}"
    else
        echo -e "${YELLOW}⚠️ npx não detectado; instale Node.js para usar os plugins oficiais.${NC}"
    fi
else
    echo -e "${GRAY}ℹ️ Plugins oficiais do Flutter são opcionais. Ative com: INSTALL_FLUTTER_SKILLS=1 ./install.sh${NC}"
    echo -e "${GRAY}   Ou execute: npx skills add flutter/agent-plugins --skill '*' --agent universal --yes${NC}"
fi
# ------------------------------------------------------------------------------
# 2. Criação das pastas fundamentais
# ------------------------------------------------------------------------------
echo -e "\n${YELLOW}📁 Criando diretórios do projeto...${NC}"

mkdir -p .agents/rules
mkdir -p .agents/skills/spec-discovery
mkdir -p .agents/skills/mobile-ux
mkdir -p .agents/skills/clean-architecture
mkdir -p .agents/skills/code-quality-tests
mkdir -p .agents/skills/antigravity-skill-orchestrator
mkdir -p .agents/skills/flutter-state-riverpod
mkdir -p .agents/skills/supabase-flutter
mkdir -p .agents/skills/local-first-data
mkdir -p .agents/skills/mobile-cicd
mkdir -p .agents/skills/store-publishing
mkdir -p .agents/skills/flutter-release
mkdir -p .agents/skills/flutter-apply-architecture-best-practices
mkdir -p .agents/skills/flutter-add-widget-test
mkdir -p .agents/skills/flutter-add-integration-test
mkdir -p .agents/skills/flutter-setup-declarative-routing
mkdir -p .agents/skills/flutter-use-http-package
mkdir -p .agents/skills/flutter-setup-localization
mkdir -p .agents/skills/flutter-build-responsive-layout
mkdir -p .agents/skills/dart-use-pattern-matching
mkdir -p .agents/skills/dart-collect-coverage
mkdir -p .agents/skills/harness-evolver
mkdir -p .agents/skills/web-performance-seo
mkdir -p .agents/workflows
mkdir -p .agents/memory
mkdir -p _specs/features
mkdir -p _specs/tasks
mkdir -p _references/screens
mkdir -p _references/brand
mkdir -p apps/mobile

# Criação de .gitkeep para garantir que as pastas de referências subam para o Git
touch _references/screens/.gitkeep
touch _references/brand/.gitkeep
touch .agents/memory/.gitkeep

echo -e "${GREEN}✔ Diretórios criados com sucesso.${NC}"
echo -e "${YELLOW}📄 Gerando arquivos de configuração, regras, skills e workflows...${NC}"

# ------------------------------------------------------------------------------
# 3. _specs/prd-template.md (Agnóstico e Dinâmico)
# ------------------------------------------------------------------------------
cat << 'EOF' > _specs/prd-template.md
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
EOF

# ------------------------------------------------------------------------------
# 4. .agents/harness.yaml (Arquitetura Agnóstica v2 — 8 Componentes)
# ------------------------------------------------------------------------------
cat << 'EOF' > .agents/harness.yaml
# Antigravity Harness v3.0 — Catálogo desacoplado de Agentes & Skills
# Gerado automaticamente pelo Harness Studio (harness-studio.html)
version: "3.0-google-harness2-modular"

model_profiles:
  reasoning: "inherit"
  coding: "inherit"
  design: "inherit"
  fast_ops: "inherit"

mcp_servers:
  dart_mcp:
    enabled: true
    command: "dart"
    args: ["mcp-server"]
  supabase_mcp:
    enabled: true
    command: "npx"
    args: ["-y", "@supabase/mcp-server-supabase@latest"]
  google_stitch:
    enabled: true
    command: "npx"
    args: ["-y", "@google/stitch-mcp-server"]
    env:
      STITCH_REFERENCES_DIR: "./_references/screens"
      STITCH_OUTPUT_DIR: "./_specs"
  graft_ast:
    enabled: true
    command: "graft"
    args: ["mcp", "--watch"]
  ai_memory:
    enabled: true
    command: "ai-memory"
    args: ["mcp"]
    env:
      AI_MEMORY_DB_PATH: "./.agents/memory/context.db"

skills_registry:
  spec_discovery:
    name: "Spec-Driven Discovery & PRD"
    category: "Arquitetura & Produto"
    file: ".agents/skills/spec-discovery/SKILL.md"
    description: "Transforma requisitos vagos em contratos técnicos estritos, mapeando casos de borda e os 4 estados de tela (Loading, Empty, Error, Success)."
  clean_architecture:
    name: "Clean Architecture & Domain Purity"
    category: "Engenharia de Software"
    file: ".agents/skills/clean-architecture/SKILL.md"
    description: "Separação estrita entre Presentation, Domain (Services/Entities puros) e Data (Repositories/DTOs). Centralização de regras críticas."
  mobile_ux_design_system:
    name: "Mobile UX & Design Systems"
    category: "UI/UX & Frontend"
    file: ".agents/skills/mobile-ux/SKILL.md"
    description: "Design Tokens semânticos, alvos de toque mínimos de 48x48dp, micro-interações fluidas 60/120fps, Material 3 e responsividade adaptativa."
  stitch_visual_ingest:
    name: "Google Stitch Visual Ingestion"
    category: "UI/UX & Frontend"
    file: ".agents/skills/flutter-build-responsive-layout/SKILL.md"
    description: "Leitura de protótipos e imagens em _references/screens/ via Stitch MCP para extração de espaçamentos, tipografia e componentes."
  supabase_fullstack:
    name: "Supabase Auth, RLS & Edge"
    category: "Backend & Cloud"
    file: ".agents/skills/supabase-flutter/SKILL.md"
    description: "Integração segura com Supabase, políticas Row Level Security (RLS), sincronização incremental e funções serverless."
  local_first_sqlite:
    name: "Local-First SQLite & Performance"
    category: "Dados & Offline"
    file: ".agents/skills/local-first-data/SKILL.md"
    description: "Modelagem SQLite local de alta performance, índices compostos (CREATE INDEX), paginação (LIMIT/OFFSET), debounce de busca e fila offline."
  tdd_red_green:
    name: "Strict TDD (Red-Green-Refactor)"
    category: "Qualidade & Testes"
    file: ".agents/skills/code-quality-tests/SKILL.md"
    description: "Desenvolvimento guiado por testes determinísticos: criação do teste que falha (RED) antes da implementação mínima (GREEN)."
  flutter_riverpod_state:
    name: "Reactive State Management (Riverpod)"
    category: "Engenharia Mobile"
    file: ".agents/skills/flutter-state-riverpod/SKILL.md"
    description: "Gerenciamento de estado previsível, imutável e reativo usando Notifiers/AsyncNotifiers com descarte seguro de recursos."
  harness_evolver:
    name: "Google Harness² Recursive Evolver"
    category: "Meta-Otimização"
    file: ".agents/skills/harness-evolver/SKILL.md"
    description: "Ciclo Propose–Probe–Compose do Google Research Harness²: analisa falhas de QA ou reprovações no Kanban e atualiza as Skills automaticamente."

subagents:
  master_orchestrator:
    model: "inherit"
    role: "Master Orchestrator & Principal Architect"
    seniority: "Principal / Staff Engineer (15+ anos)"
    persona: "Conhece profundamente todo o PROJECT_BRAIN.md, a arquitetura do repositório, os contratos de domínio e o status dos servidores MCP conectados. Decompõe épicos em tarefas menores por complexidade e escala o especialista exato."
    mcps:
      - "dart_mcp"
      - "supabase_mcp"
      - "google_stitch"
      - "graft_ast"
      - "ai_memory"
    skills:
      - "spec_discovery"
      - "clean_architecture"
      - "harness_evolver"
  ui_ux_specialist:
    model: "inherit"
    role: "Senior UI/UX & Design System Engineer"
    seniority: "Senior Product Designer & Frontend Architect (10+ anos)"
    persona: "Especialista em Design Systems escaláveis, Material 3, acessibilidade WCAG, micro-interações e conversão de layouts do Google Stitch em componentes Flutter responsivos."
    mcps:
      - "google_stitch"
      - "dart_mcp"
    skills:
      - "mobile_ux_design_system"
      - "stitch_visual_ingest"
      - "flutter_riverpod_state"
  tdd_specialist:
    model: "inherit"
    role: "Lead TDD & Contract Verification Engineer"
    seniority: "Senior QA & Test Architect (10+ anos)"
    persona: "Guardião da Fase RED. Escreve testes unitários, de widget e de contrato de performance antes que qualquer código de produção exista."
    mcps:
      - "dart_mcp"
      - "graft_ast"
    skills:
      - "tdd_red_green"
      - "clean_architecture"
  mobile_domain_builder:
    model: "inherit"
    role: "Senior Flutter & Domain Engineer"
    seniority: "Senior Mobile Software Engineer (12+ anos)"
    persona: "Implementa a Fase GREEN com código limpo, serviços de domínio desacoplados (ex: PrecoService) e gerenciamento de estado reativo."
    mcps:
      - "dart_mcp"
      - "graft_ast"
      - "ai_memory"
    skills:
      - "clean_architecture"
      - "flutter_riverpod_state"
      - "mobile_ux_design_system"
  data_supabase_specialist:
    model: "inherit"
    role: "Offline-First SQLite & Supabase Architect"
    seniority: "Senior Data & Cloud Engineer (12+ anos)"
    persona: "Especialista em motores de busca SQLite ultrarrápidos (índices, paginação, sincronização FTP/REST) e backends Supabase com RLS e Edge Functions."
    mcps:
      - "supabase_mcp"
      - "dart_mcp"
      - "graft_ast"
    skills:
      - "local_first_sqlite"
      - "supabase_fullstack"
      - "clean_architecture"
  qa_self_healer:
    model: "inherit"
    role: "Autonomous QA Validator & Self-Healing Agent"
    seniority: "Staff Quality & Reliability Engineer"
    persona: "Executa linters, testes automatizados e auditoria de regressão em loop fechado (até 3 tentativas) e aciona o Harness Evolver para registrar aprendizados."
    mcps:
      - "dart_mcp"
      - "graft_ast"
      - "ai_memory"
    skills:
      - "tdd_red_green"
      - "harness_evolver"
      - "clean_architecture"
EOF

# ------------------------------------------------------------------------------
# 5. .agents/mcp.json (Configuração dos MCP Servers)
# ------------------------------------------------------------------------------
cat << 'EOF' > .agents/mcp.json
{
  "mcpServers": {
    "dart_mcp": {
      "command": "dart",
      "args": [
        "mcp-server"
      ],
      "description": "Inspeção da árvore de widgets em runtime, resolução de símbolos, pubspec e execução assistida de testes Flutter."
    },
    "supabase_mcp": {
      "command": "npx",
      "args": [
        "-y",
        "@supabase/mcp-server-supabase@latest"
      ],
      "description": "Inspeção de schema Postgres, criação de migrations, políticas RLS, Edge Functions e geração de tipos."
    },
    "google_stitch": {
      "command": "npx",
      "args": [
        "-y",
        "@google/stitch-mcp-server"
      ],
      "env": {
        "STITCH_REFERENCES_DIR": "./_references/screens",
        "STITCH_OUTPUT_DIR": "./_specs"
      },
      "description": "Extração de Design Tokens, hierarquia de componentes e fidelidade visual a partir de telas em _references/screens/."
    },
    "graft_ast": {
      "command": "graft",
      "args": [
        "mcp",
        "--watch"
      ],
      "description": "Navegação cirúrgica em árvore sintática (AST) para localizar chamadas e impactos sem estourar janela de contexto."
    },
    "ai_memory": {
      "command": "ai-memory",
      "args": [
        "mcp"
      ],
      "env": {
        "AI_MEMORY_DB_PATH": "./.agents/memory/context.db"
      },
      "description": "Memória episódica de decisões arquiteturais e passagem de tickets atômicos entre subagentes."
    }
  }
}
EOF

# ------------------------------------------------------------------------------
# 6. .agents/rules/ (Regras de Engenharia)
# ------------------------------------------------------------------------------
cat << 'EOF' > .agents/rules/global.md
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
EOF

cat << 'EOF' > .agents/rules/mobile.md
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
EOF

cat << 'EOF' > .agents/rules/web.md
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
EOF

if [ ! -f .agents/PROJECT_BRAIN.md ]; then
cat << 'EOF' > .agents/PROJECT_BRAIN.md
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
EOF
fi

# ------------------------------------------------------------------------------
# 7. .agents/skills/ (Skills Fundamentais e Especializadas)
# ------------------------------------------------------------------------------
cat << 'EOF' > .agents/skills/spec-discovery/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/mobile-ux/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/clean-architecture/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/antigravity-skill-orchestrator/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/code-quality-tests/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-state-riverpod/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/supabase-flutter/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/local-first-data/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/mobile-cicd/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/store-publishing/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-release/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-apply-architecture-best-practices/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-add-widget-test/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-add-integration-test/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-setup-declarative-routing/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-use-http-package/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-setup-localization/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/flutter-build-responsive-layout/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/dart-use-pattern-matching/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/dart-collect-coverage/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/harness-evolver/SKILL.md
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
EOF

cat << 'EOF' > .agents/skills/web-performance-seo/SKILL.md
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
EOF

# ------------------------------------------------------------------------------
# 8. .agents/workflows/dev-cycle.yaml (Workflow Completo com TDD e Git)
# ------------------------------------------------------------------------------
cat << 'EOF' > .agents/workflows/dev-cycle.yaml
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
EOF

# ------------------------------------------------------------------------------
# 8.1 harness-studio.html (Kanban, matriz 1:N, ciclo TDD e analisador de spec)
# ------------------------------------------------------------------------------
cat << 'EOF' > harness-studio.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Antigravity Studio v3.0 — AI Software Engineering OS</title>
  <style>
    :root {
      --bg-base: #07090e;
      --bg-surface: #0f131d;
      --bg-elevated: #161c2a;
      --bg-glass: rgba(22, 28, 42, 0.78);
      --border: #222b3d;
      --border-hover: #384866;
      --text-main: #f1f5f9;
      --text-muted: #94a3b8;
      --text-dim: #64748b;
      --primary: #38bdf8;
      --primary-glow: rgba(56, 189, 248, 0.16);
      --indigo: #818cf8;
      --emerald: #10b981;
      --amber: #f59e0b;
      --rose: #f43f5e;
      --purple: #c084fc;
      --radius-sm: 6px;
      --radius-md: 10px;
      --radius-lg: 14px;
      --shadow: 0 12px 32px -4px rgba(0, 0, 0, 0.6);
    }

    * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Inter', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; }
    body { background-color: var(--bg-base); color: var(--text-main); display: flex; height: 100vh; overflow: hidden; }

    /* SIDEBAR */
    .sidebar {
      width: 270px;
      background: var(--bg-surface);
      border-right: 1px solid var(--border);
      display: flex;
      flex-direction: column;
      padding: 20px 14px;
      flex-shrink: 0;
    }
    .brand {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 6px 10px 20px;
      border-bottom: 1px solid var(--border);
      margin-bottom: 16px;
    }
    .brand-logo {
      width: 34px; height: 34px; border-radius: 9px;
      background: linear-gradient(135deg, var(--primary), var(--indigo));
      display: flex; align-items: center; justify-content: center;
      font-weight: 800; color: #050811; font-size: 1.1rem;
      box-shadow: 0 0 20px rgba(56, 189, 248, 0.35);
    }
    .brand-text h1 { font-size: 0.98rem; font-weight: 700; letter-spacing: -0.02em; }
    .brand-text span { font-size: 0.72rem; color: var(--primary); font-family: monospace; }

    .nav-group-label {
      font-size: 0.68rem; text-transform: uppercase; letter-spacing: 0.08em;
      color: var(--text-dim); font-weight: 700; padding: 10px 10px 6px;
    }
    .nav-btn {
      display: flex; align-items: center; justify-content: space-between;
      width: 100%; background: transparent; border: 1px solid transparent;
      color: var(--text-muted); padding: 10px 12px; border-radius: var(--radius-md);
      font-size: 0.86rem; font-weight: 500; cursor: pointer; transition: all 0.15s;
      margin-bottom: 4px; text-align: left;
    }
    .nav-btn:hover { background: var(--bg-elevated); color: var(--text-main); }
    .nav-btn.active {
      background: var(--primary-glow); border-color: rgba(56, 189, 248, 0.35);
      color: var(--primary); font-weight: 600;
    }
    .nav-pill {
      font-size: 0.7rem; background: var(--bg-base); color: var(--text-muted);
      padding: 2px 7px; border-radius: 999px; border: 1px solid var(--border);
    }

    .sidebar-footer {
      margin-top: auto; padding-top: 14px; border-top: 1px solid var(--border);
      display: flex; flex-direction: column; gap: 8px;
    }
    .fs-status {
      font-size: 0.75rem; padding: 10px; border-radius: var(--radius-md);
      background: var(--bg-base); border: 1px solid var(--border);
      display: flex; align-items: center; gap: 8px; color: var(--text-muted);
    }
    .dot { width: 8px; height: 8px; border-radius: 50%; background: var(--amber); flex-shrink: 0; }
    .dot.online { background: var(--emerald); box-shadow: 0 0 8px var(--emerald); }

    /* MAIN AREA */
    .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .topbar {
      height: 64px; background: var(--bg-surface); border-bottom: 1px solid var(--border);
      display: flex; align-items: center; justify-content: space-between; padding: 0 28px;
      flex-shrink: 0;
    }
    .topbar-left { display: flex; align-items: center; gap: 14px; }
    .topbar-title { font-size: 1.1rem; font-weight: 700; }
    .mcp-strip { display: flex; align-items: center; gap: 6px; }
    .mcp-chip {
      font-size: 0.72rem; padding: 4px 9px; border-radius: 999px;
      background: var(--bg-elevated); border: 1px solid var(--border);
      color: var(--text-muted); display: flex; align-items: center; gap: 5px; cursor: pointer;
    }
    .mcp-chip.active { border-color: rgba(16, 185, 129, 0.4); color: #a7f3d0; background: rgba(16, 185, 129, 0.1); }

    .topbar-actions { display: flex; align-items: center; gap: 10px; }
    .btn {
      padding: 8px 14px; border-radius: var(--radius-sm); font-size: 0.82rem;
      font-weight: 600; cursor: pointer; border: 1px solid var(--border);
      background: var(--bg-elevated); color: var(--text-main); transition: all 0.15s;
      display: inline-flex; align-items: center; gap: 6px;
    }
    .btn:hover { border-color: var(--border-hover); background: #1e2638; }
    .btn-primary {
      background: linear-gradient(135deg, var(--primary), #0284c7);
      color: #04101c; border-color: transparent; font-weight: 700;
    }
    .btn-primary:hover { filter: brightness(1.08); }
    .btn-emerald { background: rgba(16, 185, 129, 0.15); color: #34d399; border-color: rgba(16, 185, 129, 0.35); }
    .btn-rose { background: rgba(244, 63, 94, 0.15); color: #fb7185; border-color: rgba(244, 63, 94, 0.35); }

    /* VIEWPORT CONTENT */
    .viewport { flex: 1; overflow-y: auto; padding: 24px 28px; }
    .view-pane { display: none; }
    .view-pane.active { display: block; }

    /* KANBAN */
    .kanban-grid {
      display: grid; grid-template-columns: repeat(5, minmax(260px, 1fr));
      gap: 16px; align-items: start; overflow-x: auto; padding-bottom: 16px;
    }
    .kanban-col {
      background: var(--bg-surface); border: 1px solid var(--border);
      border-radius: var(--radius-lg); padding: 14px; min-height: 72vh;
      display: flex; flex-direction: column;
    }
    .col-header {
      display: flex; align-items: center; justify-content: space-between;
      padding-bottom: 12px; margin-bottom: 12px; border-bottom: 1px solid var(--border);
    }
    .col-header h3 { font-size: 0.8rem; text-transform: uppercase; letter-spacing: 0.06em; color: var(--text-muted); display: flex; align-items: center; gap: 7px; }
    .task-card {
      background: var(--bg-elevated); border: 1px solid var(--border);
      border-radius: var(--radius-md); padding: 14px; margin-bottom: 10px;
      cursor: pointer; transition: all 0.16s; position: relative;
    }
    .task-card:hover { border-color: var(--primary); transform: translateY(-2px); box-shadow: var(--shadow); }
    .task-id { font-family: monospace; font-size: 0.7rem; color: var(--primary); font-weight: 700; }
    .task-title { font-size: 0.9rem; font-weight: 600; margin: 5px 0 6px; color: var(--text-main); line-height: 1.35; }
    .task-desc { font-size: 0.78rem; color: var(--text-muted); line-height: 1.45; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; margin-bottom: 10px; }
    .task-meta { display: flex; flex-wrap: wrap; gap: 5px; align-items: center; justify-content: space-between; padding-top: 8px; border-top: 1px solid rgba(255,255,255,0.05); }
    .chip { font-size: 0.68rem; padding: 2px 7px; border-radius: 4px; background: var(--bg-base); border: 1px solid var(--border); color: var(--text-muted); }
    .chip-agent { color: var(--indigo); border-color: rgba(129, 140, 248, 0.3); background: rgba(129, 140, 248, 0.1); }
    .chip-skill { color: var(--primary); border-color: rgba(56, 189, 248, 0.3); background: rgba(56, 189, 248, 0.08); }
    .gate-box {
      margin-top: 10px; padding-top: 10px; border-top: 1px dashed var(--border);
      display: flex; gap: 6px;
    }
    .gate-box button { flex: 1; padding: 6px; font-size: 0.74rem; border-radius: 5px; cursor: pointer; font-weight: 700; border: none; }

    /* CARDS GRID (AGENTS, SKILLS, MCPS) */
    .section-bar { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    .cards-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(340px, 1fr)); gap: 18px; }
    .entity-card {
      background: var(--bg-surface); border: 1px solid var(--border);
      border-radius: var(--radius-lg); padding: 20px; cursor: pointer;
      transition: all 0.16s; display: flex; flex-direction: column; justify-content: space-between;
    }
    .entity-card:hover { border-color: var(--primary); transform: translateY(-2px); box-shadow: var(--shadow); }
    .entity-head { display: flex; justify-content: space-between; align-items: flex-start; gap: 10px; margin-bottom: 10px; }
    .entity-title { font-size: 1.02rem; font-weight: 700; color: var(--text-main); }
    .entity-sub { font-size: 0.76rem; color: var(--primary); font-family: monospace; margin-bottom: 8px; }
    .entity-body { font-size: 0.83rem; color: var(--text-muted); line-height: 1.5; margin-bottom: 14px; }
    .tag-row { display: flex; flex-wrap: wrap; gap: 5px; margin-top: auto; }

    /* ORCHESTRATOR CONSOLE */
    .orch-layout { display: grid; grid-template-columns: 1.2fr 1fr; gap: 22px; }
    .panel { background: var(--bg-surface); border: 1px solid var(--border); border-radius: var(--radius-lg); padding: 22px; }
    .panel h3 { font-size: 1rem; margin-bottom: 6px; display: flex; align-items: center; gap: 8px; }
    .panel p.sub { font-size: 0.82rem; color: var(--text-muted); margin-bottom: 16px; }
    .form-field { margin-bottom: 14px; }
    .form-field label { display: block; font-size: 0.78rem; color: var(--text-muted); font-weight: 600; margin-bottom: 6px; }
    .form-field input, .form-field textarea, .form-field select {
      width: 100%; background: var(--bg-base); border: 1px solid var(--border);
      color: var(--text-main); padding: 10px 12px; border-radius: var(--radius-sm); font-size: 0.86rem;
    }
    .form-field input:focus, .form-field textarea:focus { outline: none; border-color: var(--primary); }

    /* MODAL */
    .modal-backdrop {
      position: fixed; inset: 0; background: rgba(3, 6, 12, 0.82);
      backdrop-filter: blur(6px); display: none; align-items: center; justify-content: center;
      z-index: 1000; padding: 20px;
    }
    .modal-backdrop.open { display: flex; }
    .modal {
      background: var(--bg-surface); border: 1px solid var(--border-hover);
      border-radius: var(--radius-lg); width: 100%; max-width: 720px;
      max-height: 90vh; overflow-y: auto; padding: 26px; box-shadow: var(--shadow);
    }
    .modal-header { display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid var(--border); padding-bottom: 14px; margin-bottom: 18px; }
    .checkbox-grid {
      display: grid; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr));
      gap: 8px; background: var(--bg-base); padding: 12px; border-radius: var(--radius-sm);
      border: 1px solid var(--border); max-height: 210px; overflow-y: auto;
    }
    .check-item { display: flex; align-items: center; gap: 8px; font-size: 0.8rem; color: var(--text-main); cursor: pointer; padding: 4px; border-radius: 4px; }
    .check-item:hover { background: var(--bg-elevated); }

    /* TOAST */
    #toast {
      position: fixed; bottom: 22px; right: 22px; background: var(--bg-elevated);
      border: 1px solid var(--primary); color: var(--text-main); padding: 12px 18px;
      border-radius: var(--radius-md); font-size: 0.84rem; font-weight: 600;
      box-shadow: var(--shadow); transform: translateY(120%); opacity: 0;
      transition: all 0.25s; z-index: 2000;
    }
    #toast.show { transform: translateY(0); opacity: 1; }
  </style>
</head>
<body>

  <!-- SIDEBAR -->
  <aside class="sidebar">
    <div class="brand">
      <div class="brand-logo">A²</div>
      <div class="brand-text">
        <h1>Antigravity Studio</h1>
        <span>v3.0 • Harness² OS</span>
      </div>
    </div>

    <div class="nav-group-label">Engenharia & Fluxo</div>
    <button class="nav-btn active" onclick="switchView('orchestrator', this)">
      <span>🧠 Master Orchestrator</span>
      <span class="nav-pill">IA</span>
    </button>
    <button class="nav-btn" onclick="switchView('kanban', this)">
      <span>📋 Kanban & Gates</span>
      <span class="nav-pill" id="nav-count-tasks">0</span>
    </button>

    <div class="nav-group-label">Arquitetura Modular (1:N)</div>
    <button class="nav-btn" onclick="switchView('agents', this)">
      <span>🤖 Especialistas (Agentes)</span>
      <span class="nav-pill" id="nav-count-agents">0</span>
    </button>
    <button class="nav-btn" onclick="switchView('skills', this)">
      <span>⚡ Catálogo de Skills</span>
      <span class="nav-pill" id="nav-count-skills">0</span>
    </button>
    <button class="nav-btn" onclick="switchView('mcps', this)">
      <span>🔌 Servidores MCP</span>
      <span class="nav-pill" id="nav-count-mcps">0</span>
    </button>

    <div class="sidebar-footer">
      <div class="fs-status" id="fs-indicator">
        <span class="dot" id="fs-dot"></span>
        <span id="fs-text">Modo Memória Local (Conecte a pasta p/ Auto-Save real)</span>
      </div>
      <button class="btn btn-primary" style="width:100%; justify-content:center;" onclick="connectRepositoryFolder()">
        🔗 Conectar Pasta do Projeto
      </button>
      <button class="btn" style="width:100%; justify-content:center;" onclick="downloadHarnessBundle()">
        ⬇ Baixar harness.yaml
      </button>
    </div>
  </aside>

  <!-- MAIN -->
  <div class="main">
    <header class="topbar">
      <div class="topbar-left">
        <h2 class="topbar-title" id="view-title">🧠 Master Orchestrator & Planejamento</h2>
        <div class="mcp-strip" id="topbar-mcps"></div>
      </div>
      <div class="topbar-actions">
        <button class="btn" onclick="openSkillModal()">+ Nova Skill</button>
        <button class="btn" onclick="openAgentModal()">+ Novo Agente</button>
        <button class="btn btn-primary" onclick="openTaskModal()">+ Nova Tarefa</button>
      </div>
    </header>

    <main class="viewport">

      <!-- VIEW 1: MASTER ORCHESTRATOR -->
      <section id="view-orchestrator" class="view-pane active">
        <div class="orch-layout">
          <div class="panel">
            <h3>🎯 Despacho Inteligente de Feature / Bugfix</h3>
            <p class="sub">O Master Orchestrator analisa o <code>PROJECT_BRAIN.md</code>, detecta os MCPs ativos (Supabase, Stitch, Dart, Graft) e decompõe a demanda atribuindo o melhor Agente e suas Skills.</p>
            
            <div class="form-field">
              <label>Título da Demanda / Épico</label>
              <input type="text" id="orch-title" placeholder="Ex: Implementar Checkout Offline com Sincronização Supabase e UI Material 3">
            </div>
            <div class="form-field">
              <label>Descrição Técnica, Regras de Negócio e Restrições</label>
              <textarea id="orch-desc" rows="5" placeholder="Descreva o que precisa ser feito. Ex: O preço deve ser centralizado no domínio (PrecoService), tela com 4 estados obrigatórios, persistência SQLite com índices e sincronização Supabase RLS..."></textarea>
            </div>
            <div class="form-field">
              <label>Complexidade Estimada</label>
              <select id="orch-complexity">
                <option value="Alta (Decompor em Múltiplas Tarefas TDD)">Alta — Decompor em Spec + UI + TDD RED + GREEN + Auditoria</option>
                <option value="Média (Fluxo Padrão TDD)">Média — Fluxo Padrão TDD</option>
                <option value="Baixa (Correção Cirúrgica)">Baixa — Correção Cirúrgica Direta</option>
              </select>
            </div>
            <div style="display:flex; gap:10px;">
              <button class="btn btn-primary" onclick="orchestrateDemand()">⚡ Analisar, Decompor no Kanban & Gerar Prompt</button>
            </div>
          </div>

          <div class="panel">
            <h3>📋 Prompt Canônico Gerado para o Chat da IDE</h3>
            <p class="sub">Copie e cole no Antigravity, Claude Code, Cursor ou Codex após decompor a demanda:</p>
            <div class="form-field">
              <textarea id="orch-output" rows="13" readonly style="font-family:monospace; font-size:0.79rem; color:#a5f3fc;"></textarea>
            </div>
            <button class="btn" onclick="copyOrchestratorPrompt()">📋 Copiar Prompt para o Agente</button>
          </div>
        </div>
      </section>

      <!-- VIEW 2: KANBAN -->
      <section id="view-kanban" class="view-pane">
        <div class="section-bar">
          <p style="font-size:0.85rem; color:var(--text-muted);">Clique em qualquer card para inspecionar, editar agente/skills, mudar coluna ou aprovar no Gate Humano.</p>
        </div>
        <div class="kanban-grid" id="kanban-container"></div>
      </section>

      <!-- VIEW 3: AGENTES -->
      <section id="view-agents" class="view-pane">
        <div class="section-bar">
          <p style="font-size:0.85rem; color:var(--text-muted);">Clique em qualquer Agente para editar sua persona, senioridade, MCPs permitidos e selecionar suas Skills (1:N).</p>
          <button class="btn btn-primary" onclick="openAgentModal()">+ Criar Novo Agente</button>
        </div>
        <div class="cards-grid" id="agents-grid"></div>
      </section>

      <!-- VIEW 4: SKILLS -->
      <section id="view-skills" class="view-pane">
        <div class="section-bar">
          <p style="font-size:0.85rem; color:var(--text-muted);">Catálogo global desacoplado. Ao criar ou editar uma Skill, ela é gravada em <code>.agents/skills/&lt;id&gt;/SKILL.md</code> e fica disponível para qualquer Agente.</p>
          <button class="btn btn-primary" onclick="openSkillModal()">+ Criar Nova Skill</button>
        </div>
        <div class="cards-grid" id="skills-grid"></div>
      </section>

      <!-- VIEW 5: MCPS -->
      <section id="view-mcps" class="view-pane">
        <div class="section-bar">
          <p style="font-size:0.85rem; color:var(--text-muted);">Servidores Model Context Protocol reconhecidos pelo Orquestrador e pelos Especialistas (sincronizado com <code>.agents/mcp.json</code>).</p>
        </div>
        <div class="cards-grid" id="mcps-grid"></div>
      </section>

    </main>
  </div>

  <!-- MODAL GENÉRICO DE INSPEÇÃO E EDIÇÃO -->
  <div class="modal-backdrop" id="modal-backdrop" onclick="if(event.target===this) closeModal()">
    <div class="modal" id="modal-content"></div>
  </div>

  <div id="toast">Salvo automaticamente no Harness!</div>

  <script>
    // =========================================================================
    // ESTADO PADRÃO COMPLETO (COM AGENTES, SKILLS E MCPS PRÉ-CARREGADOS)
    // =========================================================================
    const DEFAULT_STATE = {
      version: "3.0-google-harness2-modular",
      mcps: {
        dart_mcp: {
          name: "Official Dart & Flutter MCP",
          command: "dart",
          args: ["mcp-server"],
          active: true,
          desc: "Inspeção da árvore de widgets em runtime, resolução de símbolos, pubspec e execução assistida de testes Flutter."
        },
        supabase_mcp: {
          name: "Supabase MCP Server",
          command: "npx",
          args: ["-y", "@supabase/mcp-server-supabase@latest"],
          active: true,
          desc: "Inspeção de schema Postgres, criação de migrations, políticas RLS, Edge Functions e geração de tipos."
        },
        google_stitch: {
          name: "Google Stitch Visual MCP",
          command: "npx",
          args: ["-y", "@google/stitch-mcp-server"],
          active: true,
          env: {
            STITCH_REFERENCES_DIR: "./_references/screens",
            STITCH_OUTPUT_DIR: "./_specs"
          },
          desc: "Extração de Design Tokens, hierarquia de componentes e fidelidade visual a partir de telas em _references/screens/."
        },
        graft_ast: {
          name: "Graft AST Code Indexer",
          command: "graft",
          args: ["mcp", "--watch"],
          active: true,
          desc: "Navegação cirúrgica em árvore sintática (AST) para localizar chamadas e impactos sem estourar janela de contexto."
        },
        ai_memory: {
          name: "AI Memory & Handoff DB",
          command: "ai-memory",
          args: ["mcp"],
          active: true,
          env: {
            AI_MEMORY_DB_PATH: "./.agents/memory/context.db"
          },
          desc: "Memória episódica de decisões arquiteturais e passagem de tickets atômicos entre subagentes."
        }
      },
      skills: {
        spec_discovery: {
          name: "Spec-Driven Discovery & PRD",
          category: "Arquitetura & Produto",
          file: ".agents/skills/spec-discovery/SKILL.md",
          desc: "Transforma requisitos vagos em contratos técnicos estritos, mapeando casos de borda e os 4 estados de tela (Loading, Empty, Error, Success).",
          rules: "Nunca autorize codificação sem critérios de aceitação verificáveis e contratos de entrada/saída documentados."
        },
        clean_architecture: {
          name: "Clean Architecture & Domain Purity",
          category: "Engenharia de Software",
          file: ".agents/skills/clean-architecture/SKILL.md",
          desc: "Separação estrita entre Presentation, Domain (Services/Entities puros) e Data (Repositories/DTOs). Centralização de regras críticas.",
          rules: "Proibido colocar SQL, chamadas HTTP ou regras de negócio dentro de Widgets ou Controllers de UI."
        },
        mobile_ux_design_system: {
          name: "Mobile UX & Design Systems",
          category: "UI/UX & Frontend",
          file: ".agents/skills/mobile-ux/SKILL.md",
          desc: "Design Tokens semânticos, alvos de toque mínimos de 48x48dp, micro-interações fluidas 60/120fps, Material 3 e responsividade adaptativa.",
          rules: "Consuma tokens via Theme.of(context). Garanta feedback visual imediato e estados vazios informativos."
        },
        stitch_visual_ingest: {
          name: "Google Stitch Visual Ingestion",
          category: "UI/UX & Frontend",
          file: ".agents/skills/flutter-build-responsive-layout/SKILL.md",
          desc: "Leitura de protótipos e imagens em _references/screens/ via Stitch MCP para extração de espaçamentos, tipografia e componentes.",
          rules: "Sempre cruze os prints de referência com o Design System antes de construir novos Widgets."
        },
        supabase_fullstack: {
          name: "Supabase Auth, RLS & Edge",
          category: "Backend & Cloud",
          file: ".agents/skills/supabase-flutter/SKILL.md",
          desc: "Integração segura com Supabase, políticas Row Level Security (RLS), sincronização incremental e funções serverless.",
          rules: "Toda tabela exposta deve possuir política RLS explícita e tipagem forte validada."
        },
        local_first_sqlite: {
          name: "Local-First SQLite & Performance",
          category: "Dados & Offline",
          file: ".agents/skills/local-first-data/SKILL.md",
          desc: "Modelagem SQLite local de alta performance, índices compostos (CREATE INDEX), paginação (LIMIT/OFFSET), debounce de busca e fila offline.",
          rules: "Evite Full Table Scans em catálogos grandes; exija paginação e índices em colunas de filtro textual."
        },
        tdd_red_green: {
          name: "Strict TDD (Red-Green-Refactor)",
          category: "Qualidade & Testes",
          file: ".agents/skills/code-quality-tests/SKILL.md",
          desc: "Desenvolvimento guiado por testes determinísticos: criação do teste que falha (RED) antes da implementação mínima (GREEN).",
          rules: "Em testes concorrentes de banco local, isole instâncias em memória para evitar locks."
        },
        flutter_riverpod_state: {
          name: "Reactive State Management (Riverpod)",
          category: "Engenharia Mobile",
          file: ".agents/skills/flutter-state-riverpod/SKILL.md",
          desc: "Gerenciamento de estado previsível, imutável e reativo usando Notifiers/AsyncNotifiers com descarte seguro de recursos.",
          rules: "Evite mutações diretas de estado durante o ciclo de build; use estados assíncronos tipados."
        },
        harness_evolver: {
          name: "Google Harness² Recursive Evolver",
          category: "Meta-Otimização",
          file: ".agents/skills/harness-evolver/SKILL.md",
          desc: "Ciclo Propose–Probe–Compose do Google Research Harness²: analisa falhas de QA ou reprovações no Kanban e atualiza as Skills automaticamente.",
          rules: "Quando uma tarefa exigir mais de 1 tentativa de reparo, sintetize a causa raiz na respectiva SKILL.md."
        }
      },
      agents: {
        master_orchestrator: {
          role: "Master Orchestrator & Principal Architect",
          seniority: "Principal / Staff Engineer (15+ anos)",
          persona: "Conhece profundamente todo o PROJECT_BRAIN.md, a arquitetura do repositório, os contratos de domínio e o status dos servidores MCP conectados. Decompõe épicos em tarefas menores por complexidade e escala o especialista exato.",
          skills: ["spec_discovery", "clean_architecture", "harness_evolver"],
          mcps: ["dart_mcp", "supabase_mcp", "google_stitch", "graft_ast", "ai_memory"]
        },
        ui_ux_specialist: {
          role: "Senior UI/UX & Design System Engineer",
          seniority: "Senior Product Designer & Frontend Architect (10+ anos)",
          persona: "Especialista em Design Systems escaláveis, Material 3, acessibilidade WCAG, micro-interações e conversão de layouts do Google Stitch em componentes Flutter responsivos.",
          skills: ["mobile_ux_design_system", "stitch_visual_ingest", "flutter_riverpod_state"],
          mcps: ["google_stitch", "dart_mcp"]
        },
        tdd_specialist: {
          role: "Lead TDD & Contract Verification Engineer",
          seniority: "Senior QA & Test Architect (10+ anos)",
          persona: "Guardião da Fase RED. Escreve testes unitários, de widget e de contrato de performance antes que qualquer código de produção exista.",
          skills: ["tdd_red_green", "clean_architecture"],
          mcps: ["dart_mcp", "graft_ast"]
        },
        mobile_domain_builder: {
          role: "Senior Flutter & Domain Engineer",
          seniority: "Senior Mobile Software Engineer (12+ anos)",
          persona: "Implementa a Fase GREEN com código limpo, serviços de domínio desacoplados (ex: PrecoService) e gerenciamento de estado reativo.",
          skills: ["clean_architecture", "flutter_riverpod_state", "mobile_ux_design_system"],
          mcps: ["dart_mcp", "graft_ast", "ai_memory"]
        },
        data_supabase_specialist: {
          role: "Offline-First SQLite & Supabase Architect",
          seniority: "Senior Data & Cloud Engineer (12+ anos)",
          persona: "Especialista em motores de busca SQLite ultrarrápidos (índices, paginação, sincronização FTP/REST) e backends Supabase com RLS e Edge Functions.",
          skills: ["local_first_sqlite", "supabase_fullstack", "clean_architecture"],
          mcps: ["supabase_mcp", "dart_mcp", "graft_ast"]
        },
        qa_self_healer: {
          role: "Autonomous QA Validator & Self-Healing Agent",
          seniority: "Staff Quality & Reliability Engineer",
          persona: "Executa linters, testes automatizados e auditoria de regressão em loop fechado (até 3 tentativas) e aciona o Harness Evolver para registrar aprendizados.",
          skills: ["tdd_red_green", "harness_evolver", "clean_architecture"],
          mcps: ["dart_mcp", "graft_ast", "ai_memory"]
        }
      },
      tasks: [
        {
          id: "T01",
          title: "Recuperação de Senha",
          desc: "Fluxo completo de reset de senha com Supabase Auth, deep link e os 4 estados de tela. Spec: _specs/tasks/T01-recuperacao-senha.md",
          column: "backlog",
          agent: "mobile_domain_builder",
          skills: ["spec_discovery", "clean_architecture"],
          complexity: "Média",
          feedback: ""
        },
        {
          id: "T02",
          title: "Dashboard Gerencial",
          desc: "Painel responsivo com Design Tokens, gráficos e estados de carregamento. Spec: _specs/tasks/T02-dashboard-gerencial.md",
          column: "backlog",
          agent: "ui_ux_specialist",
          skills: ["mobile_ux_design_system", "stitch_visual_ingest"],
          complexity: "Alta",
          feedback: ""
        },
        {
          id: "T03",
          title: "Push Notifications",
          desc: "Notificações com fila offline, permissões e deep link para a tela de destino. Spec: _specs/tasks/T03-push-notifications.md",
          column: "backlog",
          agent: "mobile_domain_builder",
          skills: ["flutter_riverpod_state", "clean_architecture"],
          complexity: "Média",
          feedback: ""
        },
        {
          id: "T04",
          title: "In-App Purchases",
          desc: "Compra de assinatura com validação de recibo e restauração de compras. Spec: _specs/tasks/T04-in-app-purchases.md",
          column: "backlog",
          agent: "mobile_domain_builder",
          skills: ["clean_architecture", "flutter_riverpod_state"],
          complexity: "Alta",
          feedback: ""
        },
        {
          id: "T05",
          title: "Backend Alternativo / Sync",
          desc: "Sincronização incremental Supabase + cache local SQLite com políticas RLS. Spec: _specs/tasks/T05-firebase-alternativo.md",
          column: "backlog",
          agent: "data_supabase_specialist",
          skills: ["supabase_fullstack", "local_first_sqlite"],
          complexity: "Alta",
          feedback: ""
        },
        {
          id: "T00",
          title: "Unificação do Harness v2.1 com Dart MCP Server e Matriz 1:N",
          desc: "Base do Flutter Mobile Harness v2.1 consolidada, validada e commitada.",
          column: "done",
          agent: "master_orchestrator",
          skills: ["spec_discovery", "clean_architecture"],
          complexity: "Alta",
          feedback: "Aprovado e commitado."
        }
      ]
    };

    const COLUMNS = [
      {
        id: "backlog",
        title: "1. Backlog & Specs",
        gate: "PRD/spec aprovada, critérios de aceitação objetivos e skills 1:N definidas.",
        color: "#94a3b8"
      },
      {
        id: "red",
        title: "2. TDD Fase RED (Testes Falhos)",
        gate: "Suíte criada e executada com falha comprovada pelo motivo correto (RED).",
        color: "#f43f5e"
      },
      {
        id: "green",
        title: "3. TDD Fase GREEN (Implementação)",
        gate: "Menor código possível para a suíte ficar verde; `dart analyze` sem erros.",
        color: "#38bdf8"
      },
      {
        id: "review",
        title: "4. Loop QA/A11y & Gate Humano",
        gate: "Até 3 ciclos de autorreparo, cobertura mínima, Semantics/contraste/touch targets validados.",
        color: "#f59e0b"
      },
      {
        id: "done",
        title: "5. Concluído & Evoluído",
        gate: "Commit semântico atômico, Kanban atualizado e PROJECT_BRAIN.md com o aprendizado.",
        color: "#10b981"
      }
    ];

    let state = loadState();
    let dirHandle = null;

    function loadState() {
      const saved = localStorage.getItem("antigravity_studio_v3");
      if (saved) {
        try { return JSON.parse(saved); } catch (e) {}
      }
      return JSON.parse(JSON.stringify(DEFAULT_STATE));
    }

    async function persistState(toastMsg = "Alterações salvas automaticamente no Harness!") {
      localStorage.setItem("antigravity_studio_v3", JSON.stringify(state));
      renderAll();
      if (dirHandle) {
        await writeFilesToDisk();
        showToast("💾 " + toastMsg + " (Gravado no disco)");
      } else {
        showToast("⚡ " + toastMsg);
      }
    }

    function showToast(msg) {
      const t = document.getElementById("toast");
      t.innerText = msg;
      t.classList.add("show");
      setTimeout(() => t.classList.remove("show"), 2600);
    }

    // =========================================================================
    // AUTO-SAVE DIRETO NOS ARQUIVOS DO PROJETO (FILE SYSTEM ACCESS API)
    // =========================================================================
    async function connectRepositoryFolder() {
      if (!window.showDirectoryPicker) {
        alert("Seu navegador não suporta File System Access API direta. Use Chrome/Edge ou o botão 'Baixar harness.yaml'.");
        return;
      }
      try {
        dirHandle = await window.showDirectoryPicker({ mode: "readwrite" });
        document.getElementById("fs-dot").classList.add("online");
        document.getElementById("fs-text").innerText = `Conectado: ${dirHandle.name} (Auto-Save Ativo)`;
        await writeFilesToDisk();
        showToast("Conectado! .agents/harness.yaml, skills e task-board.md sincronizados.");
      } catch (err) {
        console.warn("Conexão cancelada:", err);
      }
    }

    async function writeFileByPath(rootHandle, pathParts, content) {
      let current = rootHandle;
      for (let i = 0; i < pathParts.length - 1; i++) {
        current = await current.getDirectoryHandle(pathParts[i], { create: true });
      }
      const fileHandle = await current.getFileHandle(pathParts[pathParts.length - 1], { create: true });
      const writable = await fileHandle.createWritable();
      await writable.write(content);
      await writable.close();
    }

    async function writeFilesToDisk() {
      if (!dirHandle) return;
      // 1. Gravar .agents/harness.yaml
      await writeFileByPath(dirHandle, [".agents", "harness.yaml"], generateHarnessYAML());
      // 2. Gravar .agents/mcp.json
      await writeFileByPath(dirHandle, [".agents", "mcp.json"], generateMcpJSON());
      // 3. Gravar cada Skill em .agents/skills/<id>/SKILL.md
      for (const [id, sk] of Object.entries(state.skills)) {
        const folderName = id.replace(/_/g, "-");
        const skillMd = `---\nname: ${folderName}\ndescription: "${sk.desc.replace(/"/g, '\\"')}"\ncategory: "${sk.category}"\n---\n\n# Skill: ${sk.name}\n\n## Objetivo\n${sk.desc}\n\n## Regras e Guardrails\n${sk.rules || "Seguir os padrões de Clean Architecture e TDD do projeto."}\n`;
        await writeFileByPath(dirHandle, [".agents", "skills", folderName, "SKILL.md"], skillMd);
      }
      // 4. Gravar _specs/task-board.md
      await writeFileByPath(dirHandle, ["_specs", "task-board.md"], generateTaskBoardMarkdown());
    }

    function generateHarnessYAML() {
      let y = `# Antigravity Harness v3.0 — Catálogo desacoplado de Agentes & Skills\n# Gerado automaticamente pelo Harness Studio (harness-studio.html)\nversion: "${state.version}"\n\nmodel_profiles:\n  reasoning: "inherit"\n  coding: "inherit"\n  design: "inherit"\n  fast_ops: "inherit"\n\nmcp_servers:\n`;
      Object.entries(state.mcps).forEach(([id, m]) => {
        y += `  ${id}:\n    enabled: ${m.active}\n    command: "${m.command}"\n    args: [${m.args.map(a => `"${a}"`).join(', ')}]\n`;
        if (m.env && Object.keys(m.env).length) {
          y += `    env:\n`;
          Object.entries(m.env).forEach(([k, v]) => { y += `      ${k}: "${v}"\n`; });
        }
      });
      y += `\nskills_registry:\n`;
      Object.entries(state.skills).forEach(([id, s]) => {
        y += `  ${id}:\n    name: "${s.name}"\n    category: "${s.category}"\n    file: "${s.file}"\n    description: "${s.desc.replace(/"/g, '\\"')}"\n`;
      });
      y += `\nsubagents:\n`;
      Object.entries(state.agents).forEach(([id, a]) => {
        y += `  ${id}:\n    model: "inherit"\n    role: "${a.role}"\n    seniority: "${a.seniority}"\n    persona: "${a.persona.replace(/"/g, '\\"')}"\n    mcps:\n`;
        (a.mcps || []).forEach(m => { y += `      - "${m}"\n`; });
        y += `    skills:\n`;
        (a.skills || []).forEach(sk => { y += `      - "${sk}"\n`; });
      });
      return y;
    }

    function generateMcpJSON() {
      const mcpServers = {};
      Object.entries(state.mcps).forEach(([id, m]) => {
        if (!m.active) return;
        const entry = { command: m.command, args: m.args };
        if (m.env && Object.keys(m.env).length) entry.env = m.env;
        if (m.desc) entry.description = m.desc;
        mcpServers[id] = entry;
      });
      return JSON.stringify({ mcpServers }, null, 2) + "\n";
    }

    function generateTaskBoardMarkdown() {
      let md = `# 📋 Kanban de Desenvolvimento do Projeto (\`task-board.md\`)\n\n`;
      md += `> Sincronizado via Antigravity Harness Studio v3.0 e gerenciado pelo \`master_orchestrator\`.\n`;
      md += `> **Regra de ouro:** nenhum card avança de coluna sem cumprir o gate de saída da coluna atual.\n\n`;
      md += "```text\nBacklog ──▶ TDD RED ──▶ TDD GREEN ──▶ Loop QA/A11y ──▶ Concluído\n```\n\n";
      COLUMNS.forEach(col => {
        md += `## ${col.title}\n`;
        if (col.gate) md += `> **Gate de saída:** ${col.gate}\n\n`;
        const list = state.tasks.filter(t => t.column === col.id);
        if (list.length === 0) {
          md += `- *(Nenhuma tarefa ativa nesta coluna)*\n\n`;
        } else {
          list.forEach(t => {
            const agName = state.agents[t.agent] ? state.agents[t.agent].role : t.agent;
            md += `- **[${t.id}] ${t.title}** — *Agente:* \`${t.agent}\` (${agName}) | *Skills:* \`${(t.skills || []).join(', ')}\`\n  - ${t.desc}\n`;
            if (t.feedback) md += `  - ⚠️ **Feedback de Revisão**: ${t.feedback}\n`;
          });
          md += `\n`;
        }
      });
      md += `---\n\n### Legenda de skills por card\n| Campo | Significado |\n|---|---|\n`;
      md += `| \`Skills:\` | Lista 1:N de skills ativadas para o card (editável no \`harness-studio.html\`). |\n`;
      md += `| \`WIP\` | Limite de trabalho em progresso da coluna; exceder exige justificativa no \`ai_memory\`. |\n`;
      md += `| \`@agente\` | Subagente responsável pela coluna, conforme \`.agents/harness.yaml#subagents\`. |\n`;
      return md;
    }

    // =========================================================================
    // NAVEGAÇÃO E RENDERIZAÇÃO
    // =========================================================================
    function switchView(view, btn) {
      document.querySelectorAll(".view-pane").forEach(p => p.classList.remove("active"));
      document.querySelectorAll(".nav-btn").forEach(b => b.classList.remove("active"));
      document.getElementById("view-" + view).classList.add("active");
      if (btn) btn.classList.add("active");

      const titles = {
        orchestrator: "🧠 Master Orchestrator & Planejamento de Engenharia",
        kanban: "📋 Kanban Interativo & Gate de Aprovação Humana",
        agents: "🤖 Especialistas Configurados (Agentes 1:N Skills)",
        skills: "⚡ Catálogo Global de Skills Reutilizáveis",
        mcps: "🔌 Servidores MCP & Sensores do Ambiente"
      };
      document.getElementById("view-title").innerText = titles[view] || "Antigravity Studio";
      renderAll();
    }

    function renderAll() {
      document.getElementById("nav-count-tasks").innerText = state.tasks.length;
      document.getElementById("nav-count-agents").innerText = Object.keys(state.agents).length;
      document.getElementById("nav-count-skills").innerText = Object.keys(state.skills).length;
      document.getElementById("nav-count-mcps").innerText = Object.values(state.mcps).filter(m => m.active).length;

      // Topbar MCP strip
      document.getElementById("topbar-mcps").innerHTML = Object.entries(state.mcps).map(([id, m]) => `
        <div class="mcp-chip ${m.active ? 'active' : ''}" onclick="toggleMcp('${id}')" title="Clique para ativar/desativar ${m.name}">
          <span>${m.active ? '●' : '○'}</span> ${m.name.replace(' MCP', '')}
        </div>
      `).join('');

      renderKanban();
      renderAgents();
      renderSkills();
      renderMcps();
    }

    function renderKanban() {
      const container = document.getElementById("kanban-container");
      container.innerHTML = COLUMNS.map(col => {
        const colTasks = state.tasks.filter(t => t.column === col.id);
        return `
          <div class="kanban-col">
            <div class="col-header">
              <h3><span style="color:${col.color}">●</span> ${col.title}</h3>
              <span class="nav-pill">${colTasks.length}</span>
            </div>
            <div>
              ${colTasks.map(t => {
                const ag = state.agents[t.agent];
                return `
                  <div class="task-card" onclick="openTaskModal('${t.id}')">
                    <div style="display:flex; justify-content:space-between; align-items:center;">
                      <span class="task-id">${t.id}</span>
                      <span class="chip">${t.complexity || 'Média'}</span>
                    </div>
                    <div class="task-title">${t.title}</div>
                    <div class="task-desc">${t.desc}</div>
                    ${t.feedback ? `<div style="font-size:0.74rem; color:#fda4af; background:rgba(244,63,94,0.12); padding:6px; border-radius:4px; margin-bottom:8px;">⚠️ Feedback: ${t.feedback}</div>` : ''}
                    <div class="task-meta">
                      <span class="chip chip-agent">🤖 ${ag ? ag.role.split('&')[0] : t.agent}</span>
                      <span class="chip chip-skill">⚡ ${(t.skills || []).length} skills</span>
                    </div>
                    ${col.id === 'review' ? `
                      <div class="gate-box" onclick="event.stopPropagation()">
                        <button class="btn-emerald" onclick="approveTask('${t.id}')">✔ Aprovar</button>
                        <button class="btn-rose" onclick="rejectTask('${t.id}')">✖ Reprovar</button>
                      </div>
                    ` : ''}
                  </div>
                `;
              }).join('')}
            </div>
          </div>
        `;
      }).join('');
    }

    function renderAgents() {
      document.getElementById("agents-grid").innerHTML = Object.entries(state.agents).map(([id, a]) => `
        <div class="entity-card" onclick="openAgentModal('${id}')">
          <div>
            <div class="entity-head">
              <div>
                <div class="entity-title">🤖 ${a.role}</div>
                <div class="entity-sub">ID: ${id} • ${a.seniority}</div>
              </div>
              <span class="chip">Editar ✎</span>
            </div>
            <div class="entity-body">${a.persona}</div>
          </div>
          <div>
            <div style="font-size:0.72rem; color:var(--text-dim); margin-bottom:6px; font-weight:700;">SKILLS ATRIBUÍDAS (${(a.skills||[]).length}):</div>
            <div class="tag-row" style="margin-bottom:10px;">
              ${(a.skills || []).map(sk => `<span class="chip chip-skill">⚡ ${state.skills[sk] ? state.skills[sk].name : sk}</span>`).join('')}
            </div>
            <div style="font-size:0.72rem; color:var(--text-dim); margin-bottom:6px; font-weight:700;">MCPS CONECTADOS:</div>
            <div class="tag-row">
              ${(a.mcps || []).map(m => `<span class="chip">${state.mcps[m] ? state.mcps[m].name : m}</span>`).join('')}
            </div>
          </div>
        </div>
      `).join('');
    }

    function renderSkills() {
      document.getElementById("skills-grid").innerHTML = Object.entries(state.skills).map(([id, s]) => {
        const usedBy = Object.entries(state.agents).filter(([_, a]) => (a.skills || []).includes(id)).map(([_, a]) => a.role.split(' ')[0]);
        return `
          <div class="entity-card" onclick="openSkillModal('${id}')">
            <div>
              <div class="entity-head">
                <div>
                  <div class="entity-title">⚡ ${s.name}</div>
                  <div class="entity-sub">${s.file}</div>
                </div>
                <span class="chip">${s.category}</span>
              </div>
              <div class="entity-body">${s.desc}</div>
            </div>
            <div class="tag-row">
              <span class="chip chip-agent">Usada por ${usedBy.length} agente(s)</span>
              <span class="chip">Clique p/ editar SKILL.md ✎</span>
            </div>
          </div>
        `;
      }).join('');
    }

    function renderMcps() {
      document.getElementById("mcps-grid").innerHTML = Object.entries(state.mcps).map(([id, m]) => `
        <div class="entity-card" onclick="toggleMcp('${id}')">
          <div>
            <div class="entity-head">
              <div>
                <div class="entity-title">🔌 ${m.name}</div>
                <div class="entity-sub">${m.command} ${m.args.join(' ')}</div>
              </div>
              <span class="chip" style="color:${m.active ? '#34d399' : '#94a3b8'}">${m.active ? 'ATIVO' : 'INATIVO'}</span>
            </div>
            <div class="entity-body">${m.desc}</div>
          </div>
          <div class="tag-row">
            <span class="chip">Clique para alternar status no .agents/mcp.json</span>
          </div>
        </div>
      `).join('');
    }

    // =========================================================================
    // MODAIS DE INSPEÇÃO E EDIÇÃO (CLICAR NO CARD ABRE DETALHES COMPLETOS)
    // =========================================================================
    function openModal(html) {
      document.getElementById("modal-content").innerHTML = html;
      document.getElementById("modal-backdrop").classList.add("open");
    }
    function closeModal() {
      document.getElementById("modal-backdrop").classList.remove("open");
    }

    // MODAL DE AGENTE (CRIAR / EDITAR + SELECIONAR MÚLTIPLAS SKILLS E MCPS)
    function openAgentModal(agentId = null) {
      const a = agentId ? state.agents[agentId] : { role: "", seniority: "Senior Engineer (10+ anos)", persona: "", skills: [], mcps: ["dart_mcp"] };
      const skillsCheckboxes = Object.entries(state.skills).map(([sid, s]) => `
        <label class="check-item">
          <input type="checkbox" name="agent-skill" value="${sid}" ${(a.skills || []).includes(sid) ? 'checked' : ''}>
          <span>${s.name}</span>
        </label>
      `).join('');

      const mcpsCheckboxes = Object.entries(state.mcps).map(([mid, m]) => `
        <label class="check-item">
          <input type="checkbox" name="agent-mcp" value="${mid}" ${(a.mcps || []).includes(mid) ? 'checked' : ''}>
          <span>${m.name}</span>
        </label>
      `).join('');

      openModal(`
        <div class="modal-header">
          <h3>🤖 ${agentId ? 'Editar Agente Especialista' : 'Criar Novo Agente Especialista'}</h3>
          <button class="btn" onclick="closeModal()">✕</button>
        </div>
        <div class="form-field">
          <label>ID Técnico do Agente (ex: ui_ux_specialist)</label>
          <input type="text" id="m-agent-id" value="${agentId || ''}" ${agentId ? 'readonly' : ''} placeholder="Ex: security_auditor">
        </div>
        <div class="form-field">
          <label>Título / Papel Profissional</label>
          <input type="text" id="m-agent-role" value="${a.role}" placeholder="Ex: Senior UI/UX & Design System Architect">
        </div>
        <div class="form-field">
          <label>Senioridade & Experiência</label>
          <input type="text" id="m-agent-seniority" value="${a.seniority}" placeholder="Ex: Staff Designer & Frontend Engineer (12+ anos)">
        </div>
        <div class="form-field">
          <label>Persona, Diretrizes Comportamentais e Foco Técnico</label>
          <textarea id="m-agent-persona" rows="3">${a.persona}</textarea>
        </div>
        <div class="form-field">
          <label>Selecione as Skills deste Agente (Relação 1:N):</label>
          <div class="checkbox-grid">${skillsCheckboxes}</div>
        </div>
        <div class="form-field">
          <label>Servidores MCP que este Agente pode utilizar:</label>
          <div class="checkbox-grid">${mcpsCheckboxes}</div>
        </div>
        <div style="display:flex; justify-content:space-between; margin-top:18px;">
          ${agentId ? `<button class="btn btn-rose" onclick="deleteAgent('${agentId}')">Excluir Agente</button>` : '<span></span>'}
          <div style="display:flex; gap:10px;">
            <button class="btn" onclick="closeModal()">Cancelar</button>
            <button class="btn btn-primary" onclick="saveAgentModal()">💾 Salvar Agente no Harness</button>
          </div>
        </div>
      `);
    }

    function saveAgentModal() {
      const id = document.getElementById("m-agent-id").value.trim().replace(/\s+/g, "_").toLowerCase();
      const role = document.getElementById("m-agent-role").value.trim();
      const seniority = document.getElementById("m-agent-seniority").value.trim();
      const persona = document.getElementById("m-agent-persona").value.trim();
      const skills = Array.from(document.querySelectorAll("input[name='agent-skill']:checked")).map(i => i.value);
      const mcps = Array.from(document.querySelectorAll("input[name='agent-mcp']:checked")).map(i => i.value);

      if (!id || !role) return alert("Preencha o ID e o Papel do Agente!");
      state.agents[id] = { role, seniority, persona, skills, mcps };
      closeModal();
      persistState(`Agente '${role}' salvo automaticamente no harness.yaml!`);
    }

    function deleteAgent(id) {
      if (!confirm("Deseja remover este agente do catálogo?")) return;
      delete state.agents[id];
      closeModal();
      persistState("Agente removido do harness.yaml.");
    }

    // MODAL DE SKILL (CRIAR / EDITAR + ATRIBUIR A AGENTES)
    function openSkillModal(skillId = null) {
      const s = skillId ? state.skills[skillId] : { name: "", category: "Engenharia Mobile", file: "", desc: "", rules: "" };
      const assignedAgents = Object.entries(state.agents).map(([aid, ag]) => `
        <label class="check-item">
          <input type="checkbox" name="skill-agent" value="${aid}" ${(ag.skills || []).includes(skillId) ? 'checked' : ''}>
          <span>${ag.role}</span>
        </label>
      `).join('');

      openModal(`
        <div class="modal-header">
          <h3>⚡ ${skillId ? 'Inspecionar / Editar Skill' : 'Criar Nova Skill no Harness'}</h3>
          <button class="btn" onclick="closeModal()">✕</button>
        </div>
        <div class="form-field">
          <label>ID da Skill (ex: frontend_best_practices)</label>
          <input type="text" id="m-skill-id" value="${skillId || ''}" ${skillId ? 'readonly' : ''} placeholder="Ex: design_tokens_m3">
        </div>
        <div class="form-field">
          <label>Nome da Habilidade</label>
          <input type="text" id="m-skill-name" value="${s.name}" placeholder="Ex: Boas Práticas de Frontend & Design System">
        </div>
        <div class="form-field">
          <label>Categoria</label>
          <input type="text" id="m-skill-cat" value="${s.category}" placeholder="Ex: UI/UX & Frontend">
        </div>
        <div class="form-field">
          <label>Descrição Técnica da Competência</label>
          <textarea id="m-skill-desc" rows="3">${s.desc}</textarea>
        </div>
        <div class="form-field">
          <label>Guardrails e Regras Estritas (Conteúdo do SKILL.md)</label>
          <textarea id="m-skill-rules" rows="3">${s.rules || ''}</textarea>
        </div>
        <div class="form-field">
          <label>Vincular esta Skill imediatamente aos seguintes Agentes:</label>
          <div class="checkbox-grid">${assignedAgents}</div>
        </div>
        <div style="display:flex; justify-content:space-between; margin-top:18px;">
          ${skillId ? `<button class="btn btn-rose" onclick="deleteSkill('${skillId}')">Excluir Skill</button>` : '<span></span>'}
          <div style="display:flex; gap:10px;">
            <button class="btn" onclick="closeModal()">Cancelar</button>
            <button class="btn btn-primary" onclick="saveSkillModal()">💾 Salvar Skill Automaticamente</button>
          </div>
        </div>
      `);
    }

    function saveSkillModal() {
      const id = document.getElementById("m-skill-id").value.trim().replace(/\s+/g, "_").toLowerCase();
      const name = document.getElementById("m-skill-name").value.trim();
      const category = document.getElementById("m-skill-cat").value.trim();
      const desc = document.getElementById("m-skill-desc").value.trim();
      const rules = document.getElementById("m-skill-rules").value.trim();
      const folder = id.replace(/_/g, "-");

      if (!id || !name) return alert("Preencha ID e Nome da Skill!");
      state.skills[id] = { name, category, file: `.agents/skills/${folder}/SKILL.md`, desc, rules };

      const checkedAgents = Array.from(document.querySelectorAll("input[name='skill-agent']:checked")).map(i => i.value);
      Object.entries(state.agents).forEach(([aid, ag]) => {
        ag.skills = ag.skills || [];
        if (checkedAgents.includes(aid) && !ag.skills.includes(id)) ag.skills.push(id);
        if (!checkedAgents.includes(aid)) ag.skills = ag.skills.filter(x => x !== id);
      });

      closeModal();
      persistState(`Skill '${name}' salva em .agents/skills/${folder}/SKILL.md!`);
    }

    function deleteSkill(id) {
      if (!confirm("Remover esta skill do catálogo?")) return;
      delete state.skills[id];
      Object.values(state.agents).forEach(ag => {
        ag.skills = (ag.skills || []).filter(s => s !== id);
      });
      closeModal();
      persistState("Skill removida.");
    }

    // MODAL DE TAREFA DO KANBAN (INSPECIONAR, EDITAR, APROVAR/REPROVAR)
    function openTaskModal(taskId = null) {
      const idx = state.tasks.findIndex(t => t.id === taskId);
      const t = idx >= 0 ? state.tasks[idx] : {
        id: "T-" + (101 + state.tasks.length),
        title: "",
        desc: "",
        column: "backlog",
        agent: "master_orchestrator",
        skills: ["clean_architecture"],
        complexity: "Média",
        feedback: ""
      };

      const agentOptions = Object.entries(state.agents).map(([aid, ag]) => `
        <option value="${aid}" ${t.agent === aid ? 'selected' : ''}>${ag.role} (${aid})</option>
      `).join('');

      const colOptions = COLUMNS.map(c => `
        <option value="${c.id}" ${t.column === c.id ? 'selected' : ''}>${c.title}</option>
      `).join('');

      const skillChecks = Object.entries(state.skills).map(([sid, s]) => `
        <label class="check-item">
          <input type="checkbox" name="task-skill" value="${sid}" ${(t.skills || []).includes(sid) ? 'checked' : ''}>
          <span>${s.name}</span>
        </label>
      `).join('');

      openModal(`
        <div class="modal-header">
          <h3>📋 ${idx >= 0 ? `Tarefa ${t.id}` : 'Nova Tarefa no Kanban'}</h3>
          <button class="btn" onclick="closeModal()">✕</button>
        </div>
        <div style="display:grid; grid-template-columns: 1fr 1fr; gap:12px;">
          <div class="form-field">
            <label>ID da Tarefa</label>
            <input type="text" id="m-task-id" value="${t.id}" ${idx >= 0 ? 'readonly' : ''}>
          </div>
          <div class="form-field">
            <label>Etapa Atual no Pipeline (Coluna)</label>
            <select id="m-task-col">${colOptions}</select>
          </div>
        </div>
        <div class="form-field">
          <label>Título da Tarefa</label>
          <input type="text" id="m-task-title" value="${t.title}">
        </div>
        <div class="form-field">
          <label>Especificação, Critérios de Aceitação e Escopo</label>
          <textarea id="m-task-desc" rows="3">${t.desc}</textarea>
        </div>
        <div style="display:grid; grid-template-columns: 2fr 1fr; gap:12px;">
          <div class="form-field">
            <label>Agente Responsável</label>
            <select id="m-task-agent" onchange="syncTaskAgentSkills(this.value)">${agentOptions}</select>
          </div>
          <div class="form-field">
            <label>Complexidade</label>
            <select id="m-task-comp">
              <option value="Baixa" ${t.complexity==='Baixa'?'selected':''}>Baixa</option>
              <option value="Média" ${t.complexity==='Média'?'selected':''}>Média</option>
              <option value="Alta" ${t.complexity==='Alta'?'selected':''}>Alta</option>
            </select>
          </div>
        </div>
        <div class="form-field">
          <label>Skills Ativadas para esta Tarefa:</label>
          <div class="checkbox-grid" id="m-task-skills-box">${skillChecks}</div>
        </div>
        <div class="form-field">
          <label>Feedback de Revisão Humana (Gate de Aprovação)</label>
          <input type="text" id="m-task-feedback" value="${t.feedback || ''}" placeholder="Opcional: motivo de reprovação ou ajuste fino">
        </div>
        <div style="display:flex; justify-content:space-between; margin-top:18px;">
          ${idx >= 0 ? `<button class="btn btn-rose" onclick="deleteTask('${t.id}')">Excluir Tarefa</button>` : '<span></span>'}
          <div style="display:flex; gap:8px;">
            ${idx >= 0 && t.column === 'review' ? `
              <button class="btn btn-emerald" onclick="approveTask('${t.id}'); closeModal();">✔ Aprovar Entrega</button>
              <button class="btn btn-rose" onclick="rejectTask('${t.id}'); closeModal();">✖ Reprovar</button>
            ` : ''}
            <button class="btn btn-primary" onclick="saveTaskModal(${idx})">💾 Salvar Tarefa</button>
          </div>
        </div>
      `);
    }

    function syncTaskAgentSkills(agentId) {
      const ag = state.agents[agentId];
      if (!ag) return;
      document.querySelectorAll("input[name='task-skill']").forEach(cb => {
        cb.checked = (ag.skills || []).includes(cb.value);
      });
    }

    function saveTaskModal(idx) {
      const taskObj = {
        id: document.getElementById("m-task-id").value.trim(),
        title: document.getElementById("m-task-title").value.trim(),
        desc: document.getElementById("m-task-desc").value.trim(),
        column: document.getElementById("m-task-col").value,
        agent: document.getElementById("m-task-agent").value,
        complexity: document.getElementById("m-task-comp").value,
        feedback: document.getElementById("m-task-feedback").value.trim(),
        skills: Array.from(document.querySelectorAll("input[name='task-skill']:checked")).map(i => i.value)
      };
      if (!taskObj.title) return alert("Informe o título da tarefa!");
      if (idx >= 0) state.tasks[idx] = taskObj;
      else state.tasks.push(taskObj);
      closeModal();
      persistState(`Tarefa ${taskObj.id} atualizada no Kanban!`);
    }

    function deleteTask(id) {
      state.tasks = state.tasks.filter(t => t.id !== id);
      closeModal();
      persistState(`Tarefa ${id} removida.`);
    }

    function approveTask(id) {
      const t = state.tasks.find(x => x.id === id);
      if (t) {
        t.column = "done";
        t.feedback = "Aprovado pelo Engenheiro Responsável.";
        persistState(`Tarefa ${id} APROVADA e movida para Concluído!`);
      }
    }

    function rejectTask(id) {
      const t = state.tasks.find(x => x.id === id);
      if (!t) return;
      const reason = prompt("Informe o motivo da reprovação / ajuste necessário para o agente:", t.feedback || "");
      if (reason !== null) {
        t.column = "red";
        t.feedback = reason || "Reprovado no Gate Humano — revisar testes e critérios.";
        persistState(`Tarefa ${id} REPROVADA — retornou para TDD RED com feedback!`);
      }
    }

    function toggleMcp(id) {
      state.mcps[id].active = !state.mcps[id].active;
      persistState(`Servidor MCP '${state.mcps[id].name}' ${state.mcps[id].active ? 'ATIVADO' : 'DESATIVADO'}!`);
    }

    // =========================================================================
    // MASTER ORCHESTRATOR — DECOMPOSIÇÃO INTELIGENTE E GERAÇÃO DE PROMPT
    // =========================================================================
    function orchestrateDemand() {
      const title = document.getElementById("orch-title").value.trim();
      const desc = document.getElementById("orch-desc").value.trim();
      const comp = document.getElementById("orch-complexity").value;
      if (!title || !desc) return alert("Preencha o título e a descrição da demanda!");

      const lower = (title + " " + desc).toLowerCase();
      const usedIds = new Set(state.tasks.map(t => t.id));
      let baseNum = 1;
      while (usedIds.has(`T${String(baseNum).padStart(2, "0")}`)) baseNum++;
      const nextId = (offset) => `T${String(baseNum + offset).padStart(2, "0")}`;
      const createdTasks = [];

      if (comp.startsWith("Alta")) {
        // Decompõe em 3 sub-tarefas coordenadas
        const t1 = {
          id: nextId(0),
          title: `[Spec & Contrato] ${title}`,
          desc: `Mapear contratos de domínio, impactos via Graft AST e definir critérios TDD para: ${desc}`,
          column: "backlog",
          agent: "master_orchestrator",
          skills: ["spec_discovery", "clean_architecture"],
          complexity: "Alta",
          feedback: ""
        };
        const dataOrUiAgent = (lower.includes("sql") || lower.includes("supabase") || lower.includes("banco") || lower.includes("offline") || lower.includes("busca"))
          ? "data_supabase_specialist"
          : "mobile_domain_builder";
        const t2 = {
          id: nextId(1),
          title: `[TDD & Domínio/Dados] ${title}`,
          desc: `Criar teste falho (Fase RED) e implementar serviço/repositório (Fase GREEN): ${desc}`,
          column: "red",
          agent: dataOrUiAgent,
          skills: state.agents[dataOrUiAgent].skills,
          complexity: "Alta",
          feedback: ""
        };
        const t3 = {
          id: nextId(2),
          title: `[UI/UX & Gate QA] ${title}`,
          desc: `Integrar na camada de apresentação respeitando os 4 estados de UI, Design Tokens e validar em loop fechado.`,
          column: "backlog",
          agent: "ui_ux_specialist",
          skills: ["mobile_ux_design_system", "stitch_visual_ingest", "tdd_red_green"],
          complexity: "Média",
          feedback: ""
        };
        state.tasks.push(t1, t2, t3);
        createdTasks.push(t1, t2, t3);
      } else {
        let bestAgent = "mobile_domain_builder";
        if (lower.includes("ui") || lower.includes("tela") || lower.includes("layout") || lower.includes("design") || lower.includes("stitch")) bestAgent = "ui_ux_specialist";
        else if (lower.includes("sql") || lower.includes("supabase") || lower.includes("query") || lower.includes("índice") || lower.includes("offline")) bestAgent = "data_supabase_specialist";
        else if (lower.includes("teste") || lower.includes("linter") || lower.includes("bug")) bestAgent = "qa_self_healer";

        const singleTask = {
          id: nextId(0),
          title,
          desc,
          column: "backlog",
          agent: bestAgent,
          skills: state.agents[bestAgent].skills,
          complexity: comp.split(" ")[0],
          feedback: ""
        };
        state.tasks.push(singleTask);
        createdTasks.push(singleTask);
      }

      const activeMcps = Object.entries(state.mcps).filter(([_, m]) => m.active).map(([id, m]) => `${id} (${m.command})`).join(", ");
      const promptText = `Atue como o master_orchestrator do Antigravity Harness v3.0 (Google Harness² Architecture).

1. CONTEXTO DO PROJETO & MCPS ATIVOS:
   - Leia .agents/PROJECT_BRAIN.md, .agents/harness.yaml e _specs/task-board.md.
   - Servidores MCP conectados neste ambiente: ${activeMcps}.

2. DEMANDA SOLICITADA:
   - Épico: "${title}"
   - Especificação: "${desc}"
   - Complexidade: ${comp}

3. TAREFAS CRIADAS E ESCALADAS NO KANBAN:
${createdTasks.map(ct => `   - [${ct.id}] ${ct.title}
     • Agente Escalado: ${ct.agent} (${state.agents[ct.agent].role})
     • Skills Ativadas: ${ct.skills.map(s => state.skills[s]?.file || s).join(", ")}`).join("\n")}

4. PIPELINE DE EXECUÇÃO OBRIGATÓRIO:
   - Passo A (Spec & AST): Use o Graft AST e Dart MCP para inspecionar impactos sem quebrar contratos existentes.
   - Passo B (Fase RED): Acione as diretrizes de tdd_red_green e crie os testes que comprovem a necessidade/falha.
   - Passo C (Fase GREEN): Implemente a solução mantendo regras de negócio estritamente na camada de Domain/Data.
   - Passo D (QA Loop & Gate Humano): Rode os testes e linters até zerar erros, mova os cards para a coluna '4. Gate de Aprovação' em _specs/task-board.md e aguarde minha aprovação no Kanban.`;

      document.getElementById("orch-output").value = promptText;
      persistState(`${createdTasks.length} tarefa(s) criada(s) e atribuída(s) no Kanban!`);
    }

    function copyOrchestratorPrompt() {
      const txt = document.getElementById("orch-output").value;
      if (!txt) return alert("Gere uma análise no Orquestrador primeiro!");
      navigator.clipboard.writeText(txt);
      showToast("📋 Prompt copiado para a área de transferência!");
    }

    function downloadHarnessBundle() {
      const blob = new Blob([generateHarnessYAML()], { type: "text/yaml" });
      const a = document.createElement("a");
      a.href = URL.createObjectURL(blob);
      a.download = "harness.yaml";
      a.click();
    }

    renderAll();
  </script>
</body>
</html>
EOF

# ------------------------------------------------------------------------------
# 8.2 _specs/task-board.md (5 colunas do ciclo Flutter)
# ------------------------------------------------------------------------------
cat << 'EOF' > _specs/task-board.md
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
EOF

# ------------------------------------------------------------------------------
# 9. .gitignore recomendado
# ------------------------------------------------------------------------------
if [ ! -f .gitignore ]; then
cat << 'EOF' > .gitignore
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
EOF
echo -e "${GREEN}✔ .gitignore padrão criado.${NC}"
fi

echo ""
# ------------------------------------------------------------------------------
# 10. Isolamento Git Nativo (Local-Only nos Projetos Consumidores)
# ------------------------------------------------------------------------------
IS_BASE_REPO=0
if [ -d ".git" ]; then
    REMOTE_URL=$(git config --get remote.origin.url 2>/dev/null || echo "")
    if [[ "$REMOTE_URL" == *"antigravity-harness"* ]]; then
        IS_BASE_REPO=1
    fi
fi

if [ -d ".git" ] && [ "$IS_BASE_REPO" -eq 0 ]; then
    echo -e "${CYAN}🔒 Blindando o Git do projeto consumidor contra envio do Harness ao GitHub...${NC}"
    if ! grep -q "Antigravity Harness (Local-Only" .gitignore 2>/dev/null; then
        cat << 'EOF' >> .gitignore

# === Antigravity Harness (Local-Only - Nao subir para o GitHub) ===
.agents/
.agents.bak-*/
_specs/
_references/
harness-studio.html
docs-harness.html
install.ps1
install.sh
install-harness.ps1
install-harness.sh
update.ps1
update.sh
populate-skills.ps1
populate-deep-skills.sh
COMANDOS.md
EOF
    fi

    if [ -f ".git/info/exclude" ]; then
        if ! grep -q "Antigravity Harness (Local-Only" .git/info/exclude 2>/dev/null; then
            cat << 'EOF' >> .git/info/exclude

# === Antigravity Harness (Local-Only - Nao subir para o GitHub) ===
.agents/
.agents.bak-*/
_specs/
_references/
harness-studio.html
docs-harness.html
install.ps1
install.sh
install-harness.ps1
install-harness.sh
update.ps1
update.sh
populate-skills.ps1
populate-deep-skills.sh
COMANDOS.md
EOF
        fi
    fi

    git rm -r --cached --ignore-unmatch \
      .agents _specs _references harness-studio.html docs-harness.html \
      install.ps1 install.sh install-harness.ps1 install-harness.sh \
      update.ps1 update.sh populate-skills.ps1 COMANDOS.md 2>/dev/null || true

    echo -e "${GREEN}✔ Git isolado com sucesso! Apenas o código do projeto subirá para o repositório remoto.${NC}"
fi

echo -e "${GREEN}=====================================================${NC}"
echo -e "${GREEN}  🎉 Harness configurado com sucesso!               ${NC}"
echo -e "${GREEN}=====================================================${NC}"
echo ""
echo -e "Próximos passos recomendados:"
echo -e " 1. Adicione prints/telas de inspiração em:  ${CYAN}_references/screens/${NC}"
echo -e " 2. Inicie a descoberta do produto:          ${CYAN}Copie _specs/prd-template.md para _specs/prd.md${NC}"
echo -e " 3. Modelos: herda o modelo logado por padrão (inherit). Opcional: ${CYAN}export AI_MODEL_REASONING='...' AI_MODEL_CODING='...'${NC}"
echo -e " 4. Studio visual v3.0: abra ${CYAN}harness-studio.html${NC}, clique em um card para editar e use 'Conectar Pasta do Projeto' para auto-save direto em .agents/ e _specs/."
echo ""