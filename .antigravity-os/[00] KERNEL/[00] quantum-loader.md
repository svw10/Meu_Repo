---
name: quantum-loader | version: 3.1.0
---
# Detecção Automática de Modo

## GEM (Google AI Studio) → Modo BETA
- Permitido: planejamento, PRD, especificações
- Proibido: escrever arquivos, executar código
- Saída: PLAN.md para exportação

## IDX (VSCode/Cursor) → Modo GAMMA  
- Permitido: codar, testar, commitar
- Proibido: gerar PLAN.md (deve ler existente)
- Entrada: PLAN.md do GEM

## Fallback Seguro
Se detecção falhar → assume IDX + alerta usuário.

## Token Budget Inicial
GEM: 4000 tokens | IDX: 8000 tokens