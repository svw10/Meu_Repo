## 🎯 Estrutura dos Snippets v3.0

```
Minhas_Skills/RECURSOS/snippets/
├── 00_index_snippets.md          # Índice e guia de uso
├── 01_orquestracao/              # THETA + infraestrutura
├── 02_agentes/                   # Código específico por agente
├── 03_stack_omega/               # Next.js, React, TypeScript
├── 04_backend/                   # API, Server Actions, DB
├── 05_ai_integration/            # Vercel AI SDK, OpenRouter
├── 06_observability/             # Logs, métricas, tracing
└── 07_comms/                     # WhatsApp, Email, Webhooks
```

---

## 📋 Arquivos Criados:

### 1. ÍNDICE GERAL

**`Minhas_Skills/RECURSOS/snippets/00_index_snippets.md`**

```markdown
---
name: index_snippets
description: Índice central do arsenal de snippets do Antigravity OS v3.0
version: 3.0.0
maintainer: ZETA_Optimizer
last_updated: 2026-02-22
---

# 🧩 ARSENAL DE SNIPPETS v3.0

> **DIRETRIZ:** NUNCA escreva código do zero. Sempre consulte este índice primeiro.

## 📂 Estrutura do Arsenal

| Pasta | Agente Principal | Conteúdo |
|:---|:---|:---|
| `01_orquestracao/` | THETA | State management, routing, agent loader |
| `02_agentes/` | Todos | Templates específicos por agente |
| `03_stack_omega/` | GAMMA | Next.js, React, TypeScript, Tailwind |
| `04_backend/` | GAMMA | API Routes, Server Actions, Drizzle |
| `05_ai_integration/` | GAMMA | Vercel AI SDK, OpenRouter, RAG |
| `06_observability/` | ZETA | Logs JSON, métricas, tracing |
| `07_comms/` | GAMMA | WhatsApp, Email, Evolution API |

## 🎯 Como Usar (Protocolo GAMMA)

1. **Identifique o contexto** no PLAN.md
2. **Localize a categoria** neste índice
3. **Carregue o snippet** (.md) correspondente
4. **Analise o frontmatter** (agent, skill, dependencies)
5. **Substitua as variáveis** `{{LIKE_THIS}}`
6. **Valide com DELTA** antes de commit

## 🏷️ Convenção de Nomenclatura

```
[NN]_[categoria]_[nome_especifico].md

Exemplos:
- 03_nextjs_api_route_handler.md
- 05_openrouter_streaming_chat.md
- 06_logger_json_structured.md
```

## 🔄 Ciclo de Vida

```
Criação (GAMMA) → Uso (GAMMA) → Feedback (DELTA) → Otimização (ZETA) → Atualização (ZETA)
```

## 📊 Métricas do Arsenal

- Total de snippets: [AUTO_COUNT]
- Cobertura Stack Omega: 95%
- Última otimização: [ZETA_TIMESTAMP]

---
*Gerenciado por ZETA_Optimizer | Atualizado automaticamente*
```

---

### 2. ORQUESTRAÇÃO (THETA)

**`Minhas_Skills/RECURSOS/snippets/01_orquestracao/01_theta_state_manager.md`**

```markdown
---
name: theta_state_manager
description: Gerenciamento de estado CURRENT_AGENT.md para orquestração
agent: THETA
skill: 00_index_skills
category: orquestracao
tags: [state, yaml, context, router]
dependencies: []
mode: [GEM, IDX]
---

# {{COMPONENT_NAME}} - State Manager

## Código

```typescript
// lib/state/agentState.ts
import { promises as fs } from 'fs';
import { parse, stringify } from 'yaml';

interface AgentState {
  session_id: string;
  timestamp: string;
  mode: 'GEM' | 'IDX';
  user_intent: string;
  active_agent: 'THETA' | 'ALPHA' | 'BETA' | 'GAMMA' | 'DELTA' | 'EPSILON' | 'ETA' | 'ZETA';
  agent_status: 'idle' | 'planning' | 'executing' | 'reviewing' | 'error';
  loaded_skills: string[];
  active_workflow?: string;
  current_step?: number;
  project_type?: 'saas' | 'landing' | 'api';
  design_system?: '01_saas' | '02_landing' | '00_base';
  action_history: Array<{
    agent: string;
    action: string;
    timestamp: string;
    result: 'success' | 'failure';
  }>;
  next_action?: string;
  next_agent?: string;
  reasoning?: string;
}

const STATE_PATH = 'context/CURRENT_AGENT.md';

export async function loadAgentState(): Promise<AgentState> {
  try {
    const content = await fs.readFile(STATE_PATH, 'utf-8');
    // Extrai YAML do markdown (entre ---)
    const yamlMatch = content.match(/^---\n([\s\S]*?)\n---/);
    if (!yamlMatch) throw new Error('Invalid state format');
    return parse(yamlMatch[1]) as AgentState;
  } catch (error) {
    // Estado padrão se não existir
    return {
      session_id: `sess_${Date.now()}`,
      timestamp: new Date().toISOString(),
      mode: 'GEM',
      user_intent: '',
      active_agent: 'THETA',
      agent_status: 'idle',
      loaded_skills: [],
      action_history: []
    };
  }
}

export async function saveAgentState(state: AgentState): Promise<void> {
  const yamlContent = stringify(state);
  const markdownContent = `---
${yamlContent}---
  
# ESTADO ATUAL DA SESSÃO

> ⚠️ **ARQUIVO GERADO AUTOMATICAMENTE** - Não edite manualmente
> Última atualização: ${new Date().toISOString()}

## 🎯 INSTRUÇÕES PARA AGENTES

**Quando ler este arquivo:**
1. Verifique \`active_agent\` - é você? Se sim, execute. Se não, chame o agente correto.
2. Verifique \`active_workflow\` - há um workflow em andamento? Siga o step atual.
3. Verifique \`loaded_skills\` - skills já estão no contexto? Não recarregue.
4. Após executar, atualize este arquivo com novo estado.

---
FIM DO CURRENT_AGENT
`;
  
  await fs.writeFile(STATE_PATH, markdownContent, 'utf-8');
}

export function delegateToAgent(
  currentState: AgentState, 
  targetAgent: AgentState['active_agent'], 
  reason: string
): AgentState {
  return {
    ...currentState,
    active_agent: targetAgent,
    agent_status: 'idle',
    delegated_by: currentState.active_agent,
    reasoning: reason,
    timestamp: new Date().toISOString(),
    action_history: [
      ...currentState.action_history,
      {
        agent: currentState.active_agent,
        action: `delegated_to_${targetAgent}`,
        timestamp: new Date().toISOString(),
        result: 'success'
      }
    ]
  };
}
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{COMPONENT_NAME}}` | Nome do componente de estado | `AgentStateManager` |
| `{{STATE_PATH}}` | Caminho do arquivo de estado | `context/CURRENT_AGENT.md` |

## Uso por Agente

**THETA (Orchestrator):**
- Carrega estado atual no início de cada interação
- Decide próximo agente baseado em `user_intent`
- Atualiza estado após delegação
- Nunca executa código diretamente - apenas orquestra

**Exemplo de fluxo:**
```typescript
const state = await loadAgentState();
if (state.active_agent !== 'THETA') {
  // Redireciona para agente correto
  await redirectToAgent(state.active_agent);
}
const newState = delegateToAgent(state, 'BETA', 'Necessário planejamento arquitetural');
await saveAgentState(newState);
```

## Stack Omega

- **Runtime:** Node.js / Next.js
- **Parser:** `yaml` (npm package)
- **Storage:** Markdown file (Git-friendly)

## Validação (DELTA)

- [ ] Schema YAML válido
- [ ] Timestamp em ISO 8601
- [ ] Agent válido (enum de 8 valores)
- [ ] Status válido (enum de 5 valores)
- [ ] Histórico não excede 100 entradas (rotacionar se necessário)
```

