// components/antigravity/motion/shader-background.tsx
"use client"

import { motion } from "framer-motion"

interface ShaderBackgroundProps {
  variant?: "aurora" | "sparkles" | "glow" | "grid"
  className?: string
}

export function ShaderBackground({ 
  variant = "aurora", 
  className = "" 
}: ShaderBackgroundProps) {
  const variants = {
    aurora: "bg-gradient-to-br from-purple-500/20 via-blue-500/20 to-cyan-500/20",
    sparkles: "bg-[radial-gradient(circle_at_1px_1px,_white_1px,_transparent_0)] [background-size:24px_24px] opacity-20",
    glow: "bg-[radial-gradient(ellipse_at_center,_rgba(204,255,0,0.15)_0%,_transparent_70%)]",
    grid: "bg-[linear-gradient(rgba(255,255,255,0.03)_1px,transparent_1px),linear-gradient(90deg,rgba(255,255,255,0.03)_1px,transparent_1px)] [background-size:40px_40px]"
  }

  return (
    <motion.div
      className={`absolute inset-0 -z-10 ${variants[variant]} ${className}`}
      animate={variant === "aurora" ? {
        backgroundPosition: ["0% 0%", "100% 100%", "0% 0%"]
      } : undefined}
      transition={{ 
        duration: 20, 
        repeat: Infinity, 
        ease: "linear" 
      }}
      style={variant === "aurora" ? { backgroundSize: "200% 200%" } : undefined}
    />
  )
}
```

---

### 2. **Text Shimmer Effect**
Efeito de brilho passando no texto.

**Onde inserir**: `animation_mastery.md` → seção "Text Animations"

```tsx
// components/antigravity/motion/text-shimmer.tsx
"use client"

import { motion } from "framer-motion"

export function TextShimmer({ 
  children, 
  className = "",
  duration = 2 
}: { 
  children: React.ReactNode
  className?: string
  duration?: number
}) {
  return (
    <span className={`relative inline-block overflow-hidden ${className}`}>
      {children}
      <motion.span
        className="absolute inset-0 bg-gradient-to-r from-transparent via-white/40 to-transparent"
        initial={{ x: "-100%" }}
        animate={{ x: "100%" }}
        transition={{ 
          duration, 
          repeat: Infinity, 
          ease: "linear",
          repeatDelay: 1 
        }}
      />
    </span>
  )
}
```

---

### 3. **Loading Morph**
Loading com forma que muda.

**Onde inserir**: `animation_mastery.md` → seção "Micro-interactions"

```tsx
// components/antigravity/motion/loading-morph.tsx
"use client"

import { motion } from "framer-motion"

export function LoadingMorph({ className = "" }: { className?: string }) {
  return (
    <motion.div 
      className={`w-8 h-8 rounded-full border-2 border-neon-lime ${className}`}
      animate={{
        rotate: 360,
        borderRadius: ["20%", "50%", "20%"],
        scale: [1, 1.1, 1]
      }}
      transition={{
        rotate: { duration: 1.5, repeat: Infinity, ease: "linear" },
        borderRadius: { duration: 2, repeat: Infinity, ease: "easeInOut" },
        scale: { duration: 1, repeat: Infinity, ease: "easeInOut" }
      }}
    />
  )
}
```

---

### 4. **Page Transition (FLIP)**
Transição entre páginas.

**Onde inserir**: `animation_mastery.md` → seção "Page Transitions" (novo)

```tsx
// components/antigravity/motion/page-transition.tsx
"use client"

import { motion } from "framer-motion"

export function PageTransition({ children }: { children: React.ReactNode }) {
  return (
    <motion.div
      initial={{ opacity: 0, scale: 0.98 }}
      animate={{ opacity: 1, scale: 1 }}
      exit={{ opacity: 0, scale: 1.02 }}
      transition={{ duration: 0.4, ease: [0.16, 1, 0.3, 1] }}
    >
      {children}
    </motion.div>
  )
}
```

---

### 5. **Globals.css Updates**
Keyframes e classes utilitárias.

**Onde inserir**: `00_fundacao/tailwind_config.md` ou `globals.css`

```css
/* Adicionar ao globals.css */

@keyframes gradient-shift {
  0%, 100% { background-position: 0% 50%; }
  50% { background-position: 100% 50%; }
}

.animate-gradient-shift {
  background-size: 200% 200%;
  animation: gradient-shift 20s ease infinite;
}

/* Noise overlay */
.noise-overlay {
  position: fixed;
  inset: 0;
  pointer-events: none;
  z-index: 100;
  opacity: 0.03;
  background-image: url("data:image/svg+xml,%3Csvg viewBox='0 0 200 200' xmlns='http://www.w3.org/2000/svg'%3E%3Cfilter id='noise'%3E%3CfeTurbulence type='fractalNoise' baseFrequency='0.65' numOctaves='3' stitchTiles='stitch'/%3E%3C/filter%3E%3Crect width='100%25' height='100%25' filter='url(%23noise)'/%3E%3C/svg%3E");
}

/* Lenis smooth scroll */
html.lenis {
  height: auto;
}
.lenis.lenis-smooth {
  scroll-behavior: auto;
}
```

---

