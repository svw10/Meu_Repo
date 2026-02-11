# UI KIT INDEX - MAPA DE COMPONENTES VISUAIS
> **USO:** Referência obrigatória para o Agente GAMMA ao criar telas (`/ui`).

## 1. COMPONENTES PRIMITIVOS (SHADCN/UI)
*Estes componentes já estão pré-configurados. Não crie do zero.*

| NOME | ARQUIVO BASE | OBSERVAÇÃO |
| :--- | :--- | :--- |
| **Button** | `components/ui/button.tsx` | Variantes: default, destructive, outline, secondary, ghost, link |
| **Input** | `components/ui/input.tsx` | Sempre usar com `Label` |
| **Card** | `components/ui/card.tsx` | Estrutura: Root > Header > Title > Content > Footer |
| **Dialog** | `components/ui/dialog.tsx` | Modais e popups |
| **Toast** | `components/ui/use-toast.ts` | Notificações de sistema |

## 2. PADRÕES DE LAYOUT (TAILWIND)
* **Container:** `container mx-auto px-4 py-8`
* **Grid Padrão:** `grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6`
* **Card Premium (Glass):** `bg-white/10 backdrop-blur-lg border-white/20` (Ver Skill `ux-pro-max`)

## 3. CORES SEMÂNTICAS (THEME)
* `bg-primary` / `text-primary-foreground`: Ações principais.
* `bg-destructive`: Ações de erro/perigo.
* `text-muted-foreground`: Textos secundários.

---
**REGRA:** Se precisar de um componente que não está aqui, procure em `Snippets\ui` antes de criar.