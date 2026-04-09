---
name: idx_global_rules
description: Regras operacionais obrigatórias para modo IDX (Execução). Sempre ativas.
version: 1.0.0
scope: global-idx
enforcement: hard
---

# 🎯 IDX GLOBAL RULES — Sempre Ativas em Modo Execução

> **Aplicação:** Estas regras são carregadas automaticamente no modo IDX. Nunca ignore.

---

## 🔒 SEGURANÇA & COMPLIANCE (Não Negociável)

### 1. Dados Sensíveis
- 🚫 **NUNCA** logue PII (CPF, email, telefone) em texto claro.
- ✅ Use `logger.info('user_action', { userId: 'hashed_abc123' })` — nunca `{ email: 'user@ex.com' }`.
- ✅ Máscara automática: `[REDACTED_CPF]`, `[REDACTED_EMAIL]`.

### 2. Secrets & Variáveis de Ambiente
- 🚫 **NUNCA** commitar `.env` ou valores reais de secrets.
- ✅ Sempre referenciar via `process.env.NOME_DA_VAR`.
- ✅ Validar no startup: `zod.schema().parse(process.env)`.

### 3. LGPD — Direitos do Titular
- ✅ Implementar endpoint `/api/user/data-export` para portabilidade.
- ✅ Implementar `/api/user/delete-account` com soft-delete + TTL 30 dias.
- ✅ Registrar consentimento: `{ userId, purpose, timestamp, ip }`.

---

## ⚡ PERFORMANCE & CUSTO

### 4. Budget de Tokens por Operação
| Tipo de Task | Max Tokens | Alerta em | Ação se Estourar |
|-------------|-----------|-----------|-----------------|
| Code Gen | 8.000 | 6.400 (80%) | Truncar + fallback para modelo menor |
| Debug | 3.000 | 2.400 | Parar + solicitar resumo do usuário |
| API Call | 1.500 | 1.200 | Usar cache + reduzir contexto |

### 5. Cache Obrigatório
- ✅ Cache de embeddings: TTL 24h, chave = `hash(texto + modelo)`.
- ✅ Cache de respostas de LLM: TTL 1h para queries idênticas.
- ✅ Invalidar cache em: mudança de schema, deploy, ou comando `/clear-cache`.

### 6. Rate Limiting de APIs Externas
| Provider | Requests/min | Burst | Estratégia se Estourar |
|----------|-------------|-------|----------------------|
| OpenRouter | 60 | 100 | Fallback para `gpt-4o-mini` + fila |
| Evolution API | 30 | 50 | Queue com Inngest + retry exponencial |
| Resend | 100 | 200 | Batch emails + agendamento |

---

## 🧪 QUALIDADE & TESTES

### 7. Cobertura Mínima de Testes
| Tipo de Feature | Testes Unitários | Testes de Integração | E2E |
|----------------|-----------------|---------------------|-----|
| API Route | ≥ 80% | ≥ 1 cenário happy + 1 error | — |
| Server Action | ≥ 70% | ≥ 1 cenário com DB real | — |
| Componente UI | ≥ 60% | — | ≥ 1 teste Playwright |
| Workflow Inngest | — | ≥ 1 teste de fluxo completo | — |

### 8. Padrão de Resposta de Erro
```typescript
// Sempre retornar este schema em APIs
{
  success: boolean;
  error?: {
    code: string;        // Ex: "VALIDATION_FAILED", "DB_CONNECTION_ERROR"
    message: string;     // Amigável ao usuário
    details?: unknown;   // Detalhes técnicos (apenas em dev)
    requestId: string;   // Para rastreabilidade
  };
  data?: unknown;
}
```

### 9. Logging Estruturado
```typescript
// Níveis obrigatórios
logger.debug()   // Desenvolvimento apenas
logger.info()    // Ações do usuário, fluxos normais
logger.warn()    // Recuperação automática, degradação
logger.error()   // Falha que requer intervenção
logger.fatal()   // Crash iminente — alerta imediato

// Contexto mínimo em TODO log:
{
  requestId: string;
  userId?: string;      // Hash, nunca PII
  agent: string;        // Ex: "GAMMA", "DELTA"
  skill: string;        // Ex: "04_solucionando_erros"
  timestamp: string;    // ISO 8601
}
```

---

## 🤝 PROTOCOLO DE HANDOFF ENTRE AGENTES

### 10. Contrato de Passagem de Contexto
Ao delegar de Agente A → Agente B:
```yaml
handoff:
  from: "THETA"
  to: "GAMMA"
  context:
    intent: "criar_componente_upload"
    constraints: ["stack_omega", "no_external_deps"]
    budget_remaining: 4200
    loaded_skills: ["06_codando", "00_index_skills"]
  validation:
    required_fields: ["intent", "budget_remaining"]
    forbidden_fields: ["secrets", "pii_raw"]
```

### 11. Validação de Entrada do Agente
- ✅ Agente receptor DEVE validar `handoff.context` contra schema Zod.
- ❌ Rejeitar se `budget_remaining < 500` ou `intent` vazio.
- ✅ Logar handoff: `logger.info('agent_handoff', { from, to, intent })`.

---

## 🚦 FEATURE FLAGS & KILL SWITCHES

### 12. Padrão de Feature Flag
```typescript
// src/lib/feature-flags.ts
export const FeatureFlags = {
  ENABLE_AI_CODE_REVIEW: {
    enabled: process.env.ENABLE_AI_CODE_REVIEW === 'true',
    rollout: 0.5,  // 50% dos usuários
    killSwitch: async () => {
      // Lógica para desativar emergencialmente
      return await checkEmergencyOverride();
    }
  }
};

// Uso:
if (FeatureFlags.ENABLE_AI_CODE_REVIEW.enabled && Math.random() < FeatureFlags.ENABLE_AI_CODE_REVIEW.rollout) {
  // Executar feature
}
```

### 13. Kill Switch Global
- ✅ Endpoint `/api/admin/kill-switch` (protegido por Clerk + RBAC).
- ✅ Aceita: `{ feature: string, reason: string, durationMinutes: number }`.
- ✅ Registra em `Logs/kill_switch_audit.log` e notifica via Resend.

---

## 🔄 ATUALIZAÇÃO E AUDITORIA

### 14. Revisão Trimestral de Rules
- ✅ A cada 90 dias, DELTA executa auditoria automática:
  - Verifica conformidade com `IDX_GLOBAL_RULES.md`.
  - Gera relatório em `Logs/rule_compliance_audit.json`.
  - Sugere atualizações se >5 violações detectadas.

### 15. Mudança de Regras
- 🚫 NUNCA alterar `IDX_GLOBAL_RULES.md` durante execução.
- ✅ Processo: PR no repo central → Aprovação de 2 agentes (DELTA + ZETA) → Deploy via `update-core.sh`.

---

## ⚠️ VIOLAÇÕES CRÍTICAS (Bloqueio Imediato)

| Violação | Ação Automática |
|----------|----------------|
| Log de PII em texto claro | Parar execução + notificar DELTA + mascarar log |
| Commit de `.env` com secrets | Rejeitar commit + rotacionar secret + alerta |
| Estouro de budget >95% | Truncar contexto + fallback + registrar em TOKENOMICS |
| Handoff sem validação | Rejeitar + logar violação + solicitar revisão |

---

**Status:** ✅ Ativo | **Última Revisão:** $(date) | **Próxima Auditoria:** +90 dias
