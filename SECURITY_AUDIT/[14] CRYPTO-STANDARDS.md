---
name: crypto_standards
description: "Padrões de criptografia, hashing e geração de tokens"
version: 5.0.0
framework: "Antigravity OS v3.1"
status: active
tags: [security, cryptography, hashing, tokens, encryption]
---

# 🔐 PADRÕES DE CRIPTOGRAFIA

> Use APENAS os algoritmos aprovados. Qualquer desvio exige ADR.

---

## Algoritmos Aprovados

| Uso | Algoritmo | Configuração | Proibido |
|-----|-----------|-------------|----------|
| **Hash de senha** | Argon2id | memoryCost: 65536, timeCost: 3, parallelism: 4 | MD5, SHA-1, SHA-256 (sem salt), bcrypt < 10 rounds |
| **Hash de senha (fallback)** | bcrypt | rounds: 12 | rounds < 10 |
| **Hash de integridade** | SHA-256, SHA-3 | Com HMAC quando necessário | MD5, SHA-1 |
| **Criptografia simétrica** | AES-256-GCM | IV de 16 bytes, authTag | AES-ECB, AES-CBC sem HMAC, DES, 3DES |
| **Criptografia assimétrica** | RSA-OAEP 2048+ | SHA-256 como hash | RSA-PKCS1v15, RSA < 2048 |
| **Assinatura JWT** | RS256 (RSA) ou ES256 (ECDSA) | Chaves rotacionadas a cada 90 dias | HS256 em produção, none |
| **Geração de tokens** | `crypto.randomBytes(32)` | Hex ou base64url | `Math.random()`, `Date.now()`, UUIDv4 para secrets |
| **IDs públicos** | UUIDv7 | Time-ordered | Auto-increment, UUIDv1 |
| **KDF (Key Derivation)** | HKDF, PBKDF2 | ≥ 600.000 iterations (PBKDF2) | < 10.000 iterations |
| **TLS** | TLS 1.2+ | Cipher suites AEAD | TLS 1.0, TLS 1.1, SSL |

---

## Implementações de Referência

### Geração de Tokens Seguros
```typescript
import crypto from 'crypto'

// 🔒 Token seguro — 256 bits de entropia
function generateSecureToken(bytes = 32): string {
  return crypto.randomBytes(bytes).toString('hex')
}

// 🔒 Token URL-safe
function generateUrlSafeToken(bytes = 32): string {
  return crypto.randomBytes(bytes).toString('base64url')
}

// ❌ PROIBIDO
const insecureToken = Math.random().toString(36) // Previsível!
const insecureId = Date.now().toString() // Previsível!
```

### AES-256-GCM (Criptografia Autenticada)
```typescript
import crypto from 'crypto'

const ALGORITHM = 'aes-256-gcm'
const IV_LENGTH = 16
const AUTH_TAG_LENGTH = 16

function encrypt(plaintext: string, key: Buffer): string {
  const iv = crypto.randomBytes(IV_LENGTH)
  const cipher = crypto.createCipheriv(ALGORITHM, key, iv)
  
  let encrypted = cipher.update(plaintext, 'utf8', 'hex')
  encrypted += cipher.final('hex')
  const authTag = cipher.getAuthTag()
  
  // iv:authTag:ciphertext
  return `${iv.toString('hex')}:${authTag.toString('hex')}:${encrypted}`
}

function decrypt(encryptedData: string, key: Buffer): string {
  const [ivHex, authTagHex, ciphertext] = encryptedData.split(':')
  const iv = Buffer.from(ivHex, 'hex')
  const authTag = Buffer.from(authTagHex, 'hex')
  
  const decipher = crypto.createDecipheriv(ALGORITHM, key, iv)
  decipher.setAuthTag(authTag)
  
  let decrypted = decipher.update(ciphertext, 'hex', 'utf8')
  decrypted += decipher.final('utf8')
  return decrypted
}
```

### JWT — Assinatura e Verificação
```typescript
import jwt from 'jsonwebtoken'
import fs from 'fs'

// 🔒 RS256 com par de chaves RSA
const privateKey = fs.readFileSync('keys/private.pem')
const publicKey = fs.readFileSync('keys/public.pem')

function signToken(payload: object): string {
  return jwt.sign(payload, privateKey, {
    algorithm: 'RS256',
    expiresIn: '15m',      // Curto!
    issuer: 'myapp',
    audience: 'myapp-api',
  })
}

function verifyToken(token: string): jwt.JwtPayload {
  return jwt.verify(token, publicKey, {
    algorithms: ['RS256'],  // Whitelist de algoritmos
    issuer: 'myapp',
    audience: 'myapp-api',
  }) as jwt.JwtPayload
}

// ❌ PROIBIDO
jwt.decode(token)                    // Não verifica assinatura!
jwt.verify(token, 'simple-secret')   // HS256 com secret fraco!
```

### Comparação Constant-Time
```typescript
import crypto from 'crypto'

// 🔒 Previne timing attacks
function safeCompare(a: string, b: string): boolean {
  if (a.length !== b.length) return false
  return crypto.timingSafeEqual(Buffer.from(a), Buffer.from(b))
}

// ❌ PROIBIDO (vulnerável a timing attack)
if (token === expectedToken) { /* ... */ }
```

### Rotação de Chaves
```typescript
// 🔒 Suporte a múltiplas chaves (rotação sem downtime)
const KEYS = {
  current: process.env.ENCRYPTION_KEY_V2!,
  previous: process.env.ENCRYPTION_KEY_V1!, // Ainda aceita para decrypt
}

function decryptWithRotation(data: string): string {
  try {
    return decrypt(data, Buffer.from(KEYS.current, 'hex'))
  } catch {
    return decrypt(data, Buffer.from(KEYS.previous, 'hex'))
  }
}

function encryptNew(data: string): string {
  return encrypt(data, Buffer.from(KEYS.current, 'hex'))
}
```

---

## Checklist de Criptografia

- [ ] Senhas com Argon2id ou bcrypt (≥ 12 rounds)
- [ ] JWT com RS256 ou ES256 (nunca HS256 em prod)
- [ ] Tokens com `crypto.randomBytes()` (nunca `Math.random()`)
- [ ] AES-256-GCM para dados sensíveis em repouso
- [ ] TLS 1.2+ em todas as conexões
- [ ] Comparações de token com `timingSafeEqual()`
- [ ] Chaves rotacionadas a cada 90 dias
- [ ] Nenhum algoritmo deprecated (MD5, SHA-1, DES)
- [ ] IVs/nonces nunca reutilizados
- [ ] Chaves derivadas de senha com PBKDF2 ≥ 600k iterations

---

## 🔗 Referências

- OWASP Cryptographic Storage: https://cheatsheetseries.owasp.org/cheatsheets/Cryptographic_Storage_Cheat_Sheet.html
- NIST SP 800-132 (PBKDF): https://csrc.nist.gov/publications/detail/sp/800-132/final
- OWASP Password Storage: https://cheatsheetseries.owasp.org/cheatsheets/Password_Storage_Cheat_Sheet.html
