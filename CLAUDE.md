# ANTIGRAVITY OS NEURAL — CLAUDE.md v2.0

> Motor Neural do Antigravity OS para IDEs agênticas (Cursor, Claude Code, Windsurf).
> Regras são lidas de cima para baixo: **HARD → MEDIUM → SOFT**.
> Máximo 300 linhas. Documento vivo — atualize quando a IA repetir erros.

---

## 🔴 HARD RULES — Inegociáveis

### 1. Pensar Antes de Codar
- Declare suas suposições e interpretações sobre o problema ANTES de implementar.
- Defina critérios de sucesso ANTES de começar. Se não sabe como validar o resultado, não tem permissão para começar.
- Para tarefas complexas: analise código existente → mapeie escopo → faça perguntas → proponha plano → peça aprovação → implemente.

### 2. Mudanças Cirúrgicas
- Altere ESTRITAMENTE o que foi pedido.
- É PROIBIDO refatorar código ao redor ou "melhorar" trechos não solicitados.
- Nunca mova, renomeie ou delete arquivos sem instrução explícita.
- Preserve TODOS os comentários e docstrings existentes que não são alvo da mudança.

### 3. Segurança é Não-Negociável
- NUNCA hardcode secrets, API keys, tokens ou PII no código.
- Detectou PII ou secret? SANITIZE imediatamente e avise o usuário.
- Valide TODO input com Zod (`.strict()`) — no servidor, nunca só no cliente.
- Identidade do usuário vem do token/sessão, NUNCA do input (IDOR prevention).
- Nenhum `catch(e) {}` vazio — trate, logue ou propague.
- `any` é PROIBIDO — use `unknown` + validação estrutural.

### 4. Git é Sagrado
- PROIBIDO executar `git push --force`, `git rebase` destrutivo ou `git reset --hard` sem confirmação explícita do usuário.
- Commits atômicos: 1 commit = 1 mudança lógica completa.
- Conventional Commits obrigatório: `feat|fix|refactor|test|docs|chore|security(scope): description`
- NUNCA commite `.env`, `*.pem`, `*.key` ou secrets.

### 5. Verificação Contínua
- NUNCA reporte uma tarefa como "feito" sem verificar.
- Rode testes, linter e type check. Se algo falhar, corrija ANTES de apresentar o resultado.
- Se não há testes, diga explicitamente: "Sem testes automatizados para validar."

---

## 🟡 MEDIUM RULES — Padrões de Qualidade

### 6. Simplicidade Primeiro
- Busque a solução mínima viável que funciona, não a mais elaborada.
- Máximo 200 linhas por arquivo novo. Ultrapassou? Divida.
- Máximo 50 linhas por função. Faz mais de uma coisa? Refatore.
- Não introduza nova tecnologia sem esgotar opções existentes na Stack Omega.
- Prefira `fetch` nativo sobre Axios. `date-fns` sobre moment. Stdlib sobre lodash.

### 7. Arquitetura e Escopo
- Respeite a estrutura do projeto. Leia e obedeça regras de subdiretórios antes de atuar.
- Lógica de negócio em `lib/services/` — NUNCA em `app/` ou `components/`.
- Componentes de UI nunca chamam APIs, contêm regras de negócio ou parseiam dados brutos.
- Server Actions e Route Handlers são a interface — não a lógica.
- Se o projeto é monorepo, este arquivo dita regras globais; subprojetos podem ter regras locais.

### 8. TypeScript Strict Mode
- `strict: true`, `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes`, `noImplicitAny`.
- Tipos explícitos em retornos de função e parâmetros públicos.
- Interfaces para contratos, types para unions/intersections.
- Zod para validação runtime, TypeScript para compile-time.

### 9. Error Handling Estruturado
- Mensagens genéricas para o cliente, detalhes técnicos no log.
- Sempre inclua `correlationId` / `requestId` nos logs de erro.
- Use logger estruturado (JSON) — `console.log` é PROIBIDO em produção.
- Erros em LLMs/APIs externas: circuit breaker + retry com exponential backoff.

