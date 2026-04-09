---
name: codando
framework: "Antigravity OS v3.1"
owner_agent: GAMMA
trigger: "/code"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: codando
description: Tech Lead. Escreve código de produção limpo, tipado e seguro para Stack Omega. Zero boilerplate, máxima qualidade.
version: 3.0.1
tags: [desenvolvimento, nextjs, typescript, clean-code, stack-omega]
---

# 06 - CODANDO (Tech Lead Protocol)

## 🎯 Objetivo
Produzir código que pareça escrito por Engenheiro Sênior do Google. Auto-explicativo, robusto, tipado e alinhado à Stack Omega v3.0.

> **Princípio**: Você não é pago por linhas de código, mas por problemas resolvidos. Prefira bibliotecas padrão a reinventar.

## 🛠️ Stack Omega v3.0 (Imutável)

| Camada | Tecnologia | Uso |
|:---|:---|:---|
| **Framework** | Next.js 14+ (App Router) | Server Components, routing, API routes |
| **Language** | TypeScript 5+ | Strict mode, zero `any` |
| **Styling** | Tailwind CSS 3.4+ | Utilitários, design tokens via CSS vars |
| **UI Components** | Shadcn/UI + Radix | Base acessível, customizável |
| **Database** | Neon PostgreSQL + Drizzle ORM | Schema-first, type-safe queries |
| **Queues** | Inngest | Background jobs, cron, step functions |
| **Auth** | Clerk | JWT, RBAC, proteção de rotas |
| **AI/LLM** | OpenRouter + Vercel AI SDK | Múltiplos providers, streaming |
| **Validation** | Zod | Runtime validation, schemas |
| **Icons** | Lucide React | Consistente, tree-shakeable |
| **Motion** | Framer Motion | Animações premium (quando necessário) |

> **Stack Omega é non-negotiable**. Sem exceções sem ADR aprovado por BETA.

## ⚡ Regras de Ouro (Commandments)

### 1. Type Safety Absoluta
```typescript
// ❌ PROIBIDO
const data: any = fetchData();
let user: object;

// ✅ OBRIGATÓRIO
interface User {
  id: string;
  email: string;
  name: string | null;
  createdAt: Date;
}

const data: Promise<User[]> = fetchUsers();
const user = await fetchUserById(params.id) as User | null;
```

### 2. DRY (Don't Repeat Yourself)
> "Copiou 2x? Refatore. Copiou 3x? Componente/utilitário obrigatório."

```typescript
// ❌ Ruim: Repetição
<button className="bg-blue-500 text-white px-4 py-2 rounded">
<button className="bg-blue-500 text-white px-4 py-2 rounded">

// ✅ Bom: Componente reutilizável
// components/ui/button.tsx
import { cn } from "@/lib/utils";

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: "primary" | "secondary" | "danger";
  isLoading?: boolean;
}

export function Button({ 
  variant = "primary", 
  isLoading, 
  className, 
  children,
  ...props 
}: ButtonProps) {
  return (
    <button 
      className={cn(
        "px-4 py-2 rounded font-medium transition-colors",
        variant === "primary" && "bg-primary text-primary-foreground hover:bg-primary/90",
        variant === "secondary" && "bg-secondary text-secondary-foreground",
        variant === "danger" && "bg-destructive text-destructive-foreground",
        isLoading && "opacity-50 cursor-not-allowed",
        className
      )}
      disabled={isLoading}
      {...props}
    >
      {isLoading ? <Spinner className="mr-2" /> : null}
      {children}
    </button>
  );
}
```

### 3. Server vs Client Components
```typescript
// ✅ Server Component (padrão): page.tsx, layout.tsx
// app/dashboard/page.tsx
import { db } from "@/db";
import { UserCard } from "./user-card"; // Client Component importado

export default async function DashboardPage() {
  const users = await db.query.users.findMany(); // Server-side fetch
  
  return (
    <main>
      <h1>Dashboard</h1>
      {users.map(user => (
        <UserCard key={user.id} user={user} /> // Client interactivity aqui
      ))}
    </main>
  );
}

// ✅ Client Component (apenas quando necessário): 'use client'
// app/dashboard/user-card.tsx
'use client';

import { useState } from 'react';
import { Button } from '@/components/ui/button';

export function UserCard({ user }: { user: User }) {
  const [isExpanded, setIsExpanded] = useState(false);
  
  return (
    <div>
      <h3>{user.name}</h3>
      <Button onClick={() => setIsExpanded(!isExpanded)}>
        {isExpanded ? 'Menos' : 'Mais'}
      </Button>
    </div>
  );
}
```

**Regra**: `'use client'` apenas em:
- Folhas interativas (botões, inputs, modais)
- Hooks (useState, useEffect, useQuery)
- Browser APIs (localStorage, navigator)

### 4. Error Handling Robusto
```typescript
// ❌ PROIBIDO: Promise solta
fetch('/api/data').then(res => res.json());

// ✅ OBRIGATÓRIO: Tratamento completo
// Server Action
export async function createUser(data: unknown) {
  try {
    const validated = userSchema.parse(data); // Zod validation
    
    const user = await db.insert(users).values(validated).returning();
    
    revalidatePath('/users');
    return { success: true, data: user[0] };
    
  } catch (error) {
    if (error instanceof z.ZodError) {
      return { success: false, error: 'Dados inválidos', details: error.errors };
    }
    
    console.error('[createUser]', error);
    return { success: false, error: 'Erro interno' };
  }
}

// Client-side usage
const result = await createUser(formData);
if (!result.success) {
  toast.error(result.error);
  return;
}
toast.success('Usuário criado!');
```

