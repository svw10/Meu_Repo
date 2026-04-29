---
name: threat_modeling
description: "Framework de Modelagem de Ameaças — STRIDE + DREAD + Data Flow Diagrams"
version: 5.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
status: active
tags: [security, threat-modeling, stride, dread]
---

# 🎯 FRAMEWORK DE MODELAGEM DE AMEAÇAS

> Aplique ANTES de implementar. Ameaças não encontradas na modelagem são encontradas pelo atacante.

---

## 📋 Quando Modelar

| Gatilho | Profundidade |
|---------|-------------|
| Novo projeto | Completa (todas as fases) |
| Nova feature com auth/dados/pagamento | Foco na feature + adjacências |
| Integração com terceiro (API, webhook) | Foco no boundary de confiança |
| Mudança de infra (cloud, container) | Foco na camada de infra |
| Incidente de segurança | Retrospectiva + re-modelagem |

---

## FASE 1: DECOMPOSIÇÃO DO SISTEMA

### 1.1 Identificar Atores
| Ator | Nível de Confiança | Exemplos |
|------|-------------------|----------|
| **Usuário anônimo** | Nenhum | Visitante, bot, atacante |
| **Usuário autenticado** | Baixo | Cliente logado |
| **Usuário privilegiado** | Médio | Admin, moderador |
| **Sistema interno** | Alto | Backend, worker, cron |
| **Terceiro confiável** | Médio | Webhook Stripe, Clerk |
| **LLM/IA** | Nenhum | Output tratado como não confiável |

### 1.2 Identificar Boundaries de Confiança
```
┌─────────────────────────────────────────────┐
│                  INTERNET                    │
│  ┌─────────┐                                │
│  │ Browser │ ──── [BOUNDARY 1: CDN/WAF] ─── │
│  └─────────┘                                │
│                                              │
│  ┌──────────────────────────────────────┐   │
│  │         REVERSE PROXY (Nginx)         │   │
│  │  ── [BOUNDARY 2: App Server] ──       │   │
│  │  ┌──────────────────────────────┐     │   │
│  │  │    APLICAÇÃO (Next.js)       │     │   │
│  │  │  ── [BOUNDARY 3: DB] ──     │     │   │
│  │  │  ┌───────────────────────┐   │     │   │
│  │  │  │  DATABASE (Neon/PG)   │   │     │   │
│  │  │  └───────────────────────┘   │     │   │
│  │  │  ── [BOUNDARY 4: APIs] ──   │     │   │
│  │  │  ┌───────────────────────┐   │     │   │
│  │  │  │  TERCEIROS (Stripe,   │   │     │   │
│  │  │  │  Clerk, OpenAI)       │   │     │   │
│  │  │  └───────────────────────┘   │     │   │
│  │  └──────────────────────────────┘     │   │
│  └──────────────────────────────────────┘   │
└─────────────────────────────────────────────┘
```

### 1.3 Identificar Fluxos de Dados
| Fluxo | De → Para | Dados | Sensibilidade |
|-------|-----------|-------|---------------|
| Login | Browser → App | email, senha | 🔴 ALTA |
| Checkout | App → Stripe | valor, cartão | 🔴 ALTA |
| Chat IA | App → OpenAI | mensagem, contexto | 🟡 MÉDIA |
| Webhook | Stripe → App | evento pagamento | 🟡 MÉDIA |
| Assets | CDN → Browser | imagens, JS | 🟢 BAIXA |

---

## FASE 2: ANÁLISE STRIDE

Para cada componente/fluxo, analise as 6 categorias:

| Categoria | Pergunta | Exemplo de Ameaça |
|-----------|----------|-------------------|
| **S**poofing | Alguém pode fingir ser outro? | JWT forjado, session hijacking |
| **T**ampering | Dados podem ser alterados em trânsito? | Man-in-the-middle, parameter tampering |
| **R**epudiation | Ações podem ser negadas sem prova? | Logs ausentes, sem audit trail |
| **I**nformation Disclosure | Dados podem vazar? | Error messages, API over-fetching |
| **D**enial of Service | Serviço pode ser derrubado? | DDoS, ReDoS, resource exhaustion |
| **E**levation of Privilege | Usuário pode escalar permissões? | IDOR, role injection, admin bypass |

### Template de Análise STRIDE
```markdown
### [Componente/Fluxo]: Login Flow

| Ameaça | Categoria | Mitigação | Status |
|--------|-----------|-----------|--------|
| Credential stuffing | S | Rate limiting + CAPTCHA | ✅ |
| Password brute force | S | Login throttling | ✅ |
| Session hijacking | S | HttpOnly + Secure cookies | ✅ |
| Token tampering | T | JWT verify (RS256) | ✅ |
| No audit trail | R | Structured logging | ❌ TODO |
| Error message leak | I | Mensagens genéricas | ✅ |
| Login DDoS | D | Rate limit + WAF | ✅ |
| Role escalation | E | Server-side role check | ✅ |
```

---

## FASE 3: CLASSIFICAÇÃO DREAD

Pontue cada ameaça de 1 a 10:

| Fator | Significado | 1 (baixo) | 10 (alto) |
|-------|------------|-----------|-----------|
| **D**amage | Qual o dano? | Info disclosure | Data breach total |
| **R**eproducibility | Quão fácil reproduzir? | Condições raras | Sempre |
| **E**xploitability | Quão fácil explorar? | Precisa de insider | Script kiddie |
| **A**ffected Users | Quantos afetados? | 1 usuário | Todos |
| **D**iscoverability | Quão fácil descobrir? | Precisa código-fonte | Visível na URL |

**Score DREAD = (D + R + E + A + D) / 5**

| Score | Prioridade | Ação |
|-------|-----------|------|
| 8-10 | 🔴 CRÍTICA | Resolver antes do deploy |
| 5-7 | 🟡 ALTA | Resolver na sprint atual |
| 3-4 | 🟢 MÉDIA | Próxima sprint |
| 1-2 | ⚪ BAIXA | Backlog |

---

## FASE 4: PLANO DE MITIGAÇÃO

### Template
| ID | Ameaça | STRIDE | DREAD | Mitigação | Lei | Status |
|----|--------|--------|-------|-----------|-----|--------|
| T-001 | IDOR em /api/orders | E | 8.2 | Filtro ownership (LEI 6) | L6 | ❌ |
| T-002 | Prompt injection | T,E | 7.4 | Guardrails pipeline | L19 | ✅ |

---

## 📊 Saída Esperada

Ao final da modelagem, você deve ter:
1. **Diagrama** de trust boundaries
2. **Tabela STRIDE** por componente
3. **Score DREAD** por ameaça
4. **Plano de mitigação** priorizado
5. **ADR** para decisões de segurança significativas

---

## 🔗 Referências

- Microsoft Threat Modeling Tool: https://aka.ms/threatmodeling
- OWASP Threat Modeling Cheat Sheet: https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html
- STRIDE per Element: https://docs.microsoft.com/en-us/azure/security/develop/threat-modeling-tool
