# ⚡ Antigravity Harness

Harness de engenharia de software para o **Google Antigravity**, otimizado para a **hierarquia Gemini 4** com separação estrita de contextos entre **Flutter (Mobile)** e **Web & Landing Pages**.

---

## 🧠 Hierarquia Gemini 4

O harness divide o ciclo de desenvolvimento em três camadas para maximizar qualidade e velocidade sem poluir a janela de contexto:

| Camada | Modelo Sugerido | Papel Principal | Workflow / Ação |
|---|---|---|---|
| **Arquitetura** | **Gemini 4 Carbon** | Raciocínio profundo, modelagem de dados e contratos técnicos | Executa `core/workflows/plan.md` gerando a `_specs/SPEC.md` fechada |
| **Orquestração** | **Gemini 4 Argon** | Coordenação, decomposição de tarefas e resolução de conflitos | Executa `core/workflows/orchestrate.md` disparando subagentes |
| **Execução** | **Gemini 4 Hydrogen** | Workers de baixa latência em workspaces isolados (`branch`/`share`) | Implementação atômica paralela de components, repositórios e testes |

---

## 🚀 Instalação Rápida em Qualquer Projeto

Execute o comando a partir da pasta raiz do seu projeto de destino:

### 1. Projeto Flutter (Mobile / SQLite Offline-First)
Instala ou atualiza diretrizes, workflows, `harness-studio.html` e skills mobile (preservando `_specs/` e skills customizadas):

- **Windows (PowerShell)**:
  ```powershell
  # Em um projeto existente:
  & "caminho\para\antigravity-harness\setup.ps1" -Profile flutter
  # Para criar um app Flutter novo + estrutura Clean Architecture + MCPs opcionais:
  & "caminho\para\antigravity-harness\setup.ps1" -Profile flutter -InitApp -Org com.suaempresa -WithOptionalMcps
  ```
- **Linux / macOS**:
  ```bash
  # Em um projeto existente:
  /caminho/para/antigravity-harness/init.sh flutter
  # Para criar um app Flutter novo + pastas + MCPs opcionais:
  /caminho/para/antigravity-harness/init.sh flutter . --init-app --org com.suaempresa --with-optional-mcps
  ```

> **Auto-evolução:** Cada projeto instalado também recebe `.agents/PROJECT_BRAIN.md` (memória curada local) e `.agents/HARNESS_FEEDBACK.md` (onde os agentes registram sugestões de melhoria para promover depois ao `antigravity-harness`).

### 2. Projeto Web / Landing Pages (Next.js / Tailwind / SEO)
Instala apenas diretrizes, workflows e skills web:

- **Windows (PowerShell)**:
  ```powershell
  # A partir da pasta do seu site/landing:
  & "caminho\para\antigravity-harness\setup.ps1" -Profile web
  ```
- **Linux / macOS**:
  ```bash
  # A partir da pasta do seu site/landing:
  /caminho/para/antigravity-harness/init.sh web
  ```

---

## 📂 Estrutura Modular do Repositório

```text
antigravity-harness/
├── core/                                # Núcleo compartilhado independente de stack
│   ├── GEMINI.base.md                   # Protocolo base pt-BR, subagentes e verification gate
│   ├── skills/                          # antigravity-skill-orchestrator, spec-discovery, skill-creator, harness-evolver
│   ├── templates/                       # board.json, PROJECT_BRAIN.md, HARNESS_FEEDBACK.md
│   └── workflows/
│       ├── plan.md                      # Workflow Carbon: Geração da SPEC.md
│       └── orchestrate.md               # Workflow Argon: Despacho paralelo Hydrogen (RED -> GREEN)
├── profiles/
│   ├── flutter/                         # Perfil Mobile & SaaS Offline-First
│   │   ├── profile.yaml                 # Manifesto de aliases e MCPs (default/optional)
│   │   ├── GEMINI.flutter.md            # Clean Architecture, 4 estados, SQLite e gates
│   │   └── skills/                      # 18 skills Dart/Flutter (arquitetura, Riverpod, TDD, Patrol, etc.)
│   └── web-sites/                       # Perfil Web & Landing Pages
│       ├── profile.yaml                 # Manifesto do perfil Web
│       ├── GEMINI.web.md                # Next.js App Router, Tailwind, Core Web Vitals e SEO
│       └── skills/                      # web-performance-seo, web-landing-conversion, web-responsive-ui
├── harness-studio.html                  # Kanban visual (_specs/board.json) + leitor de SPEC.md
├── COMANDOS.md                          # Guia operacional do dia a dia (início/fim de sessão e prompts)
├── setup.ps1                            # Instalador/atualizador unificado para Windows
├── init.sh                              # Instalador/atualizador unificado para Unix/macOS
└── README.md
```

> 📘 **Guia prático do dia a dia:** consulte [COMANDOS.md](COMANDOS.md) (também copiado para `.agents/COMANDOS.md` em todo projeto instalado) para ver prompts prontos de início de sessão, ciclo SDD/TDD e encerramento/handoff.

---

## 🔄 Fluxo de Desenvolvimento no Antigravity

1. **Fase 1: Especificação (Carbon)**
   - Selecione o modelo **Carbon**.
   - Solicite: *"Execute o workflow plan.md para a funcionalidade [Nome]"*.
   - O Carbon cria `_specs/SPEC.md` com contratos, checklist e tarefas atômicas sem tocar no código de produção.

2. **Fase 2: Orquestração e Paralelismo (Argon + Hydrogen)**
   - Mude para o modelo **Argon**.
   - Solicite: *"Execute o workflow orchestrate.md para a SPEC.md aprovada"*.
   - O Argon quebra a spec em ondas de dependência e despacha subagentes **Hydrogen** em paralelo via `invoke_subagent`.

3. **Fase 3: Loop Obrigatório de Verificação (Verification Gate)**
   - **Flutter**: O Argon executa obrigatoriamente `dart format .`, `flutter analyze` e `flutter test`.
   - **Web**: O Argon executa obrigatoriamente `npm run lint` e `npm run build`.
   - Tarefas só são concluídas com código de saída 0 em todas as validações.
