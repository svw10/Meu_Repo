---
name: verificando_conclusao
framework: "Antigravity OS v3.1"
owner_agent: DELTA
trigger: "/audit"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: verificando-conclusao
description: Auditor de Qualidade (QA). Valida entregas contra critérios originais via evidências objetivas. Define Definition of Done (DoD) para Stack Omega.
version: 3.0.1
tags: [qa, testing, validation, dod, entrega, verificacao]
---

# 05 - VERIFICANDO CONCLUSÃO (Quality Assurance Protocol)

## 🎯 Quando usar
- **Sempre** após `03_executando_planos` terminar, antes de declarar "pronto"
- Quando o agente acredita que terminou, mas precisa provar objetivamente
- Para garantir que deploy está acessível e estado é consistente
- **Antes de marcar qualquer tarefa como "concluída"**

> **Regra Obrigatória**: Executado ≠ Entregue. Só é "Feito" se for **Verificável**.

## 🧱 Stack Omega (Validações Prioritárias)

| Camada | Comando de Validação | Critério de Aceite |
|:---|:---|:---|
| **Types** | `npx tsc --noEmit` | Zero erros TypeScript strict |
| **Build** | `npm run build` | Build limpo, sem warnings críticos |
| **Lint** | `npm run lint` | Zero erros ESLint |
| **Testes** | `npm run test` | Todos passando (se existirem) |
| **Schema** | `npx drizzle-kit check` | Migrations sincronizadas |
| **URL** | `curl -s http://localhost:3000` | HTTP 200, tempo < 2s |
| **API** | `curl -s http://localhost:3000/api/health` | JSON válido, status: ok |
| **Inngest** | Dashboard `localhost:8288` | Functions registradas, sem erros |
| **Banco** | `psql $DATABASE_URL -c "SELECT 1"` | Conexão < 100ms |

> Se qualquer camada falhar → **REPROVADO**. Corrija via `04_solucionando_erros`.

## ⚙️ Fluxo de Trabalho (Auditoria)

### Passo 1: Recuperação de Critérios (2 min)
- [ ] Ler `docs/PLAN-[nome].md` original
- [ ] Extrair "Critérios de Sucesso" definidos
- [ ] Listar checkpoints obrigatórios por camada

**Template de Captura:**
```markdown
Critérios do Plano:
- [ ] [Critério 1 do PLAN]
- [ ] [Critério 2 do PLAN]

Camadas a validar:
- [ ] Build (types + compile)
- [ ] Acesso (URL/API)
- [ ] Dados (schema + migrations)
- [ ] Lógica (funcionalidade)
- [ ] Edge Cases (limites)
```

### Passo 2: Validação Técnica (5 min)
Executar sequência obrigatória:

```bash
#!/bin/bash
# validate_delivery.sh - Script de validação rápida

echo "🔍 Validação de Entrega - Stack Omega"

# 1. Types
echo "1. TypeScript strict..."
npx tsc --noEmit || exit 1

# 2. Build
echo "2. Build..."
npm run build || exit 1

# 3. Schema
echo "3. Database schema..."
npx drizzle-kit check || exit 1

# 4. URL
echo "4. Smoke test..."
curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200" || exit 1

# 5. API Health
echo "5. API health..."
curl -s http://localhost:3000/api/health | grep -q "ok" || exit 1

echo "✅ Todas as camadas validadas"
```

### Passo 3: Teste de Casos Limite (3 min)
- [ ] **Caso vazio**: Input vazio/nulo → comportamento esperado?
- [ ] **Caso inválido**: Dados inválidos → erro amigável?
- [ ] **Caso de erro**: API externa lenta → timeout/ retry?
- [ ] **Caso de carga**: Volume maior → performance aceitável?

**Exemplos de validação mental:**
- Usuário negar permissão → App mostra erro amigável?
- Banco lento → Timeout configurado ou retry?
- API externa cair → Fallback ou mensagem clara?

