# 🧬 ANTIGRAVITY OS - ESTRUTURA COMPLETA


## Arquivo: .antigravity-os/[99] INDEX.md


``text

# ðŸ§¬ ANTAGRAVITY OS NEURAL â€” ÃNDICE MESTRE v3.1

> **PropÃ³sito:** Mapa de navegaÃ§Ã£o para IA e humanos. Leia isto primeiro para entender a ordem de execuÃ§Ã£o, modo atual e prÃ³ximos passos.

---

## ðŸš¦ Modo Atual: [DETECTAR AUTOMATICAMENTE]

| Modo | Ambiente | Permitido | Proibido | PrÃ³ximo Passo |
|------|----------|-----------|----------|---------------|
| **GEM** (Planejamento) | Google AI Studio, Chat | PRD, SPEC, Arquitetura, Brainstorm | Escrever cÃ³digo, commitar, executar | Leia `[00] KERNEL/` â†’ `[07] SPECS_WARP/` |
| **IDX** (ExecuÃ§Ã£o) | VSCode, Cursor, Terminal | Codar, testar, debugar, commitar | Gerar PRD, mudar arquitetura sem aprovaÃ§Ã£o | Leia `[00] KERNEL/` â†’ `[02] AGENTS/` |

> ðŸ” **DetecÃ§Ã£o AutomÃ¡tica:** Consulte `[00] KERNEL/[00] quantum-loader.md` para regras de detecÃ§Ã£o.

---

## ðŸ—ºï¸ Mapa de ExecuÃ§Ã£o Enumerado (Ordem ObrigatÃ³ria)

```
[00] KERNEL/          â† SEMPRE carregado primeiro
  â”œâ”€â”€ [00] quantum-loader.md      # Detecta modo GEM/IDX + fallback seguro
  â”œâ”€â”€ [01] mode-router.json       # Regras de transiÃ§Ã£o entre modos
  â””â”€â”€ [02] token-budget-controller.json # Limites de tokens por tarefa

[01] CONFIGS/         â† ConfiguraÃ§Ãµes globais
  â”œâ”€â”€ [00] tier-matrix.json       # Matriz: task â†’ tokens â†’ model â†’ fallback
  â”œâ”€â”€ [01] model-routing.md       # Thresholds de confianÃ§a + escape hatch
  â””â”€â”€ sessions/                   # Estado da sessÃ£o atual (context, health)

[02] AGENTS/          â† Metadados dos 8 agentes
  â”œâ”€â”€ [00] orchestration-exec.md  # LÃ³gica de roteamento executÃ¡vel
  â”œâ”€â”€ [01] registry.json          # CatÃ¡logo de agentes
  â””â”€â”€ [00-07] *-meta.json         # Wrappers: custo, trigger, fallback

[03] SKILLS_ENGINE/   â† Indexador de Minhas_Skills/
  â”œâ”€â”€ [00] skills-constellation.json # Mapeamento de 12 skills
  â”œâ”€â”€ [01] retrieval-decision-matrix.json # RAG vs Grep vs Lexical
  â””â”€â”€ [02] lazy-loader.md         # Protocolo de import sob demanda

[04] MEMORY_DNA/      â† Aprendizado cross-project
  â”œâ”€â”€ [00] error-dna-registry.json # Erros + vacinas + prevention prompts
  â”œâ”€â”€ [01] anti-patterns-vault.md # Banco de "Nunca Repita"
  â”œâ”€â”€ [02] prevention-injector.md # Como injetar imunidade no contexto
  â””â”€â”€ [03] cross-project-sync.md  # Sync seguro via HTTPS + sanitizaÃ§Ã£o

[05] TOKENOMICS/      â† Economia avanÃ§ada de tokens
  â”œâ”€â”€ [00] tier-strategy.md       # Senior Mode, Differential Updates, Pruning
  â”œâ”€â”€ [01] symbolic-refs.md       # Uso de @file, @schema, @skill
  â”œâ”€â”€ [02] differential-updates.md # Protocolo SEARCH/REPLACE
  â””â”€â”€ [03] cost-telemetry.json    # Telemetria em tempo real

[06] SECURITY_DRL/    â† SeguranÃ§a e compliance
  â”œâ”€â”€ [00] pii-sanitization.md    # DetecÃ§Ã£o e masking de dados sensÃ­veis
  â”œâ”€â”€ [01] secrets-vault.json     # Protocolo zero-exposure para .env
  â”œâ”€â”€ [02] frontend-inspector.md  # Auditoria de cÃ³digo client-side
  â””â”€â”€ [03] submodule-guard.md     # ProteÃ§Ã£o do nÃºcleo contra ediÃ§Ãµes locais

[07] SPECS_WARP/      â† EspecificaÃ§Ã£o de produtos
  â”œâ”€â”€ [00] prd-business-template.md # Template focado em negÃ³cio (sem cÃ³digo)
  â”œâ”€â”€ [01] spec-technical-schema.ts # ValidaÃ§Ã£o Zod para SPEC tÃ©cnica
  â”œâ”€â”€ [02] sprint-isolation.md    # 1 sprint = 1 contexto limpo
  â””â”€â”€ [03] checkpoints-gates.md   # PortÃµes de qualidade obrigatÃ³rios

[08] SUBMODULE_HOOKS/ â† AutomaÃ§Ã£o e Git
  â”œâ”€â”€ [00] init-submodule.sh
  â”œâ”€â”€ [01] update-core.sh
  â”œâ”€â”€ [02] validate-structure.sh
  â”œâ”€â”€ [03] sync-memory.sh
  â”œâ”€â”€ [04] generate-evolution-log.sh
  â””â”€â”€ [05] retro-collector.sh

[09] RETROSPECTIVE/   â† Aprendizado ContÃ­nuo
  â”œâ”€â”€ [00] project-sweeper.md  # Workflow /retro
  â””â”€â”€ evolution-log.md         # HistÃ³rico de versÃµes
```

---

## ðŸ§­ Fluxo RÃ¡pido por CenÃ¡rio

### ðŸ†• Novo Projeto
```bash
1. bash .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh
2. Configure .cursorrules na raiz (apontando para [00] KERNEL/)
3. Leia este INDEX.md â†’ [00] KERNEL/[00] quantum-loader.md
4. Inicie com BETA (Architect) para gerar PRD
```

### ðŸ’» Desenvolvimento DiÃ¡rio (IDX)
```
1. IA lÃª: .cursorrules â†’ [00] KERNEL/ â†’ [01] ORCHESTRATOR/
2. THETA classifica tarefa â†’ valida budget â†’ seleciona agente
3. GAMMA executa com budget definido â†’ DELTA valida â†’ commit
4. Erro? Registra em [04] MEMORY_DNA/ â†’ gera prevention_prompt
```

### ðŸ§  Planejamento EstratÃ©gico (GEM)
```
1. IA lÃª: [00] KERNEL/ (modo GEM) â†’ [07] SPECS_WARP/[00] prd-business-template.md
2. BETA gera PRD â†’ valida com gates â†’ aprova para SPEC
3. THETA converte PRD â†’ SPEC tÃ©cnica com Zod validation
4. Exporta para IDX com plano de sprints atÃ´micas
```

### ðŸ” Debug/InvestigaÃ§Ã£o
```
1. Consulta [04] MEMORY_DNA/[00] error-dna-registry.json por match
2. Se encontrado: injeta prevention_prompt + aplica vaccine
3. Se novo: ETA investiga â†’ registra erro â†’ gera nova vacina
4. Atualiza [05] TOKENOMICS/[03] cost-telemetry.json com mÃ©tricas
```

---

## ðŸ“š IntegraÃ§Ã£o com Estrutura Existente

| Pasta Antigravity | Aponta Para (Projeto Pai) | FunÃ§Ã£o |
|------------------|---------------------------|--------|
| `[02] AGENTS/` | `Agentes/` | Metadados de custo, trigger e fallback |
| `[03] SKILLS_ENGINE/` | `Minhas_Skills/` | Ãndice lazy-load com decisÃ£o RAG/Grep |
| `[01] ORCHESTRATOR/` | `context/ROUTER.md` | Wrapper com validaÃ§Ã£o de budget |
| `[07] SPECS_WARP/` | `Nucleo/03_Competencias/` | Templates com gates de aprovaÃ§Ã£o |
| `[04] MEMORY_DNA/` | `Logs/` | Registro de erros com prevenÃ§Ã£o ativa |

> âš ï¸ **Regra de Ouro:** Nunca edite `.antigravity-os/` diretamente. Use `[08] SUBMODULE_HOOKS/` para atualizaÃ§Ãµes.

---

## âš¡ Comandos RÃ¡pidos para IA

```
/clear          â†’ Limpa contexto entre sprints (obrigatÃ³rio)
/compact        â†’ Resume contexto aos 60% de uso
/context        â†’ Mostra estado atual + budget restante
/cost           â†’ Exibe telemetria da sessÃ£o atual
/sync-memory    â†’ ForÃ§a atualizaÃ§Ã£o de MEMORY_DNA cross-project
/plan           â†’ Ativa modo BETA para planejamento
/build          â†’ Ativa modo GAMMA para execuÃ§Ã£o
/audit          â†’ Aciona DELTA para revisÃ£o prÃ©-commit
/retro          â†’ Dispara o Project Sweeper (aprendizado pÃ³s-projeto)
```

---

## ðŸ†˜ SoluÃ§Ã£o de Problemas

| Sintoma | Causa ProvÃ¡vel | SoluÃ§Ã£o |
|---------|---------------|---------|
| IA ignora budget | `[00] KERNEL/[02]` nÃ£o carregado | Force leitura: "Leia token-budget-controller.json" |
| Agente nÃ£o ativa | Wrapper em `[02] SQUAD_WRAPPERS/` com path errado | Valide `source_file` vs pasta real |
| Erro de caminho | `Minhas Skills` vs `Minhas_Skills` | Use sempre underscore: `Minhas_Skills/` |
| Contexto poluÃ­do | Sprint sem `/clear` anterior | Execute `/clear` + recarregue apenas sprint atual |
| Secret vazado | `[06] SECURITY_DRL/` nÃ£o aplicado | Ative pre-commit hook + sanitize antes de enviar |

---

## ðŸ”„ AtualizaÃ§Ã£o do Framework

```bash
# Verificar versÃ£o atual
cat .antigravity-os/[99] INDEX.md | grep "v"

# Atualizar para Ãºltima versÃ£o
bash .antigravity-os/[08] SUBMODULE_HOOKS/[01] update-core.sh

# Validar integridade pÃ³s-update
bash .antigravity-os/[08] SUBMODULE_HOOKS/[02] validate-structure.sh
```

---

> âœ¨ **Dica Final:** Se em dÃºvida sobre qual arquivo ler, volte a este INDEX.md. Ele Ã© o ponto de entrada Ãºnico para toda a inteligÃªncia do Antigravity OS Neural.

**VersÃ£o:** 3.1.0  
**Ãšltima AtualizaÃ§Ã£o:** $(date)  
**RepositÃ³rio Central:** https://github.com/svw10/Meu_Repo

``

---


## Arquivo: .antigravity-os/[00] KERNEL/[00] quantum-loader.md


``text

# [00] QUANTUM LOADER â€” DetecÃ§Ã£o de Modo

