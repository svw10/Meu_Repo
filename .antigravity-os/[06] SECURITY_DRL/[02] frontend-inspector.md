# [02] FRONTEND INSPECTOR — Auditoria de Cliente (Browser)

## Propósito
Garantir que o código que roda no navegador do usuário seja seguro, leve e não exponha dados do servidor ou segredos.

## Checklist de Validação (Obrigatório antes do Deploy)

### 1. 🚫 Vazamento de Secrets (Environment Variables)
- **Regra:** Nenhuma variável sensível deve ter o prefixo `NEXT_PUBLIC_` (ou `VITE_`, `REACT_APP_`).
- **Ação:** Se o frontend precisa de um segredo, crie um **Server Action** ou **API Route** para fazer a chamada segura, não exponha a chave no `.env` do client.

### 2. 🛑 Acesso Direto ao Banco (DB Client-Side)
- **Regra:** Proibido importar o ORM (Prisma, Drizzle, Mongoose) dentro de Componentes com `"use client"`.
- **Ação:** A lógica de banco deve ficar estritamente em **Server Components** ou **Server Actions**. O frontend recebe apenas os dados serializados (JSON).

### 3. ⚠️ Logs de Debug em Produção
- **Regra:** Remover `console.log`, `console.warn` ou `debugger` antes de commitar para `main`.
- **Ação:** Use um sistema de logging estruturado se for necessário monitorar erros no client.

### 4. ⚡ Performance & Re-renders
- **Regra:** Evitar re-renders desnecessários.
- **Ação:**
  - Use `React.memo` para componentes estáticos.
  - Verifique se as dependências de `useEffect` são estáveis.
  - Use `useCallback` para funções passadas como props.

### 5. 🔒 XSS & Sanitização
- **Regra:** Nunca renderize HTML cru (ex: `dangerouslySetInnerHTML`) sem sanitização prévia.
- **Ação:** Use bibliotecas de sanitização (ex: `dompurify`) ou prefira markdown renderizado seguro.

## Integração com Agente DELTA
- O Agente **DELTA (Auditor)** deve rodar este checklist automaticamente ao revisar arquivos dentro de `app/`, `components/` ou `pages/`.
- Se violação detectada → Bloquear merge e apontar a linha exata.
