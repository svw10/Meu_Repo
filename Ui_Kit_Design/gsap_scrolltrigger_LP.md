name: gsap-scrolltrigger
description: Animações de timeline complexas, pinning e scroll-scrubbing com GSAP ScrollTrigger. Para narrativas visuais avançadas.
version: 4.0.0
tags: [gsap, scrolltrigger, pinning, scrub, timeline, advanced]
---

# GSAP SCROLLTRIGGER - Animações de Timeline Complexas

> **Filosofia**: O scroll é o playback. O usuário controla o tempo da narrativa.

---

## 🎯 ÍNDICE DE TÉCNICAS

| Técnica | Complexidade | Uso Típico | Performance |
|---------|-------------|------------|-------------|
| **Scrub** | Média | Animações ligadas ao scroll | Alta |
| **Pin** | Alta | Seções que "travam" na tela | Média |
| **Timeline** | Alta | Sequências complexas | Média |
| **Snap** | Alta | Scroll que "encaixa" em seções | Baixa |
| **Parallax Layers** | Baixa | Profundidade visual | Alta |

---

## 🚀 SETUP INICIAL

Instalação:
```bash
npm install gsap @gsap/react
Provider Global:
tsx
Copy
// app/providers/gsap-provider.tsx
"use client";

import { useEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';
import { ScrollSmoother } from 'gsap/ScrollSmoother'; // Plugin pago, opcional

// Registrar plugins
gsap.registerPlugin(ScrollTrigger);

export function GSAPProvider({ children }: { children: React.ReactNode }) {
  useEffect(() => {
    // Refresh após carregamento de fontes/imagens
    document.fonts.ready.then(() => {
      ScrollTrigger.refresh();
    });
    
    return () => {
      ScrollTrigger.getAll().forEach(trigger => trigger.kill());
    };
  }, []);

  return <>{children}</>;
}
Hook useGSAP:
tsx
Copy
// hooks/useGsap.ts
import { useEffect, useRef } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function useGsap(
  callback: (ctx: gsap.Context) => void,
  deps: any[] = []
) {
  const ref = useRef<HTMLDivElement>(null);
  const ctxRef = useRef<gsap.Context | null>(null);

  useEffect(() => {
    if (!ref.current) return;
    
    ctxRef.current = gsap.context(() => {
      callback(ctxRef.current!);
    }, ref);

    return () => ctxRef.current?.revert();
  }, deps);

  return ref;
}
🎬 TÉCNICA 1: SCRUB (Scroll-Linked Animation)
Animações que respondem diretamente à posição do scroll.
Básico
tsx
Copy
"use client";

import { useRef, useLayoutEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function ScrubBasic() {
  const containerRef = useRef<HTMLDivElement>(null);
  const boxRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      gsap.to(boxRef.current, {
        x: 500,
        rotation: 360,
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top center",
          end: "bottom center",
          scrub: 1, // 1 segundo de suavização
          markers: true, // Debug (remover em produção)
        }
      });
    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <div ref={containerRef} className="h-[200vh] bg-gray-900">
      <div className="h-screen flex items-center justify-center sticky top-0">
        <div 
          ref={boxRef}
          className="w-32 h-32 bg-purple-500 rounded-lg"
        />
      </div>
    </div>
  );
}
Scrub com Múltiplos Elementos
tsx
Copy
"use client";

import { useRef, useLayoutEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function ScrubComplex() {
  const sectionRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      // Timeline com scrub
      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: sectionRef.current,
          start: "top top",
          end: "+=2000", // 2000px de scroll
          scrub: 0.5,
          pin: true, // Fixa a seção
          anticipatePin: 1, // Suaviza o pinning
        }
      });

      // Sequência de animações
      tl.from(".title", { y: 100, opacity: 0, duration: 1 })
        .from(".subtitle", { y: 50, opacity: 0, duration: 0.8 }, "-=0.5")
        .to(".image-1", { scale: 1.2, rotation: 5, duration: 1 }, "-=0.3")
        .from(".image-2", { x: 200, opacity: 0, duration: 1 }, "-=0.5")
        .to(".overlay", { opacity: 0.8, duration: 0.5 }, "-=0.3");

    }, sectionRef);

    return () => ctx.revert();
  }, []);

  return (
    <section ref={sectionRef} className="h-screen bg-black overflow-hidden relative">
      <div className="absolute inset-0 flex flex-col items-center justify-center text-white z-10">
        <h1 className="title text-7xl font-black">TÍTULO</h1>
        <p className="subtitle text-2xl mt-4">Subtítulo aparece depois</p>
      </div>
      
      <img 
        src="/image1.jpg" 
        alt="" 
        className="image-1 absolute inset-0 w-full h-full object-cover opacity-50"
      />
      <img 
        src="/image2.png" 
        alt="" 
        className="image-2 absolute right-0 bottom-0 w-1/2 h-auto"
      />
      <div className="overlay absolute inset-0 bg-purple-900/0" />
    </section>
  );
}
📌 TÉCNICA 2: PINNING (Fixar Elementos)
Fixa elementos na tela enquanto o scroll continua.
Pin Simples
tsx
Copy
"use client";

import { useLayoutEffect, useRef } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function PinSimple() {
  const containerRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      ScrollTrigger.create({
        trigger: ".pin-section",
        start: "top top",
        end: "+=1000", // Pin por 1000px de scroll
        pin: true,
        pinSpacing: true, // Mantém espaço do elemento
      });
    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <div ref={containerRef}>
      <section className="h-screen bg-blue-500 flex items-center justify-center">
        <h2 className="text-4xl text-white">Seção Normal</h2>
      </section>
      
      <section className="pin-section h-screen bg-red-500 flex items-center justify-center">
        <h2 className="text-4xl text-white">Esta seção vai PINNAR</h2>
      </section>
      
      <section className="h-screen bg-green-500 flex items-center justify-center">
        <h2 className="text-4xl text-white">Próxima seção</h2>
      </section>
    </div>
  );
}
Pin com Mudança de Conteúdo (Scrollytelling Avançado)
tsx
Copy
"use client";

import { useRef, useLayoutEffect, useState } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

const steps = [
  {
    id: 1,
    title: "Descoberta",
    description: "Entendemos seu problema profundamente",
    color: "bg-purple-600"
  },
  {
    id: 2,
    title: "Estratégia",
    description: "Criamos o plano perfeito",
    color: "bg-blue-600"
  },
  {
    id: 3,
    title: "Execução",
    description: "Implementamos com excelência",
    color: "bg-green-600"
  }
];

export function PinScrollytelling() {
  const containerRef = useRef<HTMLDivElement>(null);
  const [activeStep, setActiveStep] = useState(0);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      const tl = gsap.timeline({
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top top",
          end: "+=3000",
          pin: true,
          scrub: 1,
          onUpdate: (self) => {
            const progress = self.progress;
            const newStep = Math.min(
              Math.floor(progress * steps.length),
              steps.length - 1
            );
            setActiveStep(newStep);
          }
        }
      });

      // Animações entre steps
      steps.forEach((_, index) => {
        if (index < steps.length - 1) {
          tl.to(`.step-${index}`, { opacity: 0, y: -50, duration: 0.5 })
            .from(`.step-${index + 1}`, { opacity: 0, y: 50, duration: 0.5 }, "-=0.3");
        }
      });

    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <div ref={containerRef} className="h-screen bg-gray-900 relative overflow-hidden">
      {/* Progresso lateral */}
      <div className="absolute left-8 top-1/2 -translate-y-1/2 z-20 space-y-4">
        {steps.map((step, index) => (
          <div 
            key={step.id}
            className={`w-3 h-12 rounded-full transition-all duration-300 ${
              index === activeStep ? 'bg-white' : 'bg-white/30'
            }`}
          />
        ))}
      </div>

      {/* Conteúdo que muda */}
      <div className="h-full flex items-center justify-center">
        {steps.map((step, index) => (
          <div
            key={step.id}
            className={`step-${index} absolute text-center text-white transition-all ${
              index === 0 ? 'opacity-100' : 'opacity-0'
            }`}
          >
            <div className={`w-32 h-32 ${step.color} rounded-2xl mx-auto mb-8 flex items-center justify-center text-4xl font-bold`}>
              0{step.id}
            </div>
            <h2 className="text-6xl font-black mb-4">{step.title}</h2>
            <p className="text-2xl text-white/70 max-w-md">{step.description}</p>
          </div>
        ))}
      </div>

      {/* Background animado */}
      <div className="absolute inset-0 -z-10">
        {steps.map((step, index) => (
          <div
            key={step.id}
            className={`absolute inset-0 ${step.color} transition-opacity duration-500 ${
              index === activeStep ? 'opacity-20' : 'opacity-0'
            }`}
          />
        ))}
      </div>
    </div>
  );
}
🎭 TÉCNICA 3: TIMELINE COMPLEXA (Cenas de Cinema)
Sequências narrativas elaboradas controladas pelo scroll.
tsx
Copy
"use client";

import { useRef, useLayoutEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function CinematicTimeline() {
  const containerRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      // Master Timeline
      const master = gsap.timeline({
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top top",
          end: "+=5000", // 5000px de narrativa
          pin: true,
          scrub: 0.8,
          snap: {
            snapTo: "labels", // Encaixa nos marcadores
            duration: { min: 0.2, max: 0.5 },
            ease: "power1.inOut"
          }
        }
      });

      // ATO 1: Introdução
      master.addLabel("intro")
        .from(".hero-title", { 
          scale: 3, 
          opacity: 0, 
          duration: 2,
          ease: "power2.out"
        })
        .from(".hero-subtitle", { 
          y: 100, 
          opacity: 0, 
          duration: 1 
        }, "-=1")
        .to(".hero-bg", { 
          scale: 1.1, 
          duration: 3 
        }, "-=2");

      // ATO 2: Revelação
      master.addLabel("reveal")
        .to(".hero-title", { 
          y: -200, 
          opacity: 0, 
          duration: 1 
        })
        .from(".feature-1", { 
          x: -window.innerWidth, 
          rotation: -30,
          duration: 1.5,
          ease: "power3.out"
        }, "-=0.5")
        .from(".feature-text-1", { 
          opacity: 0, 
          x: 100, 
          duration: 1 
        }, "-=1");

      // ATO 3: Confronto
      master.addLabel("conflict")
        .to(".feature-1", { 
          x: window.innerWidth, 
          opacity: 0, 
          duration: 1 
        })
        .from(".problem-card", { 
          scale: 0, 
          rotation: 180,
          stagger: 0.2,
          duration: 1.5,
          ease: "back.out(1.7)"
        }, "-=0.5");

      // ATO 4: Resolução
      master.addLabel("resolution")
        .to(".problem-card", { 
          y: -100, 
          opacity: 0, 
          stagger: 0.1,
          duration: 0.8 
        })
        .from(".solution-hero", { 
          scale: 0.5, 
          opacity: 0, 
          duration: 2,
          ease: "elastic.out(1, 0.5)"
        })
        .from(".cta-button", { 
          y: 50, 
          opacity: 0, 
          duration: 0.8 
        }, "-=1");

      // ATO 5: Conclusão
      master.addLabel("end")
        .to(".solution-hero", { 
          scale: 1.1, 
          duration: 2 
        })
        .to(".cta-button", { 
          scale: 1.1,
          boxShadow: "0 0 50px rgba(255,255,255,0.5)",
          repeat: -1,
          yoyo: true,
          duration: 0.5
        }, "-=1.5");

    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <div ref={containerRef} className="relative bg-black">
      {/* CENA 1: Hero */}
      <div className="hero-bg absolute inset-0 opacity-30">
        <div className="w-full h-full bg-gradient-to-br from-purple-900 to-black" />
      </div>
      
      <div className="relative h-screen flex flex-col items-center justify-center text-white">
        <h1 className="hero-title text-8xl font-black text-center">
          A JORNADA
        </h1>
        <p className="hero-subtitle text-2xl mt-6 text-white/70">
          Uma história em scroll
        </p>
      </div>

      {/* CENA 2: Feature */}
      <div className="feature-1 absolute top-1/2 left-20 -translate-y-1/2 w-96 h-96 bg-blue-500 rounded-3xl" />
      <div className="feature-text-1 absolute top-1/2 right-20 -translate-y-1/2 text-white max-w-lg">
        <h2 className="text-5xl font-bold">O Desafio</h2>
        <p className="text-xl mt-4 text-white/70">
          Enfrentamos problemas complexos que exigem soluções criativas.
        </p>
      </div>

      {/* CENA 3: Problemas */}
      <div className="absolute inset-0 flex items-center justify-center gap-8">
        {[1, 2, 3].map((i) => (
          <div 
            key={i}
            className={`problem-card w-64 h-80 bg-red-500/20 backdrop-blur rounded-2xl border border-red-500/50 p-6`}
          >
            <div className="text-6xl mb-4">⚠️</div>
            <h3 className="text-2xl font-bold text-white">Problema {i}</h3>
          </div>
        ))}
      </div>

      {/* CENA 4: Solução */}
      <div className="solution-hero absolute inset-0 flex items-center justify-center">
        <div className="text-center">
          <div className="w-48 h-48 bg-green-500 rounded-full mx-auto mb-8 flex items-center justify-center text-6xl">
            ✓
          </div>
          <h2 className="text-6xl font-black text-white">RESOLVIDO</h2>
          <button className="cta-button mt-8 px-12 py-4 bg-white text-black font-bold rounded-full text-xl">
            Começar Agora
          </button>
        </div>
      </div>
    </div>
  );
}
🎯 TÉCNICA 4: SNAP (Scroll Encaixado)
Faz o scroll "travar" em seções específicas.
tsx
Copy
"use client";

import { useEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function SnapSections() {
  useEffect(() => {
    // Aguardar todos os ScrollTriggers serem criados
    const timer = setTimeout(() => {
      const sections = gsap.utils.toArray<HTMLElement>(".snap-section");
      
      const maxScroll = ScrollTrigger.maxScroll(window);
      
      // Criar pontos de snap baseados nas seções
      const snapPoints = sections.map(section => {
        const st = ScrollTrigger.create({
          trigger: section,
          start: "top top"
        });
        return st.start / maxScroll;
      });

      ScrollTrigger.create({
        snap: {
          snapTo: (value) => {
            // Encontrar o ponto mais próximo
            const target = gsap.utils.snap(snapPoints, value);
            return target;
          },
          duration: { min: 0.15, max: 0.35 },
          ease: "power2.inOut",
          delay: 0 // Sem delay para responsividade
        }
      });
    }, 100);

    return () => {
      clearTimeout(timer);
      ScrollTrigger.getAll().forEach(st => st.kill());
    };
  }, []);

  return (
    <div>
      {['Seção 1', 'Seção 2', 'Seção 3', 'Seção 4'].map((title, i) => (
        <section 
          key={i}
          className="snap-section h-screen flex items-center justify-center text-6xl font-black"
          style={{ 
            backgroundColor: ['#ff6b6b', '#4ecdc4', '#45b7d1', '#f9ca24'][i] 
          }}
        >
          {title}
        </section>
      ))}
    </div>
  );
}
🎨 TÉCNICA 5: PARALLAX LAYERS
Múltiplas camadas se movendo em velocidades diferentes.
tsx
Copy
"use client";

import { useRef, useLayoutEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function ParallaxLayers() {
  const containerRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      // Layer 1: Background (lento)
      gsap.to(".layer-bg", {
        yPercent: 20,
        ease: "none",
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top bottom",
          end: "bottom top",
          scrub: true
        }
      });

      // Layer 2: Midground (médio)
      gsap.to(".layer-mid", {
        yPercent: 50,
        ease: "none",
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top bottom",
          end: "bottom top",
          scrub: true
        }
      });

      // Layer 3: Foreground (rápido)
      gsap.to(".layer-front", {
        yPercent: 100,
        ease: "none",
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top bottom",
          end: "bottom top",
          scrub: true
        }
      });

      // Texto com fade e parallax
      gsap.from(".parallax-text", {
        y: 100,
        opacity: 0,
        scrollTrigger: {
          trigger: ".parallax-text",
          start: "top 80%",
          end: "top 30%",
          scrub: true
        }
      });

    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <div ref={containerRef} className="relative h-[200vh] overflow-hidden bg-gray-900">
      {/* Background Layer */}
      <div className="layer-bg absolute inset-0">
        <div className="w-full h-full bg-gradient-to-b from-purple-900 to-black" />
      </div>

      {/* Midground Layer */}
      <div className="layer-mid absolute inset-0 flex items-center justify-center">
        <div className="w-96 h-96 bg-blue-500/30 rounded-full blur-3xl" />
      </div>

      {/* Foreground Layer */}
      <div className="layer-front absolute bottom-0 left-0 right-0 h-1/2">
        <div className="w-full h-full bg-gradient-to-t from-black to-transparent" />
      </div>

      {/* Conteúdo */}
      <div className="relative z-10 h-screen flex items-center justify-center">
        <h1 className="parallax-text text-7xl font-black text-white text-center">
          PROFUNDIDADE<br />VISUAL
        </h1>
      </div>
    </div>
  );
}
🎛️ UTILITÁRIOS AVANÇADOS
Horizontal Scroll
tsx
Copy
"use client";

import { useRef, useLayoutEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function HorizontalScroll() {
  const containerRef = useRef<HTMLDivElement>(null);
  const scrollRef = useRef<HTMLDivElement>(null);

  useLayoutEffect(() => {
    const ctx = gsap.context(() => {
      const scrollWidth = scrollRef.current!.scrollWidth;
      const viewportWidth = window.innerWidth;

      gsap.to(scrollRef.current, {
        x: -(scrollWidth - viewportWidth),
        ease: "none",
        scrollTrigger: {
          trigger: containerRef.current,
          start: "top top",
          end: () => `+=${scrollWidth}`,
          pin: true,
          scrub: 1,
          invalidateOnRefresh: true,
        }
      });
    }, containerRef);

    return () => ctx.revert();
  }, []);

  return (
    <div ref={containerRef} className="h-screen overflow-hidden bg-black">
      <div ref={scrollRef} className="flex h-full">
        {[1, 2, 3, 4, 5].map((i) => (
          <div 
            key={i}
            className="flex-shrink-0 w-screen h-full flex items-center justify-center"
            style={{ backgroundColor: `hsl(${i * 60}, 70%, 50%)` }}
          >
            <h2 className="text-8xl font-black text-white">SLIDE {i}</h2>
          </div>
        ))}
      </div>
    </div>
  );
}
Velocity-Based Skew (Deformação baseada em velocidade)
tsx
Copy
"use client";

import { useEffect, useRef } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function VelocitySkew() {
  const textRef = useRef<HTMLHeadingElement>(null);

  useEffect(() => {
    let skewSetter = gsap.quickSetter(textRef.current, "skewY", "deg");
    let proxy = { skew: 0 };
    let skewClamp = gsap.utils.clamp(-10, 10); // Limitar entre -10 e 10 graus
    
    ScrollTrigger.create({
      onUpdate: (self) => {
        let skew = skewClamp(self.getVelocity() / -300);
        if (Math.abs(skew) > Math.abs(proxy.skew)) {
          proxy.skew = skew;
          gsap.to(proxy, {
            skew: 0,
            duration: 0.8,
            ease: "power3",
            overwrite: true,
            onUpdate: () => skewSetter(proxy.skew)
          });
        }
      }
    });
  }, []);

  return (
    <div className="h-[300vh] bg-black flex items-center justify-center">
      <h1 
        ref={textRef}
        className="text-9xl font-black text-white will-change-transform"
      >
        VELOCIDADE
      </h1>
    </div>
  );
}
⚡ OTIMIZAÇÃO DE PERFORMANCE
Best Practices
yaml
Copy
DO:
  - Usar will-change: transform, opacity apenas em elementos animados
  - Preferir transform e opacity (GPU accelerated)
  - Usar scrub com valores suaves (0.5-1)
  - Kill ScrollTriggers no unmount
  - Usar invalidateOnRefresh para responsivo

DON'T:
  - Animar width, height, top, left (causa reflow)
  - Criar muitos ScrollTriggers simultâneos (limite: ~20)
  - Usar blur durante scroll (pesado)
  - Esquecer de usar context() para cleanup
Cleanup Robusto
tsx
Copy
"use client";

import { useEffect } from 'react';
import { gsap } from 'gsap';
import { ScrollTrigger } from 'gsap/ScrollTrigger';

export function SafeComponent() {
  useEffect(() => {
    const ctx = gsap.context(() => {
      // Suas animações aqui
    });

    // Cleanup completo
    return () => {
      ctx.revert(); // Mata todas as animações do contexto
      ScrollTrigger.getAll().forEach(st => {
        if (st.vars.trigger === ref.current) {
          st.kill();
        }
      });
    };
  }, []);

  return <div>...</div>;
}
MatchMedia (Responsivo)
tsx
Copy
useEffect(() => {
  const mm = gsap.matchMedia();

  // Desktop
  mm.add("(min-width: 1024px)", () => {
    gsap.to(".box", { x: 500 });
    return () => { /* cleanup */ };
  });

  // Mobile
  mm.add("(max-width: 1023px)", () => {
    gsap.to(".box", { x: 100 });
    return () => { /* cleanup */ };
  });

  return () => mm.revert();
}, []);
📋 CHECKLIST GSAP
[ ] Setup: Plugins registrados e provider configurado
[ ] Cleanup: ctx.revert() em todos os useEffect
[ ] Performance: Apenas transform/opacity animados
[ ] Responsivo: MatchMedia para breakpoints
[ ] Acessibilidade: Respeitar prefers-reduced-motion
[ ] Mobile: Touch events testados
[ ] SEO: Conteúdo visível sem JS
[ ] Debug: Markers removidos em produção
Reduced Motion
tsx
Copy
const prefersReducedMotion = 
  typeof window !== "undefined" && 
  window.matchMedia("(prefers-reduced-motion: reduce)").matches;

// Desativar ScrollTrigger se necessário
if (prefersReducedMotion) {
  ScrollTrigger.getAll().forEach(st => st.disable());
}
🎯 QUANDO USAR GSAP vs FRAMER MOTION?
plain
Copy
Preciso de animação...
│
├─ Baseada em scroll complexa?
│  ├─ Pinning de seções? → GSAP ScrollTrigger
│  ├─ Scrub com timeline? → GSAP ScrollTrigger
│  └─ Snap entre seções? → GSAP ScrollTrigger
│
├─ Transições de componentes?
│  └─ Framer Motion (AnimatePresence)
│
├─ Gestures (drag, pan, pinch)?
│  └─ Framer Motion (melhor API)
│
├─ Layout animations?
│  └─ Framer Motion (layout prop)
│
├─ Spring physics?
│  └─ Framer Motion (mais natural)
│
└─ Timeline sequencial complexa?
   └─ GSAP (mais poderoso)
RECURSOS
Documentação: https://greensock.com/docs
ScrollTrigger: https://greensock.com/scroll
Exemplos: https://greensock.com/showcase
Cheat Sheet: https://greensock.com/cheatsheet
Club GSAP: Plugins premium (ScrollSmoother, MorphSVG)
Dica Pro: GSAP é poderoso mas pesado. Use apenas quando Framer Motion não for suficiente. Para 90% das animações de scroll, Framer Motion + useScroll/useTransform são suficientes e mais "React-native".