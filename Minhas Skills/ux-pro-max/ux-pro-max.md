name: ux-pro-max
description: Protocolo de UI/UX de Alta Fidelidade. Gera interfaces nível Awwwards/Vercel usando Bento Grids, Motion e Glassmorphism.
version: 1.0.0
tags: [ui, design, tailwind, framer-motion, aesthetics]
---

# UI/UX Pro Max Protocol

## 🎯 Quando usar
- Comando `/ui-max`.
- O projeto exige "Wow Factor" (Landing Pages, Dashboards Premium).
- O usuário pede: "Faça algo bonito", "Nível Apple", "Design moderno".

## 🧱 Arsenal Visual
- **Layout**: Bento Grids, Asymmetrical Layouts.
- **Motion**: Framer Motion (obrigatório para transições suaves).
- **Estilo**: Glassmorphism (`backdrop-blur`), Noise Textures, Gradients sutis.

## ⚙️ Fluxo de Trabalho
1. **Escolha do Arquétipo**:
   - *SaaS Minimal*: Fonte Inter, preto/branco, bordas finas (`border-zinc-200`).
   - *Futuristic*: Fontes mono, gradientes neon, dark mode profundo (`bg-zinc-950`).
   
2. **Componentização (Shadcn + Motion)**:
   - Não use componentes estáticos. 
   - Ex: Um Card não apenas aparece; ele usa `snippets/ui/motion.tsx` para deslizar.

3. **Regras de Ouro**:
   - **Espaço Negativo**: Use `p-8` ou `p-12`. Dê respiro ao conteúdo.
   - **Micro-interações**: Todo botão deve ter `hover:scale-105` ou `active:scale-95`.

## 💻 Snippets Exclusivos
- `snippets/ui/motion.tsx`