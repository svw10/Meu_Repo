# [03] CROSS-PROJECT SYNC — Sincronização de Aprendizado

## Propósito
Compartilhar "vacinas" (erros críticos resolvidos) e padrões aprovados entre todos os projetos que usam este Meta-Framework, sem expor dados sensíveis.

## Protocolo de Sincronização
- **Direção:** HTTPS Outbound-Only (Pull do repositório central).
- **Cache Local:** TTL de 24h. Atualiza apenas se o hash do registry remoto mudar.
- **Gatilho:** Manual (`/sync-memory`) ou automático ao registrar erro com `immunity_scope: "all_projects"`.

## Configuração (Ajuste uma vez)
- `REMOTE_REGISTRY_URL`: "https://raw.githubusercontent.com/svw10/Meu_Repo/main/.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json"
- `LOCAL_CACHE_PATH`: ".antigravity-os/[04] MEMORY_DNA/.cache/synced-registry.json"

## Regras de Segurança Críticas
1. **NUNCA** sincronize paths absolutos, nomes de clientes, chaves de API ou dados PII.
2. Sanitize todos os campos `context_snapshot` antes do push.
3. Use apenas padrões genéricos de stack (ex: "Next.js 14 + Prisma", não "projeto-cliente-x").

## Instruções para a IA
- Ao iniciar sessão: Verifique cache local. Se expirado (>24h), faça pull silencioso do remoto.
- Ao resolver erro crítico: Pergunte ao usuário "Deseja compartilhar esta solução como padrão global (Stack Omega)?"
- Se sim: Atualize o registry local e notifique para push manual no repositório central.
