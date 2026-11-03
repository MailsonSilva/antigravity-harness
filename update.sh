#!/usr/bin/env bash
# ==============================================================================
# Antigravity Harness - Script de Atualização Segura
# Preserva PROJECT_BRAIN.md, .agents/skills/ e .agents/memory/
# ==============================================================================

set -e

REPO_URL="https://github.com/MailsonSilva/antigravity-harness"
BRANCH="main"
TIMESTAMP=$(date +"%Y%m%d-%H%M%S")
BACKUP_DIR=".agents.bak-${TIMESTAMP}"
TMP_DIR=".tmp-harness-update-${TIMESTAMP}"

echo "====================================================="
echo "  Atualizador do Antigravity Harness"
echo "====================================================="
echo "Baixando ${REPO_URL} (branch ${BRANCH}) ..."

# 1. Backup de segurança da pasta .agents atual
if [ -d ".agents" ]; then
    cp -r .agents "$BACKUP_DIR"
    echo "Backup criado em: ${BACKUP_DIR}"
fi

# 2. Clone temporário da versão upstream
git clone --depth 1 --branch "$BRANCH" "$REPO_URL" "$TMP_DIR" --quiet

# 3. Criação segura de pastas de infraestrutura
mkdir -p .agents/rules
mkdir -p .agents/workflows
mkdir -p .agents/memory
mkdir -p .agents/skills
mkdir -p _specs/features
mkdir -p _references/screens
mkdir -p _references/brand

# 4. Sincronização dos arquivos centrais do harness (mantendo regras locais)
cp -f "$TMP_DIR/.agents/harness.yaml" .agents/harness.yaml 2>/dev/null || true
cp -f "$TMP_DIR/.agents/mcp.json" .agents/mcp.json 2>/dev/null || true
cp -f "$TMP_DIR/.agents/workflows/dev-cycle.yaml" .agents/workflows/dev-cycle.yaml 2>/dev/null || true
cp -f "$TMP_DIR/_specs/prd-template.md" _specs/prd-template.md 2>/dev/null || true

# 5. Cópia não destrutiva de skills (só adiciona novas, nunca apaga as existentes)
if [ -d "$TMP_DIR/.agents/skills" ]; then
    cp -rn "$TMP_DIR/.agents/skills/"* .agents/skills/ 2>/dev/null || true
fi

# 6. Atualização dos próprios instaladores na raiz
cp -f "$TMP_DIR/install.ps1" ./install.ps1 2>/dev/null || true
cp -f "$TMP_DIR/install.sh" ./install.sh 2>/dev/null || true
cp -f "$TMP_DIR/update.ps1" ./update.ps1 2>/dev/null || true
# update.sh é o próprio script em execução: usar rename atômico em vez de
# "cp -f" (que trunca o inode lido pelo bash e faz o shell executar um trecho
# corrompido do arquivo novo, ex.: "bash: /: Is a directory").
if [ -f "$TMP_DIR/update.sh" ]; then
    if cp -f "$TMP_DIR/update.sh" "./.update.sh.new"; then
        mv -f "./.update.sh.new" ./update.sh
    else
        rm -f "./.update.sh.new"
    fi
fi

# 7. Garantia de rastreamento do Git nas pastas de referências
touch _references/screens/.gitkeep
touch _references/brand/.gitkeep

# 8. Limpeza do diretório temporário
rm -rf "$TMP_DIR"

echo "✔ Atualização concluída com sucesso!"
echo "✔ Memória, skills pré-existentes e regras locais preservadas."