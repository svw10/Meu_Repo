name: gerenciando-memoria
description: O Bibliotecário de Produtos. Gerencia RAG de catálogo usando Neon pgvector, com embeddings de produto, atributos semânticos e busca multimodal. Otimizado para e-commerce e catálogos dinâmicos.
version: 3.0.0
tags: [rag, vector-db, neon, produto, catalogo, embeddings, e-commerce, snapfit]
---

# Gerenciando Memória de Produtos (Product RAG Protocol v3.0)

## 🎯 Quando usar
- **Indexação de Catálogo**: Novos produtos chegaram, precisam ser vetorizados para busca semântica.
- **Busca Inteligente**: Cliente descreve "vestido verão floral" → encontrar SKU correspondente.
- **Recomendações**: Produto visualmente ou semanticamente similar ao item atual.
- **Enriquecimento**: Adicionar descrições geradas por IA, tags automáticas, atributos extraídos de imagens.
- **Sincronização**: Atualizar embeddings quando preço, estoque ou descrição mudam.

> **Diferença chave**: Não é "memória de lições aprendidas". É **memória de produto** — catálogo vivo, buscável, recomendável.

---

## 🧱 Arquitetura de Dados (Catálogo Vetorial)

### Schema Especializado para Produtos

```sql
-- Extensão vetorial
CREATE EXTENSION IF NOT EXISTS vector;

-- Tabela principal de produtos vetorizados
CREATE TABLE product_embeddings (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    
    -- Identificação
    sku VARCHAR(100) UNIQUE NOT NULL,
    tenant_id VARCHAR(100) NOT NULL,  -- Multi-tenancy (SnapFit)
    
    -- Conteúdo textual (para embedding)
    title TEXT NOT NULL,
    description TEXT,
    category_path TEXT,  -- ex: "Roupas > Feminino > Vestidos"
    attributes JSONB,    -- ex: {"cor": "azul", "tamanho": "M", "material": "algodão"}
    tags TEXT[],         -- Array de tags processadas
    
    -- Metadados de negócio
    price DECIMAL(10,2),
    currency VARCHAR(3) DEFAULT 'BRL',
    stock_quantity INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    
    -- Vetores (multi-embedding strategy)
    text_embedding VECTOR(1536),      -- OpenAI text-embedding-3-small
    -- image_embedding VECTOR(512),   -- Futuro: CLIP ou similar para imagem
    
    -- Controle de versão
    source_url TEXT,      -- URL da imagem original
    last_synced TIMESTAMPTZ DEFAULT NOW(),
    embedding_version INTEGER DEFAULT 1,
    
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Índices essenciais
CREATE INDEX idx_product_embeddings_vector ON product_embeddings 
USING hnsw (text_embedding vector_cosine_ops);

CREATE INDEX idx_product_tenant ON product_embeddings(tenant_id);
CREATE INDEX idx_product_sku ON product_embeddings(sku);
CREATE INDEX idx_product_category ON product_embeddings USING GIN(category_path gin_trgm_ops);
CREATE INDEX idx_product_active ON product_embeddings(is_active) WHERE is_active = true;

-- Função de busca semântica de produtos
CREATE OR REPLACE FUNCTION search_products(
    p_tenant_id VARCHAR,
    p_query_embedding VECTOR(1536),
    p_match_threshold FLOAT DEFAULT 0.7,
    p_match_count INT DEFAULT 10,
    p_category_filter TEXT DEFAULT NULL,
    p_min_price DECIMAL DEFAULT NULL,
    p_max_price DECIMAL DEFAULT NULL
)
RETURNS TABLE(
    sku VARCHAR,
    title TEXT,
    description TEXT,
    price DECIMAL,
    similarity FLOAT,
    attributes JSONB,
    category_path TEXT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        p.sku,
        p.title,
        p.description,
        p.price,
        1 - (p.text_embedding <=> p_query_embedding) AS similarity,
        p.attributes,
        p.category_path
    FROM product_embeddings p
    WHERE p.tenant_id = p_tenant_id
        AND p.is_active = true
        AND 1 - (p.text_embedding <=> p_query_embedding) > p_match_threshold
        AND (p_category_filter IS NULL OR p.category_path ILIKE '%' || p_category_filter || '%')
        AND (p_min_price IS NULL OR p.price >= p_min_price)
        AND (p_max_price IS NULL OR p.price <= p_max_price)
    ORDER BY p.text_embedding <=> p_query_embedding
    LIMIT p_match_count;
END;
$$ LANGUAGE plpgsql;

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_product_embeddings_updated_at
    BEFORE UPDATE ON product_embeddings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
```

