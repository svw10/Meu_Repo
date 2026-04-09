---
name: project-retrospective-sweeper
description: Varredor pós-projeto. Extrai lições, atualiza memória/templates/regras com aprovação humana.
version: 1.0.0
trigger: "/retro"
author: Antigravity Meta-Framework
tags: [learning, retrospective, evolution, safe-update]
---

# 🧹 PROJECT RETROSPECTIVE SWEEPER

## 🎯 Missão
Transformar dados do projeto concluído em atualizações seguras do framework. **Nenhuma alteração é aplicada sem aprovação explícita.**

## 🚨 Gatilho
- **Manual:** `/retro` no chat da IDE.
- **Sugestão Automática:** `DELTA` sugere `/retro` após aprovação final de deploy, mas **não executa**.

## ⚙️ Protocolo – 5 Fases

### Fase 0: Coleta Estruturada (Zero Texto Bruto)
A IA deve solicitar a execução do script `[08] SUBMODULE_HOOKS/[05] retro-collector.sh` e ler APENAS o JSON compacto gerado.
**Campos obrigatórios no JSON:**
- `errors_resolved[]`, `env_vars_detected[]`, `code_patterns[]`, `token_usage_by_sprint[]`, `template_used`

### Fase 1: Triagem de Lições (IA → Humano)
Para cada categoria, a IA gera **apenas 1 pergunta múltipla escolha**. Máximo de 5 perguntas por sessão.

| Categoria | Pergunta Padrão | Opções |
|-----------|----------------|--------|
| Erros Críticos | *"Salvar prevenção para `{mutation}` em `[04] MEMORY_DNA/`?"* | `a) Global (todos projetos) | b) Stack-specific | c) Ignorar` |
| Configurações | *"Atualizar `[11] TEMPLATES/` com novas envs detectadas?"* | `a) Sim (placeholders) | b) Apenas doc | c) Não` |
| Padrões de Código | *"Promover padrão `{name}` para Skill reutilizável?"* | `a) Criar `[03] SKILLS_ENGINE/` snippet | b) Manter local | c) Não` |
| Otimização | *"Ajustar budget/modelo em `[00] KERNEL/token-budget-controller.json`?"* | `a) Aplicar ajuste | b) Documentar | c) Manter` |

### Fase 2: Análise Causal Rápida
Se `a)` for selecionado, a IA extrai causa raiz em `<50 tokens`:
`"Sintoma → Causa Imediata → Causa Raiz → Vacina Proposta"`

### Fase 3: Dry-Run & Patch Generation
A IA **NUNCA** escreve diretamente. Gera um `proposed-changes.json`:
```json
{
  "patches": [
    {"file": ".antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json", "action": "append", "data": {...}},
    {"file": ".antigravity-os/[11] TEMPLATES/stack-lessons.md", "action": "update", "section": "neon_pooling"}
  ],
  "version_bump": "patch",
  "requires_approval": true
}
```
**Pergunta Final:** *"Aplicar X patches e incrementar versão para Y? (sim/não/ver diffs)"*

### Fase 4: Aplicação Segura
Após `sim`:
1. Backup automático: `cp <file> <file>.bak`
2. Aplicação via script `[05] retro-applier.sh` (valida JSON + aplica)
3. Geração de `[99] INDEX.md` evolution entry
4. Commit automático: `feat(retro): apply lessons from project X – v{new}`

### Fase 5: Relatório de Evolução
Atualiza `.antigravity-os/evolution-log.md`:
```markdown
## v{version} ({date})
- ✅ `{mutation}` → prevenção global injetada
- 📦 Template `nextjs-omega` atualizado com `RESEND_API_KEY`
- 📊 Tokens/session reduzidos em 18% (ajuste tier-matrix)
---
```

## 🚫 Regras de Segurança Absolutas
- ❌ NUNCA modificar `[00] KERNEL/` ou `[02] SQUAD_WRAPPERS/` sem validação de schema Zod.
- ❌ NUNCA pular `DRY_RUN` ou aprovação humana.
- ❌ NUNCA salvar lições sem causa raiz documentada.
- ✅ SEMPRE criar backup `.bak` antes de escrita.
- ✅ SEMPRE validar JSON patch antes de aplicar.

## 🔗 Integração
- Lê: `[04] MEMORY_DNA/`, `[05] TOKENOMICS/`, git log, `package.json`
- Atualiza: `[03] SKILLS_ENGINE/`, `[11] TEMPLATES/`, `[00] KERNEL/token-budget*`, `evolution-log.md`
- Versionamento: Semântico (`patch`=lições, `minor`=novas skills/templates, `major`=mudança estrutural → requer PR)
