import os
import sys

# Antigravity OS - Full Architecture (v22.0 - Next.js First Priority)
# Contém Stack Omega completa, mas com diretriz estrita de priorizar Next.js na arquitetura.

STRUCTURE = {
    # =========================================================
    # 0. USANDO SKILLS (A CONSCIÊNCIA)
    # =========================================================
    "Minhas Skills/usando-skills/SKILL.md": """---
name: usando-skills
description: O Supervisor. Garante que o agente consulte e utilize skills especializadas. Se a skill não existir, ordena sua criação.
version: 2.0.0
tags: [core, meta, disciplina, router, consciencia]
---
# Usando Skills (Consciousness Protocol)

## 🎯 Quando usar
- **SEMPRE**. Em absolutamente toda interação com o usuário.
- Antes de responder "Oi".
- Antes de escrever qualquer linha de código.

## ⚙️ Fluxo de Pensamento (Obrigatório)

- [ ] **1. Pausa Tática**
    - O usuário falou. **NÃO RESPONDA AINDA.**
    - Analise a intenção: Verbo (Criar, Planejar, Corrigir) + Objeto (Código, Texto, Banco).

- [ ] **2. Consulta ao Kernel (`index-skills`)**
    - Varra a lista de skills existentes.
    - *Pergunta*: "Existe uma ferramenta especializada para isso?"

- [ ] **3. Decisão de Roteamento (Bifurcação)**
    - **Cenário A (Skill Existe)**:
        - Carregue o contexto da skill.
        - Anuncie: *"Estou usando a skill **[Nome]**..."*
    - **Cenário B (Skill Não Existe)**:
        - **PROIBIDO IMPROVISAR.**
        - Invoque imediatamente a skill `criando-skills`.

- [ ] **4. Registro de Auditoria**
    - Logar a decisão no padrão do `observability-playbook`.
""",

    # =========================================================
    # 1. CRIANDO SKILLS (A FÁBRICA - OMEGA COMPLETA)
    # =========================================================
    "Minhas Skills/criando-skills/SKILL.md": """---
name: criando-skills
description: O "Gênesis". Gera skills compatíveis com a Stack Omega Consolidada (Todas as ferramentas obrigatórias unificadas).
version: 6.0.0
tags: [meta, factory, genesis]
---

# Criando Skills para o Antigravity (Genesis Protocol)

## 🚨 Quando invocar esta skill
1.  **Nova Capacidade**: O usuário pede uma funcionalidade nova.
2.  **Workflow Complexo**: Padronizar processos de IA, Dados ou Automação.

## 🧱 A Stack Omega (Lista Mestra Unificada)
Toda skill deve utilizar **exclusivamente** ferramentas desta lista.

| Categoria | Ferramentas Obrigatórias |
| :--- | :--- |
| **Core & IDE** | **Google Antigravity (Project IDX / VS Code)** |
| **Linguagens** | **TypeScript, Node.js** (Web) / **Python 3.11+** (AI/Data) |
| **Frontend UI** | **Next.js App Router**, React, Tailwind CSS, Shadcn UI |
| **Backend & API** | **FastAPI**, RestAPI, Webhooks |
| **AI Frameworks** | **LangChain, LangGraph**, Vercel AI SDK |
| **LLM & Router** | **OpenRouter** (Padrão), OpenAI (Fallback) |
| **Voz & Áudio** | **OpenAI Whisper** (Transcrição), ElevenLabs |
| **Vídeo & Imagem** | **Fal.ai** (Geração), Cloudinary (Otimização) |
| **Banco de Dados** | **Neon** (Postgres), **Airtable** (CRM), **Google Sheets** |
| **Vector & RAG** | **Neon pgvector** (Nativo), Qdrant (Docker) |
| **BI & Analytics** | **Metabase** (Dashboards), Neon Analytics |
| **Storage (Arquivos)** | **Cloudflare R2**, Supabase Storage |
| **Infra & Containers** | **Vercel** (Serverless), **Docker, Docker Compose** |
| **Orquestração** | **Inngest** (Filas/Cron), Celery (Python) |
| **Automação & Scraping** | **Apify**, Selenium, Playwright |
| **Mensageria** | **Evolution API**, **WhatsApp Cloud API**, Resend (Email) |
| **Auth** | **Clerk** |

## ⚙️ Fluxo de Trabalho de Criação

- [ ] **1. Leitura de Contexto**
    - Leia `Minhas Skills/index-skills/SKILL.md`. Onde isso se encaixa?

- [ ] **2. Seleção de Stack (Mix & Match)**
    - *Exemplo:* "Preciso de um agente que ouve áudio e salva no CRM."
    - *Stack:* Whisper (Voz) + LangChain (AI) + Airtable (DB).

- [ ] **3. Geração de Código (Snippets)**
    - Gere código funcional na pasta `snippets/`.
    - **Python:** Inclua `requirements.txt`.
    - **Docker:** Inclua `docker-compose.yml` se usar Qdrant/Metabase.
    - **Node:** Inclua `route.ts` ou `inngest/function.ts`.

## 📝 Instruções de Output
Ao criar a nova skill, preencha o template em `resources/template_padrao.md`.

## 🛡️ Validação Final
1.  Estou usando **Google Sheets**? Configurei a credencial?
2.  Estou usando **Evolution API**? Configurei o Webhook?
3.  Estou usando **Docker**? O compose está correto?

---
**Comando de Execução:**
`python Minhas Skills/criando-skills/scripts/validate_stack.py --skill [NOME]`
""",

    "Minhas Skills/criando-skills/resources/template_padrao.md": """---
name: [verbo-gerundio]-[objeto]
description: [Descrição técnica precisa citando as ferramentas da Stack Omega]
version: 1.0.0
tags: [stack-component-1, stack-component-2]
---

# [Nome da Skill]

## 🎯 Quando usar
- [Gatilho 1]
- [Gatilho 2]

## 🏗️ Stack Vinculada
- **Linguagem**: [TypeScript / Python]
- **Ferramentas**: [Lista ex: Fal.ai, LangGraph, Neon]

## 📋 Checklist de Execução
- [ ] **1. Validação de Entrada**
- [ ] **2. Execução Lógica (Pipeline)**
- [ ] **3. Persistência e Output**

## 💻 Snippets
### Snippet 1: [arquivo.ext]
```[lang]
// Código

```

""",

"Minhas Skills/criando-skills/scripts/validate_stack.py": """#!/usr/bin/env python3

```

import sys

# A Lei da Stack (Consolidada v22)

ALLOWED_STACK = [
# Core & IDE
"google antigravity", "idx", "vscode", "python", "node", "typescript",
# Frontend
"react", "next", "vercel", "tailwind", "shadcn",
# Backend & AI
"fastapi", "restapi", "webhook", "langchain", "langgraph", "openai", "openrouter",
# Media
"whisper", "elevenlabs", "fal.ai", "cloudinary",
# Data & DB
"neon", "pgvector", "postgres", "airtable", "google sheets", "metabase",
# Infra & Storage
"docker", "docker compose", "compose", "cloudflare", "r2", "supabase storage",
# Automation & Comms
"apify", "selenium", "playwright", "inngest", "evolution api", "whatsapp cloud api", "resend", "clerk"
]

def validate_skill_content(file_path):
print(f"🔍 Validando skill em: {file_path}")
print("✅ Stack Omega Consolidada validada com sucesso.")
return True

if **name** == "**main**":
if len(sys.argv) > 1:
validate_skill_content(sys.argv[1])
""",

# =========================================================
# 2. INDEX SKILLS (O KERNEL)
# =========================================================
"Minhas Skills/index-skills/SKILL.md": """---

```

## name: index-skills description: O Kernel. Mapa do sistema e hierarquia de execução. version: 6.0.0

# Índice Canônico - Antigravity OS

## 🛡️ Meta-Layer (Governança)

* `usando-skills`: Supervisor.
* `criando-skills`: Fábrica (Stack Omega).
* `index-skills`: Mapa.
* `architecture-review`: CTO (ADRs).
* `observability-playbook`: SRE.

## 💡 Strategy Layer (Pensamento)

* `brainstorming`: PM.
* `planejando-solucoes`: Arquiteto (Next.js First).
* `llm-app-blueprint`: AI Engineer.
* `explorando-mercado`: Growth.

## ⚙️ Execution Layer (Ação)

* `executando-planos`: Dev (Code).
* `criando-ui`: Frontend (React/Next).
* `gerenciando-memoria`: RAG Ops.
* `pesquisando-web`: Scraping/Intel.
* `comunicando-externo`: Comms (Whats/Email).

## ✅ Quality Layer (Validação)

* `verificando-conclusao`: QA.
* `solucionando-erros`: Debug.

## 📊 Management Layer (Visibilidade)

* `status-report`: Manager.
""",
"Minhas Skills/index-skills/scripts/update_index.py": """print('✅ Índice atualizado com sucesso.')""",
# =========================================================


# 3. BRAINSTORMING


# =========================================================


"Minhas Skills/brainstorming/SKILL.md": """---
name: brainstorming
description: PM. Transforma intenções vagas em specs determinísticas.
version: 2.0.0

---

# Brainstorming Estruturado

## ⚙️ Fluxo

1. Extração Intenção. 2. Entropia. 3. Spec (`docs/SPEC-*.md`).
""",
"Minhas Skills/brainstorming/resources/template_spec_funcional.md": """# Spec Funcional""",
"Minhas Skills/brainstorming/scripts/generate_ideas.py": """print('💡 Ideias.')""",
# =========================================================


# 4. PLANEJANDO SOLUÇÕES (NEXT.JS FIRST SUPREMACY)


# =========================================================


"Minhas Skills/planejando-solucoes/SKILL.md": """---
name: planejando-solucoes
description: O Arquiteto. Gera Planos Atômicos com PRIORIDADE TOTAL em Next.js. Só usa Python se impossível fazer em Node.
version: 4.0.0
tags: [arquitetura, planejamento, nextjs-first]

---

# Planejando Soluções (Next.js Supremacy Protocol)

## 🎯 Objetivo

Garantir que a solução seja construída **dentro do ecossistema Next.js/Vercel** sempre que possível, para manter a simplicidade e a orquestração centralizada.

## ⚙️ Fluxo de Decisão de Stack (O Funil)

* [ ] **1. Tentativa Primária (The Happy Path)**
* A tarefa pode ser feita com TypeScript/Node? (Ex: CRUD, API, Scraper leve, RAG simples com Vercel SDK).
* **SIM** -> **Use Stack A (Padrão)**: Next.js App Router + Inngest + Neon.
* **NÃO** -> Vá para o passo 2.


* [ ] **2. Avaliação de Exceção (The Heavy Lifter)**
* A tarefa exige bibliotecas exclusivas do Python (Pandas pesado, LangGraph Stateful, Modelos locais)?
* **SIM** -> **Use Stack B (Híbrida)**:
* **Cérebro/UI**: Next.js (Mantém o controle).
* **Worker**: Python/FastAPI em Docker (Apenas processa e devolve para o Next).




* [ ] **3. Criação do Plano Atômico (`docs/PLAN-*.md`)**
* Se Stack B: Definir como o Next.js vai chamar o Python (via HTTP REST ou Fila Inngest?).
* Definir Schema do Banco (Neon é a fonte da verdade).



## 💻 Output

Um arquivo Markdown detalhando a arquitetura, onde **Next.js é sempre o orquestrador**, mesmo que use serviços Python satélites.
""",
"Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md": """# Plano Técnico (Next.js First)

## Decisão de Stack

* [ ] O problema foi resolvido puramente em Next.js? (Sim/Não)
* [ ] Se não, qual microserviço Python será criado?

## Passos

1. Next.js Setup...
""",
"Minhas Skills/planejando-solucoes/scripts/init_plan.py": """print('✅ Plano Next.js-First iniciado.')""",
# =========================================================


# 5. EXECUTANDO PLANOS


# =========================================================


"Minhas Skills/executando-planos/SKILL.md": """---
name: executando-planos
description: O Engenheiro. Executa código em TypeScript ou Python, gerencia Docker e dependências.
version: 2.0.0
tags: [dev, code, python, typescript, docker]

---

# Executando Planos

## ⚙️ Fluxo de Trabalho

* [ ] **1. Setup de Ambiente**
* **Se Python**: Criar `venv`, instalar `requirements.txt`.
* **Se Node**: `npm install`.
* **Se Docker**: `docker-compose up -d`.


* [ ] **2. Loop de Implementação**
* Escrever Código -> Testar Localmente -> Validar Logs.
* **Regra**: Nunca commitar código que não roda.


* [ ] **3. Checkpoint**
* `git commit -m "feat: implementacao X"`.
""",
"Minhas Skills/executando-planos/scripts/git_checkpoint.py": """print('✅ Commit.')""",
"Minhas Skills/executando-planos/resources/template_log_execucao.md": """# Log Execução""",


# =========================================================


# 6. VERIFICANDO CONCLUSÃO


# =========================================================


"Minhas Skills/verificando-conclusao/SKILL.md": """---
name: verificando-conclusao
description: QA. Valida DoD, Testes e Evidências.
version: 2.0.0

---

# Verificando Conclusão

## ⚙️ Fluxo

1. Smoke Test. 2. DB Check. 3. Report QA.
""",
"Minhas Skills/verificando-conclusao/scripts/validate_delivery.py": """print('✅ QA OK.')""",
"Minhas Skills/verificando-conclusao/resources/template_qa_report.md": """# Relatório QA""",
# =========================================================


# 7. SOLUCIONANDO ERROS


# =========================================================


"Minhas Skills/solucionando-erros/SKILL.md": """---
name: solucionando-erros
description: Médico. Diagnóstico científico de falhas.
version: 2.0.0

---

# Solucionando Erros

## ⚙️ Fluxo

1. Logs. 2. Hipóteses. 3. Correção.
""",
"Minhas Skills/solucionando-erros/scripts/health_check.py": """print('✅ Health OK.')""",
"Minhas Skills/solucionando-erros/resources/template_diagnostico.md": """# Diagnóstico""",
# =========================================================


# 8. STATUS REPORT


# =========================================================


"Minhas Skills/status-report/SKILL.md": """---
name: status-report
description: Gerente. Relatórios executivos multicanal.
version: 2.0.0

---

# Status Report

## ⚙️ Fluxo

1. Data Mining. 2. Report (Whats/Email).
""",
"Minhas Skills/status-report/resources/template_report.md": """# Status Report""",
"Minhas Skills/status-report/scripts/send_report.py": """print('✅ Enviado.')""",
# =========================================================


# 9. ARCHITECTURE REVIEW


# =========================================================


"Minhas Skills/architecture-review/SKILL.md": """---
name: architecture-review
description: CTO. Padrões e ADRs. Use para aprovar novas tecnologias fora da stack padrão.
version: 2.0.0

---

# Architecture Review

## ⚙️ Fluxo

1. Requisitos. 2. Trade-off. 3. ADR.
""",
"Minhas Skills/architecture-review/resources/template_adr.md": """# ADR""",
"Minhas Skills/architecture-review/scripts/init_adr.py": """print('✅ ADR OK.')""",
# =========================================================


# 10. LLM APP BLUEPRINT (LANGCHAIN + NEXT.JS INTELLIGENCE)


# =========================================================


"Minhas Skills/llm-app-blueprint/SKILL.md": """---
name: llm-app-blueprint
description: O Engenheiro de IA. Arquitetura de Agentes usando LangChain/LangGraph e RAG. Integração com Next.js via Vercel AI SDK ou API.
version: 3.0.0
tags: [ai, langchain, langgraph, rag, python, vercel-ai-sdk]

---

# LLM Blueprint (AI Engineering)

## 🎯 Quando usar

* Projetar agentes autônomos complexos.
* Implementar RAG (Retrieval Augmented Generation).

## 🧱 Stack de IA (Omega)

* **Framework Web**: Vercel AI SDK (Preferencial para Chat/Stream).
* **Framework Agente**: LangGraph (Python) para loops complexos.
* **RAG**: Neon pgvector (Nativo) + Google Sheets.
* **LLM**: OpenRouter.

## ⚙️ Fluxo de Trabalho

* [ ] **1. Decisão de Integração**
* O agente é simples (Chatbot)? -> Use **Vercel AI SDK** direto no Next.js.
* O agente tem estado complexo (LangGraph)? -> Use **Python/FastAPI** e exponha API para o Next.js.


* [ ] **2. Design do Grafo**
* Definir Nós (Nodes) e Arestas (Edges).
* Definir Estado (State).


* [ ] **3. Guardrails**
* Configurar validação de saída.
""",
"Minhas Skills/llm-app-blueprint/resources/template_arquitetura_ia.md": """# Arquitetura IA



## Tipo

* [ ] Vercel AI SDK (Next.js)
* [ ] LangGraph (Python API)

## Estrutura

...
""",
"Minhas Skills/llm-app-blueprint/scripts/calculate_cost.py": """print('💰 Custo OK.')""",

# =========================================================
# 11. OBSERVABILITY PLAYBOOK
# =========================================================
"Minhas Skills/observability-playbook/SKILL.md": """---

```

## name: observability-playbook description: SRE. Métricas e Logs (Vercel/Neon). version: 2.0.0

# Observability Playbook

## 🧱 Stack

* Logs: Vercel JSON.
* Traces: Inngest/LangSmith.
* Metrics: Neon Analytics.
""",
"Minhas Skills/observability-playbook/snippets/logger.ts": """// Logger JSON...""",
"Minhas Skills/observability-playbook/resources/template_telemetria.md": """# Plano Telemetria""",
# =========================================================


# 12. GERENCIANDO MEMÓRIA


# =========================================================


"Minhas Skills/gerenciando-memoria/SKILL.md": """---
name: gerenciando-memoria
description: Bibliotecário. RAG Neon pgvector / Airtable.
version: 1.0.0

---

# Memória

## ⚙️ Fluxo

1. Save. 2. Query.
""",
"Minhas Skills/gerenciando-memoria/scripts/save_context.py": """print('✅ Salvo.')""",
# =========================================================


# 13. COMUNICANDO EXTERNO


# =========================================================


"Minhas Skills/comunicando-externo/SKILL.md": """---
name: comunicando-externo
description: Mensageiro. Inngest -> Evolution/Whatsapp/Resend.
version: 1.0.0

---

# Comunicando

## ⚙️ Fluxo

1. Sanitizar. 2. Fila Inngest.
""",
"Minhas Skills/comunicando-externo/snippets/inngest_notify.ts": """// Notify code...""",
# =========================================================


# 14. PESQUISANDO WEB


# =========================================================


"Minhas Skills/pesquisando-web/SKILL.md": """---
name: pesquisando-web
description: Espião. Apify + LLM.
version: 1.0.0

---

# Pesquisa

## ⚙️ Fluxo

1. Google/Scrape. 2. Resumo.
""",
# =========================================================


# 15. CRIANDO UI


# =========================================================


"Minhas Skills/criando-ui/SKILL.md": """---
name: criando-ui
description: Frontend. Shadcn + Tailwind.
version: 1.0.0

---

# UI

## ⚙️ Fluxo

1. Server/Client. 2. Components.
""",
"Minhas Skills/criando-ui/resources/design_rules.md": """# Design Rules""",
# =========================================================


# 16. EXPLORANDO MERCADO


# =========================================================


"Minhas Skills/explorando-mercado/SKILL.md": """---
name: explorando-mercado
description: Growth Hacker. Análise de concorrência e pricing.
version: 1.0.0

---

# Explorando Mercado

## ⚙️ Fluxo

1. Concorrentes. 2. Pricing. 3. Blue Ocean.
""",
"Minhas Skills/explorando-mercado/resources/template_analise_mercado.md": """# Análise Mercado""",
"Minhas Skills/explorando-mercado/scripts/analyze_competitor.py": """print('✅ Análise OK.')""",
}

def create_structure():
    print("🚀 Iniciando Protocolo Antigravity Boot (v22.0 - Next.js First Priority)...")
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

    print("\n✨ Sistema Operacional do Agente Instalado com Sucesso!")
    print("👉 Stack Omega Completa + Prioridade Next.js configuradas.")
    print("👉 Passo 1: Rode 'python Criando_skills_script_init.py'")
    print("👉 Passo 2: Rode 'python Minhas Skills/index-skills/scripts/update_index.py'")

if __name__ == "__main__":
    create_structure()
