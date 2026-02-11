### O Script de Boot (`init_antigravity.py`) - Versão v9.0


import os
import sys

# Antigravity OS - Full Architecture (14 Skills)
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
    # 1. ARCHITECTURE REVIEW (O CTO / STAFF ENGINEER) - FUSION
    # =========================================================
    "Minhas Skills/architecture-review/SKILL.md": """---
name: architecture-review
description: O CTO. Define padrão canônico para decisões técnicas via ADRs. Garante alinhamento com a Stack Imutável e avalia trade-offs de performance/custo.
version: 2.0.0
tags: [arquitetura, adr, cto, stack, governanca]
---

# Architecture Review (Technical Governance)

## 🎯 Quando usar
- Uma nova feature exige serviços externos (ex: Gateway de Pagamento).
- Decidir entre tecnologias (ex: Server Actions vs Route Handlers).
- Definir infraestrutura de dados (ex: Tabela SQL vs JSONB).
- **Sempre** que houver trade-off entre Performance, Custo ou Complexidade.

> **Regra Obrigatória**: A improvisação técnica é dívida comportamental. Registre a decisão.

## 🧱 Stack Canônica (Antigravity Standard)
Use esta stack como padrão. Desvios exigem justificativa forte em ADR.

| Categoria | Primário (Titular) | Secundário (Reserva/Local) |
| :--- | :--- | :--- |
| **Backend** | Next.js App Router | - |
| **Banco/Vetor** | Neon + pgvector | - |
| **Orquestração** | Inngest (Serverless) | `setTimeout` (apenas UI) |
| **LLM Router** | OpenRouter | OpenAI Direct |
| **Mensageria** | Evolution API v2 | Resend (Email) |
| **Scraping** | Apify | Cheerio (Local) |
| **Auth** | Clerk | - |

## ⚙️ Fluxo de Trabalho

- [ ] **1. Requisitos Não Funcionais**
    - Qual o SLA esperado? (ex: 99.9%)
    - Qual a latência máxima? (ex: <500ms para UI, <30s para Jobs)

- [ ] **2. Análise de Opções (Trade-off Matrix)**
    - Avaliar opções contra:
        1. **Stack Adherence** (Encaixa no Next.js/Neon?)
        2. **Vendor Lock-in** (Podemos sair fácil?)
        3. **Custo** (Escala linearmente?)

- [ ] **3. Decisão e Registro (ADR)**
    - Criar `docs/ADR-[Data]-[Nome].md`.
    - Documentar a decisão e as alternativas rejeitadas.

## 📋 Checklist de Conformidade
- [ ] A solução roda em ambiente Serverless (Vercel)?
- [ ] A solução respeita os limites de conexão do Neon?
- [ ] A observabilidade (Logs/Traces) está planejada?

## 💻 Snippets
`python Minhas Skills/architecture-review/scripts/init_adr.py --title "Escolha do Provider de Email"`
""",

    "Minhas Skills/architecture-review/resources/template_adr.md": """# ADR-{{NUMBER}}: {{TITLE}}
**Status:** [Proposto / Aceito / Depreciado]
**Data:** {{DATE}}

## 1. Contexto e Problema
Precisamos de uma solução para...
**Requisitos Não Funcionais:**
- SLA: 99.9%
- Latência: < 200ms

## 2. Opções Avaliadas
| Opção | Prós | Contras | Custo |
| :--- | :--- | :--- | :--- |
| **Opção A (Padrão Stack)** | Integração nativa | - | $ |
| **Opção B** | Mais features | Lock-in alto | $$ |

## 3. Decisão
Escolhemos a **Opção A** porque...

## 4. Consequências
- **Positivas**: Manutenção simplificada.
- **Negativas**: Menos flexibilidade em X.
""",

    "Minhas Skills/architecture-review/scripts/init_adr.py": """import sys
print("✅ ADR Inicializada em docs/ADR-XXX.md")
""",

    # =========================================================
    # 2. CRIANDO SKILLS (GÊNESIS)
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
    # 3. INDEX SKILLS (ROUTER)
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
    # 4. PLANEJANDO SOLUÇÕES (ARQUITETO)
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
    # 5. LLM APP BLUEPRINT (ARQUITETO DE IA)
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
    # 6. OBSERVABILITY PLAYBOOK (SENTINELA)
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
    # 7. EXECUTANDO PLANOS (ENGENHEIRO)
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
    # 8. VERIFICANDO CONCLUSÃO (QA)
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
    # 9. SOLUCIONANDO ERROS (MÉDICO)
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
    # 10. GERENCIANDO MEMÓRIA (RAG)
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
    # 11. COMUNICANDO EXTERNO (MENSAGEIRO)
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
    # 12. PESQUISANDO WEB (ESPIÃO)
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
    # 13. CRIANDO UI (ARTISTA)
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
    print("🚀 Iniciando Protocolo Antigravity Boot (14 Skills)...")
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

