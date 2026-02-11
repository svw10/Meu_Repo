# BLUEPRINT: NEXT.JS OMEGA STACK
> **USO:** Receita de bolo para o Agente ALPHA usar no comando `/genesis`.

## 1. ESTRUTURA DE DIRETÓRIOS OBRIGATÓRIA

```text
/src
  /app              # App Router (Next.js 14+)
    /api            # Route Handlers (Backend)
    /(auth)         # Rotas de Autenticação (Clerk/Auth)
    /(dashboard)    # Rotas Protegidas
    layout.tsx      # Root Layout
    page.tsx        # Home Page
  /components
    /ui             # Shadcn Primitives (Botões, Inputs)
    /shared         # Componentes Reutilizáveis do Projeto
  /lib
    db.ts           # Conexão Drizzle + Neon
    utils.ts        # CN (Class Merge) e Formatadores
  /server           # Server Actions (Z.A.P)
  /types            # Definições TypeScript Globais
.env                # Variáveis de Ambiente (NUNCA COMMITAR)
drizzle.config.ts   # Config do Banco
next.config.js      # Config do Next