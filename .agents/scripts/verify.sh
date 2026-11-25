#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness - Verificação Unificada de Qualidade (Linux / macOS / CI)
# Executa análise estática e suíte de testes com isolamento de locks (-j 1)
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

# 1. Análise Estática (Dart Analyzer)
if [ "$SKIP_LINT" = "false" ]; then
    echo ""
    echo "[1/2] Executando análise estática em $TARGET_DIR (dart analyze)..."
    dart analyze
    echo "✔ Análise estática limpa sem avisos."
else
    echo ""
    echo "[1/2] Análise estática ignorada (--skip-lint)."
fi

# 2. Bateria de Testes com concorrência segura (-j 1 para isolamento SQLite)
if [ "$SKIP_TESTS" = "false" ]; then
    if [ -d "test" ]; then
        echo ""
        echo "[2/2] Executando suíte de testes em $TARGET_DIR (flutter test -j 1)..."
        flutter test -j 1
        echo "✔ Todos os testes passaram com sucesso!"
    else
        echo ""
        echo "[2/2] Diretório de testes 'test/' não encontrado em $TARGET_DIR (pulando testes)."
    fi
else
    echo ""
    echo "[2/2] Testes ignorados (--skip-tests)."
fi

echo ""
echo "====================================================="
echo "  🎉 Gate de Qualidade Aprovado com Sucesso!         "
echo "====================================================="
