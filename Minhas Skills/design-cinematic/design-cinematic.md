### 🏛️ ARQUIVO DEFINITIVO: `design-cinematic.md` (FULL ARSENAL)

```markdown
# SKILL: DESIGN CINEMATIC, 3D & PREMIUM MATERIALS (MASTER EDITION)
> **Descrição:** Biblioteca definitiva de UI/UX para Landing Pages de Luxo (Apple/Nike/Awwwards).
> **Foco:** Scrollytelling, Física 3D, Tratamento de Imagem Volumétrico e Movimento Quântico.
> **Tecnologias:** Framer Motion, Lenis Scroll, Tailwind CSS.

## 🎨 1. DNA VISUAL & ATMOSFERA
- **Background:** `bg-[#050505]` (Preto Profundo - nunca use #000000).
- **Accent Color:** `text-[#CCFF00]` (Neon Lime) ou `text-[#FF3B30]` (Vermelho Sport).
- **Glass Surface:** `bg-white/5` com `backdrop-blur-xl` e `border-white/10`.

## 💎 2. TRATAMENTO DE IMAGEM (O Efeito "Tecido Real")
**IMPORTANTE:** Nunca renderize imagens de produtos "cruas". Use este container para criar granulação, volume e luz.

### COMPONENTE: `<PremiumProductDisplay />`
```tsx
<div className="group relative w-full h-full flex items-center justify-center perspective-1000">
  {/* 1. Sombra Colorida Volumétrica (Glow do Tecido) */}
  <div className="absolute inset-0 bg-gradient-to-tr from-[#CCFF00]/20 to-transparent opacity-0 blur-[100px] transition-opacity duration-700 group-hover:opacity-100" />
  
  {/* 2. O Produto (Camiseta) */}
  <div className="relative z-10 transition-transform duration-500 ease-out group-hover:scale-105 group-hover:-rotate-2 group-hover:drop-shadow-[0_30px_60px_rgba(204,255,0,0.3)]">
      <Image 
        src={src} 
        alt="Produto Premium" 
        width={800} 
        height={1000}
        quality={100}
        priority 
        className="drop-shadow-[0_20px_40px_rgba(0,0,0,0.8)] object-contain" 
      />
      
      {/* 3. TEXTURA DE GRANULAÇÃO (Noise) - ANTI-PLÁSTICO */}
      {/* Gera ruído visual via SVG Base64 para simular tecido real */}
      <div className="pointer-events-none absolute inset-0 opacity-15 mix-blend-overlay bg-[url('data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyMDAgMjAwIj48ZmlsdGVyIGlkPSJuIj48ZmVUdXJidWxlbmNlIHR5cGU9ImZyYWN0YWxOb2lzZSIgYmFzZUZyZXF1ZW5jeT0iMC42NSIgbnVtT2N0YXZlcz0iMyIHN0aXRjaFRpbGVzPSJzdGl0Y2giLz48L2ZpbHRlcj48cmVjdCB3aWR0aD0iMTAwJSIgaGVpZ2h0PSIxMDAlIiBmaWxsPSJ0cmFuc3BhcmVudCIvPjxyZWN0IHdpZHRoPSIxMDAlIiBoZWlnaHQ9IjEwMCUiIGZpbHRlcj0idXJsKCNuKSIgb3BhY2l0eT0iMC40Ii8+PC9zdmc+')]" />
      
      {/* 4. Reflexo de Luz (Sheen Especular) */}
      <div className="absolute inset-0 bg-gradient-to-tr from-white/0 via-white/5 to-white/0 opacity-0 group-hover:opacity-100 transition-opacity duration-500 mask-image-linear-gradient" />
  </div>
</div>

```

## 🧩 3. ELEMENTOS DE INTERFACE (UI KIT)

### A. BOTÃO "ATOMIC NEON" (CTA Principal)

```tsx
<button className="relative px-12 py-6 bg-[#CCFF00] text-black font-black text-xl tracking-tighter uppercase overflow-hidden rounded-full transition-all duration-300 hover:scale-105 hover:shadow-[0_0_60px_-15px_rgba(204,255,0,0.6)] active:scale-95">
  <span className="relative z-10 flex items-center gap-3">
    GARANTIR A MINHA <ArrowRight className="w-6 h-6 animate-pulse" />
  </span>
  <div className="absolute inset-0 bg-white/40 scale-x-0 origin-left transition-transform duration-300 group-hover:scale-x-100" />
</button>

```

### B. GLASS CARD (Detalhes Técnicos)

```tsx
<div className="group relative overflow-hidden rounded-[2rem] border border-white/10 bg-white/5 p-10 backdrop-blur-2xl transition-all hover:bg-white/10 hover:border-[#CCFF00]/30">
  <div className="absolute -top-24 -right-24 h-64 w-64 rounded-full bg-[#CCFF00]/10 blur-[80px] transition-all group-hover:bg-[#CCFF00]/20" />
  <h3 className="text-3xl font-bold text-white mb-4 group-hover:text-[#CCFF00] transition-colors">Tecnologia Dry-Fit</h3>
  <p className="text-lg text-gray-400 leading-relaxed">Microfibras de alta performance que evaporam o suor instantaneamente.</p>
</div>

```

### C. TIPOGRAFIA CINEMÁTICA

* **H1 (Hero):** `text-7xl md:text-[10rem] leading-[0.85] font-black tracking-tighter uppercase text-white mix-blend-overlay`
* **H2 (Seções):** `text-6xl md:text-8xl font-bold tracking-tighter text-transparent bg-clip-text bg-gradient-to-b from-white to-white/40`

## 🕹️ 4. MECÂNICA DE MOVIMENTO (FÍSICA AVANÇADA)

### D. SCROLLYTELLING STICKY (O Efeito do Primeiro Vídeo)

**Uso:** Seção onde a imagem fica parada (Sticky) e o texto rola.

```tsx
<section className="relative h-[400vh] bg-[#050505]">
  {/* CAMADA STICKY (Fixa) */}
  <div className="sticky top-0 h-screen w-full flex items-center justify-center overflow-hidden">
     <AnimatePresence mode="wait">
        <motion.div 
           key={activeFeatureIndex} 
           initial={{ opacity: 0, scale: 1.1, filter: "blur(20px)" }}
           animate={{ opacity: 1, scale: 1, filter: "blur(0px)" }}
           exit={{ opacity: 0, scale: 0.9, filter: "blur(10px)" }}
           transition={{ duration: 1.2, ease: [0.16, 1, 0.3, 1] }} // Easing Apple-like
           className="absolute inset-0 flex items-center justify-center"
        >
           <PremiumProductDisplay src={features[activeFeatureIndex].image} />
        </motion.div>
     </AnimatePresence>
  </div>
  
  {/* CAMADA DE TEXTO (Scrollável) */}
  <div className="relative z-10 w-full">
     {features.map((f, i) => (
        <div key={i} className="h-screen flex items-center justify-end pr-20">
           <motion.div 
             initial={{ opacity: 0, x: 50 }}
             whileInView={{ opacity: 1, x: 0 }}
             className="max-w-xl bg-black/60 backdrop-blur-xl p-12 rounded-3xl border-l-4 border-[#CCFF00]"
           >
              <h3 className="text-5xl font-black text-white mb-6">{f.title}</h3>
              <p className="text-xl text-gray-300">{f.desc}</p>
           </motion.div>
        </div>
     ))}
  </div>
</section>

```

### E. QUANTUM CAROUSEL 3D (Efeito Planeta/Camiseta)

**Uso:** Carrossel onde as camisetas giram em órbita horizontal.

```tsx
'use client';
import { motion, useScroll, useTransform } from 'framer-motion';
import { useRef } from 'react';

export const Carousel3D = ({ items }) => {
  const containerRef = useRef(null);
  const { scrollYProgress } = useScroll({ target: containerRef });

  return (
    <div ref={containerRef} className="relative h-[150vh] bg-black perspective-[2000px] overflow-hidden flex items-center justify-center">
       <div className="flex gap-[-100px] items-center">
         {items.map((src, i) => (
            <Card3D key={i} src={src} index={i} total={items.length} />
         ))}
       </div>
    </div>
  )
}

// Sub-componente com Lógica Orbital
const Card3D = ({ src, index }) => {
  return (
    <motion.div
       initial={{ rotateY: 45, scale: 0.8, opacity: 0.5, zIndex: 0 }}
       whileInView={{ rotateY: 0, scale: 1.2, opacity: 1, zIndex: 50 }}
       exit={{ rotateY: -45, scale: 0.8, opacity: 0.5, zIndex: 0 }}
       transition={{ duration: 0.8, ease: "circOut" }}
       viewport={{ margin: "-10% 20% -10% 20%" }} // Dispara quando chega no centro
       className="w-[350px] h-[500px] -ml-20 first:ml-0 transform-style-3d cursor-pointer hover:z-[100]"
    >
       <PremiumProductDisplay src={src} />
    </motion.div>
  )
}

```

### F. SLOW MOTION PARALLAX (Imagens Soltas)

```tsx
export const SlowMotionImage = ({ src }) => {
  const ref = useRef(null);
  const { scrollYProgress } = useScroll({ target: ref, offset: ["start end", "end start"] });
  const y = useTransform(scrollYProgress, [0, 1], ["0%", "-15%"]); // Movimento reverso suave
  const scale = useTransform(scrollYProgress, [0, 0.5, 1], [1, 1.05, 1]); // Respiração suave

  return (
    <div ref={ref} className="w-full overflow-hidden rounded-[3rem]">
      <motion.div style={{ y, scale }} className="relative h-[120%] w-full">
         <Image src={src} fill className="object-cover" />
      </motion.div>
    </div>
  )
}

```

## 🛠️ SETUP OBRIGATÓRIO

1. **Lenis Scroll:** Instale `@studio-freight/react-lenis` e envolva o app. Configure `lerp: 0.08` para sensação de "manteiga".
2. **Imagens:** Use arquivos PNG com fundo transparente para o efeito de tecido funcionar.
3. **Fonte:** Recomenda-se a fonte "Inter" ou "Geist" com `font-feature-settings: 'tnum', 'ss01'`.

