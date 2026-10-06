# ==============================================================================
# Antigravity Developer Harness - Instalador Nativo PowerShell (Windows)
# 100% Autocontido: Instala ferramentas (ai-memory, graft), regras, skills e workflows
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
version: "1.0"
name: "unified-developer-harness"
description: "Harness unificado multi-alvo com alocação dinâmica de modelos de IA, TDD, Stitch MCP, Graft e ai-memory."

# Nenhum modelo é fixado: escolha via variáveis de ambiente por tarefa.
# Ex: $env:MODEL_REASONING="seu-modelo-forte"; $env:MODEL_CODING="seu-modelo-rapido"
models:
  reasoning: "${MODEL_REASONING}"
  coding: "${MODEL_CODING}"
  multimodal_design: "${MODEL_DESIGN}"
  fast_ops: "${MODEL_OPS}"

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
    test_command: "cd apps/mobile && flutter test"
    lint_command: "cd apps/mobile && dart analyze"

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
    model: "${MODEL_REASONING}"
    role: "Entrevista o desenvolvedor, define requisitos de negócio e gera o PRD agnóstico em _specs/ com diagramas Archify."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/spec-discovery/SKILL.md"
    tools: ["file_read", "file_write", "ai_memory"]

  ui_ux_designer:
    model: "${MODEL_DESIGN}"
    role: "Inspeciona capturas em _references/screens/ usando Google Stitch MCP e gera os tokens de design em _specs/design-tokens.json."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/mobile-ux/SKILL.md"
    tools: ["google_stitch_mcp", "file_read", "file_write", "ai_memory"]

  tdd_tester:
    model: "${MODEL_CODING}"
    role: "Lê a spec da feature e cria testes unitários/widgets/componentes que obrigatoriamente falham antes do código."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/clean-architecture/SKILL.md"
    tools: ["file_read", "file_write", "bash", "graft", "ai_memory"]

  mobile_builder:
    model: "${MODEL_CODING}"
    role: "Escreve código Flutter estritamente tipado, modular e aderente à Clean Architecture para passar nos testes."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/mobile-ux/SKILL.md"
      - ".agents/skills/clean-architecture/SKILL.md"
    tools: ["file_read", "file_write", "graft", "ai_memory"]

  qa_validator:
    model: "${MODEL_CODING}"
    role: "Executa testes e linters do app mobile, orquestrando até 3 ciclos de autorreparo automático caso algo quebre."
    rules:
      - ".agents/rules/global.md"
    skills:
      - ".agents/skills/code-quality-tests/SKILL.md"
    tools: ["bash", "file_read", "file_write", "ai_memory"]

  git_committer:
    model: "${MODEL_OPS}"
    role: "Inspeciona o diff staged, extrai o contexto do ticket no ai-memory e cria o commit semântico atômico."
    rules:
      - ".agents/rules/global.md"
    tools: ["git", "ai_memory", "bash"]

  release_manager:
    model: "${MODEL_CODING}"
    role: "Executa o pipeline de release Flutter (gates, versionamento, build, entrega) e publica nas lojas com rollout controlado."
    rules:
      - ".agents/rules/global.md"
      - ".agents/rules/mobile.md"
    skills:
      - ".agents/skills/flutter-release/SKILL.md"
      - ".agents/skills/mobile-cicd/SKILL.md"
      - ".agents/skills/store-publishing/SKILL.md"
    tools: ["bash", "file_read", "file_write", "ai_memory"]

workflows:
  dev_cycle:
    file: ".agents/workflows/dev-cycle.yaml"
    description: "Ciclo ponta a ponta: Ingestão -> Design -> TDD Red -> Green -> Refactor -> Commit."
'@ | Set-Content -Path ".agents\harness.yaml" -Encoding UTF8

# ------------------------------------------------------------------------------
# 5. .agents/mcp.json
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
# 6. .agents/rules/ (global.md, mobile.md)
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

## 1. Arquitetura de Software e Separação de Camadas
Adotamos uma abordagem modular e desacoplada inspirada em **Clean Architecture**:

```
apps/mobile/lib/
├── core/                  # Serviços globais, tema, utilitários e clientes (HTTP/DB)
│   ├── database/          # SQLite / persistência local (migrations, helpers, DAOs)
│   ├── network/           # Clientes HTTP / APIs remotas
│   └── theme/             # Design Tokens, tipografia e estilos globais
├── features/              # Módulos funcionais isolados
│   └── [feature_name]/
│       ├── data/          # Models, DTOs, DataSources e Repositórios concretos
│       ├── domain/        # Entidades de negócio e Contratos de repositório (Interfaces)
│       └── presentation/  # Telas, Widgets atômicos e State Holders (Bloc/Notifier)
└── main.dart
```