## PropÃ³sito
Identificar se o ambiente atual Ã© de **Planejamento (GEM)** ou **ExecuÃ§Ã£o (IDX)** para aplicar as regras corretas de seguranÃ§a e token budget.

##  MODO GEM (Google AI Studio / Planejamento)
- **Foco:** Arquitetura, PRD, Brainstorming, EstruturaÃ§Ã£o.
- **Regra de Ouro:** NÃƒO escreva cÃ³digo no repositÃ³rio. NÃƒO execute comandos.
- **AÃ§Ã£o:** Gere planos (Markdown), esquemas e instruÃ§Ãµes claras para o Modo IDX.
- **Skills:** Use `Minhas_Skills/ESTRATEGIA_DISCOVERY/`.

## ðŸ”µ MODO IDX (VSCode / Cursor / ExecuÃ§Ã£o)
- **Foco:** Codar, Debugar, Testar, Commitar.
- **Regra de Ouro:** Siga rigorosamente o plano definido no Modo GEM. NÃ£o invente features novas sem aprovaÃ§Ã£o.
- **AÃ§Ã£o:** Edite arquivos, rode testes, valide seguranÃ§a.
- **Skills:** Use `Minhas_Skills/EXECUCAO_IMPLEMENTACAO/`.

## ðŸ” Como Detectar
1. Se houver pastas como `app/`, `pages/`, `src/` com cÃ³digo implementado â†’ **MODO IDX**.
2. Se o usuÃ¡rio pedir "planejar", "criar PRD", "brainstorm" â†’ **MODO GEM**.
3. Na dÃºvida â†’ **MODO IDX** (mas valide o budget primeiro).

``

---


## Arquivo: .antigravity-os/[00] KERNEL/[01] mode-router.json


``text

{
  "version": "3.1.0",
  "modes": {
    "GEM": {
      "agents": [
        "THETA",
        "BETA",
        "EPSILON",
        "ALPHA"
      ],
      "forbidden": [
        "write_file",
        "execute_code"
      ]
    },
    "IDX": {
      "agents": [
        "THETA",
        "GAMMA",
        "DELTA",
        "ZETA",
        "ETA"
      ],
      "requires": "PLAN.md"
    }
  },
  "fallback": "IDX_safe_mode",
  "transition": "GEM\u2192PLAN\u2192IDX\u2192EXEC\u2192DELTA_AUDIT"
}

``

---


## Arquivo: .antigravity-os/[00] KERNEL/[02] token-budget-controller.json


``text

{
  "version": "3.1.0",
  "budgets": {
    "grep": {
      "max": 500,
      "alert_at": 400
    },
    "agent_call": {
      "max": 1000,
      "alert_at": 800
    },
    "code_gen": {
      "max": 8000,
      "alert_at": 6400
    },
    "debug": {
      "max": 3000,
      "alert_at": 2400
    }
  },
  "global": {
    "session_max": 50000,
    "alert_at_pct": 80,
    "hard_stop_at_pct": 95
  },
  "enforcement": "soft"
}

``

---


## Arquivo: .antigravity-os/[01] ORCHESTRATOR/[00] semantic-router.md


``text

# [01] SEMANTIC ROUTER

## IntegraÃ§Ã£o com Estrutura Existente
Este arquivo coordena o fluxo entre o Kernel e seus agentes existentes em `Agentes/` e `context/`.

## Fluxo de Roteamento ObrigatÃ³rio
1. **Detectar Modo**: Leia `.antigravity-os/[00] KERNEL/[00] quantum-loader.md` (GEM ou IDX).
2. **Consultar Rota**: Leia o arquivo `context/ROUTER.md` para identificar qual agente deve atuar agora.
3. **Validar Budget**: Antes de ativar qualquer agente, verifique `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.
4. **Selecionar Agente**: Se o budget permitir, carregue o agente correspondente da pasta `Agentes/`.
5. **Carregar Skill**: Se necessÃ¡rio, importe a skill especÃ­fica via `.antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json`.

## Aviso CrÃ­tico
Nunca pule a etapa 3 (Validar Budget). Se o budget estiver baixo, avise o usuÃ¡rio antes de carregar o agente.

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[00] theta-meta.json


``text

{
  "version": "1.0",
  "agent": "THETA",
  "description": "Orquestrador Global e Roteador de Tarefas",
  "source_file": "Agentes/THETA_Orchestrator.md",
  "cost_category": "low",
  "execution_context": "always_first",
  "behavior_rules": [
    "Leia o input do usuÃ¡rio e classifique a intenÃ§Ã£o.",
    "Defina o modo de operaÃ§Ã£o (GEM/IDX) baseado no Quantum Loader.",
    "Selecione o agente especialista (GAMMA, BETA, etc.) ou Skill necessÃ¡ria.",
    "Monitore o consumo de tokens e alerte se prÃ³ximo do limite."
  ],
  "fallback": "ZETA (Otimizador)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[01] beta-meta.json


``text

{
  "version": "1.0",
  "agent": "BETA",
  "description": "Arquiteto e Planejador (GEM Mode)",
  "source_file": "Agentes/BETA_Architect.md",
  "cost_category": "medium",
  "execution_context": "GEM_only",
  "behavior_rules": [
    "Crie PRDs e SPECs tÃ©cnicas detalhadas.",
    "Defina arquitetura de dados e fluxos.",
    "EstabeleÃ§a critÃ©rios de aceite rigorosos.",
    "NUNCA escreva cÃ³digo de produÃ§Ã£o (deixe para o GAMMA).",
    "Divida o projeto em Sprints menores."
  ],
  "fallback": "THETA (Orchestrator)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[02] gamma-meta.json


``text

{
  "version": "1.0",
  "agent": "GAMMA",
  "description": "Builder & Executor (Escreve CÃ³digo)",
  "source_file": "Agentes/GAMMA_Builder.md",
  "cost_category": "high",
  "execution_context": "IDX_only",
  "behavior_rules": [
    "Receba o plano do BETA ou instruÃ§Ãµes do THETA.",
    "Implemente cÃ³digo estritamente seguindo o PRD/SPEC.",
    "Valide cada alteraÃ§Ã£o com testes ou linting.",
    "Nunca planeje arquitetura (use BETA para isso).",
    "Se travar, chame o ETA (Investigator)."
  ],
  "fallback": "THETA (Orchestrator)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[03] delta-meta.json


``text

{
  "version": "1.0",
  "agent": "DELTA",
  "description": "Auditor de Qualidade e SeguranÃ§a",
  "source_file": "Agentes/DELTA_Auditor.md",
  "cost_category": "medium",
  "execution_context": "pre_commit",
  "behavior_rules": [
    "Revise cÃ³digo antes do commit.",
    "Verifique vazamento de secrets e PII.",
    "Valide conformidade com Minhas_Rules/STACK_OMEGA_RULES.",
    "Aprovar ou rejeitar PRs baseado em critÃ©rios tÃ©cnicos.",
    "Registre falhas em .antigravity-os/[04] MEMORY_DNA/."
  ],
  "fallback": "ETA (Investigator)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[03] eta-meta.json


``text

{
  "name": "ETA",
  "source": "Agentes/ETA_Prime.md",
  "cost_tokens": 150,
  "mode": "debug",
  "trigger": "error_detected",
  "fallback": "THETA"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[04] eta-meta.json


``text

{
  "version": "1.0",
  "agent": "ETA",
  "description": "Investigador de Bugs e Debugging Profundo",
  "source_file": "Agentes/ETA_Investigator.md",
  "cost_category": "high",
  "execution_context": "debug_mode",
  "behavior_rules": [
    "Analise stack traces e logs de erro.",
    "Isole a causa raiz de bugs complexos.",
    "Proponha hipÃ³teses de falha e valide uma a uma.",
    "Sugira fixes mÃ­nimos e testÃ¡veis.",
    "Registre o erro resolvido em MEMORY_DNA para nÃ£o repetir."
  ],
  "fallback": "GAMMA (Builder)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[04] zeta-meta.json


``text

{
  "name": "ZETA",
  "source": "Agentes/ZETA_Prime.md",
  "cost_tokens": 80,
  "mode": "optimize",
  "trigger": "slow_performance",
  "fallback": "THETA"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[05] delta-meta.json


``text

{
  "name": "DELTA",
  "source": "Agentes/DELTA_Prime.md",
  "cost_tokens": 120,
  "mode": "audit",
  "trigger": "pre_commit",
  "fallback": "THETA"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[05] zeta-meta.json


``text

{
  "version": "1.0",
  "agent": "ZETA",
  "description": "Otimizador de Performance e RefatoraÃ§Ã£o",
  "source_file": "Agentes/ZETA_Optimizer.md",
  "cost_category": "low",
  "execution_context": "optimization_mode",
  "behavior_rules": [
    "Analise cÃ³digo em busca de gargalos de performance.",
    "Sugira refatoraÃ§Ãµes para reduzir complexidade.",
    "Otimize queries de banco e chamadas de API.",
    "Reduza consumo de tokens e memÃ³ria.",
    "Mantenha a legibilidade e padrÃµes do projeto."
  ],
  "fallback": "THETA (Orchestrator)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[06] epsilon-meta.json


``text

{
  "version": "1.0",
  "agent": "EPSILON",
  "description": "Estrategista de Growth e Mercado",
  "source_file": "Agentes/EPSILON_Growth.md",
  "cost_category": "medium",
  "execution_context": "growth_analysis",
  "behavior_rules": [
    "Analise tendÃªncias de mercado e concorrÃªncia.",
    "Sugira features baseadas em ROI e retenÃ§Ã£o de usuÃ¡rios.",
    "Otimize funis de conversÃ£o e SEO tÃ©cnico.",
    "Integre mÃ©tricas de analytics ao cÃ³digo.",
    "Valide hipÃ³teses de negÃ³cio antes da implementaÃ§Ã£o tÃ©cnica."
  ],
  "fallback": "BETA (Architect)"
}

``

---


## Arquivo: .antigravity-os/[02] SQUAD_WRAPPERS/[07] alpha-meta.json


``text

{
  "version": "1.0",
  "agent": "ALPHA",
  "description": "Genesis & Bootstrap (InicializaÃ§Ã£o de Projeto)",
  "source_file": "Agentes/ALPHA_Genesis.md",
  "cost_category": "low",
  "execution_context": "bootstrap_mode",
  "behavior_rules": [
    "Configure estrutura inicial de pastas e arquivos base.",
    "Instale dependÃªncias e configure ambiente (.env, git, etc.).",
    "Valide se o projeto segue os padrÃµes de Minhas_Rules/.",
    "Gere README e documentaÃ§Ã£o de setup inicial.",
    "Entregue o projeto pronto para o THETA orquestrar."
  ],
  "fallback": "THETA (Orchestrator)"
}

``

---


## Arquivo: .antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json


``text

{
  "version": "3.1.0",
  "skills_root": "Minhas_Skills/",
  "lazy_load": true,
  "cache_ttl": "24h",
  "mapping": {
    "brainstorming": "Minhas_Skills/ESTRATEGIA_DISCOVERY/01_brainstorming.md",
    "planning": "Minhas_Skills/ESTRATEGIA_DISCOVERY/02_planejando_solucoes.md",
    "execution": "Minhas_Skills/EXECUCAO_IMPLEMENTACAO/03_executando_planos.md",
    "debugging": "Minhas_Skills/QUALIDADE_DEBUG/04_solucionando_erros.md",
    "validation": "Minhas_Skills/QUALIDADE_DEBUG/05_verificando_conclusao.md",
    "coding": "Minhas_Skills/EXECUCAO_IMPLEMENTACAO/06_codando.md",
    "external_comms": "Minhas_Skills/EXECUCAO_IMPLEMENTACAO/07_comunicando_externo.md",
    "market_analysis": "Minhas_Skills/ESTRATEGIA_DISCOVERY/08_explorando_mercados.md",
    "memory_mgmt": "Minhas_Skills/DOMINIO_ECOMMERCE/09_gerenciando_memoria.md",
    "llm_blueprint": "Minhas_Skills/DOMINIO_IA/10_llm_app_blueprint.md",
    "web_research": "Minhas_Skills/DOMINIO_IA/11_pesquisando_web.md",
    "using_skills": "Minhas_Skills/CORE/12_usando_skills.md"
  }
}

``

---


## Arquivo: .antigravity-os/[03] SKILLS_ENGINE/[01] retrieval-decision-matrix.json


``text

{
  "rules": {
    "if_input_lt_100_chars": "use:LEXICAL_GREP",
    "if_code_snippet": "use:GREP",
    "if_architecture": "use:RAG",
    "if_external_api": "use:MCP"
  },
  "priority": {
    "speed": "GREP",
    "accuracy": "RAG",
    "cost": "LEXICAL"
  }
}

``

---


## Arquivo: .antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json


``text

{
  "version": "3.1.0",
  "description": "Sistema GenÃ©tico de Erros - IntegraÃ§Ã£o com Logs/",
  "integration_path": "Logs/",
  "schema": {
    "error_id": "string (md5 hash de contexto+erro)",
    "timestamp": "ISO8601",
    "mutation": "tipo_do_erro (ex: 'db_connection_fail', 'cors_block', 'token_leak')",
    "context_snapshot": "trecho relevante do cÃ³digo/prompt que causou o erro",
    "agent_involved": "nome do agente (ex: 'GAMMA', 'ETA')",
    "vaccine": "soluÃ§Ã£o aplicada passo a passo",
    "immunity_scope": ["projeto_atual", "stack_omega", "todos_projetos"],
    "prevention_prompt": "instruÃ§Ã£o curta (<50 palavras) para injetar no system prompt antes de tarefas similares",
    "ttl_days": 90,
    "status": "active | archived"
  },
  "usage_rules": [
    "1. Antes de codar, consulte este registry por 'mutation' e 'tech_stack'.",
    "2. Se houver match, injete 'prevention_prompt' no contexto inicial.",
    "3. Ao resolver novo erro, registre imediatamente usando o schema acima.",
    "4. Use TTL para arquivar erros nÃ£o recorrentes apÃ³s 90 dias."
  ],
  "example_entry": {
    "error_id": "a1b2c3d4",
    "timestamp": "2026-02-20T10:00:00Z",
    "mutation": "env_vars_not_loaded",
    "context_snapshot": "PrismaClient init sem verificaÃ§Ã£o de DATABASE_URL",
    "agent_involved": "GAMMA",
    "vaccine": "Adicionar validaÃ§Ã£o Zod de envs antes de instanciar PrismaClient",
    "immunity_scope": ["stack_omega", "todos_projetos"],
    "prevention_prompt": "Antes de iniciar DB client, valide TODAS as env vars com schema Zod. Falhe rÃ¡pido se ausente.",
    "ttl_days": 90,
    "status": "active"
  }
}

``

---


## Arquivo: .antigravity-os/[04] MEMORY_DNA/[01] anti-patterns-vault.md


``text

# [01] ANTI-PATTERNS VAULT â€” Banco de "Nunca Repita"

## PropÃ³sito
Centralizar prÃ¡ticas proibidas, falhas de arquitetura e decisÃµes tÃ©cnicas reprovadas para evitar reincidÃªncia no desenvolvimento.

## IntegraÃ§Ã£o
- Baseado em: `Minhas_Rules/` e `Nucleo/`
- Atualizado por: DELTA (Auditor) e ETA (Investigator)

## Formato de Registro
Cada entrada deve seguir obrigatoriamente:
- **PadrÃ£o:** Nome curto e descritivo.
- **Risco:** Impacto tÃ©cnico, de seguranÃ§a ou custo.
- **SoluÃ§Ã£o:** Alternativa aprovada e validada.
- **ReferÃªncia:** Caminho para regra ou documento oficial.

## Regras de Uso
1. Consulte este vault antes de implementar features crÃ­ticas.
2. Se identificar um anti-pattern no cÃ³digo, registre aqui e acione o DELTA.
3. Revise e arquive itens obsoletos a cada sprint para manter o vault enxuto.

## Exemplo
- **PadrÃ£o:** `Hardcoded_Secrets`
- **Risco:** Vazamento em versionamento, falha em auditoria.
- **SoluÃ§Ã£o:** Injetar via variÃ¡veis de ambiente + validaÃ§Ã£o no startup.
- **ReferÃªncia:** `Minhas_Rules/SECURITY.md`

``

---


## Arquivo: .antigravity-os/[04] MEMORY_DNA/[02] prevention-injector.md


``text

# [02] PREVENTION INJECTOR â€” Mecanismo de InjeÃ§Ã£o de Imunidade

## PropÃ³sito
Converter erros passados (`MEMORY_DNA`) em proteÃ§Ã£o ativa para a sessÃ£o atual, sem inflar o contexto.

## Algoritmo de ExecuÃ§Ã£o
1. **Scan**: Antes de iniciar uma Task, leia `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.
2. **Match**: Busque chaves relacionadas ao contexto atual (ex: "Prisma", "Auth", "Next.js").
3. **Extract**: Copie apenas o campo `prevention_prompt` dos erros ativos encontrados.
4. **Inject**: Adicione a frase copiada como uma regra temporÃ¡ria no inÃ­cio da tarefa.

