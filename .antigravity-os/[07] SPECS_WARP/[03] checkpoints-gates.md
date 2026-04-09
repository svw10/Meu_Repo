# [03] CHECKPOINTS & GATES — Portões de Qualidade Obrigatórios

## 🎯 Propósito
Definir pontos de parada obrigatórios onde a IA deve validar critérios antes de avançar para a próxima fase, prevenindo retrabalho em cascata e garantindo conformidade com Stack Omega.

---

## 🚦 Mapa de Gates do Fluxo

```
[Usuário solicita feature]
        ↓
[GATE 1: PRD Review] ← BETA + Humano
        ↓
[PRD Aprovado]
        ↓
[GATE 1.5: Spec Refinement] ← BETA + THETA + Entrevista Estruturada ⭐ NOVO
        ↓
[SPEC Técnica Validada]
        ↓
[GATE 2: SPEC Generation] ← Validação Zod + THETA
        ↓
[SPEC Técnica Aprovada]
        ↓
[GATE 3: Sprint Approval] ← DELTA (Security/Performance Check)
        ↓
[Execução GAMMA]
        ↓
[GATE 4: Acceptance Test] ← Testes automatizados + DELTA
        ↓
[Deploy/Commit]
        ↓
[GATE 5: Post-Mortem] ← Registro em MEMORY_DNA
```

---

## 📋 Detalhamento dos Gates

### 🔹 GATE 1: PRD Review (Negócio)
**Responsável:** BETA (Architect) + Validação Humana

**Critérios de Passagem:**
- [ ] User Stories no formato correto (Como/Quero/Para)
- [ ] Critérios de aceite em BDD/Gherkin definidos
- [ ] "Fora do Escopo" explicitamente listado
- [ ] KPIs mensuráveis definidos
- [ ] Sem termos técnicos de implementação
- [ ] Stack Omega respeitada (sem libs não autorizadas)

**Ação se Falhar:** Retornar para refinamento com BETA. Não gerar SPEC.

---

### 🔹 GATE 1.5: Spec Refinement (Entrevista Estruturada) ⭐ NOVO
**Responsável:** BETA + THETA (com protocolo de entrevista)

**Propósito:** Eliminar ambiguidades de negócio antes da geração técnica via entrevista guiada.

**Protocolo Obrigatório:**
1. **NUNCA** alterar SPEC antes de terminar TODAS as perguntas
2. **UMA pergunta por vez** — aguardar resposta do usuário
3. **Múltipla escolha** sempre que possível (a, b, c, d)
4. **Auto-fill técnico** — padrões Stack Omega aplicados sem perguntar
5. **Confirmação final** antes de gerar SPEC

**Critérios de Passagem:**
- [ ] Todas as perguntas do protocolo respondidas
- [ ] Decisões de negócio documentadas e confirmadas
- [ ] Padrões técnicos aplicados (status codes, validation, error handling)
- [ ] Edge cases identificados e tratados
- [ ] Resumo de decisões aprovado pelo usuário
- [ ] Output formatado (JSON ou Markdown) conforme preferência

**Checklist de Auto-Fill (Stack Omega) — Aplicar SEM perguntar:**
| Categoria | Padrões Automáticos |
|-----------|-------------------|
| `api_endpoint` | Status codes (400,401,403,404,409,422,429,500), Zod validation, response schema, timeout 10s |
| `build` | Node ≥18, env vars validation, cleanup artifacts, network retry 2x |
| `estrutura` | Conflito de pasta, permissões, `.gitignore`, README, aliases `@/` |
| `database` | RLS enabled, constraint violations, migration rollback, pool exhaustion |
| `auth` | Token expiry, refresh flow, brute force lockout, CSRF protection |
| `integração` | Timeout 30s, retry com backoff, circuit breaker, fallback/cache |
| `ia_agent` | Token limit, modelo indisponível, resposta vazia, fallback model |
| `frontend` | Loading state, error boundary, empty state, offline fallback |
| `infra` | Health check, graceful shutdown, OOM handler, readiness/liveness |

**Ação se Falhar:** Solicitar respostas faltantes. Não avançar para Gate 2.

---

### 🔹 GATE 2: SPEC Generation (Técnica)
**Responsável:** THETA (Orchestrator) + Validação Zod