### Regras de Dependência:
- A camada de **Apresentação (Presentation)** depende apenas do **Domínio (Domain)**. Nunca chame a camada de dados diretamente de dentro de um Widget.
- A camada de **Dados (Data)** implementa os contratos da camada de **Domínio**.
- O **Domínio (Domain)** é composto por Dart puro: livre de dependências do framework Flutter, widgets ou pacotes externos.

---

## 2. Gerenciamento de Estados de Tela (Regra dos 4 Estados)
Toda tela que consulta, carrega ou submete informações DEVE implementar explicitamente os quatro estados visuais da UI:
1. **Estado de Carregamento (`LoadingState`)**:
   - Usar *shimmer skeleton* ou indicador visual de progresso contextualizado.
   - Evitar bloquear a tela inteira se parte do conteúdo já estiver em cache.
2. **Estado de Conteúdo Vazio (`EmptyState`)**:
   - Mensagem amigável explicando por que não há itens na lista.
   - Ação visual clara e direta (*Call to Action*), com botão destacado.
3. **Estado de Falha/Erro (`ErrorState`)**:
   - Mensagem em Português claro, sem termos técnicos indecifráveis para o usuário final.
   - Botão obrigatório de *"Tentar Novamente"* para reexecutar a consulta.
4. **Estado de Sucesso/Dados (`SuccessState`)**:
   - Renderização limpa, com paginação sob demanda quando houver listas extensas.

---

## 3. Diretrizes de UI, Widgets e Performance
1. **Construtores `const`**: Sempre declare construtores `const` em Widgets sem estado mutável para evitar reconstruções desnecessárias.
2. **Tamanho Mínimo de Alvo de Toque (Touch Target)**:
   - Todo botão, ícone interativo ou elemento clicável deve ter uma área de toque de no mínimo 48x48 dp.
3. **Alinhamento com Tokens Visuais**:
   - Cores, raios de borda, espaçamentos e fontes devem ser consumidos centralmente a partir de `core/theme/` (gerado a partir de `_specs/design-tokens.json`).
   - É proibido usar cores "mágicas" (`Color(0xFF123456)`) soltas no corpo dos widgets.

---

## 4. Persistência de Dados e Testabilidade
1. **Migrações Incrementais e Versionadas**:
   - Nunca altere schemas existentes diretamente; utilize migrations sequenciais vinculadas à versão do banco.
2. **Operações em Lote**:
   - Mutações de múltiplos registros devem utilizar transações ou batches para evitar retenção de I/O em disco.
3. **Testabilidade em Memória**:
   - Testes unitários de repositórios e DAOs locais devem rodar em memória (ex.: `sqflite_common_ffi`), garantindo feedback em milissegundos sem depender de emulador físico.
'@ | Set-Content -Path ".agents\rules\mobile.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 7. .agents/skills/ (As 4 Skills Fundamentais)
# ------------------------------------------------------------------------------
@'
---
name: spec-discovery
description: Conduz a entrevista de produto inicial, define requisitos de negócio e gera o PRD estruturado em _specs/prd.md com diagramas conceituais Archify.
---

# Skill: Descoberta de Produto e PRD

Esta skill orienta o agente `product_architect` na formalização de escopo e estratégias técnicas antes do início do código.

## 1. Processo de Entrevista de Produto
O agente deve formular perguntas curtas e diretas ao desenvolvedor, cobrindo:
1. **Dor Central**: Qual gargalo o usuário enfrenta sem esse software?
2. **Plataformas do App**: O projeto atende Android, iOS ou ambos? Quais versões mínimas?
3. **Decisão de Persistência**: A solução precisa de banco 100% local (ex: SQLite), sincronização em nuvem ou API externa?
4. **Métrica de Sucesso (North Star Metric)**: O que valida comercialmente o produto no curto prazo?

## 2. Geração do PRD
- Copie o modelo de `_specs/prd-template.md` para `_specs/prd.md`.
- Preencha com linguagem objetiva em pt-BR.
- Registre o ticket inicial no `ai-memory` marcando os targets ativos.
'@ | Set-Content -Path ".agents\skills\spec-discovery\SKILL.md" -Encoding UTF8

@'
---
name: mobile-ux
description: Diretrizes de UX/UI mobile, extração de Design DNA com Google Stitch MCP a partir de prints e geração de tokens visuais.
---

