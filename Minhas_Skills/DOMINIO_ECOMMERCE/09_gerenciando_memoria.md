---
name: gerenciando_memoria
framework: "Antigravity OS v3.1"
owner_agent: BETA
trigger: "/memory"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: gerenciando-memoria
description: Bibliotecário de Produtos. RAG de catálogo usando Neon pgvector, embeddings semânticos, busca multimodal. Otimizado para e-commerce multi-tenant.
version: 3.0.1
tags: [rag, vector-db, neon, produto, catalogo, embeddings, ecommerce, pgvector]
---

# 09 - GERENCIANDO MEMÓRIA DE PRODUTOS (Product RAG Protocol)

## 🎯 Quando usar
- **Indexação**: Novos produtos precisam ser vetorizados para busca semântica
- **Busca inteligente**: Cliente descreve "vestido verão floral" → encontrar SKU
- **Recomendações**: Produtos similares ao item atual (cross-sell, up-sell)
- **Enriquecimento**: Descrições geradas por IA, tags automáticas
- **Sincronização**: Atualizar embeddings quando dados mudam

> **Diferença**: Não é "memória de lições aprendidas". É **catálogo vivo** — buscável, recomendável, multi-tenant.

## 🧱 Arquitetura Stack Omega + Especialização

| Componente | Stack Omega | Especialização Produto |
|:---|:---|:---|
| **Database** | Neon PostgreSQL | pgvector extension, índice HNSW |
| **ORM** | Drizzle | Schema type-safe, migrations |
| **Embeddings** | OpenRouter | `text-embedding-3-small` (1536d) |
| **Busca** | SQL + pgvector | Funções PL/pgSQL especializadas |
| **Multi-tenancy** | tenant_id em todas as tabelas | Isolamento por loja (SnapFit) |

## 🗄️ Schema Drizzle (Alternativa ao SQL Raw)

```typescript
// src/db/schema/products.ts
import { pgTable, uuid, varchar, text, decimal, 
         integer, boolean, jsonb, timestamp, index, vector } from "drizzle-orm/pg-core";

export const productEmbeddings = pgTable("product_embeddings", {
  id: uuid("id").defaultRandom().primaryKey(),
  
  // Multi-tenancy
  tenantId: varchar("tenant_id", { length: 100 }).notNull(),
  sku: varchar("sku", { length: 100 }).notNull(),
  
  // Conteúdo
  title: text("title").notNull(),
  description: text("description"),
  categoryPath: text("category_path"), // "Roupas > Feminino > Vestidos"
  attributes: jsonb("attributes"),      // {cor: "azul", tamanho: "M"}
  tags: text("tags").array(),
  
  // Negócio
  price: decimal("price", { precision: 10, scale: 2 }),
  currency: varchar("currency", { length: 3 }).default("BRL"),
  stockQuantity: integer("stock_quantity").default(0),
  isActive: boolean("is_active").default(true),
  
  // Vetor
  textEmbedding: vector("text_embedding", { dimensions: 1536 }),
  
  // Metadados
  sourceUrl: text("source_url"),
  lastSynced: timestamp("last_synced").defaultNow(),
  embeddingVersion: integer("embedding_version").default(1),
  
  createdAt: timestamp("created_at").defaultNow().notNull(),
  updatedAt: timestamp("updated_at").defaultNow().notNull(),
}, (table) => ({
  // Índices
  vectorIdx: index("product_embedding_vector_idx").using("hnsw", 
    table.textEmbedding.op("vector_cosine_ops")),
  tenantIdx: index("product_tenant_idx").on(table.tenantId),
  skuIdx: index("product_sku_idx").on(table.sku),
  activeIdx: index("product_active_idx").on(table.isActive).where(
    sql`${table.isActive} = true`
  ),
}));

// Relações
export const productEmbeddingsRelations = relations(productEmbeddings, ({ one }) => ({
  tenant: one(tenants, {
    fields: [productEmbeddings.tenantId],
    references: [tenants.id],
  }),
}));
```