## Formato de InjeÃ§Ã£o
> âš ï¸ **MEMÃ“RIA DE PREVENÃ‡ÃƒO:** [prevention_prompt extraÃ­do]

## RestriÃ§Ãµes de Token
- Injete no mÃ¡ximo 3 prompts de prevenÃ§Ã£o por sessÃ£o.
- Priorize erros com tag `immunity_scope: "all_projects"`.
- Se o erro nÃ£o for relevante, ignore.

``

---


## Arquivo: .antigravity-os/[04] MEMORY_DNA/[03] cross-project-sync.md


``text

# [03] CROSS-PROJECT SYNC â€” SincronizaÃ§Ã£o de Aprendizado

## PropÃ³sito
Compartilhar "vacinas" (erros crÃ­ticos resolvidos) e padrÃµes aprovados entre todos os projetos que usam este Meta-Framework, sem expor dados sensÃ­veis.

## Protocolo de SincronizaÃ§Ã£o
- **DireÃ§Ã£o:** HTTPS Outbound-Only (Pull do repositÃ³rio central).
- **Cache Local:** TTL de 24h. Atualiza apenas se o hash do registry remoto mudar.
- **Gatilho:** Manual (`/sync-memory`) ou automÃ¡tico ao registrar erro com `immunity_scope: "all_projects"`.

## ConfiguraÃ§Ã£o (Ajuste uma vez)
- `REMOTE_REGISTRY_URL`: "https://raw.githubusercontent.com/svw10/Meu_Repo/main/.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json"
- `LOCAL_CACHE_PATH`: ".antigravity-os/[04] MEMORY_DNA/.cache/synced-registry.json"

## Regras de SeguranÃ§a CrÃ­ticas
1. **NUNCA** sincronize paths absolutos, nomes de clientes, chaves de API ou dados PII.
2. Sanitize todos os campos `context_snapshot` antes do push.
3. Use apenas padrÃµes genÃ©ricos de stack (ex: "Next.js 14 + Prisma", nÃ£o "projeto-cliente-x").

## InstruÃ§Ãµes para a IA
- Ao iniciar sessÃ£o: Verifique cache local. Se expirado (>24h), faÃ§a pull silencioso do remoto.
- Ao resolver erro crÃ­tico: Pergunte ao usuÃ¡rio "Deseja compartilhar esta soluÃ§Ã£o como padrÃ£o global (Stack Omega)?"
- Se sim: Atualize o registry local e notifique para push manual no repositÃ³rio central.

``

---


## Arquivo: .antigravity-os/[05] TOKENOMICS/[00] tier-strategy.md


``text

# [00] TIER STRATEGY â€” Economia Inteligente de Tokens

## PropÃ³sito
Definir estratÃ©gias de execuÃ§Ã£o baseadas em "Custo-BenefÃ­cio", priorizando o mÃ­nimo de tokens para o mÃ¡ximo de resultado.

##  Tier 1: Senior Mode (SimbÃ³lico)
**Economia estimada: ~70%**
- **Regra:** Nunca cole schemas, componentes grandes ou logs inteiros no prompt.
- **TÃ©cnica:** Use referÃªncias simbÃ³licas.
  - âŒ Errado: Colar o schema `User` inteiro (300 linhas).
  - âœ… Certo: Usar `@schema:User` ou apontar o arquivo `db/schema.prisma`.
- **AÃ§Ã£o da IA:** Ler o arquivo referenciado sob demanda (Lazy Load).

## ðŸ¥ˆ Tier 2: Differential Updates (Git Diff)
**Economia estimada: ~50% em refatoraÃ§Ãµes**
- **Regra:** Nunca envie o arquivo completo se alterou apenas uma funÃ§Ã£o.
- **TÃ©cnica:** Gere ou aplique apenas o `diff`.
- **AÃ§Ã£o da IA:** Use ferramentas de patch ou blocos de cÃ³digo focados na alteraÃ§Ã£o.

## ðŸ¥‰ Tier 3: Context Pruning (Jardinagem)
**Economia estimada: MantÃ©m o modelo "esperto"**
- **Regra:** Contexto poluÃ­do gera alucinaÃ§Ã£o.
- **TÃ©cnica:**
  - Arquivos de configuraÃ§Ã£o estÃ¡ticos (`package.json`, `tsconfig`) â†’ NÃ£o incluir a cada mensagem, apenas na primeira.
  - Logs antigos â†’ Arquivar ou limpar apÃ³s leitura.
  - Prompts de sistema longos â†’ Dividir em arquivos modulares (`skills/`).

## âš ï¸ Alerta de Custos
Se `estimated_cost > budget`, aplique automaticamente o **Tier 1**.

``

---


## Arquivo: .antigravity-os/[05] TOKENOMICS/[01] symbolic-refs.md


``text

# [01] SYMBOLIC REFS â€” ReferÃªncias SimbÃ³licas

## PropÃ³sito
Substituir colagem de conteÃºdo bruto por ponteiros inteligentes, reduzindo drasticamente o consumo de tokens e evitando poluiÃ§Ã£o de contexto.

## Sintaxe ObrigatÃ³ria
- **Arquivo:** `@file:src/utils/auth.ts` (caminho relativo Ã  raiz)
- **Schema/Model:** `@schema:User` ou `@db:Prisma.User`
- **Skill/MÃ³dulo:** `@skill:06_codando` ou `@module:ESTRATEGIA_DISCOVERY`
- **Trecho EspecÃ­fico:** `@file:config.ts#L12-45` (linhas exatas)