# Skill: Mobile UX & Google Stitch Integration

Esta skill capacita o agente a atuar como designer e engenheiro de interface mobile.

## 1. Fluxo de Extração com Google Stitch MCP
Quando existirem capturas ou imagens em `_references/screens/`:
1. Inspecione as referências via tool `google_stitch_mcp` com a ação `extract_design_context`.
2. Salve os valores extraídos em `_specs/design-tokens.json` no formato padrão W3C (cores, raios de borda, espaçamentos e fontes).

## 2. Ergonomia Mobile e Regra dos 4 Estados
- **Touch Target**: Área clicável mínima de 48x48 dp.
- **Thumb Zone**: Ações críticas posicionadas no terço inferior da tela.
- **Os 4 Estados de Tela Obrigatórios**:
  - `LoadingState`: Shimmer skeletons contextuais.
  - `EmptyState`: Mensagem amigável com botão de ação direta.
  - `ErrorState`: Mensagem clara em pt-BR e botão de retentativa.
  - `SuccessState`: Renderização fluida e performática dos dados.
'@ | Set-Content -Path ".agents\skills\mobile-ux\SKILL.md" -Encoding UTF8

@'
---
name: clean-architecture
description: Práticas de Test-Driven Development (Red-Green-Refactor), desacoplamento de domínio e criação de suítes de teste de alta velocidade.
---

# Skill: Clean Architecture & Disciplina TDD

Esta skill dita o comportamento dos subagentes `tdd_tester`, `mobile_builder` e `qa_validator`.

## 1. Protocolo Red-Green-Refactor
1. **Fase Vermelha (RED)**:
   - Lê a spec da feature em `_specs/features/*.md`.
   - Cria testes unitários ou de widgets que cobrem os critérios de aceitação.
   - Executa a suíte e valida que ela **FALHOU** pelos motivos corretos.
2. **Fase Verde (GREEN)**:
   - Escreve apenas o código estritamente necessário para fazer os testes passarem.
3. **Fase de Refatoração (REFACTOR)**:
   - Limpeza de nomes, tipagem estrita e reexecução dos testes para garantir que tudo continua verde.

## 2. Isolamento de Domínio
- O domínio é composto por regras puras de negócio, livre de frameworks de UI ou dependências externas.
- Testes de banco de dados devem ser executados em memória para resposta instantânea.
'@ | Set-Content -Path ".agents\skills\clean-architecture\SKILL.md" -Encoding UTF8

# ------------------------------------------------------------------------------
# 8. .agents/workflows/dev-cycle.yaml (Pipeline Completo com TDD e Git)
# ------------------------------------------------------------------------------
@'
version: "1.0"
name: "dev-cycle"
description: "Pipeline completo orientado a Spec com TDD (Red-Green-Refactor), loop autônomo de autorreparo e Git committer semântico."

inputs:
  task_id:
    type: string
    description: "ID da tarefa em _specs/tasks/ (ex: T01). Se informado, a spec é derivada da tarefa e feature_spec torna-se opcional"
    required: false
    default: ""
  feature_spec:
    type: string
    description: "Caminho relativo da especificação da funcionalidade (ex: _specs/features/auth-login.md). Opcional quando task_id é informado"
    required: false
    default: ""
  target:
    type: string
    description: "Plataforma de destino do build: android | ios | both"
    default: "both"
  skip_design:
    type: boolean
    description: "Pular inspeção visual caso a tarefa seja puramente backend/lógica de negócio"
    default: false
  release:
    type: boolean
    description: "Executar a etapa de release ao final (gates, versionamento, build e entrega)"
    default: false