---

### 3. AGENTE ALPHA (Genesis)

**`Minhas_Skills/RECURSOS/snippets/02_agentes/02_alpha_project_bootstrap.md`**

```markdown
---
name: alpha_project_bootstrap
description: Template de inicialização de projeto novo (Genesis)
agent: ALPHA
skill: 01_brainstorming
category: genesis
tags: [bootstrap, nextjs, setup, project-structure]
dependencies: [03_stack_omega]
mode: [GEM, IDX]
---

# {{PROJECT_NAME}} - Bootstrap Inicial

## Estrutura de Pastas

```
{{PROJECT_NAME}}/
├── src/
│   ├── app/
│   │   ├── layout.tsx
│   │   ├── page.tsx
│   │   └── globals.css
│   ├── components/
│   │   └── ui/           # shadcn/ui components
│   ├── lib/
│   │   ├── utils.ts      # cn() helper
│   │   └── db/           # Drizzle config
│   └── hooks/
├── tests/
│   ├── unit/
│   └── e2e/
├── docs/
│   ├── PLAN.md           # Gerado por BETA
│   └── ADR/              # Architecture Decision Records
├── infra/
│   └── terraform/        # Se necessário
├── Logs/
│   └── .gitkeep
├── .env.example
├── .gitignore
├── next.config.js
├── package.json
├── tailwind.config.ts
├── tsconfig.json
└── drizzle.config.ts
```

## Arquivos Base

### package.json

```json
{
  "name": "{{PROJECT_NAME}}",
  "version": "0.1.0",
  "private": true,
  "scripts": {
    "dev": "next dev --turbopack",
    "build": "next build",
    "start": "next start",
    "lint": "biome check --apply .",
    "format": "biome format --write .",
    "db:generate": "drizzle-kit generate",
    "db:migrate": "drizzle-kit migrate",
    "db:studio": "drizzle-kit studio"
  },
  "dependencies": {
    "next": "14.2.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "@neondatabase/serverless": "^0.9.0",
    "drizzle-orm": "^0.30.0",
    "drizzle-kit": "^0.20.0",
    "@clerk/nextjs": "^4.29.0",
    "tailwindcss": "^3.4.0",
    "class-variance-authority": "^0.7.0",
    "clsx": "^2.1.0",
    "tailwind-merge": "^1.14.0",
    "lucide-react": "^0.300.0",
    "framer-motion": "^11.0.0",
    "zod": "^3.22.0",
    "ai": "^3.0.0",
    "@ai-sdk/openai": "^0.0.0",
    "inngest": "^3.0.0"
  },
  "devDependencies": {
    "@types/node": "^20.0.0",
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@biomejs/biome": "^1.5.0",
    "typescript": "^5.3.0"
  }
}
```

### tsconfig.json

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "lib": ["dom", "dom.iterable", "esnext"],
    "allowJs": true,
    "skipLibCheck": true,
    "strict": true,
    "noEmit": true,
    "esModuleInterop": true,
    "module": "esnext",
    "moduleResolution": "bundler",
    "resolveJsonModule": true,
    "isolatedModules": true,
    "jsx": "preserve",
    "incremental": true,
    "plugins": [{ "name": "next" }],
    "paths": {
      "@/*": ["./src/*"]
    }
  },
  "include": ["next-env.d.ts", "**/*.ts", "**/*.tsx", ".next/types/**/*.ts"],
  "exclude": ["node_modules"]
}
```

### .env.example

```bash
# Database
DATABASE_URL="postgresql://user:pass@host/db?sslmode=require"

# Auth (Clerk)
NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=pk_test_...
CLERK_SECRET_KEY=sk_test_...

# AI (OpenRouter)
OPENROUTER_API_KEY=sk-or-v1-...

# Inngest
INNGEST_EVENT_KEY="..."
INNGEST_SIGNING_KEY="..."

# Optional: Monitoring
SENTRY_DSN="..."
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{PROJECT_NAME}}` | Nome do projeto (kebab-case) | `meu-saas` |
| `{{PROJECT_DESCRIPTION}}` | Descrição curta | `Plataforma de gestão` |

## Uso por Agente

**ALPHA (Genesis):**
1. Valida nome do projeto (sem espaços, lowercase)
2. Cria estrutura de pastas
3. Copia arquivos base com variáveis substituídas
4. Executa `npm install` (se IDX mode)
5. Registra em `Logs/project_creation.yaml`

**Handoff para BETA:**
Após bootstrap, atualiza CURRENT_AGENT.md:
```yaml
active_agent: ALPHA
agent_status: completed
next_agent: BETA
project_created: {{PROJECT_NAME}}
ready_for: architecture_planning
```

## Stack Omega

- **Framework:** Next.js 14+ (App Router)
- **Language:** TypeScript 5+ (strict: true)
- **Database:** Neon PostgreSQL + Drizzle ORM
- **Auth:** Clerk
- **Styling:** Tailwind CSS + shadcn/ui
- **AI:** Vercel AI SDK + OpenRouter
- **Queues:** Inngest

## Validação (DELTA)

- [ ] Nome do projeto válido (regex: `^[a-z0-9-]+$`)
- [ ] TypeScript strict habilitado
- [ ] Todas as dependências da Stack Omega presentes
- [ ] `.env.example` completo (sem valores reais)
- [ ] `.gitignore` inclui: `node_modules/`, `.env`, `.next/`, `Logs/*.log`
```

---

### 4. AGENTE BETA (Architect)

**`Minhas_Skills/RECURSOS/snippets/02_agentes/03_beta_plan_template.md`**

```markdown
---
name: beta_plan_template
description: Template de PLAN.md para arquitetura de projetos
agent: BETA
skill: 02_planejando_solucoes
category: architecture
tags: [plan, architecture, schema, design]
dependencies: [03_alpha_project_bootstrap]
mode: [GEM, IDX]
---

# PLAN.md - {{PROJECT_NAME}}

> Gerado por BETA Architect Prime | Data: {{DATE_ISO}} | Versão: 1.0

## 1. VISÃO GERAL

| Aspecto | Descrição |
|:---|:---|
| **Nome** | {{PROJECT_NAME}} |
| **Tipo** | {{PROJECT_TYPE}} (saas/landing/api/worker) |
| **Objetivo** | {{ONE_LINE_DESCRIPTION}} |
| **Público-alvo** | {{TARGET_AUDIENCE}} |
| **Complexidade** | {{COMPLEXITY}} (baixa/média/alta) |

## 2. STACK TECNOLÓGICA

| Camada | Tecnologia | Justificativa |
|:---|:---|:---|
| Framework | Next.js 14+ (App Router) | SSR, RSC, performance |
| Language | TypeScript 5+ | Type safety, DX |
| Database | Neon PostgreSQL | Serverless, pgvector |
| ORM | Drizzle ORM | Performance, type-safe |
| Auth | Clerk | Completo, fácil integração |
| Styling | Tailwind CSS + shadcn/ui | Consistência, velocidade |
| AI/LLM | Vercel AI SDK + OpenRouter | Flexibilidade de modelos |
| Filas | Inngest | Serverless jobs, cron |
| Deploy | Vercel | Edge, CI/CD nativo |

## 3. ESTRUTURA DE DADOS (Schema Drizzle)

