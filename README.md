# 🧬 Antigravity OS Neural v3.1

> Sistema operacional de desenvolvimento de software com IA — 8 agentes autônomos, 12 skills especializadas e auditoria de segurança zero-trust.

[![Stack](https://img.shields.io/badge/Stack-Omega_v3.0-blueviolet)](#-stack-omega-v30)
[![Agentes](https://img.shields.io/badge/Agentes-8_Autônomos-green)](#-squad-de-agentes)
[![Skills](https://img.shields.io/badge/Skills-12_Especializadas-orange)](#-skills-engine)
[![Security](https://img.shields.io/badge/Security-Zero_Trust_v5.0-red)](#-segurança--auditoria)
[![License](https://img.shields.io/badge/License-MIT-blue)](#-licença)

---

## 📋 Índice

- [Visão Geral](#-visão-geral)
- [Arquitetura](#-arquitetura)
- [Squad de Agentes](#-squad-de-agentes)
- [Skills Engine](#-skills-engine)
- [Stack Omega v3.0](#-stack-omega-v30)
- [Segurança e Auditoria](#-segurança--auditoria)
- [Setup — Novo Projeto](#-setup--novo-projeto)
- [Estrutura de Pastas](#-estrutura-de-pastas)
- [Fluxos de Trabalho](#-fluxos-de-trabalho)
- [Comandos Rápidos](#-comandos-rápidos)
- [CI/CD e Deploy](#-cicd--deploy)
- [UI Kit e Design System](#-ui-kit--design-system)
- [Contribuindo](#-contribuindo)
- [Licença](#-licença)

---

## 🎯 Visão Geral

O **Antigravity OS** não é um framework — é um **sistema operacional para desenvolvimento com IA**. Ele orquestra agentes especializados, gerencia contexto entre sprints, previne erros recorrentes com memória evolutiva e garante segurança enterprise-grade em cada deploy.

### Princípios Fundamentais

| Princípio | Descrição |
|-----------|-----------|
| **Lazy Loading** | Carrega apenas o necessário, quando necessário |
| **Stack Omega** | Tecnologias curadas, testadas, integradas — sem exceções sem ADR |
| **Agentes Especializados** | Cada agente faz uma coisa e faz melhor que qualquer generalista |
| **Observabilidade Total** | Antes de falhar, sabemos que vai falhar |
| **Evolução Contínua** | Cada projeto alimenta o sistema — skills melhoram, agentes aprendem |
| **Zero Trust** | Nenhum input é confiável — valide tudo, sempre |

### Missão

Reduzir em **70% o tempo de entrega** de projetos web modernos, mantendo segurança enterprise-grade e qualidade auditável.

---

## 🏗️ Arquitetura

O sistema opera em dois modos:

| Modo | Ambiente | Permitido | Proibido |
|------|----------|-----------|----------|
| **GEM** (Planejamento) | Google AI Studio, Chat | PRD, SPEC, Arquitetura, Brainstorm | Escrever código, commitar |
| **IDX** (Execução) | VSCode, Cursor, Terminal | Codar, testar, debugar, commitar | Mudar arquitetura sem aprovação |

### Padrões Implementados

- **Blackboard Pattern** — Contexto compartilhado entre agentes
- **Fail-Fast Validation** — Zod valida outputs antes de handover (anti-hallucination)
- **Handoff Artifacts** — Artefatos imutáveis de passagem de bastão entre agentes
- **Memory DNA** — Registro de erros com vacinas + prevention prompts
- **Token Budget Controller** — Economia de tokens com limites por tarefa
- **Feedback Loop Protocol** — Autocorreção DELTA→GAMMA/ETA + escalação

---

## 🤖 Squad de Agentes

8 agentes autônomos com personalidades e responsabilidades distintas:

| Agente | Nome | Função | Personalidade |
|--------|------|--------|---------------|
| **THETA** | Orchestrator Prime | Coordena, decide, delega, roteia tarefas | Líder calmo, visionário |
| **ALPHA** | Genesis Prime | Cria projetos do zero, scaffolding | Criativo, ousado |
| **BETA** | Architect Prime | Planeja, gera PRDs, define arquitetura | Analítico, meticuloso |
| **GAMMA** | Builder Prime | Executa, constrói, implementa features | Pragmático, rápido |
| **DELTA** | Auditor Prime | Revisa código, audita segurança, valida qualidade | Crítico, preciso |
| **EPSILON** | Growth Prime | Estratégia de mercado, growth hacking | Visionário, comercial |
| **ETA** | Investigator Prime | Debug profundo, root cause analysis | Detetive, persistente |
| **ZETA** | Optimizer Prime | Performance, refatoração, drift detection | Perfeccionista, eficiente |

### Fluxo de Orquestração

```
THETA (recebe tarefa)
  ├── Classifica → valida budget → seleciona agente
  ├── BETA planeja → GAMMA executa → DELTA audita
  ├── Erro? → ETA investiga → registra em Memory DNA
  └── Aprovado (≥ 85%)? → Deploy via CI/CD
```

> Documentação completa de cada agente em [`Agentes/`](Agentes/)

---

## ⚡ Skills Engine

12 skills especializadas organizadas em 4 camadas:

| Camada | Skills | Propósito |
|--------|--------|-----------|
| **CORE** | `00_index_skills`, `12_usando_skills` | Kernel + Entry Point |
| **1 — Discovery** | `01_brainstorming`, `02_planejando_solucoes`, `08_explorando_mercados` | Ideação e arquitetura |
| **2 — Build** | `03_executando_planos`, `06_codando`, `07_comunicando_externo`, `08_subagent_dispatch` | Implementação |
| **3 — QA** | `03_tdd_red_green_refactor`, `04_solucionando_erros`, `05_verificando_conclusao`, `05_code_review_checklist`, `13_testes_e2e` | Qualidade e debug |
| **4 — Domínio** | `09_gerenciando_memoria`, `10_llm_app_blueprint`, `11_pesquisando_web`, `13_memoria_persistente` | E-commerce, IA e RAG |

### Entry Point

Toda interação começa em: `Minhas_Skills/CORE/12_usando_skills.md`

> Índice completo em [`Minhas_Skills/CORE/00_index_skills.md`](Minhas_Skills/CORE/00_index_skills.md)

---

## 🛠️ Stack Omega v3.0

Tecnologias curadas e integradas — mudanças exigem ADR aprovado:

| Camada | Tecnologia | Propósito |
|--------|-----------|-----------|
| **Frontend** | Next.js 14+ (App Router) | Framework React full-stack |
| **Styling** | Tailwind CSS + Shadcn/UI | Design system + componentes |
| **Animações** | Framer Motion / GSAP | Micro-interações + scroll |
| **Database** | Neon PostgreSQL + Drizzle ORM | Banco serverless + type-safe ORM |
| **Auth** | Clerk | Autenticação + gerenciamento de usuários |
| **Queues** | Inngest | Orquestração assíncrona + retry |
| **AI/LLM** | OpenRouter (multi-provider) | Gateway para múltiplos modelos |
| **Email** | Resend + Brevo | Email transacional + marketing |
| **Messaging** | Evolution API | WhatsApp Business |
| **Deploy** | Vercel | CI/CD + hosting |
| **Validation** | Zod | Runtime validation + anti-hallucination |
| **TypeScript** | Strict Mode | `noUncheckedIndexedAccess`, `exactOptionalPropertyTypes` |

> ADRs documentados em [`.antigravity-os/[10] DECISIONS/`](.antigravity-os/%5B10%5D%20DECISIONS/)

---

## 🛡️ Segurança & Auditoria

Framework de segurança zero-trust com cobertura completa:

### Camadas de Defesa

| Camada | Local | Função |
|--------|-------|--------|
| **Políticas e Compliance** | `SECURITY_AUDIT/` | Checklists, threat modeling, LGPD, crypto standards |
| **Guardrails Operacionais** | `.antigravity-os/[06] SECURITY_DRL/` | PII sanitization, secrets vault, frontend inspector |
| **Regras Globais** | `Minhas_Rules/` | LLM guardrails, error handling, dependency policy |
| **Executor de Auditoria** | `Agentes/DELTA_Auditor.md` | Auditor que aplica as políticas |
| **CI/CD Security** | `.github/workflows/` + `SECURITY_AUDIT/[11]` | SAST, DAST, SCA, secrets scan |
| **Pre-commit Hooks** | `SECURITY_AUDIT/[12]` | 6 checks automatizados no git |

### SECURITY_AUDIT/ — Artefatos

| Arquivo | Conteúdo |
|---------|----------|
| `[00]` Zero-Trust Prompt | Prompt mestre de auditoria para IA |
| `[01]` 20 Leis Imutáveis | Leis de arquitetura segura em 5 camadas |
| `[02]` 30 Vetores de Ataque | Checklist com CWE, payloads e testes |
| `[03]` 15 Anti-Padrões Vibe Coding | Erros comuns de código gerado por IA |
| `[04]` Código de Referência | Snippets seguros (auth, SSRF, upload, webhooks) |
| `[05]` Checklist Hardening | 100+ itens para aprovação pré-deploy |
| `[06]` Template Relatório | Relatório 4 fases + scorecard A-F |
| `[07]` Incident Response | Plano com 5 fases + post-mortem + ANPD |
| `[08]` Threat Modeling | STRIDE + DREAD + trust boundaries |
| `[09]` Security Headers | Config para Next.js, Vercel, Nginx, Express |
| `[10]` Container Security | Dockerfile seguro + checklist |
| `[11]` CI/CD Security | Workflow SAST/DAST/SCA/Secrets |
| `[12]` Pre-commit Hooks | 6 checks com husky/lint-staged |
| `[13]` Compliance LGPD | Checklist + implementação técnica |
| `[14]` Crypto Standards | Algoritmos aprovados + referências |

> **Regra de ouro:** Nenhum deploy sem aprovação do DELTA (≥ 85% no checklist).

---

## 🚀 Setup — Novo Projeto

### 1. Clone o repositório central

```bash
git clone https://github.com/svw10/Meu_Repo.git
cd Meu_Repo
```

### 2. Integre como submódulo no seu projeto

```bash
# No seu projeto existente
git submodule add https://github.com/svw10/Meu_Repo.git .antigravity-os
bash .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh
```

### 3. Configure variáveis de ambiente

```bash
cp .env.example .env
# Edite .env com suas credenciais
```

**Variáveis mínimas:**

```env
DATABASE_URL="postgresql://user:pass@host:5432/db"
CLERK_SECRET_KEY="sk_..."
OPENAI_API_KEY="sk-..."
INNGEST_EVENT_KEY="your-key"
INNGEST_SIGNING_KEY="your-signing-key"
```

### 4. Inicialize e rode

```bash
npm install
npm run db:generate   # Gera client do ORM
npm run db:push       # Cria tabelas
npm run dev           # Inicia dev server
```

### 5. Instale hooks de segurança

```bash
npx husky install
# Veja: SECURITY_AUDIT/[12] PRE-COMMIT-HOOKS.md
```

---

## 📁 Estrutura de Pastas

```
Meu_Repo/
│
├── .antigravity-os/                 # 🧬 Core do OS (read-only em projetos)
│   ├── [00] KERNEL/                 # Boot: mode detection, budget, anxiety detector
│   ├── [01] ORCHESTRATOR/           # Roteamento semântico, feedback loop, handoff
│   ├── [02] SQUAD_WRAPPERS/         # Metadados de agentes (custo, trigger, fallback)
│   ├── [03] SKILLS_ENGINE/          # Indexador lazy-load de skills
│   ├── [04] MEMORY_DNA/             # Erros + vacinas + prevention prompts
│   ├── [05] TOKENOMICS/             # Economia de tokens + telemetria
│   ├── [06] SECURITY_DRL/           # PII sanitization, secrets vault, guardrails
│   ├── [07] SPECS_WARP/             # Templates PRD/SPEC + gates de qualidade
│   ├── [08] SUBMODULE_HOOKS/        # Scripts de automação Git
│   ├── [09] RETROSPECTIVE/          # Aprendizado pós-projeto
│   ├── [10] DECISIONS/              # ADRs machine-readable (YAML)
│   ├── [11] HANDOFF_ARTIFACTS/      # Artefatos de passagem de bastão
│   ├── [11] TEMPLATES/              # Templates reutilizáveis
│   └── [99] INDEX.md                # Mapa Mestre — leia SEMPRE primeiro
│
├── Agentes/                         # 🤖 Documentação dos 8 agentes
│   ├── THETA_Orchestrator.md
│   ├── ALPHA_Genesis.md
│   ├── BETA_Architect.md
│   ├── GAMMA_Builder.md
│   ├── DELTA_Auditor.md
│   ├── EPSILON_Growth.md
│   ├── ETA_Investigator.md
│   └── ZETA_Optimizer.md
│
├── Minhas_Skills/                   # ⚡ 12 skills em 4 camadas
│   ├── CORE/                        # Kernel + Supervisor
│   ├── ESTRATEGIA_DISCOVERY/        # Camada 1: Discovery
│   ├── EXECUCAO_IMPLEMENTACAO/      # Camada 2: Build
│   ├── QUALIDADE_DEBUG/             # Camada 3: QA
│   ├── DOMINIO_ECOMMERCE/           # Camada 4: E-commerce
│   ├── DOMINIO_IA/                  # Camada 4: IA/LLM
│   └── RECURSOS/                    # Scripts, snippets, templates
│
├── Minhas_Rules/                    # 📜 Políticas globais
│   ├── AGENTIC_IDE_RULES.md         # Regras para IDEs com IA
│   ├── ANTIGRAVITY_LAWS.md          # Leis do framework
│   ├── DEPENDENCY_POLICY.md         # Supply chain security
│   ├── ERROR_HANDLING_STANDARD.md   # Padrão de tratamento de erros
│   ├── LLM_Guardrails.md            # Guardrails para uso de LLMs
│   ├── STACK_OMEGA_RULES.md         # Regras da stack tecnológica
│   └── SYSTEM_IDENTITY.md           # Identidade e missão do OS
│
├── SECURITY_AUDIT/                  # 🛡️ Auditoria Zero-Trust v5.0
│   ├── [00]-[14] ...                # 15 artefatos de segurança
│   └── README.md                    # Índice da pasta
│
├── Ui_Kit_Design/                   # 🎨 Design system e UI kit
│   ├── Design_LP.md                 # Landing pages
│   ├── ui-kit-saas.md               # Kit SaaS
│   ├── animation_mastery_LP.md      # Animações
│   ├── gsap_scrolltrigger_LP.md     # GSAP + ScrollTrigger
│   └── motion-advanced-utils_LP.md  # Framer Motion avançado
│
├── templates/                       # 📄 Templates de projeto
│   ├── nextjs-landing/              # Boilerplate landing page
│   └── nextjs-saas/                 # Boilerplate SaaS
│
├── Logs/                            # 📊 Logging estruturado
├── context/                         # 🧭 Contexto do agente atual
├── docs/                            # 📚 ADRs e documentação
│
├── .github/workflows/               # ⚙️ CI/CD pipelines
│   └── antigravity-deploy.yml       # Pipeline com 5 security gates
│
├── .env.example                     # Template de variáveis (199 linhas)
├── .gitignore                       # Proteções de segurança
├── GEMINI.md                        # Integração com Google Gemini
├── CLAUDE.md                        # Integração com Anthropic Claude
└── README.md                        # 📖 Este arquivo
```

---

## 🔄 Fluxos de Trabalho

### Novo Projeto
```
1. init-submodule.sh → Integra Antigravity OS
2. Configure .cursorrules → Aponta para [00] KERNEL/
3. Leia INDEX.md → [00] quantum-loader.md
4. BETA (Architect) → Gera PRD
5. THETA converte PRD → SPEC técnica
6. GAMMA executa → DELTA audita → Deploy
```

### Desenvolvimento Diário
```
1. IA lê: .cursorrules → [00] KERNEL/ → [01] ORCHESTRATOR/
2. THETA classifica tarefa → valida budget → seleciona agente
3. GAMMA executa com budget → DELTA valida → commit
4. Erro? Registra em MEMORY_DNA → gera prevention_prompt
```

### Debug / Investigação
```
1. Consulta MEMORY_DNA → busca erro similar (vacina existente?)
2. Se encontrado: injeta prevention_prompt + aplica vacina
3. Se novo: ETA investiga → registra → gera nova vacina
4. Atualiza TOKENOMICS com métricas da sessão
```

### Auditoria Pré-Deploy
```
1. DELTA executa 4 fases: Red Team → Blue Team → TDD → Relatório
2. Aplica CHECKLIST-HARDENING (100+ itens)
3. Score ≥ 85%? → Aprovado para deploy
4. Score < 85%? → Retorna para GAMMA corrigir
```

---

## ⚡ Comandos Rápidos

```bash
/clear          # Limpa contexto entre sprints (obrigatório)
/compact        # Resume contexto aos 60% de uso
/context        # Mostra estado atual + budget restante
/cost           # Exibe telemetria da sessão atual
/sync-memory    # Força atualização de MEMORY_DNA cross-project
/plan           # Ativa modo BETA para planejamento
/build          # Ativa modo GAMMA para execução
/audit          # Aciona DELTA para revisão pré-commit
/retro          # Dispara Project Sweeper (aprendizado pós-projeto)
```

---

## ⚙️ CI/CD & Deploy

### Vercel (Recomendado)

O pipeline em `.github/workflows/antigravity-deploy.yml` executa 5 gates:

```
Lint → Security Scan → Tests → Build → Deploy
```

**Variáveis obrigatórias no Vercel:**

| Variável | Propósito |
|----------|-----------|
| `DATABASE_URL` | Conexão Neon PostgreSQL |
| `CLERK_SECRET_KEY` | Autenticação |
| `OPENAI_API_KEY` | LLMs (via OpenRouter) |
| `INNGEST_EVENT_KEY` | Orquestração de filas |
| `INNGEST_SIGNING_KEY` | Assinatura de eventos |

### Security Pipeline (Opcional)

Copie `SECURITY_AUDIT/[11] CI-CD-SECURITY.yml` para `.github/workflows/` para ativar:

- **SAST** — Semgrep (análise estática)
- **Secrets Scan** — TruffleHog + GitLeaks
- **SCA** — npm audit + Snyk (dependências)
- **Container Scan** — Trivy (se usar Docker)
- **Custom Checks** — Padrões do Antigravity OS

---

## 🎨 UI Kit & Design System

Kits de design documentados para produção:

| Kit | Conteúdo |
|-----|----------|
| [`Design_LP.md`](Ui_Kit_Design/Design_LP.md) | Landing pages premium |
| [`ui-kit-saas.md`](Ui_Kit_Design/ui-kit-saas.md) | Componentes SaaS (dashboards, tabelas, forms) |
| [`animation_mastery_LP.md`](Ui_Kit_Design/animation_mastery_LP.md) | Padrões de animação |
| [`gsap_scrolltrigger_LP.md`](Ui_Kit_Design/gsap_scrolltrigger_LP.md) | GSAP + ScrollTrigger |
| [`motion-advanced-utils_LP.md`](Ui_Kit_Design/motion-advanced-utils_LP.md) | Framer Motion avançado |

---

## 🤝 Contribuindo

1. Fork o repositório
2. Crie uma branch: `git checkout -b feature/nova-feature`
3. Commit seguindo [Conventional Commits](https://www.conventionalcommits.org/):
   ```
   feat: adiciona novo agente X
   fix: corrige validação de CNPJ
   docs: atualiza ADR-004
   security: adiciona rate limiting
   ```
4. Push: `git push origin feature/nova-feature`
5. Abra um Pull Request

### Regras de Contribuição

- Todo código passa pelo DELTA (auditoria ≥ 85%)
- Mudanças na Stack Omega exigem ADR
- Nunca edite `.antigravity-os/` diretamente — use `[08] SUBMODULE_HOOKS/`
- TypeScript strict mode obrigatório — `any` é proibido
- Testes para lógica crítica (cobertura mínima 80%)

---

## 📝 Licença

MIT License — veja [LICENSE](LICENSE) para detalhes.

---

## 📚 Referências

| Recurso | Link |
|---------|------|
| Next.js 14 | [nextjs.org/docs/app](https://nextjs.org/docs/app) |
| Drizzle ORM | [orm.drizzle.team](https://orm.drizzle.team) |
| Clerk Auth | [clerk.com/docs](https://clerk.com/docs) |
| Inngest | [inngest.com/docs](https://www.inngest.com/docs) |
| Zod | [zod.dev](https://zod.dev) |
| OWASP Top 10 | [owasp.org/Top10](https://owasp.org/Top10/) |
| Tailwind CSS | [tailwindcss.com](https://tailwindcss.com) |
| Shadcn/UI | [ui.shadcn.com](https://ui.shadcn.com) |

---

<p align="center">
  <strong>Mantido por:</strong> Luciano — Arquiteto AprenderIA<br>
  <strong>Versão:</strong> Antigravity OS Neural v3.1<br>
  <strong>Repositório:</strong> <a href="https://github.com/svw10/Meu_Repo">github.com/svw10/Meu_Repo</a>
</p>
