name: planejando-solucoes
description: O Estrategista. Quebra demandas complexas em Planos Atômicos, vinculados à Stack do projeto. Garante rastreabilidade, critérios de sucesso claros e zero ambiguidade.
version: 3.0.0
tags: [planejamento, arquitetura, atomicidade, prd, universal]
author: System Architect
---

# Planejando Soluções (Atomic Architecture Protocol)

## 🎯 Quando usar
- **Sempre** que o usuário pedir: "plano", "roadmap", "criar feature", "como fazer X".
- Quando a tarefa envolver múltiplos sistemas (ex: Banco + IA + Frontend).
- Para evitar "alucinação de código": O agente só pode codar se tiver um plano aprovado.
- Quando o escopo for ambíguo: Use esta skill para forçar clareza.
- **Após** `brainstorming` ter gerado um SPEC aprovado.

## 🧱 A Stack do Projeto (Configurável)

O plano deve mapear cada problema para as ferramentas definidas em `project-context.json`:

**Exemplo SnapFit:**
| Camada | Ferramenta | Uso no Plano |
| :--- | :--- | :--- |
| **Frontend** | Next.js 14 (App Router) | Server Actions, UI Components |
| **Dados** | Neon (Postgres + pgvector) | Schema, Migrations, Embeddings |
| **Orquestração** | Inngest | Filas, Cron Jobs, Step Functions |
| **Auth** | Clerk | Proteção de rotas, User ID |
| **AI** | OpenRouter | LLM, embeddings |
| **Comms** | Evolution API + Resend | WhatsApp, Email |
| **Storage** | Cloudflare R2 | Imagens, assets |

**Exemplo Outro Projeto:**
| Camada | Ferramenta | Uso no Plano |
| :--- | :--- | :--- |
| **Frontend** | Vue 3 + Nuxt | Composition API, SSR |
| **Dados** | Supabase (Postgres) | Schema, Realtime |
| **Orquestração** | Bull + Redis | Filas, jobs |
| **Auth** | Auth0 | JWT, RBAC |
| **AI** | Direct OpenAI | GPT-4, DALL-E |
| **Comms** | Twilio | SMS, WhatsApp |
| **Storage** | AWS S3 | Arquivos, backups |

> **Princípio**: A stack é definida no contexto do projeto, não hardcoded na skill.

## 🧬 Filosofia: Atomicidade e Rastreabilidade

### Regra dos 10 Minutos
Nenhuma etapa do plano deve ser complexa demais a ponto de levar mais de 10 minutos para ser codificada/executada. Se for, quebre-a em sub-etapas.

### Critério Binário
Cada etapa precisa de uma definição clara de "Pronto" (Sim/Não). Nada subjetivo.

### Validação Prévia
Para etapas críticas (ex: Migration), o plano deve sugerir como validar o ambiente antes de executar.

## ⚙️ Fluxo de Trabalho (Obrigatório)

### Passo 1: Clarificação e Binding (5 min)
- Entender o objetivo final (KPI mensurável)
- Vincular cada necessidade a um componente da Stack do projeto
- Validar: "Esta ferramenta está no nosso contexto?"

**Checklist:**
- [ ] Objetivo final claro (ex: "Usuário consegue fazer X em Y segundos")
- [ ] Cada necessidade mapeada para camada da stack
- [ ] Ferramentas validadas contra `project-context.json`

### Passo 2: Arquitetura Técnica (O "O Que") (10 min)
- Definir Schema do Banco (Tabelas/Campos/Relações)
- Definir Rotas da API e Eventos de fila
- Definir Componentes de UI necessários

**Output:** Diagrama mental ou esquema textual da arquitetura.

### Passo 3: Decomposição Atômica (O "Como") (15 min)
- Quebrar a implementação em passos numerados
- Definir o **Critério de Sucesso** para cada passo
- Garantir que cada passo ≤ 10 minutos de execução

**Exemplo de decomposição:**
```
❌ Ruim: "Criar sistema de autenticação" (várias horas)
✅ Bom: 
  1. Criar tabela users no Neon (5 min)
  2. Configurar Clerk no Next.js (5 min)
  3. Criar middleware de proteção de rotas (5 min)
  4. Criar componente de login (10 min)
  5. Testar fluxo completo (5 min)
```

