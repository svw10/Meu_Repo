Perfeito! Vou criar dois arquivos complementares especializados para elevar ainda mais seu arsenal de animações no Antigravity OS:

1. **Spline Integration** - Guia completo para 3D interativo
2. **GSAP ScrollTrigger** - Para animações de timeline complexas e pinning avançado

---

name: spline-integration
description: Guia completo de integração Spline para 3D interativo em Landing Pages. Embed, React, eventos e otimização.
version: 4.0.0
tags: [spline, 3d, webgl, interactive, landing-page]
---

# SPLINE INTEGRATION - 3D Interativo na Web

> **Filosofia**: 3D não é só visual — é experiência. O usuário deve querer interagir, não apenas observar.

---

## 🎯 ÍNDICE RÁPIDO

| Método | Complexidade | Performance | Caso de Uso |
|--------|-------------|-------------|-------------|
| **Embed Script** | Baixa | Média | Prototipagem rápida |
| **React Component** | Média | Alta | Produção Next.js |
| **Viewer API** | Alta | Alta | Interatividade customizada |
| **Runtime API** | Muito Alta | Máxima | Controle total da cena |

---

## 🚀 MÉTODO 1: EMBED SCRIPT (Rápido)

Para quando você precisa colocar uma cena 3D funcionando em 2 minutos.

### HTML Puro
```html
<!DOCTYPE html>
<html>
<head>
  <script 
    type="module" 
    src="https://unpkg.com/@splinetool/viewer@1.9.82/build/spline-viewer.js">
  </script>
</head>
<body>
  <spline-viewer 
    url="https://prod.spline.design/SEU-ID/scene.splinecode"
    loading-anim-type="none"
  ></spline-viewer>
</body>
</html>
```

### Next.js (Client Component)
```tsx
// components/spline/spline-embed.tsx
"use client";

import Script from "next/script";

export function SplineEmbed({ sceneUrl }: { sceneUrl: string }) {
  return (
    <>
      <Script
        src="https://unpkg.com/@splinetool/viewer@1.9.82/build/spline-viewer.js"
        type="module"
        strategy="lazyOnload"
      />
      <spline-viewer 
        url={sceneUrl}
        loading-anim-type="spinner-big"
        className="w-full h-full"
      />
    </>
  );
}
```

### Atributos do Viewer
```yaml
loading-anim-type:
  - none: Sem loading (recomendado se tiver skeleton próprio)
  - spinner: Spinner padrão
  - spinner-big: Spinner grande
  - logo: Logo do Spline animado

events:
  - mouse-down: Dispara quando clica
  - mouse-up: Dispara quando solta
  - mouse-hover: Dispara no hover
  - key-down: Dispara no teclado
  - key-up: Dispara no teclado
  - start: Quando cena inicia
  - load: Quando cena carrega completamente
```

---

## 🎨 MÉTODO 2: REACT COMPONENT (Produção)

Instalação:
```bash
npm install @splinetool/react-spline @splinetool/runtime
```

### Componente Base
```tsx
// components/spline/spline-scene.tsx
"use client";

import Spline from '@splinetool/react-spline';
import { Suspense, useState } from 'react';
import { motion } from 'framer-motion';

interface SplineSceneProps {
  scene: string;
  className?: string;
  onLoad?: () => void;
  onError?: () => void;
}

export function SplineScene({ 
  scene, 
  className = "w-full h-full",
  onLoad,
  onError 
}: SplineSceneProps) {
  const [isLoading, setIsLoading] = useState(true);

  return (
    <div className={`relative ${className}`}>
      {/* Skeleton de Loading */}
      {isLoading && (
        <div className="absolute inset-0 bg-gray-900 flex items-center justify-center">
          <motion.div
            animate={{ 
              scale: [1, 1.2, 1],
              opacity: [0.5, 1, 0.5]
            }}
            transition={{ duration: 2, repeat: Infinity }}
            className="w-16 h-16 border-4 border-purple-500 border-t-transparent rounded-full"
          />
        </div>
      )}
      
      <Suspense fallback={null}>
        <Spline
          scene={scene}
          onLoad={() => {
            setIsLoading(false);
            onLoad?.();
          }}
          onError={(err) => {
            console.error('Spline error:', err);
            onError?.();
          }}
        />
      </Suspense>
    </div>
  );
}
```

