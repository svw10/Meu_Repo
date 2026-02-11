### 📂 Estrutura de Diretórios

Minhas Skills/
└── planejando-solucoes/
    ├── SKILL.md
    ├── scripts/
    │   ├── init_plan.py       # Cria o arquivo do plano
    │   └── validate_plan.py   # (Novo) Verifica se o plano está atômico o suficiente
    └── resources/
        └── template_plano_atomico.md



### 1. O Cérebro (`Minhas Skills/planejando-solucoes/SKILL.md`)


name: planejando-solucoes
description: O Estrategista. Quebra demandas complexas em Planos Atômicos, vinculados à Stack Imutável (Neon, Inngest, Vercel). Garante rastreabilidade, critérios de sucesso claros e zero ambiguidade.
version: 2.0.0
tags: [planejamento, arquitetura, atomicidade, prd]
---

# Planejando Soluções (Atomic Architecture Protocol)

## 🎯 Quando usar
- **Sempre** que o usuário pedir: "plano", "roadmap", "criar feature", "como fazer X".
- Quando a tarefa envolver múltiplos sistemas da stack (ex: Banco + IA + Frontend).
- Para evitar "alucinação de código": O agente só pode codar se tiver um plano aprovado.
- Quando o escopo for ambíguo: Use esta skill para forçar clareza.

## 🧱 A Stack Imutável (Lei Suprema)
O plano deve, obrigatoriamente, mapear cada problema para uma destas ferramentas:

| Camada | Ferramenta Obrigatória | Uso no Plano |
| :--- | :--- | :--- |
| **Frontend** | Vercel (Next.js App Router) | Server Actions, UI Components |
| **Dados** | Neon (Postgres + pgvector) | Schema, Migrations, Embeddings |
| **Orquestração** | Inngest | Filas, Cron Jobs, Step Functions |
| **Auth** | Clerk | Proteção de rotas, User ID |
| **AI/Voz** | OpenRouter / Whisper / Fal.ai | Gerações e Transcrições |
| **Integração** | Apify / Evolution API | Scraping e WhatsApp |

## 🧬 Filosofia: Atomicidade e Rastreabilidade
1.  **Regra dos 10 Minutos**: Nenhuma etapa do plano deve ser complexa demais a ponto de levar mais de 10 minutos para ser codificada/executada. Se for, quebre-a.
2.  **Critério Binário**: Cada etapa precisa de uma definição clara de "Pronto" (Sim/Não).
3.  **Validação Prévia**: Para etapas críticas (ex: Migration), o plano deve sugerir como validar o ambiente antes de executar.

## ⚙️ Fluxo de Trabalho

- [ ] **1. Clarificação e Binding**
    - Entender o objetivo final (KPI).
    - Vincular cada necessidade a um componente da Stack (tabela acima).

- [ ] **2. Arquitetura Técnica (O "O Que")**
    - Definir Schema do Banco (Tabelas/Campos).
    - Definir Rotas da API e Eventos do Inngest.

- [ ] **3. Decomposição Atômica (O "Como")**
    - Quebrar a implementação em passos numerados.
    - Definir o **Critério de Sucesso** para cada passo.
    - *Ex: "Criar tabela X" -> Sucesso: "Tabela visível no Drizzle Studio".*

- [ ] **4. Geração do Artefato**
    - Preencher o `template_plano_atomico.md`.

## 📋 Checklist de Entrega

O output final deve ser um arquivo Markdown contendo:
- [ ] Visão de Arquitetura (Schema + Rotas).
- [ ] Lista de Passos Atômicos (com checkbox).
- [ ] Comandos de Validação (scripts de teste rápido).

## 💻 Snippets e Recursos

### Snippet 1: Inicializador
```bash
# Cria um novo plano vazio na pasta docs/
python "Minhas Skills/planejando-solucoes/scripts/init_plan.py" --name "nome-da-tarefa"


### Snippet 2: Validador de Plano (Anti-Alucinação)

# Verifica se o plano tem critérios de sucesso definidos
python "Minhas Skills/planejando-solucoes/scripts/validate_plan.py" --file "docs/PLAN-nome.md"


### 2. O Template Atômico (`Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md`)

Este template força o agente a pensar em pequenos blocos testáveis.

```markdown
# Plano Atômico: [Nome da Feature]
**Data:** {{DATE}}
**Objetivo Final:** [Resultado mensurável, ex: Usuário consegue agendar reunião e receber confirmação no WhatsApp]

---

## 1. Arquitetura da Stack (Blueprint)

