---
name: anxiety_detector
description: "Protocolo de detecção de 'Ansiedade de Contexto' — identifica degradação comportamental do modelo antes que comprometa o trabalho em andamento"
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: THETA (responsável por monitorar)
trigger: "Contínuo — THETA verifica sinais após cada resposta de agente"
status: active
tags: [context, anxiety, handoff, resilience, kernel]
---

# 🧠 ANXIETY DETECTOR — Kernel Protocol

## 🎯 Propósito

O Token Budget Controller mede **quantidade** de tokens.  
Este protocolo detecta **qualidade** do comportamento — a degradação sutil que ocorre quando um modelo começa a sentir pressão de contexto, mesmo dentro do budget.

> O Anthropic identificou "Context Anxiety" como **causa #1 de falha em tarefas longas**: o modelo começa a "correr" para terminar antes de perder o contexto, sacrificando qualidade no processo.

---

## 🚨 SINAIS DE ANSIEDADE (O que monitorar)

THETA deve observar padrões nas últimas **3 respostas consecutivas** de qualquer agente:

### 🔴 Sinais Críticos (ação imediata)
| Sinal | Exemplo | Nível |
|:---|:---|:---|
| **Conclusão prematura** | "Pronto! Tarefa concluída" sem evidências | 🔴 Crítico |
| **Generalização de pendências** | "O restante segue o mesmo padrão..." | 🔴 Crítico |
| **Pular para resultado** | Apresenta output sem mostrar raciocínio intermediário | 🔴 Crítico |
| **Comprimir sem avisar** | Reduz etapas do plano "para simplificar" sem autorização | 🔴 Crítico |

### 🟡 Sinais de Alerta (monitorar próxima resposta)
| Sinal | Exemplo | Nível |
|:---|:---|:---|
| **Frases de fechamento repetidas** | "Vamos finalizar...", "Para concluir...", "Resumindo..." em excesso | 🟡 Alerta |
| **Diminuição de detalhes** | Respostas ficam cada vez mais curtas sem motivo | 🟡 Alerta |
| **Checklist superficial** | Marca itens como ✅ sem verificação real | 🟡 Alerta |
| **Mudança de tom** | Passa de técnico/preciso para "isso deve funcionar" | 🟡 Alerta |
| **Redução de referências** | Para de citar arquivos/schemas explicitamente | 🟡 Alerta |

### 🟢 Estado Saudável (referência)
- Ainda cita arquivos específicos por nome e linha
- Ainda faz perguntas antes de assumir
- Ainda documenta decisões intermediárias
- Respostas mantêm nível de detalhe consistente

---

## ⚙️ PROTOCOLO DE RESPOSTA

### Se 1 sinal 🔴 ou 2 sinais 🟡 consecutivos:

**THETA executa Handoff Preventivo:**

```
1. PAUSE — Não termine a resposta corrente prematuramente
2. SINALIZE ao usuário:
   "⚠️ THETA: Detectei degradação de contexto no [AGENTE]. 
   Vou executar handoff preventivo antes de continuar.
   Trabalho atual: [resumo em 3 linhas]"

3. COMPRIMA o contexto atual via Handoff Artifact:
   → Gerar `.antigravity-os/[11] HANDOFF_ARTIFACTS/[timestamp]-[agente]-handoff.yaml`
   (Ver protocolo em [01] ORCHESTRATOR/[03] handoff-artifacts-protocol.md)

4. REINICIE o agente com contexto comprimido:
   → Carregue Activation Card do agente ([01] ORCHESTRATOR/[02] activation-cards.md)
   → Injete o Handoff Artifact como único contexto inicial
   → Não repasse histórico de conversa — apenas o artefato
```

### Se sessão ultrapassar 80% do budget global:
- **Independentemente de sinais** → executar handoff preventivo
- Sincronizar com `[02] token-budget-controller.json` (`alert_at_pct: 80`)

---

## 📊 DIAGNÓSTICO RÁPIDO (THETA usa isso)

Após cada 3 respostas de um agente, THETA faz internamente:

```
CHECKLIST DE SAÚDE DO AGENTE:
[ ] Última resposta referenciou arquivos por nome? (se sim: +1 ponto)
[ ] Última resposta fez perguntas de clarificação quando necessário? (se sim: +1)
[ ] Nível de detalhe mantido vs. início da sessão? (se sim: +1)
[ ] Sem frases de encerramento prematuro? (se sim: +1)
[ ] Critérios de verificação ainda explícitos? (se sim: +1)

Score 5/5: ✅ Agente saudável — continue
Score 3-4/5: 🟡 Alerta — monitorar próxima resposta
Score 0-2/5: 🔴 Ansiedade — handoff preventivo imediato
```

---

## 🔗 Integração com Antigravity OS

| Componente | Papel |
|:---|:---|
| `[02] token-budget-controller.json` | Gatilho numérico (80% budget) complementa detecção comportamental |
| `[01] ORCHESTRATOR/[03] handoff-artifacts-protocol.md` | Protocolo de compressão e passagem de bastão |
| `[01] ORCHESTRATOR/[01] feedback-loop-protocol.md` | Diferença: Feedback Loop é para rejeição de qualidade; Anxiety é para degradação de contexto |
| `[01] ORCHESTRATOR/[02] activation-cards.md` | Cards usados para reiniciar agente após handoff preventivo |
| `context/CURRENT_AGENT.md` | Log do estado atual — deve ser atualizado antes do handoff |

---

## ⚠️ O que NÃO é ansiedade de contexto

- Resposta curta porque a tarefa era simples → **Normal**
- Agente encerrando porque genuinamente completou → **Normal**
- GAMMA dizendo "próximo passo é X" → **Normal** (é handoff intencional)
- DELTA aprovando sem ressalvas → **Normal** (se evidências foram verificadas)

> **Regra:** Detecte padrão, não instâncias isoladas. Um sinal único não é ansiedade.
