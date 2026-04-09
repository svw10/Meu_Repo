---
name: using_git_worktrees
description: Isolamento de features via Git Worktrees. Desenvolva múltiplas branches simultaneamente sem switch de contexto.
version: 3.1.0
framework: "Antigravity OS v3.1"
owner_agent: THETA
trigger: "/isolate"
integration: "Antigravity Neural Router"
status: active
tags: [git, worktree, isolation, feature-branch, workflow, theta]
---

# 04 - USING GIT WORKTREES (Feature Isolation Protocol)

## 🎯 Quando usar
- **Desenvolvimento paralelo**: Múltiplas features em andamento simultaneamente
- **Hotfix urgente**: Corrigir produção sem interromper feature em desenvolvimento
- **Code review isolado**: Preparar PR sem poluir branch principal
- **Testes A/B**: Comparar implementações diferentes lado a lado
- **Context switching**: Trocar entre tarefas sem stash/commit prematuro

> **Regra de Ouro**: Uma feature = Um worktree = Um contexto limpo. Nunca misture branches no mesmo diretório.

## 🧱 Arquitetura Git Worktree + Antigravity

```
meu-projeto/ (main)
├── .git/
├── src/
├── .antigravity-os/
└── worktrees/
    ├── feature/auth-v2/     ← Worktree 1: Autenticação
    ├── hotfix/login-bug/    ← Worktree 2: Correção urgente
    └── experiment/ai-chat/  ← Worktree 3: Experimento IA
```

| Componente | Função | Integração Antigravity |
|:---|:---|:---|
| **Git Worktree** | Diretório isolado por branch | Cada worktree tem seu `CURRENT_AGENT.md` |
| **Branch naming** | Convenção clara de nomes | `feature/`, `hotfix/`, `experiment/` |
| **State isolation** | Estado do agente por worktree | `context/CURRENT_AGENT.md` local |
| **Sync protocol** | Sincronização segura com main | Via `.antigravity-os/[08] SUBMODULE_HOOKS/` |

## ⚙️ Protocolo de Isolamento (5 Passos)

### Passo 1: Criar Worktree (2 min)

```bash
# Sintaxe base:
git worktree add <caminho> <branch> -b <nova-branch>

# Exemplos práticos:

# 1. Nova feature
git worktree add worktrees/feature/dashboard-analytics -b feature/dashboard-analytics

# 2. Hotfix urgente da main
git worktree add worktrees/hotfix/login-crash main -b hotfix/login-crash

# 3. Experimento sem afetar branches existentes
git worktree add worktrees/experiment/ai-refactor -b experiment/ai-refactor
```

**Checklist de Criação:**
- [ ] Nome da branch segue convenção (`feature/`, `hotfix/`, `experiment/`)
- [ ] Worktree criado em `worktrees/` (não na raiz)
- [ ] Branch base correta (main para hotfix, develop para features)
- [ ] `.gitignore` do worktree respeitado

### Passo 2: Inicializar Contexto do Agente (1 min)

Cada worktree precisa de seu próprio estado:

```bash
# Dentro do novo worktree:
cd worktrees/feature/dashboard-analytics

# Copiar estrutura base do Antigravity (se necessário)
cp -r ../../.antigravity-os ./
cp -r ../../Minhas_Skills ./
cp ../../.cursorrules ./

# Inicializar CURRENT_AGENT.md específico
cat > context/CURRENT_AGENT.md << EOF
---
name: current_agent
worktree: "feature/dashboard-analytics"
branch: "feature/dashboard-analytics"
parent_branch: "develop"
created_at: $(date -Iseconds)
---

# ESTADO DO WORKTREE

**Feature**: Dashboard de Analytics  
**Objetivo**: Implementar gráficos de retenção e funil de conversão  
**Stack**: Next.js 14 + Neon + Recharts  

## Progresso
- [ ] Setup inicial
- [ ] Schema de dados
- [ ] Componentes de gráfico
- [ ] Integração com API
- [ ] QA e testes

## Próximos passos
1. Consultar BETA para schema
2. Executar GAMMA para componentes
EOF
```

### Passo 3: Desenvolver com Contexto Isolado (N min)

