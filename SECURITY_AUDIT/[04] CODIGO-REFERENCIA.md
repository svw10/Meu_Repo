---
name: codigo_referencia
description: "Snippets de código seguro por domínio"
version: 5.0.0
framework: "Antigravity OS v3.1"
status: active
tags: [security, reference-code, snippets]
---

# 🔐 CÓDIGO DE REFERÊNCIA POR DOMÍNIO

> Copie e adapte. Cada snippet tem comentário com a LEI e CWE que protege.

## 🔐 Auth & Identidade

```typescript
// 🔒 Hash de senha com Argon2id (OWASP 2025)
import argon2 from 'argon2'
const hash = await argon2.hash(password, {
  type: argon2.argon2id, memoryCost: 65536, timeCost: 3, parallelism: 4
})

// 🔒 Comparação constant-time — CWE-208
import crypto from 'crypto'
function safeCompare(a: string, b: string): boolean {
  if (a.length !== b.length) return false
  return crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b))
}

// 🔒 Cookie de sessão seguro
res.cookie('session', token, {
  httpOnly: true, secure: true, sameSite: 'Strict',
  maxAge: 15 * 60 * 1000, partitioned: true
})

// 🔒 Mensagem genérica (previne account enumeration — CWE-204)
return { error: 'Credenciais inválidas' }

// 🔒 Login throttling (por IP + por conta)
const attempts = await getLoginAttempts(email)
if (attempts.count >= 5) {
  const lockDuration = Math.min(2 ** attempts.count * 1000, 15 * 60 * 1000)
  if (Date.now() - attempts.lastAttempt < lockDuration) {
    return { error: 'Muitas tentativas. Tente novamente mais tarde.' }
  }
}
```

## 🔐 IDOR Protection — LEI 6

```typescript
// ✅ ID extraído da sessão, nunca do input
async function updateProfile(session: Session, data: ProfileData) {
  const userId = session.user.id // 🔒 CWE-639
  const profile = await db.profile.findUnique({ where: { userId } })
  if (!profile) throw new AuthError('Perfil não encontrado')
  await db.profile.update({ where: { userId }, data })
}
```

## 🔐 Validação de Input — LEI 2

```typescript
import { z } from 'zod'
const createPostSchema = z.object({
  title: z.string().min(3).max(200).trim(),
  content: z.string().min(10).max(10000).trim(),
  tags: z.array(z.string().max(50)).max(10),
}).strict() // campos extras rejeitados
```

## 🔐 Upload Seguro — LEI 15

```typescript
import { fileTypeFromBuffer } from 'file-type'
import sharp from 'sharp'
const ALLOWED_MIME = new Set(['image/jpeg', 'image/png', 'image/webp'])
const MAX_SIZE = 5 * 1024 * 1024

async function safeUpload(buffer: Buffer) {
  if (buffer.length > MAX_SIZE) throw new Error('Arquivo muito grande')
  const detected = await fileTypeFromBuffer(buffer)
  if (!detected || !ALLOWED_MIME.has(detected.mime)) throw new Error('Tipo não permitido')
  const sanitized = await sharp(buffer)
    .rotate().withMetadata(false)
    .resize(4096, 4096, { withoutEnlargement: true })
    .jpeg({ quality: 85 }).toBuffer()
  return { buffer: sanitized, name: `${crypto.randomUUID()}.jpg` }
}
```

## 🔐 SSRF Protection — LEI 15

```typescript
async function safeFetch(userURL: string) {
  const parsed = new URL(userURL)
  if (!['https:', 'http:'].includes(parsed.protocol)) throw new Error('Protocolo não permitido')
  const addresses = await dns.promises.resolve4(parsed.hostname)
  if (addresses.some(isBlockedIP)) throw new Error('Destino bloqueado')
  const ALLOWED = ['api.example.com']
  if (!ALLOWED.some(d => parsed.hostname === d)) throw new Error('Domínio não permitido')
  return fetch(parsed.toString(), { redirect: 'manual', signal: AbortSignal.timeout(10000) })
}
```

## 🔐 Rate Limiting & Budget Caps

```typescript
const authLimiter = rateLimit({
  windowMs: 15 * 60 * 1000, max: 10,
  store: new RedisStore({ client: redis }),
  keyGenerator: (req) => req.user?.id || req.ip
})
```

## 🔐 Webhooks & Pagamentos — LEI 10

```typescript
async function handleWebhook(req: Request) {
  const event = stripe.webhooks.constructEvent(req.body, sig, process.env.STRIPE_WEBHOOK_SECRET!)
  const processed = await db.webhookEvent.findUnique({ where: { eventId: event.id } })
  if (processed) return { received: true }
  await db.$transaction(async (tx) => {
    await processPayment(tx, event.data.object)
    await tx.webhookEvent.create({ data: { eventId: event.id } })
  })
}
```

## 🔐 Race Condition — LEI 10

```typescript
await db.user.update({
  where: { id, balance: { gte: amount } },
  data: { balance: { decrement: amount } }
})
```

## 🔐 CSP, GraphQL, WebSocket, Mobile, Crypto, Error Handling

Ver detalhes completos no prompt original `[00] ZERO-TRUST-PROMPT.md`.

## 🔐 CSV Injection Protection

```typescript
function escapeCsvCell(value: string): string {
  const dangerous = ['=', '+', '-', '@', '\t', '\r']
  if (dangerous.some(d => value.startsWith(d))) return `'${value}`
  return value
}
```

## 🔐 Container Seguro

```dockerfile
FROM node:20-alpine AS runner
RUN addgroup --system --gid 1001 appgroup && adduser --system --uid 1001 appuser
USER appuser
HEALTHCHECK --interval=30s CMD wget -qO- http://localhost:3000/api/health || exit 1
CMD ["node", "server.js"]
```