---

## ⚙️ Fluxo de Trabalho

### A. Indexação de Produtos (Write)

**Cenário**: Novo produto chega do ERP ou upload em massa.

```bash
# Indexar produto único
python "Minhas Skills/gerenciando-memoria/scripts/index_product.py" \
  --tenant "loja-exemplo" \
  --sku "VEST-001" \
  --title "Vestido Longo Floral Verão" \
  --description "Vestido leve de algodão com estampa floral, ideal para dias quentes" \
  --category "Roupas > Feminino > Vestidos" \
  --price 149.90 \
  --attributes '{"cor": "azul", "tamanho": "M", "material": "algodão", "estacao": "verao"}' \
  --image-url "https://cdn.exemplo.com/vest-001.jpg"

# Indexação em massa via CSV
python "Minhas Skills/gerenciando-memoria/scripts/bulk_index.py" \
  --tenant "loja-exemplo" \
  --file "produtos.csv" \
  --batch-size 100
```

**Pipeline de Processamento:**

1. **Enriquecimento de Texto**:
   ```python
   # Gera descrição melhorada se original é curta
   if len(description) < 50:
       description = generate_enhanced_description(title, attributes)
   ```

2. **Normalização de Atributos**:
   ```python
   # Padroniza cores, tamanhos, materiais
   attributes = normalize_attributes(raw_attributes)
   # ex: "azul marinho" → "azul", "GG" → "XL"
   ```

3. **Geração de Embedding**:
   ```python
   text_to_embed = f"{title}. {description}. Categoria: {category}. Tags: {', '.join(tags)}"
   embedding = generate_embedding(text_to_embed)
   ```

4. **Upsert no Neon**:
   ```sql
   INSERT INTO product_embeddings (...) 
   VALUES (...) 
   ON CONFLICT (sku) 
   DO UPDATE SET ...;
   ```

---

### B. Busca Semântica de Produtos (Read)

**Cenários de busca suportados:**

| Tipo de Query | Exemplo | Estratégia |
| :--- | :--- | :--- |
| **Descritiva** | "vestido azul para festa" | Embedding direto do texto |
| **Visual** | "parecido com esse" | Futuro: embedding de imagem |
| **Atributo** | "tamanho G preto" | Filtro SQL + embedding |
| **Preço** | "até 100 reais" | Filtro range + embedding |
| **Composta** | "calça jeans masculina barata" | Embedding + filtros múltiplos |

```bash
# Busca básica
python "Minhas Skills/gerenciando-memoria/scripts/search_products.py" \
  --tenant "loja-exemplo" \
  --query "vestido leve para praia" \
  --limit 5

# Busca com filtros
python "Minhas Skills/gerenciando-memoria/scripts/search_products.py" \
  --tenant "loja-exemplo" \
  --query "camisa social" \
  --category "Masculino" \
  --max-price 200.00 \
  --min-similarity 0.75

# Busca para recomendações (similar ao SKU atual)
python "Minhas Skills/gerenciando-memoria/scripts/similar_products.py" \
  --tenant "loja-exemplo" \
  --sku "CAM-045" \
  --limit 4
```

---

### C. Sincronização e Manutenção

**Regras de atualização:**

- [ ] **Preço mudou**: Atualiza metadados, **não recria embedding** (texto igual)
- [ ] **Descrição mudou**: **Recria embedding** (semântica mudou)
- [ ] **Esgotou**: `is_active = false` (não aparece em buscas)
- [ ] **Nova imagem**: Futuro - reprocessa embedding visual
- [ ] **Deleção**: Soft delete (mantém histórico) ou hard delete

```bash
# Sincronização incremental (delta desde última execução)
python "Minhas Skills/gerenciando-memoria/scripts/sync_catalog.py" \
  --tenant "loja-exemplo" \
  --since "2024-01-15T10:00:00Z"

# Reindexação completa (recria todos embeddings)
python "Minhas Skills/gerenciando-memoria/scripts/reindex_all.py" \
  --tenant "loja-exemplo" \
  --batch-size 50

# Limpeza de produtos inativos há X dias
python "Minhas Skills/gerenciando-memoria/scripts/cleanup_inactive.py" \
  --tenant "loja-exemplo" \
  --inactive-days 30
```

