---
name: especificando_requisitos
description: "Fase SPECIFY do TLC Spec Driven — Requisitos claros e mensuráveis antes de qualquer arquitetura"
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: THETA + EPSILON
trigger: "/specify | 'novo projeto' | 'quero criar' | gatilho manual antes de /plan"
previous: null
next: 02_planejando_solucoes (BETA)
status: active
tags: [specify, requirements, tlc, discovery, pré-arquitetura]
---

# 00 - ESPECIFICANDO REQUISITOS (Fase SPECIFY)

## 🎯 Quando usar

Antes de qualquer `/plan` (BETA), quando a tarefa envolve:
- Feature nova de médio/alta complexidade (>2 arquivos)
- Integração com sistema externo
- Decisões de negócio ainda não documentadas
- Qualquer tarefa onde os "critérios de done" não estão claros

> **Regra de Ouro:** NUNCA chame BETA (arquitetura) sem `SPECIFICATION.md` aprovado para tarefas complexas.  
> Para tarefas simples (1 arquivo, comportamento óbvio), pode pular direto para `/plan`.

---

## ⚠️ O que NÃO fazer aqui

- ❌ Mencionar ferramentas de implementação ("usar Drizzle", "criar endpoint")
- ❌ Ser vago ("sistema rápido" → deve ser "tempo de resposta <500ms p95")
- ❌ Pular critérios de aceite por parecerem óbvios
- ❌ Misturar requisitos com arquitetura (isso é BETA)

---

## 📋 Template de Saída — SPECIFICATION.md

Arquivo gerado: `docs/SPECIFICATION-[nome-curto].md`

```markdown
# SPECIFICATION: [Nome do Projeto/Feature]
> Gerado por: Fase SPECIFY | Aprovado por: [Humano/THETA] | Data: YYYY-MM-DD

---

## 1. Contexto e Problema
[Descreva a dor do usuário ou necessidade de negócio em 2-5 frases.
Responda: Quem tem o problema? O que está acontecendo? Qual o impacto?]

---

## 2. Requisitos Funcionais (RF)

| ID | Requisito | Critério de Aceite (testável) | Prioridade |
|:---|:---|:---|:---|
| RF-001 | [O sistema DEVE fazer X] | [Dado Y, quando Z, então W] | Must Have |
| RF-002 | [O sistema DEVE fazer X] | [Dado Y, quando Z, então W] | Should Have |
| RF-003 | [O sistema PODE fazer X] | [Dado Y, quando Z, então W] | Nice to Have |

> Cada critério deve ser verificável por DELTA sem ambiguidade.

---

## 3. Requisitos Não-Funcionais (RNF)

| Categoria | Requisito | Métrica |
|:---|:---|:---|
| Performance | Tempo de resposta aceitável | <Xms p95 |
| Segurança | Nível de proteção | [LGPD/Auth/Criptografia] |
| Disponibilidade | SLA esperado | 99.X% |
| Escalabilidade | Volume suportado | X usuários simultâneos |

---

## 4. Restrições

- [ ] Stack Omega obrigatória (ver `Minhas_Rules/STACK_OMEGA_RULES.md`)
- [ ] [Restrição de prazo, se houver]
- [ ] [Integrações obrigatórias]
- [ ] [Dependências de outros sistemas]

---

## 5. Fora do Escopo (Explícito)

O que NÃO será feito nesta iteração:
- [ ] [Feature X — motivo]
- [ ] [Integração Y — motivo]

---

## 6. Checklist de Validação SMART

Antes de passar para BETA:
- [ ] Requisitos são **Específicos**? (sem "deve ser bom")
- [ ] Requisitos são **Mensuráveis**? (com métricas claras)
- [ ] Requisitos são **Atingíveis**? (dentro da Stack Omega)
- [ ] Requisitos são **Relevantes**? (vinculados ao problema)
- [ ] Requisitos têm **Tempo**? (se aplicável)
- [ ] Pelo menos 1 critério de aceite testável por RF?
- [ ] Stakeholder (usuário/Luciano) validou?

---

**Status:** [ ] Rascunho | [ ] Em Revisão | [ ] Aprovado para Arquitetura  
**Aprovado por:** [Nome/Agente]  
**Próximo passo:** `/plan` com BETA → `docs/PLAN-[nome].md`
```

---

## 🔄 Handoff para BETA

THETA só deve acionar BETA quando:
1. `docs/SPECIFICATION-[nome].md` existe
2. Status = `Aprovado para Arquitetura`
3. Todos os RFs têm pelo menos 1 critério de aceite testável
4. Seção "Fora do Escopo" preenchida

> Se o usuário pular esta fase em tarefa complexa, THETA deve avisar:  
> `"⚠️ Sem SPECIFICATION.md para uma tarefa desta complexidade. Recomendo /specify antes do /plan. Continuar mesmo assim? (sim/não)"`

---

## 🔗 Integração com Antigravity OS

| Componente | Papel |
|:---|:---|
| `01_brainstorming.md` | Ideação e contexto inicial (input para esta skill) |
| `[07] SPECS_WARP/[05] spec-creation-protocol.md` | Protocolo de entrevista estruturada para preencher o template |
| `[07] SPECS_WARP/[03] checkpoints-gates.md` | Gate 1 valida PRD; Gate 1.5 é a entrevista; Gate 2 valida SPEC técnica |
| `02_planejando_solucoes.md` | Próxima skill — já exige "SPEC aprovado" como pré-requisito |
| `docs/SPECIFICATION-[nome].md` | Artefato gerado (input para BETA fazer o PLAN) |