## Regras de ResoluÃ§Ã£o (Para a IA)
1. Ao detectar `@`, busque o recurso na estrutura local (`Minhas_Skills/`, `Agentes/`, `src/`, etc.).
2. Carregue APENAS o trecho necessÃ¡rio para a tarefa atual.
3. Se o recurso nÃ£o existir ou o caminho estiver quebrado, solicite correÃ§Ã£o antes de prosseguir.
4. Nunca expanda um `@schema` ou `@skill` inteiro se a tarefa exigir apenas uma funÃ§Ã£o especÃ­fica.

## Limites de SeguranÃ§a
- Proibido: `@file:.env`, `@file:*.key`, `@file:secrets.json`
- Sanitize automaticamente paths que contenham `token`, `secret`, `password`, `key`.

## Exemplos PrÃ¡ticos
âœ… **Correto:** "Valide o schema de autenticaÃ§Ã£o usando `@schema:AuthInput` e a skill `@skill:05_verificando_conclusao`."
âŒ **Errado:** Colar 200 linhas do schema + cÃ³digo da skill na mensagem.

## IntegraÃ§Ã£o
- Funciona em conjunto com `.antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json` para resoluÃ§Ã£o de `@skill`.
- Priorize referÃªncias simbÃ³licas em TODAS as interaÃ§Ãµes, exceto debugging crÃ­tico que exija contexto completo.

``

---


## Arquivo: .antigravity-os/[05] TOKENOMICS/[02] differential-updates.md


``text

# [02] DIFFERENTIAL UPDATES â€” AtualizaÃ§Ãµes Incrementais

## PropÃ³sito
Eliminar o desperdÃ­cio de tokens enviando arquivos inteiros. Transmita e aplique apenas as alteraÃ§Ãµes reais (diffs) durante o desenvolvimento.

## Protocolo de EdiÃ§Ã£o
1. **IdentificaÃ§Ã£o:** Localize APENAS os blocos de cÃ³digo que precisam mudar.
2. **FormataÃ§Ã£o:** Use sintaxe `SEARCH/REPLACE` ou `diff` unificado.
   ```diff
   // ... existing code ...
   - linha_antiga_ou_funÃ§Ã£o_depreciada();
   + nova_linha_ou_funÃ§Ã£o_otimizada();
   // ... existing code ...
   ```

``

---


## Arquivo: .antigravity-os/[05] TOKENOMICS/[03] cost-telemetry.json


``text

{
  "version": "3.1.0",
  "description": "Telemetria de Custo em Tempo Real por Feature/SessÃ£o",
  "integration_path": "Logs/",
  "schema": {
    "session_id": "string (uuid)",
    "feature_name": "string",
    "agent_involved": "string (ex: GAMMA, BETA)",
    "model_used": "string (ex: haiku, sonnet, opus)",
    "tokens_input": "integer",
    "tokens_output": "integer",
    "estimated_cost_usd": "float",
    "duration_seconds": "integer",
    "status": "success | warning | budget_exceeded",
    "timestamp": "ISO8601"
  },
  "logging_rules": [
    "1. Inicie o registro no inÃ­cio de cada task com status 'pending'.",
    "2. Atualize tokens e custo a cada bloco de cÃ³digo gerado.",
    "3. Finalize com status 'success' ou 'budget_exceeded' se ultrapassar 90% do budget.",
    "4. Grave entrada completa em Logs/telemetry.log ao final da sessÃ£o.",
    "5. Se 'budget_exceeded', acione automaticamente o ZETA (Otimizador) para refatorar o prompt ou dividir a task."
  ],
  "aggregation": {
    "per_sprint": "some(tokens) + sum(cost) group by feature_name",
    "per_agent": "avg(duration) + total_cost group by agent_involved",
    "alert_thresholds": {
      "cost_per_feature": 0.50,
      "tokens_per_minute": 5000,
      "retry_loops": 3
    }
  },
  "example_entry": {
    "session_id": "sess_9f8a7b",
    "feature_name": "auth_login_flow",
    "agent_involved": "GAMMA",
    "model_used": "sonnet",
    "tokens_input": 1200,
    "tokens_output": 850,
    "estimated_cost_usd": 0.012,
    "duration_seconds": 45,
    "status": "success",
    "timestamp": "2026-02-20T14:30:00Z"
  }
}

``

---


## Arquivo: .antigravity-os/[06] SECURITY_DRL/[00] pii-sanitization.md


``text

# [00] PII SANITIZATION â€” ProteÃ§Ã£o de Dados SensÃ­veis

## PropÃ³sito
Impedir vazamento de dados pessoais (PII) ou credenciais para a nuvem/IA, garantindo compliance LGPD e seguranÃ§a zero-trust.

## DetecÃ§Ã£o Local (Regex Patterns)
A IA deve escanear TODO o contexto antes de enviar Ã  nuvem. PadrÃµes crÃ­ticos:
- **CPF:** `\d{3}\.\d{3}\.\d{3}-\d{2}`
- **E-mail:** `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}`
- **Telefone:** `\(\d{2}\)\s?\d{4,5}-?\d{4}`
- **IP/Hosts Internos:** `192\.168\.\d{1,3}\.\d{1,3}|10\.\d{1,3}\.\d{1,3}\.\d{1,3}`
- **Chaves/Secrets:** `(sk-|pk-|ghp_|AKIA)[A-Za-z0-9]{20,}`

## Protocolo de SanitizaÃ§Ã£o
1. **Scan:** Identifique matches antes de injetar no prompt.
2. **Mask:** Substitua por `[REDACTED_<TYPE>]` (ex: `[REDACTED_CPF]`, `[REDACTED_EMAIL]`).
3. **Log:** Registre a ocorrÃªncia em `Logs/security_audit.log` (apenas metadata, nunca o dado original).
4. **Proceed:** Envie o contexto sanitizado para processamento.

## IntegraÃ§Ã£o com Minhas_Rules/
- Valide contra `Minhas_Rules/SECURITY.md` para padrÃµes adicionais da stack.
- Se `Minhas_Rules/` exigir criptografia, aplique antes da masking.

## Regras CrÃ­ticas para a IA
- ðŸš« NUNCA inclua dados reais em exemplos, logs ou prompts de debug.
- âœ… USE sempre dados fictÃ­cios (ex: `user@example.com`, `000.000.000-00`) para testes.
- ðŸ”’ Se detectar PII acidental, pause, sanitize e notifique: "âš ï¸ Dados sensÃ­veis detectados e sanitizados automaticamente."

``

---


## Arquivo: .antigravity-os/[06] SECURITY_DRL/[01] secrets-vault.json


``text

{
  "version": "3.1.0",
  "description": "Cofre de Secrets - Protocolo Zero-Exposure para IA e Git",
  "storage_config": {
    "type": "local_env",
    "primary_path": ".env",
    "backup_path": ".env.example (apenas chaves, sem valores)",
    "git_ignored": true,
    "encrypted_at_rest": false
  },
  "usage_protocol": {
    "step_1_load": "Carregue secrets APENAS em memÃ³ria local (Node process.env / Python os.environ).",
    "step_2_mask": "Antes de enviar contexto Ã  IA, substitua TODOS os valores reais por placeholders: {{NOME_DA_VAR}}.",
    "step_3_generate": "A IA deve gerar cÃ³digo referenciando process.env.NOME_DA_VAR, NUNCA valores literais.",
    "step_4_validate": "Execute verificaÃ§Ã£o prÃ©-commit para garantir que nenhum valor real vazou no diff."
  },
  "alias_map": {
    "DB_URL": "{{DATABASE_URL}}",
    "AUTH_KEY": "{{AUTH_SECRET}}",
    "API_KEY": "{{PROVIDER_API_KEY}}",
    "JWT_SEC": "{{JWT_SECRET}}"
  },
  "forbidden_patterns_context": [
    "sk-[a-zA-Z0-9]{30,}",
    "ghp_[a-zA-Z0-9]{30,}",
    "AKIA[0-9A-Z]{16}",
    "password\\s*[:=]\\s*['\"][^'\"]{5,}['\"]",
    "Bearer eyJ[a-zA-Z0-9_-]+"
  ],
  "emergency_rules": [
    "Se detectar secret real no contexto: PARE, sanitize imediatamente e notifique o usuÃ¡rio.",
    "Se o usuÃ¡rio pedir para 'colar a chave': Recuse e instrua a usar .env + alias.",
    "Nunca faÃ§a commit de .env. Se ocorrer, use git-filter-repo ou BFG Repo-Cleaner."
  ],
  "integration": {
    "hooks": ".git/hooks/pre-commit (chama validaÃ§Ã£o de secrets)",
    "logging": "Logs/security_audit.log (apenas alertas, nunca os valores)"
  }
}

``

---


## Arquivo: .antigravity-os/[06] SECURITY_DRL/[02] frontend-inspector.md


``text

# [02] FRONTEND INSPECTOR â€” Auditoria de Cliente (Browser)

## PropÃ³sito
Garantir que o cÃ³digo que roda no navegador do usuÃ¡rio seja seguro, leve e nÃ£o exponha dados do servidor ou segredos.

## Checklist de ValidaÃ§Ã£o (ObrigatÃ³rio antes do Deploy)

### 1. ðŸš« Vazamento de Secrets (Environment Variables)
- **Regra:** Nenhuma variÃ¡vel sensÃ­vel deve ter o prefixo `NEXT_PUBLIC_` (ou `VITE_`, `REACT_APP_`).
- **AÃ§Ã£o:** Se o frontend precisa de um segredo, crie um **Server Action** ou **API Route** para fazer a chamada segura, nÃ£o exponha a chave no `.env` do client.

### 2. ðŸ›‘ Acesso Direto ao Banco (DB Client-Side)
- **Regra:** Proibido importar o ORM (Prisma, Drizzle, Mongoose) dentro de Componentes com `"use client"`.
- **AÃ§Ã£o:** A lÃ³gica de banco deve ficar estritamente em **Server Components** ou **Server Actions**. O frontend recebe apenas os dados serializados (JSON).

### 3. âš ï¸ Logs de Debug em ProduÃ§Ã£o
- **Regra:** Remover `console.log`, `console.warn` ou `debugger` antes de commitar para `main`.
- **AÃ§Ã£o:** Use um sistema de logging estruturado se for necessÃ¡rio monitorar erros no client.

### 4. âš¡ Performance & Re-renders
- **Regra:** Evitar re-renders desnecessÃ¡rios.
- **AÃ§Ã£o:**
  - Use `React.memo` para componentes estÃ¡ticos.
  - Verifique se as dependÃªncias de `useEffect` sÃ£o estÃ¡veis.
  - Use `useCallback` para funÃ§Ãµes passadas como props.

### 5. ðŸ”’ XSS & SanitizaÃ§Ã£o
- **Regra:** Nunca renderize HTML cru (ex: `dangerouslySetInnerHTML`) sem sanitizaÃ§Ã£o prÃ©via.
- **AÃ§Ã£o:** Use bibliotecas de sanitizaÃ§Ã£o (ex: `dompurify`) ou prefira markdown renderizado seguro.

## IntegraÃ§Ã£o com Agente DELTA
- O Agente **DELTA (Auditor)** deve rodar este checklist automaticamente ao revisar arquivos dentro de `app/`, `components/` ou `pages/`.
- Se violaÃ§Ã£o detectada â†’ Bloquear merge e apontar a linha exata.

``

