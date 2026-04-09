---
name: context_cache_protocol
description: Protocolo de cache de contexto para redução de tokens (80%+ economia)
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: ZETA
trigger: "pré-execução + pós-resposta"
status: active
tags: [cache, tokens, optimization, prompt, zeta]
---

# 🔒 CONTEXT CACHE PROTOCOL — Economia de Tokens via Cache Inteligente

## 🎯 Propósito
Reduzir em até 90% o custo de tokens repetidos (System Prompt, Skills, Descrições de Ferramentas) através de cache estratégico com invalidação inteligente.

## 🧱 Arquitetura de Cache (3 Camadas)

| Camada | O que Cachear | TTL | Invalidação |
|:---|:---|:---|:---|
| **L1: System Prompt** | `.cursorrules`, `CLAUDE.md`, `GEMINI.md` | 24h | Mudança no arquivo fonte |
| **L2: Skills/Agents** | Frontmatter + checklist de skills carregadas | 1h | Nova versão da skill |
| **L3: Ferramentas** | Descrições de APIs, schemas Zod, contratos | 6h | Mudança no schema |

## ⚙️ Protocolo de Cache (4 Passos)

### Passo 1: Identificação de Blocos Imutáveis
Antes de enviar prompt à LLM, identifique:
```typescript
const immutableBlocks = {
  systemPrompt: hash('.cursorrules'), // SHA256
  agentRules: hash('Agentes/THETA_Orchestrator.md'),
  skillDefs: loadedSkills.map(s => hash(s.frontmatter)),
  toolSchemas: Object.keys(zodSchemas).map(k => hash(k)),
};
```

### Passo 2: Consulta ao Cache (Redis/Upstash)
```typescript
async function getCachedBlock(key: string): Promise<string | null> {
  const cached = await redis.get(`ctx:${key}`);
  return cached; // null se miss
}
```

### Passo 3: Montagem do Prompt com Referências
Se cache hit:
```
[SYSTEM] Use cached block: ctx:a1b2c3d4
[AGENT] Use cached block: ctx:e5f6g7h8
[SKILLS] Use cached blocks: ctx:i9j0, ctx:k1l2
```
Se cache miss:
```
[SYSTEM] {{full_system_prompt}}
[AGENT] {{full_agent_rules}}
[SKILLS] {{skill_frontmatter}}
→ Após montar, salvar no cache com TTL apropriado
```

### Passo 4: Invalidação Inteligente
Invalidar cache quando:
- [ ] Arquivo fonte modificado (git hash mudou)
- [ ] Versão da skill atualizada (frontmatter.version)
- [ ] Schema Zod alterado (hash do schema mudou)
- [ ] TTL expirado (fallback de segurança)

## 📊 Métricas de Economia

| Métrica | Antes | Depois | Economia |
|---------|-------|--------|----------|
| Tokens por request (system) | ~2.500 | ~250 | 90% |
| Tokens por skill carregada | ~800 | ~80 | 90% |
| Custo mensal estimado | $45 | $9 | 80% |
| Latência adicional (cache hit) | - | +15ms | Negligível |

## 🛡️ Regras de Segurança

- ❌ **Nunca** cachear dados sensíveis (PII, secrets, user input)
- ✅ **Sempre** usar hash criptográfico (SHA256) para chaves de cache
- ✅ **Sempre** validar integridade do cache antes de usar (hash match)
- ✅ **Sempre** ter fallback para "cache miss" (montar prompt completo)

## 🔗 Integração com Stack Omega

| Componente | Integração |
|-----------|-----------|
| **Redis/Upstash** | `process.env.CACHE_REDIS_URL` para cache distribuído |
| **ZETA (Optimizer)** | Monitora hit/miss rate e sugere ajustes de TTL |
| **THETA (Orchestrator)** | Decide quando usar cache vs. montar do zero |
| **MEMORY_DNA** | Registra padrões de cache para aprendizado futuro |

## 🚫 Anti-Padrões (Proibidos)

- ❌ Cachear input do usuário (sempre dinâmico)
- ❌ Usar TTL fixo sem invalidação por conteúdo
- ❌ Ignorar cache miss (sempre ter fallback)
- ❌ Cachear schemas Zod sem validar hash

## ✅ Checklist de Implementação

- [ ] Redis/Upstash configurado e testado
- [ ] Função de hash SHA256 para chaves de cache
- [ ] Fallback para cache miss implementado
- [ ] Invalidação por hash de arquivo implementada
- [ ] Métricas de hit/miss rate sendo logadas
- [ ] ZETA monitorando eficiência do cache

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Invocada automaticamente por THETA antes de enviar prompt à LLM.

**Memória:** Padrões de cache registrados em `.antigravity-os/[04] MEMORY_DNA/` para otimização futura.

**Budget:** Economia de tokens registrada em `.antigravity-os/[05] TOKENOMICS/[03] cost-telemetry.json`.

**Handoff:** Após cache check, prossegue para execução normal da skill/agente.

**Stack Omega:** Redis/Upstash para cache, SHA256 para hashing, ZETA para monitoramento.
