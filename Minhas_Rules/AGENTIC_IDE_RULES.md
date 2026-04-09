---
name: agentic_ide_rules
description: 14 Regras para IDEs Agênticas adaptadas para Stack Omega v3.1
version: 1.0.0
scope: global
enforcement: hard
source: "Adaptado de '14 Rules para IDEs Agenticas' (Cursor/Claude Code/Windsurf)"
---

# 🛡️ 14 REGRAS PARA IDEs AGÊNTICAS — Stack Omega Edition

> **Propósito:** Garantir segurança, performance e consistência ao usar agentes de IA para desenvolvimento no ecossistema Antigravity OS.

---

## 🎯 Como Usar

1. **Antes de codar:** Consulte esta regra + `STACK_OMEGA_RULES.md`
2. **Durante a geração:** O agente deve validar cada bloco contra as restrições
3. **Após a geração:** DELTA deve auditar conformidade antes do commit

---

## 🔐 SEGURANÇA & ISOLAMENTO

### Regra 01: Isolamento Frontend/Backend (Adaptada)
**Gatilho:** Criar/modificar arquivos em `app/`, `components/`, ou client-side code.

**Restrições Stack Omega:**
- ❌ **Proibido:** Chamar Neon/Drizzle diretamente em Client Components (`'use client'`)
- ❌ **Proibido:** Expor `process.env` sensíveis no bundle (use Server Actions)
- ✅ **Obrigatório:** Toda mutação de dados deve passar por Server Action ou Route Handler
- ✅ **Obrigatório:** Validar input com Zod antes de qualquer operação no banco

**Exemplo Correto (Next.js App Router):**
```typescript
// app/components/UserForm.tsx (Client Component)
'use client';
export function UserForm() {
  const createUser = async (data: FormData) => {
    'use server'; // ou chamar Server Action externa
    const validated = UserSchema.parse(Object.fromEntries(data));
    await db.insert(users).values(validated);
    revalidatePath('/users');
  };
  // ...
}
```

### Regra 03: Blindagem Multi-Tenant (Adaptada)
**Gatilho:** Queries ao banco, migrations, ou acesso a dados de usuários.

**Restrições Stack Omega:**
- ✅ **Obrigatório:** Usar Clerk Organizations ou `userId` do `auth()` em toda query
- ✅ **Obrigatório:** Habilitar Row Level Security (RLS) no Neon para tabelas sensíveis
- ❌ **Proibido:** Aceitar `companyId` ou `userId` como parâmetro livre do frontend

**Exemplo Correto (Drizzle + Clerk):**
```typescript
import { auth } from '@clerk/nextjs/server';
import { db } from '@/db';

export async function getUserData() {
  const { userId } = await auth();
  if (!userId) throw new Error('Unauthorized');
  
  return await db.query.users.findFirst({
    where: eq(users.clerkId, userId), // clerkId é o vínculo seguro
  });
}
```

### Regra 04: Secrets Vault (Alinhada)
**Gatilho:** Manipular API keys, tokens, ou credenciais.

**Restrições Stack Omega:**
- ✅ **Obrigatório:** Usar `process.env.NOME_DA_VAR` (nunca hardcode)
- ✅ **Obrigatório:** Validar variáveis críticas no startup com Zod
- ✅ **Obrigatório:** Sanitizar logs (nunca imprimir secrets ou PII)

**Validação no Startup:**
```typescript
// src/lib/env.ts
import { z } from 'zod';

const EnvSchema = z.object({
  DATABASE_URL: z.string().url(),
  CLERK_SECRET_KEY: z.string().min(10),
  OPENROUTER_API_KEY: z.string().startsWith('sk-or-'),
});

export const env = EnvSchema.parse(process.env);
```

### Regra 05: Session Hardening (Referenciado)
**Gatilho:** Configurar auth, cookies, ou middleware.

**Stack Omega:** Clerk já aplica:
- `httpOnly: true`, `secure: true` (em produção), `sameSite: 'lax'`
- Refresh tokens automáticos
- Proteção contra CSRF

