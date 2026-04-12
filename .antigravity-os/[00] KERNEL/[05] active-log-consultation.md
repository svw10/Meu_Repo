---
name: active_log_consultation
description: "Protocolo de Consulta Ativa de Logs — Antes de iniciar qualquer tarefa, o agente consulta logs recentes para detectar falhas e contexto de runtime existente"
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: THETA (orchestre) | GAMMA/ETA/ZETA (executam)
trigger: "Antes de iniciar qualquer tarefa em MODO IDX que envolva sistema em execução"
status: active
tags: [logs, telemetry, observability, context, runtime]
---

# 📡 ACTIVE LOG CONSULTATION — Kernel Protocol

## 🎯 Propósito

O problema da **telemetria passiva**: o agente *tem* logs em `Logs/`, mas só os consulta *depois* de quebrar algo. Este protocolo torna a consulta de logs **obrigatória antes de começar** — transformando o agente de reativo em proativo.

> **Diferença chave vs Anxiety Detector:**
> - `[04] anxiety-detector.md` monitora **o comportamento do modelo** durante execução
> - Este protocolo monitora **o estado do sistema alvo** antes da execução

---

## 🔍 QUANDO EXECUTAR (Gatilho Obrigatório)

Execute este protocolo **antes** de qualquer tarefa em MODO IDX quando:

| Situação | Logs a consultar |
|:---|:---|
| Implementar feature em sistema já rodando | `Logs/errors.log` + `Logs/metrics/` |
| Corrigir bug reportado pelo usuário | `Logs/errors.log` (últimas 24h) |
| Fazer deploy ou atualização | `Logs/metrics/` + `Logs/performance/` |
| Pós-DELTA reprovação | `Logs/feedback-loop.log` |
| Tarefa de otimização (ZETA) | `Logs/metrics/latency.ts` + `Logs/metrics/cost_per_user.ts` |
| Qualquer `/audit` do DELTA | Todos os logs do projeto |

**NÃO execute quando:**
- Tarefa é puramente de planejamento (MODO GEM)
- Projeto é novo (sem logs existentes)
- Tarefa não afeta sistema em execução (ex: documentação pura)

---

## ⚙️ PROTOCOLO (3 PASSOS — máx 2 min)

### PASSO 1: Verificação rápida de saúde (30 segundos)

```bash
# Se o projeto tem logs estruturados:
cat Logs/errors.log | tail -50          # Últimos 50 erros
cat Logs/metrics/latency.ts | tail -20  # Últimas métricas de latência

# Se o projeto tem Vercel/cloud:
# → Pergunte ao usuário: "Há erros ativos no painel da Vercel?"
```

**O que buscar:**
- Erros das últimas 2 horas antes da tarefa
- Picos de latência não explicados
- Falhas recorrentes no mesmo endpoint/módulo

### PASSO 2: Classificar contexto de runtime

| Sinal encontrado | Ação antes de começar |
|:---|:---|
| Erros críticos ativos (5xx, DB down) | 🛑 PARE — resolva o incidente antes de nova feature |
| Erros recorrentes no mesmo módulo que vou tocar | ⚠️ Avise o usuário, incorpore ao escopo da tarefa |
| Latência degradada mas estável | 📝 Documente como baseline para comparação pós-tarefa |
| Logs limpos, sistema saudável | ✅ Prossiga com a tarefa original |

### PASSO 3: Registrar baseline (se aplicável)

Antes de qualquer mudança que afete performance, capture:

```
BASELINE PRÉ-TAREFA (copiar para DRIFT_REPORT ou comentário da tarefa):
- Erros/h: [N]
- Latência P95: [Xms]
- Custo/usuário: [R$X]
- Módulos com alertas: [lista]
```

---

## 🤖 INTEGRAÇÃO COM AGENTES

| Agente | Como usa este protocolo |
|:---|:---|
| **GAMMA** | Executa PASSO 1 antes de implementar. Se encontrar erros ativos, para e reporta ao THETA |
| **ETA** | Executa PASSO 1 + 2 para entender contexto do bug antes de investigar causa raiz |
| **ZETA** | Executa PASSO 1 + 2 + 3 — a baseline é essencial para medir ganhos de otimização |
| **DELTA** | Consulta TODOS os logs como parte da Fase 1 (Conformidade) |
| **THETA** | Verifica se há incidente ativo ANTES de delegar qualquer tarefa |

---

## 📋 Checklist de Consulta Ativa (uso rápido)

```
ANTES DE COMEÇAR:
[ ] Verificou Logs/errors.log (últimas 2h)?
[ ] Sistema está saudável (sem erros 5xx ativos)?
[ ] Latência está normal (sem pico na última hora)?
[ ] Módulo alvo tem histórico de erros recentes?

Se todas ✅: prossiga
Se algum ❌: avise THETA + usuário antes de continuar
```

---

## 🔗 Arquitetura de Logs do Antigravity OS

```
Logs/
├── errors.log              # Erros de runtime (structured JSON)
├── feedback-loop.log       # Histórico de reprovações DELTA
├── metrics/
│   ├── latency.ts          # Latência de endpoints (P50/P95/P99)
│   ├── cost_per_user.ts    # Custo por usuário ativo
│   └── cost_analysis.ts    # Análise de custos por serviço
└── performance/            # Lighthouse scores, bundle size
```

> Se `Logs/` não existir no projeto: crie com `mkdir -p Logs/metrics Logs/performance` e oriente GAMMA a implementar structured logging no primeiro commit.
