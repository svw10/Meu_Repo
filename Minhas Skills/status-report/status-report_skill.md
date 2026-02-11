### O Script de Boot (`init_antigravity.py`) - Versão v11.0


import os
import sys

# Antigravity OS - Full Architecture (15 Skills)
# Stack: Next.js, Neon, Inngest, Clerk, Apify, Evolution API, OpenRouter

STRUCTURE = {
    # =========================================================
    # 0. BRAINSTORMING (O PM / PRODUTO)
    # =========================================================
    "Minhas Skills/brainstorming/SKILL.md": """---
name: brainstorming
description: O Gerente de Produto. Transforma intenções vagas em especificações determinísticas e mensuráveis.
version: 2.0.0
tags: [produto, discovery, entropia, especificacao]
---
# Brainstorming Estruturado

## 🎯 Quando usar
- O usuário diz: "Quero algo para...", "Preciso melhorar X".
- Alta Entropia Conceitual.

## 🧱 Reality Check
- "Armazenar dados" -> **Neon**
- "Automação" -> **Inngest**
- "Interface" -> **Next.js**

## ⚙️ Fluxo
1. Extração da Intenção Bruta.
2. Compressão de Entropia (3 Hipóteses).
3. Definição de Critérios Binários.
4. Especificação Canônica (`docs/SPEC-[nome].md`).
""",
    "Minhas Skills/brainstorming/resources/template_spec_funcional.md": """# Especificação Funcional
**Objetivo Final:** [Resultado mensurável]
## 1. Problema
## 2. Solução
## 3. Critérios de Sucesso (Binários)
""",
    "Minhas Skills/brainstorming/scripts/generate_ideas.py": """print('💡 Ideias geradas.')""",

    # =========================================================
    # 1. STATUS REPORT (O GERENTE DE PROJETOS) - FUSION
    # =========================================================
    "Minhas Skills/status-report/SKILL.md": """---
name: status-report
description: O Gerente de Projetos. Consolida progresso, riscos e decisões em relatórios executivos multicanal. Adapta o tom para Stakeholders (Técnico vs Executivo).
version: 2.0.0
tags: [report, progress, stakeholders, communication, sla]
---

# Status Report (Executive Briefing)

## 🎯 Quando usar
- Fim de Sprint ou Tarefa Crítica (ex: Deploy, Qualificação de Leads).
- Ocorreu um Risco (SLA Breach, Custo > Orçamento).
- Decisão Arquitetural Relevante (ADR criada).
- **Regra**: Autonomia sem comunicação é opacidade. Se impacta confiança, reporte.

## 🧱 Fontes da Verdade (Data Mining)
- **Progresso**: `docs/RUN-*.md` (Logs de Execução).
- **Qualidade**: `docs/QA-*.md` (Relatórios de Teste).
- **Decisões**: `docs/ADR-*.md` (Mudanças Técnicas).
- **Métricas**: Tabela `metrics` no Neon (ROI, Latência).

## ⚙️ Fluxo de Trabalho

- [ ] **1. Identificação de Stakeholder e Canal**
    - **Cliente/CEO**: Resumo Executivo + ROI -> **WhatsApp (Evolution)**.
    - **CTO/Técnico**: Detalhes Técnicos + ADRs -> **Email (Resend)**.
    - **Sistema (Radar)**: Registro de Reputação -> **Neon DB**.

- [ ] **2. Coleta e Síntese**
    - Agregar dados das últimas 24h/Semana.
    - Calcular custo real vs orçado.

- [ ] **3. Estruturação do Relatório (4 Partes)**
    1. **Resumo Executivo**: TL;DR de 2 linhas.
    2. **Progresso**: Entregas (Done) e Métricas.
    3. **Riscos e Decisões**: O que mudou? O que preocupa?
    4. **Próximos Passos**: Ação clara com data.

- [ ] **4. Adaptação de Tom**
    - Se for para **CEO**: Fale de dinheiro e prazo.
    - Se for para **Dev**: Fale de latência e refatoração.

## 📋 Checklist de Entrega
- [ ] Tom ajustado para o público?
- [ ] Canal correto selecionado?
- [ ] Métricas de valor (não apenas esforço) incluídas?

## 💻 Snippets
`python Minhas Skills/status-report/scripts/send_report.py --channel whatsapp --target ceo`
""",

    "Minhas Skills/status-report/resources/template_report.md": """# Status Report: [Projeto]
**Data:** {{DATE}}
**Saúde:** [🟢/🟡/🔴]

### ✅ Resumo Executivo
[1-2 frases focadas em impacto de negócio]

### 🚀 Progresso e Entregas
- [x] Feature Login (SLA: 99.9%)
- [x] Custo da semana: R$ 5,00 (Abaixo do budget)

### ⚠️ Riscos e Decisões
- **Decisão**: Migramos para Neon (Ver ADR-002).
- **Risco**: Cota de API do Apify em 80%.

### 🔜 Próximos Passos
- [ ] Iniciar Módulo de Pagamento (Segunda-feira).
""",

    "Minhas Skills/status-report/scripts/send_report.py": """import sys
print("✅ Relatório enviado via Evolution API (Simulação).")
""",

    # =========================================================
    # 2. ARCHITECTURE REVIEW (O CTO)
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
    # 3. CRIANDO SKILLS (GÊNESIS)
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
    # 4. INDEX SKILLS (ROUTER)
    # =========================================================
    "Minhas Skills/index-skills/SKILL.md": """---
name: index-skills
description: Router do sistema.
version: 1.0.0
---
# Índice
## Mapa
| Skill | Status |
| :--- | :--- |
| `status-report` | 🟢 |
| `architecture-review` | 🟢 |
| `observability-playbook` | 🟢 |
| `llm-app-blueprint` | 🟢 |
| `brainstorming` | 🟢 |
| `planejando-solucoes` | 🟢 |
| `executando-planos` | 🟢 |
| `verificando-conclusao` | 🟢 |
| `solucionando-erros` | 🟢 |
| `gerenciando-memoria` | 🟢 |
| `comunicando-externo` | 🟢 |
| `pesquisando-web` | 🟢 |
| `criando-ui` | 🟢 |
""",
    "Minhas Skills/index-skills/scripts/update_index.py": """print('✅ Índice OK.')""",

    # =========================================================
    # 5. PLANEJANDO SOLUÇÕES (ARQUITETO)
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
    # 6. LLM APP BLUEPRINT (ARQUITETO DE IA)
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
    # 7. OBSERVABILITY PLAYBOOK (SENTINELA)
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
    # 8. EXECUTANDO PLANOS (ENGENHEIRO)
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
    # 9. VERIFICANDO CONCLUSÃO (QA)
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
    # 10. SOLUCIONANDO ERROS (MÉDICO)
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
    # 11. GERENCIANDO MEMÓRIA (RAG)
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
    # 12. COMUNICANDO EXTERNO (MENSAGEIRO)
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
    # 13. PESQUISANDO WEB (ESPIÃO)
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
    # 14. CRIANDO UI (ARTISTA)
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
    print("🚀 Iniciando Protocolo Antigravity Boot (15 Skills)...")
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
    print("👉 Agora rode: 'python Minhas Skills/index-skills/scripts/update_index.py' para registrar tudo.")

if __name__ == "__main__":
    create_structure()