**Ação do Agente:** Apenas configurar Clerk conforme docs, não reinventar sessão.

---

## ⚡ PERFORMANCE & ARQUITETURA

### Regra 02: Async Performance (Adaptada)
**Gatilho:** Criar rotas, Server Actions, ou chamadas externas.

**Restrições Stack Omega:**
- ✅ **Obrigatório:** Usar `async/await` em Server Actions e Route Handlers
- ✅ **Obrigatório:** Delegar tarefas longas (>30s) para Inngest
- ❌ **Proibido:** Bloquear o event loop com operações síncronas

**Exemplo Correto (Inngest para Long-Running):**
```typescript
// src/inngest/functions/process-document.ts
export const processDocument = inngest.createFunction(
  { id: 'process-document' },
  { event: 'document/uploaded' },
  async ({ event, step }) => {
    const result = await step.run('heavy-processing', async () => {
      // Operação que pode levar minutos
      return await heavyAIProcessing(event.data.fileId);
    });
    return result;
  }
);
```

### Regra 06: Clean Architecture (Reforçada)
**Gatilho:** Criar novos arquivos ou adicionar lógica de negócio.

**Estrutura Stack Omega:**
```
src/
├── app/                 # Route Handlers + Server Actions (interface)
├── components/          # UI components (apresentação)
├── lib/
│   ├── actions/         # Server Actions reutilizáveis
│   ├── services/        # Lógica de negócio pura (sem side-effects)
│   ├── db/              # Schema Drizzle + queries
│   └── utils/           # Helpers genéricos
├── inngest/             # Background jobs
└── types/               # Tipos compartilhados
```

**Regra:** Lógica de negócio nunca em `app/` ou `components/` — sempre em `lib/services/`.

### Regra 11: API Consistency (Adaptada para Next.js)
**Gatilho:** Criar Route Handlers ou Server Actions.

**Convenções Stack Omega:**
| Ação | Padrão Next.js | Status Code |
|------|---------------|-------------|
| Listar | `GET /api/resources` | 200 + array |
| Detalhe | `GET /api/resources/[id]` | 200 + objeto |
| Criar | `POST /api/resources` (Server Action) | 201 + objeto |
| Atualizar | `PATCH /api/resources/[id]` | 200 + objeto |
| Deletar | `DELETE /api/resources/[id]` | 204 |

**Padrão de Resposta de Erro:**
```typescript
{
  success: false,
  error: {
    code: 'VALIDATION_ERROR' | 'NOT_FOUND' | 'INTERNAL_ERROR',
    message: 'Mensagem amigável ao usuário',
    requestId: string, // para rastreabilidade
  }
}
```

---

## 🧪 QUALIDADE & TESTES

### Regra 08: Error Handling (Consolidado)
**Gatilho:** Criar blocos try/catch ou handlers de erro.

**Princípios Stack Omega:**
- ✅ **Obrigatório:** Usar logger estruturado (`logger.error()`, nunca `console.log`)
- ✅ **Obrigatório:** Incluir `requestId` em todos os logs de erro
- ✅ **Obrigatório:** Separar mensagem para usuário vs. detalhes técnicos no log
- ❌ **Proibido:** `catch(e) {}` ou `try { } catch { pass }`

**Exemplo Correto:**
```typescript
import { logger } from '@/lib/observability/logger';

export async function chargeCustomer(customerId: string, amount: number) {
  const requestId = crypto.randomUUID();
  const log = logger.child({ requestId, customerId });
  
  try {
    log.info('charge.started', { amount });
    const result = await paymentProvider.charge({ customerId, amount });
    log.info('charge.success', { transactionId: result.id });
    return { success: true, data: result };
  } catch (error) {
    log.error('charge.failed', error as Error, { amount });
    
    if (error instanceof StripeError && error.type === 'card_declined') {
      return {
        success: false,
        error: {
          code: 'CARD_DECLINED',
          message: 'Cartão recusado. Verifique os dados.',
          requestId,
        }
      };
    }
    
    // Erro genérico para o usuário, detalhado no log
    return {
      success: false,
      error: {
        code: 'INTERNAL_ERROR',
        message: 'Erro ao processar pagamento. Tente novamente.',
        requestId,
      }
    };
  }
}
```

