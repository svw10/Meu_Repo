name: index-skills
description: Kernel Universal v3.0. Índice Canônico das 12 skills do Antigravity OS. Router central e documentação de arquitetura.
version: 3.0.2
tags: [core, kernel, router, sistema, indice, arquitetura]
---

# 00 - INDEX SKILLS (Kernel Universal v3.0.2)

> **Sistema**: Antigravity OS  
> **Versão**: 3.0.2 (Final)  
> **Total de Skills**: 12  
> **Última atualização**: 2026-02-22

## 🎯 Propósito

Este é o **Kernel do Sistema** - o mapa canônico que define:
- Quais skills existem (12 total)
- Em qual camada operam (1-4 + CORE)
- Como se relacionam (dependências)
- Versão atual de cada uma

**Regra de Ouro**: Toda skill mencionada aqui existe fisicamente em `Minhas_Skills/`. Não há skills "fantasma".

---

## 🗺️ Mapa Visual das Skills
┌─────────────────────────────────────────────────────────────┐
│                        CORE (Camada 0)                      │
│  ┌─────────────────┐    ┌─────────────────┐                 │
│  │ 00_index_skills │◄──►│ 12_usando_skills│  (Entry Point)  │
│  │   (Este arquivo)│    │  (Supervisor)   │                 │
│  └─────────────────┘    └─────────────────┘                 │
└─────────────────────────────────────────────────────────────┘
│
┌─────────────────────┼─────────────────────┐
▼                     ▼                     ▼
┌───────────────┐    ┌───────────────┐    ┌───────────────┐
│  CAMADA 1     │    │  CAMADA 2     │    │  CAMADA 3     │
│  Estratégia   │◄──►│  Execução     │◄──►│  Qualidade    │
│  & Discovery  │    │  & Build      │    │  & Debug      │
└───────────────┘    └───────────────┘    └───────────────┘
│                     │                     │
│    ┌────────────────┼────────────────┐    │
│    ▼                ▼                ▼    │
│ ┌────────┐    ┌──────────┐    ┌──────────┐│
└►│01      │    │03        │    │04        │┘
│02      │    │06        │    │05        │
│08      │    │07        │    └──────────┘
└────────┘    └──────────┘
│
┌──────────┴──────────┐
▼                     ▼
┌───────────────┐    ┌───────────────┐
│  CAMADA 4     │    │  CAMADA 4     │
│  Domínio      │    │  Domínio      │
│  E-commerce   │    │  IA/LLM       │
└───────────────┘    └───────────────┘
│                     │
┌────┘                     └────┐
▼                               ▼
┌──────┐                      ┌──────────┐
│09    │                      │10        │
│      │                      │11        │
└──────┘                      └──────────┘
plain
Copy

---

## 📋 Índice Canônico (12 Skills)

| # | Skill | Camada | Descrição | Versão | Status |
|---|-------|--------|-----------|--------|--------|
| 00 | `index-skills` | CORE | Kernel/Router central | 3.0.2 | ✅ Ativo |
| 01 | `brainstorming` | 1 | Discovery de produto e ideias | 3.0.0 | ✅ Ativo |
| 02 | `planejando-solucoes` | 1 | Arquitetura técnica e planejamento | 3.0.0 | ✅ Ativo |
| 03 | `executando-planos` | 2 | Build Loop - execução de código | 3.0.0 | ✅ Ativo |
| 04 | `solucionando-erros` | 3 | Debug e resolução de problemas | 3.0.0 | ✅ Ativo |
| 05 | `verificando-conclusao` | 3 | QA e verificação de entrega | 3.0.0 | ✅ Ativo |
| 06 | `codando` | 2 | Padrões de código e UI | 3.0.0 | ✅ Ativo |
| 07 | `comunicando-externo` | 2 | Comunicação (email, WhatsApp, etc) | 3.0.0 | ✅ Ativo |
| 08 | `explorando-mercados` | 1 | Validação de mercado e concorrência | 3.0.0 | ✅ Ativo |
| 09 | `gerenciando-memoria` | 4 | RAG e sistemas de memória (e-commerce) | 3.0.0 | ✅ Ativo |
| 10 | `llm-app-blueprint` | 4 | Arquitetura de aplicações LLM | 3.0.0 | ✅ Ativo |
| 11 | `pesquisando-web` | 4 | Research competitivo e web scraping | 3.0.0 | ✅ Ativo |
| 12 | `usando-skills` | CORE | Supervisor/Entry point universal | 3.0.1 | ✅ Ativo |

---

## 🏗️ Estrutura de Diretórios (Física)
Minhas_Skills/
├── CORE/                               # 🧠 Kernel + Consciência
│   ├── 00_index_skills.md              # Este arquivo
│   └── 12_usando_skills.md             # Supervisor universal
│
├── ESTRATEGIA_DISCOVERY/               # 📊 Camada 1: Validar/Descobrir
│   ├── 01_brainstorming.md
│   ├── 02_planejando_solucoes.md
│   └── 08_explorando_mercados.md
│
├── EXECUCAO_IMPLEMENTACAO/             # ⚙️ Camada 2: Construir
│   ├── 03_executando_planos.md
│   ├── 06_codando.md
│   └── 07_comunicando_externo.md
│
├── QUALIDADE_DEBUG/                    # 🔍 Camada 3: Verificar/Corrigir
│   ├── 04_solucionando_erros.md
│   └── 05_verificando_conclusao.md
│
├── DOMINIO_ECOMMERCE/                  # 🛒 Camada 4: Especialização
│   └── 09_gerenciando_memoria.md
│
└── DOMINIO_IA/                         # 🤖 Camada 4: Especialização
├── 10_llm_app_blueprint.md
└── 11_pesquisando_web.md
plain
Copy