### Uso em Hero Section
```tsx
// app/sections/hero-spline.tsx
"use client";

import { SplineScene } from "@/components/spline/spline-scene";
import { motion } from "framer-motion";

export function HeroSpline() {
  return (
    <section className="relative h-screen w-full overflow-hidden bg-black">
      {/* Spline 3D Background */}
      <div className="absolute inset-0">
        <SplineScene 
          scene="https://prod.spline.design/xyz/scene.splinecode"
          onLoad={() => console.log('3D Scene loaded')}
        />
      </div>
      
      {/* Overlay Gradient para legibilidade */}
      <div className="absolute inset-0 bg-gradient-to-t from-black via-black/20 to-transparent" />
      
      {/* Conteúdo */}
      <div className="relative z-10 h-full flex flex-col justify-end pb-20 px-8">
        <motion.div
          initial={{ opacity: 0, y: 50 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 1, duration: 0.8 }}
          className="max-w-4xl"
        >
          <h1 className="text-6xl md:text-8xl font-black text-white leading-none">
            EXPERIÊNCIA<br />
            <span className="text-transparent bg-clip-text bg-gradient-to-r from-purple-400 to-pink-600">
              IMERSIVA
            </span>
          </h1>
          <p className="mt-6 text-xl text-white/70 max-w-xl">
            Interaja com o futuro. Arraste, gire e explore nosso universo 3D.
          </p>
        </motion.div>
      </div>
      
      {/* Hint de interação */}
      <motion.div
        initial={{ opacity: 0 }}
        animate={{ opacity: 1 }}
        transition={{ delay: 2 }}
        className="absolute bottom-8 right-8 text-white/50 text-sm flex items-center gap-2"
      >
        <span className="w-2 h-2 bg-green-500 rounded-full animate-pulse" />
        Interativo • Arraste para explorar
      </motion.div>
    </section>
  );
}
```

---

## 🎮 MÉTODO 3: VIEWER API (Interatividade)

Controle programático da cena 3D via JavaScript.

### Hook useSpline
```tsx
// hooks/useSpline.ts
import { useRef, useCallback } from 'react';
import { Application } from '@splinetool/runtime';

export function useSpline() {
  const splineRef = useRef<Application | null>(null);

  const onLoad = useCallback((spline: Application) => {
    splineRef.current = spline;
    
    // Eventos globais
    spline.addEventListener('mouseDown', (e) => {
      console.log('Mouse down on:', e.target.name);
    });
    
    spline.addEventListener('keyDown', (e) => {
      console.log('Key pressed:', e.key);
    });
  }, []);

  const triggerAnimation = useCallback((animationName: string) => {
    splineRef.current?.emitEvent('keyDown', animationName);
  }, []);

  const getObject = useCallback((name: string) => {
    return splineRef.current?.findObjectByName(name);
  }, []);

  const setVariable = useCallback((name: string, value: any) => {
    splineRef.current?.setVariable(name, value);
  }, []);

  return {
    onLoad,
    triggerAnimation,
    getObject,
    setVariable,
    spline: splineRef
  };
}
```

### Componente Interativo
```tsx
// components/spline/interactive-3d.tsx
"use client";

import Spline from '@splinetool/react-spline';
import { useSpline } from '@/hooks/useSpline';
import { motion } from 'framer-motion';

export function Interactive3D() {
  const { onLoad, triggerAnimation, setVariable } = useSpline();

  const handleColorChange = (color: string) => {
    setVariable('productColor', color);
  };

  const handleRotate = () => {
    triggerAnimation('rotate');
  };

  return (
    <div className="relative h-screen w-full bg-gray-900">
      <Spline
        scene="https://prod.spline.design/xyz/scene.splinecode"
        onLoad={onLoad}
      />
      
      {/* UI Controls flutuante */}
      <motion.div
        initial={{ opacity: 0, x: -50 }}
        animate={{ opacity: 1, x: 0 }}
        transition={{ delay: 1.5 }}
        className="absolute left-8 top-1/2 -translate-y-1/2 space-y-4"
      >
        <div className="bg-black/50 backdrop-blur-xl p-6 rounded-2xl border border-white/10">
          <h3 className="text-white font-bold mb-4">Personalizar</h3>
          
          {/* Seletor de cor */}
          <div className="space-y-2">
            <label className="text-white/70 text-sm">Cor do Produto</label>
            <div className="flex gap-2">
              {['#FF5733', '#33FF57', '#3357FF', '#F333FF'].map((color) => (
                <button
                  key={color}
                  onClick={() => handleColorChange(color)}
                  className="w-8 h-8 rounded-full border-2 border-white/20 hover:scale-110 transition-transform"
                  style={{ backgroundColor: color }}
                />
              ))}
            </div>
          </div>
          
          {/* Botões de ação */}
          <div className="mt-6 space-y-2">
            <button
              onClick={handleRotate}
              className="w-full px-4 py-2 bg-white text-black rounded-lg font-medium hover:bg-white/90 transition-colors"
            >
              Girar 360°
            </button>
            <button
              onClick={() => triggerAnimation('explode')}
              className="w-full px-4 py-2 bg-white/10 text-white rounded-lg font-medium hover:bg-white/20 transition-colors"
            >
              Ver Explodido
            </button>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
```

