#!/bin/bash
# [06] SECURITY SCAN — Pré-commit obrigatório (Secrets, PII, URLs, Path)
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[06] security-scan.sh
set -e

echo "🛡️ Iniciando varredura de segurança pré-commit..."

BLOCKED=0

# 1. Secrets
echo "🔍 Verificando secrets..."
if grep -rnE "(sk-|pk-|ghp_|AKIA|xox[baprs]-)[A-Za-z0-9]{20,}" src/ docs/ 2>/dev/null; then
  echo "❌ Bloqueado: Secrets detectados. Use .env + {{REDACTED_SECRET}}"
  BLOCKED=1
fi

# 2. PII (CPF/CNPJ/Email)
echo "🔍 Verificando PII..."
if grep -rnE "(\d{3}\.\d{3}\.\d{3}-\d{2}|\d{2}\.\d{3}\.\d{3}/\d{4}-\d{2}|[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,})" src/ 2>/dev/null | grep -v "REDACTED\|example\|teste"; then
  echo "❌ Bloqueado: PII detectada. Mascare com [REDACTED_*]"
  BLOCKED=1
fi

# 3. Path Traversal
echo "🔍 Verificando path traversal..."
if grep -rnE "(\.\./|\.\.\\|/etc/|/root/|/var/|C:\\Windows)" src/ 2>/dev/null; then
  echo "❌ Bloqueado: Path traversal detectado."
  BLOCKED=1
fi

# 4. URLs Não Whitelisted
echo "🔍 Verificando URLs externas..."
WHITELIST="github.com|gitlab.com|npmjs.com|pypi.org|vercel.com|neon.tech|clerk.com|resend.com|openrouter.ai|nextjs.org|react.dev"
if grep -rnE "https?://[^/]+" src/ 2>/dev/null | grep -vE "$WHITELIST" | grep -v "localhost\|127.0.0.1\|example.com"; then
  echo "⚠️ Atenção: URLs fora da whitelist detectadas. Valide manualmente."
fi

# Resultado
if [ $BLOCKED -eq 1 ]; then
  echo "🛑 Commit bloqueado. Corrija as violações de segurança."
  exit 1
else
  echo "✅ Varredura concluída. Zero violações críticas."
  exit 0
fi
