---
name: pesquisando_web
framework: "Antigravity OS v3.1"
owner_agent: EPSILON
trigger: "/search"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: pesquisando-web
description: Pesquisador de Inteligência Competitiva. Web scraping via Apify para análise de concorrência, pricing e tendências. Integra com LLM para síntese.
version: 3.0.1
tags: [apify, scraping, research, competitive-intelligence, market-analysis, web-crawler]
---

# 11 - PESQUISANDO WEB (Intelligence Protocol)

## 🎯 Quando usar
- **Análise competitiva**: "Como funciona o X?", "Preços do concorrente Y"
- **Pricing intelligence**: Monitoramento de preços, planos, limites
- **Trends de mercado**: "Micro-SaaS trends 2026", "State of AI"
- **Dúvidas factuais**: "Preço atual do iPhone 15", "CEO da empresa Z"
- **Enriquecimento**: Usuário forneceu URL, extrair resumo estruturado

> **Foco**: Análise de concorrência em SaaS, e-commerce, fashion tech.

## 🧱 Stack de Inteligência (Stack Omega + Apify)

| Componente | Tecnologia | Função | Custo |
|:---|:---|:---|:---:|
| **Busca** | Apify Google Search | Resultados SERP | $0.001/q |
| **Scraping** | Apify Cheerio/Puppeteer | Extração de dados | $0.002-0.01/p |
| **Análise** | OpenRouter (via `10_llm_app_blueprint`) | Sumarização, extração | Variável |
| **Orquestração** | Inngest | Filas, retries, schedule | - |
| **Cache/Logs** | Neon + Drizzle | Resultados, histórico | - |

### Actors Apify Recomendados

| Actor | Uso | Quando |
|:---|:---|:---|
| `google-search-scraper` | Busca Google | Descoberta, SERP |
| `website-content-crawler` | Crawl completo | Mapear site de concorrente |
| `cheerio-scraper` | Página única | Pricing, features, docs |
| `puppeteer-scraper` | SPA/JS-heavy | Dashboards modernos |

## ⚙️ Fluxo de Trabalho

### Passo 1: Definição da Missão (2 min)

```typescript
interface ResearchMission {
  type: 'competitor-analysis' | 'pricing' | 'trends' | 'factual' | 'monitoring';
  query: string;              // "Zeekit pricing 2024"
  target?: string;            // "zeekit.com" (opcional)
  depth: 'shallow' | 'medium' | 'deep';
  deliverables: ('summary' | 'structured' | 'screenshots' | 'gaps')[];
}

// Exemplo
const mission: ResearchMission = {
  type: 'competitor-analysis',
  query: 'Zeekit virtual try on pricing vs competitors',
  target: 'zeekit.com',
  depth: 'medium',
  deliverables: ['summary', 'structured', 'gaps'],
};
```

### Passo 2: Execução Estratégica (5 min)

**A. Busca Google (Descoberta)**
```typescript
// 3-5 queries variantes para cobertura
const queries = [
  "Zeekit virtual try on pricing",
  "Zeekit vs Vue.ai vs SnapFit",
  "AI fashion try on SaaS 2024",
];
```

**B. Scraping Direcionado**
| Alvo | Actor | Dados |
|:---|:---|:---|
| `/pricing` | Cheerio | Planos, tiers, limites |
| `/features` | Cheerio | Lista de funcionalidades |
| `/docs` | Cheerio | Tech stack, APIs |
| Blog | Crawler | Positioning, messaging |

**C. Análise Estruturada**
```typescript
interface CompetitorAnalysis {
  company: {
    name: string;
    website: string;
    positioning: string;      // "Enterprise" vs "SMB"
    employees?: string;       // De LinkedIn/about
  };
  pricing: {
    model: 'usage' | 'seat' | 'hybrid';
    tiers: Array<{
      name: string;
      price: string;
      limits: Record<string, string>;
    }>;
    freeTier: boolean;
  };
  product: {
    keyFeatures: string[];
    differentiators: string[];
    techStack?: string[];     // Inferido de docs
  };
  gaps: string[];             // Oportunidades para nós
}
```

### Passo 3: Processamento com LLM (3 min)

