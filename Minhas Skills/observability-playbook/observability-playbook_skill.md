### O Script de Boot (`init_antigravity.py`) - Versão v7.0

import os
import sys

# Antigravity OS - Full Architecture (13 Skills)
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
    # 1. CRIANDO SKILLS (GÊNESIS)
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
## Checklist
- [ ] ...
""",
    "Minhas Skills/criando-skills/scripts/validate_stack.py": """print('✅ Stack OK.')""",

    # =========================================================
    # 2. INDEX SKILLS (ROUTER)
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
    # 3. PLANEJANDO SOLUÇÕES (ARQUITETO)
    # =========================================================
    "Minhas Skills/planejando-solucoes/SKILL.md": """---
name: planejando-solucoes
description: O Arquiteto. Gera Planos Atômicos (Técnicos).
version: 2.0.0
---
# Planejando Soluções
## ⚙️ Fluxo
1. Ler Spec.
2. Definir Schema/Rotas.
3. Plano Atômico.
""",
    "Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md": """# Plano Técnico
## Stack Binding
## Roteiro
""",
    "Minhas Skills/planejando-solucoes/scripts/init_plan.py": """print('✅ Plano iniciado.')""",

    # =========================================================
    # 4. LLM APP BLUEPRINT (ARQUITETO DE IA)
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
    # 5. OBSERVABILITY PLAYBOOK (SENTINELA) - FUSION
    # =========================================================
    "Minhas Skills/observability-playbook/SKILL.md": """---
name: observability-playbook
description: O Sentinela. Define padrão canônico para métricas, logs estruturados e alertas de SLA em sistemas Serverless/Antigravity.
version: 2.0.0
tags: [logs, metrics, monitoring, vercel, inngest, sla]
---

# Observability Playbook (Telemetry Standard)

## 🎯 Quando usar
- Implementar um novo agente ou workflow.
- Definir SLA/SLO (Nível de Serviço).
- Debugar "falhas silenciosas".

> **Regra Obrigatória**: Sem métricas, não há autonomia — há sorte. Nada entra em produção "cego".

## 🧱 Stack de Observabilidade (Serverless)
| Camada | Ferramenta | O que medir? |
| :--- | :--- | :--- |
| **Logs App** | Vercel Logs | JSON Estruturado (Erro, Info, Warn). |
| **Traces** | Inngest | Duração da Task, Retries, Falhas. |
| **Métricas** | Neon Analytics | KPIs de Negócio (ex: `leads_count`). |
| **Alertas** | Evolution API | Notificação WhatsApp se SLA < 99.9%. |

## ⚙️ Fluxo de Trabalho

- [ ] **1. Instrumentação de Código (JSON)**
    - Proibido logar texto puro. Use JSON.
    - **Máscara de Dados**: Nunca logue PII (CPF, Email). Use `sha256(email)`.
    - Formato: `{ "event": "task_start", "userId": "hash", "latency": 200 }`

- [ ] **2. Definição de SLO (Objetivo)**
    - Ex: "99% das tasks de IA devem responder em < 15s".
    - Orçamento de Erro: "Podemos falhar 1% das vezes antes de acordar o humano".

- [ ] **3. Alertas Inteligentes (Inngest)**
    - Configurar um Workflow `monitor-sla` que roda a cada 1h.
    - Se falhas > limiar, disparar Evolution API.

- [ ] **4. Auditoria Diária (Neon)**
    - Salvar métricas agregadas na tabela `daily_metrics` para análise de ROI.

## 📋 Checklist de Logs Seguros
✅ **Correto**: `{ "event": "rag_retrieval", "score": 0.89, "doc_id": "uuid" }`
❌ **Proibido**: `{ "prompt": "Qual o salário do CEO?", "response": "R$..." }`

## 💻 Snippets
`import { logger } from "@/lib/logger"`
""",

    "Minhas Skills/observability-playbook/snippets/logger.ts": """// Logger Canônico para Vercel/Next.js
// Remove dados sensíveis automaticamente
export const logger = {
  info: (meta: object) => console.log(JSON.stringify({ level: 'info', timestamp: new Date(), ...meta })),
  error: (meta: object) => console.error(JSON.stringify({ level: 'error', timestamp: new Date(), ...meta })),
};
""",

    "Minhas Skills/observability-playbook/resources/template_telemetria.md": """# Plano de Telemetria: [Feature]
## 1. SLOs (Metas)
- [ ] Latência p95 < [X]ms
- [ ] Taxa de Sucesso > [X]%

## 2. Eventos Críticos
- `task_started`
- `task_completed` (com custo de tokens)
- `sla_breach` (Alerta!)
""",

    # =========================================================
    # 6. EXECUTANDO PLANOS (ENGENHEIRO)
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
    # 7. VERIFICANDO CONCLUSÃO (QA)
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
    # 8. SOLUCIONANDO ERROS (MÉDICO)
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
    # 9. GERENCIANDO MEMÓRIA (RAG)
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
    # 10. COMUNICANDO EXTERNO (MENSAGEIRO)
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
    # 11. PESQUISANDO WEB (ESPIÃO)
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
    # 12. CRIANDO UI (ARTISTA)
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
    print("🚀 Iniciando Protocolo Antigravity Boot (13 Skills)...")
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

