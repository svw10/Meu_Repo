# [01] FEEDBACK LOOP PROTOCOL — Loop de Autocorreção

> **Versão:** 1.0.0  
> **Owner:** THETA (Orchestrator)  
> **Integra com:** DELTA (Auditor) · ETA (Investigator) · GAMMA (Builder) · `[04] MEMORY_DNA/`  
> **Schema de estado:** `.antigravity-os/[04] MEMORY_DNA/[05] correction-state-schema.json`

---

## 🎯 Propósito

Transformar o fluxo linear de execução em um **ciclo de qualidade resiliente**. Quando um agente produtor (GAMMA ou ETA) gera output que falha na validação do DELTA, o sistema devolve o trabalho ao agente correto com contexto completo do erro — ao invés de falhar ou retornar pro zero.

---

## 🔄 Fluxo: Linear vs. Cíclico

### ❌ Antes (Linear — frágil)
```
GAMMA executa → DELTA valida → FALHA → fim (retrabalho manual)
```

### ✅ Agora (Cíclico — resiliente)
```
GAMMA executa
    ↓
DELTA valida
    ↓ (se REJECTED)
THETA lê CorrectionState → incrementa attemptCount
    ↓
    ├── attemptCount ≤ 3 → retorna ao agente produtor com feedback estruturado
    └── attemptCount > 3 → ESCALAÇÃO: notifica humano + registra em MEMORY_DNA
```

---

## 📐 Estados do Loop de Correção

O THETA mantém estado no `context/CURRENT_AGENT.md` durante o ciclo:

```yaml
# context/CURRENT_AGENT.md — campos adicionados pelo Feedback Loop
correction_loop:
  active: true | false
  attempt_count: 0          # máx 3
  max_attempts: 3
  return_to: GAMMA | ETA    # agente que deve corrigir
  failed_at_step: string    # "fase 2 da auditoria" ou "gate 4"
  issues:
    - "Sem validação Zod no endpoint /api/user"
    - "API key hardcoded em config.ts:15"
  original_output_ref: string  # referência ao Logs/sprint-[id]-output.md
  last_correction_at: ISO8601
  escalated: false
```

---

## ⚙️ Protocolo Passo a Passo (THETA executa)

### PASSO 1 — DELTA emite veredito REJECTED

DELTA gera `AUDIT_REPORT.md` com status `🔴 REPROVADO` e lista de `critical_issues`.

DELTA atualiza `context/CURRENT_AGENT.md`:
```yaml
active_agent: DELTA
agent_status: rejected
return_to: GAMMA         # ou ETA se for bug de investigação
critical_issues:
  - [lista dos bloqueantes]
```

---

### PASSO 2 — THETA intercepta e verifica tentativas

THETA lê `correction_loop.attempt_count` do `CURRENT_AGENT.md`.

```
SE attempt_count < max_attempts (3):
    → Executa PASSO 3 (retornar ao agente)

SE attempt_count >= max_attempts:
    → Executa PASSO 5 (ESCALAÇÃO)
```

---

### PASSO 3 — Preparar contexto de correção

THETA monta o **Correction Briefing** e injeta no contexto do agente produtor:

```markdown
## 🔁 CORRECTION BRIEFING — Tentativa [N] de 3

**Retornando para:** [GAMMA|ETA]
**Motivo da reprovação:** [resumo em 1 linha]
**Gate que falhou:** Gate [X] — [nome]

### ❌ Problemas a corrigir (OBRIGATÓRIO):
1. [issue crítico com localização exata]
2. [issue crítico com localização exata]

### ⚠️ Alertas (melhorar se possível):
- [alerta 1]

### 📦 Output original:
> Referência: Logs/sprint-[id]-output-attempt-[N-1].md

### ✅ Critérios para aprovação:
- [critério 1 do acceptance_criteria da sprint]
- [critério 2]
```

---

### PASSO 4 — Agente produtor executa correção

- **GAMMA** corrige o código conforme os issues apontados
- **ETA** investiga e resolve causas raiz de bugs
- O output corrigido é logado em `Logs/sprint-[id]-output-attempt-[N].md`
- DELTA re-audita automaticamente (volta ao PASSO 1)
- `attempt_count` incrementa +1

