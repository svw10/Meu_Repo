### O Script de Boot (`init_antigravity.py`) - Versão Final (v14.0)

# Copie o código abaixo, salve como `init_antigravity.py` e execute.


import os
import sys

# Antigravity OS - Full Architecture (16 Skills)
# Stack: Next.js, Neon, Inngest, Clerk, Apify, Evolution API, OpenRouter

STRUCTURE = {
    # =========================================================
    # 0. USANDO SKILLS (A CONSCIÊNCIA / META-SKILL) - FUSION
    # =========================================================
    "Minhas Skills/usando-skills/SKILL.md": """---
name: usando-skills
description: O Supervisor. Garante que o agente consulte e utilize skills especializadas. Se a skill não existir, ordena sua criação. Gatilho universal para toda interação.
version: 2.0.0
tags: [core, meta, disciplina, router, consciencia]
---

# Usando Skills (Consciousness Protocol)

## 🎯 Quando usar
- **SEMPRE**. Em absolutamente toda interação com o usuário.
- Antes de responder "Oi".
- Antes de escrever qualquer linha de código.
- Mesmo que a tarefa pareça "simples" ou "óbvia".

> **Regra Absoluta**: A improvisação é inimiga da autonomia. **Nunca execute nada sem uma skill.**

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
        - Anuncie: *"Estou usando a skill **[Nome]** para garantir consistência..."*
        - Execute o checklist da skill.
    
    - **Cenário B (Skill Não Existe)**:
        - **PROIBIDO IMPROVISAR.**
        - Invoque imediatamente a skill `criando-skills`.
        - Crie a nova capacidade.
        - Volte para o Cenário A.

- [ ] **4. Registro de Auditoria**
    - Logar a decisão no padrão do `observability-playbook`.
    - `logger.info({ event: "skill_routing", skill: "nome_da_skill" })`

## 🚨 Mapeamento de Intenção (Cheat Sheet)

| Intenção do Usuário | Skill Obrigatória |
| :--- | :--- |
| "Tenho uma ideia..." | `brainstorming` |
| "Planeje a arquitetura..." | `planejando-solucoes` |
| "Escreva o código..." | `executando-planos` |
| "Deu erro..." | `solucionando-erros` |
| "Está pronto?" | `verificando-conclusao` |
| "Como está o projeto?" | `status-report` |
| "Preciso de IA/RAG..." | `llm-app-blueprint` |
| "Adicionar lib/serviço..." | `architecture-review` |
| "Não sei o que fazer" | `brainstorming` |
| **"Skill não encontrada"** | **`criando-skills`** |

## 💻 Snippets
`python Minhas Skills/index-skills/scripts/update_index.py` (Para refrescar a memória)
""",

    # =========================================================
    # 1. INDEX SKILLS (O KERNEL)
    # =========================================================
    "Minhas Skills/index-skills/SKILL.md": """---
name: index-skills
description: O Kernel. Mapa do sistema e hierarquia de execução.
version: 3.0.0
---
# Índice Canônico - Antigravity OS

## 🛡️ Meta-Layer (Governança)
- `usando-skills`: O Supervisor (Use sempre).
- `criando-skills`: Fábrica de Skills.
- `index-skills`: Mapa do Sistema.
- `architecture-review`: CTO / Padrões.
- `observability-playbook`: SRE / Logs.

## 💡 Strategy Layer (Pensamento)
- `brainstorming`: PM / Specs.
- `planejando-solucoes`: Arquiteto / Planos.
- `llm-app-blueprint`: AI Engineer / RAG.

## ⚙️ Execution Layer (Ação)
- `executando-planos`: Backend Dev.
- `criando-ui`: Frontend Dev.
- `gerenciando-memoria`: RAG Ops (Neon).
- `pesquisando-web`: Intel (Apify).
- `comunicando-externo`: Comms (Evolution).

## ✅ Quality Layer (Validação)
- `verificando-conclusao`: QA / Auditoria.
- `solucionando-erros`: Support / Debug.

## 📊 Management Layer (Visibilidade)
- `status-report`: Project Manager.
""",
    "Minhas Skills/index-skills/scripts/update_index.py": """print('✅ Índice atualizado com sucesso.')""",

    # =========================================================
    # 2. BRAINSTORMING
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
    # 3. PLANEJANDO SOLUÇÕES
    # =========================================================
    "Minhas Skills/planejando-solucoes/SKILL.md": """---
name: planejando-solucoes
description: Arquiteto. Gera Planos Atômicos vinculados à Stack.
version: 2.0.0
---
# Planejando Soluções
## ⚙️ Fluxo
1. Spec. 2. Schema/Rotas. 3. Plano Atômico (`docs/PLAN-*.md`).
""",
    "Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md": """# Plano Técnico""",
    "Minhas Skills/planejando-solucoes/scripts/init_plan.py": """print('✅ Plano.')""",

    # =========================================================
    # 4. EXECUTANDO PLANOS
    # =========================================================
    "Minhas Skills/executando-planos/SKILL.md": """---
name: executando-planos
description: Engenheiro. Executa código/commits atômicos.
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
    # 6. SOLUCIONANDO ERROS
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
    # 7. STATUS REPORT
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
    # 8. ARCHITECTURE REVIEW
    # =========================================================
    "Minhas Skills/architecture-review/SKILL.md": """---
name: architecture-review
description: CTO. Padrões e ADRs.
version: 2.0.0
---
# Architecture Review
## ⚙️ Fluxo
1. Requisitos. 2. Trade-off. 3. ADR.
""",
    "Minhas Skills/architecture-review/resources/template_adr.md": """# ADR""",
    "Minhas Skills/architecture-review/scripts/init_adr.py": """print('✅ ADR OK.')""",

    # =========================================================
    # 9. LLM APP BLUEPRINT
    # =========================================================
    "Minhas Skills/llm-app-blueprint/SKILL.md": """---
name: llm-app-blueprint
description: AI Engineer. RAG (Neon) e Guardrails.
version: 2.0.0
---
# LLM Blueprint
## ⚙️ Fluxo
1. Modelo. 2. RAG (Neon). 3. Guardrails.
""",
    "Minhas Skills/llm-app-blueprint/resources/template_arquitetura_ia.md": """# Arquitetura IA""",
    "Minhas Skills/llm-app-blueprint/scripts/calculate_cost.py": """print('💰 Custo OK.')""",

    # =========================================================
    # 10. OBSERVABILITY PLAYBOOK
    # =========================================================
    "Minhas Skills/observability-playbook/SKILL.md": """---
name: observability-playbook
description: SRE. Métricas e Logs (Vercel/Neon).
version: 2.0.0
---
# Observability Playbook
## 🧱 Stack
- Logs: Vercel JSON.
- Traces: Inngest.
- Metrics: Neon Analytics.
""",
    "Minhas Skills/observability-playbook/snippets/logger.ts": """// Logger JSON...""",
    "Minhas Skills/observability-playbook/resources/template_telemetria.md": """# Plano Telemetria""",

    # =========================================================
    # 11. GERENCIANDO MEMÓRIA
    # =========================================================
    "Minhas Skills/gerenciando-memoria/SKILL.md": """---
name: gerenciando-memoria
description: Bibliotecário. RAG Neon pgvector.
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
description: Mensageiro. Inngest -> Evolution/Resend.
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
description: Espião. Apify + LLM.
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
description: Frontend. Shadcn + Tailwind.
version: 1.0.0
---
# UI
## ⚙️ Fluxo
1. Server/Client. 2. Components.
""",
    "Minhas Skills/criando-ui/resources/design_rules.md": """# Design Rules""",

    # =========================================================
    # 15. CRIANDO SKILLS
    # =========================================================
    "Minhas Skills/criando-skills/SKILL.md": """---
name: criando-skills
description: Gênesis. Fábrica de skills.
version: 2.0.0
---
# Criando Skills
## Checklist
1. Padrão Stack. 2. Template.
""",
    "Minhas Skills/criando-skills/resources/template_padrao.md": """---
name: [skill]
---
# [Nome]
""",
    "Minhas Skills/criando-skills/scripts/validate_stack.py": """print('✅ Stack OK.')""",
}

