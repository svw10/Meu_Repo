---
name: handoff_artifacts_protocol
description: "Protocolo de Handoff Artifacts — artefatos imutáveis de passagem de bastão entre agentes que sobrevivem a resets de contexto"
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: THETA (gera) | Todos os agentes (consomem)
trigger: "Toda transição de agente ou handoff preventivo (anxiety-detector)"
status: active
tags: [handoff, artifacts, context, immutability, orchestration]
---

# 🤝 HANDOFF ARTIFACTS PROTOCOL — Orquestrador

## 🎯 Propósito

O `context/CURRENT_AGENT.md` é **mutável** — é sobrescrito a cada sessão e não tem histórico.  

Handoff Artifacts são **imutáveis**: gerados no momento do handoff, salvos com timestamp, e usados como **única fonte de verdade** para reiniciar um agente com contexto comprimido — sobrevivendo a resets de contexto, troca de sessão, ou limite de tokens.

> **Analogia:** `CURRENT_AGENT.md` é RAM (volátil). Handoff Artifact é um arquivo salvo em disco (persistente).

---

## 📂 Localização e Nomeação

```
.antigravity-os/[11] HANDOFF_ARTIFACTS/
├── [YYYY-MM-DDTHH-MM]-[FROM]-to-[TO].yaml    # Handoff entre agentes
├── [YYYY-MM-DDTHH-MM]-[FROM]-anxiety.yaml     # Handoff preventivo (anxiety)
└── README.md                                   # Índice de artefatos ativos
```

**Exemplos:**
```
2026-04-12T15-30-BETA-to-GAMMA.yaml
2026-04-12T16-45-GAMMA-anxiety.yaml
```

---

## 📋 Template — Handoff Artifact YAML

```yaml
# Handoff Artifact — Antigravity OS v3.1
# IMUTÁVEL após geração. Não edite este arquivo.

artifact_version: "1.0"
generated_at: "YYYY-MM-DDTHH:MM:SSZ"
generated_by: "THETA"  # Sempre THETA gera o artefato

# Quem passa o bastão e para quem
from_agent: "BETA"     # Agente que estava trabalhando
to_agent: "GAMMA"      # Agente que vai receber
handoff_reason: "PLANNED"  # PLANNED | ANXIETY_DETECTED | TASK_COMPLETE | BLOCKED

# O que foi feito (compressão do trabalho atual)
context_summary: |
  [2-5 linhas máximo. O essencial do que foi feito até aqui.
  Inclua: objetivo da sessão, decisões tomadas, estado atual.]

# Artefatos produzidos (com paths exatos)
artifacts_produced:
  - type: "PLAN"
    path: "docs/PLAN-[nome].md"
    status: "complete"
  - type: "TASKS"
    path: "docs/TASKS-[nome]-sprint1.md"
    status: "complete"

# Próxima ação — o que o agente receptor deve fazer PRIMEIRO
next_atomic_task: |
  [1-2 linhas. Ação específica e atômica. Ex:
  "Implementar TASK-001: criar endpoint /api/checkout conforme 
  docs/TASKS-checkout-sprint1.md"]

# Dívida técnica e pendências (o que NÃO foi resolvido)
technical_debt:
  - "[Decisão pendente sobre X — precisa de input do usuário]"
  - "[Feature Y deliberadamente adiada para Sprint 2]"

# Riscos identificados (para o próximo agente não ser pego de surpresa)
risks:
  - severity: "HIGH"
    description: "[Risco específico e ação preventiva]"
  - severity: "LOW"
    description: "[Risco menor a monitorar]"

# Critério de validação para a próxima entrega
validation_checkpoint: |
  [Como DELTA vai saber que o trabalho do próximo agente está correto.
  Ex: "Endpoint /api/checkout retorna 200 com token JWT válido e
  debita crédito no Neon conforme RF-003 da SPECIFICATION.md"]

# Contexto de negócio crítico (para não perder em reset)
business_context:
  project: "[Nome do projeto]"
  sprint: "[Sprint N]"
  deadline: "[Data ou 'sem prazo definido']"
  stakeholder_decisions:
    - "[Decisão tomada pelo usuário que influencia o código]"

# Referências obrigatórias (agente receptor DEVE ler antes de começar)
mandatory_reads:
  - "docs/SPECIFICATION-[nome].md"     # Requisitos
  - "docs/TASKS-[nome]-sprint[N].md"   # Tasks atuais
  - ".antigravity-os/[01] ORCHESTRATOR/[02] activation-cards.md"  # Card do agente
```

---

## ⚙️ Protocolo de Geração (THETA)

### Quando gerar um Handoff Artifact:

1. **Handoff planejado** — agente completa sua fase (`PLANNED`)
2. **Handoff preventivo** — `[04] anxiety-detector.md` detecta degradação (`ANXIETY_DETECTED`)
3. **Bloqueio** — agente não consegue avançar sem input humano (`BLOCKED`)
4. **Tarefa concluída** — ciclo completo de uma task (`TASK_COMPLETE`)

### Como gerar:

```
THETA:
1. Solicitar ao agente atual: "Comprima o estado atual em 5 linhas"
2. Popular o template YAML com a compressão
3. Salvar em .antigravity-os/[11] HANDOFF_ARTIFACTS/[timestamp]-[from]-to-[to].yaml
4. Atualizar .antigravity-os/[11] HANDOFF_ARTIFACTS/README.md com nova entrada
5. Carregar Activation Card do agente receptor
6. Injetar artefato como ÚNICO contexto inicial (não passar histórico)
```

---

## 📖 README.md do diretório (manter atualizado)

```markdown
# Handoff Artifacts Index

| Arquivo | De → Para | Razão | Sprint | Status |
|:---|:---|:---|:---|:---|
| [timestamp]-BETA-to-GAMMA.yaml | BETA → GAMMA | PLANNED | Sprint 1 | 🟢 Ativo |
| [timestamp]-GAMMA-anxiety.yaml | GAMMA → GAMMA | ANXIETY | Sprint 1 | ✅ Consumido |
```

---

## 🔑 Regras de Imutabilidade

- **Nunca edite** um artefato após gerado. Se houver erro, gere um novo com `_v2` no nome.
- **Nunca delete** artefatos consumidos — são registro histórico (DELTA pode auditar)
- **Máximo de 3 artefatos ativos** por sprint. Se tiver mais, algo está errado no fluxo.

---

## 🔗 Integração com Antigravity OS

| Componente | Papel |
|:---|:---|
| `[00] KERNEL/[04] anxiety-detector.md` | Gatilho de handoff preventivo |
| `[01] ORCHESTRATOR/[02] activation-cards.md` | Card do agente receptor (lido após o artefato) |
| `[01] ORCHESTRATOR/[01] feedback-loop-protocol.md` | Diferença: Feedback Loop é sobre qualidade de entrega; Handoff Artifact é sobre continuidade de contexto |
| `context/CURRENT_AGENT.md` | Ainda usado para sessão ativa — Handoff Artifact é para transições |
| `[04] MEMORY_DNA/[07] handoff-artifact-schema.json` | Schema formal de validação dos campos obrigatórios |
