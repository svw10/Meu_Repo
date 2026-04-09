---
name: code_review_checklist
description: Checklist estruturado de revisão de código com níveis de severidade, gate de qualidade e integração com DELTA.
version: 3.1.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
trigger: "/review"
integration: "Antigravity Neural Router"
status: active
tags: [code-review, quality, delta, checklist, pr-template, security]
---

# 05 - CODE REVIEW CHECKLIST (Quality Gate Protocol)

## 🎯 Quando usar
- **SEMPRE** antes de merge em `main` ou `develop`
- Após `GAMMA` finalizar uma feature ou bugfix
- Quando `03_executando_planos` ou `04_solucionando_erros` concluírem
- Gatilho manual: `/review` ou `/check`

> **Regra de Ouro**: Nenhum PR é aprovado sem passar por este checklist. "Aprovar por confiança" é proibido.

## 🚦 Níveis de Severidade (Obrigatórios)

| Nível | Impacto | Ação | Quem decide |
|:---|:---|:---|:---|
| 🔴 **CRÍTICO** | Quebra produção, vaza secrets, falha de segurança | 🛑 **BLOQUEIA MERGE** | DELTA (Automático) |
| 🟠 **BLOQUEANTE** | Falha funcional, regressão, quebra contrato API | 🛑 **BLOQUEIA MERGE** | DELTA + BETA |
| 🟡 **AVISO** | Débito técnico, performance ruim, complexidade alta | ⚠️ **MERGE COM RASTREIO** | DELTA (registra em MEMORY_DNA) |
| 🟢 **SUGESTÃO** | Naming, formatação, micro-otimizações | ✅ **ACEITA COM FIX** | GAMMA (resolve antes de merge) |

## 📋 Checklist de Validação DELTA

### 1. 🔒 Segurança & Compliance (CRÍTICO)
- [ ] Zero secrets/PII no código ou logs
- [ ] Validação Zod em todas as entradas de usuário/API
- [ ] Auth checks em rotas privadas (`middleware.ts` ou Server Action)
- [ ] Sanitização de inputs (prevenção XSS/Injection)
- [ ] Rate limiting em endpoints públicos

### 2. 🏗️ Arquitetura & Stack Omega (BLOQUEANTE)
- [ ] Segue `STACK_OMEGA_RULES.md` (sem libs não autorizadas)
- [ ] Server/Client components separados corretamente (`'use client'` justificado)
- [ ] Database queries otimizadas (sem N+1, usa índices)
- [ ] Estado global apenas quando necessário (Zustand/Context)
- [ ] Lógica de negócio fora de componentes UI

### 3. 🧪 Qualidade & Testes (BLOQUEANTE)
- [ ] Testes unitários cobrem caminhos felizes e erros
- [ ] Testes de integração rodam no CI
- [ ] Cobertura de código ≥ 80% (lógica crítica ≥ 90%)
- [ ] Nenhum `console.log` ou `debugger` em produção
- [ ] Tipagem TypeScript strict (zero `any`, inferência correta)

### 4. ⚡ Performance & UX (AVISO)
- [ ] Imagens otimizadas (`<Image>` ou WebP/AVIF)
- [ ] Bundle size monitorado (< 200KB inicial)
- [ ] Lazy loading em rotas/componentes pesados
- [ ] Core Web Vitals dentro do target (LCP < 2.5s, CLS < 0.1)
- [ ] Loading/Error states implementados

### 5. 📝 Documentação & Manutenção (SUGESTÃO)
- [ ] JSDoc em funções públicas complexas
- [ ] CHANGELOG atualizado com convenção de commits
- [ ] README/docs refletem novas features ou mudanças de API
- [ ] Nomenclatura segue `06_codando.md` (convenções do projeto)

## 🤖 Integração com Agente DELTA

DELTA deve executar este checklist **automaticamente** ao receber `/review`:

1. **Scan Estático**: Roda `tsc`, `lint`, `security-check`, `bundle-analyzer`
2. **Análise de Diff**: Compara alterações com `PLAN.md` e critérios de aceite
3. **Validação Semântica**: Verifica se a implementação resolve o problema original sem efeitos colaterais
4. **Geração de Relatório**: Preenche template abaixo e bloqueia/libera merge

## 📄 Template de Pull Request (Obrigatório)

```markdown
## 🎯 Objetivo
[O que este PR faz e por que é necessário]

## 🔗 Referências
- Plan: `docs/PLAN-[nome].md`
- Task: [Link Jira/GitHub]
- SPEC: `docs/SPEC-[nome].md`

## ✅ Checklist de Validação
- [ ] Build limpo (`npm run build`)
- [ ] Lint & Types passando
- [ ] Testes unitários/integração rodam
- [ ] Nenhuma vulnerabilidade crítica detectada
- [ ] Stack Omega respeitada

## 📊 Métricas
| Métrica | Antes | Depois | Impacto |
|---------|-------|--------|---------|
| Bundle  |       |        |         |
| LCP     |       |        |         |
| Testes  |       |        |         |

## ⚠️ Notas de Review (DELTA)
[DELTA preenche com achados, severidades e ação necessária]

## 🟢 Aprovação
- [ ] DELTA aprovado
- [ ] BETA validou arquitetura (se aplicável)
- [ ] GAMMA corrigiu avisos/sugestões
```

## 🚫 Anti-Padrões (Proibidos)

- ❌ Aprovar PR sem rodar checklist completo
- ❌ Ignorar falhas de tipo "por enquanto"
- ❌ Merge de código não testado em produção
- ❌ Review superficial ("LGTM" sem análise)
- ❌ Ignorar débito técnico classificado como AVISO
- ❌ Alterar contrato de API sem versionamento ou depreciação

## 📊 Métricas de Sucesso

| Métrica | Alvo | Como Medir |
|---------|------|-----------|
| Tempo de Review | < 2h | GitHub Insights |
| Taxa de Rejeição | < 15% | PR Status (closed vs merged) |
| Bugs em Produção | 0/mês | Sentry / Logs |
| Débito Técnico | Redução trimestral | SonarQube / DELTA logs |
| Cobertura de Testes | > 80% | CI Pipeline |

## 🔗 Integração com Sistema v3.1

**Roteamento:** Invocada via `/review` ou pipeline de CI/CD antes do merge.

**Memória:** Falhas recorrentes são registradas em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json` para criar regras de pré-commit automáticas.

**Budget:** Review não consome budget de desenvolvimento — é investimento obrigatório.

**Handoff:** Após aprovação, retoma fluxo em `03_executando_planos` para deploy ou próxima feature.

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Esta skill é invocada via `.antigravity-os/[02] SQUAD_WRAPPERS/` ou Slash Commands.

**Memória:** Erros encontrados devem ser logados em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.

**Budget:** Respeite os limites de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.

**Handoff:** Após execução, atualize `context/CURRENT_AGENT.md` e retorne ao THETA.

**Stack Omega:** Siga rigorosamente `Minhas_Rules/STACK_OMEGA_RULES.md`.
