---
name: semantic-router | wrapper para context/ROUTER.md
---
# Fluxo de Roteamento Otimizado

1. Detecta modo via [00] KERNEL/quantum-loader.md
2. Lê context/ROUTER.md (seu arquivo)
3. Consulta budget em [00] KERNEL/token-budget-controller.json
4. Se budget OK → carrega agente de Agentes/[NOME]_Prime.md
5. Se budget NOK → sugere alternativa (ex: ZETA ao invés de GAMMA)
6. Atualiza context/CURRENT_AGENT.md

## Regra de Ouro
Nunca carregar agente sem validar budget primeiro.