### Passo 4: Geração do Artefato (5 min)
- Preencher o `docs/PLAN-[nome].md` usando o template
- Validar com `validate_plan.py`
- Marcar como pronto para execução

## 📋 Checklist de Entrega (DoD)

O output final deve ser um arquivo Markdown contendo:
- [ ] Visão de Arquitetura (Schema + Rotas + Componentes)
- [ ] Lista de Passos Atômicos (com checkbox e critérios)
- [ ] Comandos de Validação (scripts de teste rápido)
- [ ] Riscos e Fallbacks identificados
- [ ] Tempo estimado total (soma dos passos)

## 🌍 Exemplos por Projeto

### Exemplo 1: SnapFit - Sistema de Créditos

**Contexto:** SaaS de provador virtual, stack = Next.js + Neon + Inngest + Clerk

**Objetivo:** Controlar quantas imagens cada lojista pode gerar por mês

**Arquitetura:**
- Banco: Tabela `tenants` (campos: `credits_included`, `credits_used`, `plan_type`)
- Fila: Evento `image.generation.requested` → consome 1 crédito
- Frontend: Card de créditos no dashboard
- Validação: Bloqueia se `credits_used >= credits_included`

**Plano Atômico:**
1. [ ] **Migration: Adicionar campos de crédito**
   - Ação: Alterar `src/db/schema/tenants.ts`, adicionar 3 campos
   - Critério: `npx drizzle-kit push` executa sem erro
   - Validação: Ver no Neon Console que colunas existem

2. [ ] **Server Action: Consumir crédito**
   - Ação: Criar `src/actions/consume-credit.ts`
   - Critério: Decrementa `credits_used` em 1, retorna novo valor
   - Validação: Teste unitário passa

3. [ ] **Inngest: Integrar consumo na geração de imagem**
   - Ação: Adicionar step `consumeCredit` na função `generateImage`
   - Critério: Evento dispara → crédito consumido → imagem gerada
   - Validação: Log no Inngest Dev Server mostra execução

4. [ ] **Frontend: Card de créditos**
   - Ação: Componente `CreditsCard` em `src/components/dashboard/`
   - Critério: Mostra "X/Y créditos", barra de progresso, alerta em 80%
   - Validação: Visual correto no Storybook

5. [ ] **Bloqueio: Quando zera**
   - Ação: Middleware ou check antes da geração
   - Critério: Se créditos = 0, retorna erro "Limite atingido"
   - Validação: Tentativa de geração com 0 créditos retorna 403

**Riscos:**
- Se Stripe webhook falhar? → R: Sistema continua com créditos atuais, notifica admin
- Se race condition no consumo? → R: Usar `SELECT FOR UPDATE` no Postgres

---

### Exemplo 2: AprenderIA - Matching Inteligente

**Contexto:** Plataforma de matchmaking técnico, stack = Go + Neon + OpenRouter

**Objetivo:** Empresas encontrarem prestadores de serviço com base em skills

**Arquitetura:**
- Banco: Tabelas `profiles` (embedding), `projects` (requirements), `matches` (score)
- API: Endpoint `POST /api/match` com RAG
- AI: Embedding de perfis via OpenRouter

**Plano Atômico:**
1. [ ] **Migration: Tabela de embeddings**
   - Ação: Criar `profiles` com campo `embedding vector(1536)`
   - Critério: Tabela criada, índice HNSW criado
   - Validação: Query de similaridade funciona

2. [ ] **Serviço: Gerar embedding de perfil**
   - Ação: Função `GenerateEmbedding(text string) []float32`
   - Critério: Chama OpenRouter, retorna vetor 1536 dimensões
   - Validação: Teste com texto fixo retorna vetor consistente

3. [ ] **API: Endpoint de matching**
   - Ação: `POST /api/match` recebe requirements, retorna top 10 perfis
   - Critério: Usa similaridade de cosseno, retorna em < 500ms
   - Validação: Benchmark com 1000 perfis

