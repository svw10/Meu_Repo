#!/bin/bash
# [01] UPDATE CORE — Atualização Segura do Framework
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[01] update-core.sh

set -e  # Sai imediatamente em caso de erro

FRAMEWORK_PATH=".antigravity-os"

echo "🔄 Verificando estado do Antigravity OS..."

# 1. Valida se o submódulo existe
if [ ! -d "$FRAMEWORK_PATH/.git" ]; then
  echo "❌ Erro: Antigravity OS não está integrado como submódulo."
  echo "Execute primeiro: [00] init-submodule.sh"
  exit 1
fi

# 2. Verifica se há alterações locais não commitadas no submódulo
cd "$FRAMEWORK_PATH"
if [ -n "$(git status --porcelain)" ]; then
  echo "⚠️  Atenção: Existem alterações locais não commitadas em .antigravity-os/"
  echo "   Recomendação: Faça backup ou commit antes de atualizar."
  read -p "Deseja continuar e sobrescrever? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "🛑 Atualização cancelada."
    exit 1
  fi
  # Força checkout para limpar estado sujo
  git checkout -- .
  git clean -fd
fi

# 3. Atualiza para a versão mais remota
echo "📥 Buscando e aplicando atualizações..."
git fetch origin main
OLD_HASH=$(git rev-parse HEAD)
git merge origin/main --ff-only 2>/dev/null || git pull origin main
NEW_HASH=$(git rev-parse HEAD)

if [ "$OLD_HASH" == "$NEW_HASH" ]; then
  echo "✅ Framework já está na versão mais recente."
else
  echo "📦 Atualizado com sucesso:"
  echo "   Anterior: $OLD_HASH"
  echo "   Atual:    $NEW_HASH"
fi

cd ..

# 4. Atualiza referência no projeto pai
echo "📝 Atualizando link do submódulo no repositório pai..."
git add "$FRAMEWORK_PATH"
git commit -m "chore: update antigravity-os core ($NEW_HASH)" 2>/dev/null || echo "ℹ️  Projeto pai já está sincronizado."

# 5. Validação Pós-Atualização
echo "🔍 Validando integridade da estrutura..."
REQUIRED_FILES=(
  "$FRAMEWORK_PATH/[00] KERNEL/[00] quantum-loader.md"
  "$FRAMEWORK_PATH/[01] ORCHESTRATOR/[00] semantic-router.md"
  "$FRAMEWORK_PATH/[99] INDEX.md"
)

ALL_OK=true
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ FALHA: Arquivo crítico ausente: $file"
    ALL_OK=false
  fi
done

if [ "$ALL_OK" = true ]; then
  echo "✅ Estrutura validada. Framework pronto para uso."
else
  echo "⚠️  Validação falhou. Execute 'git submodule update --init --recursive' para reparar."
  exit 1
fi

echo ""
echo "🎉 Atualização concluída!"
echo "💡 Dica: Revise .antigravity-os/[99] INDEX.md para ver novas features ou regras."