name: pesquisando-web
description: O Pesquisador de Inteligência Competitiva. Usa Apify para buscas Google, scraping de sites e extração estruturada. Especializado em análise de concorrência (SaaS, e-commerce, tendências de mercado).
version: 3.0.0
tags: [apify, scraping, crawler, research, competitive-intelligence, market-analysis]
---

# Pesquisando Web (Intelligence Protocol v3.0)

## 🎯 Quando usar
- **Análise Competitiva**: "Como funciona o try-on da Zeekit?", "Preços e features do Vue.ai".
- **Dúvidas Factuais**: "Qual o preço atual do iPhone 15?", "Quem é o CEO da empresa X?".
- **Monitoramento Contínuo**: "Verifique se saiu vaga nova no LinkedIn da Zenvia", "Mudanças de preço do concorrente".
- **Enriquecimento de Dados**: Usuário forneceu URL, extrair resumo estruturado.
- **Tendências de Mercado**: "Micro-SaaS trends 2026", "State of AI Fashion Tech".

> **Foco Especial**: Análise de concorrência em **fashion tech**, **virtual try-on** e **e-commerce SaaS**.

---

## 🧱 Stack de Inteligência

| Componente | Ferramenta | Função | Custo Aprox. |
| :--- | :--- | :--- | :--- |
| **Busca** | Apify Google Search Scraper | Resultados SERP, rich snippets | $0.001/query |
| **Scraping Leve** | Apify Cheerio Scraper | HTML estático, blogs, docs | $0.002/page |
| **Scraping Pesado** | Apify Puppeteer Scraper | SPAs, JavaScript-heavy | $0.01/page |
| **Análise** | OpenRouter (GPT-4o/Claude) | Sumarização, extração estruturada | Variável |
| **Orquestração** | Inngest | Filas, retries, agendamento | - |
| **Storage** | Neon | Cache de resultados, histórico | - |

### Actors do Apify Recomendados

| Actor ID | Uso | Quando Usar |
| :--- | :--- | :--- |
| `apify/google-search-scraper` | Busca Google | Dados gerais, SERP, posicionamento |
| `apify/website-content-crawler` | Crawl completo | Mapear site inteiro de concorrente |
| `apify/cheerio-scraper` | Página única | Extrair pricing, features, docs |
| `apify/puppeteer-scraper` | SPA/JS-heavy | Dashboards, apps modernos |
| `apify/linkedin-profile-scraper` | Pessoas | Hiring, key people (compliance!) |
| `apify/twitter-scraper` | Social | Sentimento, anúncios |

---

## ⚙️ Fluxo de Trabalho

### Passo 1: Definição da Missão de Pesquisa (2 min)

**Classificação da Pesquisa:**

```typescript
type ResearchType = 
  | 'competitor-analysis'    // Análise completa de concorrente
  | 'pricing-intelligence'   // Monitoramento de preços
  | 'feature-comparison'     // Comparativo de funcionalidades
  | 'market-trends'          // Tendências de mercado
  | 'factual-query'          // Resposta direta
  | 'monitoring';            // Verificação periódica
```

**Template de Briefing:**

```markdown
## Missão de Pesquisa: [Nome do Concorrente/Tema]

**Objetivo**: [O que precisamos saber?]
**Alvo**: [URL específica ou termo de busca]
**Profundidade**: 
  - [ ] Superficial (títulos + snippets)
  - [ ] Média (conteúdo principal das páginas)
  - [ ] Profunda (múltiplas páginas, análise cruzada)

**Entregáveis Esperados**:
- [ ] Resumo executivo (3 parágrafos)
- [ ] Dados estruturados (JSON: pricing, features, etc.)
- [ ] Screenshots/evidências (URLs visitadas)
- [ ] Análise de gaps (o que eles têm que não temos)

**Restrições**:
- [ ] Não violar ToS (rate limiting, robots.txt)
- [ ] Não scrapear áreas logadas
- [ ] Respeitar cache (não re-scrapear < 24h)
```

---

### Passo 2: Execução Estratégica (5 min)

**A. Busca Google (Descoberta)**

