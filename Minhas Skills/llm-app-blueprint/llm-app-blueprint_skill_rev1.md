name: llm-app-blueprint
description: O Engenheiro de IA. Arquitetura de LLMs via OpenRouter (multi-provider), RAG com Neon pgvector, Guardrails e Avaliação. Blueprint universal para sistemas cognitivos.
version: 3.0.0
tags: [ai, llm, openrouter, rag, guardrails, neon, multi-provider, routing]
---

# LLM App Blueprint (OpenRouter Architecture v3.0)

## 🎯 Quando usar
- Projetar agentes de IA, sistemas RAG ou fluxos conversacionais.
- Implementar **roteamento inteligente** entre múltiplos modelos (cost/quality/latency).
- Configurar Guardrails e validação de saída estruturada.
- Auditar sistemas existentes para confiabilidade > 99%.

> **Regra Obrigatória**: Nunca chame LLM diretamente. Sempre use OpenRouter para roteamento, fallback e observabilidade unificada.

---

## 🧱 Arquitetura Cognitiva (OpenRouter First)

### Camada de Roteamento (OpenRouter)
OpenRouter atua como **API Gateway de LLMs**, unificando acesso a múltiplos providers:

| Provider | Modelo | Uso Ideal | Custo Relativo |
| :--- | :--- | :--- | :--- |
| **Anthropic** | `claude-3.5-sonnet` | Raciocínio complexo, coding | $$$ |
| **OpenAI** | `gpt-4o` | Multimodal, instruções precisas | $$$ |
| **OpenAI** | `gpt-4o-mini` | Tarefas simples, baixo custo | $ |
| **Meta** | `llama-3.1-70b` | Open source, sem rate limits | $$ |
| **Google** | `gemini-1.5-flash` | Velocidade, contexto longo | $ |
| **Mistral** | `mistral-large` | Europa, compliance GDPR | $$ |

**Vantagens do OpenRouter:**
- **Fallback automático**: Se Claude falha, tenta GPT-4o automaticamente.
- **Cost routing**: Escolha modelo baseado em orçamento por request.
- **Observabilidade**: Logs unificados de todos os providers.
- **Formato único**: Mesma API para todos (OpenAI-compatible).

### Stack de Suporte
- **RAG / Memória**: Neon + pgvector (embeddings `text-embedding-3-small`).
- **Orquestração**: Inngest (jobs longos, retries, rate limiting).
- **Validação**: Zod (TypeScript) ou Pydantic (Python) para structured output.
- **Cache**: Redis ou Upstash (evita re-chamadas caras).

---

## ⚙️ Fluxo de Trabalho

### Passo 1: Definição de Estratégia de Roteamento (3 min)

Decida como o sistema escolhe o modelo:

```typescript
// Estratégias de Routing
type RoutingStrategy = 
  | "quality"      // Sempre melhor modelo (Claude 3.5)
  | "cost"         // Sempre mais barato (GPT-4o-mini)
  | "balanced"     // Mistral/Meta para médias
  | "adaptive"     // Escolhe baseado na complexidade da query
  | "fallback"     // Tenta barato, sobe se necessário
```

**Matriz de Decisão:**

| Complexidade da Tarefa | Modelo Primário | Fallback | Max Tokens | Max Cost |
| :--- | :--- | :--- | :--- | :--- |
| Simples (classificação, resumo curto) | `gpt-4o-mini` | `llama-3.1-8b` | 500 | $0.001 |
| Média (explicação, análise) | `mistral-large` | `gpt-4o-mini` | 2000 | $0.01 |
| Complexa (coding, raciocínio) | `claude-3.5-sonnet` | `gpt-4o` | 4000 | $0.05 |
| Crítica (decisões de negócio) | `claude-3.5-sonnet` | `gpt-4o` + human review | 8000 | $0.10 |

---

### Passo 2: Configuração OpenRouter (5 min)

**Variáveis de Ambiente:**
```bash
OPENROUTER_API_KEY=sk-or-v1-...
OPENROUTER_BASE_URL=https://openrouter.ai/api/v1
OPENROUTER_DEFAULT_MODEL=anthropic/claude-3.5-sonnet
OPENROUTER_FALLBACK_MODEL=openai/gpt-4o-mini
OPENROUTER_MAX_COST_PER_REQUEST=0.05
```

