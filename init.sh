#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness Setup & Update (Linux / macOS / WSL)
# Configura ou atualiza o ambiente Antigravity (v4 Modular) no projeto-alvo.
# Uso:
#   ./init.sh flutter [caminho_destino] [--with-optional-mcps] [--init-app] [--app-dir apps/mobile]
#   ./init.sh web     [caminho_destino] [--repo owner/repo] [--branch main]
# ==============================================================================

set -euo pipefail

PROFILE=""
TARGET_DIR="$(pwd)"
REPO="MailsonSilva/antigravity-harness"
BRANCH="main"
APP_DIR=""
ORG="com.example"
PROJECT_NAME=""
INIT_APP="false"
WITH_OPTIONAL_MCPS="false"

while [ $# -gt 0 ]; do
    case "$1" in
        --with-optional-mcps)
            WITH_OPTIONAL_MCPS="true"
            shift
            ;;
        --init-app)
            INIT_APP="true"
            shift
            ;;
        --org)
            ORG="${2:-com.example}"
            shift 2
            ;;
        --project-name)
            PROJECT_NAME="${2:-}"
            shift 2
            ;;
        --repo)
            REPO="${2:-}"
            shift 2
            ;;
        --branch)
            BRANCH="${2:-main}"
            shift 2
            ;;
        --app-dir)
            APP_DIR="${2:-}"
            shift 2
            ;;
        -h|--help)
            echo "Uso: ./init.sh <perfil> [caminho_destino] [--with-optional-mcps] [--init-app] [--org com.example] [--project-name app] [--app-dir dir] [--repo owner/repo] [--branch main]"
            exit 0
            ;;
        *)
            if [ -z "$PROFILE" ]; then
                PROFILE="$1"
            else
                TARGET_DIR="$1"
            fi
            shift
            ;;
    esac
done

if [ -z "$PROFILE" ]; then
    echo "Uso: ./init.sh <flutter|web> [caminho_destino] [--with-optional-mcps]"
    exit 1
fi

TEMP_CLONE_DIR=""
cleanup() {
    if [ -n "$TEMP_CLONE_DIR" ] && [ -d "$TEMP_CLONE_DIR" ]; then
        rm -rf "$TEMP_CLONE_DIR"
    fi
}
trap cleanup EXIT

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE_TYPE="local"
HARNESS_ROOT="$SCRIPT_DIR"

if [ ! -d "$HARNESS_ROOT/core" ]; then
    SOURCE_TYPE="remote"
    TEMP_CLONE_DIR="$(mktemp -d)"
    echo "🌐 Baixando Antigravity Harness ($REPO@$BRANCH)..."
    git clone --quiet --depth 1 --branch "$BRANCH" "https://github.com/$REPO.git" "$TEMP_CLONE_DIR"
    HARNESS_ROOT="$TEMP_CLONE_DIR"
fi

CORE_DIR="$HARNESS_ROOT/core"
PROFILES_ROOT="$HARNESS_ROOT/profiles"

if [ ! -d "$CORE_DIR" ] || [ ! -d "$PROFILES_ROOT" ]; then
    echo "Erro: Estrutura inválida em $HARNESS_ROOT."
    exit 1
fi

# Resolver perfil dinamicamente via profile.yaml
SELECTED_PROFILE_DIR=""
PROFILE_NAME=""
PROFILE_MD=""
SELECTED_YAML=""

