#!/bin/bash
# [00] INIT SUBMODULE — Integração do Antigravity OS em Novo Projeto
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh

set -e  # Sai imediatamente em caso de erro

echo "🧬 Iniciando integração do Antigravity OS Neural..."

# Configurações
FRAMEWORK_REPO="https://github.com/svw10/Meu_Repo.git"
FRAMEWORK_PATH=".antigravity-os"
FRAMEWORK_BRANCH="main"

# 1. Verifica se já existe um submódulo
if [ -d "$FRAMEWORK_PATH/.git" ]; then
  echo "⚠️  Antigravity OS já está integrado em $FRAMEWORK_PATH"
  echo "Para atualizar: bash $FRAMEWORK_PATH/[08] SUBMODULE_HOOKS/[01] update-core.sh"
  exit 0
fi

# 2. Adiciona como submódulo Git
echo "📦 Adicionando submódulo: $FRAMEWORK_REPO → $FRAMEWORK_PATH"
git submodule add -b "$FRAMEWORK_BRANCH" "$FRAMEWORK_REPO" "$FRAMEWORK_PATH"

# 3. Inicializa e atualiza submódulos recursivos
echo "🔄 Inicializando submódulos..."
git submodule update --init --recursive

# 4. Configura permissões de execução nos hooks
echo "🔐 Configurando permissões de scripts..."
chmod +x "$FRAMEWORK_PATH/[08] SUBMODULE_HOOKS/"*.sh 2>/dev/null || true

# 5. Valida estrutura mínima
echo "✅ Validando estrutura..."
REQUIRED_FILES=(
  "$FRAMEWORK_PATH/[00] KERNEL/[00] quantum-loader.md"
  "$FRAMEWORK_PATH/[01] ORCHESTRATOR/[00] semantic-router.md"
  "$FRAMEWORK_PATH/[99] INDEX.md"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ Erro: Arquivo crítico não encontrado: $file"
    exit 1
  fi
done

# 6. Atualiza .gitmodules para commit
echo "📝 Atualizando .gitmodules..."
git add .gitmodules "$FRAMEWORK_PATH"

# 7. Mensagem final
echo ""
echo "🎉 Antigravity OS integrado com sucesso!"
echo ""
echo "Próximos passos:"
echo "1. Commit a integração: git commit -m 'chore: add antigravity-os submodule'"
echo "2. Configure .cursorrules na raiz apontando para $FRAMEWORK_PATH/[00] KERNEL/"
echo "3. Inicie um novo projeto lendo: $FRAMEWORK_PATH/[99] INDEX.md"
echo ""
echo "⚠️  Regra de Ouro: Nunca edite $FRAMEWORK_PATH/ diretamente."
echo "   Para atualizar o framework: use [01] update-core.sh"