**SQL Equivalente (para migrations):**
```sql
-- Executar via drizzle-kit ou manualmente
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE IF NOT EXISTS product_embeddings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id VARCHAR(100) NOT NULL,
    sku VARCHAR(100) UNIQUE NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    category_path TEXT,
    attributes JSONB,
    tags TEXT[],
    price DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'BRL',
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    text_embedding VECTOR(1536),
    source_url TEXT,
    last_synced TIMESTAMPTZ DEFAULT NOW(),
    embedding_version INTEGER DEFAULT 1,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_product_embeddings_vector ON product_embeddings 
USING hnsw (text_embedding vector_cosine_ops);

CREATE INDEX idx_product_tenant ON product_embeddings(tenant_id);
CREATE INDEX idx_product_active ON product_embeddings(is_active) WHERE is_active = true;
```

## ⚙️ Fluxo de Trabalho

### A. Indexação de Produtos (Write)

**Trigger**: Novo produto no ERP, upload em massa, ou atualização.

```typescript
// Server Action: src/lib/actions/products/index-product.ts
'use server';

import { db } from '@/db';
import { productEmbeddings } from '@/db/schema';
import { generateEmbedding } from '@/lib/ai/embeddings';
import { normalizeAttributes } from '@/lib/products/normalize';
import { eq, sql } from 'drizzle-orm';

interface IndexProductInput {
  tenantId: string;
  sku: string;
  title: string;
  description?: string;
  categoryPath: string;
  attributes: Record<string, string>;
  price: number;
  imageUrl?: string;
}

export async function indexProduct(input: IndexProductInput) {
  // 1. Normalizar atributos
  const normalizedAttrs = normalizeAttributes(input.attributes);
  
  // 2. Enriquecer descrição se necessário
  let enhancedDescription = input.description;
  if (!input.description || input.description.length < 50) {
    enhancedDescription = await generateEnhancedDescription(
      input.title, 
      normalizedAttrs
    );
  }
  
  // 3. Construir texto para embedding
  const embeddingText = constructEmbeddingText({
    title: input.title,
    description: enhancedDescription,
    category: input.categoryPath,
    attributes: normalizedAttrs,
  });
  
  // 4. Gerar embedding
  const embedding = await generateEmbedding(embeddingText);
  
  // 5. Upsert no banco (Drizzle)
  await db.insert(productEmbeddings)
    .values({
      tenantId: input.tenantId,
      sku: input.sku,
      title: input.title,
      description: enhancedDescription,
      categoryPath: input.categoryPath,
      attributes: normalizedAttrs,
      price: input.price.toString(),
      textEmbedding: embedding,
      sourceUrl: input.imageUrl,
      updatedAt: new Date(),
    })
    .onConflictDoUpdate({
      target: productEmbeddings.sku,
      set: {
        title: input.title,
        description: enhancedDescription,
        categoryPath: input.categoryPath,
        attributes: normalizedAttrs,
        price: input.price.toString(),
        textEmbedding: embedding,
        sourceUrl: input.imageUrl,
        updatedAt: new Date(),
        embeddingVersion: sql`${productEmbeddings.embeddingVersion} + 1`,
      },
      where: sql`(
        ${productEmbeddings.description} IS DISTINCT FROM ${enhancedDescription}
        OR ${productEmbeddings.title} IS DISTINCT FROM ${input.title}
      )`,
    });
  
  return { success: true, sku: input.sku };
}

// Helper: Construir texto rico
function constructEmbeddingText(params: {
  title: string;
  description?: string;
  category: string;
  attributes: Record<string, string>;
}) {
  const parts = [params.title];
  
  if (params.description) parts.push(params.description);
  parts.push(`Categoria: ${params.category}`);
  
  const attrText = Object.entries(params.attributes)
    .map(([k, v]) => `${k}: ${v}`)
    .join(', ');
  
  if (attrText) parts.push(`Características: ${attrText}`);
  
  return parts.join('. ');
}
```

### B. Busca Semântica (Read)

**Cenários**: Busca por descrição, recomendações, filtros combinados.

