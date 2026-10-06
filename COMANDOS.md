# 📟 Guia de Comandos — do zero ao projeto existente

> Cole os blocos na ordem. Windows = PowerShell · Linux/macOS/WSL = Bash.

## 1. Pré-requisitos (uma vez por máquina)

```powershell
# Windows — Node (p/ ai-memory), Flutter, Git
winget install OpenJS.NodeJS Google.Flutter Git.Git
flutter doctor
```

```bash
# Linux/macOS/WSL — Node, Flutter, Git
node -v; flutter doctor; git --version
```

## 2. Criar projeto novo

```powershell
# Windows — dentro da pasta vazia do projeto
irm https://raw.githubusercontent.com/MailsonSilva/antigravity-harness-base/main/install.ps1 | iex
```

```bash
# Linux/macOS/WSL — dentro da pasta vazia do projeto
curl -sSL https://raw.githubusercontent.com/MailsonSilva/antigravity-harness-base/main/install.sh | bash
```

## 3. Escolher os modelos (toda sessão nova — sem isso o pipeline aborta)

```powershell
# Windows
$env:MODEL_REASONING = "seu-modelo-forte"     # PRD, arquitetura
$env:MODEL_CODING = "seu-modelo-rapido"       # TDD, builders, QA
$env:MODEL_DESIGN = "seu-modelo-com-visao"    # Stitch, tokens
$env:MODEL_OPS = "seu-modelo-leve"            # git, comandos
```

```bash
# Linux/macOS/WSL
export MODEL_REASONING="seu-modelo-forte" MODEL_CODING="seu-modelo-rapido" \
       MODEL_DESIGN="seu-modelo-com-visao" MODEL_OPS="seu-modelo-leve"
```

## 4. Descoberta → PRD → tarefas → board

```bash
cp _specs/prd-template.md _specs/prd.md          # preencha o PRD
cp _specs/tasks/_template.md _specs/tasks/T01-minha-tarefa.md  # preencha id/dificuldade/urgência
cat _specs/task-board.md                          # veja o ranking (regenere ao editar tarefas)
```

## 5. Rodar o dev-cycle

```bash
# Ver o ranking e escolher a tarefa na hora (interativo)
# → dev-cycle sem task_id
# Ir direto numa tarefa (spec derivada, status vira done no fim)
# → dev-cycle com task_id: T01
# Com release ao final (gates + tag + build + lojas)
# → dev-cycle com task_id: T01, release: true, platform: both
```

## 6. Comandos Flutter do dia a dia (dentro de `apps/mobile`)

```bash
flutter pub get
flutter test                 # suíte (Fase RED/GREEN)
dart analyze                 # zero avisos (gate)
dart format .                # formatação
flutter test --coverage      # LCOV em coverage/lcov.info
```

## 7. Projeto já existente — atualizar o harness sem perder nada

```powershell
# Windows — na raiz do projeto
irm https://raw.githubusercontent.com/MailsonSilva/antigravity-harness-base/main/update.ps1 | iex
```

```bash
# Linux/macOS/WSL — na raiz do projeto
curl -sSL https://raw.githubusercontent.com/MailsonSilva/antigravity-harness-base/main/update.sh | bash
```

```bash
git status --short          # confira o que mudou
git diff .agents/harness.yaml   # revise antes de commitar
# Rollback (se algo falhar): apague .agents e renomeie .agents.bak-<data> de volta
```

## 8. Atalho mental

| Quero... | Comando |
|---|---|
| Projeto novo | `install.ps1` / `install.sh` |
| Definir modelos | `$env:` / `export MODEL_*` |
| Nova tarefa | copiar `_template.md` → `T<NN>-*.md` |
| Ver prioridades | ler `_specs/task-board.md` |
| Desenvolver | dev-cycle (+ `task_id`, `+release` se for publicar) |
| Testar/analisar | `flutter test` / `dart analyze` em `apps/mobile` |
| Atualizar harness existente | `update.ps1` / `update.sh` |
| Versionar | `git commit -m "feat(mobile): ..."` (Conventional Commits) |
