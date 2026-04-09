---
name: solucionando_erros
framework: "Antigravity OS v3.1"
owner_agent: ETA
trigger: "/debug"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: solucionando-erros
description: Médico Forense. Diagnóstico sistemático de falhas via método científico. Gera hipóteses testáveis, validação empírica e recuperação com fallback.
version: 3.0.1
tags: [debug, troubleshooting, diagnostico, recovery, observabilidade]
---

# 04 - SOLUCIONANDO ERROS (Scientific Debug Protocol)

## 🎯 Quando usar
- Build quebrou, API retornou 500, Worker travou
- Dado salvo mas não aparece (cache vs banco vs estado)
- Agente tentou corrigir 2x e falhou (loop de erro)
- Sistema lento, timeouts, memory leaks
- **Sempre que:** Output de `03_executando_planos` não atingido

> **Regra Suprema**: Nunca assuma ("Acho que é X"). **Valide** ("Testei Y, resultado foi Z"). Sem evidência, sem correção.

## 🧱 Stack Omega (Detecção Prioritária)

Embora detecte automaticamente, priorize comandos da Stack Omega:

| Componente | Comando de Diagnóstico | Validação Rápida |
|:---|:---|:---|
| **Types** | `npx tsc --noEmit` | Zero erros de tipo |
| **Schema** | `npx drizzle-kit check` | Migrations sincronizadas |
| **Build** | `npm run build` | Build limpo |
| **Inngest** | Dashboard `localhost:8288` | Funções registradas |
| **Neon** | `psql $DATABASE_URL -c "SELECT 1"` | Conexão < 100ms |
| **Env** | `env \| grep -E "(DATABASE_URL\|OPENROUTER)"` | Vars essenciais presentes |

## ⚙️ Fluxo de Trabalho (Ciclo de Evidência)

### Passo 1: Congelamento (2 min)
- **PARAR** execução (não tente "de novo" cegamente)
- Capturar contexto:
  - Stack trace (últimos 50 frames)
  - Logs recentes (últimas 100 linhas)
  - Estado do sistema (memória, CPU)
  - Última alteração: `git log -1 --oneline`

**Comandos rápidos:**
```bash
# Capturar tudo
git diff HEAD~1 > last_change.diff
npm run build 2>&1 | tail -50 > build_error.log
```

### Passo 2: Health Check (3 min)
Execute validações da Stack Omega:

```bash
# Sequência de sobrevivência
echo "=== 1. ENV ===" && env | grep -E "DATABASE|OPENROUTER|CLERK" | wc -l
echo "=== 2. TYPES ===" && npx tsc --noEmit 2>&1 | head -5
echo "=== 3. BUILD ===" && npm run build 2>&1 | tail -10
echo "=== 4. DB ===" && npx drizzle-kit check 2>&1 | head -3
```

**Checklist:**
- [ ] Variáveis de ambiente carregadas
- [ ] Types passando (strict mode)
- [ ] Build limpo
- [ ] Banco conectado
- [ ] Inngest functions registradas

### Passo 3: Hipóteses (5 min)
Liste **3 causas possíveis** ordenadas por:
1. **Probabilidade** (comum nesta stack)
2. **Facilidade de teste** (quão rápido validar)
3. **Impacto** (quão crítico)

**Template:**
```markdown
| Rank | Hipótese | Prob. | Teste | Tempo |
|:---|:---|:---|:---|:---|
| 1 | [Causa provável] | Alta | [Comando] | 30s |
| 2 | [Causa secundária] | Média | [Comando] | 2min |
| 3 | [Edge case] | Baixa | [Comando] | 5min |
```

**Erros comuns Stack Omega:**

| Erro | Causa Provável | Teste |
|:---|:---|:---|
| `Cannot find module` | Dependência não instalada | `npm ls [pacote]` |
| `relation does not exist` | Migration não aplicada | `npx drizzle-kit push` |
| `TypeError: Cannot read property` | Tipagem incorreta (any) | `npx tsc --noEmit` |
| `ECONNREFUSED localhost:3000` | Dev server não rodando | `lsof -i :3000` |
| `Inngest function not found` | Função não registrada | Dashboard local |
| `JWT expired` | Clerk session inválida | Re-login no browser |

