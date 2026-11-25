# 📘 Guia Operacional — Antigravity Harness v4

Referência rápida para uso no dia a dia: comandos de terminal, prompts de início/fim de sessão, fluxo SDD/TDD em ondas, Kanban Studio e promoção de melhorias.

---

## 1. Comandos de Terminal (Setup, Novo App & Atualização)

### Criar um app Flutter novo do zero (`-InitApp`)
Cria o projeto via `flutter create`, gera a árvore Clean Architecture (`lib/core/*`, `lib/features/`, `test/`, `integration_test/`, `_references/`) e instala `GEMINI.md`, `.agents/`, `_specs/board.json` e `harness-studio.html`:

- **Windows (PowerShell):**
  ```powershell
  & "C:\caminho\para\antigravity-harness\setup.ps1" -Profile flutter -InitApp -Org com.suaempresa -TargetDir "C:\caminho\do\novo_app"
  ```
- **Linux / macOS / WSL:**
  ```bash
  /caminho/para/antigravity-harness/init.sh flutter /caminho/do/novo_app --init-app --org com.suaempresa
  ```

### Instalar ou atualizar em um projeto existente
Preserva `_specs/`, `.agents/PROJECT_BRAIN.md`, `.agents/HARNESS_FEEDBACK.md` e skills customizadas; atualiza apenas arquivos gerenciados (com backup em `%TEMP%`/`/tmp`):

```powershell
# Windows (a partir da raiz do projeto)
& "C:\caminho\para\antigravity-harness\setup.ps1" -Profile flutter
```
```bash
# Linux / macOS
/caminho/para/antigravity-harness/init.sh flutter .
```

### Quality Gate Unificado (`verify.ps1` / `verify.sh`)
Todo projeto instalado recebe `.agents/scripts/verify.ps1` (Windows) e `.agents/scripts/verify.sh` (Linux/macOS/CI), executando `dart analyze` e `flutter test -j 1`:
```powershell
# Windows
.\.agents\scripts\verify.ps1
```
```bash
# Linux / macOS / GitHub Actions
./.agents/scripts/verify.sh
```

### Flags úteis
- **Ativar MCPs opcionais** (`supabase_mcp`, `google_stitch`, `patrol_mcp`, `graft_ast`, `ai_memory`):
  - PowerShell: `-WithOptionalMcps` | Bash: `--with-optional-mcps`
- **Monorepo (subpasta do app Flutter):**
  - PowerShell: `-AppDir apps/mobile` | Bash: `--app-dir apps/mobile`
- **Perfil Web / Landing Pages:**
  - PowerShell: `-Profile web` | Bash: `./init.sh web .`

---

## 2. Como Iniciar uma Sessão de Trabalho (Boot de Contexto)

Copie e cole no chat ao abrir o projeto no dia seguinte para retomar exatamente de onde parou, sem desperdiçar janela de contexto:

```text
/antigravity-skill-orchestrator Leia .agents/PROJECT_BRAIN.md, _specs/board.json e _specs/SPEC.md (se existir). Me dê um resumo curto do estado atual, invariantes ativas e qual o próximo passo recomendado antes de editar qualquer arquivo.
```

---

## 3. Prompts do Ciclo Diário (SDD + TDD em Ondas)

### Passo 1 — Descoberta & Micro-Spec (Modelo Carbon)
Para toda nova funcionalidade ou refatoração média/grande:
```text
Execute .agents/workflows/plan.md usando spec-discovery para a funcionalidade: [Descreva a feature]. Faça as perguntas cirúrgicas necessárias antes de gerar _specs/SPEC.md.
```
*Após revisar e aprovar `_specs/SPEC.md`, avance para o Passo 2.*

### Passo 2 — Execução TDD em Ondas (Modelo Argon + Workers Hydrogen)
Roda na ordem: **Onda 1 (Contratos) → Onda 2 (Fase RED)** → **Onda 3 (Fase GREEN)** → **Onda 4 (Refactor & Verification Gate)**, sincronizando `_specs/board.json`:
```text
Execute .agents/workflows/orchestrate.md para _specs/SPEC.md aprovada. Respeite os Guardrails Negativos e atualize _specs/board.json a cada onda.
```

### Passo 3 — Tarefas Rápidas, Bugfixes ou Refatorações Pontuais
Para correções ou ajustes menores que não exigem `SPEC.md` completa:
```text
/antigravity-skill-orchestrator Preciso [corrigir bug X / criar widget Y / ajustar query Z]. Faça a triagem e delegue apenas com as skills necessárias, validando com flutter test e dart analyze no final.
```

### Passo 4 — Auditoria de Arquitetura (`egm-*`)
Quando quiser uma revisão crítica profunda do projeto ou de um plano:
- **Mapear realidade vs. docs:** *"Rode `egm-codebase-details` para confrontar a documentação com o código real."*
- **Simplificar / cortar excessos:** *"Rode `egm-zoom-out` e `egm-design` em paralelo para revisar nossa arquitetura."*
- **Validar plano antes de codar:** *"Rode `egm-implementation-readiness` na `_specs/SPEC.md`."*

---

## 4. Usando o `harness-studio.html` (Kanban & Visualizador de SPEC)

1. Abra `harness-studio.html` no **Chrome** ou **Edge**.
2. Clique em **📁 Conectar Pasta do Projeto** e selecione a raiz do seu app.
3. Acompanhe os cards em `_specs/board.json` (`Backlog`, `Fase RED`, `Fase GREEN`, `Gate de Aprovação`, `Concluído`).
4. Clique em um card em **Gate de Aprovação** para **Aprovar** ou **Reprovar** (com feedback direto para a IA voltar à fase `RED`).
5. Use a aba **📄 SPEC.md (Leitura)** na barra superior para consultar a especificação atual durante a revisão.

> O Studio usa trava otimista (`lastModified`) para nunca sobrescrever alterações feitas por subagentes no disco.

---

## 5. Como Encerrar uma Sessão de Trabalho (Handoff & Auto-Evolução)

Ao finalizar o expediente ou concluir uma entrega, use este prompt para preservar o estado para a próxima sessão:

```text
Vamos encerrar a sessão:
1. Atualize o bloco "Último Handoff & Decisões Recentes" em .agents/PROJECT_BRAIN.md (substituindo itens antigos, mantendo o arquivo enxuto).
2. Confirme que _specs/board.json e o checklist de _specs/SPEC.md refletem o estado real dos testes.
3. Se houve retrabalho ou lacuna em alguma skill/workflow hoje, registre uma sugestão (Status: pendente) em .agents/HARNESS_FEEDBACK.md.
4. Rode flutter analyze e flutter test para garantir tudo verde e faça um commit semântico em pt-BR.
```

---

## 6. Como Promover Melhorias de Volta para o `antigravity-harness`

Quando abrir o repositório `antigravity-harness` para evoluir o próprio harness, aponte o arquivo de feedback do app onde você trabalhou:

```text
Leia C:\caminho\do\meu_app\.agents\HARNESS_FEEDBACK.md, analise as entradas pendentes e proponha as melhorias aplicáveis nas skills/workflows oficiais do antigravity-harness.
```
