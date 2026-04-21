---
name: memoria-persistente
description: Implementar sistema de memória conversacional multi-tenant com HNSW, RAG e Circuit Breaker.
status: active
version: 3.0.0
---

# 13 - Memória Persistente (RAG Protocol)

## 📌 Contexto e Identidade
Esta skill serve para implementar arquiteturas prontas de banco de memórias semânticas no sistema de projetos-filho baseados na Stack Omega (Next.js, Drizzle, Neon, Inngest).

## 🚀 Quando usar
- Quando um bot ou agente necessitar recordar históricos estendidos do projeto com alta economia de tokens (utilizando `cache_control` Ephemeral).
- Ao definir deduplicação semântica nativa no PostgreSQL (sem gastar memória RAM rodando algoritmos de cosseno no Node.js).
- Quando se exige conformidade com GDPR/LGPD com suporte à Soft Delete com arquivamento.

## 🚧 Checklist de Build
- [ ] Criar arquivo Migration (`.sql`) com extensões `pgvector` e `pg_trgm`.
- [ ] Configurar tabelas Drizzle tipadas com Enums para tipos da Memória.
- [ ] Acoplar função `drizzle-kit generate`.
- [ ] Estabelecer arquivo de rota Endpoint `/api/gdpr` consumindo tabela segura para Archive.
- [ ] Integrar Inngest Cron Jobs e Triggers assíncronos (`optimizeMemoryJob`).
- [ ] Implementar Circuit Breaker ao instanciar API Externa (OpenAI).
- [ ] Configurar formatação Array para injeção da flag `ephemeral`.

## 👾 Código-Exemplo Arquitetural
Para referenciar implementações da Memória:

### Drizzle Model + Enums:
```typescript
import { pgTable, text, vector, index } from "drizzle-orm/pg-core";
// ... (Definições de Tabelas)
```

### Otimizador Assíncrono com Inngest (ZETA)
Aplica relevância nas memórias executando globalmente aos domingos em blocos `orgId`:
```typescript
export const optimizeMemoryJob = inngest.createFunction(
  { id: "zeta-memory-optimization" },
  { cron: "0 3 * * 0" }, 
  async ({ step }) => {
      const tenants = await step.run("list-tenants", async () => { /* Select distinct orgIds */ });
      for (const orgId of tenants) {
        await step.run(`optimize-${orgId}`, async () => await runZetaMemoryOptimization(orgId));
      }
  }
);
```

### RAG Prompt Caching Endpoint
Retorna array no padrão nativo aceito por Providers compatíveis.
```typescript
const systemMessage = {
  role: "system",
  content: finalContext,
  cache_control: { type: "ephemeral" }
};
```

## ⛔ Anti-Padrões
- **Evitar** laços `.map` ou `.filter` de cálculo trigonométrico no servidor da Vercel. Tudo deve performar SQL via operador de distância (`<=>`).
- **NUNCA** deixe as RLS das tabelas abertas.