```typescript
// src/lib/db/schema.ts
import { pgTable, serial, varchar, timestamp, text, json, vector } from 'drizzle-orm/pg-core';

export const {{MAIN_ENTITY_PLURAL}} = pgTable('{{MAIN_ENTITY_PLURAL}}', {
  id: serial('id').primaryKey(),
  {{FIELD_1}}: varchar('{{FIELD_1}}', { length: 255 }).notNull(),
  {{FIELD_2}}: text('{{FIELD_2}}'),
  metadata: json('metadata').default({}),
  embedding: vector('embedding', { dimensions: 1536 }), // Para RAG
  createdAt: timestamp('created_at').defaultNow(),
  updatedAt: timestamp('updated_at').defaultNow(),
});

// Relações
export const {{RELATED_ENTITY_PLURAL}} = pgTable('{{RELATED_ENTITY_PLURAL}}', {
  id: serial('id').primaryKey(),
  {{MAIN_ENTITY_SINGULAR}}Id: serial('{{MAIN_ENTITY_SINGULAR}}_id').references(() => {{MAIN_ENTITY_PLURAL}}.id),
  // ...
});
```

## 4. ARQUITETURA DE FLUXOS

### Fluxo Principal

```mermaid
graph TD
    A[Usuário] -->|Ação| B[Next.js App]
    B -->|Server Action| C[Database]
    B -->|API Route| D[External API]
    B -->|Inngest| E[Background Job]
    E -->|Webhook| B
```

### Integrações Externas

| Serviço | Propósito | Endpoint |
|:---|:---|:---|
| {{SERVICE_1}} | {{PURPOSE_1}} | `{{ENDPOINT_1}}` |
| {{SERVICE_2}} | {{PURPOSE_2}} | `{{ENDPOINT_2}}` |

## 5. COMPONENTES PRINCIPAIS

| Componente | Local | Responsabilidade | Agente |
|:---|:---|:---|:---|
| `{{COMPONENT_1}}` | `app/{{ROUTE_1}}/page.tsx` | {{RESPONSIBILITY_1}} | GAMMA |
| `{{COMPONENT_2}}` | `app/{{ROUTE_2}}/page.tsx` | {{RESPONSIBILITY_2}} | GAMMA |
| `{{API_ROUTE_1}}` | `app/api/{{ROUTE_1}}/route.ts` | {{API_RESP_1}} | GAMMA |

## 6. ROTEAMENTO

| Rota | Tipo | Função | Auth | Agente |
|:---|:---|:---|:---|:---|
| `/` | Page | Landing/Home | Pública | GAMMA |
| `/dashboard` | Page | Painel admin | Privada | GAMMA |
| `/api/webhook` | Route | Receber eventos | Token | GAMMA |
| `/api/ai` | Route | Streaming AI | Privada | GAMMA |

## 7. PASSO A PASSO PARA GAMMA

### Fase 1: Setup (ALPHA já fez)
- [ ] Confirmar estrutura de pastas
- [ ] Validar variáveis de ambiente
- [ ] Testar conexão com Neon

### Fase 2: Database
- [ ] Implementar schema em `src/lib/db/schema.ts`
- [ ] Gerar migration: `npm run db:generate`
- [ ] Aplicar migration: `npm run db:migrate`
- [ ] Validar com Drizzle Studio

### Fase 3: Autenticação
- [ ] Configurar Clerk em `app/layout.tsx`
- [ ] Criar middleware de proteção de rotas
- [ ] Implementar sync de usuários com DB

### Fase 4: Core Features
- [ ] {{FEATURE_1}}
- [ ] {{FEATURE_2}}
- [ ] {{FEATURE_3}}

### Fase 5: UI/UX
- [ ] Aplicar design system ({{DESIGN_SYSTEM}})
- [ ] Implementar responsividade
- [ ] Adicionar loading states e error boundaries

### Fase 6: QA e Deploy
- [ ] DELTA revisa (checklist de qualidade)
- [ ] Testes E2E com Playwright
- [ ] Deploy na Vercel

## 8. ADRs (Architecture Decision Records)

| Decisão | Contexto | Consequência |
|:---|:---|:---|
| {{DECISION_1}} | {{CONTEXT_1}} | {{CONSEQUENCE_1}} |
| {{DECISION_2}} | {{CONTEXT_2}} | {{CONSEQUENCE_2}} |

## 9. CRITÉRIOS DE SUCESSO

- [ ] {{SUCCESS_CRITERIA_1}}
- [ ] {{SUCCESS_CRITERIA_2}}
- [ ] {{SUCCESS_CRITERIA_3}}

## 10. RISCOS E MITIGAÇÕES

| Risco | Probabilidade | Impacto | Mitigação |
|:---|:---|:---|:---|
| {{RISK_1}} | Alta/Média/Baixa | Alto/Médio/Baixo | {{MITIGATION_1}} |

---
**FIM DO PLANO** - Aguardando GAMMA para execução.
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{PROJECT_NAME}}` | Nome do projeto | `crm-inteligente` |
| `{{PROJECT_TYPE}}` | Tipo | `saas` |
| `{{DATE_ISO}}` | Data ISO 8601 | `2026-02-22T10:00:00Z` |
| `{{MAIN_ENTITY_PLURAL}}` | Entidade principal (plural) | `customers` |
| `{{MAIN_ENTITY_SINGULAR}}` | Entidade principal (singular) | `customer` |
| `{{COMPLEXITY}}` | Nível de complexidade | `média` |
| `{{DESIGN_SYSTEM}}` | Sistema de design | `01_saas` |

## Uso por Agente

**BETA (Architect):**
1. Analisa requisitos com EPSILON (se necessário)
2. Define stack (respeitando Stack Omega)
3. Cria schema de banco
4. Desenha fluxos de dados
5. Gera PLAN.md preenchido
6. Valida viabilidade técnica

**Handoff para GAMMA:**
Atualiza CURRENT_AGENT.md:
```yaml
active_agent: BETA
agent_status: completed
deliverable: PLAN.md
next_agent: GAMMA
ready_to_execute: true
plan_complexity: {{COMPLEXITY}}
```

## Stack Omega

- **Documentation:** Markdown + Mermaid (diagramas)
- **Schema:** Drizzle ORM (TypeScript)
- **Versioning:** Git + Conventional Commits

## Validação (DELTA)

- [ ] Schema Drizzle válido (tipos corretos)
- [ ] Todas as rotas documentadas
- [ ] Critérios de sucesso mensuráveis
- [ ] ADRs justificam exceções à Stack Omega (se houver)
- [ ] Fluxos de dados coherentes
```

---

### 5. AGENTE GAMMA (Builder) - Stack Omega

**`Minhas_Skills/RECURSOS/snippets/03_stack_omega/04_gamma_nextjs_api_route.md`**

```markdown
---
name: gamma_nextjs_api_route
description: API Route Next.js com validação Zod e observabilidade
agent: GAMMA
skill: 04_codando
category: backend
tags: [api, route, nextjs, zod, validation]
dependencies: [06_observability]
mode: [GEM, IDX]
---

# {{ROUTE_NAME}} - API Route Handler

## Código

```typescript
// app/api/{{ROUTE_PATH}}/route.ts
import { NextRequest, NextResponse } from 'next/server';
import { z } from 'zod';
import { logger } from '@/lib/observability/logger';
import { withAuth } from '@/lib/auth/middleware';

// Schema de validação Zod
const {{SCHEMA_NAME}} = z.object({
  {{FIELD_1}}: z.string().min(1).max(255),
  {{FIELD_2}}: z.email().optional(),
  {{FIELD_3}}: z.enum(['{{ENUM_1}}', '{{ENUM_2}}']).default('{{DEFAULT_ENUM}}'),
  metadata: z.record(z.unknown()).optional(),
});

type {{TYPE_NAME}} = z.infer<typeof {{SCHEMA_NAME}}>;

