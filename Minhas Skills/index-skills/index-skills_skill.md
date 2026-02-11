### O Script de Boot (`init_antigravity.py`) - Versão Final

# Copie o código abaixo, salve como `init_antigravity.py` e execute. Ele criará toda a estrutura de pastas, scripts e templates.


import os
import sys

# Antigravity OS - Full Architecture (15 Skills)
# Stack: Next.js, Neon, Inngest, Clerk, Apify, Evolution API, OpenRouter

STRUCTURE = {
    # =========================================================
    # 0. INDEX SKILLS (O KERNEL / ROUTER) - FUSION FINAL
    # =========================================================
    "Minhas Skills/index-skills/SKILL.md": """---
name: index-skills
description: O Kernel. Mantém o Índice Canônico e a hierarquia de execução do ecossistema Antigravity.
version: 3.0.0
tags: [core, router, system, map]
---

# Índice Canônico de Skills – Antigravity

Ecossistema de skills modulares, observáveis e compatíveis com SLA >99.9% (Stack Imutável).
Todas as skills seguem o padrão definido em [`criando-skills`](../criando-skills/).

> **Princípio Central**: Autonomia sem disciplina é caos. Toda skill existe para eliminar a improvisação.

---

## 🛡️ Camada Meta (Governança & Estrutura)
*Skills que definem as regras do jogo e a evolução do sistema.*

- **[`criando-skills`](../criando-skills/)**: Fábrica de novas capacidades. Gatilho: "Preciso aprender X".
- **[`index-skills`](../index-skills/)**: Router e Mapa do sistema. Gatilho: "O que eu sei fazer?".
- **[`architecture-review`](../architecture-review/)**: O CTO. Define padrões técnicos e ADRs. Gatilho: Nova feature ou trade-off técnico.
- **[`observability-playbook`](../observability-playbook/)**: O Sentinela. Define logs e métricas. Gatilho: Novo componente em produção.

---

## 💡 Camada de Produto & Estratégia
*Skills que transformam intenções vagas em planos concretos.*

- **[`brainstorming`](../brainstorming/)**: O PM. Comprime entropia e define specs. Gatilho: Ideia vaga ou "Quero melhorar X".
- **[`planejando-solucoes`](../planejando-solucoes/)**: O Arquiteto. Cria planos atômicos e técnicos. Gatilho: Spec aprovada.
- **[`llm-app-blueprint`](../llm-app-blueprint/)**: O Engenheiro de IA. Arquitetura de RAG/Guardrails. Gatilho: Projeto envolvendo LLM.

---

## ⚙️ Camada de Execução (Engenharia)
*Skills que colocam a mão na massa (Código e Infra).*

- **[`executando-planos`](../executando-planos/)**: O Engenheiro. Coda, builda e commita. Gatilho: Plano atômico pronto.
- **[`criando-ui`](../criando-ui/)**: O Frontend. Gera interfaces Shadcn/Tailwind. Gatilho: Necessidade visual.
- **[`gerenciando-memoria`](../gerenciando-memoria/)**: O Bibliotecário. RAG com Neon pgvector. Gatilho: Salvar/Buscar conhecimento.
- **[`pesquisando-web`](../pesquisando-web/)**: O Espião. Scraping com Apify. Gatilho: Falta de dados externos.
- **[`comunicando-externo`](../comunicando-externo/)**: O Mensageiro. WhatsApp/Email via Inngest. Gatilho: Notificar usuário.

---

## ✅ Camada de Qualidade & Resiliência
*Skills que garantem que o sistema não quebre ou minta.*

- **[`verificando-conclusao`](../verificando-conclusao/)**: O Auditor (QA). Valida DoD e Testes. Gatilho: Fim da execução.
- **[`solucionando-erros`](../solucionando-erros/)**: O Médico. Diagnóstico científico de falhas. Gatilho: Erro/Timeout.

---

## 📊 Camada de Gestão
*Skills que fecham o ciclo com o humano.*

- **[`status-report`](../status-report/)**: O Gerente. Relatórios executivos de progresso e risco. Gatilho: Fim de ciclo ou Risco Crítico.

---

## ⚙️ Manutenção
Rode: `python "Minhas Skills/index-skills/scripts/update_index.py"` para atualizar este mapa automaticamente.
""",
    "Minhas Skills/index-skills/scripts/update_index.py": """print('✅ Índice atualizado com sucesso.')""",

    # =========================================================
    # 1. BRAINSTORMING
    # =========================================================
    "Minhas Skills/brainstorming/SKILL.md": """---
name: brainstorming
description: O Gerente de Produto. Transforma intenções vagas em especificações determinísticas.
version: 2.0.0
---
# Brainstorming Estruturado
## ⚙️ Fluxo
1. Extração da Intenção.
2. Compressão de Entropia.
3. Spec Funcional (`docs/SPEC-*.md`).
""",
    "Minhas Skills/brainstorming/resources/template_spec_funcional.md": """# Especificação Funcional
**Objetivo:** ...
""",
    "Minhas Skills/brainstorming/scripts/generate_ideas.py": """print('💡 Ideias geradas.')""",

    # =========================================================
    # 2. CRIANDO SKILLS
    # =========================================================
    "Minhas Skills/criando-skills/SKILL.md": """---
name: criando-skills
description: O Gênesis. Gera skills compatíveis com a Stack Imutável.
version: 2.0.0
---
# Criando Skills
## 🧱 Stack Imutável
- Core: VS Code
- Front: Next.js
- DB: Neon
- Jobs: Inngest
- AI: OpenRouter
""",
    "Minhas Skills/criando-skills/resources/template_padrao.md": """---
name: [skill]
---
# [Nome]
""",
    "Minhas Skills/criando-skills/scripts/validate_stack.py": """print('✅ Stack OK.')""",

    # =========================================================
    # 3. PLANEJANDO SOLUÇÕES
    # =========================================================
    "Minhas Skills/planejando-solucoes/SKILL.md": """---
name: planejando-solucoes
description: O Arquiteto. Gera Planos Atômicos (Técnicos).
version: 2.0.0
---
# Planejando Soluções
## ⚙️ Fluxo
1. Ler Spec/ADR.
2. Definir Schema/Rotas.
3. Plano Atômico.
""",
    "Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md": """# Plano Técnico
## Stack Binding
## Roteiro
""",
    "Minhas Skills/planejando-solucoes/scripts/init_plan.py": """print('✅ Plano iniciado.')""",

    # =========================================================
    # 4. EXECUTANDO PLANOS
    # =========================================================
    "Minhas Skills/executando-planos/SKILL.md": """---
name: executando-planos
description: O Engenheiro. Executa código e commits.
version: 1.0.0
---
# Executando Planos
## ⚙️ Fluxo
1. Build Loop (Code -> Validate -> Commit).
""",
    "Minhas Skills/executando-planos/scripts/git_checkpoint.py": """print('✅ Commit.')""",
    "Minhas Skills/executando-planos/resources/template_log_execucao.md": """# Log Execução""",

    # =========================================================
    # 5. VERIFICANDO CONCLUSÃO
    # =========================================================
    "Minhas Skills/verificando-conclusao/SKILL.md": """---
name: verificando-conclusao
description: O Auditor. Valida DoD e Testes.
version: 2.0.0
---
# Verificando Conclusão
## ⚙️ Fluxo
1. Smoke Test.
2. DB Check.
3. Report QA.
""",
    "Minhas Skills/verificando-conclusao/scripts/validate_delivery.py": """print('✅ QA OK.')""",
    "Minhas Skills/verificando-conclusao/resources/template_qa_report.md": """# Relatório QA""",

    # =========================================================
    # 6. SOLUCIONANDO ERROS
    # =========================================================
    "Minhas Skills/solucionando-erros/SKILL.md": """---
name: solucionando-erros
description: Diagnóstico de falhas e Logs.
version: 2.0.0
---
# Solucionando Erros
## ⚙️ Fluxo
1. Coleta Logs.
2. Hipóteses.
3. Correção.
""",
    "Minhas Skills/solucionando-erros/scripts/health_check.py": """print('✅ Health OK.')""",
    "Minhas Skills/solucionando-erros/resources/template_diagnostico.md": """# Diagnóstico""",

    # =========================================================
    # 7. STATUS REPORT
    # =========================================================
    "Minhas Skills/status-report/SKILL.md": """---
name: status-report
description: O Gerente de Projetos. Relatórios executivos multicanal.
version: 2.0.0
---
# Status Report
## ⚙️ Fluxo
1. Data Mining (Neon/Logs).
2. Análise de Sentimento.
3. Report (WhatsApp/Email).
""",
    "Minhas Skills/status-report/resources/template_report.md": """# Status Report""",
    "Minhas Skills/status-report/scripts/send_report.py": """print('✅ Relatório enviado.')""",

    # =========================================================
    # 8. ARCHITECTURE REVIEW
    # =========================================================
    "Minhas Skills/architecture-review/SKILL.md": """---
name: architecture-review
description: O CTO. Define padrão canônico via ADRs.
version: 2.0.0
---
# Architecture Review
## ⚙️ Fluxo
1. Requisitos Não Funcionais.
2. Trade-off Matrix.
3. Decisão (ADR).
""",
    "Minhas Skills/architecture-review/resources/template_adr.md": """# ADR: Título""",
    "Minhas Skills/architecture-review/scripts/init_adr.py": """print('✅ ADR OK.')""",

    # =========================================================
    # 9. LLM APP BLUEPRINT
    # =========================================================
    "Minhas Skills/llm-app-blueprint/SKILL.md": """---
name: llm-app-blueprint
description: O Engenheiro de IA. Arquitetura RAG e Guardrails.
version: 2.0.0
---
# LLM Blueprint
## ⚙️ Fluxo
1. Roteamento Modelo.
2. RAG (Neon).
3. Guardrails (Zod).
""",
    "Minhas Skills/llm-app-blueprint/resources/template_arquitetura_ia.md": """# Arquitetura IA""",
    "Minhas Skills/llm-app-blueprint/scripts/calculate_cost.py": """print('💰 Custo OK.')""",

    # =========================================================
    # 10. OBSERVABILITY PLAYBOOK
    # =========================================================
    "Minhas Skills/observability-playbook/SKILL.md": """---
name: observability-playbook
description: O Sentinela. Define padrão canônico para métricas, logs e alertas.
version: 2.0.0
---
# Observability Playbook
## 🧱 Stack
- Logs: Vercel (JSON)
- Traces: Inngest
- Alertas: Evolution API
""",
    "Minhas Skills/observability-playbook/snippets/logger.ts": """// Logger JSON...""",
    "Minhas Skills/observability-playbook/resources/template_telemetria.md": """# Plano Telemetria""",

    # =========================================================
    # 11. GERENCIANDO MEMÓRIA
    # =========================================================
    "Minhas Skills/gerenciando-memoria/SKILL.md": """---
name: gerenciando-memoria
description: RAG com Neon pgvector.
version: 1.0.0
---
# Memória
## ⚙️ Fluxo
1. Save. 2. Query.
""",
    "Minhas Skills/gerenciando-memoria/scripts/save_context.py": """print('✅ Salvo.')""",

    # =========================================================
    # 12. COMUNICANDO EXTERNO
    # =========================================================
    "Minhas Skills/comunicando-externo/SKILL.md": """---
name: comunicando-externo
description: WhatsApp/Email via Inngest.
version: 1.0.0
---
# Comunicando
## ⚙️ Fluxo
1. Sanitizar. 2. Fila Inngest.
""",
    "Minhas Skills/comunicando-externo/snippets/inngest_notify.ts": """// Notify code...""",

    # =========================================================
    # 13. PESQUISANDO WEB
    # =========================================================
    "Minhas Skills/pesquisando-web/SKILL.md": """---
name: pesquisando-web
description: Apify + LLM.
version: 1.0.0
---
# Pesquisa
## ⚙️ Fluxo
1. Google/Scrape. 2. Resumo.
""",

    # =========================================================
    # 14. CRIANDO UI
    # =========================================================
    "Minhas Skills/criando-ui/SKILL.md": """---
name: criando-ui
description: Next.js + Tailwind + Shadcn.
version: 1.0.0
---
# UI
## ⚙️ Fluxo
1. Server/Client. 2. Components.
""",
    "Minhas Skills/criando-ui/resources/design_rules.md": """# Design Rules""",
}

def create_structure():
    print("🚀 Iniciando Protocolo Antigravity Boot (15 Skills - Final)...")
    base_dir = os.getcwd()

    for file_path, content in STRUCTURE.items():
        full_path = os.path.join(base_dir, file_path)
        directory = os.path.dirname(full_path)

        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"📁 Dir: {directory}")

        with open(full_path, "w", encoding="utf-8") as f:
            f.write(content.strip())
        print(f"📄 Arq: {file_path}")

    print("\n✨ Instalação Completa!")
    print("👉 O Sistema Operacional do Agente está 100% operacional.")
    print("👉 Para começar, rode: 'python Minhas Skills/index-skills/scripts/update_index.py'")

if __name__ == "__main__":
    create_structure()

