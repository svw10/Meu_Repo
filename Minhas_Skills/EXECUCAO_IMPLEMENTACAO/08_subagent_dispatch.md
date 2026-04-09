---
name: subagent_dispatch
description: Orquestração de subagentes paralelos com revisão em 2 estágios (spec + code).
version: 3.1.0
framework: "Antigravity OS v3.1"
owner_agent: THETA
trigger: "/parallel"
integration: "Antigravity Neural Router"
status: active
tags: [subagents, parallel, dispatch, review, theta, orchestration]
---

# 08 - SUBAGENT DISPATCH (Parallel Execution Protocol)

## 🎯 Quando usar
- **Tarefas complexas** com 3+ etapas independentes (ex: DB schema + API route + UI component)
- **Prazos apertados** onde execução sequencial é inviável
- **Refatorações grandes** que podem ser isoladas por módulo
- Quando THETA detecta alto custo de contexto sequencial

> **Regra de Ouro**: Nunca dispare subagentes sem contrato Zod definido. Paralelismo sem revisão = caos.

## 🧱 Arquitetura de Subagentes (Antigravity Pool)

| Subagente | Função | Agente Base | Limite Concurrente |
|:---|:---|:---|:---|
| **Spec-Writer** | Gera especificação técnica atômica | BETA (Architect) | 2 |
| **Code-Builder** | Implementa código seguindo spec | GAMMA (Builder) | 3 |
| **Quality-Auditor** | Revisa código + testes | DELTA (Auditor) | 2 |
| **Integration-Test** | Valida fluxo end-to-end | ETA (Investigator) | 1 |

**Fluxo de Revisão em 2 Estágios:**
1. **Stage 1 (Spec Review)**: BETA valida arquitetura → aprova ou rejeita com diff
2. **Stage 2 (Code Review)**: DELTA valida implementação + testes → merge ou rollback

## ⚙️ Protocolo de Dispatch (3 Fases)

### Fase 1: Decomposição & Contrato (2 min)
THETA quebra a tarefa em subtasks atômicas e gera contrato Zod para cada uma:
```typescript
import { z } from 'zod';

export const SubagentContractSchema = z.object({
  taskId: z.string().uuid(),
  parentTaskId: z.string().uuid(),
  type: z.enum(['spec', 'code', 'review', 'test']),
  input: z.record(z.unknown()),
  expectedOutput: z.record(z.unknown()),
  budgetTokens: z.number().max(8000),
  timeoutSeconds: z.number().default(300),
  dependsOn: z.array(z.string()).optional(),
  status: z.enum(['queued', 'running', 'success', 'failed', 'rejected']).default('queued')
});
```

### Fase 2: Execução Paralela Controlada (N min)
- **Queue Manager**: THETA mantém fila com prioridade e limites de concorrência
- **Context Isolation**: Cada subagente recebe APENAS seu input + spec aprovada (não carrega contexto global)
- **Budget Tracking**: Consumo de tokens é rastreado por subtask em `TOKENOMICS/[03] cost-telemetry.json`
- **Circuit Breaker**: Se 2 subagentes falharem consecutivamente, pausa dispatch e alerta usuário

### Fase 3: Revisão em 2 Estágios (5 min)
**Stage 1: Spec Validation**
- BETA compara output do Spec-Writer com `PLAN.md` original
- Valida: arquitetura, dependencies, edge cases, budget allocation
- Output: `spec-approved.json` ou `spec-rejected.md` com diff

**Stage 2: Code Validation**
- DELTA roda checklist de `05_code_review_checklist.md`
- Executa testes unitários + lint + typecheck
- Valida integração entre subtasks (ex: API route ↔ DB schema ↔ UI props)
- Output: `code-merged` ou `code-rejected.md` com rollback instructions

## 🤖 Integração com Agentes Existentes

| Agente | Papel no Dispatch |
|--------|------------------|
| **THETA** | Dispatcher principal, gerencia fila, aloca budget, monitora health |
| **BETA** | Stage 1 Review (Spec), valida arquitetura e contratos |
| **GAMMA** | Executa subtasks de código, segue specs aprovadas |
| **DELTA** | Stage 2 Review (Code), auditoria final antes de merge |
| **ETA** | Debug paralelo, investiga falhas de subagentes |
| **ZETA** | Otimiza alocação de budget e limites de concorrência |

**Exemplo de Orquestração THETA:**
```yaml
dispatch_session:
  id: "sess_parallel_9f8a7b"
  parent_task: "create_auth_flow"
  subtasks:
    - id: "sub_01"
      type: "spec"
      agent: "BETA"
      status: "success"
    - id: "sub_02"
      type: "code"
      agent: "GAMMA"
      depends_on: ["sub_01"]
      status: "running"
    - id: "sub_03"
      type: "review"
      agent: "DELTA"
      depends_on: ["sub_02"]
      status: "queued"
  budget_allocated: 12000
  budget_consumed: 4800
  status: "in_progress"
```

## 🚫 Anti-Padrões (Proibidos)
- ❌ Disparar >3 subagentes simultâneos (risco de contexto pollution)
- ❌ Pular Stage 1 Review (especificação não validada)
- ❌ Subagente carregar contexto global (viola isolamento)
- ❌ Ignorar contrato Zod (output não estruturado)
- ❌ Merge sem Stage 2 Review (código não auditado)
- ❌ Budget ilimitado por subtask (viola TOKENOMICS)

## ✅ Checklist de Qualidade
- [ ] Contrato Zod definido para cada subtask
- [ ] Limite de concorrência respeitado (máx 3)
- [ ] Stage 1 Review (Spec) aprovado por BETA
- [ ] Stage 2 Review (Code) aprovado por DELTA
- [ ] Budget rastreado e dentro do limite global
- [ ] Rollback plan definido em caso de falha
- [ ] Logs de dispatch registrados em `MEMORY_DNA`

## 🔗 Integração com Sistema v3.1
**Roteamento:** Invocada via `/parallel` ou por THETA ao detectar tarefa complexa.
**Memória:** Falhas de dispatch registradas em `.antigravity-os/[04] MEMORY_DNA/` para ajuste de limites.
**Budget:** Consumo monitorado em `.antigravity-os/[05] TOKENOMICS/[03] cost-telemetry.json`.
**Handoff:** Após Stage 2 aprovado, retoma fluxo sequencial ou notifica deploy.

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Esta skill é invocada via `.antigravity-os/[02] SQUAD_WRAPPERS/` ou Slash Commands.

**Memória:** Erros encontrados devem ser logados em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.

**Budget:** Respeite os limites de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.

**Handoff:** Após execução, atualize `context/CURRENT_AGENT.md` e retorne ao THETA.

**Stack Omega:** Siga rigorosamente `Minhas_Rules/STACK_OMEGA_RULES.md`.
