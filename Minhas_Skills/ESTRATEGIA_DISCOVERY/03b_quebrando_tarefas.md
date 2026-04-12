---
name: quebrando_tarefas
description: "Fase TASKS do TLC Spec Driven — Quebrar PLAN.md em tarefas atômicas (<4h) com critérios de verificação e evidências obrigatórias"
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: THETA
trigger: "/tasks | após aprovação do PLAN.md pelo BETA"
previous: 02_planejando_solucoes (BETA)
next: 03_executando_planos (GAMMA)
status: active
tags: [tasks, atomic, tlc, breakdown, definition-of-done, anti-cheat]
---

# 03b - QUEBRANDO TAREFAS (Fase TASKS)

## 🎯 Quando usar

Esta skill é a **ponte obrigatória** entre o PLAN.md do BETA e a execução do GAMMA, para sprints com:
- Mais de 3 passos no PLAN.md
- Trabalho estimado em >2 horas
- Múltiplos arquivos criados/modificados
- Risk level médio ou alto (definido pelo BETA)

> Para sprints simples (<3 passos, <1h), GAMMA pode ler o PLAN.md diretamente. Usar bom senso.

---

## ⚙️ Protocolo de Quebra (3 Etapas)

### Etapa 1 — Leitura do PLAN.md

Leia `docs/PLAN-[nome].md` e extraia:
- Total de fases e passos
- Dependências entre passos (sequencial vs. paralelo)
- Estimativa de tempo por passo
- Arquivos impactados

### Etapa 2 — Atomização

Regras de atomização:
- **Tamanho:** Cada task deve ser completável em **1-4 horas**. Se maior, quebre.
- **Verificação:** Cada task deve ter critérios **pass/fail** (binários, não subjetivos).
- **Independência:** Tasks devem ser independentes quando possível.
- **Rastreabilidade:** Cada task DEVE referenciar o `RF-XXX` da SPECIFICATION.

### Etapa 3 — Gerar TASKS.md

Arquivo gerado: `docs/TASKS-[nome]-sprint[N].md`

---

## 📋 Template — TASKS.md

```markdown
# TASKS: [Nome da Feature] — Sprint [N]
> Origem: `docs/PLAN-[nome].md` | Gerado por: Fase TASKS (THETA) | Data: YYYY-MM-DD

---

## Metadados
- **Total de Tasks:** [N]
- **Estimativa Total:** [X horas]
- **Risk Level:** [Baixo/Médio/Alto]
- **Agente Executor:** GAMMA
- **Agente Validador:** DELTA

---

## Tasks Atômicas

### ✅ TASK-001: [Nome curto e descritivo]
**Requisito:** RF-[XXX] (rastreável à SPECIFICATION)  
**Escopo:** [O que fazer — específico, sem ambiguidade]  
**Arquivos:** [Lista de arquivos a criar/modificar]  
**Estimativa:** [X horas]  
**Dependência:** [TASK-000 ou "nenhuma"]

**Critérios de Verificação (Definition of Done):**
- [ ] [Critério 1 — testável e binário]
- [ ] [Critério 2 — testável e binário]
- [ ] [Critério 3 — testável e binário]

**Evidências Requeridas (Test Anti-Cheat):**
- [ ] Output de `npx tsc --noEmit`: zero erros
- [ ] Output de `npm run lint`: zero erros críticos
- [ ] [Evidência funcional específica: log/screenshot/curl]
- [ ] Critérios de verificação acima: todos marcados ✅

**Status:** [ ] Pendente | [ ] Em Progresso | [ ] Concluída | [ ] Reprovada por DELTA

---

### ✅ TASK-002: [Nome curto e descritivo]
**Requisito:** RF-[XXX]  
**Escopo:** [...]  
**Arquivos:** [...]  
**Estimativa:** [X horas]  
**Dependência:** TASK-001

**Critérios de Verificação:**
- [ ] [Critério 1]
- [ ] [Critério 2]

**Evidências Requeridas:**
- [ ] [...]

**Status:** [ ] Pendente

---

## Progresso da Sprint

| Task | Descrição | Status | DELTA | Tentativas |
|:---|:---|:---|:---|:---|
| TASK-001 | [Nome] | ⏳ Pendente | — | 0 |
| TASK-002 | [Nome] | ⏳ Pendente | — | 0 |

---

## Regras de Execução (GAMMA)

1. Execute tasks **na ordem** (respeite dependências)
2. **SEM** evidências = task **NÃO** está concluída
3. Máximo de **3 tentativas** por task antes de escalar (Feedback Loop Protocol)
4. Marque status **apenas** após DELTA aprovar

---
**Sprint Status:** [ ] Em Planejamento | [ ] Em Execução | [ ] Concluída | [ ] Bloqueada
```

---

## 🛡️ Test Anti-Cheat — Regras Técnicas

GAMMA **não pode** marcar uma task como `Concluída` sem:

| Check | Obrigatório | Como verificar |
|:---|:---|:---|
| TypeScript sem erros | ✅ Sempre | `npx tsc --noEmit` — output vazio |
| Lint aprovado | ✅ Sempre | `npm run lint` — zero erros críticos |
| Critérios de verificação | ✅ Sempre | Todos os checkboxes da task marcados |
| Evidência funcional | ✅ Sempre | Log/screenshot específico da task |
| DELTA não rejeitou | ✅ Sempre | Status ≠ "Reprovada por DELTA" |

> **Integração com Feedback Loop Protocol:**  
> Se DELTA rejeitar → `correction_loop.attempt_count` +1 → GAMMA corrige → DELTA re-audita.  
> Se attempt_count ≥ 3 → ESCALAÇÃO (sprint marcada "bloqueada", usuário notificado).  
> Ver: `.antigravity-os/[01] ORCHESTRATOR/[01] feedback-loop-protocol.md`

---

## 🚫 Anti-Padrões (Proibidos)

- ❌ Task maior que 4 horas (não é atômica — quebre mais)
- ❌ Critério subjetivo ("funcionar bem", "parecer correto")
- ❌ Task sem rastreabilidade para RF da SPECIFICATION
- ❌ Marcar "Concluída" sem evidências anexadas
- ❌ GAMMA iniciar sem TASKS.md aprovado (para sprints complexas)
- ❌ Pular tasks por "parecerem triviais" (todas passam por DELTA)

---

## 🔗 Integração com Antigravity OS

| Componente | Papel |
|:---|:---|
| `02_planejando_solucoes.md` | Input — PLAN.md gerado por BETA |
| `00_especificando_requisitos.md` | Rastreabilidade — RF-XXX referenciados em cada task |
| `03_executando_planos.md` | Próxima skill — GAMMA executa task por task |
| `05_verificando_conclusao.md` | QA — DELTA audita cada task com DoD técnico |
| `[01] ORCHESTRATOR/[01] feedback-loop-protocol.md` | Loop de correção quando DELTA rejeita |
| `[04] MEMORY_DNA/[06] task-evidence-schema.json` | Schema formal das evidências de conclusão |

---

## ✅ Checklist de Entrega (THETA entrega para GAMMA)

- [ ] Todas as tasks do PLAN.md cobertas
- [ ] Nenhuma task > 4 horas
- [ ] Todos os critérios são binários (pass/fail)
- [ ] Todas as tasks têm rastreabilidade para RF-XXX
- [ ] Dependências mapeadas e sequência definida
- [ ] Seção "Progresso da Sprint" inicializada
- [ ] TASKS.md salvo em `docs/TASKS-[nome]-sprint[N].md`