---

## 🎛️ MÉTODO 4: RUNTIME API (Controle Total)

Manipulação avançada de objetos da cena.

```tsx
// components/spline/advanced-control.tsx
"use client";

import { useEffect, useRef } from 'react';
import { Application } from '@splinetool/runtime';

export function AdvancedSplineControl() {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const appRef = useRef<Application | null>(null);

  useEffect(() => {
    if (!canvasRef.current) return;

    const init = async () => {
      const app = new Application(canvasRef.current!);
      await app.load('https://prod.spline.design/xyz/scene.splinecode');
      
      appRef.current = app;
      
      // Controle total da cena
      const cube = app.findObjectByName('Cube');
      const sphere = app.findObjectByName('Sphere');
      
      // Animar via código
      if (cube) {
        cube.position.x = 100;
        cube.rotation.y = Math.PI / 4;
        cube.scale.set(2, 2, 2);
      }
      
      // Eventos customizados
      app.addEventListener('mouseDown', (e) => {
        if (e.target.name === 'Button') {
          // Trigger animação específica
          app.emitEvent('mouseDown', 'AnimationState');
        }
      });
    };

    init();
    
    return () => {
      appRef.current?.dispose();
    };
  }, []);

  return (
    <canvas 
      ref={canvasRef} 
      className="w-full h-full"
      style={{ display: 'block' }}
    />
  );
}
```

---

## 🎨 PADRÕES DE DESIGN COM SPLINE

### 1. Hero 3D com Scroll Parallax
```tsx
"use client";

import { useRef } from 'react';
import { motion, useScroll, useTransform } from 'framer-motion';
import Spline from '@splinetool/react-spline';

export function Hero3DParallax() {
  const containerRef = useRef(null);
  const { scrollYProgress } = useScroll({
    target: containerRef,
    offset: ["start start", "end start"]
  });
  
  const y = useTransform(scrollYProgress, [0, 1], ["0%", "50%"]);
  const opacity = useTransform(scrollYProgress, [0, 0.5], [1, 0]);
  const scale = useTransform(scrollYProgress, [0, 1], [1, 1.2]);

  return (
    <div ref={containerRef} className="relative h-[200vh]">
      <div className="sticky top-0 h-screen overflow-hidden">
        {/* Spline com parallax */}
        <motion.div 
          style={{ y, scale }}
          className="absolute inset-0"
        >
          <Spline scene="https://prod.spline.design/xyz/scene.splinecode" />
        </motion.div>
        
        {/* Conteúdo que fade out */}
        <motion.div 
          style={{ opacity }}
          className="absolute inset-0 flex items-center justify-center"
        >
          <h1 className="text-7xl font-black text-white text-center">
            SCROLL PARA<br />EXPLORAR
          </h1>
        </motion.div>
      </div>
    </div>
  );
}
```

