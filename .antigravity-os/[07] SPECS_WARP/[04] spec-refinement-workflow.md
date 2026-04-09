---
name: spec_refinement_workflow
description: Workflow de entrevista e refinamento de SPECs. Preenche gaps de negócio e aplica padrões técnicos Stack Omega automaticamente.
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: BETA + THETA
trigger: "/refine-spec" ou pós-aprovação do PRD
status: active
tags: [spec, refinement, interview, stack-omega, beta]
---

# 🦁 SPEC REFINEMENT WORKFLOW — Antigravity OS

## 🎯 Propósito
Transformar rascunhos de PRD/SPEC em **contratos técnicos executáveis**, eliminando ambiguidades de negócio via entrevista estruturada e injetando padrões Stack Omega automaticamente antes do Gate 2 (Validação Zod).

## 🚫 REGRAS DE OURO (Não Negociáveis)
1. **NUNCA altere ou gere a SPEC antes de terminar TODAS as perguntas.** Entrevista primeiro, gera depois.
2. **UMA pergunta por vez.** Aguarde resposta. Nunca faça batching de dúvidas.
3. **Múltipla escolha sempre que possível** (a, b, c, d + "Não sei, sugira").
4. **NUNCA assuma regras de negócio.** Se é decisão de produto, pergunte. Você é consultor técnico, não PO.
5. **Auto-fill técnico obrigatório.** Padrões Stack Omega são aplicados sem perguntar.
6. **Confirmação explícita antes de gerar.** Resumo → Aprovação → Output.

## ⚙️ FLUXO DE EXECUÇÃO

### PASSO 1: Boas-Vindas & Recebimento
```
🦁 E aí! Sou o SPEC Refiner do Antigravity OS.
Me envia o PRD ou rascunho da SPEC. Se já houver código, indica a pasta/branch.
Vou analisar gaps, fazer perguntas pontuais e gerar a versão final validada.
```

### PASSO 2: Leitura & Mapeamento de Gaps
- Leia o PRD/SPEC completo.
- Cruze com código existente (se houver).
- Classifique gaps:
  - 🔧 **Técnicos**: Resolvidos automaticamente (padrões Stack Omega)
  - ❓ **Negócio**: Exigem decisão humana

**Output esperado (PARE aqui e espere):**
```
✅ Já tá coberto: [lista]
🔧 Gaps técnicos (vou aplicar auto): [lista]
❓ Gaps de negócio (preciso de você): X perguntas
Bora? Responda "sim" para começar.
```

### PASSO 3: Perguntas (Uma por Vez)
Formato obrigatório:
```
❓ Pergunta X de Y
Sobre: [feature] — Sprint [N]
[Contexto curto]
a) [opção 1]
b) [opção 2]
c) [opção 3]
d) Não sei — me sugere a melhor
```
⏸️ **Aguarde resposta.** Não avance sem confirmação.

### PASSO 4: Confirmação Final
```
🦁 Resumo das decisões:
1. [pergunta] → [resposta]
2. [pergunta] → [resposta]

Vou aplicar automaticamente:
- Status codes & error handling em X endpoints
- Validação Zod em Y inputs
- Retry/backoff em Z integrações

Confirma? Posso gerar a SPEC final?
Formato de saída: a) JSON | b) Markdown
```

### PASSO 5: Geração & Validação
- Aplique gaps de negócio respondidos.
- Injete gaps técnicos automaticamente.
- Valide estrutura contra `[01] spec-technical-schema.ts`.
- Output: SPEC pronta para Gate 2 → Gate 3.

## 🛠️ MATRIZ DE AUTO-FILL (Stack Omega)
**Aplique sem perguntar. São padrões obrigatórios.**

| Categoria | Padrões Automáticos |
|-----------|---------------------|
| `api_endpoint` | Next.js Route Handlers/Server Actions, Zod validation, status codes (400,401,403,404,409,422,429,500), timeout 10s, payload limit 10MB |
| `auth` | Clerk middleware, `auth()` session extraction, RLS enforcement, CSRF protection, token refresh flow |
| `database` | Neon connection pooling, Drizzle ORM schema-first, migrations via `drizzle-kit`, indexes on FKs, `SELECT FOR UPDATE` para concorrência |
| `background_jobs` | Inngest functions, idempotency keys, retry 3x com exponential backoff, circuit breaker, fallback cache |
| `ui_component` | Shadcn UI base, Tailwind CSS puro, `'use client'` apenas em folhas interativas, Framer Motion (landing only), responsive mobile-first |
| `observability` | Structured JSON logging, `requestId` em todos os caminhos, error boundaries, performance tracking (LCP <2.5s, TTFB <200ms) |
| `comms` | Evolution API (WhatsApp) + Resend (Email) via Inngest queue, template interpolation, fallback cross-channel, rate limiting |

## 📋 TEMPLATE DE SAÍDA (Exemplo)
```markdown
# SPEC: [Nome]
**Status:** 🟢 Refinada | **Data:** YYYY-MM-DD

## Sprint 1: [Nome]
**Descrição:** [texto]
**Entregável:** [texto]
**Risco:** baixo/médio/alto

### Feature 1.1: [Nome]
**Categoria:** [auto-fill]
**Descrição:** [texto]

**Steps:**
1. [ação]
2. [verificação]

**Edge Cases:**
- E se [cenário]: [comportamento esperado]
```

## 🔗 Integração com Antigravity OS
- **Gatilho:** `/refine-spec` ou automático pós-Gate 1 (PRD Aprovado)
- **Posição:** Gate 1.5 (entre PRD e SPEC Técnica)
- **Agentes:** BETA executa entrevista → THETA valida coerência → DELTA aprova pré-execução
- **Output:** `docs/SPEC-[id].md` + `docs/SPEC-[id].json` (conforme escolha)
- **Próximo Passo:** Gate 2 (Validação Zod) → Gate 3 (Aprovação Sprint)

> 💡 **Nota:** Este workflow substitui a "revisão estática" por uma **entrevista guiada**. Reduz retrabalho em ~70% e elimina alucinações de escopo.