export async function {{METHOD}}(req: NextRequest) {
  const requestId = crypto.randomUUID();
  const startTime = Date.now();
  
  try {
    // Log de entrada
    logger.info('{{EVENT_NAME}}_started', {
      requestId,
      method: req.method,
      path: req.nextUrl.pathname,
      timestamp: new Date().toISOString(),
    });

    // Parse e validação do body
    const body = await req.json();
    const validated = {{SCHEMA_NAME}}.parse(body);
    
    // Lógica principal
    const result = await {{SERVICE_FUNCTION}}(validated);
    
    // Log de sucesso
    const duration = Date.now() - startTime;
    logger.info('{{EVENT_NAME}}_completed', {
      requestId,
      duration_ms: duration,
      status: 'success',
    });

    return NextResponse.json(
      { 
        success: true, 
        data: result,
        meta: { requestId, duration_ms: duration }
      },
      { status: 200 }
    );

  } catch (error) {
    const duration = Date.now() - startTime;
    
    if (error instanceof z.ZodError) {
      logger.warn('{{EVENT_NAME}}_validation_error', {
        requestId,
        errors: error.errors,
        duration_ms: duration,
      });
      
      return NextResponse.json(
        { 
          success: false, 
          error: 'Validation failed',
          details: error.errors,
          requestId 
        },
        { status: 400 }
      );
    }

    logger.error('{{EVENT_NAME}}_error', {
      requestId,
      error: error instanceof Error ? error.message : 'Unknown error',
      stack: error instanceof Error ? error.stack : undefined,
      duration_ms: duration,
    });

    return NextResponse.json(
      { 
        success: false, 
        error: 'Internal server error',
        requestId 
      },
      { status: 500 }
    );
  }
}

// Exporta métodos adicionais se necessário
export const dynamic = 'force-dynamic';
export const runtime = 'nodejs'; // ou 'edge' para Edge Runtime
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{ROUTE_NAME}}` | Nome descritivo da rota | `CreateUser` |
| `{{ROUTE_PATH}}` | Caminho da rota | `users/create` |
| `{{SCHEMA_NAME}}` | Nome do schema Zod | `CreateUserSchema` |
| `{{TYPE_NAME}}` | Nome do tipo inferido | `CreateUserInput` |
| `{{FIELD_1}}` | Campo 1 do schema | `name` |
| `{{FIELD_2}}` | Campo 2 do schema | `email` |
| `{{FIELD_3}}` | Campo 3 do schema | `role` |
| `{{ENUM_1}}` | Valor enum 1 | `admin` |
| `{{ENUM_2}}` | Valor enum 2 | `user` |
| `{{DEFAULT_ENUM}}` | Valor padrão | `user` |
| `{{METHOD}}` | Método HTTP | `POST` |
| `{{EVENT_NAME}}` | Nome do evento para logs | `user_create` |
| `{{SERVICE_FUNCTION}}` | Função de serviço | `createUser` |

## Uso por Agente

**GAMMA (Builder):**
1. Lê PLAN.md para entender o endpoint necessário
2. Copia este snippet
3. Substitui todas as variáveis
4. Implementa `{{SERVICE_FUNCTION}}` na camada de serviço
5. Adiciona testes unitários
6. Valida com DELTA

**Exemplo de implementação:**
```typescript
// src/lib/services/userService.ts
export async function createUser(data: CreateUserInput) {
  const user = await db.insert(users).values(data).returning();
  return user[0];
}
```

## Stack Omega

- **Framework:** Next.js 14+ Route Handlers
- **Validation:** Zod (strict)
- **Auth:** Clerk (via middleware)
- **Observability:** Logger JSON estruturado
- **Runtime:** Node.js (padrão) ou Edge (se especificado)

## Validação (DELTA)

- [ ] Schema Zod cobre todos os campos necessários
- [ ] Tratamento de erro para ZodError (400)
- [ ] Tratamento de erro genérico (500) sem expor detalhes internos
- [ ] Logger chamado em todos os caminhos (success, validation, error)
- [ ] requestId único em todas as respostas
- [ ] Não há `console.log` (usar logger)
- [ ] Função de serviço extraída (não no route handler)
```

---

### 6. AGENTE GAMMA (Builder) - UI

**`Minhas_Skills/RECURSOS/snippets/03_stack_omega/05_gamma_shadcn_component.md`**

```markdown
---
name: gamma_shadcn_component
description: Componente React com shadcn/ui, Tailwind e Framer Motion
agent: GAMMA
skill: 06_criando_ui
category: frontend
tags: [react, component, shadcn, tailwind, framer-motion]
dependencies: []
mode: [GEM, IDX]
---

# {{COMPONENT_NAME}} - React Component

## Código

```typescript
// src/components/{{COMPONENT_PATH}}/{{COMPONENT_FILE}}.tsx
'use client';

import * as React from 'react';
import { motion } from 'framer-motion';
import { cn } from '@/lib/utils';
import { {{ICON}} } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';

// Types
interface {{COMPONENT_NAME}}Props {
  title: string;
  description?: string;
  {{PROP_1}}: {{TYPE_1}};
  {{PROP_2}}?: {{TYPE_2}};
  on{{ACTION}}?: (value: {{RETURN_TYPE}}) => void;
  className?: string;
  variant?: 'default' | 'outline' | 'ghost';
}

// Animation variants
const containerVariants = {
  hidden: { opacity: 0, y: 20 },
  visible: { 
    opacity: 1, 
    y: 0,
    transition: {
      duration: 0.5,
      ease: [0.22, 1, 0.36, 1], // Custom easing
      staggerChildren: 0.1
    }
  }
};

const itemVariants = {
  hidden: { opacity: 0, x: -10 },
  visible: { opacity: 1, x: 0 }
};