### Passo 4: Veredito e Documentação (5 min)
- [ ] Comparar critérios originais vs realidade
- [ ] Gerar `docs/QA-[nome].md` com template
- [ ] Decisão binária: **🟢 Aprovado** ou **🔴 Reprovado**
- [ ] Se **Aprovado**: Notificar usuário com evidências
- [ ] Se **Reprovado**: Acionar `04_solucionando_erros` com relatório

## 📋 Definition of Done (DoD) - Stack Omega

O que significa "Concluído" neste sistema:

### DoD Técnico (Obrigatório)
- [ ] **Build limpo**: `npm run build` passa sem erros
- [ ] **Types strict**: `npx tsc --noEmit` zero erros
- [ ] **Lint**: `npm run lint` zero erros críticos
- [ ] **Schema**: `npx drizzle-kit check` sincronizado
- [ ] **Testes**: `npm run test` passa (se existirem)

### DoD Funcional (Obrigatório)
- [ ] **Critérios do PLAN**: Todos atendidos com evidências
- [ ] **Smoke test**: URL responde HTTP 200
- [ ] **API health**: Endpoint `/api/health` retorna ok
- [ ] **Edge cases**: Mínimo 2 cenários de limite testados
- [ ] **Rollback test**: Se falhar, sabe-se como reverter

### DoD Documentação (Obrigatório)
- [ ] **QA Report**: `docs/QA-[nome].md` preenchido
- [ ] **Evidências**: Screenshots/URLs de comprovação
- [ ] **CHANGELOG**: Atualizado se necessário
- [ ] **README**: Atualizado se necessário

> **Se qualquer item acima estiver faltando → NÃO está concluído.**

## 📄 Template QA Report

**Arquivo:** `docs/QA-[nome].md`

```markdown
# QA Report: [Nome da Feature]
**Data:** YYYY-MM-DD HH:MM  
**Status:** [🟢 Aprovado / 🔴 Reprovado]  
**Plano:** `docs/PLAN-[nome].md`  
**Executor:** `03_executando_planos`  
**Auditor:** `05_verificando_conclusao`

---

## 1. Resumo Executivo

**Veredito:** [Aprovado/Reprovado para produção]

**Justificativa em uma frase:** [Por que passou ou falhou]

---

## 2. Validação Técnica (Stack Omega)

| Camada | Comando | Resultado | Status |
|:---|:---|:---|:---:|
| Types | `npx tsc --noEmit` | [Saída] | [✅/❌] |
| Build | `npm run build` | [Tempo/erros] | [✅/❌] |
| Schema | `npx drizzle-kit check` | [Status] | [✅/❌] |
| Lint | `npm run lint` | [Erros] | [✅/❌] |
| Testes | `npm run test` | [Passou/X falhas] | [✅/❌/⏭️] |

**Legenda:** ✅ Passou | ❌ Falhou | ⏭️ Pulado (não aplica)

---

## 3. Validação Funcional

### Critérios do Plano vs Realidade

| ID | Critério Original | Evidência | Status |
|:---|:---|:---|:---:|
| 1 | [Critério do PLAN] | [Screenshot/URL/Log] | [✅/❌] |
| 2 | [Critério do PLAN] | [Screenshot/URL/Log] | [✅/❌] |

### Smoke Tests
- [ ] URL principal (`/`) responde 200
- [ ] API health (`/api/health`) responde ok
- [ ] Inngest dashboard sem erros
- [ ] Banco responde < 100ms

### Edge Cases Testados
- [ ] **Caso vazio**: [Descrição] → [Resultado]
- [ ] **Caso inválido**: [Descrição] → [Resultado]
- [ ] **Caso de erro**: [Descrição] → [Resultado]

---

## 4. Evidências

### Screenshots/Logs
```
[Cole screenshots ou links para evidências visuais]
```

### Comandos de Validação
```bash
# Comando que prova que funciona
curl -s http://localhost:3000/api/health | jq .
```

---

## 5. Casos de Falha (Se Reprovado)

### Bloqueadores Identificados
1. **[Título]**: [Descrição da falha]
   - **Impacto:** [Crítico/Médio/Baixo]
   - **Como reproduzir:** [Passos]
   - **Próximo passo:** [Ação recomendada]

### Tentativas de Correção
- [ ] Tentativa 1: [Ação] → [Resultado]
- [ ] Tentativa 2: [Ação] → [Resultado]

---

## 6. Próximos Passos

### Se Aprovado:
- [ ] Merge para branch principal
- [ ] Deploy em produção
- [ ] Monitoramento pós-deploy (24h)

### Se Reprovado:
- [ ] Corrigir bloqueadores via `04_solucionando_erros`
- [ ] Re-executar `03_executando_planos` (passos afetados)
- [ ] Re-executar `05_verificando_conclusao`

---

**Assinatura:**  
Auditor: [Nome do Agente]  
Data: [YYYY-MM-DD]  
Commit: [Hash do último commit validado]
```

