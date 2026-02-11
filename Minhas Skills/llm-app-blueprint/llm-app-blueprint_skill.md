### O Script de Boot (`init_antigravity.py`) - Versão Completa

import os
import sys

# Antigravity OS - Full Architecture (12 Skills)
# Stack: Next.js, Neon, Inngest, Clerk, Apify, Evolution API, OpenRouter

STRUCTURE = {
    # =========================================================
    # 0. BRAINSTORMING (O PM / PRODUTO)
    # =========================================================
    "Minhas Skills/brainstorming/SKILL.md": """---
name: brainstorming
description: O Gerente de Produto (PM). Realiza compressão de entropia para transformar intenções vagas em especificações determinísticas.
version: 2.0.0
tags: [produto, discovery, entropia, especificacao, mvp]
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
    # 4. LLM APP BLUEPRINT (ARQUITETO DE IA) - FUSION
    # =========================================================
    "Minhas Skills/llm-app-blueprint/SKILL.md": """---
name: llm-app-blueprint
description: O Engenheiro de IA. Define arquitetura de RAG no Neon, Guardrails, Avaliação e Custos. Obrigatório para sistemas cognitivos.
version: 2.0.0
tags: [ai, llm, rag, guardrails, neon, pgvector]
---

# Blueprint para Aplicações com LLM (Cognitive Architecture)

## 🎯 Quando usar
- Projetar agentes, RAG ou fluxos de chat.
- Implementar Guardrails e Roteamento Semântico.
- Auditar sistemas existentes para SLA >99.9%.

> **Regra Obrigatória**: Improvisação em LLM = Alucinação. Siga o blueprint.

## 🧱 Stack Cognitiva (Neon First)
- **RAG / Memória**: **Neon + pgvector**.
    - *Branching*: Use branches do Neon (`dev-rag`, `main`) para testar novos embeddings.
- **Modelo**: OpenRouter (Roteamento entre GPT-4o, Claude 3.5, Llama 3).
- **Orquestração**: Inngest (Agentes de longa duração, Retries).
- **Validação**: Zod (Structured Output).

## ⚙️ Fluxo de Trabalho

- [ ] **1. Camada de Entrada (Roteamento)**
    - Definir se a query precisa de RAG, de Tool Use ou apenas Chat.
    - *Ex: "Falar com suporte" -> Rota A; "Resumir texto" -> Rota B.*

- [ ] **2. Configuração RAG (Neon)**
    - Tabela: `documents (embedding vector(1536))`.
    - Índice: HNSW (`vector_cosine_ops`).
    - Estratégia: Hybrid Search (se necessário) ou Semantic Search padrão.

- [ ] **3. Guardrails & Segurança**
    - Input: Rejeitar Prompt Injection.
    - Output: Validar Schema JSON com Zod.
    - Fallback: "Não sei responder" em vez de inventar.

- [ ] **4. Avaliação (LLM-as-Judge)**
    - Implementar um passo de "Crítica" onde um modelo menor avalia a resposta do maior.
    - Logar resultados: `llm_eval_score` (1-5).

## 📋 Checklist de Conformidade
- [ ] Fallback de modelo configurado (ex: Claude -> GPT-4o -> Haiku)?
- [ ] Orçamento por task definido (max tokens)?
- [ ] RAG usando índices HNSW no Neon?

## 💻 Snippets
`python Minhas Skills/llm-app-blueprint/scripts/calculate_cost.py`
""",

    "Minhas Skills/llm-app-blueprint/resources/template_arquitetura_ia.md": """# Arquitetura Cognitiva: [Nome]

## 1. Estratégia de Modelos (OpenRouter)
- **Primário**: `anthropic/claude-3.5-sonnet` (Raciocínio)
- **Secundário (Fallback)**: `openai/gpt-4o-mini` (Velocidade/Custo)
- **Max Cost/Run**: $0.05

## 2. RAG no Neon
- **Tabela**: `knowledge_base`
- **Embedding**: `text-embedding-3-small`
- **Chunking**: 512 tokens com overlap de 50.

## 3. Guardrails (Zod)
```typescript
const ResponseSchema = z.object({
  answer: z.string(),
  confidence: z.number().min(0).max(1),
  sources: z.array(z.string())
});


## 4. Avaliação (LLM-as-Judge)

* Critério: "A resposta cita apenas fontes fornecidas no contexto?"
* Prompt de Juiz: "Score 1 (Alucinação) a 5 (Factual)."
""",
"Minhas Skills/llm-app-blueprint/scripts/calculate_cost.py": """import sys

# Calculadora simples de custo baseada em tokens

print("💰 Custo estimado por 1k execuções: $X.XX")
""",

# =========================================================
# 5. EXECUTANDO PLANOS (ENGENHEIRO)
# =========================================================
"Minhas Skills/executando-planos/SKILL.md": """---



## name: executando-planos description: O Engenheiro. Executa código e commits. version: 1.0.0

# Executando Planos

## ⚙️ Fluxo

1. Build Loop (Code -> Validate -> Commit).
""",
"Minhas Skills/executando-planos/scripts/git_checkpoint.py": """print('✅ Commit.')""",
"Minhas Skills/executando-planos/resources/template_log_execucao.md": """# Log Execução""",
# =========================================================


# 6. VERIFICANDO CONCLUSÃO (QA)


# =========================================================


"Minhas Skills/verificando-conclusao/SKILL.md": """---
name: verificando-conclusao
description: O Auditor. Valida DoD e Testes.
version: 2.0.0


# Verificando Conclusão

## ⚙️ Fluxo

1. Smoke Test.
2. DB Check.
3. Report QA.
""",
"Minhas Skills/verificando-conclusao/scripts/validate_delivery.py": """print('✅ QA OK.')""",
"Minhas Skills/verificando-conclusao/resources/template_qa_report.md": """# Relatório QA""",
# =========================================================


# 7. SOLUCIONANDO ERROS (MÉDICO)


# =========================================================


"Minhas Skills/solucionando-erros/SKILL.md": """---
name: solucionando-erros
description: Diagnóstico de falhas e Logs.
version: 2.0.0


# Solucionando Erros

## ⚙️ Fluxo

1. Coleta Logs.
2. Hipóteses.
3. Correção.
""",
"Minhas Skills/solucionando-erros/scripts/health_check.py": """print('✅ Health OK.')""",
"Minhas Skills/solucionando-erros/resources/template_diagnostico.md": """# Diagnóstico""",
# =========================================================


# 8. GERENCIANDO MEMÓRIA (RAG)


# =========================================================


"Minhas Skills/gerenciando-memoria/SKILL.md": """---
name: gerenciando-memoria
description: RAG com Neon pgvector.
version: 1.0.0


# Memória

## ⚙️ Fluxo

1. Save. 2. Query.
""",
"Minhas Skills/gerenciando-memoria/scripts/save_context.py": """print('✅ Salvo.')""",
# =========================================================


# 9. COMUNICANDO EXTERNO (MENSAGEIRO)


# =========================================================


"Minhas Skills/comunicando-externo/SKILL.md": """---
name: comunicando-externo
description: WhatsApp/Email via Inngest.
version: 1.0.0


# Comunicando

## ⚙️ Fluxo

1. Sanitizar. 2. Fila Inngest.
""",
"Minhas Skills/comunicando-externo/snippets/inngest_notify.ts": """// Notify code...""",
# =========================================================


# 10. PESQUISANDO WEB (ESPIÃO)


# =========================================================


"Minhas Skills/pesquisando-web/SKILL.md": """---
name: pesquisando-web
description: Apify + LLM.
version: 1.0.0


# Pesquisa

## ⚙️ Fluxo

1. Google/Scrape. 2. Resumo.
""",
# =========================================================


# 11. CRIANDO UI (ARTISTA)


# =========================================================


"Minhas Skills/criando-ui/SKILL.md": """---
name: criando-ui
description: Next.js + Tailwind + Shadcn.
version: 1.0.0


# UI

## ⚙️ Fluxo

1. Server/Client. 2. Components.
""",
"Minhas Skills/criando-ui/resources/design_rules.md": """# Design Rules""",
}

def create_structure():
print("🚀 Iniciando Protocolo Antigravity Boot (12 Skills)...")
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


if **name** == "**main**":
create_structure()

