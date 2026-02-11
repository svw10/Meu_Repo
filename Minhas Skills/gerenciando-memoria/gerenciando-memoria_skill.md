### 📂 Estrutura de Diretórios


Minhas Skills/
└── gerenciando-memoria/
    ├── SKILL.md
    ├── scripts/
    │   ├── save_context.py    # Gera embedding e salva no Neon
    │   └── query_context.py   # Busca similaridade (RAG) no Neon
    └── resources/
        └── schema_memoria.sql # O setup da tabela no Neon



### 1. O Cérebro (`Minhas Skills/gerenciando-memoria/SKILL.md`)

---
name: gerenciando-memoria
description: O Bibliotecário. Gerencia a Memória de Longo Prazo (RAG) usando Neon (pgvector). Responsável por indexar aprendizados e recuperar contexto técnico para evitar erros repetitivos.
version: 1.0.0
tags: [rag, vector-db, neon, aprendizado]
---

# Gerenciando Memória (RAG Protocol)

## 🎯 Quando usar
- **Fim de Tarefa**: Após concluir um `executando-planos`, invoque para salvar "Lições Aprendidas".
- **Início de Tarefa**: Antes de planejar, invoque para perguntar: "Já fizemos algo parecido?".
- **Documentação**: Quando o agente ler uma doc nova (ex: atualização da Evolution API), salvar aqui.

## 🧱 Stack Vinculada (Neon + Embeddings)
Esta skill interage diretamente com:
- **Neon (Postgres)**: Armazenamento vetorial (`vector(1536)`).
- **OpenAI/OpenRouter**: Geração de Embeddings (`text-embedding-3-small`).

## ⚙️ Fluxo de Trabalho

### A. Memorização (Write)
- [ ] **1. Sintetizar a Informação**
    - O agente deve resumir o conteúdo (Snippet de código, Solução de erro, Regra de negócio).
    - Criar tags de metadados (ex: `stack:nextjs`, `type:bugfix`).
- [ ] **2. Vetorizar e Salvar**
    - Executar script para gerar embedding e inserir na tabela `agent_memory`.

### B. Recuperação (Read)
- [ ] **1. Definir Query Semântica**
    - Transformar a dúvida do usuário em uma frase de busca (ex: "Como configurar webhook do Clerk").
- [ ] **2. Consultar o Oráculo**
    - Executar script de busca vetorial (`query_context.py`).
    - Injetar o resultado no Context Window do agente.

## 📋 Checklist de Manutenção
- [ ] A extensão `vector` está ativa no Neon? (`CREATE EXTENSION IF NOT EXISTS vector;`)
- [ ] Os embeddings estão atualizados com a versão mais recente do código?

## 💻 Snippets e Recursos

### Snippet 1: Setup do Banco
*(Execute isso no Neon SQL Editor se for a primeira vez)*
```sql
CREATE EXTENSION IF NOT EXISTS vector;

CREATE TABLE agent_memory (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content TEXT NOT NULL,
  metadata JSONB DEFAULT '{}',
  embedding vector(1536),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX ON agent_memory USING hnsw (embedding vector_cosine_ops);


### Snippet 2: Salvar Conhecimento


# Salva uma nota na memória permanente
python "Minhas Skills/gerenciando-memoria/scripts/save_context.py" \
  --content "Para corrigir CORS no Next.js, use o arquivo next.config.js com headers..." \
  --tags "nextjs,cors,config"



### Snippet 3: Buscar Conhecimento (RAG)


# Busca as 3 notas mais relevantes
python "Minhas Skills/gerenciando-memoria/scripts/query_context.py" \
  --query "erro de cors no vercel"



---

### 2. Scripts Python (O Motor do RAG)

Estes scripts usam bibliotecas padrão (`psycopg2`, `openai`) para conectar sua stack.

#### `Minhas Skills/gerenciando-memoria/scripts/save_context.py`
```python
import sys
import os
import argparse
import psycopg2
from openai import OpenAI

# Configuração (Assume que as variáveis estão no .env)
DB_URL = os.getenv("DATABASE_URL") # Neon Connection String
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

client = OpenAI(api_key=OPENAI_API_KEY)

def get_embedding(text):
    response = client.embeddings.create(input=text, model="text-embedding-3-small")
    return response.data[0].embedding

def save_memory(content, tags):
    print(f"🧠 Gerando embedding para: {content[:30]}...")
    vector = get_embedding(content)
    
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    
    sql = """
    INSERT INTO agent_memory (content, metadata, embedding)
    VALUES (%s, %s, %s)
    """
    
    # Formata tags como JSON
    metadata = {"tags": tags.split(","), "source": "agent-skill"}
    
    cur.execute(sql, (content, json.dumps(metadata), vector))
    conn.commit()
    cur.close()
    conn.close()
    print("✅ Memória salva no Neon com sucesso!")

if __name__ == "__main__":
    import json
    parser = argparse.ArgumentParser()
    parser.add_argument("--content", required=True)
    parser.add_argument("--tags", default="general")
    args = parser.parse_args()
    
    save_memory(args.content, args.tags)



#### `Minhas Skills/gerenciando-memoria/scripts/query_context.py`

import sys
import os
import argparse
import psycopg2
from openai import OpenAI

DB_URL = os.getenv("DATABASE_URL")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")

client = OpenAI(api_key=OPENAI_API_KEY)

def search_memory(query, limit=3):
    print(f"🔍 Buscando no cérebro por: '{query}'...")
    vector = client.embeddings.create(input=query, model="text-embedding-3-small").data[0].embedding
    
    conn = psycopg2.connect(DB_URL)
    cur = conn.cursor()
    
    # Busca por similaridade de cosseno (<->)
    sql = """
    SELECT content, metadata, 1 - (embedding <=> %s::vector) as similarity
    FROM agent_memory
    ORDER BY embedding <=> %s::vector
    LIMIT %s
    """
    
    cur.execute(sql, (vector, vector, limit))
    rows = cur.fetchall()
    
    print(f"\n📚 Encontrei {len(rows)} memórias relevantes:\n")
    for row in rows:
        content, meta, score = row
        print(f"--- [Similaridade: {score:.2f}] ---")
        print(f"Tags: {meta.get('tags')}")
        print(f"Conteúdo: {content}\n")
    
    cur.close()
    conn.close()

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--query", required=True)
    args = parser.parse_args()
    
    search_memory(args.query)