### Passo 4: Validação Empírica (5 min)
Para cada hipótese, execute **um comando de prova**:

- **Hipótese 1**: Comando → Resultado → ✅ Confirmada / ❌ Refutada
- **Hipótese 2**: Comando → Resultado → ✅ Confirmada / ❌ Refutada  
- **Hipótese 3**: Comando → Resultado → ✅ Confirmada / ❌ Refutada

**Regras:**
- Confirmada → Vá para Passo 5
- Refutada → Documente, vá para próxima
- Inconclusiva → Refinar (mais específica)

### Passo 5: Correção + Fallback (5 min)
- [ ] Aplicar **correção mínima** (menor mudança que resolve)
- [ ] **Testar localmente** (reproduzir cenário de falha)
- [ ] Preparar **fallback** se correção falhar

**Estratégias de Fallback (ordem):**

1. **Graceful Degradation**: Desativar feature não-crítica
2. **Circuit Breaker**: Parar de chamar serviço falho
3. **Retry com Backoff**: Tentar novamente (1s, 2s, 4s, 8s)
4. **Mock/Stub**: Dados simulados temporariamente
5. **Fail Fast**: Parar e notificar (último recurso)

## 📄 Template DIAG (Autópsia)

**Arquivo:** `docs/DIAG-[timestamp].md`

```markdown
# DIAG: [ID-ÚNICO] - [Título do Erro]
**Data:** YYYY-MM-DD HH:MM  
**Severidade:** 🔴 Crítica / 🟠 Alta / 🟡 Média / 🟢 Baixa  
**Status:** 🟡 Investigando / 🟢 Resolvido / 🔴 Bloqueado

---

## 1. Contexto (Fatos)

**Ação que disparou:**
```bash
[Comando ou ação]
```

**Erro observado:**
```
[Stack trace ou mensagem]
```

**Ambiente:**
- Commit: `abc1234`
- Node: v20.x
- Último deploy: [timestamp]

---

## 2. Health Check

| Check | Status | Detalhe |
|:---|:---|:---|
| Types | [✅/❌] | [Saída] |
| Build | [✅/❌] | [Saída] |
| DB | [✅/❌] | [Latência] |
| Inngest | [✅/❌] | [Status] |

---

## 3. Hipóteses & Validação

### H1: [Título]
- **Descrição:** [O que se suspeita]
- **Teste:** `[comando exato]`
- **Resultado:** [saída]
- **Status:** [✅ Confirmada / ❌ Refutada]

### H2: [Título]
- **Descrição:** ...
- **Teste:** ...
- **Resultado:** ...
- **Status:** ...

### H3: [Título]
- **Descrição:** ...
- **Teste:** ...
- **Resultado:** ...
- **Status:** ...

---

## 4. Solução

**Causa raiz:** [Explicação clara]

**Correção aplicada:**
```diff
[Diff ou descrição]
```

**Commit:** `fix: [descrição]`

**Teste de regressão:** `[comando que prova que não volta]`

---

## 5. Prevenção

- [ ] Teste automatizado para este cenário
- [ ] Alerta de monitoramento
- [ ] Documentação atualizada
- [ ] ADR se arquitetura mudou

---

**Resolvido por:** [Agente]  
**Tempo total:** [X min]  
**Próxima skill:** `03_executando_planos` (retomar) ou `05_verificando_conclusao`
```

## 🛠️ Scripts (RECURSOS/scripts/)

