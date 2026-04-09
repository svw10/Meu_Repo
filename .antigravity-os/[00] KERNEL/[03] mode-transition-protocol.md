---
name: mode_transition_protocol
description: Regras de comportamento da IA durante transição GEM ↔ IDX.
version: 1.0.0
framework: "Antigravity OS v3.1"
---

# 🔄 MODE TRANSITION PROTOCOL

## 🎯 Quando Aplicar
- Comando explícito: `/switch-to-gem` ou `/switch-to-idx`
- Handoff natural: SPEC aprovada → muda para IDX | Sprint concluída → muda para GEM
- Detecção automática: THETA identifica mudança de intenção

## ⚙️ Fluxo Obrigatório (IA)

### Passo 1: Executar Script de Estado
```bash
bash .antigravity-os/[08] SUBMODULE_HOOKS/[07] mode-transition.sh --to [gem|idx]
```

### Passo 2: Limpar Contexto (Obrigatório)
- Execute `/clear` ou resuma contexto para `<200 tokens`
- Mantenha APENAS: `CURRENT_AGENT.md`, `PLAN.md` ou `SPEC.md` (conforme modo)
- Descarregue skills do modo anterior

### Passo 3: Carregar Regras do Novo Modo
- **GEM:** Leia `.antigravity-os/[01] CONFIGS/gem-mode-instructions.md`
- **IDX:** Leia `.antigravity-os/[01] CONFIGS/idx-global-instructions.md`

### Passo 4: Anunciar Transição
Responda APENAS:
```
🔄 Modo alterado para [GEM|IDX].
 Regras carregadas. Contexto limpo.
🚀 Pronto para [planejamento|execução].
```

## 🚫 Regras de Segurança
- ❌ Nunca mantenha código ativo ao entrar em GEM
- ❌ Nunca mantenha PRD/Brainstorm ao entrar em IDX
- ❌ Nunca pule `/clear` ou limpeza de contexto
- ✅ Sempre atualize `loaded_skills` em `CURRENT_AGENT.md`
- ✅ Sempre valide budget antes de primeira ação no novo modo

## 🔗 Integração
- Chamado por: THETA (automático) ou Usuário (manual)
- Atualiza: `context/CURRENT_AGENT.md`
- Limpa: Contexto de sessão, skills carregadas, estado de sprint
- Prepara: Ambiente para próximo agente especializado
