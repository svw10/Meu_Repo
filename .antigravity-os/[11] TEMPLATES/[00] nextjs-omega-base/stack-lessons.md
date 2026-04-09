# 🧬 STACK OMEGA — Next.js + Clerk + Resend + Neon
**Status:** Pré-Validado | **Versão:** 1.0 | **Origem:** Lições de 12+ projetos

## 📦 Decisões de Arquitetura (Fixas)
- **Auth:** Clerk (Middleware nativo). ❌ Não usar Auth0/Cognito salvo exceção documentada.
- **Email:** Resend + React Email. ❌ Proibido `nodemailer` ou envio direto de client.
- **DB:** Neon (Serverless Postgres). ✅ Obrigatório Pooling/Proxy. ❌ Conexão direta sem pooler.
- **ORM:** Prisma ou Drizzle (definir no PRD). Se Prisma: usar `neon-http` driver.

## ⚙️ Padrões Aprovados (Copiar & Adaptar)

### 1. Clerk Middleware (`app/middleware.ts`)
```typescript
import { authMiddleware } from "@clerk/nextjs";
export default authMiddleware({
  publicRoutes: ["/api/webhook/clerk", "/", "/login"],
});
export const config = { matcher: ["/((?!.+\\.[\\w]+$|_next).*)", "/", "/(api|trpc)(.*)"] };
```

### 2. Resend + Validação Zod
- Sempre validar payload com `zod` antes de `resend.emails.send`.
- Usar `@react-email/components` para templates tipados.
- **Regra:** Emails transacionais só via Server Action.

### 3. Neon Connection Pooling
```env
# .env.example
DATABASE_URL="postgresql://user:pass@ep-xyz.region.aws.neon.tech/db?sslmode=require"
DIRECT_URL="postgresql://user:pass@ep-xyz.region.aws.neon.tech/db?sslmode=require"
```
- **Crítico:** Em Vercel/Edge, configurar `connection_limit=1` no pooler.
- ❌ **Proibido:** Instanciar `PrismaClient` em `"use client"`.

## 🛡️ Lições Críticas (Injetar em MEMORY_DNA)
| Serviço | Erro Recorrente | Vacina Aplicada |
|---------|----------------|-----------------|
| **Clerk** | Webhook não verificado | Validar sempre `webhooks.createEvent` + log falhas em `Logs/auth-errors.log` |
| **Resend** | Rate limit estourado | Implementar fila (Inngest/BullMQ) se >50 emails/min |
| **Neon** | "Too many connections" | Usar `pooler` endpoint + `connection_limit=1` em serverless |

## 🚀 Integração com Antigravity OS
1. Ao invocar `@template:nextjs-omega`, a IA carrega este contexto automaticamente.
2. Pula fase de "pesquisa de stack" → vai direto para `SPECS_WARP`.
3. Todas as configs aqui seguem `Minhas_Rules/SECURITY.md` e `Nucleo/FABRICA_SOFTWARE.md`.

> 💡 **Nota:** Este arquivo é imutável por IA. Alterações requerem PR no repositório central + aprovação do DELTA.