**Vantagens do worktree:**
- ✅ Terminal dedicado por feature
- ✅ Dependências instaladas localmente (sem conflito de versões)
- ✅ Server rodando em porta diferente (`PORT=3001`, `3002`, etc.)
- ✅ `.env` específico por feature (ex: `DATABASE_URL` de staging)

**Exemplo de fluxo GAMMA em worktree:**

```bash
# No worktree da feature:
cd worktrees/feature/dashboard-analytics

# Rodar servidor em porta alternativa
PORT=3001 npm run dev

# Executar skill via slash command
/code criar componente LineChart com Recharts

# O GAMMA trabalha apenas neste contexto
# Sem risco de commitar código de outra feature
```

### Passo 4: Validar e Preparar PR (5 min)

Antes de finalizar:

```bash
# 1. Rodar validações locais
npm run lint
npm run test
npx tsc --noEmit

# 2. Executar auditoria DELTA
/qa validar feature dashboard-analytics

# 3. Commitar com mensagem estruturada
git add .
git commit -m "feat(dashboard): adiciona gráficos de retenção e funil

- Implementa LineChart com Recharts
- Integra com endpoint /api/analytics/retention
- Adiciona filtros de período e segmento
- Testes unitários para hooks de dados

Refs: PLAN-dashboard-analytics, ISSUE-142"

# 4. Push da branch (não do worktree!)
# O worktree compartilha o .git/ principal
git push origin feature/dashboard-analytics
```

### Passo 5: Limpeza e Merge (3 min)

Após PR aprovado:

```bash
# 1. Voltar para diretório principal
cd ../..

# 2. Fazer checkout da branch alvo
git checkout develop

# 3. Merge do PR (via UI do GitHub ou CLI)
git merge feature/dashboard-analytics --no-ff -m "Merge feature/dashboard-analytics"

# 4. Remover worktree (opcional, mas recomendado)
git worktree remove worktrees/feature/dashboard-analytics

# 5. Limpar branch remota (após merge)
git push origin --delete feature/dashboard-analytics
```

## 🔄 Integração com Agentes Antigravity

| Agente | Papel no Worktree |
|--------|------------------|
| **THETA** | Cria worktree, inicializa contexto, gerencia múltiplos worktrees |
| **BETA** | Define escopo da feature no `PLAN.md` específico do worktree |
| **GAMMA** | Executa código isolado, sem risco de conflito com outras branches |
| **DELTA** | Audita PR preparado no worktree antes do push |
| **ETA** | Debuga issues específicas do worktree sem afetar main |
| **ZETA** | Otimiza performance do worktree (cache, dependências) |

**Exemplo de orquestração THETA:**

```yaml
# context/CURRENT_AGENT.md no worktree
active_agent: THETA
worktree_mode: true
active_worktrees:
  - path: "worktrees/feature/auth-v2"
    branch: "feature/auth-v2"
    status: "in_progress"
  - path: "worktrees/hotfix/login-bug"
    branch: "hotfix/login-bug"
    status: "ready_for_pr"
next_action: "Switch to worktrees/hotfix/login-bug for urgent fix"
```

## 🛡️ Regras de Segurança e Boas Práticas

### ✅ Permitido
- [ ] Múltiplos worktrees ativos simultaneamente (recomendado: ≤ 3)
- [ ] Cada worktree com seu próprio `node_modules/` (evita conflitos de versão)
- [ ] Variáveis de ambiente específicas por worktree (`.env.local` não versionado)
- [ ] Servidores rodando em portas diferentes (`3000`, `3001`, `3002`)

### ❌ Proibido
- [ ] Commitar diretamente da pasta `worktrees/` sem push da branch
- [ ] Modificar `.git/` manualmente dentro do worktree
- [ ] Usar `git add .` na raiz enquanto worktrees estão ativos (pode incluir arquivos não intencionais)
- [ ] Deletar branch sem remover worktree correspondente (gera "dangling worktree")

### ⚠️ Atenção
- Worktrees compartilham o mesmo `.git/` → operações no repositório afetam todos
- `git fetch` atualiza todas as branches, mas não altera worktrees ativos
- `git gc` pode ser mais lento com múltiplos worktrees (execute periodicamente)

## 📋 Template de Worktree Setup

