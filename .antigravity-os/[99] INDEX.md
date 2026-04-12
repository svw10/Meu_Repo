# 🧬 ANTAGRAVITY OS NEURAL — ÍNDICE MESTRE v3.1

> **Propósito:** Mapa de navegação para IA e humanos. Leia isto primeiro para entender a ordem de execução, modo atual e próximos passos.

---

## 🚦 Modo Atual: [DETECTAR AUTOMATICAMENTE]

| Modo | Ambiente | Permitido | Proibido | Próximo Passo |
|------|----------|-----------|----------|---------------|
| **GEM** (Planejamento) | Google AI Studio, Chat | PRD, SPEC, Arquitetura, Brainstorm | Escrever código, commitar, executar | Leia `[00] KERNEL/` → `[07] SPECS_WARP/` |
| **IDX** (Execução) | VSCode, Cursor, Terminal | Codar, testar, debugar, commitar | Gerar PRD, mudar arquitetura sem aprovação | Leia `[00] KERNEL/` → `[02] AGENTS/` |

> 🔍 **Detecção Automática:** Consulte `[00] KERNEL/[00] quantum-loader.md` para regras de detecção.

---

## 🗺️ Mapa de Execução Enumerado (Ordem Obrigatória)

```
[00] KERNEL/          ← SEMPRE carregado primeiro
  ├── [00] quantum-loader.md      # Detecta modo GEM/IDX + fallback seguro
  ├── [01] mode-router.json       # Regras de transição entre modos
  ├── [02] token-budget-controller.json # Limites de tokens por tarefa
  ├── [03] mode-transition-protocol.md  # Protocolo de transição entre modos
  └── [04] anxiety-detector.md    # ⭐ Detecção de degradação comportamental do modelo

[01] ORCHESTRATOR/    ← Rágio de roteamento, escalação e autocorreção
  ├── [00] semantic-router.md      # Roteamento com validação de budget
  ├── [01] feedback-loop-protocol.md # ⭐ Loop autocorreção DELTA→GAMMA/ETA + escalação
  ├── [02] activation-cards.md     # ⭐ Feed Forward: briefing rápido por agente (8 cards)
  └── [03] handoff-artifacts-protocol.md # ⭐ Artefatos imútáveis de passagem de bastão

[02] AGENTS/          ← Metadados dos 8 agentes
  ├── [00] orchestration-exec.md  # Lógica de roteamento executável
  ├── [01] registry.json          # Catálogo de agentes
  └── [00-07] *-meta.json         # Wrappers: custo, trigger, fallback

[03] SKILLS_ENGINE/   ← Indexador de Minhas_Skills/
  ├── [00] skills-constellation.json # Mapeamento de 12 skills
  ├── [01] retrieval-decision-matrix.json # RAG vs Grep vs Lexical
  └── [02] lazy-loader.md         # Protocolo de import sob demanda

[04] MEMORY_DNA/      ← Aprendizado cross-project
  ├── [00] error-dna-registry.json # Erros + vacinas + prevention prompts
  ├── [01] anti-patterns-vault.md # Banco de "Nunca Repita"
  ├── [02] prevention-injector.md # Como injetar imunidade no contexto
  ├── [03] cross-project-sync.md  # Sync seguro via HTTPS + sanitização
  ├── [04] memory-summarizer.md   # Sumarização de histórico de longo prazo
  ├── [05] correction-state-schema.json # ⭐ Schema do estado do Feedback Loop
  ├── [06] task-evidence-schema.json # ⭐ Test Anti-Cheat: evidências obrigatórias por task
  └── [07] handoff-artifact-schema.json # ⭐ Schema de validação dos Handoff Artifacts

[05] TOKENOMICS/      ← Economia avançada de tokens
  ├── [00] tier-strategy.md       # Senior Mode, Differential Updates, Pruning
  ├── [01] symbolic-refs.md       # Uso de @file, @schema, @skill
  ├── [02] differential-updates.md # Protocolo SEARCH/REPLACE
  └── [03] cost-telemetry.json    # Telemetria em tempo real

[06] SECURITY_DRL/    ← Segurança e compliance
  ├── [00] pii-sanitization.md    # Detecção e masking de dados sensíveis
  ├── [01] secrets-vault.json     # Protocolo zero-exposure para .env
  ├── [02] frontend-inspector.md  # Auditoria de código client-side
  └── [03] submodule-guard.md     # Proteção do núcleo contra edições locais

[07] SPECS_WARP/      ← Especificação de produtos
  ├── [00] prd-business-template.md # Template focado em negócio (sem código)
  ├── [01] spec-technical-schema.ts # Validação Zod para SPEC técnica
  ├── [02] sprint-isolation.md    # 1 sprint = 1 contexto limpo
  └── [03] checkpoints-gates.md   # Portões de qualidade obrigatórios

[08] SUBMODULE_HOOKS/ ← Automação e Git
  ├── [00] init-submodule.sh
  ├── [01] update-core.sh
  ├── [02] validate-structure.sh
  ├── [03] sync-memory.sh
  ├── [04] generate-evolution-log.sh
  └── [05] retro-collector.sh

[09] RETROSPECTIVE/   ← Aprendizado Contínuo
  ├── [00] project-sweeper.md  # Workflow /retro
  └── evolution-log.md         # Histórico de versões

[11] HANDOFF_ARTIFACTS/ ← Artefatos imutáveis de passagem de bastão
  ├── README.md                # Índice: ativos e consumidos por sprint
  └── [timestamp]-[from]-to-[to].yaml  # Gerado por THETA a cada handoff
```

