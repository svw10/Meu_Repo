# [01] ANTI-PATTERNS VAULT — Banco de "Nunca Repita"

## Propósito
Centralizar práticas proibidas, falhas de arquitetura e decisões técnicas reprovadas para evitar reincidência no desenvolvimento.

## Integração
- Baseado em: `Minhas_Rules/` e `Nucleo/`
- Atualizado por: DELTA (Auditor) e ETA (Investigator)

## Formato de Registro
Cada entrada deve seguir obrigatoriamente:
- **Padrão:** Nome curto e descritivo.
- **Risco:** Impacto técnico, de segurança ou custo.
- **Solução:** Alternativa aprovada e validada.
- **Referência:** Caminho para regra ou documento oficial.

## Regras de Uso
1. Consulte este vault antes de implementar features críticas.
2. Se identificar um anti-pattern no código, registre aqui e acione o DELTA.
3. Revise e arquive itens obsoletos a cada sprint para manter o vault enxuto.

## Exemplo
- **Padrão:** `Hardcoded_Secrets`
- **Risco:** Vazamento em versionamento, falha em auditoria.
- **Solução:** Injetar via variáveis de ambiente + validação no startup.
- **Referência:** `Minhas_Rules/SECURITY.md`
