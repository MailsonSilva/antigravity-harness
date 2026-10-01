# 🚀 Antigravity Developer Harness Base

Harness unificado e modular para desenvolvimento autónomo de software com suporte multi-alvo (**Mobile**, **Web** e **Landing Pages**). 

Projetado para orquestrar subagentes especializados através de ciclos estritos de **TDD (Red-Green-Refactor)**, prototipagem visual orientada por referências (**Google Stitch MCP**), navegação precisa por AST (**Graft**) e persistência contextual entre agentes (**ai-memory**).

---

## 🎯 Arquitetura de Alvos (Multi-Target)

O harness centraliza as regras de negócio e a identidade de produto, ativando módulos sob procura definidos em `_specs/prd-template.md`:

* **`apps/mobile`**: Aplicações móveis em Flutter com Clean Architecture, tratamento dos 4 estados de ecrã (*loading, empty, error, success*) e suporte a bases de dados locais/remotas (SQLite, Supabase, etc.).
* **`apps/web`**: Painéis e aplicações Next.js/React com foco em React Server Components e tipagem estrita.
* **`apps/landing`**: Páginas de alta conversão otimizadas para Core Web Vitals, SEO semântico e acessibilidade.

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
│   │   ├── mobile.md                # Normas de arquitetura Flutter e padrões de UI
│   │   └── web.md                   # Normas para Next.js, RSC e Core Web Vitals
│   ├── skills/                      # Competências modulares padronizadas
│   │   ├── clean-architecture/      # SKILL.md (Fase Red-Green e testes isolados)
│   │   ├── mobile-ux/               # SKILL.md (Ergonomia móvel e ligação Stitch)
│   │   ├── spec-discovery/          # SKILL.md (Entrevista e definição de PRD)
│   │   └── web-performance/         # SKILL.md (Boas práticas e otimização web)
│   └── workflows/
│       └── dev-cycle.yaml           # Ciclo fechado: Spec ➔ Red ➔ Green ➔ QA ➔ Git
├── instalador_powershell_windows.ps1 # Script de instalação para Windows
└── instalador_shell_linux_macos_wsl.sh # Script de instalação para ambientes Unix/WSL

⚡ Instalação Rápida em Qualquer Computador
Para configurar um novo projeto a partir de uma pasta limpa, execute o comando correspondente ao seu sistema operativo no terminal:

Windows (PowerShell)
PowerShell
irm [https://raw.githubusercontent.com/SEU_USUARIO/antigravity-harness-base/main/instalador_powershell_windows.ps1](https://raw.githubusercontent.com/SEU_USUARIO/antigravity-harness-base/main/instalador_powershell_windows.ps1) | iex
Linux / macOS / WSL
Bash
curl -sSL [https://raw.githubusercontent.com/SEU_USUARIO/antigravity-harness-base/main/instalador_shell_linux_macos_wsl.sh](https://raw.githubusercontent.com/SEU_USUARIO/antigravity-harness-base/main/instalador_shell_linux_macos_wsl.sh) | bash

🔄 Fluxo de Desenvolvimento (Pipeline dev-cycle)
O desenvolvimento opera através de transições estruturadas entre subagentes especializados:

Plaintext
[Descoberta / PRD] ──► [Design & Stitch] ──► [Fase RED (TDD)]
                                                   │
[Git Commit] ◄── [Auditoria / QA] ◄── [Fase GREEN (Código)]
Descoberta (product_architect): Conduz a análise dos requisitos e preenche _specs/prd-template.md.

Design Visual (ui_ux_designer): Inspeciona _references/screens/, interage com o Google Stitch MCP e gera os tokens visuais.

Fase Vermelha (tdd_tester): Cria a bateria de testes unitários ou de widgets que inicialmente falham.

Fase Verde (mobile_builder / web_builder): Implementa o código mínimo necessário com auxílio do Graft para satisfazer os testes.

Auditoria e Autorreparo (qa-validator): Executa validações estáticas e testes; em caso de falha, aciona o ciclo de correção automática (limite de 3 tentativas).

Registo Semântico (git_committer): Valida as alterações pendentes no Git e cria commits atómicos no formato Conventional Commits baseando-se no contexto registado pelo ai-memory.

🛠️ Ferramentas e Protocolos Integrados
Google Stitch MCP: Prototipagem e extração de padrões visuais a partir de imagens.

Graft: Navegação eficiente na árvore sintática abstrata (AST) sem dispersão de contexto.

ai-memory: Gestão de transferências formais (handoffs) entre subagentes e retenção de decisões técnicas.