---

## 🧭 Fluxo Rápido por Cenário

### 🆕 Novo Projeto
```bash
1. bash .antigravity-os/[08] SUBMODULE_HOOKS/[00] init-submodule.sh
2. Configure .cursorrules na raiz (apontando para [00] KERNEL/)
3. Leia este INDEX.md → [00] KERNEL/[00] quantum-loader.md
4. Inicie com BETA (Architect) para gerar PRD
```

### 💻 Desenvolvimento Diário (IDX)
```
1. IA lê: .cursorrules → [00] KERNEL/ → [01] ORCHESTRATOR/
2. THETA classifica tarefa → valida budget → seleciona agente
3. GAMMA executa com budget definido → DELTA valida → commit
4. Erro? Registra em [04] MEMORY_DNA/ → gera prevention_prompt
```

### 🧠 Planejamento Estratégico (GEM)
```
1. IA lê: [00] KERNEL/ (modo GEM) → [07] SPECS_WARP/[00] prd-business-template.md
2. BETA gera PRD → valida com gates → aprova para SPEC
3. THETA converte PRD → SPEC técnica com Zod validation
4. Exporta para IDX com plano de sprints atômicas
```

### 🔍 Debug/Investigação
```
1. Consulta [04] MEMORY_DNA/[00] error-dna-registry.json por match
2. Se encontrado: injeta prevention_prompt + aplica vaccine
3. Se novo: ETA investiga → registra erro → gera nova vacina
4. Atualiza [05] TOKENOMICS/[03] cost-telemetry.json com métricas
```

---

## 📚 Integração com Estrutura Existente

| Pasta Antigravity | Aponta Para (Projeto Pai) | Função |
|------------------|---------------------------|--------|
| `[02] AGENTS/` | `Agentes/` | Metadados de custo, trigger e fallback |
| `[03] SKILLS_ENGINE/` | `Minhas_Skills/` | Índice lazy-load com decisão RAG/Grep |
| `[01] ORCHESTRATOR/` | `context/ROUTER.md` | Wrapper com validação de budget |
| `[07] SPECS_WARP/` | `Nucleo/03_Competencias/` | Templates com gates de aprovação |
| `[04] MEMORY_DNA/` | `Logs/` | Registro de erros com prevenção ativa |

> ⚠️ **Regra de Ouro:** Nunca edite `.antigravity-os/` diretamente. Use `[08] SUBMODULE_HOOKS/` para atualizações.

---

## ⚡ Comandos Rápidos para IA

```
/clear          → Limpa contexto entre sprints (obrigatório)
/compact        → Resume contexto aos 60% de uso
/context        → Mostra estado atual + budget restante
/cost           → Exibe telemetria da sessão atual
/sync-memory    → Força atualização de MEMORY_DNA cross-project
/plan           → Ativa modo BETA para planejamento
/build          → Ativa modo GAMMA para execução
/audit          → Aciona DELTA para revisão pré-commit
/retro          → Dispara o Project Sweeper (aprendizado pós-projeto)
```

---

## 🆘 Solução de Problemas

| Sintoma | Causa Provável | Solução |
|---------|---------------|---------|
| IA ignora budget | `[00] KERNEL/[02]` não carregado | Force leitura: "Leia token-budget-controller.json" |
| Agente não ativa | Wrapper em `[02] SQUAD_WRAPPERS/` com path errado | Valide `source_file` vs pasta real |
| Erro de caminho | `Minhas Skills` vs `Minhas_Skills` | Use sempre underscore: `Minhas_Skills/` |
| Contexto poluído | Sprint sem `/clear` anterior | Execute `/clear` + recarregue apenas sprint atual |
| Secret vazado | `[06] SECURITY_DRL/` não aplicado | Ative pre-commit hook + sanitize antes de enviar |

---

## 🔄 Atualização do Framework

```bash
# Verificar versão atual
cat .antigravity-os/[99] INDEX.md | grep "v"

# Atualizar para última versão
bash .antigravity-os/[08] SUBMODULE_HOOKS/[01] update-core.sh

# Validar integridade pós-update
bash .antigravity-os/[08] SUBMODULE_HOOKS/[02] validate-structure.sh
```

---

> ✨ **Dica Final:** Se em dúvida sobre qual arquivo ler, volte a este INDEX.md. Ele é o ponto de entrada único para toda a inteligência do Antigravity OS Neural.

**Versão:** 3.1.0  
**Última Atualização:** $(date)  
**Repositório Central:** https://github.com/svw10/Meu_Repo