---


## Arquivo: .antigravity-os/[06] SECURITY_DRL/[03] submodule-guard.md


``text

# [03] SUBMODULE GUARD â€” ProteÃ§Ã£o do NÃºcleo Core

## PropÃ³sito
Impedir que alteraÃ§Ãµes locais em projetos filhos corrompam ou desviam do `Antigravity OS` central. O framework deve ser imutÃ¡vel no nÃ­vel do projeto, exceto para atualizaÃ§Ãµes oficiais.

## Regra de Ouro (Read-Only)
A pasta `.antigravity-os/` Ã© **READ-ONLY** para tarefas de desenvolvimento de features.
- âŒ **Proibido:** Editar, deletar ou renomear arquivos dentro de `.antigravity-os/` durante o trabalho no projeto.
- âœ… **Permitido:** Ler e consultar arquivos para seguir as regras.

## Fluxo de AtualizaÃ§Ã£o Segura
Se uma regra, skill ou wrapper precisar ser alterado:
1. **NÃ£o edite localmente.**
2. Identifique o arquivo no repositÃ³rio central (GitHub do Framework).
3. FaÃ§a um Pull Request ou Commit no repo central.
4. No projeto filho, execute: `git submodule update --remote` para puxar a versÃ£o atualizada.

## ProteÃ§Ã£o contra Git Accidents
- **`.gitignore` Global:** A pasta `.antigravity-os/` pode ser adicionada ao `.gitignore` do projeto filho se vocÃª nÃ£o quiser versionar o link do submÃ³dulo (embora seja recomendado versionar para garantir que todos usem a mesma versÃ£o).
- **PermissÃµes:** Scripts em `.antigravity-os/[08] SUBMODULE_HOOKS/` devem ser executados para verificar integridade da estrutura.

## IntegraÃ§Ã£o com DELTA (Auditor)
- O Agente DELTA deve verificar se houve alteraÃ§Ãµes nÃ£o autorizadas em `.antigravity-os/` antes de aprovar um commit que envolva configuraÃ§Ã£o de projeto.
- Se alteraÃ§Ãµes locais forem detectadas: Rejeitar e solicitar limpeza (`git checkout -- .antigravity-os/`) ou commit da atualizaÃ§Ã£o oficial.

``

---


## Arquivo: .antigravity-os/[07] SPECS_WARP/[00] prd-business-template.md


``text

# [00] PRD BUSINESS TEMPLATE â€” Documento de Requisitos de Produto

## âš ï¸ Regra de Ouro: Foco Exclusivo no NegÃ³cio
Este documento **NÃƒO deve conter cÃ³digo, nomes de tabelas, endpoints ou decisÃµes de stack**.
Seu objetivo Ã© definir **O QUE** serÃ¡ feito e **POR QUE**, validado pelo Agente BETA (Arquiteto) antes de passar para a SPEC TÃ©cnica (GAMMA).

---

## 1. VisÃ£o Geral do Produto
- **Problema:** Qual dor do usuÃ¡rio ou lacuna de mercado estamos resolvendo?
- **Objetivo:** O que define o sucesso deste produto/feature?
- **PÃºblico-Alvo:** Quem sÃ£o os usuÃ¡rios finais? (Personas principais)
- **IntegraÃ§Ã£o:** Relacionado a `Nucleo/FABRICA_SOFTWARE.md` e `Minhas_Skills/ESTRATEGIA_DISCOVERY/`.

## 2. Regras de NegÃ³cio CrÃ­ticas
- Liste apenas restriÃ§Ãµes funcionais (ex: "UsuÃ¡rio free nÃ£o pode exportar relatÃ³rios", "Pagamento deve ser confirmado em atÃ© 5min").
- Defina prioridades: [MoSCoW: Must have, Should have, Could have, Won't have].

## 3. User Stories & Fluxos Principais
- Use o formato: "Como [perfil], eu quero [aÃ§Ã£o], para que [benefÃ­cio]."
- Descreva o fluxo ideal (Caminho Feliz) e fluxos alternativos (ex: recuperaÃ§Ã£o de senha, cancelamento).

## 4. CritÃ©rios de Aceite (Formato BDD/Gherkin)
A IA deve validar a implementaÃ§Ã£o contra estes cenÃ¡rios:
```gherkin
CenÃ¡rio: [Nome do CenÃ¡rio]
  Dado que [condiÃ§Ã£o inicial]
  Quando [aÃ§Ã£o do usuÃ¡rio]
  EntÃ£o [resultado esperado]
  E [validaÃ§Ã£o secundÃ¡ria]
```

``

---


## Arquivo: .antigravity-os/[07] SPECS_WARP/[01] spec-technical-schema.ts


``text

import { z } from 'zod';

// ---------------------------------------------------------
// SCHEMA DE VALIDAÃ‡ÃƒO TÃ‰CNICA (Zod)
// Garante que a SPEC esteja completa, tipada e pronta para o GAMMA codar.
// ---------------------------------------------------------

// 1. CritÃ©rios de Aceite (Vinculados ao PRD)
export const AcceptanceCriterionSchema = z.object({
  id: z.string().describe("ID Ãºnico (ex: AC-001)"),
  scenario: z.string().describe("DescriÃ§Ã£o do cenÃ¡rio (Gherkin ou direto)"),
  type: z.enum(['functional', 'security', 'performance', 'edge_case']),
  automated_test: z.boolean().describe("Se deve gerar teste automatizado"),
  status: z.enum(['pending', 'validated', 'failed']).default('pending')
});

// 2. AlteraÃ§Ãµes de Arquivo (Mapeamento TÃ©cnico)
export const FileChangeSchema = z.object({
  path: z.string().describe("Caminho relativo (ex: src/app/auth/route.ts)"),
  action: z.enum(['create', 'update', 'delete', 'move']),
  description: z.string().describe("Resumo tÃ©cnico da alteraÃ§Ã£o"),
  dependencies: z.array(z.string()).optional().describe("Arquivos impactados")
});

// 3. Sprint TÃ©cnica (Unidade de ExecuÃ§Ã£o)
export const SprintSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string(),
  estimated_tokens: z.number().min(500).max(15000).describe("Budget de tokens para esta sprint"),
  files: z.array(FileChangeSchema),
  acceptance_criteria: z.array(AcceptanceCriterionSchema).min(1),
  agent_assigned: z.enum(['GAMMA', 'DELTA', 'ETA']).default('GAMMA'),
  status: z.enum(['queued', 'in_progress', 'review', 'done']).default('queued')
});

// 4. Schema Raiz da SPEC TÃ©cnica
export const SpecTechnicalSchema = z.object({
  version: z.literal('1.0'),
  project_name: z.string(),
  linked_prd_id: z.string().describe("ID do PRD aprovado (obrigatÃ³rio)"),
  stack: z.array(z.string()).describe("Stack obrigatÃ³ria (ex: Next.js 14, Prisma, Tailwind)"),
  global_constraints: z.object({
    max_context_tokens: z.number().default(8000),
    security_rules: z.array(z.string()),
    performance_targets: z.array(z.string())
  }),
  sprints: z.array(SprintSchema).min(1).describe("DivisÃ£o obrigatÃ³ria em sprints atÃ´micas"),
  created_at: z.string().datetime(),
  approved_by: z.string().describe("Agente ou humano responsÃ¡vel")
});

export type SpecTechnical = z.infer<typeof SpecTechnicalSchema>;

// ---------------------------------------------------------
// INSTRUÃ‡ÃƒO DE EXECUÃ‡ÃƒO PARA A IA
// ---------------------------------------------------------
/*
1. Antes de gerar cÃ³digo, valide os dados da SPEC contra `SpecTechnicalSchema`.
2. Se invÃ¡lido (ex: sem sprints ou sem linked_prd_id), solicite correÃ§Ã£o ao BETA (Arquiteto).
3. SÃ³ permita execuÃ§Ã£o do GAMMA se `sprints.length > 0` e o budget de cada sprint estiver dentro de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.
4. Atualize o status das sprints conforme a entrega avanÃ§a.
*/

``

---


## Arquivo: .antigravity-os/[07] SPECS_WARP/[02] sprint-isolation.md


``text

# [02] SPRINT ISOLATION â€” Protocolo de Contexto Limpo

## PropÃ³sito
Garantir que cada sprint tÃ©cnica seja executada em um contexto isolado, eliminando "lixo" de sessÃµes anteriores e prevenindo a "Dumb Zone" (alucinaÃ§Ã£o por superlotaÃ§Ã£o de contexto).

## ðŸ§± Regra de Ouro: 1 Sprint = 1 Chat Limpo
- Nunca acumule mÃºltiplas sprints na mesma conversa.
- Ao finalizar uma sprint, execute `/clear` imediatamente.
- O contexto inicial da nova sprint deve conter APENAS:
  1. A SPEC TÃ©cnica atual (apenas o bloco da sprint relevante).
  2. O `prevention_prompt` extraÃ­do de `MEMORY_DNA` (se aplicÃ¡vel).
  3. As regras globais do `.cursorrules`.

## ðŸ”„ Fluxo de Isolamento
1. **InÃ­cio:** A IA lÃª apenas o objeto da sprint atual em `.antigravity-os/[07] SPECS_WARP/[01] spec-technical-schema.ts`.
2. **ExecuÃ§Ã£o:** Foca estritamente nos `files` e `acceptance_criteria` daquela sprint. Ignora cÃ³digo nÃ£o relacionado.
3. **ValidaÃ§Ã£o:** Verifique critÃ©rios de aceite. Se passar â†’ marque status como `done`.
4. **TransiÃ§Ã£o:** Atualize o rastreador de progresso externo. Execute `/clear`.
5. **PrÃ³xima:** Carregue apenas os dados da Sprint N+1.

## ðŸ§  GestÃ£o de Estado (Sem Poluir Contexto)
- Use arquivos externos para rastrear progresso, nunca o histÃ³rico do chat.
- Referencie o estado atual via ponteiros `@file` ou resumos <200 tokens.
- Se precisar de contexto de sprints anteriores, solicite um "resume tÃ©cnico" compacto, nunca o log completo.

## ðŸ¤– IntegraÃ§Ã£o com Agentes
- **THETA:** Prepara o pacote de contexto mÃ­nimo e dispara o isolamento.
- **GAMMA:** Executa dentro dos limites estritos da sprint ativa.
- **DELTA:** Valida a entrega isolada antes de liberar a transiÃ§Ã£o para a prÃ³xima.

## âš ï¸ Alerta de ViolaÃ§Ã£o
Se o consumo de contexto ultrapassar 60% ou a IA detectar mistura de sprints, deve parar imediatamente e solicitar `/clear` + recarregamento da sprint atual.

``

---


## Arquivo: .antigravity-os/[07] SPECS_WARP/[03] checkpoints-gates.md


``text

# [03] CHECKPOINTS & GATES â€” PortÃµes de Qualidade ObrigatÃ³rios

## PropÃ³sito
Definir pontos de parada obrigatÃ³rios onde a IA deve validar critÃ©rios antes de avanÃ§ar para a prÃ³xima fase, prevenindo retrabalho em cascata e garantindo conformidade.

---