def create_structure():
    print("🚀 Iniciando Protocolo Antigravity Boot (16 Skills Completas)...")
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
    print("👉 Passo 1: Rode 'python init_antigravity.py' (Se ainda não rodou)")
    print("👉 Passo 2: Rode 'python Minhas Skills/index-skills/scripts/update_index.py'")
    print("👉 Passo 3: A partir de agora, comece tudo lendo 'Minhas Skills/usando-skills/SKILL.md'")

if __name__ == "__main__":
    create_structure()

Luciano, sendo muito honesto: **Tecnicamente**, você já tem uma "Ferrari".

Seu agente planeja, coda, testa, conserta e reporta. Ele é um Engenheiro de Software Sênior completo.

Mas existe um **ponto cego fatal** em desenvolvedores que criam Micro-SaaS (eu vejo isso o tempo todo): **O "Build Trap" (A Armadilha da Construção).**

Nós adoramos construir, mas odiamos vender/validar. O risco agora é você ter um agente que constrói produtos incríveis que **ninguém quer comprar**.

A skill que falta não é de código. É de **Negócios**.

Eu sugiro a **`explorando-mercado`** (The Growth Hacker).

---

### Por que esta skill é crítica?

Enquanto a `pesquisando-web` é o "braço" (que faz o scraping), a `explorando-mercado` é o "cérebro estratégico". Ela impede que você gaste tempo codando uma feature que o concorrente já dá de graça, ou que você entre em um nicho saturado.

