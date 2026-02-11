name: criando-skills
description: A Fábrica de Capacidades. Gera skills especializadas de arquitetura crítica de forma genérica, configurável e agnóstica de stack específica.
version: 3.0.0
tags: [meta, factory, genesis, generic, architecture]
---

# Criando Skills (Genesis Protocol v3.0)

## 🎯 Quando invocar esta skill

1. **Nova Capacidade Detectada**: O usuário solicita funcionalidade que não existe no `index-skills`
2. **Padronização de Workflow**: Processo complexo se repete e merece ser encapsulado
3. **Evolução Arquitetural**: Nova categoria de tecnologia precisa ser integrada ao sistema

> **Regra de Ouro**: Se a skill não existe, **NUNCA improvise**. Invoque `criando-skills` imediatamente.

---

## 🧱 Arquitetura de Stacks (Configurável)

A skill **não prescreve stack fixa**. O usuário define via `project-context.json`:

```json
{
  "project": "meu-saas",
  "stack_preference": {
    "frontend": ["nextjs", "react", "vue", "svelte", "angular"],
    "backend": ["fastapi", "express", "django", "rails", "go"],
    "database": ["neon", "supabase", "mongodb", "mysql", "firebase"],
    "ai": ["openrouter", "langchain", "vercel-ai-sdk", "transformers"],
    "automation": ["inngest", "celery", "bullmq", "n8n"],
    "comms": ["resend", "evolution-api", "twilio", "sendgrid"]
  },
  "constraints": {
    "serverless": true,
    "docker_required": false,
    "budget_tier": "startup|growth|enterprise"
  }
}
```

### Categorias de Tecnologia (Catálogo)

O usuário seleciona o que precisa. A skill gera o boilerplate compatível.

| Categoria | Opções Comuns | Caso de Uso |
| :--- | :--- | :--- |
| **Core Runtime** | Node.js, Python, Go, Rust, Elixir, Java | Base da aplicação |
| **Frontend** | Next.js, React, Vue, Svelte, Astro, Angular | UI/UX |
| **Backend API** | FastAPI, Express, Django, Rails, Gin, Phoenix | Lógica de negócio |
| **Database** | Neon, Supabase, MongoDB, PlanetScale, Firebase | Persistência |
| **Vector/RAG** | pgvector, Qdrant, Pinecone, Weaviate, Chroma | Memória semântica |
| **AI/LLM** | OpenRouter, OpenAI, Anthropic, Ollama, Groq | Inteligência |
| **AI Framework** | LangChain, LangGraph, Vercel AI SDK, LiteLLM | Orquestração IA |
| **Media** | Fal.ai, Replicate, Cloudinary, Sharp | Imagem/Vídeo/Áudio |
| **Automation** | Inngest, Celery, BullMQ, n8n, Temporal | Filas/Workflows |
| **Scraping** | Apify, Playwright, Puppeteer, Selenium | Coleta de dados |
| **Comms** | Resend, Evolution API, Twilio, SendGrid, Postmark | Email/Whats/SMS |
| **Auth** | Clerk, Auth0, Firebase Auth, Keycloak, Cognito | Identidade |
| **Storage** | R2, S3, Supabase Storage, Cloudinary, GCS | Arquivos |
| **Infra** | Vercel, Docker, Kubernetes, Fly.io, Railway | Deploy |
| **Observability** | Datadog, LogRocket, Sentry, Plausible, Metabase | Monitoramento |

---

## ⚙️ Fluxo de Trabalho (Fábrica)

### Passo 1: Análise de Intenção (2 min)

- [ ] **Capturar requisito**: O que o usuário quer que o sistema faça?
- [ ] **Mapear domínio**: Qual categoria? (AI, Data, Automation, Comms, etc.)
- [ ] **Verificar existência**: Já existe skill similar no `index-skills`?

**Output**: Declaração de intenção em uma frase:
> *"Criar skill para [ação] usando [categoria principal] + [categoria secundária]"*

---

### Passo 2: Seleção de Stack (Mix & Match) (3 min)

- [ ] Carregar `project-context.json` do projeto atual
- [ ] Se não existir, perguntar ao usuário ou usar defaults genéricos
- [ ] Selecionar ferramentas do catálogo que atendem à intenção