---

## 📋 Checklist de Operações

### Antes de Indexar:
- [ ] SKU é único por tenant?
- [ ] Atributos estão normalizados (cores, tamanhos)?
- [ ] Imagens têm URL pública acessível?
- [ ] Preço está em centavos/decimal correto?

### Antes de Buscar:
- [ ] Tenant ID correto?
- [ ] Filtros de preço aplicados (evitar mostrar produtos caros demais)?
- [ ] Limite de resultados definido (paginação)?
- [ ] Fallback para busca textual simples se RAG falhar?

### Manutenção:
- [ ] Monitorar latência das queries (< 100ms)?
- [ ] Taxa de clique nos resultados (feedback implícito)?
- [ ] Produtos sem embedding (erros de indexação)?
- [ ] Tamanho do índice (quando fazer particionamento)?

---

## 💻 Scripts e Snippets

### Script: index_product.py

```python
#!/usr/bin/env python3
"""
Indexa produto único no catálogo vetorial.
"""
import argparse
import json
import os
import sys
from typing import Dict, Optional

import psycopg2
from openai import OpenAI

# Config
DB_URL = os.getenv("DATABASE_URL")
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
OPENROUTER_BASE_URL = os.getenv("OPENROUTER_BASE_URL", "https://openrouter.ai/api/v1")

client = OpenAI(
    base_url=OPENROUTER_BASE_URL,
    api_key=OPENROUTER_API_KEY,
)

def generate_embedding(text: str) -> list:
    """Gera embedding via OpenRouter (OpenAI compatível)."""
    try:
        response = client.embeddings.create(
            input=text,
            model="openai/text-embedding-3-small"
        )
        return response.data[0].embedding
    except Exception as e:
        print(f"❌ Erro ao gerar embedding: {e}")
        sys.exit(1)

def normalize_attributes(attrs: Dict) -> Dict:
    """Normaliza atributos do produto."""
    # Mapeamento de cores
    color_map = {
        "azul marinho": "azul", "azul royal": "azul",
        "vermelho escuro": "vermelho", "rosa pink": "rosa",
        "preto fosco": "preto", "branco off": "branco",
    }
    
    # Mapeamento de tamanhos
    size_map = {
        "pp": "XS", "p": "S", "m": "M", 
        "g": "L", "gg": "XL", "xgg": "XXL",
    }
    
    normalized = {}
    for key, value in attrs.items():
        val_lower = str(value).lower().strip()
        
        if key in ["cor", "color"]:
            normalized[key] = color_map.get(val_lower, val_lower)
        elif key in ["tamanho", "size"]:
            normalized[key] = size_map.get(val_lower, val_lower.upper())
        else:
            normalized[key] = val_lower
    
    return normalized

def construct_embedding_text(title: str, description: Optional[str], 
                           category: str, attributes: Dict) -> str:
    """Constrói texto rico para embedding."""
    parts = [title]
    
    if description:
        parts.append(description)
    
    parts.append(f"Categoria: {category}")
    
    # Adiciona atributos como texto
    attr_text = ", ".join([f"{k}: {v}" for k, v in attributes.items()])
    if attr_text:
        parts.append(f"Características: {attr_text}")
    
    return ". ".join(parts)

def index_product(tenant_id: str, sku: str, title: str, 
                 description: Optional[str], category: str,
                 price: float, attributes: Dict, image_url: Optional[str],
                 currency: str = "BRL"):
    """Indexa ou atualiza produto."""
    
    # Normalização
    norm_attrs = normalize_attributes(attributes)
    embedding_text = construct_embedding_text(title, description, category, norm_attrs)
    
    print(f"🧠 Gerando embedding para: {sku} - {title[:40]}...")
    embedding = generate_embedding(embedding_text)
    
    # Upsert no banco
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    
    sql = """
    INSERT INTO product_embeddings 
        (tenant_id, sku, title, description, category_path, attributes,
         price, currency, text_embedding, source_url, updated_at)
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, NOW())
    ON CONFLICT (sku) 
    DO UPDATE SET
        tenant_id = EXCLUDED.tenant_id,
        title = EXCLUDED.title,
        description = EXCLUDED.description,
        category_path = EXCLUDED.category_path,
        attributes = EXCLUDED.attributes,
        price = EXCLUDED.price,
        currency = EXCLUDED.currency,
        text_embedding = EXCLUDED.text_embedding,
        source_url = EXCLUDED.source_url,
        updated_at = NOW(),
        embedding_version = product_embeddings.embedding_version + 1
    WHERE product_embeddings.description IS DISTINCT FROM EXCLUDED.description
       OR product_embeddings.title IS DISTINCT FROM EXCLUDED.title;
    """
    
    cur.execute(sql, (
        tenant_id, sku, title, description, category,
        json.dumps(norm_attrs), price, currency,
        embedding, image_url
    ))
    
    conn.commit()
    cur.close()
    conn.close()
    
    print(f"✅ Produto {sku} indexado/atualizado!")

def main():
    parser = argparse.ArgumentParser(description="Indexa produto no catálogo vetorial")
    parser.add_argument("--tenant", required=True, help="ID do tenant/loja")
    parser.add_argument("--sku", required=True, help="SKU único do produto")
    parser.add_argument("--title", required=True, help="Título do produto")
    parser.add_argument("--description", help="Descrição detalhada")
    parser.add_argument("--category", required=True, help="Caminho da categoria")
    parser.add_argument("--price", type=float, required=True, help="Preço")
    parser.add_argument("--attributes", default="{}", help="JSON de atributos")
    parser.add_argument("--image-url", help="URL da imagem")
    parser.add_argument("--currency", default="BRL", help="Moeda (BRL/USD)")
    
    args = parser.parse_args()
    
    try:
        attrs = json.loads(args.attributes)
    except json.JSONDecodeError:
        print("❌ Atributos devem ser JSON válido")
        sys.exit(1)
    
    index_product(
        tenant_id=args.tenant,
        sku=args.sku,
        title=args.title,
        description=args.description,
        category=args.category,
        price=args.price,
        attributes=attrs,
        image_url=args.image_url,
        currency=args.currency
    )

if __name__ == "__main__":
    main()
```