## 🛠️ Scripts (RECURSOS/scripts/)

### validate_delivery.sh
```bash
#!/bin/bash
# Validação completa de entrega - Stack Omega

set -e  # Falha em qualquer erro

PLAN_FILE="${1:-docs/PLAN-latest.md}"
QA_FILE="${2:-docs/QA-$(date +%Y%m%d-%H%M%S).md}"

echo "🔍 Iniciando validação de entrega..."
echo "Plano: $PLAN_FILE"
echo "QA Report: $QA_FILE"

# 1. Verificar se plano existe
if [ ! -f "$PLAN_FILE" ]; then
    echo "❌ Plano não encontrado: $PLAN_FILE"
    exit 1
fi

# 2. Types
echo -e "\n📋 1. TypeScript strict mode..."
if npx tsc --noEmit; then
    echo "   ✅ Types OK"
    TYPES_STATUS="✅"
else
    echo "   ❌ Types falhou"
    TYPES_STATUS="❌"
    exit 1
fi

# 3. Build
echo -e "\n🔨 2. Build..."
if npm run build 2>&1 | tail -20; then
    echo "   ✅ Build OK"
    BUILD_STATUS="✅"
else
    echo "   ❌ Build falhou"
    BUILD_STATUS="❌"
    exit 1
fi

# 4. Schema
echo -e "\n🗄️ 3. Database schema..."
if npx drizzle-kit check 2>&1 | grep -q "No issues"; then
    echo "   ✅ Schema OK"
    SCHEMA_STATUS="✅"
else
    echo "   ⚠️ Schema pode ter divergências"
    SCHEMA_STATUS="⚠️"
fi

# 5. Lint
echo -e "\n🧹 4. Lint..."
if npm run lint 2>&1 | tail -10; then
    echo "   ✅ Lint OK"
    LINT_STATUS="✅"
else
    echo "   ❌ Lint falhou"
    LINT_STATUS="❌"
fi

# 6. Smoke test (se servidor rodando)
echo -e "\n🌐 5. Smoke test..."
if curl -s -o /dev/null -w "%{http_code}" http://localhost:3000 | grep -q "200"; then
    echo "   ✅ URL responde 200"
    URL_STATUS="✅"
else
    echo "   ⚠️ URL não responde (servidor pode estar parado)"
    URL_STATUS="⚠️"
fi

# 7. Gerar QA Report básico
cat > "$QA_FILE" << EOF
# QA Report: $(basename "$PLAN_FILE" .md | sed 's/PLAN-//')
**Data:** $(date -Iseconds)
**Status:** 🟡 Validação Automática
**Plano:** $PLAN_FILE

## Validação Técnica

| Camada | Status |
|:---|:---:|
| Types | $TYPES_STATUS |
| Build | $BUILD_STATUS |
| Schema | $SCHEMA_STATUS |
| Lint | $LINT_STATUS |
| URL | $URL_STATUS |

## Resumo

- **Build:** $([ "$BUILD_STATUS" = "✅" ] && echo "Passou" || echo "Falhou")
- **Types:** $([ "$TYPES_STATUS" = "✅" ] && echo "Passou" || echo "Falhou")

**Status Geral:** $([ "$BUILD_STATUS" = "✅" ] && [ "$TYPES_STATUS" = "✅" ] && echo "🟢 Aprovado para revisão manual" || echo "🔴 Reprovado - corrigir falhas")

**Próximo passo:** Revisar critérios funcionais do plano e completar seção 3 deste relatório.
EOF

echo -e "\n✅ Validação técnica concluída"
echo "📄 QA Report gerado: $QA_FILE"

if [ "$BUILD_STATUS" = "✅" ] && [ "$TYPES_STATUS" = "✅" ]; then
    echo -e "\n🟢 APROVADO para revisão manual"
    exit 0
else
    echo -e "\n🔴 REPROVADO - corrigir falhas técnicas"
    exit 1
fi
```