```typescript
// Para análise de concorrência: encontre todos os players
const searchQueries = [
  "Zeekit virtual try on pricing",
  "Vue.ai alternatives competitors",
  "AI fashion try on SaaS 2024",
  "virtual fitting room API pricing",
  "SnapFit vs Zeekit vs Vue.ai"
];
```

**B. Scraping Direcionado (Extração)**

| Alvo | Actor | Dados Alvo |
| :--- | :--- | :--- |
| `/pricing` | Cheerio | Planos, limites, features por tier |
| `/features` | Cheerio | Lista de funcionalidades, screenshots |
| `/docs/api` | Cheerio | Documentação técnica, endpoints |
| `/about` | Cheerio | Funding, team size, investors |
| Blog/Case studies | Crawler | Messaging, positioning, ICP |

**C. Análise Competitiva Estruturada**

```typescript
interface CompetitorAnalysis {
  company: {
    name: string;
    website: string;
    founded?: string;
    funding?: string;
    employees?: string;
  };
  product: {
    category: string;
    positioning: string;  // "Enterprise" vs "SMB"
    keyDifferentiators: string[];
    techStack?: string[]; // Inferido de docs, job postings
  };
  pricing: {
    model: 'usage-based' | 'seat-based' | 'hybrid';
    tiers: Array<{
      name: string;
      price: string;
      limits: Record<string, string>;
      features: string[];
    }>;
    freeTier: boolean;
    enterpriseContact: boolean;
  };
  strengths: string[];
  weaknesses: string[];
  opportunities: string[]; // Para nós: gaps que podemos explorar
  threats: string[];       // Riscos para nossa posição
}
```

---

### Passo 3: Processamento e Síntese (5 min)

**Pipeline de Análise:**

1. **Limpeza**: Remover HTML, scripts, navbars (usando readability ou LLM)
2. **Extração Estruturada**: Converter texto em JSON tipado
3. **Comparação**: Cruzar com nossos dados (se disponível)
4. **Sumarização**: Gerar insights acionáveis

```typescript
// Exemplo: Extração de pricing via LLM
const pricingPrompt = `
Analise o texto abaixo de uma página de preços e extraia:
1. Nome de cada plano
2. Preço (mensal/anual)
3. Limites principais (requests, usuários, etc.)
4. Features incluídas em cada tier
5. Se há free trial ou free tier

Texto: """${scrapedContent}"""

Responda em JSON válido seguindo o schema CompetitorPricing.
`;
```

---

### Passo 4: Entrega e Arquivamento (2 min)

**Formatos de Saída:**

```markdown
# Relatório de Inteligência Competitiva: [Concorrente]

## Executive Summary
[3-5 parágrafos com insights chave]

## Ficha Técnica
| Atributo | Valor |
| :--- | :--- |
| Website | [URL] |
| Funding | [Dado] |
| Pricing | [Link / Resumo] |

## Análise de Pricing
[Tabela comparativa]

## Feature Matrix
[Checklist de funcionalidades]

## Oportunidades Identificadas
1. [Gap que podemos explorar]
2. [Diferenciação possível]

## Evidências
- [URLs visitadas com timestamps]
- [Screenshots relevantes]
- [Trechos de código/docs]
```

**Arquivamento:**
- [ ] Salvar no banco (competitor_intelligence table)
- [ ] Taggear com data, tipo de pesquisa, solicitante
- [ ] Alertar se mudanças significativas detectadas (vs. cache)

---

## 📋 Checklist de Qualidade e Ética

### Qualidade dos Dados
- [ ] Múltiplas fontes cruzadas (não confiar em uma única página)?
- [ ] Dados com data de coleta (inteligência envelhece rápido)?
- [ ] Screenshots/evidências para claims importantes?
- [ ] Cache configurado (evitar re-scraping desnecessário)?

### Ética e Compliance
- [ ] Respeitando robots.txt?
- [ ] Rate limiting adequado (não sobrecarregar servidores)?
- [ ] Não acessando áreas logadas/protegidas?
- [ ] GDPR/CCPA: não coletando PII desnecessária?
- [ ] Termos de Uso do site alvo permitem scraping?