4. [ ] **Cache: Redis para embeddings frequentes**
   - Ação: Cachear embeddings de perfis populares
   - Critério: Cache hit > 80%, TTL 1 hora
   - Validação: Métricas no Redis Insights

---

### Exemplo 3: Genérico - Blog Pessoal

**Contexto:** Site simples, stack = Next.js + Markdown (sem banco)

**Objetivo:** Publicar posts técnicos

**Arquitetura:**
- Conteúdo: Markdown files em `content/posts/`
- Build: Geração estática no build time
- UI: Tailwind + tipografia

**Plano Atômico:**
1. [ ] **Estrutura: Pasta de conteúdo**
   - Ação: Criar `content/posts/` com arquivo `hello-world.md`
   - Critério: Arquivo existe, formato frontmatter correto
   - Validação: `ls content/posts/` mostra arquivo

2. [ ] **Parser: Ler markdown**
   - Ação: Função `getPost(slug)` que lê arquivo e parseia frontmatter
   - Critério: Retorna título, data, conteúdo HTML
   - Validação: Console.log mostra objeto correto

3. [ ] **Rota: Página de post**
   - Ação: `app/blog/[slug]/page.tsx` com geração estática
   - Critério: Acessar `/blog/hello-world` renderiza conteúdo
   - Validação: `npm run build` gera HTML estático

4. [ ] **Lista: Índice de posts**
   - Ação: Página `app/blog/page.tsx` listando todos os posts
   - Critério: Mostra título, data, excerpt de cada post
   - Validação: Ordenação por data decrescente

## 🛠️ Scripts e Utilitários

### Inicializar novo plano:
```bash
python skills/planejando-solucoes/scripts/init_plan.py \
  --name "sistema-de-creditos" \
  --project SnapFit
```

### Validar plano antes de executar:
```bash
python skills/planejando-solucoes/scripts/validate_plan.py \
  --file "docs/PLAN-sistema-de-creditos.md"
```

### Estimar tempo total:
```bash
python skills/planejando-solucoes/scripts/estimate_time.py \
  --file "docs/PLAN-sistema-de-creditos.md"
```

## 💻 Código dos Scripts

### init_plan.py
```python
#!/usr/bin/env python3
"""
Cria um novo plano atômico baseado no contexto do projeto.
"""

import argparse
import json
import os
from pathlib import Path
from datetime import date

def load_project_context(project: str) -> dict:
    """Carrega contexto do projeto."""
    context_paths = [
        f"projects/{project}/context.json",
        f"{project}/context.json",
        "project-context.json"
    ]
    
    for path in context_paths:
        if Path(path).exists():
            return json.loads(Path(path).read_text())
    
    # Default fallback
    return {
        "stack": ["nextjs", "neon", "inngest"],
        "project_type": "saas",
        "name": project
    }

def create_plan(name: str, project: str):
    """Cria arquivo de plano preenchido."""
    
    context = load_project_context(project)
    stack = context.get("stack", ["nextjs", "neon"])
    
    # Determinar template baseado no stack
    template = generate_template(name, project, stack)
    
    # Criar diretório se não existir
    target_dir = Path("docs")
    target_dir.mkdir(exist_ok=True)
    
    # Nome do arquivo
    filename = f"PLAN-{name.lower().replace(' ', '-')}.md"
    target_path = target_dir / filename
    
    # Escrever arquivo
    target_path.write_text(template)
    
    print(f"✅ Plano Atômico criado: {target_path}")
    print(f"📋 Stack detectada: {', '.join(stack)}")
    print(f"🎯 Próximo passo: Preencher arquitetura e passos atômicos")

def generate_template(name: str, project: str, stack: list) -> str:
    """Gera template de plano baseado na stack."""
    
    stack_str = ', '.join(stack)
    
    return f"""# Plano Atômico: {name}
**Projeto:** {project}  
**Data:** {date.today().isoformat()}  
**Stack:** {stack_str}

---

## 1. Arquitetura da Stack (Blueprint)

### A. Banco de Dados
*(Defina tabelas e campos baseado em: {stack[1] if len(stack) > 1 else 'seu banco'})*
- Tabela `[nome]`:
    - `id`: uuid
    - `created_at`: timestamp
    - `[campos específicos]`: [tipos]

### B. Orquestração/Backend
*(Defina eventos e funções baseado em: {stack[2] if len(stack) > 2 else 'sua orquestração'})*
- Evento: `[dominio].[acao]`
- Função: `[nome-da-funcao]` (Steps: A -> B -> C)

### C. Frontend & Integrações
- Rota: `/app/[caminho]`
- Componentes: `[Lista de componentes]`
- API Externa: [Se aplicável]

---

## 2. Roteiro de Execução Atômica

> Cada passo deve ser executável em isolamento e verificável em ≤ 10 minutos.

### Fase 1: Fundação e Dados
1. [ ] **[Título do passo]**
    - *Ação*: [O que fazer]
    - *Critério de Sucesso*: [Como saber que deu certo]
    - *Validação*: [Comando ou teste para verificar]

2. [ ] **[Próximo passo]**
    - *Ação*: [...]
    - *Critério de Sucesso*: [...]
    - *Validação*: [...]

### Fase 2: Lógica de Backend
3. [ ] **[Passo]**
    - *Ação*: [...]
    - *Critério de Sucesso*: [...]
    - *Validação*: [...]

### Fase 3: Frontend e UI
4. [ ] **[Passo]**
    - *Ação*: [...]
    - *Critério de Sucesso*: [...]
    - *Validação*: [...]

---

## 3. Riscos e Fallbacks
- Se [risco 1]? -> *R: [ação de contingência]*
- Se [risco 2]? -> *R: [ação de contingência]*

---

## 4. Estimativa
- Total de passos: [X]
- Tempo estimado: [Y minutos]
- Complexidade: [Baixa/Média/Alta]
"""

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", required=True, help="Nome da feature")
    parser.add_argument("--project", default="default", help="Nome do projeto")
    args = parser.parse_args()
    
    create_plan(args.name, args.project)
```