### Regra 10: Test-First (Integrado)
**Gatilho:** Implementar nova feature ou função de negócio.

**Fluxo Stack Omega:**
1. **Red:** Escrever teste com Vitest/Playwright que define o comportamento
2. **Green:** Implementar código mínimo para o teste passar
3. **Refactor:** Melhorar estrutura mantendo testes verdes

**Cobertura Mínima:**
- Funções de negócio: ≥80%
- Edge cases: null/undefined, arrays vazios, limites numéricos
- Erros: ≥1 teste de exceção por função que pode falhar

**Exemplo (Vitest + Server Action):**
```typescript
// __tests__/lib/actions/create-user.test.ts
import { describe, it, expect, vi, beforeEach } from 'vitest';
import { createUser } from '@/lib/actions/create-user';
import { db } from '@/db';

describe('createUser', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('deve criar usuário com dados válidos', async () => {
    const result = await createUser({
      email: 'teste@example.com',
      name: 'Teste',
      password: 'Senha123!'
    });
    
    expect(result.success).toBe(true);
    expect(result.data?.email).toBe('teste@example.com');
  });

  it('deve falhar com email duplicado', async () => {
    // Mock de usuário existente
    vi.spyOn(db.query.users, 'findFirst').mockResolvedValue({ id: 'existing' } as any);
    
    const result = await createUser({
      email: 'teste@example.com',
      name: 'Teste',
      password: 'Senha123!'
    });
    
    expect(result.success).toBe(false);
    expect(result.error?.code).toBe('EMAIL_EXISTS');
  });
});
```

### Regra 09: Dependency Hygiene (Adaptada)
**Gatilho:** Sugerir `npm install` ou adicionar dependência.

**Critérios Stack Omega:**
- ✅ **Freshness:** Última release < 12 meses
- ✅ **Popularity:** >1k downloads/semana (npm) ou >500 stars (GitHub)
- ✅ **Security:** Zero CVEs críticos/altos (`npm audit`)
- ✅ **Necessidade:** Não adicionar para funções triviais (implemente inline)

**Workflow do Agente:**
```bash
# 1. Verificar vulnerabilidades
npm audit --production --audit-level=high

# 2. Verificar manutenção
npm view nome-do-pacote time.modified  # < 12 meses?
npm view nome-do-pacote downloads.weekly  # > 1000?

# 3. Verificar se é realmente necessário
# - Função trivial? → Implemente inline
# - Já existe no stdlib? → Use stdlib
```

---

## 🔄 OPERAÇÕES & DEVOPS

### Regra 12: Commit Discipline (Reforçada)
**Gatilho:** Gerar mensagens de commit ou preparar release.

**Formato Stack Omega (Conventional Commits):**
```
<type>(<scope>): <description>

[body opcional]

[footer opcional: Closes #123]
```

**Types Permitidos:**
| Type | Quando Usar | Exemplo |
|------|------------|---------|
| `feat` | Nova funcionalidade | `feat(auth): add social login with Google` |
| `fix` | Correção de bug | `fix(billing): correct tax calculation for EU` |
| `refactor` | Mudança sem alterar comportamento | `refactor(db): extract user queries to service` |
| `test` | Adicionar/corrigir testes | `test(auth): add e2e test for login flow` |
| `docs` | Apenas documentação | `docs(api): add examples for webhook endpoints` |
| `chore` | Manutenção, configs, deps | `chore(deps): upgrade next to 14.2.22` |

**Regras Adicionais:**
- Descrição em minúsculo, sem ponto final
- Máximo 72 caracteres na primeira linha
- Body explica "o que" e "por que", não "como"

### Regra 13: Env Isolation (Documentada)
**Gatilho:** Configurar variáveis de ambiente ou connection strings.