**Cliente Universal (TypeScript):**
```typescript
// lib/ai/openrouter-client.ts
import OpenAI from 'openai';

const openrouter = new OpenAI({
  baseURL: process.env.OPENROUTER_BASE_URL,
  apiKey: process.env.OPENROUTER_API_KEY,
  defaultHeaders: {
    'HTTP-Referer': process.env.SITE_URL, // Para rankings no OpenRouter
    'X-Title': process.env.SITE_NAME,
  },
});

// Wrapper com retry e fallback
export async function generateWithFallback(
  messages: any[],
  options: {
    primaryModel?: string;
    fallbackModel?: string;
    maxCost?: number;
    timeout?: number;
  } = {}
) {
  const {
    primaryModel = process.env.OPENROUTER_DEFAULT_MODEL,
    fallbackModel = process.env.OPENROUTER_FALLBACK_MODEL,
    maxCost = 0.05,
    timeout = 30000,
  } = options;

  try {
    const response = await openrouter.chat.completions.create({
      model: primaryModel,
      messages,
      max_tokens: 4000,
      // OpenRouter-specific: routing preferences
      extra_body: {
        transforms: ["middle-out"], // Otimização de contexto
        route: "fallback",          // Usar fallback se primário falhar
      },
    }, { timeout });

    // Log para observabilidade
    console.log(`[OpenRouter] ${primaryModel}: $${response.usage?.total_cost || 'unknown'}`);
    
    return {
      content: response.choices[0].message.content,
      model: response.model,
      usage: response.usage,
      cost: response.usage?.total_cost,
    };

  } catch (error: any) {
    console.warn(`[OpenRouter] Falha em ${primaryModel}:`, error.message);
    
    // Fallback manual se necessário
    if (fallbackModel && fallbackModel !== primaryModel) {
      console.log(`[OpenRouter] Tentando fallback: ${fallbackModel}`);
      return generateWithFallback(messages, {
        ...options,
        primaryModel: fallbackModel,
        fallbackModel: undefined, // Evita loop infinito
      });
    }
    
    throw error;
  }
}
```

**Cliente Universal (Python):**
```python
# lib/ai/openrouter_client.py
import os
import openai
from typing import List, Dict, Optional
import logging

logger = logging.getLogger(__name__)

class OpenRouterClient:
    def __init__(self):
        self.client = openai.OpenAI(
            base_url=os.getenv("OPENROUTER_BASE_URL"),
            api_key=os.getenv("OPENROUTER_API_KEY"),
        )
        self.default_model = os.getenv("OPENROUTER_DEFAULT_MODEL", "anthropic/claude-3.5-sonnet")
        self.fallback_model = os.getenv("OPENROUTER_FALLBACK_MODEL", "openai/gpt-4o-mini")
    
    def generate(
        self,
        messages: List[Dict[str, str]],
        model: Optional[str] = None,
        max_tokens: int = 4000,
        temperature: float = 0.7,
        response_format: Optional[Dict] = None,
        use_fallback: bool = True,
    ) -> Dict:
        """
        Gera completion com OpenRouter, com fallback automático.
        """
        primary_model = model or self.default_model
        
        try:
            response = self.client.chat.completions.create(
                model=primary_model,
                messages=messages,
                max_tokens=max_tokens,
                temperature=temperature,
                response_format=response_format,
                extra_headers={
                    "HTTP-Referer": os.getenv("SITE_URL", ""),
                    "X-Title": os.getenv("SITE_NAME", ""),
                },
                extra_body={
                    "transforms": ["middle-out"],
                    "route": "fallback" if use_fallback else None,
                },
            )
            
            cost = getattr(response, 'usage', {}).get('total_cost', 'unknown')
            logger.info(f"[OpenRouter] {primary_model}: ${cost}")
            
            return {
                "content": response.choices[0].message.content,
                "model": response.model,
                "usage": response.usage,
                "cost": cost,
            }
            
        except Exception as e:
            logger.warning(f"[OpenRouter] Falha em {primary_model}: {e}")
            
            if use_fallback and primary_model != self.fallback_model:
                logger.info(f"[OpenRouter] Tentando fallback: {self.fallback_model}")
                return self.generate(
                    messages=messages,
                    model=self.fallback_model,
                    max_tokens=max_tokens,
                    temperature=temperature,
                    response_format=response_format,
                    use_fallback=False,  # Evita loop
                )
            raise

# Singleton
openrouter = OpenRouterClient()
```

---

### Passo 3: RAG com Neon pgvector (5 min)

**Schema:**
```sql
-- Neon: Tabela de documentos com embeddings
CREATE TABLE knowledge_base (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    content TEXT NOT NULL,
    embedding VECTOR(1536),  -- OpenAI text-embedding-3-small
    metadata JSONB DEFAULT '{}',
    source VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Índice HNSW para busca rápida
CREATE INDEX idx_knowledge_embedding ON knowledge_base 
USING hnsw (embedding vector_cosine_ops);

-- Função de busca semântica
CREATE OR REPLACE FUNCTION search_knowledge(
    query_embedding VECTOR(1536),
    match_threshold FLOAT,
    match_count INT
)
RETURNS TABLE(
    id UUID,
    content TEXT,
    similarity FLOAT,
    metadata JSONB
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        kb.id,
        kb.content,
        1 - (kb.embedding <=> query_embedding) AS similarity,
        kb.metadata
    FROM knowledge_base kb
    WHERE 1 - (kb.embedding <=> query_embedding) > match_threshold
    ORDER BY kb.embedding <=> query_embedding
    LIMIT match_count;
END;
$$ LANGUAGE plpgsql;
```