---

### Script: search_products.py

```python
#!/usr/bin/env python3
"""
Busca semântica de produtos com filtros.
"""
import argparse
import json
import os
import sys

import psycopg2
from openai import OpenAI

DB_URL = os.getenv("DATABASE_URL")
OPENROUTER_API_KEY = os.getenv("OPENROUTER_API_KEY")
OPENROUTER_BASE_URL = os.getenv("OPENROUTER_BASE_URL", "https://openrouter.ai/api/v1")

client = OpenAI(
    base_url=OPENROUTER_BASE_URL,
    api_key=OPENROUTER_API_KEY,
)

def search_products(tenant_id: str, query: str, limit: int = 10,
                   category_filter: str = None, min_price: float = None,
                   max_price: float = None, min_similarity: float = 0.7):
    """Busca produtos por similaridade semântica."""
    
    # Gera embedding da query
    print(f"🔍 Analisando: '{query}'...")
    try:
        response = client.embeddings.create(
            input=query,
            model="openai/text-embedding-3-small"
        )
        query_embedding = response.data[0].embedding
    except Exception as e:
        print(f"❌ Erro na geração do embedding: {e}")
        sys.exit(1)
    
    # Busca no banco
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    
    sql = """
    SELECT sku, title, description, price, similarity, attributes, category_path
    FROM search_products(
        %s, %s::vector, %s, %s, %s, %s, %s
    )
    """
    
    cur.execute(sql, (
        tenant_id, query_embedding, min_similarity, limit,
        category_filter, min_price, max_price
    ))
    
    results = cur.fetchall()
    cur.close()
    conn.close()
    
    # Output formatado
    print(f"\n📦 {len(results)} produtos encontrados:\n")
    print("-" * 80)
    
    for row in results:
        sku, title, desc, price, sim, attrs, cat = row
        print(f"🛒 {title}")
        print(f"   SKU: {sku} | R$ {price:.2f} | Similaridade: {sim:.2%}")
        print(f"   Categoria: {cat}")
        if attrs:
            print(f"   Atributos: {json.dumps(attrs, ensure_ascii=False)}")
        if desc:
            print(f"   Descrição: {desc[:100]}...")
        print("-" * 80)
    
    # Retorna JSON para integração
    return [
        {
            "sku": r[0], "title": r[1], "description": r[2],
            "price": float(r[3]), "similarity": float(r[4]),
            "attributes": r[5], "category": r[6]
        }
        for r in results
    ]

def main():
    parser = argparse.ArgumentParser(description="Busca semântica de produtos")
    parser.add_argument("--tenant", required=True, help="ID do tenant")
    parser.add_argument("--query", required=True, help="Descrição do que buscar")
    parser.add_argument("--limit", type=int, default=10, help="Máximo de resultados")
    parser.add_argument("--category", help="Filtrar por categoria")
    parser.add_argument("--min-price", type=float, help="Preço mínimo")
    parser.add_argument("--max-price", type=float, help="Preço máximo")
    parser.add_argument("--min-similarity", type=float, default=0.7, 
                       help="Threshold de similaridade (0-1)")
    parser.add_argument("--json", action="store_true", help="Output em JSON")
    
    args = parser.parse_args()
    
    results = search_products(
        tenant_id=args.tenant,
        query=args.query,
        limit=args.limit,
        category_filter=args.category,
        min_price=args.min_price,
        max_price=args.max_price,
        min_similarity=args.min_similarity
    )
    
    if args.json:
        print(json.dumps(results, ensure_ascii=False, indent=2))

if __name__ == "__main__":
    main()
```