**Restrições Stack Omega:**
- ✅ **Obrigatório:** Usar prefixos por ambiente: `NEXT_PUBLIC_` apenas para vars expostas ao client
- ✅ **Obrigatório:** Banco separado por ambiente (Neon branches: `main`, `develop`, `staging`)
- ✅ **Obrigatório:** Feature flags para código não finalizado (não commitar em `main` sem flag)

**Arquivos de Env:**
```bash
# .env.local (desenvolvimento local)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...
DATABASE_URL=postgresql://localhost:5432/myapp_dev

# .env.production (Vercel - NUNCA commitado)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_live_...
CLERK_SECRET_KEY=sk_live_...
DATABASE_URL=postgresql://prod-db.internal/myapp_prod
```

**Validação no Código:**
```typescript
// src/lib/env.ts
export function validateEnvironment() {
  if (process.env.NODE_ENV === 'production') {
    if (process.env.CLERK_SECRET_KEY?.includes('test')) {
      throw new Error('Chave de teste detectada em produção!');
    }
    if (!process.env.DATABASE_URL?.includes('prod')) {
      throw new Error('URL de produção esperada em ambiente prod');
    }
  }
}
```

### Regra 14: Documentation as Code (Consolidada)
**Gatilho:** Criar funções, classes, ou módulos.

**Hierarquia de Clareza Stack Omega:**
1. **Nomes Descritivos:** `calculateMonthlyRevenue` > `calc`, `userEmail` > `ue`
2. **Funções Pequenas:** Uma responsabilidade por função
3. **Docstrings Obrigatórias:** Para funções públicas/exportadas
4. **README Vivo:** Setup, exemplos, arquitetura básica

**Template de Docstring (TSDoc):**
```typescript
/**
 * Calcula o valor total de um pedido após desconto.
 * 
 * @param unitPrice - Preço unitário do produto (deve ser >= 0)
 * @param quantity - Quantidade de itens (deve ser >= 1)
 * @param discountAmount - Valor absoluto do desconto a aplicar
 * @param applyDiscount - Se true, subtrai o desconto do total
 * @returns Valor total do pedido após desconto (se aplicável)
 * @throws {ValidationError} Se unitPrice < 0 ou quantity < 1
 * 
 * @example
 * ```ts
 * calculateOrderTotal(10.00, 3, 5.00, true) // returns 25.00
 * ```
 */
export function calculateOrderTotal(
  unitPrice: number,
  quantity: number,
  discountAmount: number = 0,
  applyDiscount: boolean = true
): number {
  // ...
}
```

**Proibições:**
- ❌ Comentários que repetem o código (`i++ // incrementa i`)
- ❌ Código comentado (use git para histórico)
- ❌ TODOs sem issue/ticket associado

---

## 🚨 CHECKLIST DE AUDITORIA (DELTA)

Antes de aprovar qualquer código gerado por agente, validar:

### Segurança
- [ ] Zero secrets/PII em logs ou bundle
- [ ] Server Actions validam input com Zod
- [ ] Clerk auth aplicado em rotas protegidas
- [ ] RLS habilitado em tabelas sensíveis (se multi-tenant)

### Performance
- [ ] Operações longas delegadas para Inngest
- [ ] Zero código bloqueante em Server Actions
- [ ] Lazy loading aplicado em componentes pesados

### Qualidade
- [ ] Testes escritos antes da implementação (TDD)
- [ ] Cobertura ≥80% para lógica de negócio
- [ ] Error handling com logger estruturado + requestId
- [ ] Docstrings em funções públicas

### Operações
- [ ] Commit segue Conventional Commits
- [ ] Variáveis de ambiente com prefixos corretos
- [ ] Feature flags para código não finalizado
- [ ] README atualizado se mudou arquitetura

---

**Status:** ✅ Ativo | **Integração:** Carregado automaticamente no modo IDX
**Referências:** `[06] SECURITY_DRL/`, `STACK_OMEGA_RULES.md`, `03_tdd_red_green_refactor.md`