```bash
#!/bin/bash
# scripts/create-feature-worktree.sh

set -e

FEATURE_NAME=$1
BRANCH_TYPE=${2:-feature}  # feature, hotfix, experiment
BASE_BRANCH=${3:-develop}

if [ -z "$FEATURE_NAME" ]; then
  echo "Uso: $0 <nome-da-feature> [tipo] [branch-base]"
  echo "Exemplo: $0 dashboard-analytics feature develop"
  exit 1
fi

BRANCH_NAME="${BRANCH_TYPE}/${FEATURE_NAME}"
WORKTREE_PATH="worktrees/${BRANCH_NAME}"

echo "🌳 Criando worktree: ${WORKTREE_PATH}"
echo "   Branch: ${BRANCH_NAME}"
echo "   Base: ${BASE_BRANCH}"

# Criar worktree
git worktree add -b "${BRANCH_NAME}" "${WORKTREE_PATH}" "${BASE_BRANCH}"

# Inicializar estrutura Antigravity (se necessário)
if [ ! -f "${WORKTREE_PATH}/.antigravity-os/[99] INDEX.md" ]; then
  echo "📦 Copiando estrutura Antigravity..."
  cp -r .antigravity-os "${WORKTREE_PATH}/"
  cp -r Minhas_Skills "${WORKTREE_PATH}/" 2>/dev/null || true
  cp .cursorrules "${WORKTREE_PATH}/" 2>/dev/null || true
fi

# Criar CURRENT_AGENT.md inicial
cat > "${WORKTREE_PATH}/context/CURRENT_AGENT.md" << EOF
---
name: current_agent
worktree: "${FEATURE_NAME}"
branch: "${BRANCH_NAME}"
parent_branch: "${BASE_BRANCH}"
created_at: $(date -Iseconds)
---

# ESTADO DO WORKTREE: ${FEATURE_NAME}

**Objetivo**: [Preencher após /plan]
**Stack**: [Preencher após BETA]

## Progresso
- [ ] Setup
- [ ] Planejamento
- [ ] Implementação
- [ ] QA
- [ ] PR

## Próximos passos
1. Executar /plan para definir escopo
EOF

echo "✅ Worktree criado com sucesso!"
echo "💡 Para começar: cd ${WORKTREE_PATH} && /plan [descrição da feature]"
```

## 🚫 Anti-Padrões (Proibidos)

- ❌ Usar `git switch` em vez de worktrees para trocar de contexto (perde estado local)
- ❌ Commitar código incompleto só para "liberar" a branch principal
- ❌ Ignorar convenção de naming (`feature/`, `hotfix/`)
- ❌ Manter worktrees órfãos após merge (consome disco e causa confusão)
- ❌ Rodar `npm install` na raiz enquanto worktrees usam versões diferentes

## ✅ Checklist de Qualidade

- [ ] Worktree criado com `git worktree add` (não clone manual)
- [ ] Branch nomeada com prefixo correto (`feature/`, `hotfix/`, `experiment/`)
- [ ] `context/CURRENT_AGENT.md` inicializado com metadata do worktree
- [ ] Dependências instaladas localmente (se necessário)
- [ ] Porta do servidor configurada para não conflitar (`3000 + N`)
- [ ] `.env.local` com variáveis específicas da feature (não versionado)
- [ ] PR preparado com commit estruturado e mensagens claras
- [ ] Worktree removido após merge (`git worktree remove`)

## 🔗 Integração com Sistema v3.1

**Roteamento:** Invocada via `/isolate <nome>` ou por THETA ao detectar desenvolvimento paralelo.

**Memória:** Metadata do worktree registrada em `.antigravity-os/[04] MEMORY_DNA/` para aprendizado de padrões de isolamento.

**Budget:** Worktrees não impactam budget de tokens — cada contexto é isolado e econômico.

**Handoff:** Após criação, THETA delega para BETA (planejamento) ou GAMMA (execução) dentro do worktree.

**Stack Omega:** Git 2.25+ (suporte nativo a worktrees), Node.js para scripts de automação.

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Esta skill é invocada via `.antigravity-os/[02] SQUAD_WRAPPERS/` ou Slash Commands.

**Memória:** Erros encontrados devem ser logados em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.

**Budget:** Respeite os limites de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.

**Handoff:** Após execução, atualize `context/CURRENT_AGENT.md` e retorne ao THETA.

**Stack Omega:** Siga rigorosamente `Minhas_Rules/STACK_OMEGA_RULES.md`.