**Matriz de Decisão**:

| Intenção | Stack Típica | Alternativas |
| :--- | :--- | :--- |
| Agente de IA conversacional | Next.js + Vercel AI SDK + OpenRouter | Python + LangGraph + FastAPI |
| Pipeline de dados | Python + Pandas + Neon | Node.js + Prisma + Inngest |
| Automação de marketing | n8n + Resend + Airtable | Inngest + React Email + Supabase |
| RAG de documentos | Python + LangChain + Qdrant | Next.js + Vercel AI SDK + pgvector |
| Webhook processing | Go + Gin + PostgreSQL | Node.js + Express + MongoDB |

---

### Passo 3: Geração de Artefatos (5 min)

Criar na pasta `Minhas Skills/[nome-da-skill]/`:

```
Minhas Skills/[verbo-gerundio]-[objeto]/
├── SKILL.md                    # Este protocolo
├── resources/
│   ├── template_[tipo].md      # Template específico do domínio
│   └── architecture_examples/   # Snippets por stack alternativa
│       ├── nextjs-example.md
│       ├── python-example.md
│       └── go-example.md
└── scripts/
    ├── validate_setup.py        # Valida dependências da stack
    └── init_boilerplate.py      # Gera código inicial
```

---

### Passo 4: Validação de Qualidade (2 min)

- [ ] **Compatibilidade**: A skill funciona com as stacks declaradas no contexto?
- [ ] **Completude**: Tem todos os 3 componentes? (MD + Resources + Scripts)
- [ ] **Testabilidade**: Os scripts de validação executam sem erro?
- [ ] **Documentação**: O template está preenchível por um agente?

---

## 📝 Templates por Domínio

### Template Genérico Base
Local: `resources/template_padrao.md`

```markdown
---
name: [verbo-gerundio]-[objeto]
description: [O que faz, para quem, usando o que]
version: 1.0.0
tags: [dominio, stack-principal, stack-secundaria]
---

# [Nome da Skill]

## 🎯 Quando usar
- [Gatilho situacional 1]
- [Gatilho situacional 2]
- [Condição de exceção]

## 🏗️ Stacks Compatíveis
Esta skill suporta múltiplas configurações:

### Opção A: [Stack Principal]
- **Runtime**: [Ex: Node.js 18+]
- **Framework**: [Ex: Next.js App Router]
- **Ferramentas**: [Lista específica]

### Opção B: [Stack Alternativa]
- **Runtime**: [Ex: Python 3.11+]
- **Framework**: [Ex: FastAPI]
- **Ferramentas**: [Lista específica]

## 📋 Checklist de Execução
- [ ] **1. Validação de Entrada**: [O que precisa estar pronto?]
- [ ] **2. Configuração de Ambiente**: [Variáveis, credenciais]
- [ ] **3. Execução Principal**: [Passos do workflow]
- [ ] **4. Verificação de Saída**: [Como confirmar sucesso?]

## 💻 Snippets por Stack

### Stack A: [Nome]
\`\`\`typescript
// Código específico
\`\`\`

### Stack B: [Nome]
\`\`\`python
# Código equivalente
\`\`\`

## 🛡️ Validação
- [ ] Comando de teste: `[comando]`
- [ ] Saída esperada: `[descrição]`
```

---

### Templates Especializados por Domínio

#### Para AI/LLM: `resources/template_ai_agent.md`
```markdown
---
name: [acao]-ia
description: Agente de IA para [proposito]
version: 1.0.0
tags: [ai, llm, agent]
---

## 🧱 Arquitetura de Decisão

Escolha baseada em complexidade:

| Complexidade | Arquitetura | Quando usar |
| :--- | :--- | :--- |
| **Baixa** | Vercel AI SDK (Next.js) | Chat simples, streaming, 1-turn |
| **Média** | LangChain + FastAPI | RAG, tool calling, memória curta |
| **Alta** | LangGraph + Python | Estados complexos, loops, human-in-the-loop |

## Guardrails Obrigatórios
- [ ] Validação de saída (JSON schema ou Pydantic)
- [ ] Rate limiting (OpenRouter tier)
- [ ] Fallback para modelo menor se principal falhar
```

