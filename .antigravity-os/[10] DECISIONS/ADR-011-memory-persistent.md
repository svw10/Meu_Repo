---
title: ADR-011 Memória Conversacional Persistente
status: accepted
date: 2026-04-21
priority: P0
tags: [architecture, memory, rag, postgres]
---

# ADR-011: Camada de Memória Persistente Conversacional

## 1. Contexto
No Antigravity OS v3.1, os módulos e agentes precisam operar com um contexto otimizado de usuários sem estourar o limite de tokens da API da OpenAI ou do OpenRouter, enquanto lidam robustamente com deduplicação semântica. 
Se faz necessária uma estrutura de infraestrutura unificada (Drizzle + Neon PostgreSQL) dedicada aos processos de Storage e Busca Vetorial.

## 2. Decisão

Adotada uma Camada de Memória híbrida, unindo Busca Vetorial (`pgvector`, `HNSW`) e Full-text nativo (`pg_trgm`, `ILIKE`).
Para redução de latência e consumo, a validação de Similaridade de Cosseno será inteiramente delegada nativamente ao banco PostgreSQL com RLS para separar rigidamente o isolamento multi-tenant.

O componente será regido pelas seguintes regras estritas:
1. **Zod+Drizzle Tipagem Fortalecida:** O isolamento das enums `MemoryTypeEnum` e `MemorySourceEnum` contendo os agentes restritos garante blindagem das APIs.
2. **Ciclo Punitivo:** Falhas de embed fallback obrigatoriamente para a busca textual local, controladas via Circuit Breakers.
3. **GDPR/LGPD Compliance:** Endpoints para remoção definitiva migrando logs para a tabela `MemoryArchive`.
4. **Prompt Caching:** O RAG vai repassar formatação com o array embutindo `cache_control: "ephemeral"`.
5. **ZETA Otimizador:** Job semanal via Inngest fará varreduras semânticas no Neon via operator `<=>` extraindo relevância (Importance Score), limpando logs inúteis isoladamente por cada Tenant (`orgId`).

## 3. Consequências

- **Escalabilidade:** Retira toda a compressão iterativa de embeddings rodando no pool de V8 da Vercel. Desloca para processamento SQL e cron jobs no Inngest.
- **Isolamento e Segurança:** Tabelas em RLS impendem cruzamento indevido de memórias, protegendo sigilo PII dos clientes do SaaS. 

Para a implementação e aplicação de código detalhado destas diretrizes em novos projetos, refira-se ao artefato de Skill oficial `Minhas_Skills/DOMINIO_IA/13_memoria_persistente.md`.