```typescript
// Server Action: src/lib/actions/products/search-products.ts
'use server';

import { db } from '@/db';
import { productEmbeddings } from '@/db/schema';
import { generateEmbedding } from '@/lib/ai/embeddings';
import { sql, eq, and, gte, lte } from 'drizzle-orm';

interface SearchProductsInput {
  tenantId: string;
  query: string;
  limit?: number;
  categoryFilter?: string;
  minPrice?: number;
  maxPrice?: number;
  minSimilarity?: number;
}

export async function searchProducts(input: SearchProductsInput) {
  // 1. Gerar embedding da query
  const queryEmbedding = await generateEmbedding(input.query);
  
  // 2. Busca vetorial com filtros (SQL raw via Drizzle)
  const results = await db.execute(sql`
    SELECT 
      p.sku,
      p.title,
      p.description,
      p.price,
      1 - (p.text_embedding <=> ${queryEmbedding}::vector) as similarity,
      p.attributes,
      p.category_path
    FROM ${productEmbeddings} p
    WHERE p.tenant_id = ${input.tenantId}
      AND p.is_active = true
      AND 1 - (p.text_embedding <=> ${queryEmbedding}::vector) > ${input.minSimilarity ?? 0.7}
      ${input.categoryFilter ? sql`AND p.category_path ILIKE ${'%' + input.categoryFilter + '%'}` : sql``}
      ${input.minPrice ? sql`AND p.price >= ${input.minPrice}` : sql``}
      ${input.maxPrice ? sql`AND p.price <= ${input.maxPrice}` : sql``}
    ORDER BY p.text_embedding <=> ${queryEmbedding}::vector
    LIMIT ${input.limit ?? 10}
  `);
  
  return results.map(row => ({
    sku: row.sku,
    title: row.title,
    description: row.description,
    price: parseFloat(row.price),
    similarity: parseFloat(row.similarity),
    attributes: row.attributes,
    category: row.category_path,
  }));
}

// Uso em API Route ou Server Component
// const results = await searchProducts({
//   tenantId: 'loja-exemplo',
//   query: 'vestido leve para praia',
//   maxPrice: 200,
//   limit: 5
// });
```

### C. Recomendações por Similaridade

```typescript
// Server Action: src/lib/actions/products/similar-products.ts
'use server';

import { db } from '@/db';
import { productEmbeddings } from '@/db/schema';
import { sql, eq, and, ne } from 'drizzle-orm';

export async function getSimilarProducts(
  tenantId: string, 
  sku: string, 
  limit: number = 4
) {
  // 1. Buscar embedding do produto de referência
  const reference = await db.query.productEmbeddings.findFirst({
    where: and(
      eq(productEmbeddings.tenantId, tenantId),
      eq(productEmbeddings.sku, sku)
    ),
  });
  
  if (!reference) throw new Error('Produto não encontrado');
  
  // 2. Buscar similares (mesma categoria, excluindo o próprio)
  const similar = await db.execute(sql`
    SELECT 
      p.sku,
      p.title,
      p.price,
      1 - (p.text_embedding <=> ${reference.textEmbedding}::vector) as similarity
    FROM ${productEmbeddings} p
    WHERE p.tenant_id = ${tenantId}
      AND p.sku != ${sku}
      AND p.is_active = true
      AND p.category_path = ${reference.categoryPath}
    ORDER BY p.text_embedding <=> ${reference.textEmbedding}::vector
    LIMIT ${limit}
  `);
  
  return similar.map(row => ({
    sku: row.sku,
    title: row.title,
    price: parseFloat(row.price),
    similarity: parseFloat(row.similarity),
  }));
}
```

### D. Sincronização e Manutenção

**Regras de negócio:**

| Mudança | Ação | Recria embedding? |
|:---|:---|:---:|
| Preço alterado | Atualiza metadados | ❌ Não |
| Estoque muda | `is_active = false` se zero | ❌ Não |
| Descrição/título muda | Atualiza e reindexa | ✅ Sim |
| Nova imagem | Futuro: reprocessa visual | ✅ Sim |
| Produto deletado | Soft delete (manter histórico) | ❌ Não |

