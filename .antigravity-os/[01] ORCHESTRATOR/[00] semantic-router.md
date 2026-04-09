# [01] SEMANTIC ROUTER

## Integração com Estrutura Existente
Este arquivo coordena o fluxo entre o Kernel e seus agentes existentes em `Agentes/` e `context/`.

## Fluxo de Roteamento Obrigatório
1. **Detectar Modo**: Leia `.antigravity-os/[00] KERNEL/[00] quantum-loader.md` (GEM ou IDX).
2. **Consultar Rota**: Leia o arquivo `context/ROUTER.md` para identificar qual agente deve atuar agora.
3. **Validar Budget**: Antes de ativar qualquer agente, verifique `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.
4. **Selecionar Agente**: Se o budget permitir, carregue o agente correspondente da pasta `Agentes/`.
5. **Carregar Skill**: Se necessário, importe a skill específica via `.antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json`.

## Aviso Crítico
Nunca pule a etapa 3 (Validar Budget). Se o budget estiver baixo, avise o usuário antes de carregar o agente.