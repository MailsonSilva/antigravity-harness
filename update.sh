#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness - Atualizador Universal (Linux / macOS / WSL / Git Bash)
# Sincroniza o harness com o repositorio upstream preservando dados locais.
#
# Uso:  ./update.sh [diretorio]        (env: REPO=owner/repo, BRANCH=main)
#
# PRESERVADO (nunca sobrescrito):
#   .agents/PROJECT_BRAIN.md     .agents/skills/** (skills existentes)
#   .agents/memory/**            apps/  _references/
#   _specs/prd.md  _specs/features/  _specs/tasks/T*.md  README.md  .git/
#
# ATUALIZADO (backup previo em /tmp/harness-backup-<data>):
#   .agents/harness.yaml  .agents/mcp.json  .agents/rules/**  .agents/workflows/**
#   _specs/prd-template.md  _specs/tasks/_template.md
#   install.ps1  install.sh  update.ps1  update.sh
# ==============================================================================

set -euo pipefail

TARGET_DIR="${1:-.}"
REPO="${REPO:-MailsonSilva/antigravity-harness}"
BRANCH="${BRANCH:-main}"

cd "$TARGET_DIR"

command -v git >/dev/null 2>&1 || { echo "ERRO: git nao encontrado no PATH." >&2; exit 1; }
[ -f .agents/harness.yaml ] || { echo "ERRO: harness nao encontrado em $(pwd). Rode o install.sh primeiro." >&2; exit 1; }

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

echo -e "\n\033[1;36mSincronizando de ${REPO_URL} (branch ${BRANCH})...\033[0m"

git clone --quiet --depth 1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR/src"
SRC="$WORKDIR/src"

# Backup dos arquivos gerenciados antes de sobrescrever.
for p in .agents/harness.yaml .agents/mcp.json .agents/rules .agents/workflows; do
  [ -e "$p" ] || continue
  mkdir -p "$BACKUP/$(dirname "$p")"
  cp -R "$p" "$BACKUP/$p"
done

# 1. Estrutura canonica.
mkdir -p \
  .agents/rules .agents/workflows .agents/memory .agents/skills \
  _specs/features _specs/tasks _references/screens _references/brand

# 2. Arquivos gerenciados (sobrescritos pelo upstream).
for f in \
  .agents/harness.yaml .agents/mcp.json \
  _specs/prd-template.md _specs/tasks/_template.md \
  install.ps1 install.sh update.ps1 update.sh; do
  [ -f "$SRC/$f" ] || continue
  mkdir -p "$(dirname "$f")"
  cp -f "$SRC/$f" "$f"
done

# 3. Regras e workflows.
for d in .agents/rules .agents/workflows; do
  [ -d "$SRC/$d" ] || continue
  mkdir -p "$d"
  cp -R "$SRC/$d/." "$d/"
done

# 4. Skills: preserva as existentes e adiciona apenas as novas.
if [ -d "$SRC/.agents/skills" ]; then
  mkdir -p .agents/skills
  for skill in "$SRC/.agents/skills"/*/; do
    [ -d "$skill" ] || continue
    name=$(basename "$skill")
    if [ ! -e ".agents/skills/$name" ]; then
      cp -R "$skill" ".agents/skills/$name"
      echo -e "  \033[1;32m+\033[0m skill nova: $name"
    fi
  done
fi

# 5. PROJECT_BRAIN: cria somente se ainda nao existir.
if [ -f "$SRC/.agents/PROJECT_BRAIN.md" ] && [ ! -f .agents/PROJECT_BRAIN.md ]; then
  cp "$SRC/.agents/PROJECT_BRAIN.md" .agents/PROJECT_BRAIN.md
fi

# 6. Marcadores de versionamento das pastas vazias.
touch _references/screens/.gitkeep _references/brand/.gitkeep .agents/memory/.gitkeep

echo -e "\033[1;32mHarness sincronizado com ${REPO_URL}@${BRANCH}.\033[0m"
echo -e "Preservados: PROJECT_BRAIN.md, .agents/skills/ e .agents/memory/."
echo -e "\033[1;33mBackup dos arquivos gerenciados: ${BACKUP}\033[0m"
