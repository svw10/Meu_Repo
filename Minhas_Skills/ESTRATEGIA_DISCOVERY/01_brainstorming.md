---
name: brainstorming
framework: "Antigravity OS v3.1"
owner_agent: EPSILON
trigger: "/brainstorm"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: brainstorming
description: PM. Transforma intenções vagas em especificações determinísticas. Define O Que, Por Que e Como antes do Planejamento Técnico.
version: 3.0.1
tags: [produto, discovery, entropia, especificacao, mvp]
---

# 01 - BRAINSTORMING ESTRUTURADO (Entropy Compression)

## 🎯 Quando usar
- Usuário diz: "Quero algo para...", "Preciso melhorar X", "Tenho uma ideia vaga"
- Intenção carece de escopo, métricas ou público definido
- Alta Entropia Conceitual (muitas interpretações possíveis)
- Antes de escrever código ou plano técnico

> **Regra Obrigatória**: Se intenção não for clara o suficiente para gerar plano atômico imediato, invocar esta skill **antes** de `02_planejando_solucoes`.

## 🧱 Reality Check (Stack Omega)

Toda ideia filtrada pela Stack Omega v3.0:

| Intenção | Stack Omega |
|:---|:---|
| "Armazenar dados" | Neon + Drizzle |
| "Automação de filas" | Inngest |
| "Interface web" | Next.js 14+ + Shadcn |
| "WhatsApp Business" | Evolution API |
| "Auth" | Clerk |
| "IA/LLM" | OpenRouter + Vercel AI SDK |

> Stack é imutável durante projeto. Sem exceções sem ADR aprovado por BETA.

## ⚙️ Fluxo de Trabalho (4 Passos)

### Passo 1: Extração da Intenção (5 min)
- Identificar dor real (5 Whys)
- Documentar: Quem? Quando? Impacto?

**Template:**
```
Problema: [Uma frase]
Quem: [Persona]
Quando: [Contexto]
Impacto: [Custo da dor]
```

### Passo 2: Compressão de Entropia (10 min)
Gerar **3 caminhos possíveis**:

| Caminho | Descrição | Quando usar |
|:---|:---|:---|
| **MVP** | Simples, resolve 80% | Prazo curto, validação rápida |
| **Ideal** | Completo, robusto, escalável | Recursos disponíveis, longo prazo |
| **IA-Native** | Só possível com IA/LLM | Diferencial competitivo, automação total |

**Critério:** Aderência Stack Omega + Viabilidade técnica + Valor de negócio

### Passo 3: Critérios Binários (5 min)
Transformar desejos vagos em métricas objetivas:

| Desejo vago | Critério binário (Sim/Não) |
|:---|:---|
| "Funciona bem" | "Tempo de resposta < 200ms" |
| "Fácil de usar" | "Completa em < 3 cliques" |
| "Seguro" | "Zero dados sensíveis em logs" |
| "Escalável" | "Suporta 1000 req/min" |

**Mínimo:** 3 critérios binários por especificação.

### Passo 4: Especificação Canônica (10 min)
Gerar `docs/SPEC-[nome].md` usando template abaixo.

**Este arquivo é gatilho obrigatório** para skill `02_planejando_solucoes`.

## 📋 Checklist de Saída (DoD)

- [ ] Intenção original capturada
- [ ] 3 caminhos explorados e documentados
- [ ] Caminho selecionado justificado
- [ ] 3+ critérios binários definidos
- [ ] Solução viável na Stack Omega
- [ ] Template SPEC preenchido
- [ ] Próxima skill definida (`02_planejando_solucoes`)

## 🌍 Exemplos por Contexto

### Exemplo: "Sistema de créditos"
```
Intenção: Controlar quantas imagens cada lojista pode gerar

MVP: Campo 'credits' na tabela tenants, decrementa a cada geração, bloqueia em zero
Ideal: Quotas mensais + Overage Stripe + Alertas 80%/100%
IA-Native: Predição ML + Upsell automático + Preços dinâmicos

Selecionado: MVP (validar modelo primeiro)

Critérios binários:
- [ ] Decrementa 1 crédito por imagem gerada
- [ ] Bloqueia quando credits = 0
- [ ] Mostra créditos restantes no dashboard
```

## 📄 Template SPEC

**Arquivo:** `docs/SPEC-[nome].md`

```markdown
# SPEC: [Nome da Iniciativa]
**Status:** 🟡 Discovery | **Data:** YYYY-MM-DD

## 1. O Problema
[Quem sofre? Quando? Qual custo?]

## 2. A Solução (Caminho Selecionado)
**Escolhido:** [MVP/Ideal/IA-Native]  
**Justificativa:** [Por que este?]

## 3. Alternativas Consideradas
| Caminho | Por que não? |
|:---|:---|
| [Alt 1] | [Razão] |
| [Alt 2] | [Razão] |

## 4. Critérios de Sucesso (Binários)
- [ ] [Critério 1 - mensurável]
- [ ] [Critério 2 - mensurável]
- [ ] [Critério 3 - mensurável]

## 5. User Stories
- [ ] **US-01**: Como [persona], quero [ação], para [benefício]
  - Critério: [Definição de pronto]

## 6. Restrições & Fallbacks
- Se [risco] → [contingência]

## 7. Próximos Passos
- [ ] Revisão stakeholders → `02_planejando_solucoes`
```

## 🚫 Anti-Padrões

- ❌ Especificação sem critérios binários
- ❌ Apenas 1 caminho explorado
- ❌ User Stories sem critérios de aceite
- ❌ Sem restrições/fallbacks
- ❌ Hardcode de stack sem validar Stack Omega

## 🔗 Integração

- **Chamada:** Direta pelo ROUTER quando intenção é vaga
- **Próxima:** `02_planejando_solucoes` (após SPEC aprovado)
- **Depende:** Stack Omega (definida em `CURRENT_AGENT.md`)

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Ajustado para estrutura v3.0 (sem `project-context.json`)
- Simplificada integração (ROUTER → skill direto)
- Removidos scripts Python (movidos para `RECURSOS/scripts/`)
- Foco em Stack Omega imutável

### v3.0.0 (Original)
- Conceito de compressão de entropia
- 3 caminhos (MVP, Ideal, IA-Native)
- Template SPEC completo
```

---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
