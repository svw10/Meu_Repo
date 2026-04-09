#!/bin/bash
# [02] VALIDATE STRUCTURE — Verificador de Integridade do Projeto
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[02] validate-structure.sh
# Objetivo: Garantir que as pastas essenciais do Antigravity OS existam no projeto pai.

echo "🔍 Verificando integridade da estrutura do projeto..."

# Define o diretório raiz do projeto (pai do .antigravity-os)
PROJECT_ROOT=".."

# Lista de pastas críticas obrigatórias
CRITICAL_FOLDERS=(
  "Agentes/"
  "Minhas_Skills/"
  "Nucleo/"
  "context/"
)

# Lista de pastas recomendadas (warning se faltar)
RECOMMENDED_FOLDERS=(
  "Logs/"
  "Minhas_Rules/"
  ".cursorrules"
)

MISSING_CRITICAL=0
MISSING_RECOMMENDED=0

# 1. Verifica Pastas Críticas
echo ""
echo "--- Pastas Críticas ---"
for folder in "${CRITICAL_FOLDERS[@]}"; do
  if [ -d "$PROJECT_ROOT/$folder" ]; then
    echo "✅ $folder encontrado."
  else
    echo "❌ FALHA CRÍTICA: $folder não encontrado!"
    MISSING_CRITICAL=$((MISSING_CRITICAL + 1))
  fi
done

# 2. Verifica Pastas Recomendadas
echo ""
echo "--- Arquivos/Pastas Recomendadas ---"
for item in "${RECOMMENDED_FOLDERS[@]}"; do
  if [ -e "$PROJECT_ROOT/$item" ]; then
    echo "✅ $item encontrado."
  else
    echo "⚠️  ATENÇÃO: $item não encontrado."
    MISSING_RECOMMENDED=$((MISSING_RECOMMENDED + 1))
  fi
done

# 3. Resultado Final
echo ""
if [ $MISSING_CRITICAL -eq 0 ]; then
  echo "🎉 Validação Crítica: SUCESSO"
  if [ $MISSING_RECOMMENDED -gt 0 ]; then
    echo "ℹ️  Nota: $MISSING_RECOMMENDED itens recomendados ausentes. O framework funcionará, mas com capacidades reduzidas."
  fi
  exit 0
else
  echo "🛑 Validação Crítica: FALHA"
  echo "⚠️  O framework precisa das pastas listadas acima para orquestrar seus Agentes e Skills."
  echo "   Por favor, crie as pastas faltantes ou restaure o backup do projeto."
  exit 1
fi
