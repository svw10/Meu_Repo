---
name: adr_template
description: Template padrão para Architectural Decision Records (ADR) alinhado ao Antigravity OS v3.1.2. Rastreabilidade técnica, consenso entre agentes e aprendizado futuro.
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: BETA + DELTA
trigger: "/adr" ou mudança de stack/arquitetura
status: active
tags: [architecture, decision, adr, beta, delta, documentation, trade-off]
---

# 📐 ADR TEMPLATE — Decisões Arquiteturais Versionadas

## 🎯 Propósito
Registrar decisões técnicas críticas que impactam arquitetura, stack, fluxos ou custos, garantindo:
- ✅ Rastreabilidade total (por que, quando, quem decidiu)
- ✅ Consenso entre agentes (BETA arquitetura + DELTA segurança/custo)
- ✅ Aprendizado estruturado (`MEMORY_DNA` + `RETROSPECTIVE`)
- ✅ Zero decisões tácitas ou "funciona por enquanto"

## ⚙️ Quando Usar
- Adoção de lib fora da `Minhas_Rules/STACK_OMEGA_RULES.md`
- Mudança de padrão arquitetural (ex: Server Actions ↔ Route Handlers, RLS ↔ Middleware)
- Trade-off com impacto em performance, custo ou segurança
- Resolução de incidente que exige ajuste estrutural
- Gatilho manual: `/adr` ou aprovação do BETA/DELTA

> **Regra de Ouro:** Todo ADR deve ser **proposto → revisado → aprovado** antes de alterar código em produção. NUNCA implementar decisão arquitetural sem ADR registrado.

---

## 📄 Formato Padrão (MADR Adaptado para IA)

```markdown
# ADR-[NNNN]: [Título Curto da Decisão]

| Campo            | Valor                                  |
|------------------|----------------------------------------|
| Status           | proposed \| accepted \| deprecated \| superseded \| rejected |
| Data             | YYYY-MM-DD                             |
| Proposto por     | Agente / Humano                        |
| Revisado por     | BETA + DELTA                           |
| Contexto         | PRD: [id] \| SPEC: [id] \| Incidente: [link] |
| Tags             | [stack, auth, db, performance, security, cost] |

## 1. Contexto
[Descreva o problema ou necessidade. Seja objetivo. Inclua métricas atuais, limitações e por que a mudança é necessária.]

## 2. Opções Consideradas
| Opção | Prós | Contras | Por que não escolhida? |
|-------|------|---------|------------------------|
| A     |      |         |                        |
| B     |      |         |                        |
| C     |      |         |                        |

## 3. Decisão
[Declaração clara da escolha. Ex: "Adotar Clerk com RLS no Neon para auth multi-tenant."]

## 4. Consequências
### ✅ Positivas
- [Benefício 1]
- [Benefício 2]

### ⚠️ Negativas / Riscos
- [Risco 1] + [Mitigação]
- [Risco 2] + [Mitigação]

### 📊 Impacto Mensurável
| Métrica          | Antes | Depois | Como Validar |
|------------------|-------|--------|--------------|
| Latência         |       |        |              |
| Custo/Token      |       |        |              |
| Complexidade     |       |        |              |
| Segurança        |       |        |              |

## 5. Plano de Execução
- [ ] Atualizar SPEC: [link]
- [ ] Atualizar `.cursorrules` / `STACK_OMEGA_RULES.md`
- [ ] Implementar migração em 2 sprints
- [ ] Monitorar métricas por 14 dias
- [ ] Registrar lição em `MEMORY_DNA`

## 6. Rastreabilidade
- Especificação: `docs/SPEC-[id].md`
- Commits: `git log --grep="ADR-[NNNN]"`
- Telemetria: `.antigravity-os/[05] TOKENOMICS/[03] cost-telemetry.json`
- Aprendizado: `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`
```

---

## 🔗 Integração com Antigravity OS

| Fase | Agente Responsável | Ação |
|------|-------------------|------|
| **Proposta** | BETA | Draft inicial, análise de alternativas, estimativa de custo |
| **Revisão** | DELTA | Validação de segurança, compliance LGPD, impacto em budget |
| **Aprovação** | THETA | Registro no índice `docs/adr/INDEX.md`, atualização de SPEC |
| **Execução** | GAMMA | Implementação seguindo plano do ADR |
| **Validação** | ETA + DELTA | Testes de regressão, monitoramento de métricas |
| **Arquivamento** | ZETA | Atualização de `MEMORY_DNA`, métricas finais, tag no git |

**Fluxo Automatizado:**
```
/adr new "Migrar auth para Clerk" 
  → BETA gera draft 
  → DELTA revisa segurança/custo 
  → THETA aprova + atualiza SPEC 
  → GAMMA implementa 
  → DELTA valida métricas 
  → ZETA arquiva em MEMORY_DNA
```