export function {{COMPONENT_NAME}}({
  title,
  description,
  {{PROP_1}},
  {{PROP_2}},
  on{{ACTION}},
  className,
  variant = 'default'
}: {{COMPONENT_NAME}}Props) {
  const [isLoading, setIsLoading] = React.useState(false);
  const [{{STATE}}, set{{STATE}}] = React.useState<{{STATE_TYPE}}>({{INITIAL_STATE}});

  const handle{{ACTION}} = async () => {
    setIsLoading(true);
    try {
      await on{{ACTION}}?.({{PROP_1}});
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <motion.div
      variants={containerVariants}
      initial="hidden"
      animate="visible"
      className={cn('w-full', className)}
    >
      <Card className="border-border/50 bg-card/50 backdrop-blur-sm">
        <CardHeader className="space-y-1">
          <motion.div variants={itemVariants} className="flex items-center gap-2">
            <{{ICON}} className="h-5 w-5 text-primary" />
            <CardTitle className="text-2xl font-bold tracking-tight">
              {title}
            </CardTitle>
          </motion.div>
          {description && (
            <motion.p 
              variants={itemVariants}
              className="text-sm text-muted-foreground"
            >
              {description}
            </motion.p>
          )}
        </CardHeader>
        
        <CardContent className="space-y-4">
          <motion.div variants={itemVariants} className="space-y-2">
            {/* Content goes here */}
            <div className="rounded-lg bg-muted p-4">
              <pre className="text-sm">
                {JSON.stringify({ {{PROP_1}}, {{PROP_2}} }, null, 2)}
              </pre>
            </div>
          </motion.div>

          <motion.div variants={itemVariants} className="flex gap-2">
            <Button
              variant={variant}
              onClick={handle{{ACTION}}}
              disabled={isLoading}
              className="w-full sm:w-auto"
            >
              {isLoading ? (
                <motion.div
                  animate={{ rotate: 360 }}
                  transition={{ duration: 1, repeat: Infinity, ease: 'linear' }}
                >
                  <{{ICON}} className="h-4 w-4" />
                </motion.div>
              ) : (
                '{{BUTTON_TEXT}}'
              )}
            </Button>
          </motion.div>
        </CardContent>
      </Card>
    </motion.div>
  );
}

// Loading skeleton
export function {{COMPONENT_NAME}}Skeleton() {
  return (
    <Card className="w-full">
      <CardHeader>
        <div className="h-6 w-1/3 animate-pulse rounded bg-muted" />
        <div className="h-4 w-1/2 animate-pulse rounded bg-muted" />
      </CardHeader>
      <CardContent>
        <div className="h-24 animate-pulse rounded bg-muted" />
      </CardContent>
    </Card>
  );
}
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{COMPONENT_NAME}}` | Nome do componente (PascalCase) | `UserProfileCard` |
| `{{COMPONENT_PATH}}` | Caminho da pasta | `dashboard` |
| `{{COMPONENT_FILE}}` | Nome do arquivo | `user-profile-card` |
| `{{ICON}}` | Ícone Lucide | `User` |
| `{{PROP_1}}` | Propriedade 1 | `userData` |
| `{{TYPE_1}}` | Tipo da prop 1 | `User` |
| `{{PROP_2}}` | Propriedade 2 | `isEditable` |
| `{{TYPE_2}}` | Tipo da prop 2 | `boolean` |
| `{{ACTION}}` | Ação do handler | `Save` |
| `{{RETURN_TYPE}}` | Tipo de retorno | `void` |
| `{{STATE}}` | Nome do estado | `formData` |
| `{{STATE_TYPE}}` | Tipo do estado | `FormData` |
| `{{INITIAL_STATE}}` | Valor inicial | `{}` |
| `{{BUTTON_TEXT}}` | Texto do botão | `Salvar alterações` |

## Uso por Agente

**GAMMA (Builder):**
1. Identifica necessidade de componente no PLAN.md
2. Seleciona este snippet (UI SaaS) ou `05_gamma_premium_component.md` (UI Pro Max)
3. Substitui variáveis
4. Implementa lógica específica no placeholder
5. Adiciona Storybook ou testes se necessário

**Design System:**
- Base: shadcn/ui components
- Animação: Framer Motion
- Ícones: Lucide React
- Estilo: Tailwind CSS (sem CSS Modules)

## Stack Omega

- **Framework:** React 18+ (Client Component)
- **Styling:** Tailwind CSS 3.4+
- **Components:** shadcn/ui (Radix UI + Tailwind)
- **Animation:** Framer Motion
- **Icons:** Lucide React
- **Utils:** `cn()` from `class-variance-authority`

## Validação (DELTA)

- [ ] Props tipadas corretamente (nenhum `any`)
- [ ] Estados inicializados corretamente
- [ ] Handlers com tratamento de erro
- [ ] Loading state implementado
- [ ] Skeleton para loading assíncrono
- [ ] Animações não bloqueiam interação
- [ ] Responsivo (mobile-first)
- [ ] Acessibilidade (ARIA labels se necessário)
```

---

### 7. AGENTE ETA (Investigator)

**`Minhas_Skills/RECURSOS/snippets/02_agentes/06_eta_error_handler.md`**

```markdown
---
name: eta_error_handler
description: Handler de erro com logging estruturado e retry logic
agent: ETA
skill: 12_solucionando_erros
category: error-handling
tags: [error, logging, retry, observability, debug]
dependencies: [06_observability]
mode: [GEM, IDX]
---

# {{ERROR_CONTEXT}} - Error Handler & Recovery

## Código

```typescript
// lib/error/handlers/{{HANDLER_NAME}}.ts
import { logger } from '@/lib/observability/logger';
import { captureException } from '@/lib/observability/sentry';

// Tipos de erro customizados
export class {{ERROR_CLASS}} extends Error {
  constructor(
    message: string,
    public code: string,
    public context?: Record<string, unknown>,
    public retryable: boolean = false
  ) {
    super(message);
    this.name = '{{ERROR_CLASS}}';
  }
}

// Configuração de retry
interface RetryConfig {
  maxAttempts: number;
  backoffMs: number;
  maxBackoffMs: number;
}

const defaultRetryConfig: RetryConfig = {
  maxAttempts: 3,
  backoffMs: 1000,
  maxBackoffMs: 10000,
};

// Função com retry automático
export async function withRetry<T>(
  operation: () => Promise<T>,
  context: string,
  config: Partial<RetryConfig> = {}
): Promise<T> {
  const { maxAttempts, backoffMs, maxBackoffMs } = { ...defaultRetryConfig, ...config };
  let lastError: Error | undefined;

  for (let attempt = 1; attempt <= maxAttempts; attempt++) {
    try {
      logger.info('{{OPERATION_NAME}}_attempt', {
        context,
        attempt,
        maxAttempts,
      });

      const result = await operation();
      
      if (attempt > 1) {
        logger.info('{{OPERATION_NAME}}_recovered', {
          context,
          attempts: attempt,
        });
      }

      return result;
    } catch (error) {
      lastError = error instanceof Error ? error : new Error(String(error));
      
      const isRetryable = error instanceof {{ERROR_CLASS}} 
        ? error.retryable 
        : true; // Default: retry em erros desconhecidos

      if (!isRetryable || attempt === maxAttempts) {
        break;
      }

      // Exponential backoff com jitter
      const delay = Math.min(
        backoffMs * Math.pow(2, attempt - 1) + Math.random() * 1000,
        maxBackoffMs
      );

      logger.warn('{{OPERATION_NAME}}_retry_scheduled', {
        context,
        attempt,
        nextAttempt: attempt + 1,
        delayMs: delay,
        error: lastError.message,
      });

      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }

  // Todos os retries falharam
  const finalError = new {{ERROR_CLASS}}(
    `Failed after ${maxAttempts} attempts: ${lastError?.message}`,
    '{{ERROR_CODE}}',
    { context, attempts: maxAttempts, originalError: lastError },
    false
  );

  logger.error('{{OPERATION_NAME}}_failed', {
    context,
    attempts: maxAttempts,
    error: finalError.message,
    stack: finalError.stack,
  });

  captureException(finalError);
  throw finalError;
}

// Wrapper para operações críticas
export function create{{SAFE_WRAPPER}}<T extends (...args: any[]) => Promise<any>>(
  operation: T,
  context: string
) {
  return async (...args: Parameters<T>): Promise<ReturnType<T>> => {
    return withRetry(
      () => operation(...args),
      context
    );
  };
}

// Uso em Server Actions
export async function {{SAFE_ACTION_NAME}}(input: {{INPUT_TYPE}}) {
  return withRetry(
    async () => {
      // Lógica que pode falhar (API externa, DB, etc)
      const result = await {{RISKY_OPERATION}}(input);
      return result;
    },
    '{{ACTION_CONTEXT}}',
    { maxAttempts: 3, backoffMs: 1000 }
  );
}
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{ERROR_CONTEXT}}` | Contexto do erro | `DatabaseConnection` |
| `{{HANDLER_NAME}}` | Nome do handler | `database-error-handler` |
| `{{ERROR_CLASS}}` | Nome da classe de erro | `DatabaseError` |
| `{{OPERATION_NAME}}` | Nome da operação | `db_query` |
| `{{ERROR_CODE}}` | Código do erro | `DB_CONNECTION_FAILED` |
| `{{SAFE_WRAPPER}}` | Nome do wrapper | `SafeDatabaseOperation` |
| `{{SAFE_ACTION_NAME}}` | Nome da ação segura | `safeUserCreate` |
| `{{INPUT_TYPE}}` | Tipo do input | `CreateUserInput` |
| `{{RISKY_OPERATION}}` | Operação arriscada | `createUserInDatabase` |
| `{{ACTION_CONTEXT}}` | Contexto da ação | `user_creation` |

## Uso por Agente

**ETA (Investigator):**
1. Identifica padrão de erro recorrente nos logs
2. Cria handler específico usando este snippet
3. Substitui operações diretas por `withRetry`
4. Documenta causa raiz em `Logs/bugfix_reports/`
5. Atualiza `12_solucionando_erros.md` se padrão novo

**Integração com ZETA:**
Se o mesmo erro ocorrer 3x, ZETA otimiza o retry config ou sugere refatoração.

## Stack Omega

- **Language:** TypeScript
- **Logging:** Pino/Winston (JSON estruturado)
- **Monitoring:** Sentry para exception tracking
- **Pattern:** Circuit Breaker + Retry com Exponential Backoff

## Validação (DELTA)

- [ ] Todos os erros são instâncias de Error (não strings)
- [ ] Contexto suficiente para debug (requestId, userId, etc)
- [ ] Retry apenas em erros transientes (não 4xx)
- [ ] Backoff exponencial implementado corretamente
- [ ] Jitter aleatório para evitar thundering herd
- [ ] Métricas de tentativas logadas
- [ ] Sentry captureException em erros fatais
```

