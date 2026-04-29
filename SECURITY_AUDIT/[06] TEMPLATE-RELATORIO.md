---
name: template_relatorio
description: "Template de relatório de segurança em 4 fases + scorecard"
version: 5.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
status: active
---

# 📄 TEMPLATE DE RELATÓRIO DE SEGURANÇA

> Copie este template e preencha para cada auditoria.
> Salve como `security-report-[PROJETO]-[DATA].md`

---

```markdown
# 🛡️ RELATÓRIO DE SEGURANÇA — [NOME DO PROJETO]

> **Gerado por:** DELTA Auditor Prime
> **Data:** [YYYY-MM-DD]
> **Commit:** [hash]
> **Auditor:** [nome/IA]
> **Versão do Prompt:** v5.0

---

## 📊 SCORECARD DE SEGURANÇA

| Métrica | Valor | Status |
|---------|-------|--------|
| Vulnerabilidades CRÍTICAS | X | 🔴/🟢 |
| Vulnerabilidades ALTAS | X | 🔴/🟢 |
| Vulnerabilidades MÉDIAS | X | 🟡/🟢 |
| Vulnerabilidades BAIXAS | X | 🟢 |
| Anti-Padrões Vibe Coding | [A#, A#] | 🔴/🟢 |
| Leis violadas | [L#, L#] | 🔴/🟢 |
| Checklist Hardening | X/Y (Z%) | 🔴/🟡/🟢 |
| **NOTA GERAL** | **[A-F]** | **[emoji]** |

### Escala de Notas
- **A** = Pronto para produção
- **B** = Menores ajustes necessários
- **C** = Ajustes significativos necessários
- **D** = Vulnerabilidades altas — NÃO deployar
- **F** = Risco crítico imediato — PARE TUDO

---

## 1. RESUMO EXECUTIVO

[Visão geral de 3-5 parágrafos cobrindo: estado geral da segurança, principais riscos encontrados, áreas bem protegidas, recomendação de deploy ou não.]

---

## 2. 🔴 FASE 1: VISÃO DO ATACANTE (Red Team)

### VULN-1: [Nome do Vetor]
| Campo | Detalhe |
|-------|---------|
| **Severidade** | CRÍTICA / ALTA / MÉDIA / BAIXA |
| **Localização** | `arquivo.ts:linha` ou `endpoint` |
| **Tipo** | OWASP A01 / CWE-639 / Anti-Padrão A# |
| **Exploit** | `curl -X POST ...` |
| **Impacto** | O que o atacante obtém |
| **PoC** | Código ou comando para reproduzir |

### VULN-2: [...]
[Repetir para cada vulnerabilidade encontrada]

### Categorias sem vulnerabilidades
✅ Nenhuma vulnerabilidade em [categoria]

---

## 3. 🔵 FASE 2: CÓDIGO BLINDADO (Blue Team)

### Correção VULN-1: [Nome]
**Antes:**
```typescript
// Código vulnerável
```

**Depois:**
```typescript
// 🔒 SEGURANÇA [VULN-1]: [explicação] — CWE-XXX
// Código corrigido
```

[Repetir para cada vulnerabilidade]

---

## 4. 🟢 FASE 3: TESTES DE SEGURANÇA

```typescript
// __tests__/security/[projeto].security.test.ts
import { describe, test, expect } from 'vitest'

describe('Security Tests', () => {
  test('VULN-1: deve rejeitar acesso a recurso de outro usuário (IDOR)', async () => {
    // Arrange / Act / Assert
  })
  
  test('VULN-2: [descrição]', async () => {
    // ...
  })
})
```

---

## 5. ANTI-PADRÕES DE VIBE CODING DETECTADOS

| Código | Anti-Padrão | Onde | Status |
|--------|-------------|------|--------|
| A# | [nome] | `arquivo:linha` | ❌ Detectado / ✅ Limpo |

---

## 6. CHECKLIST DE HARDENING

[Copiar de [05] CHECKLIST-HARDENING.md e marcar ✅/❌]

---

## 7. RECOMENDAÇÕES GERAIS

1. [Recomendação arquitetural]
2. [Recomendação de processo]
3. [...]

---

## 8. PLANO DE MELHORIA (Top 10)

| # | Ação | Prioridade | Responsável | Prazo |
|---|------|------------|-------------|-------|
| 1 | [ ] | 🔴 CRÍTICA | | |
| 2 | [ ] | 🔴 CRÍTICA | | |
| 3 | [ ] | 🟡 ALTA | | |

---

## 9. REFERÊNCIAS

- OWASP Top 10: https://owasp.org/Top10/
- CWE Database: https://cwe.mitre.org/
- [Documentação específica do framework]

---

## 🎯 PRÓXIMA AÇÃO

**Se REPROVADO (D/F):** Retornar para GAMMA (correção) → DELTA re-audita
**Se COM RESSALVAS (B/C):** GAMMA corrige alertas → DELTA re-audita em 7 dias
**Se APROVADO (A):** Liberar para deploy → ZETA otimiza se necessário

---
FIM DO RELATÓRIO
```
