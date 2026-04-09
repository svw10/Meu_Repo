#!/bin/bash
# [04] GENERATE EVOLUTION LOG — Versionamento Automático do Framework
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[04] generate-evolution-log.sh
# Objetivo: Ler git log, gerar changelog, incrementar versão e commitar.

set -e

echo "🚀 Iniciando processo de evolução do Antigravity OS..."

FRAMEWORK_DIR=".antigravity-os"
INDEX_FILE="$FRAMEWORK_DIR/[99] INDEX.md"
LOG_FILE="$FRAMEWORK_DIR/evolution-log.md"
TMP_FILE=$(mktemp)

# 1. Ler Versão Atual do INDEX.md
echo "🔍 Lendo versão atual..."
CURRENT_VERSION=$(grep -oP 'Versão:\s*\K[0-9]+\.[0-9]+\.[0-9]+' "$INDEX_FILE" || echo "0.0.0")
echo "   Versão Atual: $CURRENT_VERSION"

# 2. Incrementar Patch Version (x.y.z -> x.y.z+1)
echo "📈 Calculando nova versão..."
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"
echo "   Nova Versão: $NEW_VERSION"

# 3. Gerar Changelog das últimas alterações
echo "📝 Gerando changelog..."
# Pega os últimos 15 commits que não sejam de merge automático
COMMITS=$(git log --pretty=format:"* %s" -15)
DATE=$(date +%Y-%m-%d)

CHANGELOG_ENTRY="## Versão $NEW_VERSION ($DATE)
$COMMITS

---
"

# 4. Atualizar INDEX.md com nova versão
echo "📄 Atualizando INDEX.md..."
sed -i "s/Versão:\s*.*$/Versão: $NEW_VERSION/g" "$INDEX_FILE"
# Atualiza também a linha de "Última Atualização"
sed -i "s/\*\*Última Atualização:\*\*.*$/\*\*Última Atualização:\*\* $DATE/g" "$INDEX_FILE"

# 5. Atualizar Evolution Log (Prepend new entry)
echo "📜 Atualizando Evolution Log..."
if [ -f "$LOG_FILE" ]; then
    # Se existe, coloca o novo no topo
    echo "$CHANGELOG_ENTRY" > "$TMP_FILE"
    cat "$LOG_FILE" >> "$TMP_FILE"
    mv "$TMP_FILE" "$LOG_FILE"
else
    # Se não existe, cria
    echo -e "# 🧬 Antigravity OS Evolution Log\n\n$CHANGELOG_ENTRY" > "$LOG_FILE"
fi

# 6. Commitar e Taggear
echo "🔒 Salvando evolução..."
git add "$INDEX_FILE" "$LOG_FILE"
git commit -m "chore(release): bump version to $NEW_VERSION & update evolution log"
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

echo ""
echo "🎉 Evolução concluída!"
echo "   - Nova Versão: $NEW_VERSION"
echo "   - Tag criada: v$NEW_VERSION"
echo "   - Push necessário para sincronizar tags."
