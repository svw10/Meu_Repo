# [03] SUBMODULE GUARD — Proteção do Núcleo Core

## Propósito
Impedir que alterações locais em projetos filhos corrompam ou desviam do `Antigravity OS` central. O framework deve ser imutável no nível do projeto, exceto para atualizações oficiais.

## Regra de Ouro (Read-Only)
A pasta `.antigravity-os/` é **READ-ONLY** para tarefas de desenvolvimento de features.
- ❌ **Proibido:** Editar, deletar ou renomear arquivos dentro de `.antigravity-os/` durante o trabalho no projeto.
- ✅ **Permitido:** Ler e consultar arquivos para seguir as regras.

## Fluxo de Atualização Segura
Se uma regra, skill ou wrapper precisar ser alterado:
1. **Não edite localmente.**
2. Identifique o arquivo no repositório central (GitHub do Framework).
3. Faça um Pull Request ou Commit no repo central.
4. No projeto filho, execute: `git submodule update --remote` para puxar a versão atualizada.

## Proteção contra Git Accidents
- **`.gitignore` Global:** A pasta `.antigravity-os/` pode ser adicionada ao `.gitignore` do projeto filho se você não quiser versionar o link do submódulo (embora seja recomendado versionar para garantir que todos usem a mesma versão).
- **Permissões:** Scripts em `.antigravity-os/[08] SUBMODULE_HOOKS/` devem ser executados para verificar integridade da estrutura.

## Integração com DELTA (Auditor)
- O Agente DELTA deve verificar se houve alterações não autorizadas em `.antigravity-os/` antes de aprovar um commit que envolva configuração de projeto.
- Se alterações locais forem detectadas: Rejeitar e solicitar limpeza (`git checkout -- .antigravity-os/`) ou commit da atualização oficial.