**Critérios de Passagem:**
- [ ] Schema `SpecTechnicalSchema` validado com sucesso (`zod.parse()`)
- [ ] `linked_prd_id` presente e válido (vínculo com PRD aprovado)
- [ ] Sprints divididas atomicamente (<15k tokens cada)
- [ ] Stack e constraints alinhadas com `Minhas_Rules/STACK_OMEGA_RULES.md`
- [ ] Budget de tokens definido por sprint dentro de `token-budget-controller.json`
- [ ] Critérios de aceite testáveis e automatizáveis
- [ ] Fallback definido se budget estourar

**Ação se Falhar:** Solicitar correção da SPEC. Não iniciar codificação.

---

### 🔹 GATE 3: Sprint Approval (Pré-Execução)
**Responsável:** DELTA (Auditor)

**Critérios de Passagem:**
- [ ] Nenhum secret/PII nos arquivos alvo (scan prévio)
- [ ] Dependências declaradas e disponíveis no `package.json`
- [ ] Critérios de aceite testáveis automatizadamente
- [ ] Fallback definido se budget estourar
- [ ] Server/Client separation correto (Next.js App Router)
- [ ] Zod validation em todas as entradas de usuário/API

**Ação se Falhar:** Bloquear execução do GAMMA. Acionar ETA para investigação.

---

### 🔹 GATE 4: Acceptance Test (Pós-Execução)
**Responsável:** DELTA + Testes Automatizados

**Critérios de Passagem:**
- [ ] Todos os `acceptance_criteria` da sprint passaram
- [ ] Lint/TypeScript sem erros (`npm run lint`, `npx tsc --noEmit`)
- [ ] Testes unitários/integração criados e passando (`npm run test`)
- [ ] Telemetria registrada em `TOKENOMICS/[03] cost-telemetry.json`
- [ ] Build limpo (`npm run build`)
- [ ] Smoke test passando (URL responde HTTP 200)

**Ação se Falhar:** Acionar loop de correção com ETA. Se >3 retries, escalar para humano.

---

### 🔹 GATE 5: Post-Mortem (Aprendizado)
**Responsável:** THETA + MEMORY_DNA

**Critérios de Passagem:**
- [ ] Erros encontrados registrados em `error-dna-registry.json`
- [ ] `prevention_prompt` gerado para erros recorrentes
- [ ] Métricas de custo/tempo atualizadas em `cost-telemetry.json`
- [ ] Sprint marcada como `done` no tracker
- [ ] Lições aprendidas documentadas para evolução futura

**Ação se Falhar:** Não considerar sprint concluída. Revisar processo de registro.

---

## ⚙️ Integração com Agentes

| Gate | Agente Primário | Ação Automática |
|------|----------------|-----------------|
| 1 | BETA | Gera checklist de validação de PRD |
| **1.5** | **BETA + THETA** | **Executa protocolo de entrevista estruturada** |
| 2 | THETA | Executa `zod.parse()` na SPEC |
| 3 | DELTA | Roda scanner de segurança pré-execução |
| 4 | DELTA + GAMMA | Executa testes e valida outputs |
| 5 | THETA | Atualiza MEMORY_DNA e TOKENOMICS |

---

## 🚨 Regra de Escape

Se um gate falhar **2x consecutivas** no mesmo tipo de erro:
1. **Pausar** execução imediatamente
2. **Notificar** usuário: `"⚠️ Gate [X] falhou repetidamente. Intervenção necessária."`
3. **Sugerir** revisão manual ou ajuste de especificação
4. **Registrar** padrão de falha em `MEMORY_DNA` para aprendizado futuro

---

## 📝 Instrução para IA

Sempre que atingir um gate listado acima:
1. **Execute a validação correspondente ANTES de prosseguir**
2. **Nunca pule gates**, mesmo sob pressão de tempo
3. **Registre** o resultado da validação em `Logs/gate-audit.log`
4. **Comunique** claramente ao usuário se houver bloqueio

> 💡 **Dica:** Gate 1.5 é opcional para features simples, mas **obrigatório** para:
> - Novos domínios de negócio
> - Integrações externas críticas
> - Features com impacto em segurança ou compliance
> - Qualquer tarefa com >3 critérios de aceite complexos