### 10. Testes São Obrigatórios
- Lógica de negócio: testes unitários com Vitest (cobertura ≥ 80%).
- Fluxos críticos: testes E2E com Playwright.
- Edge cases obrigatórios: null, undefined, arrays vazios, limites numéricos, strings vazias.
- TDD quando possível: Red → Green → Refactor.

---

## 🟢 SOFT RULES — Conveniências e Estilo

### 11. Idioma e Comunicação
- Responda SEMPRE em pt-BR.
- Seja direto e técnico — sem jargão vazio ou conversas fiadas.
- Dê visão geral → solução → por que funciona.
- Se não tem certeza, pergunte. Não assuma.

### 12. Documentação como Código
- Nomes autoexplicativos: `calculateMatchingScore`, não `calc()`. `userEmail`, não `ue`.
- Docstrings TSDoc obrigatórias em funções públicas/exportadas.
- Código comentado sem justificativa = dívida técnica. Remova.
- TODOs sem issue/ticket associado são proibidos.

### 13. Observabilidade
- Health check endpoint: `/api/health` → `{ status: "ok", uptime: "Xd" }`.
- Structured logging (JSON + traceId) em todos os pontos críticos.
- Logar entrada/saída de agentes, chamadas LLM (tokens, latência), transições de workflow.
- Operações longas (>30s) delegadas para Inngest.

### 14. Performance e UX
- Lazy loading + code splitting em componentes pesados.
- Imagens otimizadas (`next/image`, WebP, dimensões explícitas).
- Paginação com `pageSize` máximo (≤ 100). Nunca `SELECT *`.
- Projeção explícita em queries — retorne apenas campos necessários.

---

## 🗺️ MAPA DE LEITURA

Ao iniciar, leia sequencialmente:

1. **Este arquivo** (CLAUDE.md) — Regras de comportamento
2. `.antigravity-os/[99] INDEX.md` — Mapa Mestre do OS
3. `.antigravity-os/[00] KERNEL/[00] quantum-loader.md` — Detectar modo GEM/IDX
4. `Minhas_Rules/STACK_OMEGA_RULES.md` — Stack tecnológica obrigatória
5. `SECURITY_AUDIT/README.md` — Framework de segurança (quando auditar)

---

## 🚫 PROIBIÇÕES ABSOLUTAS

| # | Proibição | Consequência |
|---|-----------|-------------|
| P1 | Hardcodar secrets ou PII | Rollback imediato |
| P2 | `git push --force` sem aprovação | Bloqueio de execução |
| P3 | `any` no TypeScript | Rejeição por DELTA |
| P4 | `catch(e) {}` vazio | Rejeição por DELTA |
| P5 | Lógica de negócio em componentes UI | Refatoração obrigatória |
| P6 | `console.log` em produção | Substituir por logger |
| P7 | Tecnologia fora da Stack Omega sem ADR | Rollback obrigatório |
| P8 | Deploy sem auditoria DELTA (≥ 85%) | Deploy bloqueado |
| P9 | Alucinar APIs ou libs inexistentes | Verificar `package.json` |
| P10 | Sobrescrever `.env` sem confirmação | Perda de dados |

---

## ⚡ STACK OMEGA v3.0

Referência rápida — detalhes em `Minhas_Rules/STACK_OMEGA_RULES.md`:

| Camada | Tecnologia |
|--------|-----------|
| Framework | Next.js 14+ (App Router) |
| Linguagem | TypeScript 5+ (strict, zero `any`) |
| Database | Neon PostgreSQL + Drizzle ORM |
| Auth | Clerk |
| Queues | Inngest |
| Styling | Tailwind CSS + Shadcn/UI + Lucide React |
| Animation | Framer Motion (GSAP para casos específicos) |
| AI/LLM | OpenRouter + Vercel AI SDK + pgvector |
| Validation | Zod |
| State | Zustand + TanStack Query |
| Email | Resend + Brevo |
| Deploy | Vercel |

---

**Versão:** 2.0 | **Última atualização:** 2026-04-29
**Integração:** Carregado automaticamente por IDEs agênticas na raiz do projeto.
