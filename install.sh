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
# 8.1 harness-studio.html (Kanban nativo com drag & drop e edição cirúrgica do task-board)
# ------------------------------------------------------------------------------
cat << 'EOF' > harness-studio.html
<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Antigravity Studio — Kanban & OS</title>
  <style>
    :root {
      --bg: #090d16; --surface: #111726; --elevated: #182238; --border: #232f48;
      --primary: #38bdf8; --text: #f1f5f9; --muted: #94a3b8; --green: #10b981;
      --red: #f43f5e; --amber: #f59e0b; --purple: #c084fc;
    }
    * { box-sizing: border-box; margin: 0; padding: 0; font-family: system-ui, -apple-system, sans-serif; }
    body { background: var(--bg); color: var(--text); display: flex; height: 100vh; overflow: hidden; }
    .sidebar { width: 280px; background: var(--surface); border-right: 1px solid var(--border); padding: 20px; display: flex; flex-direction: column; gap: 14px; flex-shrink: 0; }
    .main { flex: 1; display: flex; flex-direction: column; overflow: hidden; }
    .topbar { height: 60px; background: var(--surface); border-bottom: 1px solid var(--border); display: flex; align-items: center; justify-content: space-between; padding: 0 24px; }
    .viewport { flex: 1; overflow-y: auto; padding: 24px; }
    .kanban-grid { display: grid; grid-template-columns: repeat(5, minmax(280px, 1fr)); gap: 16px; min-height: 82vh; overflow-x: auto; padding-bottom: 20px; }
    .kanban-col { background: var(--surface); border: 1px solid var(--border); border-radius: 10px; padding: 14px; display: flex; flex-direction: column; transition: background 0.2s; }
    .kanban-col.drag-over { background: rgba(56, 189, 248, 0.05); border-color: var(--primary); }
    .card { background: var(--elevated); border: 1px solid var(--border); border-radius: 8px; padding: 14px; margin-bottom: 12px; cursor: grab; transition: all 0.15s; }
    .card:active { cursor: grabbing; }
    .card:hover { border-color: var(--primary); transform: translateY(-2px); }
    .badge { font-size: 0.7rem; padding: 2px 7px; border-radius: 4px; background: rgba(56,189,248,0.15); color: var(--primary); font-weight: 600; }
    .btn { padding: 8px 14px; border-radius: 6px; font-weight: 600; cursor: pointer; border: 1px solid var(--border); background: var(--elevated); color: var(--text); }
    .btn-primary { background: var(--primary); color: #04101e; border: none; font-weight: 700; }
    .btn-green { background: rgba(16,185,129,0.2); color: #34d399; border: 1px solid #10b981; }
    .btn-red { background: rgba(244,63,94,0.2); color: #fb7185; border: 1px solid #f43f5e; }
    
    .modal-backdrop { position: fixed; inset: 0; background: rgba(3,6,12,0.85); backdrop-filter: blur(4px); display: none; align-items: center; justify-content: center; z-index: 1000; padding: 20px; }
    .modal-backdrop.open { display: flex; }
    .modal { background: var(--surface); border: 1px solid var(--border); border-radius: 12px; width: 100%; max-width: 680px; max-height: 90vh; overflow-y: auto; padding: 24px; box-shadow: 0 20px 40px rgba(0,0,0,0.6); }
    .form-group { margin-bottom: 14px; }
    .form-group label { display: block; font-size: 0.78rem; color: var(--muted); margin-bottom: 6px; font-weight: 600; text-transform: uppercase; }
    .form-group input, .form-group textarea, .form-group select { width: 100%; background: #070a12; border: 1px solid var(--border); color: #fff; padding: 10px; border-radius: 6px; font-size: 0.9rem; }
  </style>
</head>
<body>

  <aside class="sidebar">
    <div style="display:flex; align-items:center; gap:10px; margin-bottom:10px;">
      <div style="width:34px; height:34px; background:linear-gradient(135deg,var(--primary),var(--purple)); border-radius:8px; display:flex; align-items:center; justify-content:center; font-weight:800; color:#000;">A²</div>
      <div>
        <h2 style="font-size:0.95rem;">Antigravity Studio</h2>
        <span style="font-size:0.72rem; color:var(--primary);">Kanban Nativo com Drag & Drop</span>
      </div>
    </div>

    <div style="font-size:0.8rem; color:var(--muted); line-height:1.4; background:rgba(255,255,255,0.03); padding:10px; border-radius:6px; border:1px solid var(--border);">
      💡 Você pode <strong>arrastar os cards</strong> entre as colunas ou clicar neles para inspecionar, aprovar e reprovar. Excluir um card remove apenas ele — as demais tarefas ficam exatamente onde estão.
    </div>

    <div style="margin-top:auto; display:flex; flex-direction:column; gap:8px;">
      <button type="button" class="btn btn-primary" id="btn-connect" onclick="connectDirectory()">📁 Conectar Pasta do Projeto</button>
      <button type="button" class="btn" onclick="manualReload()">🔄 Recarregar task-board.md</button>
      <span id="sync-status" style="font-size:0.75rem; color:var(--muted); text-align:center;">Verificando conexão...</span>
    </div>
  </aside>

  <main class="main">
    <header class="topbar">
      <h2>📋 Quadro de Engenharia</h2>
      <span style="font-size:0.8rem; color:var(--muted);" id="last-sync-time">Aguardando conexão...</span>
    </header>

    <div class="viewport">
      <div class="kanban-grid" id="kanban-board"></div>
    </div>
  </main>

  <!-- MODAL DE INSPEÇÃO -->
  <div class="modal-backdrop" id="task-modal" onclick="if(event.target===this) closeModal()">
    <div class="modal">
      <div style="display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:16px; border-bottom:1px solid var(--border); padding-bottom:12px;">
        <div>
          <span class="badge" id="m-task-id" style="font-size:0.8rem;">TASK</span>
          <h3 id="m-title-display" style="font-size:1.15rem; margin-top:6px; color:#fff;"></h3>
        </div>
        <button class="btn" onclick="closeModal()">✕</button>
      </div>

      <div class="form-group">
        <label>Status / Coluna</label>
        <select id="m-task-col">
          <option value="backlog">1. Backlog & Specs</option>
          <option value="red">2. Fase RED (TDD)</option>
          <option value="green">3. Fase GREEN (Código)</option>
          <option value="review">4. Gate de Aprovação</option>
          <option value="done">5. Concluído</option>
        </select>
      </div>

      <div style="display:grid; grid-template-columns:1fr 1fr; gap:12px;">
        <div class="form-group">
          <label>Agente Designado</label>
          <input type="text" id="m-task-agent">
        </div>
        <div class="form-group">
          <label>Skills Ativadas</label>
          <input type="text" id="m-task-skills">
        </div>
      </div>

      <div class="form-group">
        <label>Título da Tarefa</label>
        <input type="text" id="m-task-title">
      </div>

      <div class="form-group">
        <label>Especificação Técnica & Critérios</label>
        <textarea id="m-task-desc" rows="5"></textarea>
      </div>

      <div class="form-group" id="group-feedback">
        <label style="color:#fb7185;">⚠️ Feedback de Reprovação (Instrução para a IA corrigir)</label>
        <input type="text" id="m-task-feedback" placeholder="Informe o motivo da reprovação...">
      </div>

      <div style="display:flex; justify-content:space-between; align-items:center; margin-top:20px; padding-top:14px; border-top:1px solid var(--border);">
        <button type="button" class="btn btn-red" onclick="deleteCurrentTask()">Excluir</button>
        <div style="display:flex; gap:8px;">
          <button type="button" class="btn btn-red" onclick="rejectTaskAction()">✖ Reprovar (Vai para RED)</button>
          <button type="button" class="btn btn-green" onclick="approveTaskAction()">✔ Aprovar (Vai para Concluído)</button>
          <button type="button" class="btn btn-primary" onclick="saveTaskModal()">Salvar Alterações</button>
        </div>
      </div>
    </div>
  </div>

  <script>
    // =========================================================================
    // REGRAS DE PARSING DO task-board.md
    //
    // 1. A coluna de uma tarefa é definida SOMENTE pelo cabeçalho da seção
    //    ("## 1. ...", "## 2. ..."). Nada de procurar "red"/"backlog" no meio
    //    de títulos ou descrições (isso movia cards sem querer).
    // 2. O formato aceito é flexível: "- **[T01] ...**" e
    //    "- [ ] **[T01] ...**" (backlog) ou "- [x] **[T01] ...**" (concluído).
    // 3. Toda mutação é cirúrgica: excluir/mover/editar altera apenas o bloco
    //    da tarefa alvo e preserva o restante do arquivo byte a byte.
    // =========================================================================
    const COLUMNS = [
      { id: "backlog", title: "1. Backlog & Specs", color: "#94a3b8" },
      { id: "red", title: "2. Fase RED (TDD)", color: "#f43f5e" },
      { id: "green", title: "3. Fase GREEN (Código)", color: "#38bdf8" },
      { id: "review", title: "4. Gate de Aprovação", color: "#f59e0b" },
      { id: "done", title: "5. Concluído", color: "#10b981" }
    ];

    const COLUMN_BY_NUMBER = { "1": "backlog", "2": "red", "3": "green", "4": "review", "5": "done" };
    const COLUMN_KEYWORDS = [
      ["backlog", /backlog/i],
      ["red", /\bred\b/i],
      ["green", /\bgreen\b/i],
      ["review", /aprova|review|gate|\bqa\b/i],
      ["done", /conclu|done|finaliz/i]
    ];

    // - [ ] **[T-101] Título** | Agente: `x` | Dificuldade: `Alta` | Skills: `a, b`
    const TASK_LINE_RE = /^(\s*)-\s*(?:\[([ xX])\]\s*)?\*\*\[([^\]]+)\]\s*(.*?)\*\*(.*)$/;
    const EMPTY_RE = /^\s*(?:[-*]\s*)?\*{0,2}\(?(?:nenhuma|sem)\s+tarefa/i;

    let dirHandle = null;
    let tasks = [];
    let selectedTaskId = null;
    let syncTimer = null;

    const DB_NAME = "AntigravityStudioDB";
    function openDB() {
      return new Promise((resolve, reject) => {
        const req = indexedDB.open(DB_NAME, 1);
        req.onupgradeneeded = () => req.result.createObjectStore("handles");
        req.onsuccess = () => resolve(req.result);
        req.onerror = () => reject(req.error);
      });
    }

    async function saveHandle(handle) {
      const db = await openDB();
      const tx = db.transaction("handles", "readwrite");
      tx.objectStore("handles").put(handle, "project_dir");
    }

    async function getSavedHandle() {
      const db = await openDB();
      return new Promise(resolve => {
        const req = db.transaction("handles").objectStore("handles").get("project_dir");
        req.onsuccess = () => resolve(req.result);
        req.onerror = () => resolve(null);
      });
    }

    window.addEventListener("DOMContentLoaded", async () => {
      try {
        const saved = await getSavedHandle();
        if (saved) {
          const opts = { mode: "readwrite" };
          if ((await saved.queryPermission(opts)) === "granted" || (await saved.requestPermission(opts)) === "granted") {
            dirHandle = saved;
            onConnected();
            return;
          }
        }
      } catch (e) {
        console.warn("Auto-reconexão falhou:", e);
      }
      document.getElementById("sync-status").innerText = "Pasta não conectada";
    });

    async function connectDirectory() {
      try {
        dirHandle = await window.showDirectoryPicker({ mode: "readwrite" });
        await saveHandle(dirHandle);
        onConnected();
      } catch (e) {
        console.warn("Seleção cancelada:", e);
      }
    }

    function onConnected() {
      document.getElementById("btn-connect").innerText = `📁 ${dirHandle.name}`;
      document.getElementById("sync-status").innerText = `Conectado: ${dirHandle.name}`;
      loadFromTaskBoard();
      if (syncTimer) clearInterval(syncTimer);
      // Não recarrega enquanto o modal está aberto para não atropelar a edição.
      syncTimer = setInterval(() => { if (!selectedTaskId) loadFromTaskBoard(); }, 3500);
    }

    async function loadFromTaskBoard() {
      if (!dirHandle) return;
      try {
        const specs = await dirHandle.getDirectoryHandle("_specs");
        const fileHandle = await specs.getFileHandle("task-board.md");
        const file = await fileHandle.getFile();
        const text = await file.text();
        parseMarkdown(text);
        renderKanban();
        document.getElementById("last-sync-time").innerText = `Sincronizado: ${new Date().toLocaleTimeString()}`;
      } catch (e) {
        console.warn("Erro lendo task-board.md:", e);
      }
    }

    function columnFromHeading(heading) {
      const numbered = heading.trim().match(/^(\d+)\s*[.)\-:]?/);
      if (numbered && COLUMN_BY_NUMBER[numbered[1]]) return COLUMN_BY_NUMBER[numbered[1]];
      for (const [id, re] of COLUMN_KEYWORDS) {
        if (re.test(heading)) return id;
      }
      return null;
    }

    function columnTitle(id) {
      const col = COLUMNS.find(c => c.id === id);
      return col ? col.title : id;
    }

    function parseTaskMeta(text) {
      const agent = text.match(/Agente:\s*\*?\s*`([^`]*)`/i);
      const skills = text.match(/Skills:\s*\*?\s*`([^`]*)`/i);
      const difficulty = text.match(/(?:Dificuldade|Complexidade):\s*\*?\s*`?([^`|\n]+)`?/i);
      return {
        agent: agent ? agent[1].trim() : "master_orchestrator",
        skills: skills ? skills[1].trim() : "",
        difficulty: difficulty ? difficulty[1].trim() : "Média"
      };
    }

    // Varre o markdown e devolve linhas, seções (colunas) e blocos de tarefas.
    // Cada tarefa conhece lineIndex/endIndex para edição cirúrgica.
    function scanBoard(md) {
      const lines = md.split(/\r?\n/);
      const sections = [];
      const found = [];
      let section = null;
      let current = null;

      for (let i = 0; i < lines.length; i++) {
        const line = lines[i];

        const heading = line.match(/^#{1,6}\s+(.*)$/);
        if (heading) {
          const id = columnFromHeading(heading[1]);
          section = id ? { id, headingIndex: i } : null;
          if (section) sections.push(section);
          current = null;
          continue;
        }

        const taskMatch = line.match(TASK_LINE_RE);
        if (taskMatch && section) {
          current = {
            id: taskMatch[3].trim(),
            title: taskMatch[4].trim(),
            checkbox: taskMatch[2] || " ",
            column: section.id,
            lineIndex: i,
            endIndex: i + 1,
            desc: ""
          };
          found.push(current);
          continue;
        }

        if (current && /^\s+\S/.test(line)) {
          current.endIndex = i + 1;
          current.desc += line.replace(/^\s*-\s?/, "").trimEnd() + "\n";
          continue;
        }

        // Linha em branco ou texto no nível da coluna encerra o bloco.
        current = null;
      }

      found.forEach(t => {
        const block = lines.slice(t.lineIndex, t.endIndex).join("\n");
        Object.assign(t, parseTaskMeta(block));
        t.desc = t.desc.trim();
      });

      return { lines, sections, tasks: found };
    }

    function parseMarkdown(md) {
      const board = scanBoard(md);
      tasks = board.tasks.map(t => ({ ...t }));
      return board;
    }

    function buildTaskLine(task) {
      const checkbox = task.column === "done" ? "x" : " ";
      const meta = [
        `Agente: \`${task.agent || "master_orchestrator"}\``,
        `Dificuldade: \`${task.difficulty || "Média"}\``
      ];
      if (task.skills) meta.push(`Skills: \`${task.skills}\``);
      return `- [${checkbox}] **[${task.id}] ${task.title}** | ${meta.join(" | ")}`;
    }

    function buildTaskBlock(task) {
      const block = [buildTaskLine(task)];
      const desc = (task.desc || "").trim();
      if (desc) {
        desc.split(/\r?\n/).forEach(line => block.push(`  - ${line.trim()}`));
      }
      return block;
    }

    // Insere o bloco no fim da coluna de destino, removendo placeholders vazios.
    function insertBlock(lines, targetColId, block) {
      let board = scanBoard(lines.join("\n"));
      let section = board.sections.find(s => s.id === targetColId);

      if (!section) {
        while (lines.length && lines[lines.length - 1].trim() === "") lines.pop();
        lines.push("", `## ${columnTitle(targetColId)}`, ...block, "");
        return lines;
      }

      // Remove "(Nenhuma tarefa...)" da seção de destino.
      const nextSection = board.sections.find(s => s.headingIndex > section.headingIndex);
      const sectionEnd = nextSection ? nextSection.headingIndex : lines.length;
      for (let i = sectionEnd - 1; i > section.headingIndex; i--) {
        if (EMPTY_RE.test(lines[i])) lines.splice(i, 1);
      }

      board = scanBoard(lines.join("\n"));
      section = board.sections.find(s => s.id === targetColId);
      const sectionTasks = board.tasks.filter(t => t.column === targetColId);

      let insertAt;
      if (sectionTasks.length) {
        insertAt = sectionTasks[sectionTasks.length - 1].endIndex;
      } else {
        const next = board.sections.find(s => s.headingIndex > section.headingIndex);
        insertAt = next ? next.headingIndex : lines.length;
        while (insertAt > section.headingIndex + 1 && lines[insertAt - 1].trim() === "") insertAt--;
      }

      lines.splice(insertAt, 0, ...block);
      return lines;
    }

    function removeTaskFromBoard(md, id) {
      const board = scanBoard(md);
      const task = board.tasks.find(t => t.id === id);
      if (!task) return md;

      const lines = board.lines.slice();
      lines.splice(task.lineIndex, task.endIndex - task.lineIndex);

      // Evita deixar duas linhas em branco seguidas no ponto da remoção.
      if (lines[task.lineIndex - 1] !== undefined && lines[task.lineIndex - 1].trim() === "" &&
          lines[task.lineIndex] !== undefined && lines[task.lineIndex].trim() === "") {
        lines.splice(task.lineIndex, 1);
      }
      return lines.join("\n");
    }

    function saveTaskInBoard(md, task) {
      const board = scanBoard(md);
      const existing = board.tasks.find(t => t.id === task.id);
      const lines = board.lines.slice();
      const block = buildTaskBlock(task);

      if (existing && existing.column === task.column) {
        // Edição no lugar: preserva a posição da tarefa na coluna.
        lines.splice(existing.lineIndex, existing.endIndex - existing.lineIndex, ...block);
        return lines.join("\n");
      }

      if (existing) {
        lines.splice(existing.lineIndex, existing.endIndex - existing.lineIndex);
      }
      return insertBlock(lines, task.column, block).join("\n");
    }

    function escapeHtml(value) {
      return String(value == null ? "" : value).replace(/[&<>"']/g, ch => ({
        "&": "&amp;", "<": "&lt;", ">": "&gt;", '"': "&quot;", "'": "&#39;"
      }[ch]));
    }

    function renderKanban() {
      const container = document.getElementById("kanban-board");
      container.innerHTML = COLUMNS.map(col => {
        const colTasks = tasks.filter(t => t.column === col.id);
        return `
          <div class="kanban-col" ondragover="allowDrop(event)" ondragleave="leaveDrop(event)" ondrop="drop(event, '${col.id}')">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
              <span style="font-weight:700; font-size:0.85rem; color:${col.color};">● ${col.title}</span>
              <span class="badge">${colTasks.length}</span>
            </div>
            <div style="flex:1;">
              ${colTasks.map(t => `
                <div class="card" draggable="true" ondragstart="drag(event, '${escapeHtml(t.id)}')" onclick="openTaskModal('${escapeHtml(t.id)}')">
                  <div style="display:flex; justify-content:space-between; align-items:center;">
                    <span class="badge" style="background:#070a12;">${escapeHtml(t.id)}</span>
                    <span style="font-size:0.7rem; color:var(--muted);">${escapeHtml(t.difficulty)}</span>
                  </div>
                  <div style="font-size:0.92rem; font-weight:600; margin:8px 0 6px; color:#fff;">${escapeHtml(t.title)}</div>
                  <div style="display:flex; gap:6px; flex-wrap:wrap; margin-top:8px;">
                    <span class="badge" style="background:rgba(192,132,252,0.15); color:var(--purple);">🤖 ${escapeHtml(t.agent)}</span>
                    ${t.skills ? `<span class="badge">⚡ ${escapeHtml(t.skills)}</span>` : ""}
                  </div>
                </div>
              `).join("")}
              ${colTasks.length === 0 ? `<div style="font-size:0.75rem; color:var(--muted); text-align:center; padding:30px 10px;">Arraste cards para cá</div>` : ""}
            </div>
          </div>
        `;
      }).join("");
    }

    // DRAG AND DROP HANDLERS
    function allowDrop(ev) { ev.preventDefault(); ev.currentTarget.classList.add("drag-over"); }
    function leaveDrop(ev) { ev.currentTarget.classList.remove("drag-over"); }
    function drag(ev, id) { ev.dataTransfer.setData("text/plain", id); }
    async function drop(ev, targetColId) {
      ev.preventDefault();
      ev.currentTarget.classList.remove("drag-over");
      const taskId = ev.dataTransfer.getData("text/plain");
      await mutateBoard(md => {
        // Usa o estado mais recente do arquivo, não o cache da tela.
        const fresh = scanBoard(md).tasks.find(t => t.id === taskId);
        if (!fresh || fresh.column === targetColId) return md;
        return saveTaskInBoard(md, { ...fresh, column: targetColId });
      });
    }

    function openTaskModal(id) {
      selectedTaskId = id;
      const t = tasks.find(x => x.id === id);
      if (!t) return;

      document.getElementById("m-task-id").innerText = t.id;
      document.getElementById("m-title-display").innerText = t.title;
      document.getElementById("m-task-col").value = t.column;
      document.getElementById("m-task-agent").value = t.agent;
      document.getElementById("m-task-skills").value = t.skills;
      document.getElementById("m-task-title").value = t.title;
      document.getElementById("m-task-desc").value = t.desc;
      document.getElementById("m-task-feedback").value = "";

      document.getElementById("task-modal").classList.add("open");
    }

    function closeModal() {
      document.getElementById("task-modal").classList.remove("open");
      selectedTaskId = null;
    }

    // Lê o arquivo atual, aplica UMA mutação cirúrgica e grava.
    // Isso garante que tarefas não envolvidas na ação não mudem de coluna.
    async function mutateBoard(mutator) {
      if (!dirHandle) {
        alert("Conecte a pasta do projeto antes de alterar o quadro.");
        return;
      }
      try {
        const specs = await dirHandle.getDirectoryHandle("_specs");
        const fileHandle = await specs.getFileHandle("task-board.md", { create: true });
        const file = await fileHandle.getFile();
        const current = await file.text();
        const next = mutator(current);

        if (next !== current) {
          const writable = await fileHandle.createWritable();
          await writable.write(next);
          await writable.close();
        }
        await loadFromTaskBoard();
      } catch (e) {
        console.error("Erro ao gravar task-board.md:", e);
        alert("Não foi possível gravar o task-board.md. Verifique a conexão da pasta.");
      }
    }

    async function saveTaskModal() {
      const t = tasks.find(x => x.id === selectedTaskId);
      if (!t) return;

      const updated = {
        ...t,
        column: document.getElementById("m-task-col").value,
        agent: document.getElementById("m-task-agent").value.trim(),
        skills: document.getElementById("m-task-skills").value.trim(),
        title: document.getElementById("m-task-title").value.trim(),
        desc: document.getElementById("m-task-desc").value.trim()
      };
      if (!updated.title) return alert("Informe o título da tarefa.");

      closeModal();
      await mutateBoard(md => saveTaskInBoard(md, updated));
    }

    async function approveTaskAction() {
      const t = tasks.find(x => x.id === selectedTaskId);
      if (!t) return;
      const updated = {
        ...t,
        column: "done",
        desc: (t.desc ? t.desc + "\n" : "") + "✔ Aprovado pelo Engenheiro no Gate Humano."
      };
      closeModal();
      await mutateBoard(md => saveTaskInBoard(md, updated));
    }

    async function rejectTaskAction() {
      const fb = document.getElementById("m-task-feedback").value.trim();
      if (!fb) return alert("Informe o motivo da reprovação para orientar a IA no ajuste.");
      const t = tasks.find(x => x.id === selectedTaskId);
      if (!t) return;
      const updated = {
        ...t,
        column: "red",
        desc: (t.desc ? t.desc + "\n" : "") + `⚠️ Reprovado no Gate: ${fb}`
      };
      closeModal();
      await mutateBoard(md => saveTaskInBoard(md, updated));
    }

    async function deleteCurrentTask() {
      const id = selectedTaskId;
      if (!id) return;
      if (!confirm(`Deseja realmente remover a tarefa ${id} do quadro?\n\nAs demais tarefas permanecerão exatamente nas colunas atuais.`)) return;
      closeModal();
      await mutateBoard(md => removeTaskFromBoard(md, id));
    }

    function manualReload() { loadFromTaskBoard(); }
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