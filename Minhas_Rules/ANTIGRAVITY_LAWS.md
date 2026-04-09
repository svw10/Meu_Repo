name: antigravity_laws
description: Leis absolutas do Antigravity OS. Quebrar = falha de auditoria.
version: 3.0.0
---

# LEIS DE ANTIGRAVITY

> **LEI ZERO:** Se não está documentado, não existe.
> **LEI ZERO-B:** Se não está tipado, não compila.

---

## 🔴 LEI 1 - STACK OMEGA É LEI

**Texto:** Use apenas tecnologias da Stack Omega v3.0.

**Consequência de violação:** Rejeição imediata por DELTA, rollback obrigatório.

**Exceção:** ADR aprovado por BETA com assinatura digital.

---

## 🔴 LEI 2 - LAZY LOADING OBRIGATÓRIO

**Texto:** Carregue apenas o necessário, quando necessário.

**Proibido:**
- Carregar `FABRICA_SOFTWARE.md` no fluxo normal
- Carregar `GUIA_OPERACIONAL.md` no IDX
- Carregar todas as skills "por garantia"

**Obrigatório:**
- ROUTER.md → CURRENT_AGENT.md → [agente específico] → [skill específica]

---

## 🔴 LEI 3 - GEM NÃO EXECUTA, IDX NÃO PLANEJA

**Texto:** Separação absoluta de ambientes.

**GEM (Planejamento):**
- ✅ Gera PLAN.md
- ✅ Gera prompts para IDX
- ❌ NUNCA executa código
- ❌ NUNCA cria arquivos físicos

**IDX (Execução):**
- ✅ Executa código
- ✅ Cria arquivos
- ❌ NUNCA gera PLAN.md se pedido "implementar"
- ❌ NUNCA planeja se há PLAN.md pronto

---

## 🔴 LEI 4 - AGENTES NÃO CONFLITAM

**Texto:** Um agente ativo por vez, exceto workflows orquestrados.

**Proibido:**
- Dois agentes tomando decisões simultâneas
- Agente executar fora de sua especialidade

**Permitido:**
- Workflow chamar agentes em sequência (ETA → GAMMA → DELTA)
- THETA delegar e supervisionar

---

## 🔴 LEI 5 - LOGS ANTES DO ERRO

**Texto:** Todo ponto crítico deve ter interceptor de log.

**Obrigatório logar:**
- Entrada/saída de agentes
- Chamadas LLM (tokens, latência)
- Erros antes do crash
- Transições de workflow

**Consequência:** Sem log, não há debug. Sem debug, há repetição de erro.

---

## 🔴 LEI 6 - DESIGN É ESTRATÉGICO

**Texto:** SAAS e Landing Page são diferentes. Nunca misture.

**SAAS/Dashboard:**
- Use `Minhas_Skills/06_criando_ui.md`
- Use `Ui_Kit_Design/01_saas/`
- Foco: funcionalidade, densidade de informação

**Landing Page:**
- Use `Minhas_Skills/07_ux_pro_max.md`
- Use `Ui_Kit_Design/02_landing/`
- Foco: conversão, storytelling, impacto visual

---

## 🔴 LEI 7 - COMMITS SÃO ATÔMICOS

**Texto:** Um commit por step executado com sucesso.

**Proibido:**
- Commitar código quebrado
- Commitar múltiplas features
- "Commitar depois" (nunca chega)

**Obrigatório:**
- Validação antes de commit
- Mensagem descritiva: `feat: [step] - [descrição]`

---

## 🔴 LEI 8 - EVOLUÇÃO DOCUMENTADA

**Texto:** Cada execução melhora o sistema.

**Obrigatório:**
- Erros novos → skill `12_solucionando_erros.md`
- Padrões novos → snippets reutilizáveis
- Workflows novos → `Workflows/recipes/`

**Proibido:**
- Resolver erro sem documentar solução
- Copiar código sem generalizar para snippet

---

## ⚖️ PENA DE VIOLAÇÃO

| Lei | 1ª violação | 2ª violação | 3ª violação |
|:---|:---|:---|:---|
| 1, 2, 3 | Alerta DELTA | Rollback obrigatório | Bloqueio de execução |
| 4, 5, 6 | Correção imediata | Treinamento ZETA | Revisão arquitetural |
| 7, 8 | Commit revertido | Documentação forçada | Exclusão de padrão |

---
FIM DAS LEIS - Disciplina é liberdade.