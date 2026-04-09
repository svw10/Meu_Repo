# [00] QUANTUM LOADER — Detecção de Modo

## Propósito
Identificar se o ambiente atual é de **Planejamento (GEM)** ou **Execução (IDX)** para aplicar as regras corretas de segurança e token budget.

##  MODO GEM (Google AI Studio / Planejamento)
- **Foco:** Arquitetura, PRD, Brainstorming, Estruturação.
- **Regra de Ouro:** NÃO escreva código no repositório. NÃO execute comandos.
- **Ação:** Gere planos (Markdown), esquemas e instruções claras para o Modo IDX.
- **Skills:** Use `Minhas_Skills/ESTRATEGIA_DISCOVERY/`.

## 🔵 MODO IDX (VSCode / Cursor / Execução)
- **Foco:** Codar, Debugar, Testar, Commitar.
- **Regra de Ouro:** Siga rigorosamente o plano definido no Modo GEM. Não invente features novas sem aprovação.
- **Ação:** Edite arquivos, rode testes, valide segurança.
- **Skills:** Use `Minhas_Skills/EXECUCAO_IMPLEMENTACAO/`.

## 🔍 Como Detectar
1. Se houver pastas como `app/`, `pages/`, `src/` com código implementado → **MODO IDX**.
2. Se o usuário pedir "planejar", "criar PRD", "brainstorm" → **MODO GEM**.
3. Na dúvida → **MODO IDX** (mas valide o budget primeiro).