steps:
  - id: step_select_task
    name: "0. Seleção da Tarefa (ranking por dificuldade x urgência)"
    actions:
      - description: "Aborta se nem task_id nem feature_spec foram informados"
        command: >
          if [ -z "${inputs.task_id}" ] && [ -z "${inputs.feature_spec}" ]; then echo "ERRO: informe task_id (ex: T01, veja o ranking em _specs/task-board.md) ou feature_spec."; exit 1; fi
      - description: "Com task_id: valida existência em _specs/tasks/ com status todo e deriva a spec da tarefa"
        command: >
          if [ -n "${inputs.task_id}" ]; then f=$(grep -rl "^id: \"${inputs.task_id}\"$" _specs/tasks/ | head -n 1); if [ -z "$f" ]; then echo "ERRO: tarefa ${inputs.task_id} não encontrada em _specs/tasks/."; exit 1; fi; st=$(grep "^status:" "$f" | head -n 1); case "$st" in *todo*) ;; *) echo "ERRO: tarefa ${inputs.task_id} não está com status todo ($st)."; exit 1;; esac; fi
  - id: step_ingest_context
    name: "1. Ingestão de Contexto e Análise de Símbolos"
    agent: "product_architect"
    actions:
      - description: "Validar se a spec existe e possui critérios de aceitação objetivos"
        command: "test -f ${inputs.feature_spec}"
      - description: "Fail-fast: aborta se algum MODEL_* (REASONING/CODING/DESIGN/OPS) estiver vazio"
        command: >
          for v in MODEL_REASONING MODEL_CODING MODEL_DESIGN MODEL_OPS; do
            if [ -z "${!v}" ]; then echo "ERRO: $v não definida. Defina antes de executar (ex: $env:$v='<seu-modelo>') e rode novamente."; exit 1; fi;
          done
      - description: "Consultar grafo estático via Graft para mapear arquivos impactados"
        command: "graft scan --path apps/mobile"
      - description: "Inicializar ticket de execução no ai-memory"
        command: >
          ai-memory ticket create
          --title "Dev Cycle: ${inputs.feature_spec}"
          --tags "platform:${inputs.target},tdd,in_progress"

  - id: step_design_tokens
    name: "2. Verificação de Tokens e Referências Visuais"
    agent: "ui_ux_designer"
    condition: "${inputs.skip_design == false}"
    actions:
      - description: "Verificar referências em _references/screens/ via Google Stitch MCP"
        tool: "google_stitch_mcp"
        parameters:
          action: "extract_design_context"
          source_dir: "_references/screens/"
      - description: "Garantir consistência das cores e tipografia em _specs/design-tokens.json"
        tool: "file_read"
        path: "_specs/design-tokens.json"

  - id: step_tdd_red
    name: "3. TDD Fase Vermelha (RED) - Escrita de Testes Que Devem Falhar"
    agent: "tdd_tester"
    actions:
      - description: "Ler contratos e critérios de aceitação na spec"
        tool: "file_read"
        path: "${inputs.feature_spec}"
      - description: "Escrever testes unitários e de interface cobrindo os cenários"
        tool: "file_write"
      - description: "Executar testes e certificar que falham (Red)"
        command: "cd apps/mobile && flutter test || true"

  - id: step_tdd_green
    name: "4. TDD Fase Verde (GREEN) - Implementação de Código de Produção"
    agent: "mobile_builder"
    actions:
      - description: "Escrever código de produção estritamente necessário para satisfazer os testes"
        tool: "file_write"

  - id: step_repair_loop
    name: "5. Validação de Testes e Loop Fechado de Autorreparo"
    agent: "qa_validator"
    loop:
      max_iterations: 3
      until: "test_result.exit_code == 0 && lint_result.exit_code == 0"
      on_iteration:
        - name: "Executar Linter e Checagem de Tipos"
          command: "cd apps/mobile && dart analyze"
          catch_output: "lint_result"
        - name: "Executar Suíte de Testes"
          command: "cd apps/mobile && flutter test"
          catch_output: "test_result"

  - id: step_refactor
    name: "6. Refatoração de Código, Limpeza e Formatação"
    agent: "qa_validator"
    actions:
      - description: "Aplicar formatador de código oficial"
        command: "cd apps/mobile && dart format ."

  - id: step_git_commit
    name: "7. Versionamento Atômico e Fechamento no Git"
    agent: "git_committer"
    actions:
      - description: "Adicionar arquivos alterados à staging area"
        command: "git add apps/mobile _specs/"
      - description: "Executar commit semântico atômico"
        command: >
          git commit -m "feat(mobile): implement ${inputs.feature_spec} with TDD coverage"
          -m "- Verified against criteria in ${inputs.feature_spec}"
          -m "- Clean Architecture and full test suite passed"

  - id: step_release
    name: "8. Release (gates, versionamento, build, entrega)"
    agent: "release_manager"
    condition: "${inputs.release == true}"
    actions:
      - description: "Seguir flutter-release com mobile-cicd/store-publishing conforme platform"
        tool: "file_read"
        path: "_specs/prd.md"
'@ | Set-Content -Path ".agents\workflows\dev-cycle.yaml" -Encoding UTF8

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
Write-Host " 3. Escolha os modelos por tarefa: `$env:MODEL_REASONING='seu-modelo-forte'; `$env:MODEL_CODING='seu-modelo-rapido'" -ForegroundColor Cyan
Write-Host ""