## ðŸš¦ Mapa de Gates do Fluxo
[PRD Rascunho]
â†“
[GATE 1: PRD Review] â† BETA + Humano
â†“
[PRD Aprovado]
â†“
[GATE 2: SPEC Generation] â† ValidaÃ§Ã£o Zod + THETA
â†“
[SPEC TÃ©cnica]
â†“
[GATE 3: Sprint Approval] â† DELTA (Security/Performance Check)
â†“
[ExecuÃ§Ã£o GAMMA]
â†“
[GATE 4: Acceptance Test] â† Testes automatizados + DELTA
â†“
[Deploy/Commit]
â†“
[GATE 5: Post-Mortem] â† Registro em MEMORY_DNA


---

## ðŸ“‹ Detalhamento dos Gates

### GATE 1: PRD Review (NegÃ³cio)
**ResponsÃ¡vel:** BETA (Architect) + ValidaÃ§Ã£o Humana  
**CritÃ©rios de Passagem:**
- [ ] User Stories no formato correto (Como/Quero/Para)
- [ ] CritÃ©rios de aceite em BDD/Gherkin definidos
- [ ] "Fora do Escopo" explicitamente listado
- [ ] KPIs mensurÃ¡veis definidos
- [ ] Sem termos tÃ©cnicos de implementaÃ§Ã£o

**AÃ§Ã£o se Falhar:** Retornar para refinamento com BETA. NÃ£o gerar SPEC.

---

### GATE 2: SPEC Generation (TÃ©cnica)
**ResponsÃ¡vel:** THETA (Orchestrator) + ValidaÃ§Ã£o Zod  
**CritÃ©rios de Passagem:**
- [ ] Schema `SpecTechnicalSchema` validado com sucesso
- [ ] `linked_prd_id` presente e vÃ¡lido
- [ ] Sprints divididas atomicamente (<15k tokens cada)
- [ ] Stack e constraints alinhadas com `Minhas_Rules/`
- [ ] Budget de tokens definido por sprint

**AÃ§Ã£o se Falhar:** Solicitar correÃ§Ã£o da SPEC. NÃ£o iniciar codificaÃ§Ã£o.

---

### GATE 3: Sprint Approval (PrÃ©-ExecuÃ§Ã£o)
**ResponsÃ¡vel:** DELTA (Auditor)  
**CritÃ©rios de Passagem:**
- [ ] Nenhum secret/PII nos arquivos alvo
- [ ] DependÃªncias declaradas e disponÃ­veis
- [ ] CritÃ©rios de aceite testÃ¡veis automatizadamente
- [ ] Fallback definido se budget estourar

**AÃ§Ã£o se Falhar:** Bloquear execuÃ§Ã£o do GAMMA. Acionar ETA para investigaÃ§Ã£o.

---

### GATE 4: Acceptance Test (PÃ³s-ExecuÃ§Ã£o)
**ResponsÃ¡vel:** DELTA + Testes Automatizados  
**CritÃ©rios de Passagem:**
- [ ] Todos os `acceptance_criteria` da sprint passaram
- [ ] Lint/TypeScript sem erros
- [ ] Testes unitÃ¡rios/integraÃ§Ã£o criados e passando
- [ ] Telemetria registrada em `TOKENOMICS/[03] cost-telemetry.json`

**AÃ§Ã£o se Falhar:** Acionar loop de correÃ§Ã£o com ETA. Se >3 retries, escalar para humano.

---

### GATE 5: Post-Mortem (Aprendizado)
**ResponsÃ¡vel:** THETA + MEMORY_DNA  
**CritÃ©rios de Passagem:**
- [ ] Erros encontrados registrados em `error-dna-registry.json`
- [ ] `prevention_prompt` gerado para erros recorrentes
- [ ] MÃ©tricas de custo/tempo atualizadas
- [ ] Sprint marcada como `done` no tracker

**AÃ§Ã£o se Falhar:** NÃ£o considerar sprint concluÃ­da. Revisar processo de registro.

---

## âš™ï¸ IntegraÃ§Ã£o com Agentes

| Gate | Agente PrimÃ¡rio | AÃ§Ã£o AutomÃ¡tica |
|------|----------------|-----------------|
| 1 | BETA | Gera checklist de validaÃ§Ã£o de PRD |
| 2 | THETA | Executa `zod.parse()` na SPEC |
| 3 | DELTA | Roda scanner de seguranÃ§a prÃ©-execuÃ§Ã£o |
| 4 | DELTA + GAMMA | Executa testes e valida outputs |
| 5 | THETA | Atualiza MEMORY_DNA e TOKENOMICS |

## ðŸš¨ Regra de Escape
Se um gate falhar 2x consecutivas no mesmo tipo de erro:
1. Pausar execuÃ§Ã£o
2. Notificar usuÃ¡rio: "âš ï¸ Gate [X] falhou repetidamente. IntervenÃ§Ã£o necessÃ¡ria."
3. Sugerir revisÃ£o manual ou ajuste de especificaÃ§Ã£o

## ðŸ“ InstruÃ§Ã£o para IA
Sempre que atingir um gate listado acima, execute a validaÃ§Ã£o correspondente ANTES de prosseguir. Nunca pule gates, mesmo sob pressÃ£o de tempo.

``

---


## Arquivo: .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh


``text

#!/bin/bash
# [00] INIT SUBMODULE â€” IntegraÃ§Ã£o do Antigravity OS em Novo Projeto
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh

set -e  # Sai imediatamente em caso de erro

echo "ðŸ§¬ Iniciando integraÃ§Ã£o do Antigravity OS Neural..."

# ConfiguraÃ§Ãµes
FRAMEWORK_REPO="https://github.com/svw10/Meu_Repo.git"
FRAMEWORK_PATH=".antigravity-os"
FRAMEWORK_BRANCH="main"

# 1. Verifica se jÃ¡ existe um submÃ³dulo
if [ -d "$FRAMEWORK_PATH/.git" ]; then
  echo "âš ï¸  Antigravity OS jÃ¡ estÃ¡ integrado em $FRAMEWORK_PATH"
  echo "Para atualizar: bash $FRAMEWORK_PATH/[08] SUBMODULE_HOOKS/[01] update-core.sh"
  exit 0
fi

# 2. Adiciona como submÃ³dulo Git
echo "ðŸ“¦ Adicionando submÃ³dulo: $FRAMEWORK_REPO â†’ $FRAMEWORK_PATH"
git submodule add -b "$FRAMEWORK_BRANCH" "$FRAMEWORK_REPO" "$FRAMEWORK_PATH"

# 3. Inicializa e atualiza submÃ³dulos recursivos
echo "ðŸ”„ Inicializando submÃ³dulos..."
git submodule update --init --recursive

# 4. Configura permissÃµes de execuÃ§Ã£o nos hooks
echo "ðŸ” Configurando permissÃµes de scripts..."
chmod +x "$FRAMEWORK_PATH/[08] SUBMODULE_HOOKS/"*.sh 2>/dev/null || true

# 5. Valida estrutura mÃ­nima
echo "âœ… Validando estrutura..."
REQUIRED_FILES=(
  "$FRAMEWORK_PATH/[00] KERNEL/[00] quantum-loader.md"
  "$FRAMEWORK_PATH/[01] ORCHESTRATOR/[00] semantic-router.md"
  "$FRAMEWORK_PATH/[99] INDEX.md"
)

for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "âŒ Erro: Arquivo crÃ­tico nÃ£o encontrado: $file"
    exit 1
  fi
done

# 6. Atualiza .gitmodules para commit
echo "ðŸ“ Atualizando .gitmodules..."
git add .gitmodules "$FRAMEWORK_PATH"

# 7. Mensagem final
echo ""
echo "ðŸŽ‰ Antigravity OS integrado com sucesso!"
echo ""
echo "PrÃ³ximos passos:"
echo "1. Commit a integraÃ§Ã£o: git commit -m 'chore: add antigravity-os submodule'"
echo "2. Configure .cursorrules na raiz apontando para $FRAMEWORK_PATH/[00] KERNEL/"
echo "3. Inicie um novo projeto lendo: $FRAMEWORK_PATH/[99] INDEX.md"
echo ""
echo "âš ï¸  Regra de Ouro: Nunca edite $FRAMEWORK_PATH/ diretamente."
echo "   Para atualizar o framework: use [01] update-core.sh"

``

---


## Arquivo: .antigravity-os/[08] SUBMODULE_HOOKS/[01] update-core.sh


``text

#!/bin/bash
# [01] UPDATE CORE â€” AtualizaÃ§Ã£o Segura do Framework
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[01] update-core.sh

set -e  # Sai imediatamente em caso de erro

FRAMEWORK_PATH=".antigravity-os"

echo "ðŸ”„ Verificando estado do Antigravity OS..."

# 1. Valida se o submÃ³dulo existe
if [ ! -d "$FRAMEWORK_PATH/.git" ]; then
  echo "âŒ Erro: Antigravity OS nÃ£o estÃ¡ integrado como submÃ³dulo."
  echo "Execute primeiro: [00] init-submodule.sh"
  exit 1
fi

# 2. Verifica se hÃ¡ alteraÃ§Ãµes locais nÃ£o commitadas no submÃ³dulo
cd "$FRAMEWORK_PATH"
if [ -n "$(git status --porcelain)" ]; then
  echo "âš ï¸  AtenÃ§Ã£o: Existem alteraÃ§Ãµes locais nÃ£o commitadas em .antigravity-os/"
  echo "   RecomendaÃ§Ã£o: FaÃ§a backup ou commit antes de atualizar."
  read -p "Deseja continuar e sobrescrever? (y/N) " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "ðŸ›‘ AtualizaÃ§Ã£o cancelada."
    exit 1
  fi
  # ForÃ§a checkout para limpar estado sujo
  git checkout -- .
  git clean -fd
fi

# 3. Atualiza para a versÃ£o mais remota
echo "ðŸ“¥ Buscando e aplicando atualizaÃ§Ãµes..."
git fetch origin main
OLD_HASH=$(git rev-parse HEAD)
git merge origin/main --ff-only 2>/dev/null || git pull origin main
NEW_HASH=$(git rev-parse HEAD)

if [ "$OLD_HASH" == "$NEW_HASH" ]; then
  echo "âœ… Framework jÃ¡ estÃ¡ na versÃ£o mais recente."
else
  echo "ðŸ“¦ Atualizado com sucesso:"
  echo "   Anterior: $OLD_HASH"
  echo "   Atual:    $NEW_HASH"
fi

cd ..

# 4. Atualiza referÃªncia no projeto pai
echo "ðŸ“ Atualizando link do submÃ³dulo no repositÃ³rio pai..."
git add "$FRAMEWORK_PATH"
git commit -m "chore: update antigravity-os core ($NEW_HASH)" 2>/dev/null || echo "â„¹ï¸  Projeto pai jÃ¡ estÃ¡ sincronizado."

# 5. ValidaÃ§Ã£o PÃ³s-AtualizaÃ§Ã£o
echo "ðŸ” Validando integridade da estrutura..."
REQUIRED_FILES=(
  "$FRAMEWORK_PATH/[00] KERNEL/[00] quantum-loader.md"
  "$FRAMEWORK_PATH/[01] ORCHESTRATOR/[00] semantic-router.md"
  "$FRAMEWORK_PATH/[99] INDEX.md"
)

ALL_OK=true
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "âŒ FALHA: Arquivo crÃ­tico ausente: $file"
    ALL_OK=false
  fi
done

if [ "$ALL_OK" = true ]; then
  echo "âœ… Estrutura validada. Framework pronto para uso."
