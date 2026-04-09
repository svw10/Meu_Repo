---
name: memory_summarizer
description: Sumarização automática de histórico para manter contexto de longo prazo com mínimo de tokens
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: ZETA
trigger: "a cada N mensagens ou por gatilho de custo"
status: active
tags: [summarization, memory, context, long-term, zeta]
---

# 🧠 MEMORY SUMMARIZER — Contexto de Longo Prazo com Mínimo de Tokens

## 🎯 Propósito
Manter o contexto histórico essencial para decisões estratégicas enquanto reduz drasticamente o consumo de tokens através de sumarização inteligente acionada por gatilhos.

## 🎛️ Gatilhos de Sumarização

| Gatilho | Condição | Ação |
|---------|----------|--------|
| **Contagem de Mensagens** | > 10 mensagens na sessão | Resumir últimas 10 → 1 bloco |
| **Custo Acumulado** | > 70% do budget da sprint | Resumir + alertar usuário |
| **Mudança de Sprint** | `/clear` ou nova sprint | Arquivar histórico + criar resumo |
| **Gatilho Manual** | `/summarize` | Resumir histórico atual sob demanda |

## ⚙️ Protocolo de Sumarização (3 Fases)

### Fase 1: Extração de Pontos-Chave
ZETA analisa o histórico e extrai:
```typescript
interface SummaryExtract {
  decisions: string[];        // Decisões arquiteturais tomadas
  constraints: string[];      // Restrições identificadas (stack, budget, etc)
  openQuestions: string[];    // Perguntas pendentes
  completedTasks: string[];   // Tarefas concluídas com status
  keyContext: Record<string, string>; // Contexto essencial (ex: "user prefers dark mode")
}
```

### Fase 2: Geração do Resumo Estruturado
```markdown
## 📋 Resumo da Sessão [ID]

### ✅ Decisões Tomadas
- [Decisão 1] → Justificativa
- [Decisão 2] → Justificativa

### 🎯 Restrições Ativas
- [Restrição 1] (ex: "Stack Omega obrigatória")
- [Restrição 2] (ex: "Budget: 8k tokens/sprint")

### ❓ Pendências
- [Pergunta 1] → Responsável: [Agente]
- [Pergunta 2] → Deadline: [Sprint N]

### 📊 Progresso
- Concluído: [X/Y tarefas]
- Próximo: [Próxima ação]

### 🧠 Contexto Essencial
- [Chave]: [Valor] (ex: "user_role": "admin")
```

### Fase 3: Substituição e Arquivamento
- Substitui histórico original pelo resumo estruturado (~200 tokens vs ~2000)
- Arquiva histórico completo em `.antigravity-os/.cache/session-[id]-full.md` (para debug futuro)
- Registra metadados em `MEMORY_DNA`:
```json
{
  "session_id": "sess_abc123",
  "original_tokens": 2150,
  "summarized_tokens": 210,
  "compression_ratio": 0.90,
  "summary_generated_at": "2026-02-22T15:30:00Z",
  "key_decisions": ["usar Neon", "evitar axios"],
  "archived_path": ".antigravity-os/.cache/session-sess_abc123-full.md"
}
```

## 📊 Métricas de Eficiência

| Métrica | Alvo | Como Medir |
|---------|------|-----------|
| Compression Ratio | > 85% | `summarized_tokens / original_tokens` |
| Context Retention | > 95% | Testes de recall de decisões-chave |
| Summarization Latency | < 30s | Tempo de geração do resumo |
| User Satisfaction | > 4.5/5 | Feedback pós-sumarização |

## 🛡️ Regras de Segurança

- ✅ **Sempre** preservar decisões arquiteturais no resumo
- ✅ **Sempre** manter restrições de stack/budget visíveis
- ❌ **Nunca** resumir dados sensíveis (PII, secrets) — sanitizar antes
- ✅ **Sempre** arquivar histórico completo para auditoria futura

## 🔗 Integração com Agentes

| Agente | Papel na Sumarização |
|--------|---------------------|
| **ZETA** | Gera o resumo estruturado (owner) |
| **THETA** | Decide quando acionar sumarização (gatilhos) |
| **DELTA** | Valida que decisões-chave foram preservadas |
| **ETA** | Investiga se resumo perdeu contexto crítico |

## 🚫 Anti-Padrões (Proibidos)

- ❌ Resumir sem preservar decisões arquiteturais
- ❌ Usar LLM caro para sumarização (usar modelo menor + validação)
- ❌ Descartar histórico sem arquivar (perda de audit trail)
- ❌ Ignorar gatilhos de custo (risco de estourar budget)

## ✅ Checklist de Implementação

- [ ] Gatilhos de sumarização configurados (contagem, custo, sprint)
- [ ] Template de resumo estruturado definido
- [ ] Arquivamento de histórico completo implementado
- [ ] Validação de retenção de contexto por DELTA
- [ ] Métricas de compressão sendo logadas em TOKENOMICS
- [ ] Fallback para "resumo falhou" (manter histórico original)

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Acionado por THETA via gatilhos ou comando `/summarize`.

**Memória:** Metadados de sumarização registrados em `.antigravity-os/[04] MEMORY_DNA/`.

**Budget:** Economia de tokens registrada em `.antigravity-os/[05] TOKENOMICS/[03] cost-telemetry.json`.

**Handoff:** Após sumarização, THETA retoma orquestração com contexto reduzido.

**Stack Omega:** ZETA para geração, DELTA para validação, Redis para cache de resumos frequentes.