### Custo
- [ ] Actor mais barato suficiente para o job (Cheerio > Puppeteer)?
- [ ] Limitando maxResults/maxPages?
- [ ] Reutilizando resultados em cache quando possível?

---

## 💻 Snippets de Produção

### apify_client.ts (Cliente Tipado Completo)

```typescript
// lib/apify/client.ts
import { ApifyClient } from 'apify-client';

const apify = new ApifyClient({
  token: process.env.APIFY_API_TOKEN,
});

// Interfaces de resultado
export interface GoogleSearchResult {
  title: string;
  url: string;
  description: string;
  position: number;
}

export interface ScrapedContent {
  url: string;
  title: string;
  text: string;
  html: string;
  metadata: Record<string, string>;
}

export interface CompetitorData {
  pricing?: any;
  features?: string[];
  description?: string;
}

export class WebResearcher {
  // Busca Google com cache
  async searchGoogle(
    query: string, 
    options: {
      maxResults?: number;
      includeAds?: boolean;
      languageCode?: string;
    } = {}
  ): Promise<GoogleSearchResult[]> {
    const { maxResults = 5, includeAds = false, languageCode = 'pt' } = options;

    const run = await apify.actor("apify/google-search-scraper").call({
      queries: query,
      resultsPerPage: maxResults,
      maxPagesPerQuery: 1,
      languageCode,
      includeUnfilteredResults: false,
      includeAds,
    });

    const { items } = await apify.dataset(run.defaultDatasetId).listItems();
    
    return items.map((item: any) => ({
      title: item.title,
      url: item.url,
      description: item.description,
      position: item.position,
    }));
  }

  // Scraping inteligente (escolhe actor baseado na página)
  async scrapePage(url: string, options: {
    waitForSelector?: string;
    javascriptEnabled?: boolean;
  } = {}): Promise<ScrapedContent> {
    const actorId = options.javascriptEnabled 
      ? "apify/puppeteer-scraper" 
      : "apify/cheerio-scraper";

    const run = await apify.actor(actorId).call({
      startUrls: [{ url }],
      maxRequestsPerCrawl: 1,
      ...(options.waitForSelector && { waitForSelector: options.waitForSelector }),
    });

    const { items } = await apify.dataset(run.defaultDatasetId).listItems();
    const item = items[0];

    return {
      url: item.url,
      title: item.title,
      text: item.text || item.content,
      html: item.html,
      metadata: {
        loadTime: item.loadTime,
        pageTitle: item.pageTitle,
      },
    };
  }

  // Crawl completo de site (para análise profunda)
  async crawlSite(startUrl: string, options: {
    maxPages?: number;
    includeUrls?: string[];
    excludeUrls?: string[];
  } = {}): Promise<ScrapedContent[]> {
    const { maxPages = 10 } = options;

    const run = await apify.actor("apify/website-content-crawler").call({
      startUrls: [{ url: startUrl }],
      maxCrawlPages: maxPages,
      crawlerType: "cheerio", // ou "playwright" para JS-heavy
    });

    const results: ScrapedContent[] = [];
    for await (const item of apify.dataset(run.defaultDatasetId).iterateItems()) {
      results.push({
        url: item.url,
        title: item.title,
        text: item.text,
        html: item.html,
        metadata: item.metadata,
      });
    }

    return results;
  }

  // Análise de concorrente específica
  async analyzeCompetitor(domain: string): Promise<CompetitorData> {
    // 1. Página principal
    const home = await this.scrapePage(`https://${domain}`);
    
    // 2. Página de pricing (tentativa)
    let pricing = null;
    try {
      const pricingPage = await this.scrapePage(`https://${domain}/pricing`);
      pricing = await this.extractPricing(pricingPage.text);
    } catch (e) {
      console.log("Pricing page not found or accessible");
    }

    return {
      description: home.text.slice(0, 500),
      pricing,
    };
  }

  private async extractPricing(text: string): Promise<any> {
    // Usar LLM para extrair estrutura de pricing
    // Implementação depende do cliente OpenRouter
    return null;
  }
}

