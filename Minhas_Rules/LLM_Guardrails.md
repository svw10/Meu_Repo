name: llm-guardrails
description: Guardrails de custo, qualidade, segurança e MCP para uso de LLMs.
version: 3.1.0
---

# LLM GUARDRAILS (Proteções de IA)

## 1. Controle de Custo

| Métrica | Limite | Ação ao Atingir |
|:---|:---|:---|
| Custo/request | $0.05 | Trocar para modelo mais barato |
| Custo/dia | $5.00 | Alertar admin, pausar jobs não-críticos |
| Tokens/request | 4k | Truncar ou resumir contexto |
| Tokens/mês | 100k | Revisar arquitetura, sugerir cache |

## 2. Routing de Modelos (Adaptive)

```yaml
routing_strategy: adaptive

tiers:
  simple:
    models: [gemini-flash, llama-3.1-8b]
    cost_max: 0.001
    use_for: [classificacao, resumo curto, validacao]
    
  standard:
    models: [gpt-4o-mini, claude-3-haiku]
    cost_max: 0.01
    use_for: [geracao de codigo, explicacoes]
    
  complex:
    models: [claude-3.5-sonnet, gpt-4o]
    cost_max: 0.05
    use_for: [arquitetura, debug complexo, criacao de specs]
    
  mcp:
    models: [claude-3.5-sonnet]  # Melhor para tool use
    cost_max: 0.03
    use_for: [chamadas MCP, integracoes externas]
    
  fallback:
    models: [ollama-local]
    cost_max: 0
    use_for: [quando cloud falhar ou custo excedido]
3. Segurança de Prompt
Input Sanitization
TypeScript
Copy
// Sempre validar inputs antes de enviar ao LLM
function sanitizeInput(input: string): string {
  // Remove potenciais injeções de system prompt
  const blocked = [
    /ignore previous instructions/gi,
    /system prompt/gi,
    /you are now/gi,
    /new role:/gi
  ];
  
  let cleaned = input.slice(0, 4000); // Limita tamanho
  
  blocked.forEach(pattern => {
    cleaned = cleaned.replace(pattern, '[REDACTED]');
  });
  
  return cleaned;
}
Output Validation
TypeScript
Copy
// Sempre validar outputs estruturados
const result = await llm.generate(prompt);
const parsed = safeJsonParse(result); // Com fallback

if (!parsed) {
  console.error("LLM output inválido, usando fallback");
  return fallbackResponse();
}
4. MCP (Model Context Protocol)
Quando usar MCP
Agente precisa acessar dados locais (arquivos, DB SQLite)
Integração com APIs legadas sem SDK oficial
Ferramentas especializadas (calculadora, regex complexo)
Quando NÃO usar MCP
Operações simples (use skills diretamente)
Dados já disponíveis via API REST
Processamento batch (use Inngest)
Exemplo de Tool MCP
TypeScript
Copy
// tools/calculator.ts
import { z } from 'zod';

export const calculatorTool = {
  name: "calculate",
  description: "Executa cálculos matemáticos complexos",
  parameters: z.object({
    expression: z.string().describe("Expressão matemática válida")
  }),
  async execute({ expression }) {
    // Validação rigorosa antes de eval
    const safeExpr = expression.replace(/[^0-9+\-*/().]/g, '');
    return { result: Function('"use strict"; return (' + safeExpr + ')')() };
  }
};
5. Observabilidade
Todo uso de LLM deve logar:
JSON
Copy
{
  "timestamp": "2024-01-15T10:30:00Z",
  "model": "claude-3.5-sonnet",
  "tokens_input": 1500,
  "tokens_output": 320,
  "cost_usd": 0.012,
  "latency_ms": 850,
  "cache_hit": false,
  "mcp_tools_used": ["query_database"],
  "skill_invoked": "planejando-solucoes"
}