#### Para Dados/ETL: `resources/template_data_pipeline.md`
```markdown
---
name: [processando]-dados
description: Pipeline de dados para [fonte] → [destino]
version: 1.0.0
tags: [data, etl, pipeline]
---

## 🧱 Padrões de Arquitetura

- **Batch**: Inngest + Neon (agendado)
- **Streaming**: Webhooks + Fila + Worker
- **Real-time**: WebSockets + Redis Pub/Sub

## Idempotência
Todo processamento deve ser seguro para reexecução:
- [ ] Checksum de entrada verificado?
- [ ] Duplicatas detectadas via hash?
- [ ] Estado salvo em cada etapa?
```

#### Para Comunicação: `resources/template_comms_flow.md`
```markdown
---
name: [enviando]-[canal]
description: Fluxo de comunicação via [email|whatsapp|sms]
version: 1.0.0
tags: [comms, automation]
---

## 🧱 Canais Suportados

| Canal | Provider | Caso de uso |
| :--- | :--- | :--- |
| Email | Resend, SendGrid, Postmark | Transacional, marketing |
| WhatsApp | Evolution API, Twilio, WABA | Suporte, notificações |
| SMS | Twilio, AWS SNS | Urgência, 2FA |

## Sanitização Obrigatória
- [ ] Sem dados PII em logs
- [ ] Rate limiting por destinatário
- [ ] Unsubscribe/Opt-out handling
```

---

## 💻 Scripts de Fábrica

### validate_setup.py
Valida se o ambiente pode suportar a stack escolhida.

```python
#!/usr/bin/env python3
"""
Valida se o ambiente atual suporta a stack definida no project-context.json
"""

import json
import sys
import subprocess
from pathlib import Path

STACK_REQUIREMENTS = {
    "nodejs": {"commands": ["node", "npm"], "version_flag": "--version"},
    "python": {"commands": ["python3", "pip"], "version_flag": "--version"},
    "go": {"commands": ["go"], "version_flag": "version"},
    "rust": {"commands": ["cargo", "rustc"], "version_flag": "--version"},
    "docker": {"commands": ["docker", "docker-compose"], "version_flag": "--version"},
    "neon": {"env": ["DATABASE_URL"], "optional": True},
    "openrouter": {"env": ["OPENROUTER_API_KEY"], "optional": True},
    "clerk": {"env": ["NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY"], "optional": True},
}

def load_context(project_path: str = ".") -> dict:
    """Carrega contexto do projeto."""
    paths = [
        Path(project_path) / "project-context.json",
        Path(project_path) / "context.json",
    ]
    
    for p in paths:
        if p.exists():
            return json.loads(p.read_text())
    
    return {"stack": ["generic"], "name": "unknown"}

def check_command(cmd: str) -> bool:
    """Verifica se comando existe no PATH."""
    try:
        subprocess.run([cmd, "--version"], capture_output=True, check=True)
        return True
    except (subprocess.CalledProcessError, FileNotFoundError):
        return False

def check_env(var: str) -> bool:
    """Verifica se variável de ambiente existe."""
    import os
    return var in os.environ

def validate_stack(stack: list, strict: bool = False) -> dict:
    """Valida cada componente da stack."""
    results = {"ok": [], "missing": [], "optional_missing": []}
    
    for component in stack:
        req = STACK_REQUIREMENTS.get(component, {})
        
        # Verifica comandos
        if "commands" in req:
            for cmd in req["commands"]:
                if check_command(cmd):
                    results["ok"].append(f"{component}:{cmd}")
                else:
                    results["missing"].append(f"{component}:{cmd}")
        
        # Verifica variáveis de ambiente
        if "env" in req:
            for env_var in req["env"]:
                if check_env(env_var):
                    results["ok"].append(f"{component}:{env_var}")
                else:
                    if req.get("optional"):
                        results["optional_missing"].append(f"{component}:{env_var}")
                    else:
                        results["missing"].append(f"{component}:{env_var}")
    
    return results

def main():
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument("--project-path", default=".")
    parser.add_argument("--strict", action="store_true", help="Falha se opcionais faltarem")
    args = parser.parse_args()
    
    context = load_context(args.project_path)
    stack = context.get("stack", ["generic"])
    
    print(f"🔍 Validando stack para: {context.get('name', 'unknown')}")
    print(f"Componentes: {', '.join(stack)}")
    print("-" * 50)
    
    results = validate_stack(stack, args.strict)
    
    for item in results["ok"]:
        print(f"  ✅ {item}")
    
    for item in results["optional_missing"]:
        print(f"  ⚠️  {item} (opcional)")
    
    if results["missing"]:
        print(f"\n❌ Faltando obrigatórios:")
        for item in results["missing"]:
            print(f"  - {item}")
        sys.exit(1)
    else:
        print(f"\n✅ Stack validada. Pronto para criar skills.")
        sys.exit(0)

if __name__ == "__main__":
    main()
```