export const researcher = new WebResearcher();
```

### research_workflow.ts (Workflow Inngest Completo)

```typescript
// inngest/functions/research.ts
import { inngest } from "@/inngest/client";
import { researcher } from "@/lib/apify/client";
import { openrouter } from "@/lib/openrouter/client"; // Assumindo cliente similar
import { db } from "@/lib/db";

interface ResearchEvent {
  query: string;
  type: 'competitor-analysis' | 'pricing' | 'trends' | 'factual';
  depth: 'shallow' | 'medium' | 'deep';
  competitorDomain?: string;
  saveToDb?: boolean;
}

export const researchWorkflow = inngest.createFunction(
  {
    id: "competitive-intelligence",
    name: "Competitive Intelligence Research",
    concurrency: 3, // Evitar rate limits
    retries: 2,
  },
  { event: "app/research.start" },
  async ({ event, step, logger }) => {
    const { query, type, depth, competitorDomain, saveToDb = true } = event.data as ResearchEvent;

    logger.info(`Iniciando pesquisa: ${type} - ${query}`);

    // 1. Busca inicial (se não for análise direta de domínio)
    let searchResults = [];
    if (!competitorDomain) {
      searchResults = await step.run("google-search", async () => {
        return await researcher.searchGoogle(query, {
          maxResults: depth === 'deep' ? 10 : 5,
        });
      });
    }

    // 2. Scraping de páginas relevantes
    const scrapedData = await step.run("scraping", async () => {
      const urlsToScrape = competitorDomain 
        ? [`https://${competitorDomain}`]
        : searchResults.slice(0, depth === 'deep' ? 5 : 3).map(r => r.url);

      const results = await Promise.all(
        urlsToScrape.map(url => 
          researcher.scrapePage(url).catch(err => ({ error: err.message, url }))
        )
      );

      return results.filter(r => !('error' in r));
    });

    // 3. Análise com LLM
    const analysis = await step.run("llm-analysis", async () => {
      const context = scrapedData.map(d => `
URL: ${d.url}
Title: ${d.title}
Content: ${d.text.slice(0, 3000)}
---`).join('\n');

      const prompt = type === 'competitor-analysis' 
        ? generateCompetitorPrompt(query, context)
        : generateGeneralPrompt(query, context);

      const response = await openrouter.generate([
        { role: 'system', content: 'Você é um analista de inteligência competitiva.' },
        { role: 'user', content: prompt },
      ]);

      return response.content;
    });

    // 4. Parse estruturado (tentativa)
    let structuredData = null;
    try {
      structuredData = JSON.parse(analysis);
    } catch {
      structuredData = { summary: analysis, error: "Não foi possível parsear JSON" };
    }

    // 5. Persistir no banco
    if (saveToDb) {
      await step.run("persist-results", async () => {
        await db.insert(researchLogs).values({
          query,
          type,
          depth,
          results: searchResults,
          analysis: structuredData,
          scrapedUrls: scrapedData.map(d => d.url),
          createdAt: new Date(),
        });
      });
    }

    return {
      success: true,
      query,
      type,
      summary: typeof structuredData === 'object' ? structuredData.summary : analysis,
      data: structuredData,
      sources: scrapedData.map(d => ({ url: d.url, title: d.title })),
    };
  }
);

function generateCompetitorPrompt(query: string, context: string): string {
  return `
Analise o concorrente baseado nos dados coletados e forneça:

1. Resumo executivo (2-3 parágrafos)
2. JSON estruturado com:
   - company: { name, positioning, targetAudience }
   - pricing: { model, tiers[], freeTier }
   - product: { keyFeatures[], differentiators[], techStack[] }
   - strengths: string[]
   - weaknesses: string[]
   - opportunities: string[] (gaps para explorarmos)

Dados coletados:
${context}

Query original: ${query}

Responda em português, JSON válido seguido de análise textual.
`;
}

