name: current_agent
description: Estado atual da sessão Antigravity. Gerado dinamicamente pelo ROUTER.md
version: 3.0.0
---

# ESTADO ATUAL DA SESSÃO

> ⚠️ **ARQUIVO GERADO AUTOMATICAMENTE** - Não edite manualmente
> Última atualização: [SERÁ PREENCHIDO PELO ROUTER]

```yaml
session_id: 
timestamp: 
mode:  # GEM ou IDX

# Intenção detectada
user_intent: 
original_message: 

# Agente ativo
active_agent:  # THETA | ALPHA | BETA | GAMMA | DELTA | EPSILON | ETA | ZETA
agent_status:  # idle | planning | executing | reviewing | error

# Skills carregadas
loaded_skills: []
pending_skills: []

# Workflow (se aplicável)
active_workflow: 
current_step: 
completed_steps: []
pending_steps: []

# Contexto do projeto
project_type:  # saas | landing | undefined
design_system:  # 01_saas | 02_landing | 00_base

# Histórico de ações
action_history: []

# Próxima ação recomendada
next_action: 
next_agent: 
reasoning: 
```

---

## 🎯 INSTRUÇÕES PARA AGENTES

**Quando ler este arquivo:**
1. Verifique `active_agent` - é você? Se sim, execute. Se não, chame o agente correto.
2. Verifique `active_workflow` - há um workflow em andamento? Siga o step atual.
3. Verifique `loaded_skills` - skills já estão no contexto? Não recarregue.
4. Após executar, atualize este arquivo com novo estado.

---

## 🔄 FLUXO DE ATUALIZAÇÃO

```
Usuário envia mensagem
    ↓
ROUTER.md analisa
    ↓
Atualiza CURRENT_AGENT.md
    ↓
Agente ativo lê CURRENT_AGENT.md
    ↓
Agente executa
    ↓
Agente atualiza CURRENT_AGENT.md
```

---
FIM DO CURRENT_AGENT - Estado vazio, aguardando primeira sessão.
```

