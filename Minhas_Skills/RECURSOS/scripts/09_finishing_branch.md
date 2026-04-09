---
name: finishing_branch
description: Workflow de finalização, merge e limpeza. Garante que código chegue à main sem dívidas técnicas.
version: 3.1.0
framework: "Antigravity OS v3.1"
owner_agent: THETA
trigger: "/merge"
integration: "Antigravity Neural Router"
status: active
tags: [git, merge, pr, workflow, cleanup, theta]
---

# 09 - FINISHING BRANCH (Merge & Cleanup Protocol)

## 🎯 Quando usar
- **Feature completa:** Após `05_verificando_conclusao` aprovar a entrega.
- **Hotfix pronto:** Correção crítica validada e pronta para produção.
- **Refatoração:** Código limpo pelo ZETA, pronto para integrar.

> **Regra de Ouro**: O merge é o momento mais crítico. Se falhar aqui, toda a sprint foi em vão. **Nunca force merge sem validação.**

## 🧱 Estratégia de Merge (Stack Omega)

| Tipo de Branch | Estratégia | Quando Usar |
|:---|:---|:---|
| `feature/` | **Squash Merge** | Agrupa commits atômicos em 1 commit limpo |
| `hotfix/` | **Rebase Merge** | Mantém histórico linear e rastreabilidade |
| `release/` | **Merge Commit** | Marca explicitamente o ponto de release |

**Padrão do Antigravity:** Prefira `Squash Merge` para manter o `main` limpo e legível.

## ⚙️ Protocolo de Finalização (3 Fases)

### Fase 1: Validação Pré-Merge (Opcional mas Recomendado)
Antes de solicitar o merge, execute o **Checklist Delta**:
- [ ] `npm run lint` passou sem erros.
- [ ] `npm run build` completou com sucesso.
- [ ] Testes unitários passaram (`npm run test`).
- [ ] Nenhuma variável de ambiente exposta.
- [ ] Código está formatado (`biome format --write`).

### Fase 2: Execução do Merge
Use o **Terminal Integrado** para garantir controle total (evite interfaces visuais se houver conflito complexo).

**Fluxo Seguro (Rebase + Merge):**
```bash
# 1. Atualize a branch alvo (ex: main ou develop)
git checkout main
git pull origin main

# 2. Volte para sua branch
git checkout feature/nome-da-feature

# 3. Rebase para incorporar mudanças recentes (opcional, mas limpo)
git rebase main
# Se houver conflitos, resolva um a um, adicione e continue:
# git add <arquivos_resolvidos>
# git rebase --continue

# 4. Merge de volta (Squash)
git checkout main
git merge --squash feature/nome-da-feature
git commit -m "feat: nome-da-feature (squashed)"

# 5. Push
git push origin main
```

**Fluxo Rápido (Pull Request via CLI):**
Se usar GitHub CLI:
```bash
gh pr create --title "feat: nome-da-feature" --body "Descrição detalhada"
gh pr merge --squash --delete-branch
```

### Fase 3: Limpeza e Sincronização
Após o merge:
1. **Remova a branch local:** `git branch -d feature/nome-da-feature`
2. **Remova a branch remota:** `git push origin --delete feature/nome-da-feature` (se não for feito pelo PR)
3. **Atualize tags:** `git fetch --tags`

## 🤖 Integração com Agentes

| Agente | Papel |
|--------|-------|
| **GAMMA** | Prepara o código e verifica o Checklist Pré-Merge. |
| **DELTA** | Aprova a qualidade antes de permitir o merge. |
| **THETA** | Executa o merge, gerencia conflitos e limpa o contexto. |
| **ETA** | Investiga falhas de CI/CD se o merge automático falhar. |

**Orquestração THETA:**
1. Recebe sinal de "Feature Concluída".
2. Chama DELTA para validação final.
3. Se OK → Executa merge.
4. Se NOK → Devolve para GAMMA/ETA.
5. Após merge → Atualiza `CURRENT_AGENT.md` e limpa contexto (`/clear`).

## 🛡️ Regras de Segurança (Anti-Catástrofe)

### ✅ Permitido
- [ ] Squash merge para features pequenas e médias.
- [ ] Merge commit para releases versionadas.
- [ ] Resolução manual de conflitos em branches protegidas.

### ❌ Proibido
- [ ] `git push --force` na branch `main` ou `develop`.
- [ ] Merge com testes falhando.
- [ ] Deixar branchs órfãs (sem dono) por mais de 7 dias.
- [ ] Commitar arquivos de build (`.next/`, `dist/`) no merge.

## 📋 Template de Mensagem de Commit (Merge)

Ao finalizar um merge, a mensagem deve seguir o padrão **Conventional Commits**:

```
tipo(escopo): descrição curta

- Resumo das mudanças
- Link para task/issue
- Notas de breaking change (se houver)

Refs: #123, #456
```

Exemplo:
```
feat(auth): implementa login com Clerk e refresh token

- Adiciona middleware de proteção de rotas
- Configura sync de usuário com banco Neon
- Implementa logout seguro

Refs: TASK-42
```

## 🔗 Integração com Sistema v3.1

**Roteamento:** Invocada via `/merge` ou sugerida automaticamente após `05_verificando_conclusao`.

**Memória:** Se o merge falhar repetidamente, registrar padrão em `.antigravity-os/[04] MEMORY_DNA/`.

**Budget:** Merge não consome budget de desenvolvimento, apenas validação.

**Handoff:** Após merge com sucesso, THETA executa `/clear` e aguarda nova tarefa.

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Esta skill é invocada via `.antigravity-os/[02] SQUAD_WRAPPERS/` ou Slash Commands.

**Memória:** Erros encontrados devem ser logados em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.

**Budget:** Respeite os limites de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.

**Handoff:** Após execução, atualize `context/CURRENT_AGENT.md` e retorne ao THETA.

**Stack Omega:** Siga rigorosamente `Minhas_Rules/STACK_OMEGA_RULES.md`.
