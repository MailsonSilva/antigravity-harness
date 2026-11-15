#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness Setup (Linux / macOS / WSL)
# Configura o ambiente Antigravity copiando core + perfil selecionado para o projeto.
# Uso:
#   ./init.sh flutter [caminho_destino]
#   ./init.sh web     [caminho_destino]
# ==============================================================================

set -euo pipefail

PROFILE="${1:-}"
TARGET_DIR="${2:-$(pwd)}"

if [ -z "$PROFILE" ]; then
    echo "Uso: ./init.sh <flutter|web> [caminho_destino]"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HARNESS_ROOT="$SCRIPT_DIR"

if [ ! -d "$HARNESS_ROOT/core" ]; then
    HARNESS_ROOT="$(pwd)"
fi

PROFILE_FOLDER="flutter"
PROFILE_MD="GEMINI.flutter.md"

if [ "$PROFILE" = "web" ] || [ "$PROFILE" = "web-sites" ]; then
    PROFILE_FOLDER="web-sites"
    PROFILE_MD="GEMINI.web.md"
fi

echo "🚀 Configurando Antigravity Harness ($PROFILE_FOLDER)..."
echo "📁 Destino: $TARGET_DIR"

CORE_DIR="$HARNESS_ROOT/core"
SELECTED_PROFILE_DIR="$HARNESS_ROOT/profiles/$PROFILE_FOLDER"

if [ ! -d "$CORE_DIR" ] || [ ! -d "$SELECTED_PROFILE_DIR" ]; then
    echo "Erro: Diretórios de origem não encontrados em $HARNESS_ROOT."
    exit 1
fi

AGENTS_DIR="$TARGET_DIR/.agents"
WORKFLOWS_DIR="$AGENTS_DIR/workflows"
SKILLS_DIR="$AGENTS_DIR/skills"
SPECS_DIR="$TARGET_DIR/_specs"

mkdir -p "$AGENTS_DIR" "$WORKFLOWS_DIR" "$SKILLS_DIR" "$SPECS_DIR"

echo "📦 Copiando workflows (plan.md e orchestrate.md)..."
cp -R "$CORE_DIR/workflows/"* "$WORKFLOWS_DIR/"

echo "🧠 Instalando skills do perfil $PROFILE_FOLDER..."
if [ -d "$SELECTED_PROFILE_DIR/skills" ]; then
    cp -R "$SELECTED_PROFILE_DIR/skills/"* "$SKILLS_DIR/"
fi

echo "📝 Gerando GEMINI.md consolidado na raiz do projeto..."
cat "$CORE_DIR/GEMINI.base.md" > "$TARGET_DIR/GEMINI.md"
echo -e "\n---\n" >> "$TARGET_DIR/GEMINI.md"
cat "$SELECTED_PROFILE_DIR/$PROFILE_MD" >> "$TARGET_DIR/GEMINI.md"

cp "$TARGET_DIR/GEMINI.md" "$AGENTS_DIR/GEMINI.md"

echo "✅ Antigravity Harness configurado com sucesso!"
echo "   - Perfil ativo: $PROFILE_FOLDER"
echo "   - Diretrizes:   $TARGET_DIR/GEMINI.md"
echo "   - Workflows:    $WORKFLOWS_DIR"
echo "   - Skills:       $SKILLS_DIR"
