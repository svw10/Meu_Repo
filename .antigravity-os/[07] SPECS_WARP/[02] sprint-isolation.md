# [02] SPRINT ISOLATION — Protocolo de Contexto Limpo

## Propósito
Garantir que cada sprint técnica seja executada em um contexto isolado, eliminando "lixo" de sessões anteriores e prevenindo a "Dumb Zone" (alucinação por superlotação de contexto).

## 🧱 Regra de Ouro: 1 Sprint = 1 Chat Limpo
- Nunca acumule múltiplas sprints na mesma conversa.
- Ao finalizar uma sprint, execute `/clear` imediatamente.
- O contexto inicial da nova sprint deve conter APENAS:
  1. A SPEC Técnica atual (apenas o bloco da sprint relevante).
  2. O `prevention_prompt` extraído de `MEMORY_DNA` (se aplicável).
  3. As regras globais do `.cursorrules`.

## 🔄 Fluxo de Isolamento
1. **Início:** A IA lê apenas o objeto da sprint atual em `.antigravity-os/[07] SPECS_WARP/[01] spec-technical-schema.ts`.
2. **Execução:** Foca estritamente nos `files` e `acceptance_criteria` daquela sprint. Ignora código não relacionado.
3. **Validação:** Verifique critérios de aceite. Se passar → marque status como `done`.
4. **Transição:** Atualize o rastreador de progresso externo. Execute `/clear`.
5. **Próxima:** Carregue apenas os dados da Sprint N+1.

## 🧠 Gestão de Estado (Sem Poluir Contexto)
- Use arquivos externos para rastrear progresso, nunca o histórico do chat.
- Referencie o estado atual via ponteiros `@file` ou resumos <200 tokens.
- Se precisar de contexto de sprints anteriores, solicite um "resume técnico" compacto, nunca o log completo.

## 🤖 Integração com Agentes
- **THETA:** Prepara o pacote de contexto mínimo e dispara o isolamento.
- **GAMMA:** Executa dentro dos limites estritos da sprint ativa.
- **DELTA:** Valida a entrega isolada antes de liberar a transição para a próxima.

## ⚠️ Alerta de Violação
Se o consumo de contexto ultrapassar 60% ou a IA detectar mistura de sprints, deve parar imediatamente e solicitar `/clear` + recarregamento da sprint atual.
