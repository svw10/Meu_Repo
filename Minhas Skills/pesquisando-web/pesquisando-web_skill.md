### 📂 Estrutura de Diretórios

```text
Minhas Skills/
└── pesquisando-web/
    ├── SKILL.md
    ├── scripts/
    │   └── test_search.py       # Teste rápido de pesquisa via terminal
    └── snippets/
        ├── apify_client.ts      # Cliente tipado para o Apify
        └── research_workflow.ts # Workflow Inngest (Search -> Scrape -> Summarize)



### 1. O Cérebro (`Minhas Skills/pesquisando-web/SKILL.md`)

---
name: pesquisando-web
description: O Pesquisador. Usa Apify para realizar buscas no Google, scraping de sites e extração de dados estruturados. Orquestra a leitura e sumarização de conteúdo externo.
version: 1.0.0
tags: [apify, scraping, crawler, research, google]
---

# Pesquisando Web (Intelligence Protocol)

## 🎯 Quando usar
- **Dúvidas Factuais**: "Qual o preço atual do iPhone 15?"; "Quem é o CEO da empresa X?".
- **Monitoramento**: "Verifique se saiu vaga nova no LinkedIn da Zenvia".
- **Enriquecimento**: O usuário deu uma URL e quer um resumo.

## 🧱 Stack Vinculada
Esta skill é um wrapper de inteligência sobre:
- **Apify**: O motor de execução (Actors: `google-search-scraper`, `website-content-crawler`).
- **Inngest**: Gerencia o tempo de espera (Scraping pode demorar 30s+).
- **OpenRouter**: Lê o HTML sujo extraído e transforma em Resumo Limpo.

## ⚙️ Fluxo de Trabalho

- [ ] **1. Definição do Alvo**
    - É uma busca geral? -> Use `google-search-scraper`.
    - É um site específico? -> Use `website-content-crawler`.
    - É uma rede social? -> Use Actors específicos (Instagram/LinkedIn Scrapers).

- [ ] **2. Execução Assíncrona (Apify + Inngest)**
    - O agente nunca deve travar a thread esperando o site carregar.
    - Dispare o job no Apify e aguarde o Webhook ou faça polling via Inngest (`step.waitForEvent` ou `step.sleep`).

- [ ] **3. Processamento e Limpeza**
    - O Apify devolve muito lixo (HTML, scripts).
    - Use o LLM (OpenRouter) para filtrar apenas o texto relevante antes de mostrar ao usuário.

## 📋 Checklist de Custo e Performance
- [ ] O Actor escolhido é o mais barato para a tarefa? (Ex: Cheerio é mais barato que Puppeteer).
- [ ] Limitou o número de resultados (`maxItems`)? Não traga a internet inteira.

## 💻 Snippets e Recursos

### Snippet 1: Disparo de Pesquisa (Exemplo Conceitual)
```typescript
await inngest.send({
  name: "app/research.start",
  data: {
    query: "Tendências de Micro-SaaS 2026",
    depth: "deep" // deep = lê o conteúdo dos sites; fast = só lê os títulos do Google
  }
});


---

### 2. Snippets de Produção

#### `snippets/apify_client.ts` (O Braço Mecânico)
Configuração segura do cliente Apify para usar no seu Next.js.

```typescript
import { ApifyClient } from 'apify-client';

// Singleton para não criar múltiplas conexões
const apify = new ApifyClient({
    token: process.env.APIFY_API_TOKEN,
});

export async function googleSearch(query: string, maxResults = 5) {
    // Usa o Google Search Scraper oficial
    const input = {
        queries: query,
        resultsPerPage: maxResults,
        maxPagesPerQuery: 1,
    };

    // Inicia e espera terminar (para buscas rápidas)
    const run = await apify.actor("apify/google-search-scraper").call(input);
    
    // Pega os resultados do Dataset
    const { items } = await apify.dataset(run.defaultDatasetId).listItems();
    return items;
}

export async function scrapeUrl(url: string) {
    // Usa o Cheerio (mais leve/rápido) para ler o texto da página
    const run = await apify.actor("apify/cheerio-scraper").call({
        startUrls: [{ url }],
        maxRequestsPerCrawl: 1,
    });

    const { items } = await apify.dataset(run.defaultDatasetId).listItems();
    return items[0]; // Retorna o conteúdo da primeira URL
}


#### `snippets/research_workflow.ts` (O Cérebro da Pesquisa no Inngest)

Este workflow faz o trabalho pesado: Busca no Google -> Entra nos Sites -> Resume o que encontrou.

import { inngest } from "@/inngest/client";
import { googleSearch, scrapeUrl } from "./apify_client";
import { generateSummary } from "@/lib/llm"; // Sua função do OpenRouter

export const researchWorkflow = inngest.createFunction(
  { id: "web-researcher", concurrency: 5 },
  { event: "app/research.start" },
  async ({ event, step }) => {
    
    const { query } = event.data;

    // 1. Buscar Links no Google
    const searchResults = await step.run("google-search", async () => {
      return await googleSearch(query, 3);
    });

    // 2. Ler o conteúdo de cada link (Paralelo)
    const contents = await step.run("scrape-contents", async () => {
      // Mapeia os 3 primeiros links e faz scraping
      const promises = searchResults.slice(0, 3).map(result => 
        scrapeUrl(result.url).catch(e => ({ error: true }))
      );
      return await Promise.all(promises);
    });

    // 3. Sintetizar Resposta com LLM
    const finalReport = await step.run("summarize-findings", async () => {
      const fullText = contents.map(c => c.text || "").join("\n\n");
      return await generateSummary(`Resuma isto baseado na query '${query}':\n${fullText}`);
    });

    // 4. Salvar na Memória (Opcional, chama a skill de memória)
    // await step.invoke("save-memory", { content: finalReport, tags: "research" });

    return { report: finalReport };
  }
);



### 3. Script de Teste Rápido (`scripts/test_search.py`)

Para testar se sua chave Apify está funcionando sem subir o servidor inteiro.

import os
from apify_client import ApifyClient

# Requer: pip install apify-client
TOKEN = os.getenv("APIFY_API_TOKEN")

if not TOKEN:
    print("❌ APIFY_API_TOKEN não encontrado no ambiente.")
    exit(1)

client = ApifyClient(token=TOKEN)

def test_google(query):
    print(f"🔎 Pesquisando no Google via Apify: '{query}'...")
    
    # Input para o Google Search Scraper
    run_input = {
        "queries": query,
        "maxPagesPerQuery": 1,
        "resultsPerPage": 3,
    }

    # Executa o Actor
    run = client.actor("apify/google-search-scraper").call(run_input)
    
    print("✅ Busca concluída! Extraindo resultados...")
    
    # Lista resultados
    for item in client.dataset(run["defaultDatasetId"]).iterate_items():
        title = item.get("title", "Sem título")
        link = item.get("url", "Sem link")
        print(f"- {title}\n  🔗 {link}\n")

if __name__ == "__main__":
    test_google("Zenvia micro-saas trends")

