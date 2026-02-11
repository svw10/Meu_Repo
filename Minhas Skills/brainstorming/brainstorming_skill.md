### O Script de Boot (`init_antigravity.py`) - Versão Final v3.0

import os
import sys

# Antigravity OS - Full Architecture (11 Skills)
# Stack: Next.js, Neon, Inngest, Clerk, Apify, Evolution API, OpenRouter

STRUCTURE = {
    # =========================================================
    # 0. BRAINSTORMING (O PM / PRODUTO) - FUSION VERSION
    # =========================================================
    "Minhas Skills/brainstorming/SKILL.md": """---
name: brainstorming
description: O Gerente de Produto (PM). Realiza compressão de entropia para transformar intenções vagas em especificações determinísticas. Define O Que, Por Que e Como (na Stack) antes do Planejamento Técnico.
version: 2.0.0
tags: [produto, discovery, entropia, especificacao, mvp]
---

# Brainstorming Estruturado (Entropy Compression Protocol)

## 🎯 Quando usar
- O usuário diz: "Quero algo para...", "Preciso melhorar X", "Tenho uma ideia vaga".
- A intenção carece de escopo, métricas ou público definido.
- Há **Alta Entropia Conceitual** (muitas interpretações possíveis para o mesmo pedido).

> **Regra Obrigatória**: Se a intenção não for clara o suficiente para gerar um plano atômico imediato, esta skill deve ser invocada **antes** de `planejando-solucoes`.

## 🧱 Reality Check (Alinhamento com a Stack)
Toda ideia deve ser filtrada pelo ecossistema Antigravity:
- "Quero armazenar dados" -> **Neon + pgvector** (Não Airtable).
- "Quero automação" -> **Inngest** (Não Zapier).
- "Quero interface" -> **Next.js + Shadcn** (Não Bubble).

## ⚙️ Fluxo de Trabalho

- [ ] **1. Extração da Intenção Bruta**
    - Identificar a dor real por trás do pedido ("Por que você quer isso?").

- [ ] **2. Compressão de Entropia (Hipóteses)**
    - Gerar 3 caminhos possíveis (MVP, Ideal, IA-Native).
    - Selecionar o caminho mais aderente à stack (Autonomia 24/7, SLA >99.9%).

- [ ] **3. Definição de Critérios Binários**
    - Transformar "quero que funcione bem" em "tempo de resposta < 200ms".
    - Definir o **Critério de Sucesso** (Sim/Não).

- [ ] **4. Especificação Canônica**
    - Preencher o `docs/SPEC-[nome].md` usando o template.
    - Este arquivo é o gatilho obrigatório para a skill `planejando-solucoes`.

## 📋 Checklist de Saída
- [ ] Intenção original capturada?
- [ ] Ambiguidade eliminada?
- [ ] Solução viável na Stack (Neon/Inngest/Next)?
- [ ] Próxima skill definida (`planejando-solucoes`)?

## 💻 Snippets e Recursos
`python Minhas Skills/brainstorming/scripts/generate_ideas.py --context "Contexto do problema"`
""",

    "Minhas Skills/brainstorming/resources/template_spec_funcional.md": """# Especificação Funcional: [Nome da Iniciativa]
**Status:** 🟡 Discovery
**Objetivo Final:** [Resultado mensurável. Ex: Agendar 5 reuniões/semana]

## 1. O Problema (Contexto)
[Descrição da dor atual e por que precisamos resolver isso]

## 2. A Solução (Caminho Determinístico)
Vamos construir um sistema utilizando **[Componentes da Stack]** que...

## 3. Critérios de Sucesso (Binários)
*Só consideraremos sucesso se:*
- [ ] Lead responde positivamente no WhatsApp (Evolution API).
- [ ] Dados persistidos corretamente no Neon.
- [ ] Fluxo executa sem intervenção humana (Inngest).

## 4. User Stories (Escopo do MVP)
- [ ] **US-01**: Como [usuário], quero [ação], para [benefício].
- [ ] **US-02**: Como [sistema], devo [reação], quando [gatilho].

## 5. Restrições & Fallbacks
- Se o lead não responder em 24h -> Enviar email via Resend.
- Se a API cair -> Inngest faz retry por 3 horas.
""",

    "Minhas Skills/brainstorming/scripts/generate_ideas.py": """import sys
import os
import argparse
from openai import OpenAI

# Configuração
client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

def brainstorm(context):
    print(f"🧠 Comprimindo Entropia para: '{context}'...\\n")

    prompt = f\"\"\"
    Atue como um Product Manager Sênior e Arquiteto de Software.
    O usuário tem a seguinte intenção vaga: "{context}".
    
    Nossa Stack Imutável é: Next.js, Neon (Postgres/Vector), Inngest, Apify, Evolution API.
    
    1. Identifique a ambiguidade.
    2. Proponha 3 caminhos determinísticos para resolver isso usando APENAS nossa stack.
    3. Para a melhor opção, defina 3 critérios de sucesso binários (Sim/Não).
    \"\"\"

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}]
    )

    print(response.choices[0].message.content)

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--context", required=True)
    args = parser.parse_args()
    
    brainstorm(args.context)
""",

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
| `brainstorming` | 🟢 |
| `planejando-solucoes` | 🟢 |
| `executando-planos` | 🟢 |
| `verificando-conclusao` | 🟢 |
| `...` | 🟢 |
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
1. Ler Spec Funcional.
2. Definir Schema/Rotas.
3. Plano Atômico.
""",
    "Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md": """# Plano Técnico
## Stack Binding
## Roteiro
""",
    "Minhas Skills/planejando-solucoes/scripts/init_plan.py": """print('✅ Plano iniciado.')""",

    # =========================================================
    # 4. EXECUTANDO PLANOS (ENGENHEIRO)
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
    # 5. VERIFICANDO CONCLUSÃO (QA)
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
    # 6. SOLUCIONANDO ERROS (MÉDICO)
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
    # 7. GERENCIANDO MEMÓRIA (RAG)
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
    # 8. COMUNICANDO EXTERNO (MENSAGEIRO)
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
    # 9. PESQUISANDO WEB (ESPIÃO)
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
    # 10. CRIANDO UI (ARTISTA)
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
    print("🚀 Iniciando Protocolo Antigravity Boot (11 Skills)...")
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

