#!/bin/bash
# [03] SYNC MEMORY — Sincronização Segura de Aprendizado Cross-Project
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[03] sync-memory.sh
# Protocolo: HTTPS Outbound-Only + Cache TTL 24h + Sanitização Rigorosa

set -e

FRAMEWORK_DIR=".antigravity-os"
MEMORY_DIR="$FRAMEWORK_DIR/[04] MEMORY_DNA"
REGISTRY_FILE="$MEMORY_DIR/[00] error-dna-registry.json"
CACHE_DIR="$MEMORY_DIR/.cache"
CACHE_FILE="$CACHE_DIR/synced-registry.json"
TTL_SECONDS=86400 # 24 horas

echo "🔄 Iniciando sincronização de MEMORY_DNA..."

# 1. Prepara diretório de cache
mkdir -p "$CACHE_DIR"

# 2. Verifica TTL do Cache
if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE") ))
  if [ "$CACHE_AGE" -lt "$TTL_SECONDS" ]; then
    echo "✅ Cache local válido (${CACHE_AGE}s). Pulando download."
    exit 0
  fi
  echo "⏳ Cache expirado. Atualizando..."
fi

# 3. Configuração do Remote (Ajuste se necessário)
REMOTE_URL="https://raw.githubusercontent.com/svw10/Meu_Repo/main/.antigravity-os/[04]%20MEMORY_DNA/[00]%20error-dna-registry.json"

# 4. Download com tratamento de erro
TEMP_FILE=$(mktemp)
if curl -s -f -o "$TEMP_FILE" "$REMOTE_URL"; then
  echo "📥 Download concluído."
else
  echo "⚠️  Falha ao baixar registro remoto. Mantendo cache/local."
  rm -f "$TEMP_FILE"
  exit 1
fi

# 5. SANITIZAÇÃO RIGOROSA (Obrigatório por protocolo)
# Remove campos sensíveis que nunca devem ser sincronizados
echo "🛡️  Aplicando sanitização de segurança..."
# Nota: Requer jq. Se não instalado, avisa e aborta por segurança.
if ! command -v jq &> /dev/null; then
  echo "❌ Erro: 'jq' não encontrado. Instale para sincronização segura."
  rm -f "$TEMP_FILE"
  exit 1
fi

# Filtra apenas campos seguros para compartilhamento cross-project
SAFE_REGISTRY=$(jq '
  .errors = [.errors[] | {
    mutation: .mutation,
    vaccine: .vaccine,
    prevention_prompt: .prevention_prompt,
    immunity_scope: .immunity_scope,
    tech_stack: .tech_stack,
    timestamp: .timestamp,
    # Campos PROIBIDOS no sync: context_snapshot, error_id (pode ter hash local), agent_involved (opcional)
  }]
' "$TEMP_FILE")

echo "$SAFE_REGISTRY" > "$CACHE_FILE"
rm -f "$TEMP_FILE"

# 6. Merge Inteligente com Local
if [ -f "$REGISTRY_FILE" ]; then
  echo "🔗 Mesclando com registro local..."
  # Combina erros locais + remotos, removendo duplicatas por 'mutation' + 'timestamp'
  jq -s '
    .[0].errors + .[1].errors | unique_by(.mutation + .timestamp) | {
      version: "3.1.0-synced",
      description: "Registro sincronizado e sanitizado",
      errors: .,
      last_sync: "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
    }
  ' "$REGISTRY_FILE" "$CACHE_FILE" > "${REGISTRY_FILE}.tmp"
  mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"
else
  echo "📦 Nenhum registro local. Aplicando remoto como base."
  cp "$CACHE_FILE" "$REGISTRY_FILE"
fi

echo "✅ Sincronização concluída com sucesso."
echo "📊 Registros ativos: $(jq '.errors | length' "$REGISTRY_FILE")"
echo "💡 Dica: Execute '/sync-memory' na IDE para forçar atualização manual."