```typescript
// Cron Job via Inngest: src/inngest/functions/sync-catalog.ts
import { inngest } from '@/inngest/client';
import { db } from '@/db';
import { productEmbeddings } from '@/db/schema';
import { eq, lt, and } from 'drizzle-orm';

// 1. Sincronização incremental
export const syncCatalogIncremental = inngest.createFunction(
  { id: 'sync-catalog-incremental' },
  { cron: '0 */6 * * *' }, // A cada 6 horas
  async ({ step }) => {
    // Buscar produtos modificados desde última sync
    const staleProducts = await step.run('find-stale', async () => {
      return await db.query.productEmbeddings.findMany({
        where: lt(productEmbeddings.lastSynced, new Date(Date.now() - 6 * 60 * 60 * 1000)),
        limit: 100,
      });
    });
    
    // Reindexar em batch
    for (const batch of chunk(staleProducts, 10)) {
      await step.run(`reindex-batch-${batch[0].id}`, async () => {
        for (const product of batch) {
          await reindexProduct(product); // Função que regenera embedding
        }
      });
    }
    
    return { processed: staleProducts.length };
  }
);

// 2. Limpeza de inativos
export const cleanupInactive = inngest.createFunction(
  { id: 'cleanup-inactive-products' },
  { cron: '0 2 * * 0' }, // Domingo 2h da manhã
  async ({ step }) => {
    const deleted = await step.run('cleanup', async () => {
      const result = await db.delete(productEmbeddings)
        .where(and(
          eq(productEmbeddings.isActive, false),
          lt(productEmbeddings.updatedAt, new Date(Date.now() - 30 * 24 * 60 * 60 * 1000))
        ))
        .returning({ sku: productEmbeddings.sku });
      return result;
    });
    
    return { deleted: deleted.length };
  }
);
```

## 🧠 Normalização de Atributos

```typescript
// src/lib/products/normalize.ts
const COLOR_MAP: Record<string, string> = {
  'azul marinho': 'azul',
  'azul royal': 'azul',
  'azul claro': 'azul',
  'vermelho escuro': 'vermelho',
  'rosa pink': 'rosa',
  'rosa choque': 'rosa',
  'preto fosco': 'preto',
  'branco off': 'branco',
  'branco neve': 'branco',
};

const SIZE_MAP: Record<string, string> = {
  'pp': 'XS',
  'p': 'S',
  'm': 'M',
  'g': 'L',
  'gg': 'XL',
  'xgg': 'XXL',
  'extra grande': 'XL',
};

export function normalizeAttributes(
  raw: Record<string, string>
): Record<string, string> {
  const normalized: Record<string, string> = {};
  
  for (const [key, value] of Object.entries(raw)) {
    const keyLower = key.toLowerCase().trim();
    const valLower = value.toLowerCase().trim();
    
    // Normalizar cores
    if (['cor', 'color', 'colour'].includes(keyLower)) {
      normalized[keyLower] = COLOR_MAP[valLower] || valLower;
    }
    // Normalizar tamanhos
    else if (['tamanho', 'size', 'tam'].includes(keyLower)) {
      normalized[keyLower] = SIZE_MAP[valLower] || valLower.toUpperCase();
    }
    // Material padronizado
    else if (keyLower === 'material') {
      normalized[keyLower] = valLower
        .replace('algodão', 'algodao') // Remove acentos para busca
        .replace('poliéster', 'poliester');
    }
    else {
      normalized[keyLower] = valLower;
    }
  }
  
  return normalized;
}
```

## 📋 Checklist de Operações

### Indexação:
- [ ] SKU único por tenant (constraint)
- [ ] Atributos normalizados antes de gerar embedding
- [ ] Imagem com URL pública (para futuro embedding visual)
- [ ] Preço em decimal correto (evitar float)

### Busca:
- [ ] Tenant ID sempre aplicado (isolamento)
- [ ] Filtro `is_active = true` (não mostrar esgotados)
- [ ] Limite de resultados (paginação)
- [ ] Fallback para busca textual se RAG falhar