### A. Banco de Dados (Neon + Drizzle)
*(Defina as tabelas e campos aqui)*
- Tabela `[nome]`:
    - `id`: uuid
    - `...`: ...

### B. Orquestração (Inngest)
*(Defina os gatilhos e funções)*
- Evento: `app/[context].[action]`
- Função: `[nome-da-funcao]` (Steps: A -> B -> C)

### C. Frontend & Integrações
- Rota: `/app/[slug]`
- API Ext: [Evolution API / Apify / etc]

---

## 2. Roteiro de Execução Atômica

> Cada passo deve ser executável em isolamento e verificável.

### Fase 1: Fundação e Dados
1. [ ] **Criar Schema e Migration**
    - *Ação*: Criar arquivo `src/db/schema/x.ts` e rodar `npx drizzle-kit push`.
    - *Critério de Sucesso*: A tabela aparece no Neon Console.
    - *Validação*: `npx drizzle-kit studio`

2. [ ] **Configurar Evento Inngest**
    - *Ação*: Definir tipo do evento em `src/inngest/events.ts`.
    - *Critério de Sucesso*: TypeScript não reclama do tipo no `inngest.send`.

### Fase 2: Lógica de Backend (Server Actions/Inngest)
3. [ ] **Criar Server Action de Entrada**
    - *Ação*: Criar `actions/create-x.ts` com validação Zod.
    - *Critério de Sucesso*: Chamada via cURL ou Client retorna 200 e ID criado.

4. [ ] **Implementar Função Inngest**
    - *Ação*: Criar `inngest/functions/process-x.ts`.
    - *Critério de Sucesso*: Disparar evento de teste no Inngest Dev Server e ver execução verde.

### Fase 3: Frontend e UI
5. [ ] **Criar Componente de UI**
    - *Ação*: Criar formulário em `components/feature-x/form.tsx`.
    - *Critério de Sucesso*: Renderização visual correta e log no console ao submeter.

---

## 3. Riscos e Fallbacks
- Se a API externa falhar na etapa 4? -> *R: O Inngest fará retry automático por 24h.*
- Se o banco travar? -> *R: O Clerk mantém o usuário logado, UI mostra Toast de erro.*



### 3. Scripts Auxiliares

#### `Minhas Skills/planejando-solucoes/scripts/init_plan.py`

(Mantém a lógica de criar o arquivo baseada no novo template)


import sys
import os
import datetime

# Caminho relativo ao script
TEMPLATE_PATH = os.path.join(os.path.dirname(__file__), "../resources/template_plano_atomico.md")

def create_plan(feature_name):
    target_dir = "docs"
    if not os.path.exists(target_dir):
        os.makedirs(target_dir)
    
    filename = f"PLAN-{feature_name.lower().replace(' ', '-')}.md"
    target_path = os.path.join(target_dir, filename)
    
    try:
        with open(TEMPLATE_PATH, 'r', encoding='utf-8') as t:
            content = t.read()
    except FileNotFoundError:
        print("❌ Erro: Template 'template_plano_atomico.md' não encontrado.")
        return

    content = content.replace("[Nome da Feature]", feature_name)
    content = content.replace("{{DATE}}", datetime.date.today().isoformat())

    with open(target_path, 'w', encoding='utf-8') as f:
        f.write(content)
    
    print(f"✅ Plano Atômico iniciado: {target_path}")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python init_plan.py --name \"Nome da Feature\"")
    else:
        create_plan(sys.argv[2])



#### `Minhas Skills/planejando-solucoes/scripts/validate_plan.py`

(Novo script para garantir qualidade)

import sys
import os

def validate_plan(file_path):
    if not os.path.exists(file_path):
        print("❌ Arquivo não encontrado.")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    errors = []

    # 1. Checa se a stack está definida
    if "Arquitetura da Stack" not in content:
        errors.append("Faltou a seção de Arquitetura da Stack.")

    # 2. Checa Critérios de Sucesso
    if "Critério de Sucesso" not in content:
        errors.append("Nenhum 'Critério de Sucesso' definido nas etapas.")

    # 3. Checa Atomicidade (Heurística simples: contagem de passos)
    if content.count("1. [ ]") == 0:
        errors.append("O plano não parece ter passos numerados (checklist).")

    if errors:
        print("⚠️ O plano precisa de ajustes:")
        for e in errors:
            print(f"  - {e}")
    else:
        print("✅ O plano parece sólido e atômico. Pronto para execução.")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Uso: python validate_plan.py --file docs/PLAN-nome.md")
    else:
        validate_plan(sys.argv[2])