### 5. Clean Code & Convenções

#### Nomenclatura
| Tipo | Convenção | Exemplo |
|:---|:---|:---|
| Componentes | PascalCase | `UserCard.tsx`, `AuthProvider.tsx` |
| Hooks | camelCase + use | `useAuth.ts`, `useLocalStorage.ts` |
| Utilitários | camelCase | `formatDate.ts`, `cn.ts` |
| Server Actions | camelCase + verbo | `createUser.ts`, `sendEmail.ts` |
| Schemas | PascalCase + Schema | `userSchema.ts`, `apiSchema.ts` |
| Constantes | SCREAMING_SNAKE | `API_BASE_URL`, `MAX_RETRY_COUNT` |

#### Estrutura de Arquivos (App Router)
```
src/
├── app/                    # Next.js App Router
│   ├── (marketing)/        # Route groups (sem URL)
│   │   ├── page.tsx        # Landing page
│   │   └── layout.tsx
│   ├── (dashboard)/        # Route group autenticado
│   │   ├── layout.tsx      # Proteção Clerk
│   │   ├── page.tsx        # Dashboard
│   │   └── settings/
│   │       └── page.tsx
│   ├── api/                # API Routes (quando necessário)
│   │   └── webhook/
│   │       └── route.ts
│   └── layout.tsx          # Root layout
├── components/
│   ├── ui/                 # Shadcn base (Button, Input)
│   ├── forms/              # Formulários específicos
│   ├── dashboard/          # Componentes de domínio
│   └── shared/             # Componentes genéricos
├── lib/
│   ├── utils.ts            # cn(), helpers
│   ├── hooks/              # Custom hooks
│   └── actions/            # Server Actions
├── db/
│   ├── schema.ts           # Drizzle schema
│   └── index.ts            # Cliente Neon
└── types/
    └── index.ts            # Tipos globais
```

#### Imports (Alias Obrigatórios)
```typescript
// ❌ PROIBIDO: Imports relativos complexos
import { Button } from '../../../components/ui/button';

// ✅ OBRIGATÓRIO: Alias absolutos
import { Button } from '@/components/ui/button';
import { db } from '@/db';
import { createUser } from '@/lib/actions/users';
import type { User } from '@/types';
```

## 🎨 Integração com UI Kit

Sempre consulte tokens de design:

```typescript
// ❌ Hardcoded
<div className="bg-blue-500 text-white p-4">

// ✅ Design tokens (CSS vars do UI Kit)
<div className="bg-primary text-primary-foreground p-4 rounded-lg border border-border shadow-sm">
```

**Tokens disponíveis:**
- Cores: `primary`, `secondary`, `destructive`, `muted`, `accent`
- Texto: `foreground`, `primary-foreground`, `muted-foreground`
- Espaçamento: `p-4`, `gap-4` (sistema 4px base)
- Bordas: `border`, `rounded-lg`, `shadow-sm`

## 📝 Formato de Entrega

Ao escrever código, siga estritamente:

```
📁 **Arquivo:** `caminho/relativo/ao/projeto.tsx`

```typescript
// Código COMPLETO aqui (nunca use "...rest of code")
// Inclua imports, types, componente, exports
```

**💡 Explicação:** (Apenas se lógica complexa)
- Por que esta abordagem?
- Trade-offs considerados?
```

## 🚫 Anti-Padrões (PROIBIDOS)

- `any` em qualquer lugar
- `console.log` em produção (use `console.error` para erros)
- CSS-in-JS (styled-components, emotion) - use Tailwind
- Estados globais desnecessários (Zustand/Redux sem necessidade)
- Fetch no useEffect (use Server Components ou React Query)
- APIs REST quando Server Action suffice
- Variações de componentes por props booleanas (use `variant` ou `cn`)

## ✅ Checklist Pré-Commit

- [ ] Zero erros TypeScript (`npx tsc --noEmit`)
- [ ] Zero warnings ESLint críticos
- [ ] Componentes tipados (props interface)
- [ ] Server/Client separation correto
- [ ] Error handling implementado
- [ ] Nomenclatura segue convenções
- [ ] Imports usam alias `@/`
- [ ] Design tokens usados (não hardcoded)

## 🔗 Integração

- **Chamada:** Direta por `03_executando_planos` (durante execução)
- **Consulta:** UI Kit Design tokens em `00_base/design_tokens.md`
- **Validação:** `05_verificando_conclusao` (verifica se código segue padrões)
- **Pré-requisito:** `02_planejando_solucoes` (PLAN com arquitetura definida)

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Atualizado para Stack Omega v3.0 (Inngest, Neon, OpenRouter)
- Adicionado convenções de nomenclatura específicas
- Estrutura de arquivos App Router detalhada
- Integração com UI Kit Design tokens
- Alias `@/` obrigatório
- Regras anti-padrões expandidas

### v5.0.0 (Original)
- Type safety absoluta
- DRY principle
- Client/Server separation
- Clean code fundamentals
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
