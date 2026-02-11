# STACK OMEGA - CONSTITUIÇÃO TÉCNICA (v18.5)
> **STATUS:** LEI SUPREMA.
> **OBJETIVO:** Padronização absoluta. Todo projeto Antigravity deve usar estas tecnologias.

---

## 1. O NÚCLEO (CORE)
* **Framework:** Next.js 14+ (Obrigatório uso de **App Router**).
* **Linguagem:** TypeScript 5+ (Modo estrito, sem `any`).
* **Gerenciador de Pacotes:** npm ou pnpm.

---

## 2. BANCO DE DADOS & BACKEND
* **Database:** PostgreSQL (Hospedado na **Neon**).
* **ORM:** Drizzle ORM (Leve e rápido).
    * *Proibido:* Prisma (muito pesado para Serverless), TypeORM.
* **API:** Next.js Route Handlers & Server Actions.
* **Validação:** Zod (para todas as entradas de dados).

---

## 3. INTERFACE (UI/UX)
* **CSS:** Tailwind CSS (v3.4+).
    * *Proibido:* CSS Modules, SCSS, Styled Components.
* **Componentes:** Shadcn/UI (Radix Primitives).
* **Ícones:** Lucide React.
* **Animações:** Framer Motion (apenas quando necessário).

---

## 4. INTELIGÊNCIA ARTIFICIAL
* **SDK:** Vercel AI SDK (para streaming de texto).
* **LLM Provider:** OpenRouter ou OpenAI direto.
* **Embeddings:** pgvector (nativo no Postgres via Neon).

---

## 5. AUTENTICAÇÃO & ESTADO
* **Auth:** Clerk (Prioridade 1) ou NextAuth (Prioridade 2).
* **Estado Global:** Zustand (se for simples) ou TanStack Query (para dados do servidor).
    * *Proibido:* Redux (complexidade desnecessária).

---

## 6. LISTA NEGRA (PROIBIÇÕES ABSOLUTAS)
O uso destas tecnologias resultará em falha na auditoria do Agente DELTA:
1.  ❌ **Bootstrap / Material UI** (Quebra o padrão visual).
2.  ❌ **JavaScript puro** (Sem tipagem).
3.  ❌ **Classes de CSS globais** (Fora do Tailwind).
4.  ❌ **Secrets no GitHub** (Sempre usar `.env`).

---

**FIM DA CONSTITUIÇÃO.**