else
  echo "âš ï¸  ValidaÃ§Ã£o falhou. Execute 'git submodule update --init --recursive' para reparar."
  exit 1
fi

echo ""
echo "ðŸŽ‰ AtualizaÃ§Ã£o concluÃ­da!"
echo "ðŸ’¡ Dica: Revise .antigravity-os/[99] INDEX.md para ver novas features ou regras."

``

---


## Arquivo: .antigravity-os/[08] SUBMODULE_HOOKS/[02] validate-structure.sh


``text

#!/bin/bash
# [02] VALIDATE STRUCTURE â€” Verificador de Integridade do Projeto
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[02] validate-structure.sh
# Objetivo: Garantir que as pastas essenciais do Antigravity OS existam no projeto pai.

echo "ðŸ” Verificando integridade da estrutura do projeto..."

# Define o diretÃ³rio raiz do projeto (pai do .antigravity-os)
PROJECT_ROOT=".."

# Lista de pastas crÃ­ticas obrigatÃ³rias
CRITICAL_FOLDERS=(
  "Agentes/"
  "Minhas_Skills/"
  "Nucleo/"
  "context/"
)

# Lista de pastas recomendadas (warning se faltar)
RECOMMENDED_FOLDERS=(
  "Logs/"
  "Minhas_Rules/"
  ".cursorrules"
)

MISSING_CRITICAL=0
MISSING_RECOMMENDED=0

# 1. Verifica Pastas CrÃ­ticas
echo ""
echo "--- Pastas CrÃ­ticas ---"
for folder in "${CRITICAL_FOLDERS[@]}"; do
  if [ -d "$PROJECT_ROOT/$folder" ]; then
    echo "âœ… $folder encontrado."
  else
    echo "âŒ FALHA CRÃTICA: $folder nÃ£o encontrado!"
    MISSING_CRITICAL=$((MISSING_CRITICAL + 1))
  fi
done

# 2. Verifica Pastas Recomendadas
echo ""
echo "--- Arquivos/Pastas Recomendadas ---"
for item in "${RECOMMENDED_FOLDERS[@]}"; do
  if [ -e "$PROJECT_ROOT/$item" ]; then
    echo "âœ… $item encontrado."
  else
    echo "âš ï¸  ATENÃ‡ÃƒO: $item nÃ£o encontrado."
    MISSING_RECOMMENDED=$((MISSING_RECOMMENDED + 1))
  fi
done

# 3. Resultado Final
echo ""
if [ $MISSING_CRITICAL -eq 0 ]; then
  echo "ðŸŽ‰ ValidaÃ§Ã£o CrÃ­tica: SUCESSO"
  if [ $MISSING_RECOMMENDED -gt 0 ]; then
    echo "â„¹ï¸  Nota: $MISSING_RECOMMENDED itens recomendados ausentes. O framework funcionarÃ¡, mas com capacidades reduzidas."
  fi
  exit 0
else
  echo "ðŸ›‘ ValidaÃ§Ã£o CrÃ­tica: FALHA"
  echo "âš ï¸  O framework precisa das pastas listadas acima para orquestrar seus Agentes e Skills."
  echo "   Por favor, crie as pastas faltantes ou restaure o backup do projeto."
  exit 1
fi

``

---


## Arquivo: .antigravity-os/[08] SUBMODULE_HOOKS/[03] sync-memory.sh


``text

#!/bin/bash
# [03] SYNC MEMORY â€” SincronizaÃ§Ã£o Segura de Aprendizado Cross-Project
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[03] sync-memory.sh
# Protocolo: HTTPS Outbound-Only + Cache TTL 24h + SanitizaÃ§Ã£o Rigorosa

set -e

FRAMEWORK_DIR=".antigravity-os"
MEMORY_DIR="$FRAMEWORK_DIR/[04] MEMORY_DNA"
REGISTRY_FILE="$MEMORY_DIR/[00] error-dna-registry.json"
CACHE_DIR="$MEMORY_DIR/.cache"
CACHE_FILE="$CACHE_DIR/synced-registry.json"
TTL_SECONDS=86400 # 24 horas

echo "ðŸ”„ Iniciando sincronizaÃ§Ã£o de MEMORY_DNA..."

# 1. Prepara diretÃ³rio de cache
mkdir -p "$CACHE_DIR"

# 2. Verifica TTL do Cache
if [ -f "$CACHE_FILE" ]; then
  CACHE_AGE=$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE") ))
  if [ "$CACHE_AGE" -lt "$TTL_SECONDS" ]; then
    echo "âœ… Cache local vÃ¡lido (${CACHE_AGE}s). Pulando download."
    exit 0
  fi
  echo "â³ Cache expirado. Atualizando..."
fi

# 3. ConfiguraÃ§Ã£o do Remote (Ajuste se necessÃ¡rio)
REMOTE_URL="https://raw.githubusercontent.com/svw10/Meu_Repo/main/.antigravity-os/[04]%20MEMORY_DNA/[00]%20error-dna-registry.json"

# 4. Download com tratamento de erro
TEMP_FILE=$(mktemp)
if curl -s -f -o "$TEMP_FILE" "$REMOTE_URL"; then
  echo "ðŸ“¥ Download concluÃ­do."
else
  echo "âš ï¸  Falha ao baixar registro remoto. Mantendo cache/local."
  rm -f "$TEMP_FILE"
  exit 1
fi

# 5. SANITIZAÃ‡ÃƒO RIGOROSA (ObrigatÃ³rio por protocolo)
# Remove campos sensÃ­veis que nunca devem ser sincronizados
echo "ðŸ›¡ï¸  Aplicando sanitizaÃ§Ã£o de seguranÃ§a..."
# Nota: Requer jq. Se nÃ£o instalado, avisa e aborta por seguranÃ§a.
if ! command -v jq &> /dev/null; then
  echo "âŒ Erro: 'jq' nÃ£o encontrado. Instale para sincronizaÃ§Ã£o segura."
  rm -f "$TEMP_FILE"
  exit 1
fi

# Filtra apenas campos seguros para compartilhamento cross-project
SAFE_REGISTRY=$(jq '
  .errors = [.errors[] | {
    mutation: .mutation,
    vaccine: .vaccine,
    prevention_prompt: .prevention_prompt,
    immunity_scope: .immunity_scope,
    tech_stack: .tech_stack,
    timestamp: .timestamp,
    # Campos PROIBIDOS no sync: context_snapshot, error_id (pode ter hash local), agent_involved (opcional)
  }]
' "$TEMP_FILE")

echo "$SAFE_REGISTRY" > "$CACHE_FILE"
rm -f "$TEMP_FILE"

# 6. Merge Inteligente com Local
if [ -f "$REGISTRY_FILE" ]; then
  echo "ðŸ”— Mesclando com registro local..."
  # Combina erros locais + remotos, removendo duplicatas por 'mutation' + 'timestamp'
  jq -s '
    .[0].errors + .[1].errors | unique_by(.mutation + .timestamp) | {
      version: "3.1.0-synced",
      description: "Registro sincronizado e sanitizado",
      errors: .,
      last_sync: "'$(date -u +%Y-%m-%dT%H:%M:%SZ)'"
    }
  ' "$REGISTRY_FILE" "$CACHE_FILE" > "${REGISTRY_FILE}.tmp"
  mv "${REGISTRY_FILE}.tmp" "$REGISTRY_FILE"
else
  echo "ðŸ“¦ Nenhum registro local. Aplicando remoto como base."
  cp "$CACHE_FILE" "$REGISTRY_FILE"
fi

echo "âœ… SincronizaÃ§Ã£o concluÃ­da com sucesso."
echo "ðŸ“Š Registros ativos: $(jq '.errors | length' "$REGISTRY_FILE")"
echo "ðŸ’¡ Dica: Execute '/sync-memory' na IDE para forÃ§ar atualizaÃ§Ã£o manual."

``

---


## Arquivo: .antigravity-os/[08] SUBMODULE_HOOKS/[04] generate-evolution-log.sh


``text

#!/bin/bash
# [04] GENERATE EVOLUTION LOG â€” Versionamento AutomÃ¡tico do Framework
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[04] generate-evolution-log.sh
# Objetivo: Ler git log, gerar changelog, incrementar versÃ£o e commitar.

set -e

echo "ðŸš€ Iniciando processo de evoluÃ§Ã£o do Antigravity OS..."

FRAMEWORK_DIR=".antigravity-os"
INDEX_FILE="$FRAMEWORK_DIR/[99] INDEX.md"
LOG_FILE="$FRAMEWORK_DIR/evolution-log.md"
TMP_FILE=$(mktemp)

# 1. Ler VersÃ£o Atual do INDEX.md
echo "ðŸ” Lendo versÃ£o atual..."
CURRENT_VERSION=$(grep -oP 'VersÃ£o:\s*\K[0-9]+\.[0-9]+\.[0-9]+' "$INDEX_FILE" || echo "0.0.0")
echo "   VersÃ£o Atual: $CURRENT_VERSION"

# 2. Incrementar Patch Version (x.y.z -> x.y.z+1)
echo "ðŸ“ˆ Calculando nova versÃ£o..."
MAJOR=$(echo "$CURRENT_VERSION" | cut -d. -f1)
MINOR=$(echo "$CURRENT_VERSION" | cut -d. -f2)
PATCH=$(echo "$CURRENT_VERSION" | cut -d. -f3)
NEW_PATCH=$((PATCH + 1))
NEW_VERSION="$MAJOR.$MINOR.$NEW_PATCH"
echo "   Nova VersÃ£o: $NEW_VERSION"

# 3. Gerar Changelog das Ãºltimas alteraÃ§Ãµes
echo "ðŸ“ Gerando changelog..."
# Pega os Ãºltimos 15 commits que nÃ£o sejam de merge automÃ¡tico
COMMITS=$(git log --pretty=format:"* %s" -15)
DATE=$(date +%Y-%m-%d)

CHANGELOG_ENTRY="## VersÃ£o $NEW_VERSION ($DATE)
$COMMITS

---
"

# 4. Atualizar INDEX.md com nova versÃ£o
echo "ðŸ“„ Atualizando INDEX.md..."
sed -i "s/VersÃ£o:\s*.*$/VersÃ£o: $NEW_VERSION/g" "$INDEX_FILE"
# Atualiza tambÃ©m a linha de "Ãšltima AtualizaÃ§Ã£o"
sed -i "s/\*\*Ãšltima AtualizaÃ§Ã£o:\*\*.*$/\*\*Ãšltima AtualizaÃ§Ã£o:\*\* $DATE/g" "$INDEX_FILE"

# 5. Atualizar Evolution Log (Prepend new entry)
echo "ðŸ“œ Atualizando Evolution Log..."
if [ -f "$LOG_FILE" ]; then
    # Se existe, coloca o novo no topo
    echo "$CHANGELOG_ENTRY" > "$TMP_FILE"
    cat "$LOG_FILE" >> "$TMP_FILE"
    mv "$TMP_FILE" "$LOG_FILE"
else
    # Se nÃ£o existe, cria
    echo -e "# ðŸ§¬ Antigravity OS Evolution Log\n\n$CHANGELOG_ENTRY" > "$LOG_FILE"
fi

# 6. Commitar e Taggear
echo "ðŸ”’ Salvando evoluÃ§Ã£o..."
git add "$INDEX_FILE" "$LOG_FILE"
git commit -m "chore(release): bump version to $NEW_VERSION & update evolution log"
git tag -a "v$NEW_VERSION" -m "Release version $NEW_VERSION"

echo ""
echo "ðŸŽ‰ EvoluÃ§Ã£o concluÃ­da!"
echo "   - Nova VersÃ£o: $NEW_VERSION"
echo "   - Tag criada: v$NEW_VERSION"
echo "   - Push necessÃ¡rio para sincronizar tags."

``

---


## Arquivo: .antigravity-os/[08] SUBMODULE_HOOKS/[05] retro-collector.sh


``text

#!/bin/bash
# Retro Collector â€“ Gera JSON compacto para IA processar
set -e
OUTPUT=".antigravity-os/.cache/retro-input.json"
mkdir -p "$(dirname "$OUTPUT")"

echo "ðŸ“Š Coletando dados para /retro..."

# 1. Erros resolvidos (Ãºltimos 30 dias)
ERRORS=$(grep -h '"vaccine"' .antigravity-os/[04]\ MEMORY_DNA/[00]\ error-dna-registry.json 2>/dev/null | wc -l)

# 2. VariÃ¡veis de ambiente Ãºnicas em src/
ENVS=$(grep -roh "process\.env\.[A-Z_0-9]*" src/ 2>/dev/null | sed 's/process\.env\.//g' | sort -u | jq -R . | jq -s . || echo '[]')

# 3. Uso mÃ©dio de tokens por sprint (simulado via logs ou placeholder)
TOKEN_AVG=$(jq '.global.session_max_tokens * 0.6' .antigravity-os/[00]\ KERNEL/[02]\ token-budget-controller.json 2>/dev/null || echo "null")

# 4. Template base usado
TEMPLATE=$(grep -l "CLERK\|NEON\|RESEND" .env* 2>/dev/null | head -1 || echo "unknown")

jq -n \
  --argjson errors "$ERRORS" \
  --argjson envs "$ENVS" \
  --argjson tokens "$TOKEN_AVG" \
  --arg template "$TEMPLATE" \
  '{
    errors_resolved_count: $errors,
    env_vars_detected: $envs,
    avg_tokens_per_sprint: $tokens,
    template_used: $template,
    collected_at: now
  }' > "$OUTPUT"

