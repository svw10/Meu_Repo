---
name: pre_commit_hooks
description: "Hooks de pré-commit para validação de segurança"
version: 5.0.0
framework: "Antigravity OS v3.1"
status: active
tags: [security, git, hooks, pre-commit]
---

# 🔐 PRE-COMMIT HOOKS — Validação de Segurança Local

> Barreira local antes do push. Previne que secrets e padrões perigosos entrem no repositório.

---

## Instalação Rápida

```bash
# 1. Instalar dependências
npm install -D husky lint-staged

# 2. Inicializar husky
npx husky install
npm pkg set scripts.prepare="husky install"

# 3. Criar hook de pre-commit
npx husky add .husky/pre-commit "npx lint-staged"
```

---

## Configuração lint-staged (package.json)

```json
{
  "lint-staged": {
    "*.{ts,tsx,js,jsx}": [
      "npx biome check --apply",
      "bash scripts/security-pre-commit.sh"
    ],
    "*.sql": [
      "bash scripts/check-rls.sh"
    ],
    ".env*": [
      "bash scripts/check-env-secrets.sh"
    ]
  }
}
```

---

## Script Principal: security-pre-commit.sh

```bash
#!/bin/bash
# scripts/security-pre-commit.sh
# 🔒 Validação de segurança pré-commit

set -e
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
ERRORS=0

echo "🛡️ Executando validação de segurança pré-commit..."

# ═══════════════════════════════════════════════
# CHECK 1: Secrets hardcoded
# ═══════════════════════════════════════════════
echo -n "  [1/6] Secrets hardcoded... "
STAGED_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(ts|tsx|js|jsx|json)$' || true)

if [ -n "$STAGED_FILES" ]; then
  SECRETS_FOUND=$(echo "$STAGED_FILES" | xargs grep -lnE \
    'sk-[a-zA-Z0-9]{20,}|sk_live_|sk_test_[a-zA-Z0-9]{20,}|pk_live_|ghp_[a-zA-Z0-9]{30,}|AKIA[0-9A-Z]{16}|password\s*[:=]\s*['\''"][^'\''\"]{8,}['\''"]' \
    2>/dev/null || true)
  
  if [ -n "$SECRETS_FOUND" ]; then
    echo -e "${RED}FALHOU${NC}"
    echo "    Secrets encontrados em:"
    echo "$SECRETS_FOUND" | sed 's/^/    ❌ /'
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}OK${NC}"
  fi
else
  echo -e "${GREEN}OK (sem arquivos)${NC}"
fi

# ═══════════════════════════════════════════════
# CHECK 2: NEXT_PUBLIC com secrets
# ═══════════════════════════════════════════════
echo -n "  [2/6] Env vars públicas com secrets... "
ENV_FILES=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.env' || true)

if [ -n "$ENV_FILES" ]; then
  PUBLIC_SECRETS=$(echo "$ENV_FILES" | xargs grep -lnE \
    'NEXT_PUBLIC_.*SECRET|NEXT_PUBLIC_.*PASSWORD|NEXT_PUBLIC_.*PRIVATE|VITE_.*SECRET|VITE_.*DATABASE' \
    2>/dev/null || true)
  
  if [ -n "$PUBLIC_SECRETS" ]; then
    echo -e "${RED}FALHOU${NC}"
    echo "$PUBLIC_SECRETS" | sed 's/^/    ❌ /'
    ERRORS=$((ERRORS + 1))
  else
    echo -e "${GREEN}OK${NC}"
  fi
else
  echo -e "${GREEN}OK (sem .env)${NC}"
fi

# ═══════════════════════════════════════════════
# CHECK 3: Padrões perigosos
# ═══════════════════════════════════════════════
echo -n "  [3/6] Padrões perigosos (eval, innerHTML)... "
if [ -n "$STAGED_FILES" ]; then
  DANGEROUS=$(echo "$STAGED_FILES" | xargs grep -lnE \
    'eval\(|new Function\(|dangerouslySetInnerHTML|__proto__|constructor\[' \
    2>/dev/null || true)
  
  if [ -n "$DANGEROUS" ]; then
    echo -e "${YELLOW}ALERTA${NC}"
    echo "$DANGEROUS" | sed 's/^/    ⚠️ /'
    echo "    Revise manualmente antes do push."
  else
    echo -e "${GREEN}OK${NC}"
  fi
else
  echo -e "${GREEN}OK${NC}"
fi

# ═══════════════════════════════════════════════
# CHECK 4: console.log em produção
# ═══════════════════════════════════════════════
echo -n "  [4/6] console.log (deve usar logger)... "
if [ -n "$STAGED_FILES" ]; then
  CONSOLE_LOGS=$(echo "$STAGED_FILES" | grep -v 'logger\|test\|spec\|__test' | \
    xargs grep -lnE 'console\.(log|warn|error|debug)\(' 2>/dev/null || true)
  
  if [ -n "$CONSOLE_LOGS" ]; then
    echo -e "${YELLOW}ALERTA${NC}"
    echo "$CONSOLE_LOGS" | sed 's/^/    ⚠️ /'
  else
    echo -e "${GREEN}OK${NC}"
  fi
else
  echo -e "${GREEN}OK${NC}"
fi

# ═══════════════════════════════════════════════
# CHECK 5: TODO/FIXME de segurança
# ═══════════════════════════════════════════════
echo -n "  [5/6] TODOs de segurança... "
if [ -n "$STAGED_FILES" ]; then
  SECURITY_TODOS=$(echo "$STAGED_FILES" | xargs grep -lnEi \
    'TODO.*security|FIXME.*auth|HACK.*bypass|TEMPORARY.*disable' \
    2>/dev/null || true)
  
  if [ -n "$SECURITY_TODOS" ]; then
    echo -e "${YELLOW}ALERTA${NC}"
    echo "$SECURITY_TODOS" | sed 's/^/    ⚠️ /'
  else
    echo -e "${GREEN}OK${NC}"
  fi
else
  echo -e "${GREEN}OK${NC}"
fi

# ═══════════════════════════════════════════════
# CHECK 6: .env commitado acidentalmente
# ═══════════════════════════════════════════════
echo -n "  [6/6] .env no staging... "
if git diff --cached --name-only | grep -qE '^\.env$|^\.env\.local$|^\.env\.production'; then
  echo -e "${RED}FALHOU${NC}"
  echo "    ❌ Arquivo .env está no staging! Remova com: git reset HEAD .env"
  ERRORS=$((ERRORS + 1))
else
  echo -e "${GREEN}OK${NC}"
fi

# ═══════════════════════════════════════════════
# RESULTADO
# ═══════════════════════════════════════════════
echo ""
if [ $ERRORS -gt 0 ]; then
  echo -e "${RED}❌ $ERRORS erro(s) de segurança encontrado(s). Commit bloqueado.${NC}"
  echo "   Corrija os problemas acima e tente novamente."
  exit 1
else
  echo -e "${GREEN}✅ Validação de segurança passou.${NC}"
fi
```

