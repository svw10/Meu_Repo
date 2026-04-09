# [02] PREVENTION INJECTOR — Mecanismo de Injeção de Imunidade

## Propósito
Converter erros passados (`MEMORY_DNA`) em proteção ativa para a sessão atual, sem inflar o contexto.

## Algoritmo de Execução
1. **Scan**: Antes de iniciar uma Task, leia `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.
2. **Match**: Busque chaves relacionadas ao contexto atual (ex: "Prisma", "Auth", "Next.js").
3. **Extract**: Copie apenas o campo `prevention_prompt` dos erros ativos encontrados.
4. **Inject**: Adicione a frase copiada como uma regra temporária no início da tarefa.

## Formato de Injeção
> ⚠️ **MEMÓRIA DE PREVENÇÃO:** [prevention_prompt extraído]

## Restrições de Token
- Injete no máximo 3 prompts de prevenção por sessão.
- Priorize erros com tag `immunity_scope: "all_projects"`.
- Se o erro não for relevante, ignore.
