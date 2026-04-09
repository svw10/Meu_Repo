#!/usr/bin/env python3
"""
Antigravity OS Neural Integration v3.1
Cria camada de orquestração SEM alterar estrutura existente.
Execute: python integrate_antigravity.py
"""
import json
from pathlib import Path

# MAPEAMENTO DO SEU ECOSISTEMA EXISTENTE
EXISTING = {
    "agents": "Agentes/",
    "skills": "Minhas_Skills/", 
    "rules": "Minhas_Rules/",
    "core": "Nucleo/",
    "context": "context/",
    "logs": "logs.md"
}

ROOT = Path(".antigravity-os")

def write(path: Path, content: str):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(content.strip(), encoding="utf-8")
    print(f"✅ {path}")

def create_framework():
    # [00] KERNEL
    write(ROOT / "[00] KERNEL" / "[00] quantum-loader.md", f"""---
name: quantum-loader | version: 3.1.0
---
# Detecção Automática de Modo

## GEM (Google AI Studio) → Modo BETA
- Permitido: planejamento, PRD, especificações
- Proibido: escrever arquivos, executar código
- Saída: PLAN.md para exportação

## IDX (VSCode/Cursor) → Modo GAMMA  
- Permitido: codar, testar, commitar
- Proibido: gerar PLAN.md (deve ler existente)
- Entrada: PLAN.md do GEM

## Fallback Seguro
Se detecção falhar → assume IDX + alerta usuário.

## Token Budget Inicial
GEM: 4000 tokens | IDX: 8000 tokens
""")

    write(ROOT / "[00] KERNEL" / "[01] mode-router.json", json.dumps({
        "version": "3.1.0",
        "modes": {
            "GEM": {"agents": ["THETA","BETA","EPSILON","ALPHA"], "forbidden": ["write_file","execute_code"]},
            "IDX": {"agents": ["THETA","GAMMA","DELTA","ZETA","ETA"], "requires": "PLAN.md"}
        },
        "fallback": "IDX_safe_mode",
        "transition": "GEM→PLAN→IDX→EXEC→DELTA_AUDIT"
    }, indent=2))

    write(ROOT / "[00] KERNEL" / "[02] token-budget-controller.json", json.dumps({
        "version": "3.1.0",
        "budgets": {
            "grep": {"max": 500, "alert_at": 400},
            "agent_call": {"max": 1000, "alert_at": 800},
            "code_gen": {"max": 8000, "alert_at": 6400},
            "debug": {"max": 3000, "alert_at": 2400}
        },
        "global": {"session_max": 50000, "alert_at_pct": 80, "hard_stop_at_pct": 95},
        "enforcement": "soft"
    }, indent=2))

    # [01] ORCHESTRATOR
    write(ROOT / "[01] ORCHESTRATOR" / "[00] semantic-router.md", f"""---
name: semantic-router | wrapper para {EXISTING['context']}ROUTER.md
---
# Fluxo de Roteamento Otimizado

1. Detecta modo via [00] KERNEL/quantum-loader.md
2. Lê {EXISTING['context']}ROUTER.md (seu arquivo)
3. Consulta budget em [00] KERNEL/token-budget-controller.json
4. Se budget OK → carrega agente de {EXISTING['agents']}[NOME]_Prime.md
5. Se budget NOK → sugere alternativa (ex: ZETA ao invés de GAMMA)
6. Atualiza {EXISTING['context']}CURRENT_AGENT.md

## Regra de Ouro
Nunca carregar agente sem validar budget primeiro.
""")

    # [02] SQUAD_WRAPPERS (metadados dos 8 agentes)
    squad = ROOT / "[02] SQUAD_WRAPPERS"
    for i, (agent, cost, mode, trigger) in enumerate([
        ("theta", 50, "orchestration", "always_first"),
        ("beta", 200, "GEM_only", "planning_needed"),
        ("gamma", 100, "IDX_only", "build_needed"),
        ("eta", 150, "debug", "error_detected"),
        ("zeta", 80, "optimize", "slow_performance"),
        ("delta", 120, "audit", "pre_commit"),
        ("epsilon", 90, "growth", "market_analysis"),
        ("alpha", 60, "bootstrap", "new_project")
    ]):
        write(squad / f"[{i:02d}] {agent}-meta.json", json.dumps({
            "name": agent.upper(),
            "source": f"{EXISTING['agents']}{agent.upper()}_Prime.md",
            "cost_tokens": cost,
            "mode": mode,
            "trigger": trigger,
            "fallback": "THETA" if agent != "theta" else "ZETA"
        }, indent=2))

    # [03] SKILLS_ENGINE
    write(ROOT / "[03] SKILLS_ENGINE" / "[00] skills-constellation.json", json.dumps({
        "version": "3.1.0",
        "root": EXISTING['skills'],
        "lazy_load": True,
        "cache_ttl": "24h",
        "mapping": {
            "01_brainstorming": f"{EXISTING['skills']}ESTRATEGIA_DISCOVERY/01_brainstorming.md",
            "06_codando": f"{EXISTING['skills']}EXECUCAO_IMPLEMENTACAO/06_codando.md",
            "12_usando_skills": f"{EXISTING['skills']}CORE/12_usando_skills.md"
        }
    }, indent=2))

    write(ROOT / "[03] SKILLS_ENGINE" / "[01] retrieval-decision-matrix.json", json.dumps({
        "rules": {
            "if_input_lt_100_chars": "use:LEXICAL_GREP",
            "if_code_snippet": "use:GREP",
            "if_architecture": "use:RAG",
            "if_external_api": "use:MCP"
        },
        "priority": {"speed": "GREP", "accuracy": "RAG", "cost": "LEXICAL"}
    }, indent=2))

    # [04] MEMORY_DNA
    write(ROOT / "[04] MEMORY_DNA" / "[00] error-dna-registry.json", json.dumps({
        "version": "3.1.0",
        "schema": {
            "hash": "md5(context+error)",
            "markers": ["stack_hash", "tech_stack", "agent"],
            "vaccine": "solução_aplicada",
            "immunity": ["project", "all_projects", "stack_omega"],
            "ttl_days": 90
        },
        "integration": f"Lê {EXISTING['logs']} e converte para DNA"
    }, indent=2))

    # [05] TOKENOMICS
    write(ROOT / "[05] TOKENOMICS" / "[00] tier-strategy.md", """
# Estratégia por Tier

## Senior Mode (Simbólico)
- @schema:User ao invés de colar schema inteiro
- @skill:06 ao invés de carregar skill completa
- Economia: ~70% tokens

## Differential Updates
- Envia git diff, não arquivo completo
- Integrado com [08] SUBMODULE_HOOKS
""")

    # [06] SECURITY_DRL
    write(ROOT / "[06] SECURITY_DRL" / "[00] pii-sanitization.md", f"""
# Sanitização PII - Dr. Lexia Style

## Camadas
1. Pre-commit: regex local para CPF/email/telefone
2. Agent Local: Phi-3 Mini para anonimização (Squad_IA)
3. Pós-processamento: verifica vazamento no frontend

## Proteção do Núcleo
{EXISTING['core']} é READ-ONLY via submódulo.
""")

    # [07] SPECS_WARP
    write(ROOT / "[07] SPECS_WARP" / "[00] prd-business-template.md", f"""
# PRD Template - Integrado com {EXISTING['core']}FABRICA_SOFTWARE.md

## Sequência Obrigatória
1. User Story → 2. Business Rules → 3. Acceptance Criteria (sem código)

## Gate de Aprovação
Só chama GAMMA (codar) após DELTA aprovar este PRD.
""")

    # [08] SUBMODULE_HOOKS
    hooks = ROOT / "[08] SUBMODULE_HOOKS"
    write(hooks / "[00] init-submodule.sh", f"""#!/bin/bash
git submodule add https://github.com/svw10/antigravity-os.git .antigravity-os
git submodule update --init --recursive
echo "✅ Integrado. Nunca edite .antigravity-os/ diretamente!"
""")

    write(hooks / "[01] update-core.sh", """#!/bin/bash
cd .antigravity-os && git pull origin main && cd ..
git add .antigravity-os && git commit -m "chore: update antigravity-os core"
""")

    # [99] INDEX
    write(ROOT / "[99] INDEX.md", f"""
# ANTAGRAVITY OS NEURAL - ÍNDICE MESTRE

## Modo GEM (Google AI Studio)
Leia: [00] KERNEL/ → [01] ORCHESTRATOR/ → {EXISTING['skills']}CORE/00_index_skills.md

## Modo IDX (VSCode/Cursor)  
Leia: [00] KERNEL/ → [01] ORCHESTRATOR/ → {EXISTING['context']}CURRENT_AGENT.md

## Estrutura Existente (READ-ONLY via wrapper)
- Agentes: {EXISTING['agents']}
- Skills: {EXISTING['skills']}
- Regras: {EXISTING['rules']}
- Núcleo: {EXISTING['core']}

## Comandos
1. `python integrate_antigravity.py` ← cria esta camada
2. `bash .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh` ← novos projetos
""")

    # .cursorrules atualizado
    write(Path(".cursorrules"), f"""
# ANTAGRAVITY OS NEURAL - CURSORRULES

on_start: |
  1. Leia .antigravity-os/[00] KERNEL/[00] quantum-loader.md (detecta modo)
  2. Leia .antigravity-os/[01] ORCHESTRATOR/[00] semantic-router.md
  3. Consulte {EXISTING['context']}ROUTER.md para agente
  4. Valide budget em [00] KERNEL/[02] token-budget-controller.json

on_task: |
  - GEM: Use BETA + {EXISTING['skills']}ESTRATEGIA_DISCOVERY/
  - IDX: Use GAMMA + {EXISTING['skills']}EXECUCAO_IMPLEMENTACAO/
  - Sempre consulte [04] MEMORY_DNA/[00] error-dna-registry.json antes

forbidden: |
  - Nunca edite {EXISTING['core']} de dentro do projeto filho
  - Nunca execute sem validar budget
  - Nunca ignore modo (GEM vs IDX)
""")

    print("\n🚀 Antigravity OS Neural v3.1 criado com sucesso!")
    print("✅ Estrutura existente preservada")
    print("✅ Próximo: git add .antigravity-os/ .cursorrules && git commit -m 'feat: neural orchestration layer'")

if __name__ == "__main__":
    create_framework()
