---
name: planejando_solucoes
framework: "Antigravity OS v3.1"
owner_agent: BETA
trigger: "/plan"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: planejando-solucoes
description: Estrategista Técnico. Quebra demandas em Planos Atômicos (≤10min/passos) vinculados à Stack Omega. Garante rastreabilidade e critérios binários.
version: 3.0.1
tags: [planejamento, arquitetura, atomicidade, blueprint]
---

# 02 - PLANEJANDO SOLUÇÕES (Atomic Architecture)

## 🎯 Quando usar
- Usuário pede: "plano", "roadmap", "criar feature", "como fazer X"
- Tarefa envolve múltiplos sistemas (Banco + IA + Frontend)
- Para evitar "alucinação de código": só codar com plano aprovado
- **Sempre após** `01_brainstorming` ter gerado SPEC aprovado

> **Regra**: Sem SPEC → Não invoque esta skill. Volte para `01_brainstorming`.

## 🧱 Stack Omega (Imutável)

| Camada | Ferramenta | Uso no Plano |
|:---|:---|:---|
| **Frontend** | Next.js 14+ App Router | Server Actions, UI Components |
| **Dados** | Neon PostgreSQL + Drizzle | Schema, Migrations, Embeddings |
| **Orquestração** | Inngest | Filas, Cron Jobs, Step Functions |
| **Auth** | Clerk | Proteção de rotas, User ID |
| **AI/LLM** | OpenRouter + Vercel AI SDK | Embeddings, Geração de texto |
| **Comms** | Evolution API + Resend | WhatsApp, Email |
| **Storage** | Cloudflare R2 | Imagens, assets |
| **UI** | Tailwind + Shadcn/ui | Componentes, Temas |
| **Motion** | Framer Motion | Animações premium |

> **Stack Omega é non-negotiable**. Sem exceções sem ADR aprovado por BETA.

## 🧬 Filosofia: Atomicidade

### Regra dos 10 Minutos
Nenhuma etapa > 10 minutos de execução. Se for, quebre em sub-etapas.

### Critério Binário
Cada etapa precisa de definição clara de "Pronto" (Sim/Não).

### Validação Prévia
Etapas críticas (migrations, auth) devem ter comando de validação.

## ⚙️ Fluxo de Trabalho (4 Passos)

### Passo 1: Binding à Stack (5 min)
- Mapear cada necessidade à camada da Stack Omega
- Validar: "Esta ferramenta está na Stack Omega?"

**Checklist:**
- [ ] Objetivo final claro (KPI mensurável)
- [ ] Cada necessidade mapeada para camada
- [ ] Zero ferramentas fora da Stack Omega

### Passo 2: Arquitetura Técnica (10 min)
- **Schema**: Tabelas, campos, relações (Drizzle)
- **Eventos**: Filas Inngest, triggers
- **Rotas**: API endpoints, Server Actions
- **UI**: Componentes necessários

**Output:** Esquema textual da arquitetura.

### Passo 3: Decomposição Atômica (15 min)
Quebrar em passos numerados com:
- **Ação**: O que fazer (específico)
- **Critério**: Como saber que deu certo (binário)
- **Validação**: Comando/teste para verificar

**Exemplo:**
```
❌ Ruim: "Criar sistema de autenticação"
✅ Bom:
  1. Migration tabela users (5 min)
  2. Configurar Clerk no middleware (5 min)
  3. Criar componente LoginForm (10 min)
  4. Testar fluxo completo (5 min)
```

### Passo 4: Geração do Artefato (5 min)
- Preencher `docs/PLAN-[nome].md`
- Validar estrutura
- Marcar como pronto para `03_executando_codigo`

## 📋 Checklist de Entrega (DoD)

- [ ] Visão de Arquitetura (Schema + Eventos + Rotas + UI)
- [ ] Passos Atômicos numerados (com checkbox)
- [ ] Critério binário por passo
- [ ] Comando de validação por passo
- [ ] Riscos e Fallbacks identificados
- [ ] Tempo estimado total

## 🌍 Exemplos

### Exemplo: Sistema de Créditos (SnapFit)

**Contexto:** Controlar imagens geradas por lojista

**Arquitetura:**
- **Schema**: `tenants` (credits_included, credits_used, plan_type)
- **Evento**: `image.generation.requested` → consome crédito
- **UI**: Card de créditos no dashboard

