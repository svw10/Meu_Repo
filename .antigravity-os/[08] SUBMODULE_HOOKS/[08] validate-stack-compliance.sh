#!/bin/bash
# [08] VALIDATE STACK COMPLIANCE — Varredura de conformidade arquitetônica
# Valida ADRs machine-readable de .antigravity-os/[10] DECISIONS/
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[08] validate-stack-compliance.sh [projeto_path]
# Exemplo: bash .antigravity-os/[08] SUBMODULE_HOOKS/[08] validate-stack-compliance.sh /path/to/myproject

set -e

PROJECT_PATH="${1:-.}"  # Default: diretório atual
DECISIONS_PATH="$(dirname "$0")/../[10] DECISIONS"
VIOLATIONS=0
WARNINGS=0

echo "🏗️  Antigravity OS — Stack Compliance Validator"
echo "📁 Projeto: $PROJECT_PATH"
echo "📋 ADRs: $DECISIONS_PATH"
echo "────────────────────────────────────────────────"

# ─── ADR-001: PostgreSQL/Neon/Drizzle ────────────────────────────────────────
echo ""
echo "🔍 ADR-001: Database (PostgreSQL + Neon + Drizzle)"

# Verifica presença de drizzle-orm no package.json
if [ -f "$PROJECT_PATH/package.json" ]; then
  if ! grep -q "drizzle-orm" "$PROJECT_PATH/package.json"; then
    echo "  ❌ BLOQUEANTE: drizzle-orm não encontrado em package.json"
    VIOLATIONS=$((VIOLATIONS + 1))
  else
    echo "  ✅ drizzle-orm presente"
  fi

  if ! grep -q "@neondatabase/serverless" "$PROJECT_PATH/package.json"; then
    echo "  ⚠️  AVISO: @neondatabase/serverless não encontrado (pode usar pg direto)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  ✅ @neondatabase/serverless presente"
  fi

  # Verifica ORM proibidos
  for BANNED in "\"prisma\"" "\"@prisma/client\"" "\"mysql2\"" "\"sqlite3\"" "\"better-sqlite3\"" "\"mongoose\"" "\"typeorm\""; do
    if grep -q "$BANNED" "$PROJECT_PATH/package.json"; then
      echo "  ❌ BLOQUEANTE: Dependência proibida detectada: $BANNED (ADR-001)"
      VIOLATIONS=$((VIOLATIONS + 1))
    fi
  done

  # Verifica drizzle.config.ts
  if [ ! -f "$PROJECT_PATH/drizzle.config.ts" ] && [ ! -f "$PROJECT_PATH/drizzle.config.js" ]; then
    echo "  ⚠️  AVISO: drizzle.config.ts não encontrado"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  ✅ drizzle.config presente"
  fi
fi

# ─── ADR-002: TypeScript Strict ──────────────────────────────────────────────
echo ""
echo "🔍 ADR-002: TypeScript Strict Mode"

if [ -f "$PROJECT_PATH/tsconfig.json" ]; then
  if ! grep -q '"strict": true' "$PROJECT_PATH/tsconfig.json"; then
    echo "  ❌ BLOQUEANTE: TypeScript strict mode não ativo em tsconfig.json"
    VIOLATIONS=$((VIOLATIONS + 1))
  else
    echo "  ✅ strict: true configurado"
  fi
else
  echo "  ⚠️  AVISO: tsconfig.json não encontrado"
  WARNINGS=$((WARNINGS + 1))
fi

# Verifica uso de 'any' no código fonte
if [ -d "$PROJECT_PATH/src" ]; then
  ANY_COUNT=$(grep -rnE ": any|as any|<any>" "$PROJECT_PATH/src" --include="*.ts" --include="*.tsx" 2>/dev/null | grep -v "//.*any\|node_modules" | wc -l)
  if [ "$ANY_COUNT" -gt 0 ]; then
    echo "  ❌ BLOQUEANTE: $ANY_COUNT ocorrências de 'any' explícito no código"
    echo "     Use 'unknown' + Zod para validação estrutural (ADR-002)"
    VIOLATIONS=$((VIOLATIONS + 1))
  else
    echo "  ✅ Zero 'any' explícito no código fonte"
  fi

  # Verifica Zod
  if [ -f "$PROJECT_PATH/package.json" ] && ! grep -q '"zod"' "$PROJECT_PATH/package.json"; then
    echo "  ❌ BLOQUEANTE: Zod não encontrado — obrigatório para validação de entrada"
    VIOLATIONS=$((VIOLATIONS + 1))
  else
    echo "  ✅ Zod presente"
  fi
