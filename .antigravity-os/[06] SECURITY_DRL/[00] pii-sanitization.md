# Sanitização PII - Dr. Lexia Style

## Camadas
1. Pre-commit: regex local para CPF/email/telefone
2. Agent Local: Phi-3 Mini para anonimização (Squad_IA)
3. Pós-processamento: verifica vazamento no frontend

## Proteção do Núcleo
Nucleo/ é READ-ONLY via submódulo.