### check_criteria.py
```python
#!/usr/bin/env python3
"""
Verifica se critérios específicos do plano foram atendidos.
Uso: python check_criteria.py docs/PLAN-feature.md
"""

import re
import sys
from pathlib import Path

def extract_criteria(plan_file: str):
    """Extrai critérios do arquivo de plano."""
    content = Path(plan_file).read_text()
    
    # Padrão: critérios de sucesso ou checkboxes em seções específicas
    patterns = [
        r'- \[ \] \*\*(.+?)\*\*',  # - [ ] **Critério**
        r'- \[ \] (.+?)(?=\n|$)',   # - [ ] Critério simples
        r'Critério de (?:Sucesso|Aceite):?\s*\n\s*- (.+?)(?=\n\n|\n##|$)',  # Seção formal
    ]
    
    criteria = []
    for pattern in patterns:
        matches = re.findall(pattern, content, re.MULTILINE | re.IGNORECASE)
        criteria.extend(matches)
    
    return list(set(criteria))  # Remove duplicatas

def main():
    if len(sys.argv) < 2:
        print("Uso: python check_criteria.py <arquivo-plan.md>")
        sys.exit(1)
    
    plan_file = sys.argv[1]
    criteria = extract_criteria(plan_file)
    
    print(f"📋 Critérios encontrados em {plan_file}:")
    print(f"   Total: {len(criteria)} critérios\n")
    
    for i, c in enumerate(criteria, 1):
        print(f"   {i:2d}. [ ] {c[:60]}...")
    
    print(f"\n   Use este checklist para validação manual:")
    print(f"   Copie para seu QA Report e marque conforme valida.")

if __name__ == "__main__":
    main()
```

## 🚫 Anti-Padrões

- ❌ Declarar "pronto" sem rodar validação técnica
- ❌ Ignorar warning de build ("só um warning")
- ❌ Pular edge cases ("funciona no caso normal")
- ❌ Não gerar QA Report
- ❌ Aprovar com critérios do plano pendentes
- ❌ "Quase pronto" (binário: Aprovado ou Reprovado)

## ✅ Checklist do Auditor

- [ ] PLAN original lido e critérios extraídos
- [ ] Validação técnica executada (types → build → schema → lint)
- [ ] Smoke test passou (URL responde)
- [ ] Edge cases testados (mínimo 2)
- [ ] QA Report gerado e preenchido
- [ ] Veredito binário tomado (🟢/🔴)
- [ ] Evidências anexadas (screenshots/logs)
- [ ] Próximos passos claros documentados

## 🔗 Integração

- **Chamada:** Direta pelo ROUTER (após `03_executando_planos`)
- **Pré-requisito:** `03_executando_planos` (execução concluída)
- **Próxima (Aprovado):** Notificar usuário, merge, deploy
- **Próxima (Reprovado):** `04_solucionando_erros` (correção)
- **Artefato:** `docs/QA-[nome].md`

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Stack Omega fixa (comandos específicos)
- Removida dependência de `project-context.json`
- Simplificada integração (ROUTER direto)
- Adicionado DoD estruturado (Técnico + Funcional + Documentação)
- Scripts movidos para RECURSOS/
- Adicionado `validate_delivery.sh` (validação completa)

### v3.0.0 (Original)
- Conceito de DoD agnóstico
- Validação por camadas
- Scripts de automação
- Relatório QA estruturado
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
