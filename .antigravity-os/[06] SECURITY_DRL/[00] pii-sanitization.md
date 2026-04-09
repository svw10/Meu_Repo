# [00] PII SANITIZATION — Proteção de Dados Sensíveis

## Propósito
Impedir vazamento de dados pessoais (PII) ou credenciais para a nuvem/IA, garantindo compliance LGPD e segurança zero-trust.

## Detecção Local (Regex Patterns)
A IA deve escanear TODO o contexto antes de enviar à nuvem. Padrões críticos:
- **CPF:** `\d{3}\.\d{3}\.\d{3}-\d{2}`
- **E-mail:** `[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}`
- **Telefone:** `\(\d{2}\)\s?\d{4,5}-?\d{4}`
- **IP/Hosts Internos:** `192\.168\.\d{1,3}\.\d{1,3}|10\.\d{1,3}\.\d{1,3}\.\d{1,3}`
- **Chaves/Secrets:** `(sk-|pk-|ghp_|AKIA)[A-Za-z0-9]{20,}`

## Protocolo de Sanitização
1. **Scan:** Identifique matches antes de injetar no prompt.
2. **Mask:** Substitua por `[REDACTED_<TYPE>]` (ex: `[REDACTED_CPF]`, `[REDACTED_EMAIL]`).
3. **Log:** Registre a ocorrência em `Logs/security_audit.log` (apenas metadata, nunca o dado original).
4. **Proceed:** Envie o contexto sanitizado para processamento.

## Integração com Minhas_Rules/
- Valide contra `Minhas_Rules/SECURITY.md` para padrões adicionais da stack.
- Se `Minhas_Rules/` exigir criptografia, aplique antes da masking.

## Regras Críticas para a IA
- 🚫 NUNCA inclua dados reais em exemplos, logs ou prompts de debug.
- ✅ USE sempre dados fictícios (ex: `user@example.com`, `000.000.000-00`) para testes.
- 🔒 Se detectar PII acidental, pause, sanitize e notifique: "⚠️ Dados sensíveis detectados e sanitizados automaticamente."