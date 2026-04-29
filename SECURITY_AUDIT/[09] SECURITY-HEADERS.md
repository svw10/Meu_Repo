---
name: security_headers
description: "Configuração de headers de segurança por plataforma"
version: 5.0.0
framework: "Antigravity OS v3.1"
status: active
tags: [security, headers, csp, hsts, cors]
---

# 🔐 SECURITY HEADERS — Configuração por Plataforma

---

## Headers Obrigatórios

| Header | Valor | Propósito |
|--------|-------|-----------|
| `Strict-Transport-Security` | `max-age=63072000; includeSubDomains; preload` | Força HTTPS |
| `X-Content-Type-Options` | `nosniff` | Previne MIME sniffing |
| `X-Frame-Options` | `DENY` | Previne clickjacking |
| `X-XSS-Protection` | `0` | Desabilita filtro XSS do browser (causa mais problemas) |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | Controla referer |
| `Permissions-Policy` | `camera=(), microphone=(), geolocation=()` | Restringe APIs do browser |
| `Content-Security-Policy` | Ver abaixo | Previne XSS, injection |

---

## Next.js (next.config.js)

```javascript
// next.config.js
const securityHeaders = [
  { key: 'Strict-Transport-Security', value: 'max-age=63072000; includeSubDomains; preload' },
  { key: 'X-Content-Type-Options', value: 'nosniff' },
  { key: 'X-Frame-Options', value: 'DENY' },
  { key: 'X-XSS-Protection', value: '0' },
  { key: 'Referrer-Policy', value: 'strict-origin-when-cross-origin' },
  { key: 'Permissions-Policy', value: 'camera=(), microphone=(), geolocation=(), browsing-topics=()' },
]

module.exports = {
  async headers() {
    return [{ source: '/(.*)', headers: securityHeaders }]
  },
  poweredBy: false, // Remove X-Powered-By
}
```

## Vercel (vercel.json)

```json
{
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        { "key": "Strict-Transport-Security", "value": "max-age=63072000; includeSubDomains; preload" },
        { "key": "X-Content-Type-Options", "value": "nosniff" },
        { "key": "X-Frame-Options", "value": "DENY" },
        { "key": "Referrer-Policy", "value": "strict-origin-when-cross-origin" },
        { "key": "Permissions-Policy", "value": "camera=(), microphone=(), geolocation=()" }
      ]
    }
  ]
}
```

## Nginx

```nginx
server {
    listen 443 ssl http2;
    server_tokens off;

    add_header Strict-Transport-Security "max-age=63072000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-Frame-Options "DENY" always;
    add_header Referrer-Policy "strict-origin-when-cross-origin" always;
    add_header Permissions-Policy "camera=(), microphone=(), geolocation=()" always;
    add_header Content-Security-Policy "default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data: https:; connect-src 'self' https://api.example.com; frame-ancestors 'none'; base-uri 'self'; form-action 'self'; object-src 'none'" always;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256;
    ssl_prefer_server_ciphers off;
}
```

## Express.js (com Helmet)

```typescript
import helmet from 'helmet'

app.use(helmet({
  contentSecurityPolicy: {
    directives: {
      defaultSrc: ["'self'"],
      scriptSrc: ["'self'"],
      styleSrc: ["'self'", "'unsafe-inline'"],
      imgSrc: ["'self'", "data:", "https:"],
      connectSrc: ["'self'", "https://api.example.com"],
      frameAncestors: ["'none'"],
      baseUri: ["'self'"],
      formAction: ["'self'"],
      objectSrc: ["'none'"],
    },
  },
  hsts: { maxAge: 63072000, includeSubDomains: true, preload: true },
}))
```

---

## CSP — Content Security Policy

### CSP Restritivo (Recomendado)
```
default-src 'self';
script-src 'self' 'nonce-{RANDOM}';
style-src 'self' 'nonce-{RANDOM}';
img-src 'self' data: https:;
connect-src 'self' https://api.example.com;
font-src 'self' https://fonts.gstatic.com;
frame-ancestors 'none';
base-uri 'self';
form-action 'self';
object-src 'none';
upgrade-insecure-requests;
```

### CSP para Next.js com nonce
```typescript
// middleware.ts
import { NextResponse } from 'next/server'
import type { NextRequest } from 'next/server'

export function middleware(request: NextRequest) {
  const nonce = Buffer.from(crypto.randomUUID()).toString('base64')
  const cspHeader = `
    default-src 'self';
    script-src 'self' 'nonce-${nonce}' 'strict-dynamic';
    style-src 'self' 'nonce-${nonce}';
    img-src 'self' blob: data: https:;
    connect-src 'self' https://*.vercel.app;
    frame-ancestors 'none';
  `.replace(/\s{2,}/g, ' ').trim()

  const response = NextResponse.next()
  response.headers.set('Content-Security-Policy', cspHeader)
  response.headers.set('x-nonce', nonce)
  return response
}
```

---

## CORS — Configuração Segura

```typescript
// ❌ NUNCA em produção
app.use(cors({ origin: '*', credentials: true }))

// ✅ CORRETO: Allowlist
const ALLOWED_ORIGINS = [
  'https://myapp.com',
  'https://admin.myapp.com',
  ...(process.env.NODE_ENV === 'development' ? ['http://localhost:3000'] : [])
]

app.use(cors({
  origin: (origin, callback) => {
    if (!origin || ALLOWED_ORIGINS.includes(origin)) {
      callback(null, true)
    } else {
      callback(new Error('CORS não permitido'))
    }
  },
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'PATCH', 'DELETE'],
  allowedHeaders: ['Content-Type', 'Authorization'],
  maxAge: 86400
}))
```

---

## 🧪 Validação

```bash
# Testar headers de um site
curl -I https://myapp.com

# Ferramentas online
# https://securityheaders.com
# https://observatory.mozilla.org
# https://csp-evaluator.withgoogle.com
```