**Pipeline de Embedding + Query:**
```typescript
// lib/ai/rag-pipeline.ts
import { openrouter } from './openrouter-client';

export async function queryWithRAG(
  userQuery: string,
  options: {
    topK?: number;
    threshold?: number;
    systemPrompt?: string;
  } = {}
) {
  const { topK = 5, threshold = 0.7, systemPrompt } = options;

  // 1. Gerar embedding da query (usando OpenRouter/OpenAI)
  const embeddingResponse = await openrouter.embeddings.create({
    model: "openai/text-embedding-3-small",
    input: userQuery,
  });
  const queryEmbedding = embeddingResponse.data[0].embedding;

  // 2. Buscar no Neon (via Drizzle ou SQL direto)
  const relevantDocs = await db.execute(sql`
    SELECT * FROM search_knowledge(
      ${JSON.stringify(queryEmbedding)}::vector,
      ${threshold},
      ${topK}
    )
  `);

  // 3. Construir contexto
  const context = relevantDocs
    .map((doc: any) => `[Fonte: ${doc.metadata?.source}]\n${doc.content}`)
    .join('\n\n');

  // 4. Gerar resposta com contexto
  const response = await generateWithFallback([
    {
      role: 'system',
      content: `${systemPrompt || 'Você é um assistente útil.'}\n\nContexto relevante:\n${context}`,
    },
    { role: 'user', content: userQuery },
  ]);

  return {
    answer: response.content,
    sources: relevantDocs.map((d: any) => d.metadata?.source),
    model: response.model,
    cost: response.cost,
  };
}
```

---

### Passo 4: Guardrails e Validação (3 min)

**Validação de Entrada (Anti-injection):**
```typescript
// lib/ai/guardrails.ts
import { z } from 'zod';

const SafeInputSchema = z.string()
  .max(4000, "Input muito longo")
  .refine(
    text => !/(ignore|disregard|forget).*(previous|instruction|prompt)/i.test(text),
    "Possível prompt injection detectado"
  )
  .refine(
    text => !/(system|admin|root).*(prompt|instruction)/i.test(text),
    "Tentativa de override de sistema detectada"
  );

export function sanitizeInput(input: string): string {
  return SafeInputSchema.parse(input);
}
```

**Validação de Saída (Structured Output):**
```typescript
// lib/ai/structured-output.ts
import { z } from 'zod';
import { zodToJsonSchema } from 'zod-to-json-schema';

const AnalysisSchema = z.object({
  answer: z.string().describe("Resposta principal"),
  confidence: z.number().min(0).max(1).describe("Confiança 0-1"),
  sources: z.array(z.string()).describe("Fontes citadas"),
  needs_escalation: z.boolean().describe("Precisa de humano?"),
  category: z.enum(['technical', 'billing', 'general']).describe("Categoria"),
});

export async function generateStructured(
  messages: any[],
  schema: z.ZodSchema = AnalysisSchema
) {
  const response = await generateWithFallback(messages, {
    response_format: {
      type: "json_schema",
      json_schema: {
        name: "analysis_response",
        schema: zodToJsonSchema(schema),
        strict: true,
      },
    },
  });

  // Parse e validação dupla
  try {
    const parsed = JSON.parse(response.content);
    return schema.parse(parsed); // Validação Zod
  } catch (error) {
    throw new Error(`Output inválido do LLM: ${error.message}`);
  }
}
```

---

### Passo 5: Avaliação (LLM-as-Judge) (3 min)

```typescript
// lib/ai/evaluation.ts
export async function evaluateResponse(
  originalQuery: string,
  response: string,
  context: string[]
): Promise<{ score: number; feedback: string }> {
  
  const evaluation = await generateWithFallback([
    {
      role: 'system',
      content: `Você é um avaliador rigoroso de respostas de IA.
Avalie a resposta em 1-5 baseado em:
1. Factualidade (usa apenas o contexto fornecido?)
2. Clareza (é fácil de entender?)
3. Completude (responde totalmente a pergunta?)`,
    },
    {
      role: 'user',
      content: `Pergunta: ${originalQuery}\n\nContexto fornecido: ${context.join('\n')}\n\nResposta avaliada: ${response}\n\nForneça nota (1-5) e feedback curto em JSON.`,
    },
  ], {
    primaryModel: "openai/gpt-4o-mini", // Juiz mais barato
  });

  try {
    const parsed = JSON.parse(evaluation.content);
    return { score: parsed.score, feedback: parsed.feedback };
  } catch {
    return { score: 0, feedback: "Falha ao parsear avaliação" };
  }
}
```

