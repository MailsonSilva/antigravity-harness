#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness - Verificação Unificada de Qualidade (Linux / macOS / CI)
# Executa Design System Gate, análise estática e suíte de testes (-j 1)
# ==============================================================================

set -euo pipefail

SKIP_TESTS="false"
SKIP_LINT="false"
APP_PATH="."

while [ $# -gt 0 ]; do
    case "$1" in
        --skip-tests)
            SKIP_TESTS="true"
            shift
            ;;
        --skip-lint)
            SKIP_LINT="true"
            shift
            ;;
        --app-path)
            APP_PATH="${2:-.}"
            shift 2
            ;;
        -h|--help)
            echo "Uso: ./verify.sh [--skip-lint] [--skip-tests] [--app-path dir]"
            exit 0
            ;;
        *)
            echo "Argumento desconhecido: $1" >&2
            exit 1
            ;;
    esac
done

echo "====================================================="
echo "  🔍 Verificação de Qualidade do Antigravity Harness "
echo "====================================================="

TARGET_DIR="$APP_PATH"
if [ ! -f "$TARGET_DIR/pubspec.yaml" ] && [ -f "apps/mobile/pubspec.yaml" ]; then
    TARGET_DIR="apps/mobile"
fi

pushd "$TARGET_DIR" >/dev/null
cleanup() {
    popd >/dev/null || true
}
trap cleanup EXIT

# 1. Design System Gate (zero cores literais em lib/features/)
if [ "$SKIP_LINT" = "false" ]; then
    if [ -d "lib/features" ]; then
        echo ""
        echo "[1/3] Executando Design System Gate em $TARGET_DIR/lib/features..."
        VIOLATIONS=""
        while IFS= read -r -d '' dart_file; do
            file_hits="$(awk '
                /^[[:space:]]*\/\// { next }
                {
                    orig = $0
                    sanitized = $0
                    gsub(/Colors\.transparent([^A-Za-z0-9_]|$)/, " ", sanitized)
                    if (sanitized ~ /Color\(0x/ || sanitized ~ /(^|[^A-Za-z0-9_])Colors\.[A-Za-z0-9_]+/) {
                        gsub(/^[[:space:]]+|[[:space:]]+$/, "", orig)
                        printf "%s:%d: %s\n", FILENAME, NR, orig
                    }
                }
            ' "$dart_file")"
            if [ -n "$file_hits" ]; then
                if [ -n "$VIOLATIONS" ]; then
                    VIOLATIONS="${VIOLATIONS}"$'\n'"${file_hits}"
                else
                    VIOLATIONS="$file_hits"
                fi
            fi
        done < <(find "lib/features" -type f -name "*.dart" -print0)

        if [ -n "$VIOLATIONS" ]; then
            echo "❌ Violação de Design System em lib/features/:"
            while IFS= read -r vline; do
                echo "   $vline"
            done <<< "$VIOLATIONS"
            echo "Substitua cores hardcoded (Color(0x...) / Colors.*) pelos tokens semânticos de lib/core/theme/ (_references/brand/DESIGN_SYSTEM.md)."
            exit 1
        fi
        echo "✔ Design System Gate aprovado (zero cores hardcoded em lib/features/)."
    else
        echo ""
        echo "[1/3] Diretório 'lib/features/' não encontrado em $TARGET_DIR (pulando Design System Gate)."
    fi

    # 2. Análise Estática (Dart Analyzer)
    echo ""
    echo "[2/3] Executando análise estática em $TARGET_DIR (dart analyze)..."
    dart analyze
    echo "✔ Análise estática limpa sem avisos."
else
    echo ""
    echo "[1/3] Design System Gate ignorado (--skip-lint)."
    echo "[2/3] Análise estática ignorada (--skip-lint)."
fi

# 3. Bateria de Testes com concorrência segura (-j 1 para isolamento SQLite)
if [ "$SKIP_TESTS" = "false" ]; then
    if [ -d "test" ]; then
        echo ""
        echo "[3/3] Executando suíte de testes em $TARGET_DIR (flutter test -j 1)..."
        flutter test -j 1
        echo "✔ Todos os testes passaram com sucesso!"
    else
        echo ""
        echo "[3/3] Diretório de testes 'test/' não encontrado em $TARGET_DIR (pulando testes)."
    fi
else
    echo ""
    echo "[3/3] Testes ignorados (--skip-tests)."
fi

echo ""
echo "====================================================="
echo "  🎉 Gate de Qualidade Aprovado com Sucesso!         "
echo "====================================================="