### 2. Produto 3D Interativo (E-commerce)
```tsx
"use client";

import { useState } from 'react';
import { motion, AnimatePresence } from 'framer-motion';
import Spline from '@splinetool/react-spline';
import { useSpline } from '@/hooks/useSpline';

const productConfigs = {
  sneaker: {
    scene: "https://prod.spline.design/sneaker/scene.splinecode",
    colors: ['#FF0000', '#00FF00', '#0000FF'],
    price: "$299"
  },
  watch: {
    scene: "https://prod.spline.design/watch/scene.splinecode",
    colors: ['#FFD700', '#C0C0C0', '#000000'],
    price: "$599"
  }
};

export function Product3DShowcase() {
  const [activeProduct, setActiveProduct] = useState('sneaker');
  const [activeColor, setActiveColor] = useState(0);
  const { onLoad, setVariable } = useSpline();

  const currentProduct = productConfigs[activeProduct];

  const handleColorChange = (index: number) => {
    setActiveColor(index);
    setVariable('color', currentProduct.colors[index]);
  };

  return (
    <section className="min-h-screen bg-gray-900 py-20">
      <div className="container mx-auto px-6 grid lg:grid-cols-2 gap-12 items-center">
        {/* Visualizador 3D */}
        <div className="h-[600px] relative">
          <AnimatePresence mode="wait">
            <motion.div
              key={activeProduct}
              initial={{ opacity: 0, scale: 0.8 }}
              animate={{ opacity: 1, scale: 1 }}
              exit={{ opacity: 0, scale: 0.8 }}
              transition={{ duration: 0.5 }}
              className="w-full h-full"
            >
              <Spline 
                scene={currentProduct.scene}
                onLoad={onLoad}
              />
            </motion.div>
          </AnimatePresence>
          
          {/* Badge de interação */}
          <div className="absolute top-4 right-4 bg-black/50 backdrop-blur px-4 py-2 rounded-full text-white text-sm">
            🖱️ Arraste para rotacionar
          </div>
        </div>

        {/* Controles */}
        <div className="space-y-8">
          <div>
            <h2 className="text-5xl font-black text-white mb-4">
              {activeProduct === 'sneaker' ? 'Air Motion' : 'Chrono Elite'}
            </h2>
            <p className="text-3xl text-purple-400 font-bold">
              {currentProduct.price}
            </p>
          </div>

          {/* Seletor de produto */}
          <div className="flex gap-4">
            {Object.keys(productConfigs).map((product) => (
              <button
                key={product}
                onClick={() => setActiveProduct(product)}
                className={`px-6 py-3 rounded-full capitalize transition-all ${
                  activeProduct === product
                    ? 'bg-white text-black'
                    : 'bg-white/10 text-white hover:bg-white/20'
                }`}
              >
                {product}
              </button>
            ))}
          </div>

          {/* Seletor de cor */}
          <div>
            <label className="text-white/70 text-sm mb-3 block">Cor</label>
            <div className="flex gap-3">
              {currentProduct.colors.map((color, index) => (
                <button
                  key={color}
                  onClick={() => handleColorChange(index)}
                  className={`w-12 h-12 rounded-full border-4 transition-all ${
                    activeColor === index 
                      ? 'border-white scale-110' 
                      : 'border-transparent hover:scale-105'
                  }`}
                  style={{ backgroundColor: color }}
                />
              ))}
            </div>
          </div>

          <button className="w-full py-4 bg-gradient-to-r from-purple-500 to-pink-500 text-white font-bold rounded-full text-lg hover:opacity-90 transition-opacity">
            Adicionar ao Carrinho
          </button>
        </div>
      </div>
    </section>
  );
}
```

### 3. Background 3D Animado
```tsx
"use client";

import Spline from '@splinetool/react-spline';
import { motion } from 'framer-motion';

export function Background3D() {
  return (
    <div className="relative min-h-screen overflow-hidden">
      {/* Spline como background fixo */}
      <div className="fixed inset-0 -z-10">
        <Spline 
          scene="https://prod.spline.design/abstract-bg/scene.splinecode"
          className="w-full h-full"
        />
      </div>
      
      {/* Conteúdo que scrolla sobre */}
      <div className="relative z-10">
        <section className="h-screen flex items-center justify-center">
          <motion.h1 
            initial={{ opacity: 0, y: 50 }}
            whileInView={{ opacity: 1, y: 0 }}
            className="text-8xl font-black text-white text-center"
          >
            SEÇÃO 1
          </motion.h1>
        </section>
        
        <section className="h-screen flex items-center justify-center bg-black/50 backdrop-blur-sm">
          <motion.h1 
            initial={{ opacity: 0, y: 50 }}
            whileInView={{ opacity: 1, y: 0 }}
            className="text-8xl font-black text-white text-center"
          >
            SEÇÃO 2
          </motion.h1>
        </section>
      </div>
    </div>
  );
}
```

---

## ⚡ OTIMIZAÇÃO E PERFORMANCE

### Lazy Loading
```tsx
import dynamic from 'next/dynamic';

const SplineScene = dynamic(
  () => import('@/components/spline/spline-scene').then(mod => mod.SplineScene),
  { 
    ssr: false,
    loading: () => <div className="w-full h-full bg-gray-900 animate-pulse" />
  }
);
```

### Intersection Observer (Carregar apenas quando visível)
```tsx
"use client";

import { useEffect, useRef, useState } from 'react';
import Spline from '@splinetool/react-spline';

export function LazySpline({ scene }: { scene: string }) {
  const ref = useRef<HTMLDivElement>(null);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const observer = new IntersectionObserver(
      ([entry]) => {
        if (entry.isIntersecting) {
          setIsVisible(true);
          observer.disconnect();
        }
      },
      { threshold: 0.1 }
    );

    if (ref.current) observer.observe(ref.current);
    return () => observer.disconnect();
  }, []);

  return (
    <div ref={ref} className="w-full h-[600px]">
      {isVisible ? (
        <Spline scene={scene} />
      ) : (
        <div className="w-full h-full bg-gray-900 flex items-center justify-center">
          <span className="text-white/50">Carregando 3D...</span>
        </div>
      )}
    </div>
  );
}
```

