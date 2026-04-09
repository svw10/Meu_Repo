#!/bin/bash
# Retro Collector – Gera JSON compacto para IA processar
set -e
OUTPUT=".antigravity-os/.cache/retro-input.json"
mkdir -p "$(dirname "$OUTPUT")"

echo "📊 Coletando dados para /retro..."

# 1. Erros resolvidos (últimos 30 dias)
ERRORS=$(grep -h '"vaccine"' .antigravity-os/[04]\ MEMORY_DNA/[00]\ error-dna-registry.json 2>/dev/null | wc -l)

# 2. Variáveis de ambiente únicas em src/
ENVS=$(grep -roh "process\.env\.[A-Z_0-9]*" src/ 2>/dev/null | sed 's/process\.env\.//g' | sort -u | jq -R . | jq -s . || echo '[]')

# 3. Uso médio de tokens por sprint (simulado via logs ou placeholder)
TOKEN_AVG=$(jq '.global.session_max_tokens * 0.6' .antigravity-os/[00]\ KERNEL/[02]\ token-budget-controller.json 2>/dev/null || echo "null")

# 4. Template base usado
TEMPLATE=$(grep -l "CLERK\|NEON\|RESEND" .env* 2>/dev/null | head -1 || echo "unknown")

jq -n \
  --argjson errors "$ERRORS" \
  --argjson envs "$ENVS" \
  --argjson tokens "$TOKEN_AVG" \
  --arg template "$TEMPLATE" \
  '{
    errors_resolved_count: $errors,
    env_vars_detected: $envs,
    avg_tokens_per_sprint: $tokens,
    template_used: $template,
    collected_at: now
  }' > "$OUTPUT"

echo "✅ JSON salvo em $OUTPUT. Execute /retro na IDE."