---

## 🔄 Fluxo de Trabalho Típico

### Fluxo 1: Nova Feature (Discovery → Build → QA)
12_usando_skills (entry)
→ 01_brainstorming (ideia)
→ 02_planejando_solucoes (arquitetura)
→ 03_executando_planos (build)
→ 06_codando (implementação UI)
→ 05_verificando_conclusao (QA)
plain
Copy

### Fluxo 2: Bug em Produção (Debug → Fix → Verify)
12_usando_skills (entry)
→ 04_solucionando_erros (diagnóstico)
→ 03_executando_planos (fix)
→ 05_verificando_conclusao (regressão)
plain
Copy

### Fluxo 3: Sistema de Recomendação IA (Especializado)
12_usando_skills (entry)
→ 01_brainstorming (conceito)
→ 10_llm_app_blueprint (arquitetura LLM)
→ 09_gerenciando_memoria (RAG de produtos)
→ 03_executando_planos (implementação)
→ 05_verificando_conclusao (testes)
plain
Copy

---

## 🔗 Matriz de Dependências

| Skill | Depende de | É chamada por |
|-------|-----------|---------------|
| 00_index_skills | - | 12_usando_skills |
| 01_brainstorming | 12_usando_skills | 02_planejando_solucoes |
| 02_planejando_solucoes | 01_brainstorming | 03_executando_planos |
| 03_executando_planos | 02_planejando_solucoes | 04, 05, 06, 07 |
| 04_solucionando-erros | 03_executando_planos | 03 (retry), 05 |
| 05_verificando-conclusao | 03, 04 | 07 (notificação) |
| 06_codando | 02_planejando-solucoes | 03_executando_planos |
| 07_comunicando-externo | 05_verificando-conclusao | - (final) |
| 08_explorando-mercados | 01_brainstorming | 02_planejando-solucoes |
| 09_gerenciando-memoria | 02_planejando-solucoes | 03, 10 |
| 10_llm-app-blueprint | 02_planejando-solucoes | 03, 09 |
| 11_pesquisando-web | 08_explorando-mercados | 01, 02 |
| 12_usando-skills | 00_index_skills | **TODAS** (entry) |

---

## 🎯 Convenções de Nomenclatura

### Arquivos
- **Skills**: `XX_nome_da_skill.md` (snake_case, zero-padded)
- **Índice**: `00_index_skills.md`
- **Supervisor**: `12_usando_skills.md`

### Pastas
- **Maiúsculas**: `CORE/`, `ESTRATEGIA_DISCOVERY/`
- **Sem espaços**: Use underscore ou hífen
- **Em português**: Exceto termos técnicos (RAG, LLM, API)

### Versionamento
- **Semântico**: `MAJOR.MINOR.PATCH`
- **Major**: Mudança de arquitetura (ex: v2→v3)
- **Minor**: Nova funcionalidade (ex: v3.0→v3.1)
- **Patch**: Correção/ajuste (ex: v3.0.0→v3.0.1)

---

## 🚀 Quick Start (Para Novos Projetos)

1. **Copiar estrutura**: Use `init_antigravity_v3.py`
2. **Entry point**: Sempre comece com `12_usando_skills`
3. **Primeira skill**: Geralmente `01_brainstorming` (discovery)
4. **Stack padrão**: Next.js 14+, Neon, Inngest, Clerk, OpenRouter

---

## 📝 Changelog do Sistema

### v3.0.2 (2026-02-22) - FINAL
- **ADD**: Skill 12_usando_skills (supervisor/entry point)
- **ADD**: Camada 0 (CORE) separada das Camadas 1-4
- **REFACTOR**: Reorganização em 6 pastas físicas
- **UPDATE**: Matriz de dependências completa
- **REMOVE**: Skills legadas (criando-skills, etc)

### v3.0.1 (2026-02-20)
- Consolidação de 20+ skills para 11 skills principais
- Unificação de camadas (1-4)
- Stack Omega v3.0 definida

### v3.0.0 (2026-02-15)
- Arquitetura inicial do Antigravity OS
- Conceito de skills especializadas
- Protocolo de consciência

---

## ⚠️ Notas de Manutenção

- **Nunca edite este arquivo manualmente** - use `12_usando_skills` para modificações
- **Skills órfãs**: Se remover uma skill do índice, remova também o arquivo físico
- **Versionamento**: Ao atualizar uma skill, atualize também a versão aqui
- **Testes**: Após mudanças, execute `validate_skills.py` (se existir)

---

**Status do Sistema**: ✅ Operacional  
