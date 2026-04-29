---
name: 20_leis_imutaveis
description: "20 Leis Imutáveis da Arquitetura Segura — 5 camadas de defesa em profundidade"
version: 5.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
status: active
tags: [security, laws, architecture, defense-in-depth]
---

# ⚖️ 20 LEIS IMUTÁVEIS DA ARQUITETURA SEGURA

> Aplique todas. Se uma não se aplica, registre: `// 🔒 LEI [N]: N/A — motivo`

---

## CAMADA 1 — PERÍMETRO E ENTRADA

| Lei | Título | Aplicação |
|-----|--------|-----------|
| **L1** | Nunca Confie no Cliente | Validação server-side obrigatória para todo input (frontend, mobile, CLI, LLM, webhooks) |
| **L2** | Schema Restrito | Whitelist explícita via Zod/Joi/Pydantic; `.strict()`; rejeite campos extras |
| **L3** | Limites de Tamanho/Taxa | `maxLength`, `maxItems`, rate limiting, paginação com `pageSize` máximo, timeout em streaming |
| **L4** | Proteção de Perímetro | CORS com allowlist (nunca `*`), anti-CSRF, headers obrigatórios, anti-HPP, anti-replay |
| **L5** | Validação de Tipo no Ponto de Entrada | Input é `string` até prova em contrário; conversões só após validação |

### Exemplos de Violação — Camada 1

```typescript
// ❌ VIOLAÇÃO L1: Confiança no cliente
const price = req.body.price // Preço vindo do frontend
await checkout(userId, price) // Atacante envia price: 0.01

// ✅ CORRETO L1: Preço do servidor
const product = await db.product.findUnique({ where: { id: req.body.productId } })
await checkout(userId, product.price) // Preço da base

// ❌ VIOLAÇÃO L2: Schema aberto
const data = req.body // Aceita qualquer campo
await db.user.update({ data }) // Atacante envia { role: 'admin' }

// ✅ CORRETO L2: Schema restrito
const data = updateUserSchema.parse(req.body) // .strict() rejeita 'role'
```

---

## CAMADA 2 — IDENTIDADE E AUTORIZAÇÃO

| Lei | Título | Aplicação |
|-----|--------|-----------|
| **L6** | Identidade Extraída, Nunca Recebida | `userId`, `role`, `tenantId` vêm do token validado, nunca do input |
| **L7** | Autorização em Cada Operação | Verifique: (a) role necessária, (b) ownership do recurso, (c) tenant correto |
| **L8** | RLS e Tenant Isolation | Row Level Security habilitado; queries sempre com `WHERE tenant_id = $1` |
| **L9** | Sessões Resilientes | Idle timeout + absolute timeout + rotation pós-login + invalidação em lote |

### Exemplos de Violação — Camada 2

```typescript
// ❌ VIOLAÇÃO L6: userId vem do input
async function deleteAccount(req: Request) {
  const { userId } = req.body // Atacante envia userId de outra pessoa
  await db.user.delete({ where: { id: userId } })
}

// ✅ CORRETO L6: userId do token
async function deleteAccount(session: Session) {
  const userId = session.user.id // Extraído do JWT verificado
  await db.user.delete({ where: { id: userId } })
}

// ❌ VIOLAÇÃO L7: Só verifica auth, não ownership
async function getOrder(req: AuthenticatedRequest) {
  const order = await db.order.findUnique({ where: { id: req.params.id } })
  return order // Qualquer usuário logado vê qualquer pedido
}

// ✅ CORRETO L7: Verifica auth + ownership
async function getOrder(req: AuthenticatedRequest) {
  const order = await db.order.findFirst({
    where: { id: req.params.id, userId: req.user.id } // ownership
  })
  if (!order) throw new NotFoundError()
  return order
}
```

---

## CAMADA 3 — LÓGICA E DADOS

| Lei | Título | Aplicação |
|-----|--------|-----------|
| **L10** | Atomicidade Transacional | Operações críticas em transação única com lock (`SELECT ... FOR UPDATE`) |
| **L11** | Exposição Mínima de Dados | Retorne apenas campos necessários; use DTOs; nunca objetos completos do banco |
| **L12** | Sanitização de Output | Escape para XSS; proíba `innerHTML`, `eval()`, raw SQL sem parameterização |
| **L13** | Integridade de Dados em Mutações | Valide invariantes de negócio ANTES de persistir; use CHECK constraints no banco |

### Exemplos de Violação — Camada 3

