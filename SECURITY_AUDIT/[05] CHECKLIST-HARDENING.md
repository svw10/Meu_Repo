---
name: checklist_hardening
description: "Checklist completo de hardening pré-deploy — 180+ itens"
version: 5.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
status: active
---

# ✅ CHECKLIST DE HARDENING — PRÉ-DEPLOY

> Execute antes de assinar off em produção. Marque ✅ ou ❌.
> Mínimo exigido para deploy: **85% aprovado**, **0 itens CRÍTICOS pendentes**.

---

## 🔐 Secrets & Config
- [ ] Nenhum secret em variáveis públicas (`NEXT_PUBLIC_*`, `VITE_*`)
- [ ] Nenhum secret em código-fonte ou git history
- [ ] Todas as secrets em vault/secrets manager
- [ ] `.gitignore` inclui `.env*`, `*.map`, `*.pem`, `*.key`, `*.p12`
- [ ] `NODE_ENV=production` em produção
- [ ] Source maps não servidos em produção
- [ ] Swagger/OpenAPI não expostos em produção
- [ ] Debug mode desativado em produção

## 🔐 Auth & Identity
- [ ] Middleware de auth montado em TODAS as rotas protegidas
- [ ] Identidade extraída do token, nunca do input (LEI 6)
- [ ] Mensagens de login genéricas (sem account enumeration)
- [ ] Login throttling ativo (por IP + por conta)
- [ ] Sessões com idle timeout + absolute timeout + rotation
- [ ] Tokens de reset com expiração curta + uso único
- [ ] 2FA/MFA para operações sensíveis
- [ ] Senhas com hash Argon2id/bcrypt (nunca MD5/SHA)

## 🔐 Authorization & RBAC
- [ ] Cada endpoint verifica role E ownership E tenant
- [ ] RLS habilitado em tabelas com dados de usuário
- [ ] Nenhuma policy `USING (true)` ou `WITH CHECK (true)`
- [ ] Admin routes protegidas por role check server-side
- [ ] Nenhum boolean injection via query param (`?admin=true`)

## 🔐 Input Validation
- [ ] Todos os endpoints usam schema validation com `.strict()`
- [ ] `maxLength` em todos os campos de texto
- [ ] `maxItems` em todos os arrays
- [ ] Paginação com `pageSize` máximo (≤ 100)
- [ ] Projeção explícita (nunca `SELECT *`)
- [ ] Nenhum endpoint aceita ID sem verificar ownership
- [ ] Server Actions com validação Zod

## 🔐 Business Logic
- [ ] Operações financeiras usam transação atômica com lock
- [ ] Invariantes de negócio validados ANTES de persistir
- [ ] Idempotência em webhooks e operações críticas
- [ ] Preços vindos do servidor, nunca do cliente

## 🔐 File Upload
- [ ] Validação por magic bytes (não extensão)
- [ ] Imagens reprocessadas (sharp)
- [ ] Zip bomb protection
- [ ] Armazenamento externo (S3/Cloudinary)

## 🔐 SSRF & External Fetch
- [ ] Fetch com allowlist de domínios + bloqueio de IPs internos
- [ ] Redirects validados (destino final verificado)
- [ ] Timeout em todas as chamadas externas

## 🔐 XSS & CSP
- [ ] Nenhum `dangerouslySetInnerHTML`/`v-html` com input
- [ ] CSP configurado (sem `unsafe-inline`/`unsafe-eval`)
- [ ] Scripts de terceiros com SRI (integrity attribute)

## 🔐 CSRF & Cookies
- [ ] Mutações protegidas com CSRF ou SameSite=Strict
- [ ] Cookies de sessão: HttpOnly + Secure + SameSite

## 🔐 Headers & CORS
- [ ] HSTS presente
- [ ] X-Content-Type-Options: nosniff
- [ ] X-Frame-Options: DENY
- [ ] Referrer-Policy configurado
- [ ] Permissions-Policy configurado
- [ ] CORS com allowlist (nunca `*` em produção)

## 🔐 Rate Limiting & Budgets
- [ ] Rate limiting em endpoints autenticados e públicos
- [ ] Budget caps para chamadas de IA/terceiros pagos

## 🔐 Error Handling & Logging
- [ ] Stack traces não expostas em produção
- [ ] Mensagens genéricas pro cliente, detalhadas pro log
- [ ] Nenhum `catch (e) {}` sem tratamento
- [ ] Correlation ID em todas as requests
- [ ] Logs sem senhas, tokens, dados de cartão

## 🔐 Dependencies & Supply Chain
- [ ] `package-lock.json` commitado
- [ ] `npm audit` sem vulnerabilidades CRÍTICAS/ALTAS
- [ ] Nenhum pacote phantom/typosquatted
- [ ] Nenhum pacote abandonado (> 12 meses)

## 🔐 Payments & Webhooks
- [ ] Webhooks verificados por assinatura
- [ ] Webhooks idempotentes
- [ ] Preços do servidor

## 🔐 Mobile (se aplicável)
- [ ] Tokens em Keychain/Keystore
- [ ] Certificate pinning
- [ ] Jailbreak/root detection
- [ ] BFF pattern

## 🔐 LLM/IA Integration
- [ ] GuardRails implementados (secrets + injection + PII + fail-safe)
- [ ] Budget/token caps por usuário
- [ ] Output do LLM tratado como dado não confiável
- [ ] System prompt não exposto ao usuário

## 🔐 Container & Infra
- [ ] Container roda como não-root
- [ ] Image base sem CVEs (trivy scan)
- [ ] Secrets via secrets mount (não env)
- [ ] TLS 1.2+ obrigatório; HSTS com preload
- [ ] Health check endpoint `/api/health`

## 🔐 GraphQL (se aplicável)
- [ ] Depth limiting ativo
- [ ] Query complexity limiting
- [ ] Introspecção desabilitada em prod
- [ ] Auth em cada resolver

## 🔐 WebSocket (se aplicável)
- [ ] Auth no handshake
- [ ] Rate limit por conexão

## 🔐 Advanced Vectors
- [ ] Comparação de tokens com constant-time
- [ ] Regex testados contra ReDoS
- [ ] Export CSV com escape de fórmulas
- [ ] Nenhum merge profundo de input (Prototype Pollution)
- [ ] Comportamento definido para params duplicados (HPP)
- [ ] Nenhum redirect sem validação (Open Redirect)
- [ ] `crypto.randomBytes()` para tokens (nunca `Math.random()`)

## 🔐 Feature Flags & Testing
- [ ] Flags sensíveis validadas server-side
- [ ] Testes de segurança automatizados
- [ ] Pipeline CI/CD com SAST/DAST/SCA

## 🔐 LGPD & Compliance
- [ ] Consentimento explícito implementado
- [ ] Direito ao esquecimento funcional
- [ ] PII mascarada em logs
- [ ] Retenção de dados configurada
- [ ] DPA (Data Processing Agreement) com terceiros

## 🔐 Observabilidade de Segurança
- [ ] Alertas de tentativas de login em massa
- [ ] Alertas de acesso não autorizado
- [ ] Alertas de secrets scan no CI
- [ ] Dashboard de métricas de segurança
- [ ] Runbook de resposta a incidentes documentado

---

## 📊 Cálculo do Score

```
Total de itens aplicáveis: ___
Total marcados ✅: ___
Percentual: ___% 

🟢 ≥ 85%: APROVADO para deploy
🟡 70-84%: APROVADO COM RESSALVAS (corrigir em 7 dias)
🔴 < 70%: REPROVADO — NÃO DEPLOYAR
```
