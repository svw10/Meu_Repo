name: stack_omega_rules
description: Stack tecnológica oficial do Antigravity OS v3.0 
version: 3.0.0
---

# STACK OMEGA v3.0

> **LEI FUNDAMENTAL:** Tecnologias fora desta lista exigem ADR aprovado por BETA.

---

## 1. NÚCLEO (CORE) - Inegociável

| Tecnologia | Especificação | Proibido |
|:---|:---|:---|
| **Framework** | Next.js 14+ (App Router obrigatório) | Remix, Nuxt, Pages Router |
| **Linguagem** | TypeScript 5+ (strict, zero `any`) | JavaScript puro |
| **Gerenciador** | npm ou pnpm | yarn |

---

## 2. BANCO DE DADOS & ORM

| Tecnologia | Função | Proibido |
|:---|:---|:---|
| **Neon** | PostgreSQL serverless + pgvector | RDS, Supabase, MongoDB |
| **Drizzle ORM** | ORM leve, migrations SQL | Prisma, TypeORM, Sequelize |

---

## 3. INTERFACE (UI/UX)

| Tecnologia | Uso | Proibido |
|:---|:---|:---|
| **Tailwind CSS 3.4+** | Toda estilização | CSS Modules, SCSS, Styled Components |
| **Shadcn/UI** | Componentes base | Material UI, Bootstrap |
| **Radix Primitives** | Acessibilidade | Headless UI alternativos |
| **Lucide React** | Ícones | FontAwesome, emojis como ícones |
| **Framer Motion** | Animações complexas | GSAP (exceto casos específicos) |

---

## 4. BACKEND & INFRAESTRUTURA

| Tecnologia | Função | Alternativa proibida |
|:---|:---|:---|
| **Inngest** | Filas, cron jobs, workflows | Bull, Celery, SQS, Step Functions |
| **Clerk** | Autenticação completa | NextAuth, Auth0, Firebase Auth |
| **Vercel** | Deploy, hosting, edge | AWS EC2, Netlify, Heroku |
| **Zod** | Validação de schemas | Yup, Joi, class-validator |

---

## 5. ESTADO & DADOS

| Tecnologia | Caso de uso | Proibido |
|:---|:---|:---|
| **Zustand** | Estado global simples | Redux |
| **TanStack Query** | Cache de dados servidor | SWR, Apollo Client |
| **Server Actions** | Mutações server-side | API Routes tradicionais (quando possível) |

---

## 6. INTELIGÊNCIA ARTIFICIAL

| Tecnologia | Função | Proibido |
|:---|:---|:---|
| **Vercel AI SDK** | Streaming, chat UI | Implementação própria de stream |
| **OpenRouter** | Roteamento LLM | Chamada direta única a OpenAI |
| **pgvector (Neon)** | Embeddings, RAG | Pinecone, Qdrant, Chroma |

---

## 7. AUTOMATION & INTEGRAÇÕES

| Tecnologia | Função | Proibido |
|:---|:---|:---|
| **Apify** | Web scraping, research | Puppeteer local, Selenium |
| **Evolution API** | WhatsApp Business | Twilio, API própria |
| **Resend** | Email transacional | SendGrid, Nodemailer direto |

---

## 8. LISTA NEGRA ABSOLUTA

| Tecnologia | Motivo |
|:---|:---|
| ❌ Bootstrap / Material UI | Quebra identidade visual |
| ❌ JavaScript sem tipagem | Segurança zero |
| ❌ CSS global / SCSS | Conflito com Tailwind |
| ❌ Secrets no código | Falha de segurança grave |
| ❌ Axios | Use fetch nativo |
| ❌ moment.js | Use date-fns ou native |
| ❌ lodash completo | Importe funções específicas |

---

## ✅ CHECKLIST DE CONFORMIDADE

Antes de iniciar:
- [ ] Todas as tecnologias estão nesta lista?
- [ ] Se não, há ADR aprovado por BETA?
- [ ] `strict: true` no tsconfig.json?
- [ ] Variáveis sensíveis apenas em `.env`?

---
FIM DA STACK OMEGA v3.0 - Disciplina técnica é liberdade criativa.