```typescript
// Usar generateWithFallback de 10_llm_app_blueprint
const analysis = await generateWithFallback([
  {
    role: 'system',
    content: 'Você é analista de inteligência competitiva. Extraia dados estruturados.',
  },
  {
    role: 'user',
    content: `Analise este conteúdo de ${url} e extraia:
      - Pricing (planos, preços, limites)
      - Features principais
      - Positioning (enterprise vs SMB)
      - Tech stack (se mencionado)
      - Gaps ou fraquezas evidentes
      
      Conteúdo: """${scrapedText}"""
      
      Responda em JSON válido seguindo schema CompetitorAnalysis.`,
  },
]);
```

### Passo 4: Entrega e Integração (2 min)

**Output**: Relatório estruturado + integração com `08_explorando_mercados`

```markdown
# Inteligência Competitiva: [Concorrente]

## Resumo Executivo
[3 parágrafos com insights chave]

## Dados Estruturados
\`\`\`json
[CompetitorAnalysis JSON]
\`\`\`

## Oportunidades (Gaps)
1. [O que eles não fazem bem]
2. [Diferenciação possível]

## Evidências
- [URLs visitadas]
- [Screenshots]
- [Timestamps]

---
**Integração**: Dados transferidos para `docs/MARKET-[nicho].md` (08_explorando_mercados)
```

## 🗄️ Schema de Banco (Drizzle)

```typescript
// src/db/schema/research.ts
import { pgTable, uuid, text, jsonb, timestamp, varchar } from "drizzle-orm/pg-core";

export const researchLogs = pgTable("research_logs", {
  id: uuid("id").defaultRandom().primaryKey(),
  
  // Missão
  query: text("query").notNull(),
  type: varchar("type", { length: 50 }).notNull(),
  target: text("target"),
  depth: varchar("depth", { length: 20 }),
  
  // Resultados
  searchResults: jsonb("search_results"),     // Google results
  scrapedData: jsonb("scraped_data"),         // Conteúdo raw
  analysis: jsonb("analysis"),                // LLM output
  
  // Metadados
  cost: text("cost"),                         // Custo Apify + LLM
  durationMs: text("duration_ms"),
  createdAt: timestamp("created_at").defaultNow(),
  
  // Relacionamento
  marketBriefId: uuid("market_brief_id"),     // FK para 08_explorando_mercados
});

// Índices úteis
// CREATE INDEX idx_research_type ON research_logs(type);
// CREATE INDEX idx_research_target ON research_logs(target);
// CREATE INDEX idx_research_date ON research_logs(created_at);
```

## 💻 Código de Produção

### Cliente Apify (src/lib/apify/client.ts)

```typescript
import { ApifyClient } from 'apify-client';

const apify = new ApifyClient({
  token: process.env.APIFY_API_TOKEN!,
});

export interface SearchResult {
  title: string;
  url: string;
  description: string;
}

export interface ScrapedPage {
  url: string;
  title: string;
  text: string;
  html: string;
}

export class WebResearcher {
  // Busca Google
  async search(query: string, maxResults = 5): Promise<SearchResult[]> {
    const run = await apify.actor("apify/google-search-scraper").call({
      queries: query,
      resultsPerPage: maxResults,
      maxPagesPerQuery: 1,
      languageCode: 'pt',
    });

    const { items } = await apify.dataset(run.defaultDatasetId).listItems();
    
    return items.map((item: any) => ({
      title: item.title,
      url: item.url,
      description: item.description,
    }));
  }

  // Scraping de página única
  async scrape(url: string, usePuppeteer = false): Promise<ScrapedPage> {
    const actorId = usePuppeteer 
      ? "apify/puppeteer-scraper" 
      : "apify/cheerio-scraper";

    const run = await apify.actor(actorId).call({
      startUrls: [{ url }],
      maxRequestsPerCrawl: 1,
    });

    const { items } = await apify.dataset(run.defaultDatasetId).listItems();
    const item = items[0];

    return {
      url: item.url,
      title: item.title,
      text: item.text || item.content,
      html: item.html,
    };
  }

  // Crawl de site completo (para análise profunda)
  async crawlSite(startUrl: string, maxPages = 10): Promise<ScrapedPage[]> {
    const run = await apify.actor("apify/website-content-crawler").call({
      startUrls: [{ url: startUrl }],
      maxCrawlPages: maxPages,
      crawlerType: "cheerio",
    });

    const results: ScrapedPage[] = [];
    for await (const item of apify.dataset(run.defaultDatasetId).iterateItems()) {
      results.push({
        url: item.url,
        title: item.title,
        text: item.text,
        html: item.html,
      });
    }
    return results;
  }
}

export const researcher = new WebResearcher();
```