---

## 📋 Checklist de Conformidade

- [ ] OpenRouter configurado com `OPENROUTER_API_KEY` e fallback definido?
- [ ] Estratégia de roteamento documentada (quality/cost/adaptive)?
- [ ] RAG usando Neon pgvector com índice HNSW?
- [ ] Guardrails de input (anti-injection) implementados?
- [ ] Output estruturado validado com Zod/Pydantic?
- [ ] Custo máximo por request definido e logado?
- [ ] Avaliação (LLM-as-Judge) configurada para amostras?
- [ ] Cache implementado para queries repetidas?

---

## 💻 Snippets e Scripts

### Script: Calculadora de Custo
```python
#!/usr/bin/env python3
# scripts/calculate_cost.py
import argparse

PRICING = {
    "anthropic/claude-3.5-sonnet": {"input": 3.0, "output": 15.0},    # $ por 1M tokens
    "openai/gpt-4o": {"input": 5.0, "output": 15.0},
    "openai/gpt-4o-mini": {"input": 0.15, "output": 0.6},
    "meta-llama/llama-3.1-70b": {"input": 0.9, "output": 0.9},
    "mistralai/mistral-large": {"input": 3.0, "output": 9.0},
}

def calculate(model: str, input_tokens: int, output_tokens: int, requests: int = 1000):
    prices = PRICING.get(model, {"input": 1.0, "output": 3.0})
    
    cost_input = (input_tokens * prices["input"]) / 1_000_000
    cost_output = (output_tokens * prices["output"]) / 1_000_000
    cost_per_request = cost_input + cost_output
    
    print(f"💰 {model}")
    print(f"   Custo por request: ${cost_per_request:.4f}")
    print(f"   Custo por {requests} requests: ${cost_per_request * requests:.2f}")
    
    # Comparativo
    print(f"\n📊 Comparativo (1k requests, {input_tokens}in/{output_tokens}out):")
    for m, p in sorted(PRICING.items(), key=lambda x: x[1]["input"]):
        c = ((input_tokens * p["input"]) + (output_tokens * p["output"])) / 1000
        marker = " <--" if m == model else ""
        print(f"   {m}: ${c:.2f}{marker}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--model", default="anthropic/claude-3.5-sonnet")
    parser.add_argument("--input", type=int, default=1000)
    parser.add_argument("--output", type=int, default=500)
    parser.add_argument("--requests", type=int, default=1000)
    args = parser.parse_args()
    
    calculate(args.model, args.input, args.output, args.requests)
```

### Snippet: Roteamento Adaptativo
```typescript
// lib/ai/adaptive-router.ts
export async function adaptiveGenerate(query: string) {
  // Análise de complexidade simples
  const complexity = analyzeComplexity(query); // heurística baseada em length, keywords
  
  const routing = {
    simple: { model: "openai/gpt-4o-mini", max_tokens: 500 },
    medium: { model: "mistralai/mistral-large", max_tokens: 1500 },
    complex: { model: "anthropic/claude-3.5-sonnet", max_tokens: 4000 },
  }[complexity];

  return generateWithFallback([{ role: 'user', content: query }], {
    primaryModel: routing.model,
    max_tokens: routing.max_tokens,
  });
}

function analyzeComplexity(query: string): 'simple' | 'medium' | 'complex' {
  const indicators = {
    code: /\b(codigo|code|funcao|algorithm|debug)\b/i,
    reasoning: /\b(analise|compare|explique|por que|why|how)\b/i,
    creative: /\b(crie|escreva|generate|creative|story)\b/i,
  };
  
  if (query.length > 500 || indicators.reasoning.test(query)) return 'complex';
  if (query.length > 200 || indicators.code.test(query)) return 'medium';
  return 'simple';
}
```

---

## 🗂️ Estrutura de Arquivos

```
Minhas Skills/llm-app-blueprint/
├── SKILL.md                              # Este blueprint
├── resources/
│   ├── template_arquitetura_ia.md        # Template de documentação
│   ├── model_cheatsheet.md               # Preços e limites dos modelos
│   └── prompt_templates/                 # Prompts reutilizáveis
│       ├── system-rag.txt
│       ├── system-classification.txt
│       └── evaluation-judge.txt
├── scripts/
│   ├── calculate_cost.py                 # Calculadora de custo
│   ├── benchmark_models.py               # Compara performance de modelos
│   └── validate_output.py                # Valida structured output
└── snippets/
    ├── openrouter-client.ts              # Cliente TypeScript
    ├── openrouter_client.py              # Cliente Python
    ├── rag-pipeline.ts                   # Pipeline RAG completo
    └── guardrails.ts                     # Validações de segurança
```

---

