#!/bin/bash
# [07] MODE TRANSITION — Transição automática GEM ↔ IDX
# Uso: bash .antigravity-os/[08] SUBMODULE_HOOKS/[07] mode-transition.sh --to [gem|idx] [--dry-run]
set -e

TARGET="${2:-}"
DRY_RUN=false
if [ "$3" == "--dry-run" ]; then DRY_RUN=true; fi

if [[ "$TARGET" != "gem" && "$TARGET" != "idx" ]]; then
  echo "❌ Uso: $0 --to [gem|idx] [--dry-run]"
  exit 1
fi

CURRENT_AGENT="context/CURRENT_AGENT.md"
SESSIONS_DIR=".antigravity-os/.cache/sessions"
mkdir -p "$SESSIONS_DIR"

# 1. Backup do estado atual
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
cp "$CURRENT_AGENT" "${SESSIONS_DIR}/state_backup_${TIMESTAMP}.md"

# 2. Determinar novo estado
if [ "$TARGET" == "gem" ]; then
  NEW_MODE="GEM"
  NEW_AGENT="BETA"
  LOADED_SKILLS='["01_brainstorming", "02_planejando_solucoes", "08_explorando_mercados"]'
  RULES_FILE=".antigravity-os/[01] CONFIGS/gem-mode-instructions.md"
  CLEANUP_CONTEXT=true
else
  NEW_MODE="IDX"
  NEW_AGENT="GAMMA"
  LOADED_SKILLS='["03_executando_planos", "06_codando", "05_verificando_conclusao"]'
  RULES_FILE=".antigravity-os/[01] CONFIGS/idx-global-instructions.md"
  CLEANUP_CONTEXT=true
fi

# 3. Atualizar CURRENT_AGENT.md (apenas frontmatter YAML)
if [ "$DRY_RUN" == false ]; then
  sed -i "s/^mode: .*/mode: $NEW_MODE/" "$CURRENT_AGENT"
  sed -i "s/^active_agent: .*/active_agent: $NEW_AGENT/" "$CURRENT_AGENT"
  sed -i "s|^loaded_skills: .*|loaded_skills: $LOADED_SKILLS|" "$CURRENT_AGENT"
  sed -i "s/^next_action: .*/next_action: \"Carregar regras de $NEW_MODE e aguardar input\"/" "$CURRENT_AGENT"
fi

# 4. Limpeza de contexto (opcional mas recomendada)
if [ "$CLEANUP_CONTEXT" == true ] && [ "$DRY_RUN" == false ]; then
  echo "🧹 Limpando contexto anterior..."
  # Salva estado de sprint em cache
  echo "# Estado da sessão $TIMESTAMP
modo_anterior: $(grep '^mode:' "$CURRENT_AGENT" | cut -d' ' -f2)
agente_anterior: $(grep '^active_agent:' "$CURRENT_AGENT" | cut -d' ' -f2)
timestamp: $(date -Iseconds)
" > "${SESSIONS_DIR}/transition_log_${TIMESTAMP}.md"
fi

# 5. Output
echo ""
echo "✅ Transição preparada:"
echo "   🎯 Modo alvo: $NEW_MODE"
echo "   🤖 Agente ativo: $NEW_AGENT"
echo "   📚 Skills carregadas: $LOADED_SKILLS"
echo "   📜 Regras: $RULES_FILE"
echo "   💾 Backup: ${SESSIONS_DIR}/state_backup_${TIMESTAMP}.md"
echo ""
echo "🔔 PRÓXIMO PASSO (IA):"
echo "   1. Leia $RULES_FILE"
echo "   2. Execute /clear para limpar contexto"
echo "   3. Anuncie: '🔄 Modo alterado para $NEW_MODE. Pronto para $([ "$NEW_MODE" == "GEM" ] && echo "planejamento" || echo "execução").'"
