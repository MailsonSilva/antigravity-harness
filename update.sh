#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness - Script de Atualização Universal (Linux / macOS / WSL)
# Preserva 100% de PROJECT_BRAIN.md e skills existentes
# ==============================================================================

set -e

echo -e "\n\033[1;36m🔄 [Harness Update] Iniciando sincronização segura...\033[0m"

TARGET_DIR="${1:-.}"
cd "$TARGET_DIR"

mkdir -p \
  .agents/rules \
  .agents/workflows \
  .agents/memory \
  .agents/skills/harness-evolver \
  _specs/features \
  _specs/tasks \
  _references/screens \
  _references/brand

touch _references/screens/.gitkeep
touch _references/brand/.gitkeep

echo -e "\033[1;32m✅ Estrutura de diretórios sincronizada com sucesso!\033[0m"
echo -e "\033[1;36mℹ️ Memória do projeto e skills customizadas preservadas sem alteração.\033[0m\n"