echo "âœ… JSON salvo em $OUTPUT. Execute /retro na IDE."

``

---


## Arquivo: .antigravity-os/[09] RETROSPECTIVE/[00] project-sweeper.md


``text

---
name: project-retrospective-sweeper
description: Varredor pÃ³s-projeto. Extrai liÃ§Ãµes, atualiza memÃ³ria/templates/regras com aprovaÃ§Ã£o humana.
version: 1.0.0
trigger: "/retro"
author: Antigravity Meta-Framework
tags: [learning, retrospective, evolution, safe-update]
---

# ðŸ§¹ PROJECT RETROSPECTIVE SWEEPER

## ðŸŽ¯ MissÃ£o
Transformar dados do projeto concluÃ­do em atualizaÃ§Ãµes seguras do framework. **Nenhuma alteraÃ§Ã£o Ã© aplicada sem aprovaÃ§Ã£o explÃ­cita.**

## ðŸš¨ Gatilho
- **Manual:** `/retro` no chat da IDE.
- **SugestÃ£o AutomÃ¡tica:** `DELTA` sugere `/retro` apÃ³s aprovaÃ§Ã£o final de deploy, mas **nÃ£o executa**.

## âš™ï¸ Protocolo â€“ 5 Fases

### Fase 0: Coleta Estruturada (Zero Texto Bruto)
A IA deve solicitar a execuÃ§Ã£o do script `[08] SUBMODULE_HOOKS/[05] retro-collector.sh` e ler APENAS o JSON compacto gerado.
**Campos obrigatÃ³rios no JSON:**
- `errors_resolved[]`, `env_vars_detected[]`, `code_patterns[]`, `token_usage_by_sprint[]`, `template_used`

### Fase 1: Triagem de LiÃ§Ãµes (IA â†’ Humano)
Para cada categoria, a IA gera **apenas 1 pergunta mÃºltipla escolha**. MÃ¡ximo de 5 perguntas por sessÃ£o.

| Categoria | Pergunta PadrÃ£o | OpÃ§Ãµes |
|-----------|----------------|--------|
| Erros CrÃ­ticos | *"Salvar prevenÃ§Ã£o para `{mutation}` em `[04] MEMORY_DNA/`?"* | `a) Global (todos projetos) | b) Stack-specific | c) Ignorar` |
| ConfiguraÃ§Ãµes | *"Atualizar `[11] TEMPLATES/` com novas envs detectadas?"* | `a) Sim (placeholders) | b) Apenas doc | c) NÃ£o` |
| PadrÃµes de CÃ³digo | *"Promover padrÃ£o `{name}` para Skill reutilizÃ¡vel?"* | `a) Criar `[03] SKILLS_ENGINE/` snippet | b) Manter local | c) NÃ£o` |
| OtimizaÃ§Ã£o | *"Ajustar budget/modelo em `[00] KERNEL/token-budget-controller.json`?"* | `a) Aplicar ajuste | b) Documentar | c) Manter` |

### Fase 2: AnÃ¡lise Causal RÃ¡pida
Se `a)` for selecionado, a IA extrai causa raiz em `<50 tokens`:
`"Sintoma â†’ Causa Imediata â†’ Causa Raiz â†’ Vacina Proposta"`

### Fase 3: Dry-Run & Patch Generation
A IA **NUNCA** escreve diretamente. Gera um `proposed-changes.json`:
```json
{
  "patches": [
    {"file": ".antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json", "action": "append", "data": {...}},
    {"file": ".antigravity-os/[11] TEMPLATES/stack-lessons.md", "action": "update", "section": "neon_pooling"}
  ],
  "version_bump": "patch",
  "requires_approval": true
}
```
**Pergunta Final:** *"Aplicar X patches e incrementar versÃ£o para Y? (sim/nÃ£o/ver diffs)"*

### Fase 4: AplicaÃ§Ã£o Segura
ApÃ³s `sim`:
1. Backup automÃ¡tico: `cp <file> <file>.bak`
2. AplicaÃ§Ã£o via script `[05] retro-applier.sh` (valida JSON + aplica)
3. GeraÃ§Ã£o de `[99] INDEX.md` evolution entry
4. Commit automÃ¡tico: `feat(retro): apply lessons from project X â€“ v{new}`

### Fase 5: RelatÃ³rio de EvoluÃ§Ã£o
Atualiza `.antigravity-os/evolution-log.md`:
```markdown
## v{version} ({date})
- âœ… `{mutation}` â†’ prevenÃ§Ã£o global injetada
- ðŸ“¦ Template `nextjs-omega` atualizado com `RESEND_API_KEY`
- ðŸ“Š Tokens/session reduzidos em 18% (ajuste tier-matrix)
---
```

## ðŸš« Regras de SeguranÃ§a Absolutas
- âŒ NUNCA modificar `[00] KERNEL/` ou `[02] SQUAD_WRAPPERS/` sem validaÃ§Ã£o de schema Zod.
- âŒ NUNCA pular `DRY_RUN` ou aprovaÃ§Ã£o humana.
- âŒ NUNCA salvar liÃ§Ãµes sem causa raiz documentada.
- âœ… SEMPRE criar backup `.bak` antes de escrita.
- âœ… SEMPRE validar JSON patch antes de aplicar.

## ðŸ”— IntegraÃ§Ã£o
- LÃª: `[04] MEMORY_DNA/`, `[05] TOKENOMICS/`, git log, `package.json`
- Atualiza: `[03] SKILLS_ENGINE/`, `[11] TEMPLATES/`, `[00] KERNEL/token-budget*`, `evolution-log.md`
- Versionamento: SemÃ¢ntico (`patch`=liÃ§Ãµes, `minor`=novas skills/templates, `major`=mudanÃ§a estrutural â†’ requer PR)

``

---


## Arquivo: .antigravity-os/[11] TEMPLATES/[00] nextjs-omega-base/stack-lessons.md


``text

# ðŸ§¬ STACK OMEGA â€” Next.js + Clerk + Resend + Neon
**Status:** PrÃ©-Validado | **VersÃ£o:** 1.0 | **Origem:** LiÃ§Ãµes de 12+ projetos

## ðŸ“¦ DecisÃµes de Arquitetura (Fixas)
- **Auth:** Clerk (Middleware nativo). âŒ NÃ£o usar Auth0/Cognito salvo exceÃ§Ã£o documentada.
- **Email:** Resend + React Email. âŒ Proibido `nodemailer` ou envio direto de client.
- **DB:** Neon (Serverless Postgres). âœ… ObrigatÃ³rio Pooling/Proxy. âŒ ConexÃ£o direta sem pooler.
- **ORM:** Prisma ou Drizzle (definir no PRD). Se Prisma: usar `neon-http` driver.

## âš™ï¸ PadrÃµes Aprovados (Copiar & Adaptar)

### 1. Clerk Middleware (`app/middleware.ts`)
```typescript
import { authMiddleware } from "@clerk/nextjs";
export default authMiddleware({
  publicRoutes: ["/api/webhook/clerk", "/", "/login"],
});
export const config = { matcher: ["/((?!.+\\.[\\w]+$|_next).*)", "/", "/(api|trpc)(.*)"] };
```

### 2. Resend + ValidaÃ§Ã£o Zod
- Sempre validar payload com `zod` antes de `resend.emails.send`.
- Usar `@react-email/components` para templates tipados.
- **Regra:** Emails transacionais sÃ³ via Server Action.

### 3. Neon Connection Pooling
```env
# .env.example
DATABASE_URL="postgresql://user:pass@ep-xyz.region.aws.neon.tech/db?sslmode=require"
DIRECT_URL="postgresql://user:pass@ep-xyz.region.aws.neon.tech/db?sslmode=require"
```
- **CrÃ­tico:** Em Vercel/Edge, configurar `connection_limit=1` no pooler.
- âŒ **Proibido:** Instanciar `PrismaClient` em `"use client"`.

## ðŸ›¡ï¸ LiÃ§Ãµes CrÃ­ticas (Injetar em MEMORY_DNA)
| ServiÃ§o | Erro Recorrente | Vacina Aplicada |
|---------|----------------|-----------------|
| **Clerk** | Webhook nÃ£o verificado | Validar sempre `webhooks.createEvent` + log falhas em `Logs/auth-errors.log` |
| **Resend** | Rate limit estourado | Implementar fila (Inngest/BullMQ) se >50 emails/min |
| **Neon** | "Too many connections" | Usar `pooler` endpoint + `connection_limit=1` em serverless |

## ðŸš€ IntegraÃ§Ã£o com Antigravity OS
1. Ao invocar `@template:nextjs-omega`, a IA carrega este contexto automaticamente.
2. Pula fase de "pesquisa de stack" â†’ vai direto para `SPECS_WARP`.
3. Todas as configs aqui seguem `Minhas_Rules/SECURITY.md` e `Nucleo/FABRICA_SOFTWARE.md`.

> ðŸ’¡ **Nota:** Este arquivo Ã© imutÃ¡vel por IA. AlteraÃ§Ãµes requerem PR no repositÃ³rio central + aprovaÃ§Ã£o do DELTA.

``

---


