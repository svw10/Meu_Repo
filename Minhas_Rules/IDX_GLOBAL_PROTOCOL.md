---
name: idx_global_protocol
description: Regras globais obrigatórias para modo IDX (Execução). Foco: contexto limpo, atomicidade e segurança operacional.
version: 1.0.0
scope: idx_only
enforcement: hard
---

# 🎯 IDX GLOBAL PROTOCOL — Sempre Ativo em Execução

## 🧠 1. ENGENHARIA DE CONTEXTO (Zero Poluição)
- **Entrada:** Máx 3 arquivos abertos simultaneamente. Use `@file:path` ou `@skill:XX` em vez de colar código.
- **Sessão:** Execute `/clear` ao trocar de feature. Mantenha `context/CURRENT_AGENT.md` atualizado, nunca edite manualmente.
- **Histórico:** Não repita instruções já carregadas. Referencie `PLAN.md` ou `SPEC` por ID.
- **Limite:** Se `used_tokens > 75%`, force compactação: resuma contexto para `<200 tokens` + links simbólicos.

## 📁 2. OPERAÇÕES DE ARQUIVO (Atomicidade)
- **Caminhos:** Só escreva em `src/`, `docs/`, `Minhas_Skills/`, `Agentes/`, `.env*`. Bloqueie `node_modules/`, `.next/`, `.git/`.
- **Backup:** Antes de sobrescrever arquivos críticos (`schema.ts`, `middleware.ts`, `auth/`), crie `.bak` ou commit separado.
- **Formato:** TypeScript strict, Tailwind puro, componentes atômicos. Proibido CSS global ou `any`.
- **Validação:** Todo arquivo novo deve passar `tsc --noEmit` + `biome lint` antes de considerar "pronto".

## 🔄 3. GIT & COMMIT (IDX)
- **Atomicidade:** 1 commit = 1 step do plano. Nunca misture features.
- **Mensagem:** `tipo(escopo): descrição curta\n\nRefs: PLAN-[id] Passo X`
- **Hooks:** Rode `security-scan.sh` antes de commit. Se falhar, corrija PII/Secrets/Paths.
- **Branch:** `feature/[nome]` ou `fix/[id]`. Merge só após aprovação do DELTA.

## 🛑 4. RECUPERAÇÃO & ESCALONAMENTO
- **Retry:** Máx 2 tentativas automáticas por erro. Na 3ª, pare e registre em `MEMORY_DNA`.
- **Fallback:** Se budget estourar ou loop detectado, execute `/clear`, recarregue apenas sprint atual e notifique THETA.
- **Escalar:** Chame humano se: (1) erro persistir >3x, (2) arquitetura precisar mudar, (3) segurança crítica violada.

## ⚠️ VIOLAÇÕES IMEDIATAS
| Ação | Consequência |
|------|-------------|
| Colar arquivo inteiro no prompt | Truncar + forçar `@ref` |
| Commit sem validação tsc/lint | Rejeitar + acionar DELTA |
| Modificar `Nucleo/` ou `.antigravity-os/` | Reverter + alerta crítico |
| Ignorar `PLAN.md` ou `SPEC` | Pausar execução + solicitar realinhamento |

---
**Status:** ✅ Ativo | **Carga:** Leitura obrigatória no startup do IDX
