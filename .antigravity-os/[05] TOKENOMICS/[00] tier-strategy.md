# [00] TIER STRATEGY — Economia Inteligente de Tokens

## Propósito
Definir estratégias de execução baseadas em "Custo-Benefício", priorizando o mínimo de tokens para o máximo de resultado.

##  Tier 1: Senior Mode (Simbólico)
**Economia estimada: ~70%**
- **Regra:** Nunca cole schemas, componentes grandes ou logs inteiros no prompt.
- **Técnica:** Use referências simbólicas.
  - ❌ Errado: Colar o schema `User` inteiro (300 linhas).
  - ✅ Certo: Usar `@schema:User` ou apontar o arquivo `db/schema.prisma`.
- **Ação da IA:** Ler o arquivo referenciado sob demanda (Lazy Load).

## 🥈 Tier 2: Differential Updates (Git Diff)
**Economia estimada: ~50% em refatorações**
- **Regra:** Nunca envie o arquivo completo se alterou apenas uma função.
- **Técnica:** Gere ou aplique apenas o `diff`.
- **Ação da IA:** Use ferramentas de patch ou blocos de código focados na alteração.

## 🥉 Tier 3: Context Pruning (Jardinagem)
**Economia estimada: Mantém o modelo "esperto"**
- **Regra:** Contexto poluído gera alucinação.
- **Técnica:**
  - Arquivos de configuração estáticos (`package.json`, `tsconfig`) → Não incluir a cada mensagem, apenas na primeira.
  - Logs antigos → Arquivar ou limpar após leitura.
  - Prompts de sistema longos → Dividir em arquivos modulares (`skills/`).

## ⚠️ Alerta de Custos
Se `estimated_cost > budget`, aplique automaticamente o **Tier 1**.