---
name: llm_app_blueprint
framework: "Antigravity OS v3.1"
owner_agent: BETA
trigger: "/blueprint"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: llm-app-blueprint
description: Engenheiro de IA. Arquitetura LLM via OpenRouter (multi-provider), RAG genérico, Guardrails, Avaliação. Blueprint para sistemas cognitivos.
version: 3.0.1
tags: [ai, llm, openrouter, rag, guardrails, avaliacao, multi-provider]
---

# 10 - LLM APP BLUEPRINT (OpenRouter Architecture)

## 🎯 Quando usar
- Projetar agentes de IA, sistemas RAG genéricos, fluxos conversacionais
- Implementar roteamento inteligente (cost/quality/latency)
- Configurar Guardrails e validação de saída estruturada
- Criar pipelines de IA que integram com Stack Omega

> **Regra Obrigatória**: Nunca chame LLM diretamente. Use OpenRouter para roteamento, fallback e observabilidade unificada.

## 🧱 Arquitetura Cognitiva (Stack Omega + IA)

| Componente | Stack Omega | Especialização IA |
|:---|:---|:---|
| **LLM Gateway** | OpenRouter | Multi-provider, fallback automático |
| **Embeddings** | OpenRouter | `text-embedding-3-small` (1536d) |
| **Vector DB** | Neon + pgvector | RAG genérico (não só produtos) |
| **Orquestração** | Inngest | Jobs longos, retries, rate limiting |
| **Validação** | Zod | Structured output, guardrails |
| **Cache** | Redis/Upstash | Evita re-chamadas caras |
| **Observability** | Neon (logs) | Custo por request, latência, erros |

## 🔄 Roteamento Inteligente (OpenRouter)

### Estratégias de Routing

```typescript
type RoutingStrategy = 
  | "quality"      // Sempre melhor (Claude 3.5)
  | "cost"         // Sempre mais barato (GPT-4o-mini)
  | "balanced"     // Mistral/Meta para médias
  | "adaptive"     // Baseado na complexidade da query
  | "fallback";    // Tenta barato, sobe se necessário
```

### Matriz de Decisão

| Complexidade | Modelo Primário | Fallback | Max Tokens | Custo Máx |
|:---|:---|:---|:---:|:---:|
| **Simples** (classificação, resumo) | `gpt-4o-mini` | `llama-3.1-8b` | 500 | $0.001 |
| **Média** (explicação, análise) | `mistral-large` | `gpt-4o-mini` | 2000 | $0.01 |
| **Complexa** (coding, raciocínio) | `claude-3.5-sonnet` | `gpt-4o` | 4000 | $0.05 |
| **Crítica** (decisões negócio) | `claude-3.5-sonnet` | `gpt-4o` + humano | 8000 | $0.10 |

### Cliente OpenRouter (TypeScript)

```typescript
// src/lib/ai/openrouter.ts
import OpenAI from 'openai';

const openrouter = new OpenAI({
  baseURL: process.env.OPENROUTER_BASE_URL,
  apiKey: process.env.OPENROUTER_API_KEY,
  defaultHeaders: {
    'HTTP-Referer': process.env.SITE_URL,
    'X-Title': process.env.SITE_NAME,
  },
});

interface GenerateOptions {
  primaryModel?: string;
  fallbackModel?: string;
  maxTokens?: number;
  temperature?: number;
  responseFormat?: any;
  maxCost?: number;
}

export async function generateWithFallback(
  messages: any[],
  options: GenerateOptions = {}
) {
  const {
    primaryModel = process.env.OPENROUTER_DEFAULT_MODEL,
    fallbackModel = process.env.OPENROUTER_FALLBACK_MODEL,
    maxTokens = 4000,
    temperature = 0.7,
    responseFormat,
    maxCost = 0.05,
  } = options;

  try {
    const response = await openrouter.chat.completions.create({
      model: primaryModel,
      messages,
      max_tokens: maxTokens,
      temperature,
      response_format: responseFormat,
      extra_body: {
        transforms: ["middle-out"],
        route: "fallback",
      },
    });

    // Log para observabilidade (salvar no Neon)
    await logLLMRequest({
      model: response.model,
      inputTokens: response.usage?.prompt_tokens,
      outputTokens: response.usage?.completion_tokens,
      cost: response.usage?.total_cost,
      timestamp: new Date(),
    });

    return {
      content: response.choices[0].message.content,
      model: response.model,
      usage: response.usage,
      cost: response.usage?.total_cost,
    };

  } catch (error: any) {
    console.warn(`[OpenRouter] Falha em ${primaryModel}:`, error.message);
    
    if (fallbackModel && fallbackModel !== primaryModel) {
      return generateWithFallback(messages, {
        ...options,
        primaryModel: fallbackModel,
        fallbackModel: undefined,
      });
    }
    throw error;
  }
}

// Embeddings
export async function generateEmbedding(text: string) {
  const response = await openrouter.embeddings.create({
    model: "openai/text-embedding-3-small",
    input: text,
  });
  return response.data[0].embedding;
}
```