function generateGeneralPrompt(query: string, context: string): string {
  return `
Responda à pergunta "${query}" baseado nos dados coletados.

Dados:
${context}

Forneça:
1. Resposta direta e factual
2. Fontes consultadas
3. Nível de confiança (alto/médio/baixo)
4. Recomendações de próximos passos se a informação for insuficiente
`;
}
```

### test_search.py (Script de Teste)

```python
#!/usr/bin/env python3
"""
Script de teste rápido para validar integração Apify.
Útil para verificar credenciais antes de deploy.
"""

import os
import sys
import json
from apify_client import ApifyClient

def check_env():
    """Verifica variáveis necessárias."""
    token = os.getenv("APIFY_API_TOKEN")
    if not token:
        print("❌ APIFY_API_TOKEN não encontrado")
        print("   Defina: export APIFY_API_TOKEN='seu_token_aqui'")
        sys.exit(1)
    return token

def test_google_search(client, query="fashion tech startups 2024"):
    """Testa busca Google."""
    print(f"\n🔎 Testando Google Search: '{query}'")
    
    try:
        run = client.actor("apify/google-search-scraper").call({
            "queries": query,
            "maxPagesPerQuery": 1,
            "resultsPerPage": 3,
        })
        
        results = []
        for item in client.dataset(run["defaultDatasetId"]).iterate_items():
            results.append({
                "title": item.get("title"),
                "url": item.get("url"),
                "description": item.get("description")[:100] + "..."
            })
        
        print(f"✅ Sucesso! {len(results)} resultados encontrados")
        for r in results:
            print(f"   • {r['title'][:50]}...")
        return True
        
    except Exception as e:
        print(f"❌ Falha: {e}")
        return False

def test_scraping(client, url="https://example.com"):
    """Testa scraping simples."""
    print(f"\n🌐 Testando Scraping: {url}")
    
    try:
        run = client.actor("apify/cheerio-scraper").call({
            "startUrls": [{"url": url}],
            "maxRequestsPerCrawl": 1,
        })
        
        items = list(client.dataset(run["defaultDatasetId"]).iterate_items())
        if items:
            item = items[0]
            print(f"✅ Sucesso! Título: {item.get('title')}")
            print(f"   Texto extraído: {len(item.get('text', ''))} caracteres")
            return True
        else:
            print("⚠️ Nenhum dado retornado")
            return False
            
    except Exception as e:
        print(f"❌ Falha: {e}")
        return False

def main():
    print("🧪 Teste de Integração Apify")
    print("=" * 50)
    
    token = check_env()
    client = ApifyClient(token=token)
    
    # Testes
    tests = [
        ("Google Search", lambda: test_google_search(client)),
        ("Web Scraping", lambda: test_scraping(client)),
    ]
    
    results = []
    for name, test_fn in tests:
        try:
            success = test_fn()
            results.append((name, success))
        except Exception as e:
            print(f"❌ {name} erro inesperado: {e}")
            results.append((name, False))
    
    # Resumo
    print("\n" + "=" * 50)
    print("📊 Resumo dos Testes:")
    for name, success in results:
        status = "✅ PASSOU" if success else "❌ FALHOU"
        print(f"   {name}: {status}")
    
    if all(r[1] for r in results):
        print("\n🎉 Todos os testes passaram! Apify configurado corretamente.")
        sys.exit(0)
    else:
        print("\n⚠️ Alguns testes falharam. Verifique configuração.")
        sys.exit(1)

if __name__ == "__main__":
    main()
```

---

## 🗂️ Estrutura de Arquivos

```
Minhas Skills/pesquisando-web/
├── SKILL.md                              # Este protocolo
├── snippets/
│   ├── apify_client.ts                   # Cliente tipado completo
│   ├── research_workflow.ts              # Workflow Inngest
│   └── competitive_analysis_template.ts  # Templates de análise
├── scripts/
│   ├── test_search.py                    # Teste de integração
│   ├── competitor_monitor.py             # Monitoramento contínuo
│   └── extract_structured.py             # Extração via LLM
└── resources/
    ├── briefing_template.md              # Template de missão
    ├── output_template.md                # Template de relatório
    └── competitor_schema.json            # Schema de dados estruturados
```