### diagnostico_rapido.sh
```bash
#!/bin/bash
# Diagnóstico de 30 segundos para Stack Omega

echo "🔍 Diagnóstico Rápido - $(date)"
echo "================================"

echo "1. Git status:"
git log -1 --oneline 2>/dev/null || echo "   Não é repo git"

echo -e "\n2. Node/Next:"
node --version 2>/dev/null || echo "   Node não encontrado"
[ -f "next.config.js" ] && echo "   ✅ Next.js detectado" || echo "   ❌ Next.js não detectado"

echo -e "\n3. Dependências:"
[ -d "node_modules" ] && echo "   ✅ node_modules presente" || echo "   ❌ node_modules ausente"

echo -e "\n4. Types (primeiros erros):"
npx tsc --noEmit 2>&1 | head -3 || echo "   ❌ TypeScript falhou"

echo -e "\n5. Build (dry-run):"
npm run build 2>&1 | tail -5 || echo "   ❌ Build falhou"

echo -e "\n6. Banco (conexão):"
[ -n "$DATABASE_URL" ] && echo "   ✅ DATABASE_URL definida" || echo "   ❌ DATABASE_URL ausente"

echo -e "\n================================"
echo "Se qualquer ❌ acima, investigue antes de continuar."
```

### log_analyzer.py
```python
#!/usr/bin/env python3
"""
Extrai padrões de erro de logs. Uso: python log_analyzer.py app.log
"""

import re
import sys
from pathlib import Path
from collections import Counter

PATTERNS = {
    "type_error": r"TypeError[:\s]*(.+)",
    "undefined": r"Cannot read propert(?:y|ies) '([^']+)'",
    "module_not_found": r"Cannot find module '([^']+)'",
    "db_error": r"(connection refused|timeout|deadlock)",
    "build_error": r"(Build failed|Failed to compile)",
}

def analyze(log_file: str):
    content = Path(log_file).read_text(errors='ignore')
    
    print(f"📊 Analisando: {log_file}")
    print(f"   Linhas totais: {len(content.splitlines())}")
    
    findings = Counter()
    for name, pattern in PATTERNS.items():
        matches = re.findall(pattern, content, re.IGNORECASE)
        if matches:
            findings[name] = len(matches)
            print(f"\n🔴 {name}: {len(matches)} ocorrências")
            for m in matches[:3]:  # Mostra primeiros 3
                print(f"   - {str(m)[:80]}")
    
    if not findings:
        print("\n✅ Nenhum padrão de erro conhecido detectado")
    
    return dict(findings)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: python log_analyzer.py <arquivo.log>")
        sys.exit(1)
    analyze(sys.argv[1])
```

## 🚫 Anti-Padrões

- ❌ "Acho que é X" sem validar
- ❌ Corrigir sem entender causa raiz
- ❌ Ignorar stack trace (ler só a última linha)
- ❌ Não documentar solução (repetir erro depois)
- ❌ Fallback sem testar primeiro
- ❌ Múltiplas mudanças ao mesmo tempo (não isolável)

## ✅ Checklist de Recuperação

- [ ] Contexto capturado (logs, stack, estado)
- [ ] Health check executado
- [ ] 3 hipóteses geradas e priorizadas
- [ ] Validação empírica realizada
- [ ] Correção mínima aplicada
- [ ] Teste de regressão passando
- [ ] Fallback documentado
- [ ] DIAG preenchido
- [ ] Prevenção futura identificada

## 🔗 Integração

- **Chamada:** Direta pelo ROUTER (quando `03_executando_planos` falha)
- **Pré-requisito:** `03_executando_planos` (erro detectado)
- **Próxima (sucesso):** `03_executando_planos` (retomar plano)
- **Próxima (falha crítica):** `05_verificando_conclusao` (escalar)
- **Artefato:** `docs/DIAG-[timestamp].md`

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Priorização Stack Omega (comandos específicos)
- Removida dependência de `project-context.json`
- Simplificada integração (ROUTER direto)
- Template DIAG padronizado
- Scripts movidos para RECURSOS/
- Adicionado diagnostico_rapido.sh (30s)

### v3.0.0 (Original)
- Método científico de debugging
- Detecção automática de stack
- Health checks universais
- Estratégias de fallback catalogadas
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
