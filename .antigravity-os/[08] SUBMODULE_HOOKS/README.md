# 📦 [08] SUBMODULE_HOOKS — Automação & Ciclo de Vida

> **Propósito:** Utilitários de baixo nível para gerenciar instalação, atualização, validação e aprendizado do Antigravity OS. 
> **Execução:** Terminal (bash) ou chamados pelo agente THETA (`/setup`, `/retro`).

---

## 📜 Catálogo de Scripts

| Script | Função | Quando Usar | Impacto |
|:---|:---|:---|:---|
| `[00] init-submodule.sh` | Integra o framework em projeto novo | Setup inicial | ✅ Cria/Configura |
| `[01] update-core.sh` | Puxa última versão do repositório central | Após mudanças no framework pai | ✅ Atualiza `.antigravity-os/` |
| `[02] validate-structure.sh` | Verifica integridade de pastas/arquivos | Diagnóstico de saúde | 🔒 Read-Only |
| `[03] sync-memory.sh` | Sincroniza `MEMORY_DNA` (vacinas/erros) | Aprendizado cross-project | ✅ Atualiza `error-dna-registry.json` |
| `[04] generate-evolution-log.sh` | Versionamento automático + changelog | Fechamento de release/módulo | ✅ Commit/Tag automático |
| `[05] retro-collector.sh` | Extrai dados compactados para `/retro` | Preparação de análise pós-projeto | 🔒 Gera JSON cache |

---

## ⚙️ Pré-requisitos
- `bash` (Git Bash, macOS, Linux/WSL)
- `jq` (obrigatório para `sync-memory.sh` e `retro-collector.sh`)
- `git` (configurado e autenticado)

**Verificar dependências:**
```bash
bash --version && jq --version && git --version
```

---

## 🚀 Modo de Uso

Execute sempre na **raiz do projeto**:
```bash
bash .antigravity-os/[08] SUBMODULE_HOOKS/[XX] nome-do-script.sh
```

Exemplos práticos:
```bash
# Validar estrutura (seguro, sem alterações)
bash .antigravity-os/[08] SUBMODULE_HOOKS/[02] validate-structure.sh

# Sincronizar aprendizados (pós-projeto)
bash .antigravity-os/[08] SUBMODULE_HOOKS/[03] sync-memory.sh

# Coletar dados para retro
bash .antigravity-os/[08] SUBMODULE_HOOKS/[05] retro-collector.sh
```

---

## ⚠️ Regras de Segurança & Boas Práticas

1. **Não rode durante sprints ativas.** Use apenas para setup, manutenção ou fechamento de ciclo.
2. **Backup implícito:** Scripts que escrevem (`update-core.sh`, `sync-memory.sh`) validam estado antes de agir. Mesmo assim, mantenha o projeto commitado antes de executar.
3. **Sanitização ativa:** `sync-memory.sh` remove automaticamente `context_snapshot`, paths locais e PII antes de compartilhar aprendizados.
4. **Permissões:** Se der erro de execução, rode: `chmod +x .antigravity-os/[08] SUBMODULE_HOOKS/*.sh`

---

## 🔗 Integração com o Framework

- **THETA** chama esses hooks automaticamente via slash commands (`/retro`, `/setup`, `/validate`).
- **Outputs** são gravados em `.antigravity-os/.cache/` ou `Logs/` para telemetria.
- **Versionamento** segue semântica do `INDEX.md` (patch/minor/major).
- **Imutabilidade:** Durante desenvolvimento IDX, esta pasta é **READ-ONLY**. Alterações só via PR no repositório central.

> 🛡️ **Lembrete:** Se um script falhar, consulte `Logs/hooks-errors.log` ou execute `[02] validate-structure.sh` para diagnosticar.
