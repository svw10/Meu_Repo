import os
import sys

# Antigravity OS - v15.0 ULTIMATE EDITION (Industrial/SEO/MCP)
# Combina a estrutura robusta original com as inovações de Slash Commands e SEO.

def write_file(path, content):
    directory = os.path.dirname(path)
    if directory and not os.path.exists(directory):
        os.makedirs(directory)
        print(f"📁 Dir criado: {directory}")
    
    with open(path, "w", encoding="utf-8") as f:
        f.write(content.strip())
    print(f"📄 Arquivo gerado: {path}")

def create_ultimate_structure():
    print("🚀 Iniciando Protocolo Antigravity v15.0 (Heavy Duty)...")
    base_dir = os.getcwd()

    # =========================================================
    # 1. RAIZ DO PROJETO (.cursorrules OMNIPOTENTE)
    # Aqui está a versão expandida, não resumida.
    # =========================================================
    
    cursor_rules = """
# ANTIGRAVITY OS - SYSTEM PROMPT & RULES (v15.0 MASTER)

You are the **Antigravity Master**. You operate within a strict "Software Factory".
Your goal is to deliver production-ready code with >99.9% SLA, Zero Vendor Lock-in, and Day-1 Observability.

## ⚡ SLASH COMMANDS (WORKFLOW SHORTCUTS)
Use these commands to trigger specific Skills immediately:
- `/plan`    -> Invokes `skills/planejando-solucoes/SKILL.md`
- `/code`    -> Invokes `skills/executando-planos/SKILL.md`
- `/fix`     -> Invokes `skills/solucionando-erros/SKILL.md`
- `/ui`      -> Invokes `skills/criando-ui/SKILL.md`
- `/qa`      -> Invokes `skills/verificando-conclusao/SKILL.md`
- `/seo`     -> Invokes `skills/seo-optimizer/SKILL.md` (NEW)
- `/mcp`     -> Invokes `skills/mcp-builder/SKILL.md` (NEW)
- `/brain`   -> Invokes `skills/brainstorming/SKILL.md`

## 📂 FILE SYSTEM NAVIGATION (THE 4 PILLARS)
- **`/rules`**: The Law. Detailed Policies (.law), Stack definitions (.policy), and Guardrails (.yaml). READ THESE for deep context.
- **`/skills`**: The Brain. Procedures for Planning, Coding, Debugging, and Deploying.
- **`/snippets`**: The Parts. Reusable, pre-validated code blocks (JSON-LD, Database, Auth).
- **`/ui`**: The Look. Design System, Color Palette, and SEO Config.

## 🚨 CRITICAL VIOLATIONS (INSTANT FAIL)
You are strictly FORBIDDEN from using or suggesting:
- ❌ **Pinecone/Qdrant**: Use **Neon pgvector** (Postgres).
- ❌ **Firebase/Supabase Auth**: Use **Clerk** (Auth) + **Neon** (DB).
- ❌ **Axios**: Use **native `fetch`**.
- ❌ **CSS Modules/Styled-Components**: Use **Tailwind CSS**.
- ❌ **Secrets in Code**: Always use `process.env`.
- ❌ **Python for Web**: Python is only for Workers/AI. Next.js App Router is the Orchestrator.

## 🧠 SKILL-FIRST WORKFLOW (MANDATORY)
Before acting, check the specific Skill in `/skills`:
1. **Planning?** -> Read `/skills/planejando-solucoes/SKILL.md`.
2. **Coding?** -> Read `/skills/codando/SKILL.md` (if exists) or follow Stack Omega.
3. **SEO/Meta?** -> Read `/skills/seo-optimizer/SKILL.md`.
4. **New Feature?** -> Read `/skills/brainstorming/SKILL.md`.

## 🏗️ STACK OMEGA (DEFAULT)
- **Orchestration:** Next.js 14+ (App Router).
- **Database:** Neon (Postgres + Drizzle).
- **Queues:** Inngest (Serverless Jobs).
- **Style:** Tailwind + Shadcn UI.
- **AI:** Vercel AI SDK / OpenRouter / Ollama (Local).

## 🛡️ BEHAVIOR & OBSERVABILITY
- **Server-First:** Default to RSC (React Server Components).
- **No `any`:** TypeScript must be strict.
- **Structured Logs:** Every critical path must log via `console.log(JSON.stringify({...}))`.
"""
    write_file(".cursorrules", cursor_rules)

    # .vscode/settings.json (Configurações do Editor)
    vscode_settings = """
{
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "files.exclude": {
    "**/.git": true,
    "**/.DS_Store": true
  },
  "search.exclude": {
    "**/node_modules": true,
    "**/.next": true
  }
}
"""
    write_file(".vscode/settings.json", vscode_settings)

    # =========================================================
    # 2. PASTA /rules (A LEI DETALHADA - MANTENDO SUA ESTRUTURA)
    # =========================================================
    
    write_file("rules/antigravity.law", """
# ANTI-GRAVITY LAW v15.0
# Referência Canônica de Regras e Disciplina.

[DISCIPLINA]
require_skill_usage = true
announce_skill_usage = true
slash_commands_enabled = true

[STACK_OMEGA]
primary_db = neon
vector_db = neon_pgvector
secondary_db = airtable, google-sheets
llm_router = openrouter
local_llm = ollama
forbidden_vendors = pinecone, firebase, auth0, mongo

[OBSERVABILIDADE]
log_format = json_structured
metrics_required = true
seo_check_required = true

[SEGURANCA]
block_secrets_in_code = true
require_env_validation = true

[ARQUITETURA]
nextjs_must_orchestrate = true
python_as_worker_only = true
ui_framework = tailwind_shadcn
""")

    write_file("rules/stack-omega.policy", """
# Política de Uso da Stack Omega (v15)

## ✅ Permitido (The Happy Path)
- **Banco**: Neon (pgvector).
- **LLM**: OpenRouter (Cloud), Ollama (Local).
- **Frontend**: Next.js App Router.
- **Automação**: Inngest, Apify, Evolution API.
- **SEO**: Next.js Metadata + JSON-LD.

## ❌ Proibido (The Ban List)
- **Pinecone**: Custo alto. Use Neon.
- **Firebase**: Vendor lock-in.
- **Auth0**: Complexidade desnecessária. Use Clerk.
""")

    write_file("rules/llm-guardrails.yaml", """
guardrails:
  cost:
    max_cost_usd: 0.05
    alert_threshold: 0.02
  routing:
    primary: anthropic/claude-3-5-sonnet
    fallback: openai/gpt-4o-mini
    offline: ollama/llama3
""")

    # =========================================================
    # 3. PASTA /skills (O CÉREBRO ATUALIZADO)
    # =========================================================

    # Skill: SEO Optimizer (NOVA)
    write_file("skills/seo-optimizer/SKILL.md", """---
name: seo-optimizer
description: O Especialista em Search Engine Optimization. Garante indexação, Core Web Vitals e JSON-LD.
version: 1.0.0
tags: [seo, metadata, sitemap, performance]
---
# SEO Optimizer Protocol

## 🎯 Quando usar
- Comando `/seo`.
- Antes do deploy.

## ⚙️ Fluxo de Trabalho
1. **Auditoria Metadata**: Checar `layout.tsx` (title, desc, OG images).
2. **Dados Estruturados**: Injetar JSON-LD via `snippets/seo/json-ld.tsx`.
3. **Performance**: Validar `next/image` e `next/font`.
4. **Sitemap**: Garantir geração de `sitemap.xml`.
""")

    # Skill: MCP Builder (NOVA)
    write_file("skills/mcp-builder/SKILL.md", """---
name: mcp-builder
description: Cria servidores MCP (Model Context Protocol) para conectar o Agente a dados locais ou APIs legadas.
version: 1.0.0
tags: [mcp, tools, integration]
---
# MCP Builder Protocol

## 🎯 Quando usar
- Comando `/mcp`.
- Agente precisa ler arquivos locais ou banco SQLite.

## ⚙️ Fluxo de Trabalho
1. Definir Recurso (Dados) ou Ferramenta (Ação).
2. Criar servidor TypeScript com `@modelcontextprotocol/sdk`.
3. Configurar transporte Stdio (Local).
""")

    # Skill: Brainstorming (ATUALIZADA v2.1)
    write_file("skills/brainstorming/SKILL.md", """---
name: brainstorming
description: PM. Transforma intenções em specs. Self-Aware das capacidades v15.0 (SEO, MCP, Local LLM).
version: 2.1.0
---
# Brainstorming Estruturado (v2.1)

## 🎯 Quando usar
- Comando `/brain` ou `/plan`.

## 🧱 Reality Check (v15)
- "Precisa de tráfego?" -> Sugerir **Skill `/seo`**.
- "Dados locais?" -> Sugerir **Skill `/mcp`**.
- "Custo?" -> Sugerir **Local LLM**.

## ⚙️ Fluxo
1. Extração da Intenção.
2. Seleção de Arsenal (Skills).
3. Spec Funcional (`docs/SPEC-*.md`).
""")

    # Skill: Index (ATUALIZADA)
    write_file("skills/index-skills/SKILL.md", """---
name: index-skills
description: Mapa do Sistema Antigravity v15.0.
version: 3.0.0
---
# Índice de Skills (v15.0)

## ⚡ Slash Commands
- `/plan` (Arquitetura)
- `/code` (Dev)
- `/fix` (Debug)
- `/seo` (Otimização)
- `/mcp` (Conectividade)
- `/brain` (Brainstorming)
""")

    # Manter as outras skills essenciais (placeholder para não ficar gigante, mas criando o arquivo)
    other_skills = [
        "planejando-solucoes", "executando-planos", "solucionando-erros", 
        "criando-ui", "verificando-conclusao", "explorando-mercado"
    ]
    for skill in other_skills:
        write_file(f"skills/{skill}/SKILL.md", f"# {skill}\nConsulte o índice.")

    # =========================================================
    # 4. PASTA /snippets (AS PEÇAS - COM NOVOS ITENS)
    # =========================================================
    
    # JSON-LD para SEO
    write_file("snippets/seo/json-ld.tsx", """
import React from 'react';
export function JsonLd({ data }: { data: Record<string, any> }) {
  return <script type="application/ld+json" dangerouslySetInnerHTML={{ __html: JSON.stringify(data) }} />;
}
""")

    # Local LLM (Ollama)
    write_file("snippets/ai/local-llm.ts", """
import { createOpenAI } from "@ai-sdk/openai";
export const localAI = createOpenAI({
  baseURL: "http://localhost:11434/v1",
  apiKey: "ollama",
  name: "ollama"
});
""")
    
    # DB Connect (Clássico)
    write_file("snippets/db/connect.ts", """
import { neon } from '@neondatabase/serverless';
import { drizzle } from 'drizzle-orm/neon-http';
const sql = neon(process.env.DATABASE_URL!);
export const db = drizzle(sql);
""")

    # =========================================================
    # 5. PASTA /ui (A ESTÉTICA - COM SEO CONFIG)
    # =========================================================
    
    write_file("ui/ui-guide.md", """
# UI Kit Antigravity — Design System Canônico

## 🎨 Cores (Antigravity Palette)
- **Primary**: `bg-antigravity-500` (Azul Técnico).
- **Success**: `text-success` (Verde).
- **Critical**: `text-critical` (Vermelho).

## 🧭 SEO
Todo projeto deve importar `ui/seo-config.ts`.
""")

    write_file("ui/seo-config.ts", """
import type { Metadata } from "next";

export const antigravityMetadata: Metadata = {
  title: { template: "%s | Antigravity OS", default: "Antigravity OS" },
  description: "Sistemas autônomos de produção com SLA >99.9%.",
  keywords: ["AI Engineer", "Next.js", "Neon", "SLA"],
};
""")

    print("\n✨ SYSTEM OVERRIDE COMPLETE: Antigravity v15.0 Instalado.")
    print("👉 .cursorrules: Expandido com Slash Commands e Regras Rígidas.")
    print("👉 /rules: Pasta mantida e atualizada com .law e .policy.")
    print("👉 /skills: Inclui SEO e MCP.")
    print("👉 /snippets: Inclui JSON-LD e Local LLM.")

if __name__ == "__main__":
    create_ultimate_structure()