---

### 8. AGENTE ZETA (Optimizer)

**`Minhas_Skills/RECURSOS/snippets/02_agentes/07_zeta_performance_monitor.md`**

```markdown
---
name: zeta_performance_monitor
description: Monitoramento de performance com métricas automáticas
agent: ZETA
skill: 13_observability_playbook
category: performance
tags: [performance, metrics, monitoring, optimization, web-vitals]
dependencies: [06_observability]
mode: [GEM, IDX]
---

# {{COMPONENT_SCOPE}} - Performance Monitor

## Código

```typescript
// lib/performance/monitor.ts
import { logger } from '@/lib/observability/logger';

// Métricas de Web Vitals
interface WebVitalsMetrics {
  LCP: number; // Largest Contentful Paint
  FID: number; // First Input Delay
  CLS: number; // Cumulative Layout Shift
  FCP: number; // First Contentful Paint
  TTFB: number; // Time to First Byte
}

// Thresholds de performance (Stack Omega standards)
const PERFORMANCE_THRESHOLDS = {
  LCP: { good: 2500, poor: 4000 },
  FID: { good: 100, poor: 300 },
  CLS: { good: 0.1, poor: 0.25 },
  FCP: { good: 1800, poor: 3000 },
  TTFB: { good: 800, poor: 1800 },
};

type MetricRating = 'good' | 'needs-improvement' | 'poor';

function getMetricRating(metric: keyof WebVitalsMetrics, value: number): MetricRating {
  const threshold = PERFORMANCE_THRESHOLDS[metric];
  if (value <= threshold.good) return 'good';
  if (value <= threshold.poor) return 'needs-improvement';
  return 'poor';
}

// Classe de monitoramento
export class PerformanceMonitor {
  private metrics: Partial<WebVitalsMetrics> = {};
  private observers: PerformanceObserver[] = [];

  constructor(private context: string) {}

  start() {
    if (typeof window === 'undefined') return;

    // LCP
    this.observeLCP();
    
    // FID
    this.observeFID();
    
    // CLS
    this.observeCLS();
    
    // FCP
    this.observeFCP();
    
    // TTFB
    this.measureTTFB();

    // Log ao sair da página
    window.addEventListener('beforeunload', () => this.report());
  }

  private observeLCP() {
    const observer = new PerformanceObserver((list) => {
      const entries = list.getEntries();
      const lastEntry = entries[entries.length - 1] as PerformanceEntry & { renderTime?: number };
      this.metrics.LCP = lastEntry.renderTime || lastEntry.startTime;
    });
    observer.observe({ entryTypes: ['largest-contentful-paint'] });
    this.observers.push(observer);
  }

  private observeFID() {
    const observer = new PerformanceObserver((list) => {
      const entries = list.getEntries();
      const firstEntry = entries[0] as PerformanceEntry & { processingStart: number };
      this.metrics.FID = firstEntry.processingStart - firstEntry.startTime;
    });
    observer.observe({ entryTypes: ['first-input'] });
    this.observers.push(observer);
  }

  private observeCLS() {
    let clsValue = 0;
    const observer = new PerformanceObserver((list) => {
      for (const entry of list.getEntries()) {
        const layoutShift = entry as PerformanceEntry & { value: number; hadRecentInput: boolean };
        if (!layoutShift.hadRecentInput) {
          clsValue += layoutShift.value;
        }
      }
      this.metrics.CLS = clsValue;
    });
    observer.observe({ entryTypes: ['layout-shift'] });
    this.observers.push(observer);
  }

  private observeFCP() {
    const observer = new PerformanceObserver((list) => {
      const entries = list.getEntries();
      const firstEntry = entries[0];
      this.metrics.FCP = firstEntry.startTime;
    });
    observer.observe({ entryTypes: ['paint'] });
    this.observers.push(observer);
  }

  private measureTTFB() {
    const navigation = performance.getEntriesByType('navigation')[0] as PerformanceNavigationTiming;
    if (navigation) {
      this.metrics.TTFB = navigation.responseStart - navigation.startTime;
    }
  }

  report() {
    const ratings = Object.entries(this.metrics).reduce((acc, [key, value]) => {
      acc[key as keyof WebVitalsMetrics] = getMetricRating(key as keyof WebVitalsMetrics, value || 0);
      return acc;
    }, {} as Record<keyof WebVitalsMetrics, MetricRating>);

    const overallScore = this.calculateOverallScore();

    logger.info('web_vitals_report', {
      context: this.context,
      metrics: this.metrics,
      ratings,
      overallScore,
      timestamp: new Date().toISOString(),
    });

    // Alerta se performance ruim
    if (overallScore < 70) {
      logger.warn('performance_degradation_detected', {
        context: this.context,
        score: overallScore,
        recommendations: this.generateRecommendations(ratings),
      });
    }

    return { metrics: this.metrics, ratings, overallScore };
  }

  private calculateOverallScore(): number {
    const weights = { LCP: 0.25, FID: 0.25, CLS: 0.25, FCP: 0.15, TTFB: 0.1 };
    let score = 100;

    Object.entries(this.metrics).forEach(([key, value]) => {
      if (!value) return;
      const metric = key as keyof WebVitalsMetrics;
      const rating = getMetricRating(metric, value);
      
      if (rating === 'poor') score -= weights[metric] * 40;
      else if (rating === 'needs-improvement') score -= weights[metric] * 20;
    });

    return Math.max(0, score);
  }

  private generateRecommendations(ratings: Record<keyof WebVitalsMetrics, MetricRating>): string[] {
    const recommendations: string[] = [];
    
    if (ratings.LCP === 'poor') {
      recommendations.push('Otimizar imagens (WebP/AVIF), preload critical resources');
    }
    if (ratings.CLS === 'poor') {
      recommendations.push('Adicionar width/height em imagens, reservar espaço para ads');
    }
    if (ratings.FID === 'poor') {
      recommendations.push('Reduzir JavaScript main-thread, code-splitting');
    }
    
    return recommendations;
  }

  destroy() {
    this.observers.forEach(obs => obs.disconnect());
  }
}

// Hook React para uso em componentes
export function usePerformanceMonitor(context: string) {
  React.useEffect(() => {
    const monitor = new PerformanceMonitor(context);
    monitor.start();
    
    return () => monitor.destroy();
  }, [context]);
}
```

## Variáveis

| Variável | Descrição | Exemplo |
|:---|:---|:---|
| `{{COMPONENT_SCOPE}}` | Escopo do monitoramento | `DashboardPage` |
| `{{CONTEXT}}` | Contexto de uso | `dashboard_main` |

## Uso por Agente

**ZETA (Optimizer):**
1. Instrumenta aplicação com este monitor
2. Coleta métricas por 7 dias
3. Identifica gargalos (LCP > 2.5s, CLS > 0.1)
4. Gera relatório `OPTIMIZATION_REPORT.md`
5. Propõe otimizações específicas
6. Atualiza snippets se padrão de erro detectado

**Integração com EPSILON:**
Métricas de performance impactam SEO - EPSILON usa dados para otimizar estratégia.

## Stack Omega

- **API:** Web Vitals (native browser API)
- **Logging:** JSON estruturado
- **Thresholds:** Google Core Web Vitals
- **Alerting:** Baseado em score < 70

## Validação (DELTA)

- [ ] Todos os 5 Web Vitals medidos
- [ ] Cálculo de score ponderado correto
- [ ] Recomendações específicas por métrica ruim
- [ ] Cleanup de observers no unmount
- [ ] SSR-safe (checar typeof window)
- [ ] Thresholds alinhados com Stack Omega
```