### Redução de Qualidade em Mobile
```tsx
"use client";

import { useEffect, useState } from 'react';
import Spline from '@splinetool/react-spline';

export function AdaptiveSpline({ scene }: { scene: string }) {
  const [quality, setQuality] = useState<'high' | 'low'>('high');

  useEffect(() => {
    const checkPerformance = () => {
      const isMobile = window.matchMedia('(pointer: coarse)').matches;
      const isLowPower = navigator.hardwareConcurrency <= 4;
      
      if (isMobile || isLowPower) {
        setQuality('low');
      }
    };
    
    checkPerformance();
  }, []);

  // URL com qualidade reduzida (versão otimizada da cena)
  const optimizedScene = quality === 'low' 
    ? scene.replace('scene.splinecode', 'scene-mobile.splinecode')
    : scene;

  return <Spline scene={optimizedScene} />;
}
```

---

## 🐛 DEBUG E TRATAMENTO DE ERROS

### Error Boundary para Spline
```tsx
// components/spline/spline-error-boundary.tsx
"use client";

import { Component, ReactNode } from 'react';

interface Props {
  children: ReactNode;
  fallback?: ReactNode;
}

interface State {
  hasError: boolean;
}

export class SplineErrorBoundary extends Component<Props, State> {
  constructor(props: Props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError(): State {
    return { hasError: true };
  }

  componentDidCatch(error: Error) {
    console.error('Spline failed to load:', error);
  }

  render() {
    if (this.state.hasError) {
      return this.props.fallback || (
        <div className="w-full h-full bg-gray-900 flex items-center justify-center">
          <p className="text-white">Não foi possível carregar a cena 3D</p>
        </div>
      );
    }

    return this.props.children;
  }
}

// Uso
<SplineErrorBoundary fallback={<StaticImageFallback />}>
  <SplineScene scene="..." />
</SplineErrorBoundary>
```

---

## 📋 CHECKLIST SPLINE

Antes de publicar:

- [ ] Cena otimizada no Spline (polígonos reduzidos se necessário)
- [ ] Lazy loading implementado
- [ ] Fallback para erro de WebGL
- [ ] Versão mobile otimizada (cena separada se necessário)
- [ ] Loading state customizado
- [ ] Eventos de interação funcionando
- [ ] Testado em Safari (WebGL 2.0)
- [ ] Memory leaks verificados (dispose no unmount)

---

## 🎯 QUANDO USAR SPLINE?

```
Preciso de 3D na landing?
│
├─ Objeto simples (cubo, esfera) com interação básica?
│  └─ Use CSS 3D transforms (mais leve)
│
├─ Produto complexo com texturas e animações?
│  ├─ Precisa de colaboração em tempo real?
│  │  └─ Spline (ideal)
│  ├─ Precisa de física realista?
│  │  └─ Three.js + React Three Fiber
│  └─ Já tem o modelo 3D pronto?
│     └─ Three.js (mais controle)
│
├─ Background abstrato animado?
│  └─ Spline (cenas leves) ou Shaders (mais performance)
│
└─ Jogo/Experiência interativa complexa?
   └─ Unity WebGL ou Three.js (Spline é limitado para jogos)
```

---

## RECURSOS

- **Documentação**: https://docs.spline.design
- **Exemplos**: https://github.com/splinetool/examples
- **Community**: https://discord.gg/spline
- **Preços**: https://spline.design/pricing (Free tier disponível)

---

> **Dica Pro**: Sempre exporte versões "Lite" das suas cenas para mobile. O Spline é poderoso mas WebGL consome bateria. Ofereça fallback estático para usuários com `prefers-reduced-motion`.
```



### Como usar no IDX:

Adicione à sua `.cursorrules`:

## Animações e Motion Design

Sempre consultar antes de criar animações:
1. `06_animations/animation_mastery.md` - Decisão de qual biblioteca usar
2. `06_animations/spline_integration.md` - Se precisar de 3D
3. `06_animations/gsap_scrolltrigger.md` - Se precisar de scroll complexo

Regras:
- Preferir Framer Motion para 90% das animações
- Usar Spline apenas para 3D interativo real
- Usar GSAP apenas para pinning ou timelines complexas
- Sempre implementar reduced-motion
- Sempre fazer cleanup das animações
```

Agora sua IA do IDX tem um **"cérebro de motion design"** completo baseado nas melhores referências do mercado! 🚀