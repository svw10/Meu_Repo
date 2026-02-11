### 📂 Estrutura de Diretórios

```text
Minhas Skills/
└── criando-ui/
    ├── SKILL.md
    ├── snippets/
    │   ├── shadcn_card_example.tsx  # O padrão ouro de componente
    │   └── layout_skeleton.tsx      # Estrutura base de página Next.js
    └── resources/
        └── design_rules.md          # Paleta de cores e espaçamentos


### 1. O Cérebro (`Minhas Skills/criando-ui/SKILL.md`)

---
name: criando-ui
description: O Designer/Frontend. Gera componentes React modernos usando Tailwind CSS, Shadcn UI e Lucide Icons. Especialista em Next.js App Router e padrões de acessibilidade.
version: 1.0.0
tags: [frontend, react, tailwind, shadcn, ui, ux]
---

# Criando UI (Interface Protocol)

## 🎯 Quando usar
- **Novas Telas**: "Crie uma dashboard para o usuário".
- **Componentes Isolados**: "Preciso de um card de perfil de usuário".
- **Ajustes Visuais**: "Mude a cor do botão para o padrão da marca".

## 🧱 Stack Vinculada (Design System)
Esta skill é restrita ao seguinte ecossistema. Proibido usar Bootstrap, Material UI ou CSS puro.

| Categoria | Ferramenta Obrigatória |
| :--- | :--- |
| **Framework** | Next.js 14+ (App Router) |
| **Estilização** | Tailwind CSS (Utility-first) |
| **Componentes** | Shadcn UI (Radix Primitives) |
| **Ícones** | Lucide React |
| **Animação** | Tailwind Animate / Framer Motion (opcional) |

## ⚙️ Fluxo de Trabalho

- [ ] **1. Decisão de Renderização (Server vs Client)**
    - O componente precisa de `useState`, `useEffect` ou `onClick`?
        - **Sim**: Adicione `"use client"` no topo.
        - **Não**: Mantenha como Server Component (padrão).

- [ ] **2. Composição com Shadcn**
    - Não reinvente a roda. Se precisa de um botão, importe de `@/components/ui/button`.
    - Se precisa de um Card, use `@/components/ui/card`.

- [ ] **3. Estilização com Tailwind**
    - Use classes semânticas quando possível (`bg-primary`, `text-muted-foreground`).
    - Garanta responsividade (`md:grid-cols-2`).

## 📋 Checklist de Qualidade Visual
- [ ] O componente tem estado de carregamento (Skeleton)?
- [ ] O texto tem contraste suficiente?
- [ ] O componente é responsivo (Mobile First)?

## 💻 Snippets e Recursos

### Snippet 1: Padrão de Componente (Card)
```tsx
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { ArrowRight } from "lucide-react";

export function FeatureCard({ title, description }: { title: string, description: string }) {
  return (
    <Card className="hover:shadow-lg transition-all duration-300">
      <CardHeader>
        <CardTitle className="text-xl font-bold">{title}</CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-muted-foreground mb-4">{description}</p>
        <Button variant="outline" className="w-full">
          Saiba Mais <ArrowRight className="ml-2 h-4 w-4" />
        </Button>
      </CardContent>
    </Card>
  );
}


---

### 2. Snippets de Produção

#### `snippets/layout_skeleton.tsx` (Estrutura de Página Padrão)
Este snippet ensina ao agente como montar uma página inteira no Next.js sem esquecer do container principal.

```tsx
// app/(dashboard)/page.tsx
import { Suspense } from "react";
import { Skeleton } from "@/components/ui/skeleton";

export default function DashboardPage() {
  return (
    <div className="container mx-auto py-10 space-y-8">
      {/* Cabeçalho */}
      <div className="flex justify-between items-center">
        <div>
          <h2 className="text-3xl font-bold tracking-tight">Dashboard</h2>
          <p className="text-muted-foreground">Visão geral do sistema.</p>
        </div>
        {/* Botões de Ação */}
        <div className="flex gap-2">
            {/* Action Buttons here */}
        </div>
      </div>

      {/* Grid de Conteúdo */}
      <div className="grid gap-4 md:grid-cols-2 lg:grid-cols-4">
        <Suspense fallback={<Skeleton className="h-[125px] w-full rounded-xl" />}>
           {/* Componentes Assíncronos aqui */}
        </Suspense>
      </div>
    </div>
  );
}


#### `resources/design_rules.md` (As Leis do Design)

Regras para o agente não criar interfaces "carnavais".

# Regras de Design (Antigravity System)

## Cores (Tailwind Semantic)
Use sempre as variáveis semânticas, nunca cores hardcoded (ex: `#ff0000`).
- **Principal**: `bg-primary`, `text-primary-foreground`
- **Secundário**: `bg-secondary`, `text-secondary-foreground`
- **Destrutivo (Erro)**: `bg-destructive`
- **Sutil**: `text-muted-foreground`

## Espaçamento
- Use múltiplos de 4 (padrão Tailwind).
- Margem padrão entre seções: `space-y-8` ou `gap-4`.
- Padding padrão de container: `p-6` ou `p-8`.

## Tipografia
- Títulos: `font-bold tracking-tight`
- Corpo: `text-sm` ou `text-base`
- Legendas: `text-xs text-muted-foreground`