### validate_plan.py
```python
#!/usr/bin/env python3
"""
Valida se plano atômico segue padrões de qualidade.
"""

import argparse
import re
from pathlib import Path

def validate_plan(file_path: str) -> bool:
    """Valida estrutura do plano."""
    
    content = Path(file_path).read_text()
    errors = []
    warnings = []
    
    # Check 1: Estrutura básica
    if "# Plano Atômico:" not in content:
        errors.append("❌ Título 'Plano Atômico:' não encontrado")
    
    # Check 2: Seções obrigatórias
    required_sections = [
        "Arquitetura da Stack",
        "Roteiro de Execução Atômica",
        "Riscos e Fallbacks"
    ]
    
    for section in required_sections:
        if section not in content:
            errors.append(f"❌ Seção '{section}' não encontrada")
    
    # Check 3: Passos atômicos
    steps = re.findall(r'^\d+\. \[ \] \*\*', content, re.MULTILINE)
    if len(steps) == 0:
        errors.append("❌ Nenhum passo atômico encontrado (formato: '1. [ ] **Título**')")
    elif len(steps) > 15:
        warnings.append(f"⚠️ Muitos passos ({len(steps)}). Considere dividir em sub-planos.")
    
    # Check 4: Critérios de sucesso
    criteria_count = content.lower().count("critério de sucesso")
    if criteria_count < len(steps):
        errors.append(f"❌ Passos sem critério de sucesso ({len(steps) - criteria_count})")
    
    # Check 5: Validações
    validation_count = content.lower().count("validação")
    if validation_count < len(steps) / 2:
        warnings.append("⚠️ Poucos passos têm validação definida")
    
    # Check 6: Tempo estimado
    if "## 4. Estimativa" not in content:
        warnings.append("⚠️ Seção de estimativa não encontrada")
    
    # Report
    print(f"📋 Validando: {file_path}")
    print("=" * 50)
    
    if errors:
        print("\n❌ Erros (bloqueantes):")
        for error in errors:
            print(f"  {error}")
    
    if warnings:
        print("\n⚠️ Avisos (recomendados):")
        for warning in warnings:
            print(f"  {warning}")
    
    if not errors and not warnings:
        print("\n✅ Plano válido e atômico! Pronto para execução.")
        return True
    elif not errors:
        print("\n🟡 Plano aceitável, mas pode melhorar.")
        return True
    else:
        print("\n🔴 Plano precisa de ajustes antes da execução.")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True, help="Caminho do arquivo PLAN-*.md")
    args = parser.parse_args()
    
    success = validate_plan(args.file)
    exit(0 if success else 1)
```