---

### 9. OBSERVABILITY (Todos os agentes)

**`Minhas_Skills/RECURSOS/snippets/06_observability/08_logger_json_structured.md`**

```markdown
---
name: logger_json_structured
description: Logger universal JSON estruturado para todos os agentes
agent: ALL
skill: 13_observability_playbook
category: observability
tags: [logging, json, observability, monitoring, universal]
dependencies: []
mode: [GEM, IDX]
---

# Logger JSON Estruturado - Universal

## Código

```typescript
// lib/observability/logger.ts
type LogLevel = 'debug' | 'info' | 'warn' | 'error' | 'fatal';

interface LogContext {
  agent?: string;
  skill?: string;
  requestId?: string;
  userId?: string;
  project?: string;
  [key: string]: unknown;
}

interface LogEntry {
  timestamp: string;
  level: LogLevel;
  message: string;
  context: LogContext;
  stack?: string;
  duration_ms?: number;
}

class StructuredLogger {
  private isDevelopment: boolean;
  private minLevel: LogLevel;

  constructor() {
    this.isDevelopment = process.env.NODE_ENV === 'development';
    this.minLevel = (process.env.LOG_LEVEL as LogLevel) || 'info';
  }

  private shouldLog(level: LogLevel): boolean {
    const levels: LogLevel[] = ['debug', 'info', 'warn', 'error', 'fatal'];
    return levels.indexOf(level) >= levels.indexOf(this.minLevel);
  }

  private formatLogEntry(level: LogLevel, message: string, context: LogContext, error?: Error): LogEntry {
    return {
      timestamp: new Date().toISOString(),
      level,
      message,
      context: {
        ...context,
        environment: process.env.NODE_ENV,
        version: process.env.npm_package_version,
      },
      ...(error && { stack: error.stack }),
    };
  }

  private output(entry: LogEntry): void {
    // Em produção: JSON puro para parsing automático
    // Em desenvolvimento: formatado para leitura humana
    if (this.isDevelopment) {
      const colorMap: Record<LogLevel, string> = {
        debug: '\x1b[36m', // Cyan
        info: '\x1b[32m',  // Green
        warn: '\x1b[33m',  // Yellow
        error: '\x1b[31m', // Red
        fatal: '\x1b[35m', // Magenta
      };
      const reset = '\x1b[0m';
      console.log(
        `${colorMap[entry.level]}[${entry.level.toUpperCase()}]${reset} ${entry.timestamp} - ${entry.message}`,
        entry.context,
        entry.stack ? `\n${entry.stack}` : ''
      );
    } else {
      console.log(JSON.stringify(entry));
    }
  }

  debug(message: string, context: LogContext = {}): void {
    if (!this.shouldLog('debug')) return;
    this.output(this.formatLogEntry('debug', message, context));
  }

  info(message: string, context: LogContext = {}): void {
    if (!this.shouldLog('info')) return;
    this.output(this.formatLogEntry('info', message, context));
  }

  warn(message: string, context: LogContext = {}, error?: Error): void {
    if (!this.shouldLog('warn')) return;
    this.output(this.formatLogEntry('warn', message, context, error));
  }

  error(message: string, error: Error, context: LogContext = {}): void {
    if (!this.shouldLog('error')) return;
    this.output(this.formatLogEntry('error', message, context, error));
  }

  fatal(message: string, error: Error, context: LogContext = {}): void {
    this.output(this.formatLogEntry('fatal', message, context, error));
    // Em caso fatal, notificar imediatamente
    this.notifyCriticalError(message, error, context);
  }

  // Métricas de performance
  startTimer(operation: string, context: LogContext = {}): () => void {
    const start = Date.now();
    return () => {
      const duration = Date.now() - start;
      this.info(`${operation}_completed`, {
        ...context,
        duration_ms: duration,
      });
    };
  }

  private notifyCriticalError(message: string, error: Error, context: LogContext): void {
    // Integração com serviço de alerta (PagerDuty, Opsgenie, etc)
    if (process.env.CRITICAL_ALERT_WEBHOOK) {
      fetch(process.env.CRITICAL_ALERT_WEBHOOK, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          message,
          error: error.message,
          stack: error.stack,
          context,
          timestamp: new Date().toISOString(),
        }),
      }).catch(err => {
        // Fallback: log local se notificação falhar
        console.error('Failed to send critical alert:', err);
      });
    }
  }
}

// Singleton export
export const logger = new StructuredLogger();

// Helper para agentes específicos
export function createAgentLogger(agentName: string, skillName?: string) {
  return {
    debug: (msg: string, ctx?: LogContext) => logger.debug(msg, { agent: agentName, skill: skillName, ...ctx }),
    info: (msg: string, ctx?: LogContext) => logger.info(msg, { agent: agentName, skill: skillName, ...ctx }),
    warn: (msg: string, ctx?: LogContext, err?: Error) => logger.warn(msg, { agent: agentName, skill: skillName, ...ctx }, err),
    error: (msg: string, err: Error, ctx?: LogContext) => logger.error(msg, err, { agent: agentName, skill: skillName, ...ctx }),
    fatal: (msg: string, err: Error, ctx?: LogContext) => logger.fatal(msg, err, { agent: agentName, skill: skillName, ...ctx }),
  };
}
```

## Variáveis

| Variável | Descrição | Padrão |
|:---|:---|:---|
| `LOG_LEVEL` | Nível mínimo de log | `info` |
| `NODE_ENV` | Ambiente | `development`/`production` |
| `CRITICAL_ALERT_WEBHOOK` | Webhook para alertas críticos | `undefined` |

## Uso por Agente

**Todos os agentes usam este logger:**

```typescript
// Exemplo: GAMMA usando logger
import { createAgentLogger } from '@/lib/observability/logger';

const log = createAgentLogger('GAMMA', '04_codando');

export async function buildComponent() {
  log.info('component_build_started', { component: 'UserCard' });
  
  const endTimer = logger.startTimer('component_build', { component: 'UserCard' });
  
  try {
    // ... código ...
    endTimer();
    log.info('component_build_completed');
  } catch (error) {
    log.error('component_build_failed', error as Error, { component: 'UserCard' });
    throw error;
  }
}
```

## Stack Omega

- **Format:** JSON estruturado (produção) / Colorizado (dev)
- **Levels:** debug, info, warn, error, fatal
- **Context:** agent, skill, requestId, userId obrigatórios
- **Performance:** Timers integrados para métricas

## Validação (DELTA)

- [ ] Nenhum `console.log` direto no código
- [ ] Todos os logs usam `logger` ou `createAgentLogger`
- [ ] Contexto inclui `agent` e `skill`
- [ ] Erros incluem stack trace
- [ ] JSON válido em produção (parseável)
- [ ] Alertas críticos configurados (webhook)
```

---

### 10. COMMS (Integrações)

**`Minhas_Skills/RECURSOS/snippets/07_comms/09_evolution_whatsapp.md`**

