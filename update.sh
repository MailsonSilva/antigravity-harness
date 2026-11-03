#!/usr/bin/env bash
# ==============================================================================
# Antigravity Flutter Harness - Atualizador Universal (Linux / macOS / WSL / Git Bash)
# Sincroniza o harness com o upstream preservando dados locais.
#
# Uso:  ./update.sh [diretorio]     (env: REPO=owner/repo, BRANCH=main)
#
# PRESERVADO (nunca sobrescrito):
#   .agents/PROJECT_BRAIN.md     .agents/skills/** (skills existentes)
#   .agents/memory/**            apps/  _references/
#   _specs/prd.md  _specs/features/  _specs/tasks/T*.md  README.md  .git/
#
# ATUALIZADO (backup previo em diretorio temporario):
#   .agents/harness.yaml  .agents/mcp.json  .agents/rules/**  .agents/workflows/**
#   harness-studio.html  _specs/prd-template.md  _specs/tasks/_template.md
#   install.ps1  install.sh  update.ps1  update.sh
#
# CORRECAO DEFINITIVA (Exit 126 / "Is a directory"):
#   Diretorios NUNCA sao executados nem passados como comando. Toda criacao de
#   pasta usa `mkdir -p` explicito e todo marcador usa `touch` explicito.
# ==============================================================================

set -euo pipefail

TARGET_DIR="${1:-.}"
REPO="${REPO:-MailsonSilva/antigravity-harness}"
BRANCH="${BRANCH:-main}"

cd "$TARGET_DIR"

command -v git >/dev/null 2>&1 || { echo "ERRO: git nao encontrado no PATH." >&2; exit 1; }
[ -f ".agents/harness.yaml" ] || { echo "ERRO: harness nao encontrado em $(pwd). Rode o install.sh primeiro." >&2; exit 1; }

# Aceita "owner/repo", URL completa ou caminho local (util para testes).
case "$REPO" in
  http://*|https://*|git@*|file://*|/*|./*|../*|[A-Za-z]:/*) REPO_URL="$REPO" ;;
  *) REPO_URL="https://github.com/$REPO.git" ;;
esac

STAMP=$(date +%Y%m%d-%H%M%S)
WORKDIR=$(mktemp -d "${TMPDIR:-/tmp}/harness-update-XXXXXX")
BACKUP=$(mktemp -d "${TMPDIR:-/tmp}/harness-backup-XXXXXX")

cleanup() { rm -rf "$WORKDIR"; }
trap cleanup EXIT

echo "====================================================="
echo "  Atualizador do Antigravity Flutter Harness (v3.0)"
echo "====================================================="
echo "Baixando ${REPO_URL} (branch ${BRANCH}) ..."

# 1. Clone temporario da versao upstream.
git clone --quiet --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/src"
SRC="$WORKDIR/src"

# 2. Backup dos arquivos gerenciados antes de sobrescrever.
for p in ".agents/harness.yaml" ".agents/mcp.json" ".agents/rules" ".agents/workflows" "harness-studio.html"; do
    [ -e "$p" ] || continue
    mkdir -p "$BACKUP/$(dirname "$p")"
    cp -R "$p" "$BACKUP/$p"
done
echo "Backup criado em: ${BACKUP}"

# 3. Estrutura canonica: comandos explicitos de diretorio (nunca execute a pasta).
mkdir -p ".agents"
mkdir -p ".agents/rules"
mkdir -p ".agents/workflows"
mkdir -p ".agents/memory"
mkdir -p ".agents/skills"
mkdir -p "_specs"
mkdir -p "_specs/features"
mkdir -p "_specs/tasks"
mkdir -p "_references"
mkdir -p "_references/screens"
mkdir -p "_references/brand"

# 4. Arquivos gerenciados (somente arquivos; diretorios sao tratados no passo 5).
for f in \
    ".agents/harness.yaml" \
    ".agents/mcp.json" \
    "_specs/prd-template.md" \
    "_specs/tasks/_template.md" \
    "harness-studio.html" \
    "install.ps1" \
    "install.sh" \
    "update.ps1"; do
    [ -f "$SRC/$f" ] || continue
    mkdir -p "$(dirname "$f")"
    cp -f "$SRC/$f" "$f"
done

# update.sh e o proprio script em execucao: usar rename atomico em vez de
# "cp -f" (que trunca o inode lido pelo bash e faz o shell executar um trecho
# corrompido do arquivo novo, ex.: "bash: /: Is a directory").
if [ -f "$SRC/update.sh" ]; then
    if cp -f "$SRC/update.sh" "./.update.sh.new"; then
        mv -f "./.update.sh.new" "./update.sh"
    else
        rm -f "./.update.sh.new"
    fi
fi

# 5. Regras e workflows gerenciados (copia o conteudo, preserva arquivos locais).
for d in ".agents/rules" ".agents/workflows"; do
    [ -d "$SRC/$d" ] || continue
    mkdir -p "$d"
    cp -R "$SRC/$d/." "$d/"
done

# 6. Skills: preserva as existentes e adiciona apenas as novas.
if [ -d "$SRC/.agents/skills" ]; then
    mkdir -p ".agents/skills"
    for skill in "$SRC/.agents/skills"/*/; do
        [ -d "$skill" ] || continue
        name=$(basename "$skill")
        if [ ! -e ".agents/skills/$name" ]; then
            cp -R "$skill" ".agents/skills/$name"
            echo "  + skill nova: $name"
        fi
    done
fi

# 7. PROJECT_BRAIN: cria somente se ainda nao existir (nunca sobrescreve memoria).
if [ -f "$SRC/.agents/PROJECT_BRAIN.md" ] && [ ! -f ".agents/PROJECT_BRAIN.md" ]; then
    cp "$SRC/.agents/PROJECT_BRAIN.md" ".agents/PROJECT_BRAIN.md"
fi

# 8. Task board: cria somente se ainda nao existir (preserva o Kanban local).
if [ -f "$SRC/_specs/task-board.md" ] && [ ! -f "_specs/task-board.md" ]; then
    cp "$SRC/_specs/task-board.md" "_specs/task-board.md"
fi

# 9. Marcadores de versionamento das pastas vazias (touch explicito por arquivo).
touch "_references/screens/.gitkeep"
touch "_references/brand/.gitkeep"
touch ".agents/memory/.gitkeep"

echo "✔ Atualização concluída com sucesso!"
echo "✔ PROJECT_BRAIN.md, skills existentes e .agents/memory preservados."
echo "✔ harness-studio.html sincronizado quando presente no upstream; task-board.md local preservado."
