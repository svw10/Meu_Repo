name: llm_guardrails
description: Proteções de segurança para uso de LLMs no Antigravity OS
version: 3.0.0
---

# LLM GUARDRAILS

> **PRINCÍPIO:** LLMs alucinam. Nosso trabalho é impedir que isso quebre o sistema.

---

## 🛡️ GUARDRAIL 1 - OUTPUT ESTRUTURADO OBRIGATÓRIO

**Regra:** Toda saída de LLM deve ser validada por Zod.

**Implementação:**
```typescript
const ParsedSchema = z.object({
  code: z.string(),
  explanation: z.string().optional()
});
const result = ParsedSchema.parse(llmResponse);
```

**Proibido:** Usar `JSON.parse()` direto ou `response.text` sem validação.

---

## 🛡️ GUARDRAIL 2 - NUNCA CONFIE NO LLM

**Regras:**
- LLM não acessa banco de dados diretamente
- LLM não executa código em produção
- LLM não tem acesso a secrets/variáveis de ambiente

**Padrão seguro:**
```
Usuário → LLM (gera rascunho) → Agente valida → Runtime executa
```

---

## 🛡️ GUARDRAIL 3 - PROMPT INJECTION DEFENSE

**Regras:**
- Remover instruções do usuário que pareçam system prompts
- Validar input com Zod antes de enviar ao LLM
- Nunca concatenar user input direto no system prompt

---

## 🛡️ GUARDRAIL 4 - CUSTO CONTROLADO

**Regras:**
- Máximo de tokens por requisição: definido em `workflow_types.ts`
- Fallback para modelo menor se custo exceder threshold
- Log de custo em toda chamada LLM

**Alertas:** Amarelo (80%), Vermelho (100% → fallback)

---

## 🛡️ GUARDRAIL 5 - TEMPERATURA E CRIATIVIDADE

| Tarefa | Temperatura | Por quê |
|:---|:---|:---|
| Geração de código | 0.0-0.2 | Determinístico |
| Explicação | 0.3-0.5 | Clara |
| Brainstorming | 0.7-0.9 | Criativo |
| Validação | 0.0 | Estrito |

---

## 🛡️ GUARDRAIL 6 - RAG SEGURO

**Regras:**
- Filtre documentos por relevância (score > 0.7)
- Limite de contexto: máximo 50% da janela do modelo
- Cite fontes: toda informação do RAG deve ter `source_id`

---

## 🛡️ GUARDRAIL 7 - FALLBACK OBRIGATÓRIO

**Cadeia de fallback:**
```
1. Claude 3.5 Sonnet (primário)
2. GPT-4o (secundário)
3. GPT-4o-mini (terciário)
4. Resposta cacheada ou erro graceful
```

---

## 🛡️ GUARDRAIL 8 - AUDITORIA COMPLETA

**Log obrigatório:**
```typescript
{
  timestamp: ISOString,
  model: string,
  tokens_input: number,
  tokens_output: number,
  cost_usd: number,
  latency_ms: number,
  success: boolean,
  error_type?: string
}
```

**Retenção:** 90 dias no Neon.

---

## ⚠️ VIOLAÇÕES CRÍTICAS

| Violação | Consequência |
|:---|:---|
| Executar código de LLM sem validação | Bloqueio imediato, revisão de segurança |
| Expor secrets em prompt | Rotação de credenciais obrigatória |
| Ignorar fallback | Alerta para ZETA |
| Ultrapassar orçamento | Suspensão de chamadas LLM |

---
FIM DOS GUARDRAILS - Segurança primeiro, velocidade depois.
```