---

### PASSO 5 — ESCALAÇÃO (> 3 tentativas)

Se `attempt_count > max_attempts`, **nunca falhe silenciosamente**:

```
THETA executa ESCALAÇÃO:
    1. Marca sprint como "blocked" no CURRENT_AGENT.md
    2. Exibe ao usuário:
       "⚠️ ATENÇÃO: A sprint [ID] falhou 3 vezes na auditoria.
        Intervenção humana necessária antes de prosseguir.
        Problemas recorrentes: [lista]"
    3. Registra em MEMORY_DNA:
       - mutation: "correction_loop_exhausted"
       - agent_involved: [GAMMA|ETA]
       - vaccine: [plano de prevenção]
    4. Aguarda instrução do usuário — NÃO continua automaticamente
```

---

## 🗺️ Mapeamento: Tipo de Falha → Agente de Retorno

| Tipo de Falha no DELTA | Retornar Para | Motivo |
|:---|:---|:---|
| Código incorreto / lógica errada | **GAMMA** | É implementação — requer reescrita |
| Bug / exceção não tratada / race condition | **ETA** | Exige investigação de causa raiz |
| Falta de validação Zod / segurança | **GAMMA** | Ajuste de implementação |
| Secret exposto / PII vazado | **GAMMA** + alerta humano | Crítico — pode exigir revisão de arquitetura |
| TypeScript errors / lint | **GAMMA** | Correção de código |
| Falha em teste de performance | **ZETA** | Especialidade de otimização |

---

## 📊 Logging Obrigatório por Ciclo

A cada iteração do loop, registrar em `Logs/feedback-loop.log`:

```yaml
# Logs/feedback-loop.log — entrada por ciclo
sprint_id: "sprint-001"
attempt: 2
timestamp: "2026-04-12T10:00:00Z"
delta_verdict: "REJECTED"
failed_gate: "Gate 4 — Acceptance Test"
issues_count: 2
critical_issues:
  - "Sem autenticação no endpoint /api/user"
  - "Console.log em produção: src/lib/db.ts:42"
returned_to: "GAMMA"
escalated: false
```

---

## 🛡️ Regras Anti-Abuso

| Regra | Detalhe |
|:---|:---|
| **Máximo 3 tentativas** | Após isso, bloqueio total e escalação humana |
| **Preserve o contexto original** | Cada tentativa referencia a anterior em `Logs/` |
| **Nunca repita o mesmo feedback** | O Correction Briefing DEVE incluir novos detalhes se disponíveis |
| **Sem loop infinito** | `attempt_count` é validado ANTES de iniciar qualquer correção |
| **Escalação é saída digna** | Não é falha — é fail-safe. MEMORY_DNA aprende com ela |

---

## 🔗 Integração com o Ecossistema

| Componente | Papel |
|:---|:---|
| `[04] MEMORY_DNA/[05] correction-state-schema.json` | Schema formal do estado de correção |
| `[07] SPECS_WARP/[03] checkpoints-gates.md` | Gate 4 dispara este protocolo quando falha |
| `Agentes/DELTA_Auditor.md` | Emite veredito + lista de issues |
| `Agentes/THETA_Orchestrator.md` | Lê estado, decide retorno ou escalação |
| `context/CURRENT_AGENT.md` | Estado vivo do loop entre ciclos |
| `Logs/feedback-loop.log` | Audit trail completo de tentativas |

---

## ✅ Checklist de Ativação

Antes de ativar este protocolo em uma sprint, confirme:

- [ ] Sprint tem `acceptance_criteria` definidos (Gate 2)
- [ ] DELTA está configurado como validador (Gate 4)
- [ ] `context/CURRENT_AGENT.md` tem campo `correction_loop` inicializado
- [ ] `Logs/` está acessível para escrita
- [ ] `max_attempts` está definido (padrão: 3)
- [ ] Usuário foi informado sobre o mecanismo de escalação

---

> 💡 **Princípio:** O Feedback Loop não é punição — é aprendizado estruturado. Cada ciclo que falha alimenta o MEMORY_DNA com vacinas que previnem a mesma falha nos próximos projetos.
