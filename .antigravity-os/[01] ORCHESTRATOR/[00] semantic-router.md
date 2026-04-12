# [01] SEMANTIC ROUTER

> **Integra com:** `[01] feedback-loop-protocol.md` — quando DELTA emite REJECTED, o roteamento deve acionar o loop de autocorreção antes de qualquer outra ação.

## Propósito
Coordenar o fluxo entre o Kernel, os Wrappers e os agentes reais em `Agentes/`. Centraliza a lógica de decisão sem depender de arquivos de estado ou roteamento intermediário.

## Fluxo de Roteamento Obrigatório
1. **Detectar Modo**: Leia `.antigravity-os/[00] KERNEL/[00] quantum-loader.md` (GEM ou IDX).
2. **Analisar Intenção**: Mapeie a intenção da tarefa aos metadados em `.antigravity-os/[02] SQUAD_WRAPPERS/*-meta.json`.
3. **Ler Activation Card**: Carregue o card do agente identificado em `[01] ORCHESTRATOR/[02] activation-cards.md` (Feed Forward — ≤15 linhas, baixo custo de tokens).
4. **Validar Budget**: Antes de ativar qualquer agente, verifique `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.
5. **Carregar Agente**: Se o budget permitir, carregue o arquivo real correspondente via `source_file` definido no wrapper escolhido (ex: `Agentes/THETA_Orchestrator.md`).
6. **Carregar Skill**: Se necessário, importe a skill específica via `.antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json`.

## Aviso Crítico
- Nunca pule a etapa 3 (Validar Budget).
- O roteamento agora é **direto via wrappers**. A pasta `context/` não é mais usada para decisão.
- Se a intenção for ambígua, priorize THETA para reclassificação antes de executar.

## Passo 6 — Tratamento de Reprovação (NOVO)
6. **Verificar Feedback Loop:** Após qualquer execução, se `context/CURRENT_AGENT.md` tiver `agent_status: rejected`:
   - Leia `[01] feedback-loop-protocol.md` imediatamente
   - Consulte `[04] MEMORY_DNA/[05] correction-state-schema.json` para validar o estado
   - Incremente `correction_loop.attempt_count` antes de redirecionar
   - Se `attempt_count >= max_attempts` → ESCALAÇÃO (não rotear — notificar humano)