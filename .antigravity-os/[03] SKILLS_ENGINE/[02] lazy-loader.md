---
name: lazy_loader_protocol
description: Carregamento sob demanda e compressão de raw data pós-uso.
version: 1.0.0
framework: "Antigravity OS v3.1"
tags: [lazy-load, memory, rag, context]
---

# 🗜️ COMPRESSÃO DE TOOLS E RAG — Pós-Processamento Inteligente

### Regra: Remover Raw Data Após Uso
- Após agente usar resultado de RAG/busca web → manter apenas:
  - `summary`: resumo de 1-2 frases
  - `source_id`: referência para auditoria futura
  - `confidence_score`: métrica de qualidade
- Descartar: chunks brutos, HTML cru, logs de API

### Exemplo de Transformação
```typescript
// ANTES (raw data - ~1500 tokens)
{
  "raw_html": "<!DOCTYPE html>...",
  "chunks": ["chunk1...", "chunk2...", "..."],
  "metadata": {...}
}

// DEPOIS (compressed - ~50 tokens)
{
  "summary": "Artigo confirma tendência de IA em e-commerce com crescimento de 40% em 2024",
  "source_id": "research_2026_02_22_abc123",
  "confidence_score": 0.92
}
```

### Integração com Skills de Research
- `11_pesquisando_web.md`: Aplica compressão automaticamente após scraping
- `09_gerenciando_memoria.md`: Mantém apenas embeddings + metadata, descarta texto bruto
- `10_llm_app_blueprint.md`: Resume outputs de LLM antes de passar para próxima etapa

### Validação por DELTA
- Verificar se raw data foi removido antes de commit
- Alertar se > 500 tokens de dados brutos permanecem no contexto