fi

# ─── ADR-003: Autenticação Clerk ─────────────────────────────────────────────
echo ""
echo "🔍 ADR-003: Autenticação (Clerk)"

if [ -f "$PROJECT_PATH/package.json" ]; then
  if ! grep -q "@clerk/nextjs" "$PROJECT_PATH/package.json"; then
    echo "  ⚠️  INFO: @clerk/nextjs não encontrado (pode ser projeto sem auth)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  ✅ @clerk/nextjs presente"
  fi

  # Verifica providers proibidos
  for BANNED in "\"next-auth\"" "\"lucia\"" "\"iron-session\"" "\"jsonwebtoken\"" "\"passport\""; do
    if grep -q "$BANNED" "$PROJECT_PATH/package.json"; then
      echo "  ❌ BLOQUEANTE: Provider de auth proibido: $BANNED (ADR-003)"
      VIOLATIONS=$((VIOLATIONS + 1))
    fi
  done

  # Verifica middleware
  if ! [ -f "$PROJECT_PATH/middleware.ts" ] && ! [ -f "$PROJECT_PATH/src/middleware.ts" ]; then
    if grep -q "@clerk/nextjs" "$PROJECT_PATH/package.json" 2>/dev/null; then
      echo "  ⚠️  AVISO: middleware.ts não encontrado (Clerk requer middleware)"
      WARNINGS=$((WARNINGS + 1))
    fi
  else
    echo "  ✅ middleware.ts presente"
  fi
fi

# ─── EXTRAS: Código proibido ──────────────────────────────────────────────────
echo ""
echo "🔍 Verificações extras (Stack Omega)"

if [ -d "$PROJECT_PATH/src" ]; then
  # console.log em produção
  CONSOLE_COUNT=$(grep -rnE "console\.log\(" "$PROJECT_PATH/src" --include="*.ts" --include="*.tsx" 2>/dev/null | grep -v "//\|logger\|test" | wc -l)
  if [ "$CONSOLE_COUNT" -gt 5 ]; then
    echo "  ⚠️  AVISO: $CONSOLE_COUNT console.log detectados. Use structured logging (logger.ts)"
    WARNINGS=$((WARNINGS + 1))
  else
    echo "  ✅ console.log em nível aceitável"
  fi

  # TODO/FIXME excessivos
  TODO_COUNT=$(grep -rnE "(TODO|FIXME|HACK|XXX):" "$PROJECT_PATH/src" 2>/dev/null | wc -l)
  if [ "$TODO_COUNT" -gt 10 ]; then
    echo "  ⚠️  AVISO: $TODO_COUNT TODOs/FIXMEs. Revise dívida técnica."
    WARNINGS=$((WARNINGS + 1))
  fi
fi

# ─── RESULTADO FINAL ──────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════"
echo "📊 RESULTADO DA VALIDAÇÃO DE COMPLIANCE"
echo "════════════════════════════════════════════════"
echo "  Violações BLOQUEANTES: $VIOLATIONS"
echo "  Avisos: $WARNINGS"
echo ""

if [ "$VIOLATIONS" -gt 0 ]; then
  echo "🛑 COMPLIANCE REPROVADO: $VIOLATIONS violação(ões) de ADR encontrada(s)"
  echo ""
  echo "📚 Referências:"
  echo "   ADRs: .antigravity-os/[10] DECISIONS/"
  echo "   Regras: Minhas_Rules/STACK_OMEGA_RULES.md"
  echo "   Ação: Notificar THETA e DELTA antes de continuar"
  exit 1
else
  echo "✅ COMPLIANCE APROVADO — Projeto segue os ADRs ativos"
  if [ "$WARNINGS" -gt 0 ]; then
    echo "⚠️  $WARNINGS aviso(s) não-bloqueante(s) para revisão"
  fi
  exit 0
fi