---

### Script: similar_products.py (Recomendações)

```python
#!/usr/bin/env python3
"""
Encontra produtos similares a um SKU de referência.
"""
import argparse
import os
import sys

import psycopg2

DB_URL = os.getenv("DATABASE_URL")

def find_similar(tenant_id: str, sku: str, limit: int = 4):
    """Busca produtos similares ao SKU informado."""
    
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    
    # Pega embedding do produto de referência
    cur.execute("""
        SELECT text_embedding, title, category_path 
        FROM product_embeddings 
        WHERE sku = %s AND tenant_id = %s
    """, (sku, tenant_id))
    
    ref = cur.fetchone()
    if not ref:
        print(f"❌ Produto {sku} não encontrado")
        sys.exit(1)
    
    ref_embedding, ref_title, ref_cat = ref
    print(f"🎯 Produto de referência: {ref_title}")
    print(f"   Categoria: {ref_cat}\n")
    
    # Busca similares (excluindo o próprio)
    cur.execute("""
        SELECT sku, title, price, 1 - (text_embedding <=> %s) as similarity
        FROM product_embeddings
        WHERE tenant_id = %s 
            AND sku != %s 
            AND is_active = true
            AND category_path = %s  -- Mesma categoria para relevância
        ORDER BY text_embedding <=> %s
        LIMIT %s
    """, (ref_embedding, tenant_id, sku, ref_cat, ref_embedding, limit))
    
    results = cur.fetchall()
    
    print(f"📌 {len(results)} produtos similares:\n")
    for row in results:
        print(f"   • {row[1]} (SKU: {row[0]}) - R$ {row[2]:.2f} [{row[3]:.1%} similar]")
    
    cur.close()
    conn.close()

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--tenant", required=True)
    parser.add_argument("--sku", required=True, help="SKU de referência")
    parser.add_argument("--limit", type=int, default=4)
    args = parser.parse_args()
    
    find_similar(args.tenant, args.sku, args.limit)

if __name__ == "__main__":
    main()
```

---

## 🗂️ Estrutura de Arquivos

```
Minhas Skills/gerenciando-memoria/
├── SKILL.md                              # Este protocolo
├── resources/
│   ├── schema_produtos.sql               # Schema completo do Neon
│   ├── normalizacao_atributos.json       # Mapeamentos de cores/tamanhos
│   └── exemplos_queries.sql              # Queries úteis para análise
├── scripts/
│   ├── index_product.py                  # Indexa produto único
│   ├── bulk_index.py                     # Indexação em massa (CSV)
│   ├── search_products.py                # Busca semântica
│   ├── similar_products.py               # Recomendações por similaridade
│   ├── sync_catalog.py                   # Sincronização incremental
│   ├── reindex_all.py                    # Reindexação completa
│   └── cleanup_inactive.py               # Limpeza de produtos antigos
└── snippets/
    ├── enrichment_prompts.txt            # Prompts para enriquecer descrições
    └── filter_combinations.md            # Exemplos de filtros complexos
```

---

