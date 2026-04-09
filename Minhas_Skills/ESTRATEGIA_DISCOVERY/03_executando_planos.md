---
name: executando_planos
framework: "Antigravity OS v3.1"
owner_agent: GAMMA
trigger: "/execute"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: executando-planos
description: Engenheiro de Execução. Transforma PLAN em código funcionando via Build Loop rigoroso. Commits atômicos, validação contínua, rollback seguro.
version: 3.0.1
tags: [execucao, codigo, git, build-loop, atomicidade]
---

# 03 - EXECUTANDO PLANOS (Build Loop Protocol)

## 🎯 Quando usar
- Usuário diz: "Execute o plano X", "Implemente a feature Y", "Faça isso"
- Arquivo `docs/PLAN-*.md` existe e está validado
- É hora de escrever código e transformar especificação em realidade

> **Regra de Ouro**: Sem PLAN, sem código. Se não existe plano, volte para `02_planejando_solucoes`.

> **Regra de Platina**: Um passo do plano = Um commit. Nunca misture passos.

## 🧱 Stack Omega (Comandos de Validação)

| Componente | Validação Obrigatória | Comando |
|:---|:---|:---|
| **Schema** | Drizzle válido | `npx drizzle-kit check` |
| **Types** | TypeScript strict | `npx tsc --noEmit` |
| **Lint** | Zero erros | `npm run lint` |
| **Testes** | Unitários passando | `npm run test` (se existir) |
| **Build** | Next.js builda | `npm run build` |
| **Inngest** | Funções registradas | Dashboard `localhost:8288` |
| **UI** | Sem erros visuais | `localhost:3000` |

> Toda alteração deve passar por toda a cadeia de validação antes do commit.

## ⚙️ Fluxo de Trabalho (Build Loop)

### Passo 1: Bootstrap (2 min)
- [ ] Ler `docs/PLAN-[nome].md`
- [ ] Criar `docs/RUN-[nome].md` (log de execução)
- [ ] Identificar passo atual (primeiro `[ ]`)

### Passo 2: Ciclo Atômico (por passo)

#### A. Pré-Validação (1 min)
- [ ] Arquivos necessários existem?
- [ ] Dependências do passo anterior satisfeitas?
- [ ] Ambiente OK (env vars, DB conectado)?

#### B. Implementação (5-10 min)
- [ ] Executar ação do plano **exatamente** como descrito
- [ ] Se ambíguo: pausar e pedir clarificação (não improvisar)
- [ ] Seguir padrões do código existente (arquitetura, naming)

#### C. Validação de Build (2 min)
```bash
# Sequência obrigatória:
npx tsc --noEmit        # 1. Types OK?
npm run lint            # 2. Lint OK?
npm run build           # 3. Build OK?
# Se qualquer um falhar → corrigir antes de commitar
```

#### D. Commit Atômico (1 min)
```bash
git add <arquivos específicos>  # NUNCA git add .
git commit -m "tipo(escopo): descrição

Refs: PLAN-[nome] Passo X"
```

**Convenção de Commits:**
| Tipo | Quando usar | Exemplo |
|:---|:---|:---|
| `feat` | Nova funcionalidade | `feat(credits): adiciona tabela de créditos` |
| `fix` | Correção de bug | `fix(auth): corrige redirect pós-login` |
| `refactor` | Refatoração | `refactor(db): extrai schema de tenants` |
| `chore` | Config/dependências | `chore(deps): atualiza drizzle-kit` |
| `docs` | Documentação | `docs(api): adiciona README de endpoints` |
| `test` | Testes | `test(credits): adiciona testes de consumo` |

#### E. Atualizar RUN (30 seg)
- [ ] Marcar `[x]` no passo no `docs/RUN-[nome].md`
- [ ] Anotar hash do commit
- [ ] Registrar tempo gasto
- [ ] Notas sobre problemas encontrados

### Passo 3: Tratamento de Erros (Fallback)

**Se falhar (erro de build/lint/execução):**

1. **NÃO AVANCE** para próximo passo
2. **Leia o erro** (stack trace completo)
3. **Tente corrigir** (máximo 3 tentativas):
   - Tentativa 1: Sintaxe/typo óbvio
   - Tentativa 2: Verificar docs/oficial
   - Tentativa 3: Buscar padrões no código existente
4. **Se falhar 3x**:
   ```bash
   git reset --hard HEAD  # Volta ao último commit válido
   ```
   - Registrar no `docs/RUN-[nome].md`: erro, tentativas, causa
   - Invocar `04_solucionando_erros` ou notificar usuário

### Passo 4: Finalização

- [ ] Todos os passos concluídos
- [ ] Validação final completa (todos os comandos)
- [ ] `docs/RUN-[nome].md` atualizado com resumo
- [ ] Notificar usuário com evidências (screenshots/URLs)

## 📄 Template RUN (Log de Execução)

**Arquivo:** `docs/RUN-[nome].md`

```markdown
# RUN: [Nome da Feature]
**Plano:** `docs/PLAN-[nome].md`  
**Início:** YYYY-MM-DD HH:MM  
**Status:** 🟡 Em Execução

## Progresso

| # | Passo | Status | Commit | Notas |
|:---|:---|:---|:---|:---|
| 1 | [Descrição] | [x] ✅ | `a1b2c3d` | - |
| 2 | [Descrição] | [ ] ⏳ | - | - |
| 3 | [Descrição] | [ ] ⏳ | - | - |

## Diário de Erros

### [HH:MM] Passo 2: [Título]
- **Erro:** [Descrição]
- **Causa:** [Root cause]
- **Solução:** [Como resolveu]
- **Commit:** `hash`

## Resumo Final
**Status:** [🟢 Concluído / 🔴 Bloqueado]  
**Tempo Total:** [X min]  
**Deploy:** [URL]  
**Lições:** [O que melhorar]
```

## 🚫 Anti-Padrões

- ❌ Código sem PLAN aprovado
- ❌ Commit com erro de build/lint
- ❌ `git add .` (sempre especificar arquivos)
- ❌ Múltiplos passos em um commit
- ❌ Avançar com erro não resolvido
- ❌ Ignorar TypeScript strict
- ❌ Não atualizar RUN.md

## ✅ Checklist de Qualidade

- [ ] PLAN existe e é válido
- [ ] RUN.md criado antes de começar
- [ ] Cada passo: implementa → valida → commita
- [ ] Commits seguem convenção
- [ ] Máximo 3 tentativas por erro
- [ ] Rollback se falha persistente
- [ ] Diário de erros atualizado
- [ ] Build final passando

## 🔗 Integração

- **Chamada:** Direta pelo ROUTER (se PLAN existe)
- **Pré-requisito:** `02_planejando_solucoes` (PLAN aprovado)
- **Próxima (sucesso):** `05_verificando_conclusao`
- **Próxima (falha):** `04_solucionando_erros`
- **Artefatos:** `docs/RUN-[nome].md`, commits git

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Stack Omega fixa (removida configuração)
- Adicionada convenção de commits (Conventional Commits)
- Simplificada integração (ROUTER direto)
- Scripts movidos para RECURSOS/
- Adicionada cadeia de validação obrigatória (tsc → lint → build)

### v2.0.0 (Original)
- Build Loop conceitual
- Commits atômicos
- Diário de erros
- Rollback automático
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