## 🗄️ RAG Genérico (Neon pgvector)

**Diferença de `09_gerenciando_memoria`**: Este é RAG **genérico** (documentos, conhecimento), não específico de produtos e-commerce.

### Schema Drizzle

```typescript
// src/db/schema/knowledge.ts
import { pgTable, uuid, text, jsonb, timestamp, vector, index } from "drizzle-orm/pg-core";

export const knowledgeBase = pgTable("knowledge_base", {
  id: uuid("id").defaultRandom().primaryKey(),
  
  // Conteúdo
  content: text("content").notNull(),
  embedding: vector("embedding", { dimensions: 1536 }),
  
  // Metadados
  source: text("source"),           // URL, arquivo, etc
  category: text("category"),       // "docs", "faq", "procedures"
  metadata: jsonb("metadata"),      // {author, date, tags}
  
  // Controle
  tenantId: text("tenant_id"),      // Multi-tenancy opcional
  createdAt: timestamp("created_at").defaultNow(),
  updatedAt: timestamp("updated_at").defaultNow(),
}, (table) => ({
  embeddingIdx: index("knowledge_embedding_idx").using("hnsw",
    table.embedding.op("vector_cosine_ops")),
  categoryIdx: index("knowledge_category_idx").on(table.category),
}));

// Função de busca (SQL raw ou migrada para Drizzle)
export async function searchKnowledge(
  query: string,
  options: {
    category?: string;
    topK?: number;
    threshold?: number;
  } = {}
) {
  const embedding = await generateEmbedding(query);
  
  return await db.execute(sql`
    SELECT 
      id,
      content,
      source,
      1 - (embedding <=> ${JSON.stringify(embedding)}::vector) as similarity
    FROM ${knowledgeBase}
    WHERE 1 - (embedding <=> ${JSON.stringify(embedding)}::vector) > ${options.threshold ?? 0.7}
    ${options.category ? sql`AND category = ${options.category}` : sql``}
    ORDER BY embedding <=> ${JSON.stringify(embedding)}::vector
    LIMIT ${options.topK ?? 5}
  `);
}
```

## 🛡️ Guardrails e Validação

### Validação de Entrada (Anti-injection)

```typescript
// src/lib/ai/guardrails.ts
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

### Validação de Saída (Structured Output)

```typescript
// src/lib/ai/structured.ts
import { z } from 'zod';
import { zodToJsonSchema } from 'zod-to-json-schema';