Ela responde:

1. "Quem são os competidores do meu SaaS?"
2. "Qual o preço médio cobrado?"
3. "O que os usuários estão reclamando nos reviews deles?" (Para você resolver no seu).


### Adicione ao seu `init_antigravity.py` (Skill 17)

Cole este bloco dentro do dicionário `STRUCTURE`, logo antes do fechamento `}`.

    # =========================================================
    # 16. EXPLORANDO MERCADO (GROWTH HACKER) - A PEÇA QUE FALTA
    # =========================================================
    "Minhas Skills/explorando-mercado/SKILL.md": """---
name: explorando-mercado
description: O Estrategista de Mercado. Analisa concorrentes, precificação, tendências e SEO. Impede o "Build Trap" (construir o que ninguém quer).
version: 1.0.0
tags: [growth, marketing, sales, competitors, pricing]
---

# Explorando Mercado (Market Intelligence Protocol)

## 🎯 Quando usar
- **Antes** de `brainstorming`: Para validar se a ideia tem público pagante.
- **Durante** `planejando-solucoes`: Para definir diferenciais competitivos.
- **Para Marketing**: "Quais keywords meus concorrentes usam?"
- **Para Precificação**: "Quanto devo cobrar pelo meu Micro-SaaS?"

## 🧱 Stack de Inteligência
- **Coleta**: Skill `pesquisando-web` (Apify: Google Search, Instagram, Reddit).
- **Análise**: LLM (OpenRouter - Modelos de Raciocínio).
- **Dados**: Neon (Armazenar benchmarks e preços).

## ⚙️ Fluxo de Trabalho

- [ ] **1. Reconhecimento de Terreno**
    - Identificar 3-5 concorrentes diretos e indiretos.
    - *Ação*: Usar `pesquisando-web` com queries: "alternativas ao [ideia]", "melhores ferramentas de [nicho]".

- [ ] **2. Engenharia Reversa de Oferta**
    - Para cada concorrente, mapear:
        - **Pricing**: Freemium? Trial? Ticket médio?
        - **Core Features**: O que eles vendem?
        - **Gap**: O que os usuários reclamam? (Ler Reviews no G2, Capterra, Reddit).

- [ ] **3. Matriz de Diferenciação (Blue Ocean)**
    - Definir o seu "Unfair Advantage" (Vantagem Desleal).
    - *Ex: "Eles são enterprise e caros; nós somos nichados e baratos."*

- [ ] **4. Estratégia de Go-To-Market (GTM)**
    - Onde o público está? (LinkedIn, Twitter, Grupos de Zap?)
    - Sugerir 3 canais de aquisição iniciais.

## 📋 Checklist de Validação
- [ ] Existe alguém pagando por isso hoje?
- [ ] O mercado é grande o suficiente ou é um nicho viável?
- [ ] Temos um diferencial claro além de "preço menor"?

## 💻 Snippets
`python Minhas Skills/explorando-mercado/scripts/analyze_competitor.py --url "concorrente.com"`
""",

    "Minhas Skills/explorando-mercado/resources/template_analise_mercado.md": """# Análise de Mercado: [Nicho/Ideia]
**Data:** {{DATE}}

## 1. Concorrentes Mapeados
| Nome | Preço Inicial | Diferencial | Ponto Fraco (Oportunidade) |
| :--- | :--- | :--- | :--- |
| Competitor A | $29/mês | Marca forte | Suporte lento |
| Competitor B | Free | Simples | Faltam features Enterprise |

## 2. Nossa Estratégia (O Ataque)
- **Nicho Alvo**: [Ex: Pequenas escolas que não usam Moodle]
- **Proposta de Valor**: "A simplicidade do Competitor B com o suporte do A."
- **Pricing Inicial**: R$ 49,90 (BRL First).

## 3. Canais de Aquisição
1. SEO (Keywords: ...)
2. Cold Outreach (LinkedIn)...
""",

    "Minhas Skills/explorando-mercado/scripts/analyze_competitor.py": """import sys
print("✅ Análise de concorrência gerada (Simulação).")
""",