for yaml_file in "$PROFILES_ROOT"/*/profile.yaml; do
    [ -f "$yaml_file" ] || continue
    p_name="$(awk -F': *' '/^name:/{gsub(/["'\'' ]/, "", $2); print $2; exit}' "$yaml_file")"
    p_gemini="$(awk -F': *' '/^gemini_file:/{gsub(/["'\'' ]/, "", $2); print $2; exit}' "$yaml_file")"
    p_aliases="$(awk '/^aliases:/{flag=1; next} /^[a-zA-Z0-9_]+:/{flag=0} flag && /^ *- /{gsub(/^ *- *|["'\'' ]/, ""); print}' "$yaml_file")"

    if [ "$p_name" = "$PROFILE" ] || echo "$p_aliases" | grep -qx "$PROFILE"; then
        SELECTED_PROFILE_DIR="$(dirname "$yaml_file")"
        PROFILE_NAME="$p_name"
        PROFILE_MD="$p_gemini"
        SELECTED_YAML="$yaml_file"
        break
    fi
done

if [ -z "$SELECTED_PROFILE_DIR" ]; then
    echo "Erro: Perfil '$PROFILE' não encontrado em $PROFILES_ROOT."
    exit 1
fi

mkdir -p "$TARGET_DIR"
TARGET_DIR="$(cd "$TARGET_DIR" && pwd)"

echo "🚀 Configurando Antigravity Harness ($PROFILE_NAME)..."
echo "📁 Destino: $TARGET_DIR"

AGENTS_DIR="$TARGET_DIR/.agents"
WORKFLOWS_DIR="$AGENTS_DIR/workflows"
SKILLS_DIR="$AGENTS_DIR/skills"
SPECS_DIR="$TARGET_DIR/_specs"
MANIFEST_PATH="$AGENTS_DIR/.harness-manifest.json"

NOW_UTC="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
INSTALLED_AT="$NOW_UTC"
PREV_SKILLS=""
if [ -f "$MANIFEST_PATH" ]; then
    prev_inst="$(sed -n 's/.*"installedAt"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$MANIFEST_PATH" | head -n1 || true)"
    [ -n "$prev_inst" ] && INSTALLED_AT="$prev_inst"
    PREV_SKILLS="$(awk '/"managedSkills"/{flag=1} flag{print} /\]/{if(flag) exit}' "$MANIFEST_PATH" | grep -oE '"[^"]+"' | grep -v '"managedSkills"' | tr -d '"' || true)"
fi

# Backup de arquivos gerenciados existentes
if [ -f "$TARGET_DIR/GEMINI.md" ] || [ -d "$WORKFLOWS_DIR" ] || [ -f "$AGENTS_DIR/mcp.json" ]; then
    BACKUP_DIR="/tmp/harness-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR/.agents"
    [ -f "$TARGET_DIR/GEMINI.md" ] && cp "$TARGET_DIR/GEMINI.md" "$BACKUP_DIR/GEMINI.md"
    [ -d "$WORKFLOWS_DIR" ] && cp -R "$WORKFLOWS_DIR" "$BACKUP_DIR/.agents/workflows"
    [ -f "$AGENTS_DIR/mcp.json" ] && cp "$AGENTS_DIR/mcp.json" "$BACKUP_DIR/.agents/mcp.json"
    [ -f "$TARGET_DIR/harness-studio.html" ] && cp "$TARGET_DIR/harness-studio.html" "$BACKUP_DIR/harness-studio.html"
    echo "🛟 Backup criado em: $BACKUP_DIR"
fi

mkdir -p "$AGENTS_DIR" "$WORKFLOWS_DIR" "$SKILLS_DIR" "$SPECS_DIR"

echo "📦 Atualizando workflows (plan.md e orchestrate.md)..."
cp -R "$CORE_DIR/workflows/"* "$WORKFLOWS_DIR/"

echo "🧠 Instalando skills ($PROFILE_NAME)..."
MANAGED_SKILLS=()
if [ -d "$CORE_DIR/skills" ]; then
    for s in "$CORE_DIR/skills"/*; do
        [ -d "$s" ] || continue
        sname="$(basename "$s")"
        rm -rf "$SKILLS_DIR/$sname"
        cp -R "$s" "$SKILLS_DIR/$sname"
        MANAGED_SKILLS+=("$sname")
    done
fi
if [ -d "$SELECTED_PROFILE_DIR/skills" ]; then
    for s in "$SELECTED_PROFILE_DIR/skills"/*; do
        [ -d "$s" ] || continue
        sname="$(basename "$s")"
        rm -rf "$SKILLS_DIR/$sname"
        cp -R "$s" "$SKILLS_DIR/$sname"
        MANAGED_SKILLS+=("$sname")
    done
fi

# Remover skills antigas do manifesto que saíram do perfil
if [ -n "$PREV_SKILLS" ]; then
    for old_s in $PREV_SKILLS; do
        keep="false"
        for cur_s in "${MANAGED_SKILLS[@]}"; do
            if [ "$old_s" = "$cur_s" ]; then
                keep="true"
                break
            fi
        done
        if [ "$keep" = "false" ] && [ -d "$SKILLS_DIR/$old_s" ]; then
            rm -rf "$SKILLS_DIR/$old_s"
        fi
    done
fi

echo "📝 Gerando GEMINI.md na raiz do projeto..."
cat "$CORE_DIR/GEMINI.base.md" > "$TARGET_DIR/GEMINI.md"
printf "\n---\n\n" >> "$TARGET_DIR/GEMINI.md"
cat "$SELECTED_PROFILE_DIR/$PROFILE_MD" >> "$TARGET_DIR/GEMINI.md"

if [ "$PROFILE_NAME" = "flutter" ]; then
    RESOLVED_APP_DIR="$APP_DIR"
    if [ -z "$RESOLVED_APP_DIR" ]; then
        if [ -f "$TARGET_DIR/apps/mobile/pubspec.yaml" ]; then
            RESOLVED_APP_DIR="apps/mobile"
        else
            RESOLVED_APP_DIR="."
        fi
    fi
    printf "\n---\n\n## Workspace Flutter Detectado\n- Diretório do pacote Dart/Flutter: \`%s\` (execute \`flutter test\` e \`dart analyze\` a partir deste caminho).\n" "$RESOLVED_APP_DIR" >> "$TARGET_DIR/GEMINI.md"
fi

# Copiar harness-studio.html, COMANDOS.md e inicializar templates se ausentes
if [ -f "$HARNESS_ROOT/harness-studio.html" ]; then
    cp "$HARNESS_ROOT/harness-studio.html" "$TARGET_DIR/harness-studio.html"
fi
if [ -f "$HARNESS_ROOT/COMANDOS.md" ]; then
    cp "$HARNESS_ROOT/COMANDOS.md" "$AGENTS_DIR/COMANDOS.md"
fi
if [ -f "$CORE_DIR/templates/board.json" ] && [ ! -f "$SPECS_DIR/board.json" ]; then
    cp "$CORE_DIR/templates/board.json" "$SPECS_DIR/board.json"
fi
if [ -f "$CORE_DIR/templates/PROJECT_BRAIN.md" ] && [ ! -f "$AGENTS_DIR/PROJECT_BRAIN.md" ]; then
    cp "$CORE_DIR/templates/PROJECT_BRAIN.md" "$AGENTS_DIR/PROJECT_BRAIN.md"
fi
if [ -f "$CORE_DIR/templates/HARNESS_FEEDBACK.md" ] && [ ! -f "$AGENTS_DIR/HARNESS_FEEDBACK.md" ]; then
    cp "$CORE_DIR/templates/HARNESS_FEEDBACK.md" "$AGENTS_DIR/HARNESS_FEEDBACK.md"
fi

# Scaffolding inicial do app Flutter (--init-app)
if [ "$INIT_APP" = "true" ] && [ "$PROFILE_NAME" = "flutter" ]; then
    TARGET_APP_PATH="$TARGET_DIR"
    [ -n "$APP_DIR" ] && TARGET_APP_PATH="$TARGET_DIR/$APP_DIR"
    mkdir -p "$TARGET_APP_PATH"

    if [ ! -f "$TARGET_APP_PATH/pubspec.yaml" ]; then
        RAW_NAME="${PROJECT_NAME:-$(basename "$TARGET_APP_PATH")}"
        RESOLVED_PROJECT_NAME="$(printf '%s' "$RAW_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]\+/_/g; s/^_\+//; s/_\+$//')"
        if [ -z "$RESOLVED_PROJECT_NAME" ] || printf '%s' "$RESOLVED_PROJECT_NAME" | grep -qE '^[0-9]'; then
            RESOLVED_PROJECT_NAME="flutter_app"
        fi
        if command -v flutter >/dev/null 2>&1; then
            echo "📱 Executando flutter create ($RESOLVED_PROJECT_NAME)..."
            flutter create --org "$ORG" --project-name "$RESOLVED_PROJECT_NAME" "$TARGET_APP_PATH" || echo "⚠️ flutter create falhou; seguindo com criação de pastas."
        else
            echo "⚠️ Comando 'flutter' não encontrado no PATH; criando apenas estrutura de pastas."
        fi
    fi

    mkdir -p \
        "$TARGET_APP_PATH/lib/core/database" \
        "$TARGET_APP_PATH/lib/core/errors" \
        "$TARGET_APP_PATH/lib/core/network" \
        "$TARGET_APP_PATH/lib/core/theme" \
        "$TARGET_APP_PATH/lib/features" \
        "$TARGET_APP_PATH/test/core" \
        "$TARGET_APP_PATH/test/features" \
        "$TARGET_APP_PATH/integration_test" \
        "$TARGET_DIR/_references/brand" \
        "$TARGET_DIR/_references/screens"
fi

# Gerar .agents/mcp.json com base em mcps.default + mcps.optional (se --with-optional-mcps)
MCPS_DEFAULT="$(awk '/^mcps:/{m=1; next} m && /^[a-zA-Z0-9_]+:/{m=0} m && /^  default:/{d=1; next} m && /^  [a-zA-Z0-9_]+:/{d=0} m && d && /^    - /{gsub(/^    - *|["'\'' ]/, ""); print}' "$SELECTED_YAML")"
MCPS_OPTIONAL="$(awk '/^mcps:/{m=1; next} m && /^[a-zA-Z0-9_]+:/{m=0} m && /^  optional:/{o=1; next} m && /^  [a-zA-Z0-9_]+:/{o=0} m && o && /^    - /{gsub(/^    - *|["'\'' ]/, ""); print}' "$SELECTED_YAML")"

MCP_KEYS="$MCPS_DEFAULT"
if [ "$WITH_OPTIONAL_MCPS" = "true" ]; then
    MCP_KEYS="$(printf "%s\n%s" "$MCPS_DEFAULT" "$MCPS_OPTIONAL")"
fi

mcp_entry() {
    case "$1" in
        dart_mcp)
            printf '    "dart_mcp": {\n      "command": "dart",\n      "args": ["mcp-server"],\n      "description": "Inspeção da árvore de widgets, símbolos e testes Flutter."\n    }' ;;
        supabase_mcp)
            printf '    "supabase_mcp": {\n      "command": "npx",\n      "args": ["-y", "@supabase/mcp-server-supabase@latest"],\n      "description": "Inspeção de schema Postgres, migrations, RLS e Edge Functions."\n    }' ;;
        google_stitch)
            printf '    "google_stitch": {\n      "command": "npx",\n      "args": ["-y", "@google/stitch-mcp-server"],\n      "env": {"STITCH_REFERENCES_DIR": "./_references/screens", "STITCH_OUTPUT_DIR": "./_specs"},\n      "description": "Extração de Design Tokens a partir de telas em _references/screens/."\n    }' ;;
        patrol_mcp)
            printf '    "patrol_mcp": {\n      "command": "dart",\n      "args": ["run", "patrol_mcp"],\n      "description": "Testes E2E em dispositivos/emuladores com interação nativa via Patrol MCP."\n    }' ;;
        graft_ast)
            printf '    "graft_ast": {\n      "command": "graft",\n      "args": ["mcp", "--watch"],\n      "description": "Navegação em árvore sintática (AST) para localizar chamadas e impactos."\n    }' ;;
        ai_memory)
            printf '    "ai_memory": {\n      "command": "ai-memory",\n      "args": ["mcp"],\n      "env": {"AI_MEMORY_DB_PATH": "./.agents/memory/context.db"},\n      "description": "Memória episódica de decisões arquiteturais entre subagentes."\n    }' ;;
    esac
}

{
    printf '{\n  "mcpServers": {\n'
    first_mcp="true"
    for key in $MCP_KEYS; do
        [ -z "$key" ] && continue
        entry="$(mcp_entry "$key" || true)"
        [ -z "$entry" ] && continue
        if [ "$first_mcp" = "false" ]; then
            printf ',\n'
        fi
        printf '%s' "$entry"
        first_mcp="false"
    done
    printf '\n  }\n}\n'
} > "$AGENTS_DIR/mcp.json"

# Gravar .agents/.harness-manifest.json
SKILLS_JSON=""
for idx in "${!MANAGED_SKILLS[@]}"; do
    [ "$idx" -gt 0 ] && SKILLS_JSON+=", "
    SKILLS_JSON+="\"${MANAGED_SKILLS[$idx]}\""
done

cat > "$MANIFEST_PATH" <<EOF
{
  "schemaVersion": 1,
  "harnessVersion": "4.0.0",
  "profile": "$PROFILE_NAME",
  "source": {
    "type": "$SOURCE_TYPE",
    "repo": "$REPO",
    "branch": "$BRANCH"
  },
  "installedAt": "$INSTALLED_AT",
  "updatedAt": "$NOW_UTC",
  "optionalMcpsEnabled": $WITH_OPTIONAL_MCPS,
  "managedSkills": [$SKILLS_JSON]
}
EOF

echo "✅ Antigravity Harness v4 configurado com sucesso!"
echo "   - Perfil ativo: $PROFILE_NAME"
echo "   - Diretrizes:   $TARGET_DIR/GEMINI.md"
echo "   - Manifesto:    $MANIFEST_PATH"
echo "   - MCPs opt-in:  $WITH_OPTIONAL_MCPS"