---

## Script: check-rls.sh

```bash
#!/bin/bash
# scripts/check-rls.sh
echo -n "  Verificando RLS em SQL... "
if grep -qE 'DISABLE ROW LEVEL|USING \(true\)|WITH CHECK \(true\)' "$@" 2>/dev/null; then
  echo "❌ RLS desabilitado ou policy permissiva detectada!"
  grep -nE 'DISABLE ROW LEVEL|USING \(true\)|WITH CHECK \(true\)' "$@"
  exit 1
fi
echo "✅ OK"
```

---

## Script: check-env-secrets.sh

```bash
#!/bin/bash
# scripts/check-env-secrets.sh
echo -n "  Verificando .env... "
if grep -qE 'sk_live_|sk-[a-zA-Z0-9]{20,}|password\s*=\s*[^.]' "$@" 2>/dev/null; then
  echo "❌ Possíveis secrets reais detectados no .env!"
  echo "   Use placeholders: SUA_SENHA_AQUI, sk_test_..."
  exit 1
fi
echo "✅ OK"
```

---

## Tornando Scripts Executáveis

```bash
chmod +x scripts/security-pre-commit.sh
chmod +x scripts/check-rls.sh
chmod +x scripts/check-env-secrets.sh
chmod +x .husky/pre-commit
```