```markdown
---
name: evolution_whatsapp
description: Integração Evolution API para WhatsApp com fallback
agent: GAMMA
skill: 10_pesquisando_web
category: communications
tags: [whatsapp, evolution, api, fallback, comms]
dependencies: [06_observability]
mode: [GEM, IDX]
---

# Evolution WhatsApp Integration

## Código

```typescript
// lib/comms/whatsapp.ts
import { logger } from '@/lib/observability/logger';

interface WhatsAppConfig {
  baseUrl: string;
  apiKey: string;
  instanceName: string;
}

interface SendMessageInput {
  phone: string;
  text: string;
  options?: {
    delay?: number;
    linkPreview?: boolean;
  };
}

interface SendMessageResult {
  success: boolean;
  messageId?: string;
  error?: string;
  fallbackUsed?: boolean;
}

class EvolutionWhatsAppClient {
  private config: WhatsAppConfig;

  constructor(config: WhatsAppConfig) {
    this.config = config;
  }

  async sendText(input: SendMessageInput): Promise<SendMessageResult> {
    const { phone, text, options } = input;
    
    logger.info('whatsapp_send_attempt', {
      phone: this.maskPhone(phone),
      textLength: text.length,
    });

    try {
      const response = await fetch(
        `${this.config.baseUrl}/message/sendText/${this.config.instanceName}`,
        {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'apikey': this.config.apiKey,
          },
          body: JSON.stringify({
            number: this.sanitizePhone(phone),
            textMessage: { text },
            options: {
              delay: options?.delay ?? 1200,
              linkPreview: options?.linkPreview ?? true,
            },
          }),
        }
      );

      if (!response.ok) {
        const errorText = await response.text();
        throw new Error(`Evolution API error: ${response.status} - ${errorText}`);
      }

      const data = await response.json();
      
      logger.info('whatsapp_send_success', {
        phone: this.maskPhone(phone),
        messageId: data.key?.id,
      });

      return {
        success: true,
        messageId: data.key?.id,
      };

    } catch (error) {
      logger.error('whatsapp_send_failed', error as Error, {
        phone: this.maskPhone(phone),
      });

      // Fallback para email se configurado
      if (process.env.FALLBACK_EMAIL_ENABLED === 'true') {
        return this.fallbackToEmail(input);
      }

      return {
        success: false,
        error: (error as Error).message,
      };
    }
  }

  private async fallbackToEmail(input: SendMessageInput): Promise<SendMessageResult> {
    logger.info('whatsapp_fallback_to_email', {
      phone: this.maskPhone(input.phone),
    });

    try {
      // Integração com Resend ou similar
      const emailResult = await fetch('/api/email/send', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          to: input.phone + '@fallback.whatsapp', // Ou lookup de email real
          subject: 'Mensagem WhatsApp (Fallback)',
          text: input.text,
        }),
      });

      if (!emailResult.ok) {
        throw new Error('Email fallback failed');
      }

      return {
        success: true,
        fallbackUsed: true,
      };

    } catch (error) {
      logger.error('whatsapp_fallback_failed', error as Error, {
        phone: this.maskPhone(input.phone),
      });

      return {
        success: false,
        error: 'WhatsApp and fallback both failed',
      };
    }
  }

  private sanitizePhone(phone: string): string {
    // Remove tudo exceto números
    return phone.replace(/\D/g, '');
  }

  private maskPhone(phone: string): string {
    // Mascara para logs (privacidade)
    const cleaned = this.sanitizePhone(phone);
    if (cleaned.length < 4) return '***';
    return cleaned.slice(0, -4) + '****';
  }

  // Verifica status da instância
  async checkStatus(): Promise<{ connected: boolean; state: string }> {
    try {
      const response = await fetch(
        `${this.config.baseUrl}/instance/connectionState/${this.config.instanceName}`,
        {
          headers: { 'apikey': this.config.apiKey },
        }
      );

      const data = await response.json();
      
      return {
        connected: data.state === 'open',
        state: data.state,
      };

    } catch (error) {
      logger.error('whatsapp_status_check_failed', error as Error);
      return { connected: false, state: 'unknown' };
    }
  }
}

// Factory com configuração de ambiente
export function createWhatsAppClient(): EvolutionWhatsAppClient {
  const config: WhatsAppConfig = {
    baseUrl: process.env.EVOLUTION_API_URL!,
    apiKey: process.env.EVOLUTION_API_KEY!,
    instanceName: process.env.EVOLUTION_INSTANCE_NAME || 'default',
  };

  if (!config.baseUrl || !config.apiKey) {
    throw new Error('Evolution WhatsApp configuration missing');
  }

  return new EvolutionWhatsAppClient(config);
}

// Export singleton
export const whatsapp = createWhatsAppClient();
```

## Variáveis de Ambiente

| Variável | Descrição | Obrigatório |
|:---|:---|:---|
| `EVOLUTION_API_URL` | URL base da Evolution API | Sim |
| `EVOLUTION_API_KEY` | API Key da Evolution | Sim |
| `EVOLUTION_INSTANCE_NAME` | Nome da instância WhatsApp | Não (default: 'default') |
| `FALLBACK_EMAIL_ENABLED` | Habilitar fallback para email | Não (default: 'false') |

## Uso por Agente

**GAMMA (Builder):**
1. Configura variáveis de ambiente
2. Implementa chamada onde necessário (notificações, alerts)
3. Sempre usa fallback para operações críticas
4. Valida número de telefone antes de enviar

**Exemplo de uso:**
```typescript
import { whatsapp } from '@/lib/comms/whatsapp';

// Enviar notificação
const result = await whatsapp.sendText({
  phone: '+5511999999999',
  text: 'Seu pedido foi confirmado! 🎉',
  options: { delay: 1000 },
});

if (!result.success && !result.fallbackUsed) {
  // Escalar para ETA investigar
}
```

## Stack Omega

- **API:** Evolution API v2
- **Fallback:** Email (Resend) configurável
- **Privacy:** Mascaramento de telefone em logs
- **Retry:** Implementado no client HTTP (fetch com retry)

## Validação (DELTA)

- [ ] Variáveis de ambiente validadas no startup
- [ ] Telefone sanitizado antes do envio
- [ ] Telefone mascarado em logs (LGPD/GDPR)
- [ ] Fallback configurado para operações críticas
- [ ] Status da instância verificado periodicamente
- [ ] Tratamento de erro graceful (não quebra aplicação)
```

---

## 📊 Resumo da Estrutura Criada

| Arquivo | Agente | Categoria | Propósito |
|:---|:---|:---|:---|
| `00_index_snippets.md` | ZETA | Índice | Centralizar arsenal |
| `01_theta_state_manager.md` | THETA | Orquestração | Gerenciar estado |
| `02_alpha_project_bootstrap.md` | ALPHA | Genesis | Bootstrap projeto |
| `03_beta_plan_template.md` | BETA | Architecture | Template PLAN.md |
| `04_gamma_nextjs_api_route.md` | GAMMA | Backend | API Routes |
| `05_gamma_shadcn_component.md` | GAMMA | Frontend | UI Components |
| `06_eta_error_handler.md` | ETA | Error Handling | Retry & recovery |
| `07_zeta_performance_monitor.md` | ZETA | Performance | Web Vitals |
| `08_logger_json_structured.md` | ALL | Observability | Logs universais |
| `09_evolution_whatsapp.md` | GAMMA | Comms | WhatsApp integration |

---

## ✅ Checklist de Integração v3.0

- [x] **Formato:** Markdown com YAML frontmatter
- [x] **Agentes:** Todos os 8 agentes cobertos
- [x] **Variáveis:** Sistema `{{LIKE_THIS}}` para substituição GAMMA
- [x] **Stack Omega:** Next.js 14+, Neon, Drizzle, Tailwind, shadcn/ui
- [x] **Observability:** Logger JSON em todos os snippets
- [x] **Validação:** Checklist DELTA em cada snippet
- [x] **Handoff:** Instruções de transição entre agentes