---

### init_boilerplate.py
Gera código inicial baseado na stack escolhida.

```python
#!/usr/bin/env python3
"""
Gera boilerplate inicial para nova skill baseado no contexto do projeto
"""

import json
import argparse
from pathlib import Path
from datetime import datetime

BOILERPLATES = {
    "nextjs_api_route": '''import { NextResponse } from 'next/server';
import { auth } from '@clerk/nextjs';

export async function POST(req: Request) {
  try {
    const { userId } = auth();
    if (!userId) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await req.json();
    
    // TODO: Implementar lógica aqui
    
    return NextResponse.json({ success: true, data: body });
  } catch (error) {
    console.error('[API_ERROR]', error);
    return NextResponse.json(
      { error: 'Internal Server Error' }, 
      { status: 500 }
    );
  }
}''',

    "python_fastapi": '''from fastapi import FastAPI, HTTPException, Depends
from pydantic import BaseModel
import os

app = FastAPI(title="{{skill_name}} API")

class InputSchema(BaseModel):
    data: str

class OutputSchema(BaseModel):
    result: str
    processed_at: str

@app.post("/process", response_model=OutputSchema)
async def process_data(input_data: InputSchema):
    try:
        # TODO: Implementar lógica aqui
        return OutputSchema(
            result=f"Processed: {input_data.data}",
            processed_at=datetime.now().isoformat()
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)''',

    "inngest_function": '''import { inngest } from '@/lib/inngest/client';

export const {{skill_name}} = inngest.createFunction(
  { id: "{{skill_name}}" },
  { event: "{{skill_name}}/triggered" },
  async ({ event, step }) => {
    // TODO: Implementar steps aqui
    
    await step.run("process", async () => {
      return { processed: true };
    });
    
    return { success: true };
  }
);''',

    "langchain_agent": '''from langchain_openai import ChatOpenAI
from langchain.agents import AgentExecutor, create_openai_functions_agent
from langchain.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain.tools import tool
import os

@tool
def example_tool(query: str) -> str:
    """Tool description here"""
    return f"Result for: {query}"

tools = [example_tool]

llm = ChatOpenAI(
    model="gpt-4o-mini",
    openai_api_key=os.getenv("OPENROUTER_API_KEY"),
    openai_api_base="https://openrouter.ai/api/v1"
)

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are a helpful assistant"),
    ("human", "{input}"),
    MessagesPlaceholder(variable_name="agent_scratchpad"),
])

agent = create_openai_functions_agent(llm, tools, prompt)
agent_executor = AgentExecutor(agent=agent, tools=tools, verbose=True)

def run_agent(input_text: str):
    return agent_executor.invoke({"input": input_text})''',

    "database_schema": '''-- Schema para {{skill_name}}
-- Suporta: PostgreSQL (Neon), MySQL, SQLite

CREATE TABLE IF NOT EXISTS {{table_name}} (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    data JSONB NOT NULL DEFAULT '{}',
    
    -- TODO: Adicionar campos específicos
    
    CONSTRAINT valid_data CHECK (jsonb_typeof(data) = 'object')
);

CREATE INDEX idx_{{table_name}}_created ON {{table_name}}(created_at DESC);

-- Trigger para updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_{{table_name}}_updated_at 
    BEFORE UPDATE ON {{table_name}} 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();'''
}

def generate_boilerplate(skill_name: str, stack: list, output_dir: str):
    """Gera arquivos boilerplate baseado na stack."""
    output_path = Path(output_dir)
    output_path.mkdir(parents=True, exist_ok=True)
    
    generated = []
    
    # Mapeia stack para boilerplates relevantes
    if any(s in ["nextjs", "react", "vercel"] for s in stack):
        # API Route
        api_path = output_path / "api" / "route.ts"
        api_path.parent.mkdir(parents=True, exist_ok=True)
        api_path.write_text(BOILERPLATES["nextjs_api_route"])
        generated.append(str(api_path))
        
        # Inngest (se necessário)
        if "inngest" in stack:
            inngest_path = output_path / "inngest" / f"{skill_name}.ts"
            inngest_path.parent.mkdir(parents=True, exist_ok=True)
            content = BOILERPLATES["inngest_function"].replace("{{skill_name}}", skill_name)
            inngest_path.write_text(content)
            generated.append(str(inngest_path))
    
    if any(s in ["python", "fastapi", "django"] for s in stack):
        py_path = output_path / "main.py"
        content = BOILERPLATES["python_fastapi"].replace("{{skill_name}}", skill_name)
        py_path.write_text(content)
        generated.append(str(py_path))
        
        # Requirements
        req_path = output_path / "requirements.txt"
        req_path.write_text("fastapi\nuvicorn\npydantic\npython-dotenv")
        generated.append(str(req_path))
    
    if any(s in ["langchain", "langgraph", "openai"] for s in stack):
        agent_path = output_path / "agent.py"
        agent_path.write_text(BOILERPLATES["langchain_agent"])
        generated.append(str(agent_path))
    
    if any(s in ["neon", "postgres", "supabase"] for s in stack):
        schema_path = output_path / "schema.sql"
        table_name = skill_name.replace("-", "_")
        content = BOILERPLATES["database_schema"].replace("{{skill_name}}", skill_name).replace("{{table_name}}", table_name)
        schema_path.write_text(content)
        generated.append(str(schema_path))
    
    return generated

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--name", required=True, help="Nome da skill (kebab-case)")
    parser.add_argument("--project-path", default=".", help="Caminho do projeto")
    parser.add_argument("--output", required=True, help="Diretório de saída")
    
    args = parser.parse_args()
    
    # Carrega contexto
    context_path = Path(args.project_path) / "project-context.json"
    if context_path.exists():
        context = json.loads(context_path.read_text())
        stack = context.get("stack", ["generic"])
    else:
        stack = ["generic"]
    
    print(f"🏭 Gerando boilerplate para: {args.name}")
    print(f"Stack: {', '.join(stack)}")
    
    generated = generate_boilerplate(args.name, stack, args.output)
    
    print(f"\n✅ Arquivos gerados ({len(generated)}):")
    for f in generated:
        print(f"  📄 {f}")

if __name__ == "__main__":
    main()
```