const AnalysisSchema = z.object({
  answer: z.string().describe("Resposta principal"),
  confidence: z.number().min(0).max(1),
  sources: z.array(z.string()),
  needsEscalation: z.boolean(),
  category: z.enum(['technical', 'billing', 'general']),
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

  const parsed = JSON.parse(response.content);
  return schema.parse(parsed); // Validação Zod dupla
}
```

## 📊 Observabilidade (Logs no Neon)

```typescript
// src/db/schema/ai-logs.ts
import { pgTable, uuid, text, numeric, integer, timestamp, jsonb } from "drizzle-orm/pg-core";

export const llmLogs = pgTable("llm_logs", {
  id: uuid("id").defaultRandom().primaryKey(),
  
  // Request
  model: text("model").notNull(),
  prompt: text("prompt"),            // Truncado para privacidade
  systemPrompt: text("system_prompt"),
  
  // Response
  response: text("response"),        // Truncado
  inputTokens: integer("input_tokens"),
  outputTokens: integer("output_tokens"),
  
  // Métricas
  cost: numeric("cost", { precision: 10, scale: 6 }),
  latencyMs: integer("latency_ms"),
  error: text("error"),
  
  // Contexto
  userId: text("user_id"),
  sessionId: text("session_id"),
  metadata: jsonb("metadata"),        // {strategy, fallbackUsed, etc}
  
  createdAt: timestamp("created_at").defaultNow(),
});

// Helper de logging
export async function logLLMRequest(data: typeof llmLogs.$inferInsert) {
  await db.insert(llmLogs).values(data);
}
```

## 🎯 Avaliação (LLM-as-Judge)

```typescript
// src/lib/ai/evaluation.ts
export async function evaluateResponse(
  originalQuery: string,
  response: string,
  context: string[]
): Promise<{ score: number; feedback: string }> {
  
  const evaluation = await generateWithFallback([{
    role: 'system',
    content: `Você é um avaliador rigoroso. Avalie em 1-5 baseado em:
1. Factualidade (usa apenas contexto fornecido?)
2. Clareza (é fácil de entender?)
3. Completude (responde totalmente?)`,
  }, {
    role: 'user',
    content: `Pergunta: ${originalQuery}\nContexto: ${context.join('\n')}\nResposta: ${response}\n\nJSON com score e feedback.`,
  }], {
    primaryModel: "openai/gpt-4o-mini", // Juiz barato
  });

  try {
    const parsed = JSON.parse(evaluation.content);
    return { score: parsed.score, feedback: parsed.feedback };
  } catch {
    return { score: 0, feedback: "Falha ao parsear avaliação" };
  }
}
```

## 🛠️ Scripts de Apoio

### calculate-cost.ts
```typescript
#!/usr/bin/env ts-node
// scripts/calculate-cost.ts

const PRICING = {
  "anthropic/claude-3.5-sonnet": { input: 3.0, output: 15.0 },
  "openai/gpt-4o": { input: 5.0, output: 15.0 },
  "openai/gpt-4o-mini": { input: 0.15, output: 0.6 },
  "meta-llama/llama-3.1-70b": { input: 0.9, output: 0.9 },
};

function calculate(model: string, inputTokens: number, outputTokens: number, requests: number = 1000) {
  const prices = PRICING[model as keyof typeof PRICING] || { input: 1.0, output: 3.0 };
  const costPerRequest = (inputTokens * prices.input + outputTokens * prices.output) / 1_000_000;
  
  console.log(`💰 ${model}`);
  console.log(`   Por request: $${costPerRequest.toFixed(4)}`);
  console.log(`   ${requests} requests: $${(costPerRequest * requests).toFixed(2)}`);
  
  console.log(`\n📊 Comparativo (1k req, ${inputTokens}in/${outputTokens}out):`);
  Object.entries(PRICING)
    .sort((a, b) => a[1].input - b[1].input)
    .forEach(([m, p]) => {
      const c = ((inputTokens * p.input) + (outputTokens * p.output)) / 1000;
      const marker = m === model ? " <--" : "";
      console.log(`   ${m}: $${c.toFixed(2)}${marker}`);
    });
}

const [model, inputTokens, outputTokens, requests] = process.argv.slice(2);
calculate(model || "anthropic/claude-3.5-sonnet", 
          parseInt(inputTokens) || 1000, 
          parseInt(outputTokens) || 500,
          parseInt(requests) || 1000);
```

## 🔗 Integração com Skills Existentes

| Skill | Integração |
|:---|:---|
| `09_gerenciando_memoria` | Usa `generateEmbedding` desta skill para produtos |
| `01_brainstorming` | Pode usar `generateStructured` para organizar ideias |
| `02_planejando_solucoes` | `adaptiveGenerate` para estimar complexidade de tasks |
| `03_executando_planos` | `generateWithFallback` para assistência de código |
| `07_comunicando_externo` | LLM para gerar mensagens personalizadas |
| `04_solucionando_erros` | LLM para analisar logs e sugerir correções |

## 🚫 Anti-Padrões

- ❌ Chamar LLM direto (sem OpenRouter)
- ❌ Não logar custos (surpresa na conta)
- ❌ Ignorar rate limits (ban do provider)
- ❌ Sem validação de saída (JSON quebrado)
- ❌ Prompt injection não sanitizado
- ❌ Re-gerar embedding para mesmo texto (sem cache)
- ❌ RAG sem threshold de similaridade (lixo no contexto)

## ✅ Checklist de Implementação

- [ ] OpenRouter configurado com fallback
- [ ] Estratégia de roteamento definida
- [ ] Schema `knowledge_base` (RAG) aplicado
- [ ] Schema `llm_logs` (observability) aplicado
- [ ] Guardrails de input implementados
- [ ] Validação Zod para structured output
- [ ] Cache configurado (Redis/Upstash)
- [ ] Avaliação (LLM-as-Judge) para amostras

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Integrado com Stack Omega v3.0 (Drizzle, Neon, Inngest)
- Schema `llm_logs` para observabilidade
- Conexão com `09_gerenciando_memoria` (embeddings compartilhados)
- Scripts TypeScript (calculate-cost)
- Integrações com outras skills documentadas

### v3.0.0 (Original)
- Arquitetura OpenRouter first
- Roteamento multi-provider
- RAG genérico com pgvector
- Guardrails e structured output
- Avaliação automática
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
