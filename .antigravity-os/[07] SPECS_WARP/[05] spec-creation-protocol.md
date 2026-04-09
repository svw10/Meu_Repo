---
name: spec_creation_protocol
description: Protocolo Definitivo de Criação de SPEC. Une RAG, Entrevista Estruturada e Schema Zod.
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: BETA + THETA
trigger: "/create-spec" ou pós-aprovação de PRD
status: active
tags: [spec, protocol, rag, interview, zod, beta]
---

# 🧠 SPEC CREATION PROTOCOL — O Cérebro da Especificação

## 🎯 Propósito
Transformar um PRD ou ideia vaga em uma **SPEC Técnica Executável (JSON/Markdown)** através de um fluxo blindado:
1. **RAG Protocol:** Leitura inteligente (não leia tudo).
2. **Entrevista Estruturada:** Extração de gaps de negócio.
3. **Geração Técnica:** Output validado por Zod Schema.

> **Regra de Ouro:** NUNCA gere uma SPEC sem passar por este protocolo. SPECs alucinadas geram bugs em cascata.

---

## ⚙️ FLUXO DE EXECUÇÃO (3 Fases)

### 🟢 FASE 1: RAG PROTOCOL (Leitura Inteligente)
**Objetivo:** Entender o contexto sem estourar o budget.

1. **Indexação:**
   - Leia `Minhas_Skills/CORE/00_index_skills.md`.
   - Identifique a skill necessária baseada na intenção (ex: "SaaS" → `02_planejando_solucoes`).

2. **Retrieval (Zero Custo):**
   - Leia APENAS a skill selecionada.
   - Leia APENAS o modo de UI Kit necessário (SaaS ou Landing).
   - **PROIBIDO:** Ler todas as skills ou o UI Kit completo.

3. **Anúncio:**
   - "🔧 Usando skill [XX] + modo [UI] via RAG Protocol..."

### 🟡 FASE 2: ENTREVISTA ESTRUTURADA (Gate 1.5)
**Objetivo:** Eliminar ambiguidades antes de codar.

1. **Análise de Gaps:**
   - Identifique o que falta (ex: "O PRD diz 'login', mas não define recuperação de senha").

2. **Perguntas (Uma por Vez):**
   - Use múltipla escolha sempre que possível (a, b, c, d).
   - Ex: "Para recuperação de senha: a) Email Link b) SMS OTP c) Não permitir agora?"

3. **Confirmação:**
   - Resuma as decisões tomadas.
   - Peça aprovação explícita antes de gerar a SPEC.

### 🔴 FASE 3: GERAÇÃO TÉCNICA (Schema Zod)
**Objetivo:** Criar o contrato executável.

1. **Mapeamento:**
   - Converta as respostas da entrevista em campos do `SpecTechnicalSchema`.

2. **Validação:**
   - Garanta que TODOS os campos obrigatórios estão preenchidos.
   - Verifique `estimated_tokens` vs `token-budget-controller.json`.

3. **Output:**
   - Gere o arquivo `docs/SPEC-[id].json` ou `.md` validado.

---

## 🛡️ REGRAS DE SEGURANÇA & ECONOMIA

### 1. Contexto Limpo
- Antes de iniciar a FASE 1, verifique se o contexto está limpo (`/clear`).
- Se a intenção mudar drasticamente, reinicie o protocolo.

### 2. Auto-Fill Técnico (Stack Omega)
Não pergunte sobre coisas técnicas padrão. Aplique automaticamente:
- **API:** Next.js Route Handlers + Zod Validation.
- **DB:** Neon + Drizzle ORM.
- **Auth:** Clerk.
- **UI:** Tailwind + Shadcn.
- **Errors:** Structured Logging + Sentry.

### 3. Fallback de Budget
- Se `estimated_tokens` > 80% do budget global:
  - Divida a SPEC em múltiplas sub-SPECs.
  - Sugira uso de modelo menor para tarefas simples.

---

## 📝 TEMPLATE DE RESPOSTA (Padrão do Protocolo)

Ao final do processo, a resposta deve seguir este formato estrito:

```markdown
#  SPEC CRIADA COM SUCESSO

**ID:** SPEC-[nome]  
**Status:** ✅ Validada por Zod  
**Gates:** Gate 1.5 (Entrevista) → Gate 2 (Zod)  

## 📊 Resumo da Entrevista
- [Pergunta 1] → [Resposta Selecionada]
- [Pergunta 2] → [Resposta Selecionada]

## 🛠️ Decisões Técnicas (Auto-Aplicadas)
- Stack: Next.js 14 + Neon + Clerk
- Padrão de Erros: Zod + Structured Logging
- UI: [SaaS/Landing] Mode

## 🔗 Próximos Passos
1. Agente DELTA deve validar pré-execução (Gate 3).
2. Agente GAMMA pode iniciar Sprint 1 (Gate 4).

**Arquivo Gerado:** `docs/SPEC-[nome].md`
```

---

## 🚫 ANTI-PADRÕES (PROIBIDO)

- ❌ Gerar SPEC sem ler o PRD original.
- ❌ Pular a fase de entrevista (Gate 1.5).
- ❌ Gerar SPEC com campos `null` no Schema Zod.
- ❌ Ler arquivos desnecessários (violação de RAG Protocol).
- ❌ Usar Stack fora do Omega sem ADR.

---

## 🔗 Integração com Antigravity OS

- **Gatilho:** Acionado automaticamente após aprovação do PRD.
- **Agentes:** BETA (Entrevista) → THETA (Validação RAG) → GAMMA (Leitura da SPEC gerada).
- **Arquivos:**
  - Entrada: `docs/PRD-[nome].md`
  - Saída: `docs/SPEC-[nome].md` + `docs/SPEC-[nome].json`
- **Validação:** `.antigravity-os/[07] SPECS_WARP/[01] spec-technical-schema.ts`

> 💡 **Nota:** Este protocolo garante que 100% das SPECs geradas sejam **executáveis, validadas e econômicas em tokens**.