```typescript
// ❌ VIOLAÇÃO L10: Sem atomicidade
const user = await db.user.findUnique({ where: { id } })
if (user.balance >= amount) {
  // Race condition: 2 requests simultâneos passam aqui
  await db.user.update({ where: { id }, data: { balance: user.balance - amount } })
}

// ✅ CORRETO L10: Operação atômica
await db.user.update({
  where: { id, balance: { gte: amount } },
  data: { balance: { decrement: amount } }
})

// ❌ VIOLAÇÃO L11: Retorna tudo
const users = await db.user.findMany()
return users // Inclui passwordHash, internalNotes, etc.

// ✅ CORRETO L11: Projeção explícita
const users = await db.user.findMany({
  select: { id: true, name: true, email: true }
})
```

---

## CAMADA 4 — INFRAESTRUTURA E SUPPLY CHAIN

| Lei | Título | Aplicação |
|-----|--------|-----------|
| **L14** | Segredos Nunca no Bundle | Zero credenciais em código client-side, logs, repositório ou variáveis `NEXT_PUBLIC_*` |
| **L15** | Upload e SSRF Zero-Trust | Valide magic bytes, reprocasse imagens, bloqueie IPs internos em fetches, valide redirects |
| **L16** | Dependency Awareness | CVE scanning, pacotes abandonados, APIs inseguras, phantom packages, typosquatting |
| **L17** | Logging Seguro | Erros logados com contexto + correlation ID; sem dados sensíveis; stack traces ocultos em prod |
| **L18** | Configuração Segura por Padrão | HSTS, CSP, cookies HttpOnly/Secure/SameSite, debug desligado, source maps não expostos |

### Exemplos de Violação — Camada 4

```typescript
// ❌ VIOLAÇÃO L14: Secret no client
// .env
NEXT_PUBLIC_STRIPE_SECRET=sk_live_xxxxx // 💀 Exposto no bundle

// ✅ CORRETO L14: Secret só no server
STRIPE_SECRET_KEY=sk_live_xxxxx // Sem prefixo NEXT_PUBLIC_

// ❌ VIOLAÇÃO L17: PII nos logs
logger.error('Login falhou', { email: user.email, password: input.password })

// ✅ CORRETO L17: Sem PII
logger.error('Login falhou', { userId: user.id, correlationId, reason: 'invalid_credentials' })
```

---

## CAMADA 5 — IA/LLM E NOVOS VETORES

| Lei | Título | Aplicação |
|-----|--------|-----------|
| **L19** | GuardRails de IA/LLM | Cascata: secrets scan → regex injection → PII detection → anti-jailbreak → content validation → fail-safe |
| **L20** | Proteção contra Novos Vetores Web | Prototype Pollution, HTTP Smuggling, Cache Poisoning, HPP, Open Redirect, Timing Attacks, Account Enumeration, Login Throttling |

### Exemplos de Violação — Camada 5

```typescript
// ❌ VIOLAÇÃO L19: Input do usuário direto no prompt
const response = await openai.chat.completions.create({
  messages: [
    { role: 'system', content: 'Você é um assistente.' },
    { role: 'user', content: userInput } // Prompt injection!
  ]
})

// ✅ CORRETO L19: Sanitização + guardrails
const sanitizedInput = sanitizeForLLM(userInput) // Remove padrões de injection
if (detectsPromptInjection(sanitizedInput)) {
  throw new SecurityError('Prompt injection detectado')
}
const response = await openai.chat.completions.create({
  messages: [
    { role: 'system', content: HARDENED_SYSTEM_PROMPT },
    { role: 'user', content: sanitizedInput }
  ]
})
// Valida output antes de retornar
const validatedOutput = outputSchema.parse(response.choices[0].message.content)

// ❌ VIOLAÇÃO L20: Comparação de tokens insegura
if (token === expectedToken) { /* ... */ } // Timing attack

// ✅ CORRETO L20: Constant-time comparison
import crypto from 'crypto'
if (crypto.timingSafeEqual(Buffer.from(token), Buffer.from(expectedToken))) { /* ... */ }
```

---

## 📋 Matriz de Aplicabilidade

| Camada | Web App | API | Mobile | CLI | IA/LLM |
|--------|---------|-----|--------|-----|--------|
| L1-L5 (Perímetro) | ✅ | ✅ | ✅ | ✅ | ✅ |
| L6-L9 (Identidade) | ✅ | ✅ | ✅ | ⚠️ | ⚠️ |
| L10-L13 (Lógica) | ✅ | ✅ | ✅ | ✅ | ✅ |
| L14-L18 (Infra) | ✅ | ✅ | ✅ | ✅ | ✅ |
| L19-L20 (IA/Novos) | ⚠️ | ⚠️ | ⚠️ | ⚠️ | ✅ |

✅ = Obrigatório | ⚠️ = Se aplicável

---

## 🔗 Referências

- OWASP Top 10 (2025): https://owasp.org/Top10/
- OWASP API Security Top 10: https://owasp.org/API-Security/
- CWE Top 25 (2025): https://cwe.mitre.org/top25/
- NIST Cybersecurity Framework: https://www.nist.gov/cyberframework