---

## 🛡️ Validação Final de Skill Criada

Antes de registrar no `index-skills`, verificar:

- [ ] **Estrutura**: SKILL.md + resources/ + scripts/ existem?
- [ ] **Genericidade**: Funciona para múltiplas stacks ou documenta limitações?
- [ ] **Configurabilidade**: Respeita `project-context.json`?
- [ ] **Testabilidade**: `validate_setup.py` passa?
- [ ] **Documentação**: Templates são preenchíveis por agente autônomo?

---

## 📋 Checklist de Criação

- [ ] Intenção claramente definida
- [ ] Stack selecionada do catálogo (ou justificada fora dele)
- [ ] Artefatos gerados (MD + resources + scripts)
- [ ] Validação executada sem erros
- [ ] Skill registrada no `index-skills`
- [ ] Teste de criação de instância bem-sucedido

---

**Versão 3.0.0 | Agnóstica de Stack | Fábrica Universal de Capacidades**
```

Esta versão 3.0.0 da `criando-skills` é **completamente genérica**:

1. **Não impõe Next.js** - é uma opção entre muitas
2. **Catálogo configurável** - usuário escolhe o que precisa via `project-context.json`
3. **Templates por domínio** - AI, Dados, Comunicação, cada um com múltiplas opções de stack
4. **Scripts inteligentes** - detectam o ambiente e geram código compatível
5. **Validação universal** - funciona para qualquer projeto, não apenas Stack Omega