### Manutenção:
- [ ] Monitorar latência (< 100ms para busca)
- [ ] Taxa de clique (feedback implícito de qualidade)
- [ ] Produtos sem embedding (erros de indexação)
- [ ] Tamanho do índice (quando particionar por tenant?)

## 🛠️ Scripts de Apoio (RECURSOS/scripts/)

### bulk_index.ts
```typescript
#!/usr/bin/env ts-node
// scripts/bulk-index-products.ts
import { parse } from 'csv-parse';
import fs from 'fs';
import { indexProduct } from '@/lib/actions/products/index-product';

async function bulkIndex(csvPath: string, tenantId: string) {
  const parser = fs.createReadStream(csvPath).pipe(parse({
    columns: true,
    skip_empty_lines: true,
  }));
  
  let count = 0;
  for await (const record of parser) {
    await indexProduct({
      tenantId,
      sku: record.sku,
      title: record.title,
      description: record.description,
      categoryPath: record.category,
      attributes: JSON.parse(record.attributes || '{}'),
      price: parseFloat(record.price),
      imageUrl: record.image_url,
    });
    count++;
    if (count % 10 === 0) console.log(`Indexados: ${count}`);
  }
  
  console.log(`✅ Total indexado: ${count}`);
}

const [csvPath, tenantId] = process.argv.slice(2);
bulkIndex(csvPath, tenantId);
```

### search_cli.ts
```typescript
#!/usr/bin/env ts-node
// scripts/search-cli.ts
import { searchProducts } from '@/lib/actions/products/search-products';

async function search(tenantId: string, query: string, limit?: string) {
  const results = await searchProducts({
    tenantId,
    query,
    limit: limit ? parseInt(limit) : 5,
  });
  
  console.table(results.map(r => ({
    sku: r.sku,
    title: r.title.substring(0, 40),
    price: `R$ ${r.price}`,
    similarity: `${(r.similarity * 100).toFixed(1)}%`,
  })));
}

const [tenantId, query, limit] = process.argv.slice(2);
search(tenantId, query, limit);
```

## 🔗 Integração

- **Chamada:** Direta por `03_executando_planos` (quando PLAN envolve catálogo)
- **Pré-requisito:** Neon com pgvector, Drizzle schema aplicado
- **Dependências:** `generateEmbedding` (OpenRouter), normalização de atributos
- **Integrações:** 
  - `07_comunicando_externo` (notificar quando produto similar encontrado)
  - `01_brainstorming` (descoberta de atributos importantes para busca)
- **Artefatos:** Tabela `product_embeddings`, funções de busca

## 🚫 Anti-Padrões

- ❌ Indexar sem normalização de atributos (busca inconsistente)
- ❌ Esquecer `tenant_id` (vazamento de dados entre lojas)
- ❌ Recriar embedding a cada mudança de preço (desnecessário)
- ❌ Busca sem limite de resultados (performance)
- ❌ Deletar produto hard sem soft delete (perde histórico)
- ❌ Ignorar feedback de cliques (não melhora relevância)

## ✅ Checklist de Qualidade

- [ ] Schema Drizzle aplicado (migrations rodadas)
- [ ] Índice HNSW criado (para performance)
- [ ] Normalização de cores/tamanhos testada
- [ ] Busca com filtros funcionando (< 100ms)
- [ ] Recomendações por similaridade testadas
- [ ] Soft delete implementado
- [ ] Cron jobs de sync configurados (Inngest)
- [ ] Isolamento multi-tenant validado

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Integrado com Stack Omega (Drizzle ORM, Inngest)
- Schema Drizzle type-safe (alternativa ao SQL raw)
- Scripts TypeScript (bulk index, search CLI)
- Conexão com `03_executando_planos` e `07_comunicando_externo`
- Normalização de atributos expandida

### v3.0.0 (Original)
- Arquitetura pgvector completa
- Multi-tenancy via tenant_id
- Embeddings semânticos (OpenAI)
- Busca vetorial com HNSW
- Pipeline indexação/busca/recomendação
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
