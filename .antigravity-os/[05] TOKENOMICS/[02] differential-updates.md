# [02] DIFFERENTIAL UPDATES — Atualizações Incrementais

## Propósito
Eliminar o desperdício de tokens enviando arquivos inteiros. Transmita e aplique apenas as alterações reais (diffs) durante o desenvolvimento.

## Protocolo de Edição
1. **Identificação:** Localize APENAS os blocos de código que precisam mudar.
2. **Formatação:** Use sintaxe `SEARCH/REPLACE` ou `diff` unificado.
   ```diff
   // ... existing code ...
   - linha_antiga_ou_função_depreciada();
   + nova_linha_ou_função_otimizada();
   // ... existing code ...
   ```