## 📄 Template de Plano Atômico

**Arquivo:** `docs/PLAN-[nome].md`

```markdown
# Plano Atômico: [Nome da Feature]
**Projeto:** [Nome do Projeto]  
**Data:** [YYYY-MM-DD]  
**Stack:** [Ferramentas principais]

---

## 1. Arquitetura da Stack (Blueprint)

### A. Banco de Dados
- Tabela `[nome]`:
    - `id`: uuid
    - `created_at`: timestamp
    - `[campo]`: [tipo]

### B. Orquestração/Backend
- Evento: `[dominio].[acao]`
- Função: `[nome]` (Steps: A -> B -> C)

### C. Frontend & Integrações
- Rota: `/app/[caminho]`
- Componentes: [Lista]
- API Externa: [Se houver]

---

## 2. Roteiro de Execução Atômica

> Cada passo ≤ 10 minutos, com critério binário de sucesso.

### Fase 1: Fundação
1. [ ] **[Título]**
    - *Ação*: [O que fazer]
    - *Critério de Sucesso*: [Como validar]
    - *Validação*: [Comando/teste]

### Fase 2: Lógica
2. [ ] **[Título]**
    - *Ação*: [...]
    - *Critério de Sucesso*: [...]
    - *Validação*: [...]

### Fase 3: UI
3. [ ] **[Título]**
    - *Ação*: [...]
    - *Critério de Sucesso*: [...]
    - *Validação*: [...]

---

## 3. Riscos e Fallbacks
- Se [risco]? -> *R: [contingência]*

---

## 4. Estimativa
- Passos: [X]
- Tempo: [Y min]
- Complexidade: [Baixa/Média/Alta]
```

## 🚫 Anti-Padrões

- ❌ Passo que leva > 10 minutos (não atômico)
- ❌ Critério de sucesso subjetivo ("ficar bom")
- ❌ Sem validação definida
- ❌ Sem riscos/fallbacks
- ❌ Stack hardcoded (não consultar `project-context.json`)
- ❌ Plano sem SPEC prévio (deve vir de `brainstorming`)
- ❌ Muitos passos (>15 sem sub-divisão)

## ✅ Checklist de Qualidade

- [ ] Cada passo ≤ 10 minutos
- [ ] Cada passo tem critério binário de sucesso
- [ ] Cada passo tem validação definida
- [ ] Stack validada contra contexto do projeto
- [ ] Riscos e fallbacks identificados
- [ ] Tempo total estimado
- [ ] Arquitetura documentada antes dos passos
- [ ] Validado com `validate_plan.py`

## 🔗 Integrações

- **Chama:** `usando-skills` (para ser invocada)
- **É chamada por:** `brainstorming` (após SPEC aprovado)
- **Chama:** `executando-planos` (para executar o plano)
- **Depende de:** `project-context.json` (para stack)

## 📝 Changelog

### v3.0.0 (2026-02-10)
- **BREAKING**: Stack configurável via `project-context.json`
- **ADD**: Exemplos de múltiplos projetos (SnapFit, AprenderIA, genérico)
- **ADD**: Script `init_plan.py` com geração de template dinâmico
- **ADD**: Validação de critérios de sucesso e validações
- **ADD**: Estimativa de tempo no template
- **REMOVE**: Stack fixa "Imutável" (tornada configurável)
- **IMPROVE**: Regra dos 10 minutos mais explícita
- **IMPROVE**: Checklist de qualidade detalhado

### v2.0.0 (Original)
- Conceito de planos atômicos
- Stack fixa (Neon, Inngest, Vercel)
- Template básico
- Validação simples

### v1.0.0 (Prototype)
- Planejamento sequencial
- Sem atomicidade
- Sem critérios binários

---