**Plano Atômico:**

**Fase 1: Fundação**
1. [ ] **Migration: Campos de crédito**
   - Ação: Alterar `src/db/schema/tenants.ts`, adicionar 3 campos
   - Critério: `npx drizzle-kit push` executa sem erro
   - Validação: Ver no Neon Console que colunas existem

2. [ ] **Server Action: Consumir crédito**
   - Ação: Criar `src/actions/credits/consume.ts`
   - Critério: Decrementa 1 crédito, retorna novo valor
   - Validação: Teste unitário passa

**Fase 2: Orquestração**
3. [ ] **Inngest: Integrar consumo**
   - Ação: Adicionar step `consumeCredit` na função `generateImage`
   - Critério: Evento dispara → crédito consumido → imagem gerada
   - Validação: Log no Inngest Dev Server

**Fase 3: UI**
4. [ ] **Componente: Card de créditos**
   - Ação: `src/components/dashboard/credits-card.tsx`
   - Critério: Mostra "X/Y créditos", alerta em 80%
   - Validação: Visual correto no Storybook

5. [ ] **Bloqueio: Quando zera**
   - Ação: Check antes da geração, retorna erro se 0
   - Critério: HTTP 403 quando credits = 0
   - Validação: Teste de integração

**Riscos:**
- Race condition? → Usar `SELECT FOR UPDATE` no Postgres
- Stripe falhar? → Sistema continua com créditos atuais

---

## 📄 Template PLAN

**Arquivo:** `docs/PLAN-[nome].md`

```markdown
# PLAN: [Nome da Feature]
**Projeto:** [Nome] | **Data:** YYYY-MM-DD | **Complexidade:** [Baixa/Média/Alta]

## 1. Arquitetura (Blueprint)

### Schema (Drizzle)
\`\`\`typescript
// src/db/schema/[tabela].ts
export const [tabela] = pgTable("[nome]", {
  id: uuid("id").defaultRandom().primaryKey(),
  // campos específicos
});
\`\`\`

### Eventos (Inngest)
- `[dominio].[acao]` → Função `[nome]` (Steps: A → B → C)

### Rotas/UI
- Rota: `/app/[caminho]`
- Componentes: [Lista]

## 2. Execução Atômica

### Fase 1: Fundação
1. [ ] **[Título do passo]**
   - **Ação**: [O que fazer]
   - **Critério**: [Como saber que deu certo]
   - **Validação**: [Comando ou teste]

### Fase 2: Lógica
2. [ ] **[Título]**
   - **Ação**: [...]
   - **Critério**: [...]
   - **Validação**: [...]

### Fase 3: UI
3. [ ] **[Título]**
   - **Ação**: [...]
   - **Critério**: [...]
   - **Validação**: [...]

## 3. Riscos & Fallbacks
- Se [risco] → [contingência]

## 4. Estimativa
- Total de passos: [X]
- Tempo estimado: [Y minutos]
- Próxima skill: `03_executando_codigo`
```

## 🚫 Anti-Padrões

- ❌ Passo > 10 minutos (não atômico)
- ❌ Critério subjetivo ("ficar bom")
- ❌ Sem validação definida
- ❌ Ferramenta fora da Stack Omega
- ❌ Plano sem SPEC prévio
- ❌ >15 passos sem sub-divisão

## ✅ Checklist de Qualidade

- [ ] Cada passo ≤ 10 minutos
- [ ] Cada passo tem critério binário
- [ ] Cada passo tem validação
- [ ] Stack Omega respeitada
- [ ] Riscos identificados
- [ ] Tempo estimado
- [ ] Arquitetura antes dos passos

## 🔗 Integração

- **Chamada:** Direta pelo ROUTER (se SPEC existe)
- **Pré-requisito:** `01_brainstorming` (SPEC aprovado)
- **Próxima:** `03_executando_codigo`
- **Artefato:** `docs/PLAN-[nome].md`

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Ajustado para Stack Omega fixa (non-negotiable)
- Simplificada integração (ROUTER direto)
- Removidos scripts Python (movidos para RECURSOS/)
- Estrutura v3.0 (numeração sequencial)

### v3.0.0 (Original)
- Planos atômicos e rastreáveis
- Stack configurável (agora fixa)
- Template completo
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
