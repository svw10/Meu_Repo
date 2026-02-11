# 🤖 Multi-Agent System com Inngest + Prisma + Zod

Repositório de referência para arquitetura de agentes autônomos com handover assíncrono, memória persistente e validação estrutural.

## 🏗️ Arquitetura

### Padrões Implementados
- **Blackboard Pattern**: Contexto compartilhado entre agentes via `AgentThread.sharedContext`
- **Fail-Fast Validation**: Zod valida outputs antes de handover (anti-hallucination)
- **Exactly-Once Semantics**: Inngest garante não-duplicação de steps
- **Resilience**: Retry automático com exponential backoff

### Stack Técnica
- **Next.js 14** (App Router)
- **Prisma** (ORM com PostgreSQL/SQLite)
- **Inngest** (Orquestração de filas e agentes)
- **Zod** (Validação em runtime)
- **TypeScript Strict Mode**

## 🚀 Setup Local

### 1. Clone e Instale Dependências
```bash
git clone https://github.com/svw10/Meu_Repo.git
cd Meu_Repo
npm install
```

### 2. Configure Variáveis de Ambiente
```bash
cp .env.example .env
# Edite .env com suas credenciais
```

**Mínimo necessário:**
```env
DATABASE_URL="postgresql://user:pass@localhost:5432/db"
INNGEST_EVENT_KEY="your-key"
INNGEST_SIGNING_KEY="your-signing-key"
```

### 3. Inicialize o Banco de Dados
```bash
npm run db:generate  # Gera Prisma Client
npm run db:push      # Cria tabelas no banco
```

### 4. Rode em Desenvolvimento
```bash
npm run dev
```

Acesse:
- **App**: `http://localhost:3000`
- **Inngest Dev Server**: `npx inngest-cli@latest dev`
- **Prisma Studio**: `npm run db:studio` (GUI do banco)

## 📁 Estrutura de Pastas

```
Meu_Repo/
├── Agentes/                    # Documentação de agentes (ALPHA, BETA, etc.)
├── prisma/
│   └── schema.prisma          # Modelos: AgentThread, AgentMessage
├── src/
│   ├── agents/
│   │   ├── schemas.ts         # Contratos Zod (ResearchOutput, ContentOutput, etc.)
│   │   └── orchestrator.ts    # Lógica de handover multi-agente
│   ├── app/
│   │   └── api/
│   │       └── inngest/
│   │           ├── client.ts  # Cliente Inngest configurado
│   │           └── route.ts   # Rota API (GET/POST/PUT)
│   └── lib/
│       └── prisma.ts          # Singleton do Prisma Client
├── .env.example               # Template de variáveis
├── package.json
└── README.md
```

## 🔄 Fluxo de Handover (Exemplo)

```typescript
// 1. Dispara workflow
await inngest.send({
  name: "agents/workflow.start",
  data: {
    threadId: "cuid-generated-id",
    externalId: "user-123",
    prompt: "Analise tendências de IA em 2026"
  }
});

// 2. Executado automaticamente pelo Inngest:
// - STEP 1: Agente Pesquisador → valida com ResearchOutputSchema
// - STEP 2: Persiste no Prisma (AgentMessage)
// - STEP 3: Agente Redator → recebe findings validados
// - STEP 4: Persiste conteúdo
// - STEP 5: Agente Validador → verifica qualidade
// - STEP 6: Marca thread como COMPLETED ou FAILED
```

## 🛡️ Segurança & Boas Práticas

✅ **Implementado:**
- Validação estrutural com Zod (previne injection)
- TypeScript strict mode (`noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`)
- Secrets em variáveis de ambiente (nunca commitadas)
- Logging estruturado (JSON)
- Cascading deletes (integridade referencial)

❌ **Ainda não implementado (roadmap):**
- Rate limiting customizado (usa defaults do Inngest)
- Row-level security (RLS) no Prisma
- Criptografia de `sharedContext` em repouso
- Observabilidade com OpenTelemetry

## 📊 Monitoramento

### Inngest Dashboard
```bash
npx inngest-cli@latest dev
# Acesse: http://localhost:8288
```

Visão de:
- Funções executadas
- Steps executados/falhados
- Latência p50/p95
- Retry attempts

### Prisma Studio
```bash
npm run db:studio
# Acesse: http://localhost:5555
```

Visualize:
- Threads ativas/concluídas
- Histórico de mensagens de agentes
- Contexto compartilhado (sharedContext)

## 🧪 Testes (Roadmap)

```bash
# Unit tests (validação de schemas)
npm run test:unit

# Integration tests (handover completo)
npm run test:integration

# E2E tests (com banco de dados de teste)
npm run test:e2e
```

## 🚢 Deploy

### Vercel (Recomendado)
```bash
vercel --prod
```

**Variáveis obrigatórias no Vercel:**
- `DATABASE_URL`
- `INNGEST_EVENT_KEY`
- `INNGEST_SIGNING_KEY`
- `OPENAI_API_KEY` (se usar LLMs)

### Docker (Alternativa)
```dockerfile
# Dockerfile incluído no .dockerignore
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .
RUN npm run build
CMD ["npm", "start"]
```

## 📚 Documentação Adicional

- [Inngest Docs](https://www.inngest.com/docs)
- [Prisma Docs](https://www.prisma.io/docs)
- [Zod Docs](https://zod.dev)
- [Next.js App Router](https://nextjs.org/docs/app)

## 🤝 Contribuindo

1. Fork o repositório
2. Crie uma branch: `git checkout -b feature/nova-feature`
3. Commit: `git commit -m 'feat: adiciona novo agente X'`
4. Push: `git push origin feature/nova-feature`
5. Abra um Pull Request

## 📝 Licença

MIT License - veja [LICENSE](LICENSE) para detalhes.

---

**Mantido por:** Luciano - Arquiteto AprenderIA  
**Contato:** [Seu Email/LinkedIn]