---

## 🚫 Anti-Padrões (Proibidos)

- ❌ Decisão sem comparar alternativas (viés de confirmação)
- ❌ ADR vago ("melhor performance" sem métricas)
- ❌ Ignorar consequências negativas ou riscos
- ❌ Implementar antes da aprovação de BETA + DELTA
- ❌ Esquecer de atualizar SPEC/`.cursorrules` após decisão
- ❌ ADR sem rastreabilidade (git, telemetria, MEMORY_DNA)

---

## ✅ Exemplo Real (Stack Omega)

```markdown
# ADR-0012: Autenticação com Clerk + RLS no Neon

| Campo            | Valor                                  |
|------------------|----------------------------------------|
| Status           | accepted                               |
| Data             | 2026-02-22                             |
| Proposto por     | BETA                                   |
| Revisado por     | DELTA                                  |
| Contexto         | SPEC-auth-v2, Incidente: vazamento de sessão em dev |
| Tags             | auth, security, db, cost               |

## 1. Contexto
Sistema atual usa NextAuth + JWT stateless. Problemas: refresh token management frágil, falta de RLS no DB, custo de sessão escalando com tráfego.

## 2. Opções Consideradas
| Opção | Prós | Contras | Por que não escolhida? |
|-------|------|---------|------------------------|
| NextAuth v5 | Familiar, open source | RLS manual, gestão de sessão complexa | Segurança inconsistente |
| Auth0 | Enterprise, maduro | Custo alto, vendor lock-in | Fora do budget |
| Clerk + Neon RLS | Gestão automática, RLS nativo, custo previsível | Learning curve curto | ✅ Escolhido |

## 3. Decisão
Adotar Clerk para auth + habilitar Row Level Security no Neon usando `auth.jwt()->>'userId'`.

## 4. Consequências
### ✅ Positivas
- Zero gestão manual de tokens
- RLS aplicado em nível de DB (segurança garantida)
- Custo fixo por MAU (previsível)

### ⚠️ Negativas / Riscos
- Migração de usuários legacy → [Mitigação: Script de sync em Inngest]
- Dependência de provider externo → [Mitigação: Abstraction layer `src/lib/auth/`]

### 📊 Impacto Mensurável
| Métrica          | Antes | Depois | Como Validar |
|------------------|-------|--------|--------------|
| Sessão ativa     | 120MB | 8MB    | Vercel Analytics |
| Vazamento sessão | 3/mês | 0      | Sentry logs    |
| Custo infra      | $45   | $38    | Vercel Billing |

## 5. Plano de Execução
- [ ] Atualizar SPEC: docs/SPEC-auth-v2.md
- [ ] Habilitar RLS no Neon + políticas por tenant
- [ ] Migrar login flow em 2 sprints
- [ ] Monitorar `auth_failure_rate` por 14 dias
- [ ] Registrar lição em MEMORY_DNA

## 6. Rastreabilidade
- SPEC: docs/SPEC-auth-v2.md
- Commits: git log --grep="ADR-0012"
- Telemetria: .antigravity-os/[05] TOKENOMICS/[03] cost-telemetry.json
- Aprendizado: .antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json
```

---

## 📊 Métricas de Qualidade do ADR

| Métrica | Alvo | Como Medir |
|---------|------|-----------|
| Tempo de aprovação | < 4h | Timestamp proposta → aceito |
| Rastreabilidade completa | 100% | Links para SPEC, commits, telemetria |
| Impacto mensurável definido | 100% | Tabela de métricas preenchida |
| Revisão cruzada | 100% | BETA + DELTA aprovam |
| Registro em MEMORY_DNA | 100% pós-execução | Arquivo `.json` atualizado |

---

## 🛠️ Comandos Úteis

```bash
# Criar novo ADR
/adr new "Título da decisão"

# Listar ADRs ativos
/adr status

# Revisar ADR pendente
/adr review ADR-[NNNN]

# Arquivar ADR concluído
/adr close ADR-[NNNN]
```

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Invocada via `/adr` ou acionada automaticamente por THETA ao detectar mudança de stack.

**Memória:** Decisões aprovadas geram entrada em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json` com `immunity_scope: "stack_omega"`.

**Budget:** ADRs não consomem budget de execução — são investimento em governança técnica.

**Handoff:** Após aprovação, THETA atualiza `context/CURRENT_AGENT.md` e delega implementação para GAMMA via SPEC atualizada.

**Stack Omega:** Toda decisão deve referenciar `Minhas_Rules/STACK_OMEGA_RULES.md`. Desvios exigem justificativa explícita no campo "Opções Consideradas".
