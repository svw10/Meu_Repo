# [01] SEMANTIC ROUTER

## Propósito
Coordenar o fluxo entre o Kernel, os Wrappers e os agentes reais em `Agentes/`. Centraliza a lógica de decisão sem depender de arquivos de estado ou roteamento intermediário.

## Fluxo de Roteamento Obrigatório
1. **Detectar Modo**: Leia `.antigravity-os/[00] KERNEL/[00] quantum-loader.md` (GEM ou IDX).
2. **Analisar Intenção**: Mapeie a intenção da tarefa aos metadados em `.antigravity-os/[02] SQUAD_WRAPPERS/*-meta.json`.
3. **Validar Budget**: Antes de ativar qualquer agente, verifique `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.
4. **Carregar Agente**: Se o budget permitir, carregue o arquivo real correspondente via `source_file` definido no wrapper escolhido (ex: `Agentes/THETA_Orchestrator.md`).
5. **Carregar Skill**: Se necessário, importe a skill específica via `.antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json`.

## Aviso Crítico
- Nunca pule a etapa 3 (Validar Budget).
- O roteamento agora é **direto via wrappers**. A pasta `context/` não é mais usada para decisão.
- Se a intenção for ambígua, priorize THETA para reclassificação antes de executar.