# [01] SYMBOLIC REFS — Referências Simbólicas

## Propósito
Substituir colagem de conteúdo bruto por ponteiros inteligentes, reduzindo drasticamente o consumo de tokens e evitando poluição de contexto.

## Sintaxe Obrigatória
- **Arquivo:** `@file:src/utils/auth.ts` (caminho relativo à raiz)
- **Schema/Model:** `@schema:User` ou `@db:Prisma.User`
- **Skill/Módulo:** `@skill:06_codando` ou `@module:ESTRATEGIA_DISCOVERY`
- **Trecho Específico:** `@file:config.ts#L12-45` (linhas exatas)

## Regras de Resolução (Para a IA)
1. Ao detectar `@`, busque o recurso na estrutura local (`Minhas_Skills/`, `Agentes/`, `src/`, etc.).
2. Carregue APENAS o trecho necessário para a tarefa atual.
3. Se o recurso não existir ou o caminho estiver quebrado, solicite correção antes de prosseguir.
4. Nunca expanda um `@schema` ou `@skill` inteiro se a tarefa exigir apenas uma função específica.

## Limites de Segurança
- Proibido: `@file:.env`, `@file:*.key`, `@file:secrets.json`
- Sanitize automaticamente paths que contenham `token`, `secret`, `password`, `key`.

## Exemplos Práticos
✅ **Correto:** "Valide o schema de autenticação usando `@schema:AuthInput` e a skill `@skill:05_verificando_conclusao`."
❌ **Errado:** Colar 200 linhas do schema + código da skill na mensagem.

## Integração
- Funciona em conjunto com `.antigravity-os/[03] SKILLS_ENGINE/[00] skills-constellation.json` para resolução de `@skill`.
- Priorize referências simbólicas em TODAS as interações, exceto debugging crítico que exija contexto completo.