### Workflow Inngest (src/inngest/functions/research.ts)

```typescript
import { inngest } from "@/inngest/client";
import { researcher } from "@/lib/apify/client";
import { generateWithFallback } from "@/lib/ai/openrouter"; // De 10_llm_app_blueprint
import { db } from "@/db";
import { researchLogs } from "@/db/schema";

export const researchWorkflow = inngest.createFunction(
  {
    id: "competitive-intelligence",
    concurrency: 3, // Rate limiting Apify
    retries: 2,
  },
  { event: "app/research.start" },
  async ({ event, step }) => {
    const { query, type, target, depth } = event.data;

    // 1. Busca Google
    const searchResults = await step.run("search", async () => {
      return await researcher.search(query, depth === 'deep' ? 10 : 5);
    });

    // 2. Scraping
    const urlsToScrape = target 
      ? [`https://${target}`]
      : searchResults.slice(0, 3).map(r => r.url);

    const scraped = await step.run("scrape", async () => {
      return await Promise.all(
        urlsToScrape.map(url => 
          researcher.scrape(url).catch(err => ({ error: err.message, url }))
        )
      );
    });

    const validScraped = scraped.filter((r: any) => !r.error);

    // 3. Análise LLM
    const context = validScraped.map((d: any) => `
URL: ${d.url}
Title: ${d.title}
Content: ${d.text?.slice(0, 3000)}
---`).join('\n');

    const analysis = await step.run("analyze", async () => {
      return await generateWithFallback([
        {
          role: 'system',
          content: 'Você é analista de inteligência competitiva. Extraia JSON estruturado.',
        },
        {
          role: 'user',
          content: `Analise e extraia: pricing, features, positioning, gaps.\n\n${context}`,
        },
      ], {
        primaryModel: "openai/gpt-4o-mini", // Barato suficiente para análise
      });
    });

    // 4. Persistir
    await step.run("save", async () => {
      await db.insert(researchLogs).values({
        query,
        type,
        target,
        depth,
        searchResults,
        scrapedData: validScraped,
        analysis: JSON.parse(analysis.content),
        createdAt: new Date(),
      });
    });

    return {
      success: true,
      analysis: JSON.parse(analysis.content),
      sources: validScraped.map((d: any) => d.url),
    };
  }
);
```

## 🔗 Integrações

| Skill | Conexão |
|:---|:---|
| `08_explorando_mercados` | Output vai para `docs/MARKET-*.md` |
| `10_llm_app_blueprint` | Usa `generateWithFallback` para análise |
| `02_planejando_solucoes` | Dados de competidor para arquitetura |
| `07_comunicando_externo` | Alertas de mudança de preço/concorrente |

## 🚫 Anti-Padrões

- ❌ Scraping sem robots.txt check
- ❌ Rate limiting ignorado (ban do Apify)
- ❌ PII desnecessária (GDPR/CCPA)
- ❌ Re-scraping < 24h (custo desnecessário)
- ❌ Não usar cache de resultados
- ❌ Análise sem contexto suficiente (LLM alucinando)

## ✅ Checklist

- [ ] `APIFY_API_TOKEN` configurado
- [ ] Schema `research_logs` aplicado
- [ ] Rate limits do Apify respeitados
- [ ] Integração com `10_llm_app_blueprint` testada
- [ ] Cache implementado (não re-scrapar < 24h)
- [ ] Robots.txt respeitado
- [ ] Output integrado com `08_explorando_mercados`

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Integrado com Stack Omega (Drizzle, Inngest)
- Conexão com `08_explorando_mercados` e `10_llm_app_blueprint`
- Schema `research_logs` para cache/observabilidade
- Foco em research competitivo (não genérico)

### v3.0.0 (Original)
- Arquitetura Apify completa
- Actors recomendados por caso de uso
- Workflow Inngest
- Ética e compliance
```

---


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
