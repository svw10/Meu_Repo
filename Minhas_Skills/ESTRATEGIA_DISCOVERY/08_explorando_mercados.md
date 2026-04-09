---
name: explorando_mercados
framework: "Antigravity OS v3.1"
owner_agent: EPSILON
trigger: "/explore"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: explorando-mercados
description: Estrategista de Negócios. Analisa nichos, concorrentes e viabilidade econômica antes de investir em código. Validação de mercado data-driven.
version: 3.0.1
tags: [negocios, estrategia, mercado, concorrentes, viabilidade, discovery]
---

# 08 - EXPLORANDO MERCADOS (Market Intelligence Protocol)

## 🎯 Quando usar
- **Antes de** `01_brainstorming` quando ideia é nova/inesplorada
- Usuário diz: "Quero criar um...", "Será que tem mercado para...", "Como meus concorrentes..."
- Para validar se problema vale ser resolvido (tamanho do mercado)
- Para definir posicionamento diferenciado (gap analysis)

> **Regra de Ouro**: Se não encontrar concorrente, cuidado. Ou é gênio, ou não existe mercado.

## 🧠 Mentalidade (Sherlock Holmes de Negócios)

| Princípio | Aplicação |
|:---|:---|
| **Ceticismo Saudável** | "Eu acho" ≠ evidência. Dados > Opiniões. |
| **Siga o Dinheiro** | Concorrente pagando anúncio = mercado existe. |
| **Dores Reais** | 1 estrela em review > 5 estrelas (sabe o que falta). |
| **Não ser primeiro** | Ser melhor/barato/rápido > ser pioneiro. |

## 🛠️ Ferramentas de Investigação

| Ferramenta | Uso | O que buscar |
|:---|:---|:---|
| **Google Trends** | Validar tendência | Crescimento/queda de interesse (5 anos) |
| **Reclame Aqui** | Dores reais | Falhas recorrentes de concorrentes |
| **Reddit/YouTube** | Voz do cliente | Reviews honestos, "por que mudei" |
| **Facebook Ad Library** | Inteligência de anúncios | Criativos ativos, mensagens que usam |
| **LinkedIn** | Tamanho da empresa | Número de funcionários, crescimento |
| **App Store Reviews** | Falhas de produto | 1 estrela: o que quebra? |
| **SimilarWeb** | Tráfego estimado | Quanta gente visita concorrente? |

## ⚙️ Processo de Investigação (3 Fases)

### Fase 1: Mapeamento de Terreno (TAM/SAM/SOM)

**TAM** (Total Addressable Market): Toda a demanda teórica
- Ex: "Mercado de software de automação no Brasil = R$ 5B/ano"

**SAM** (Serviceable Addressable Market): O que você pode atingir
- Ex: "Automação para pequenas empresas de e-commerce = R$ 500M/ano"

**SOM** (Serviceable Obtainable Market): O que você pode capturar em 3 anos
- Ex: "10% do SAM = R$ 50M/ano (realista com nosso modelo)"

**Verificação de Saturação:**
- 🔴 **Oceano Vermelho**: Muitos concorrentes, preço baixo, sangue na água
- 🔵 **Oceano Azul**: Poucos players, diferenciação possível, margem boa

### Fase 2: Espionagem Industrial Ética (Competidores)

**Lista 3 diretos + 3 indiretos:**

| Concorrente | Tipo | O que vendem | Preço | Big Idea | Gap Identificado |
|:---|:---:|:---|:---|:---|:---|
| [Nome] | Direto | [Produto] | [R$ X] | [Promessa única] | [O que falta?] |
| [Nome] | Indireto | [Alternativa] | [R$ Y] | [Posicionamento] | [Fraqueza] |

**Engenharia Reversa de Oferta:**
1. **Landing page**: Qual a headline? CTA principal?
2. **Pricing**: Freemium? Tiered? Enterprise-only?
3. **Features**: O que destacam? O que escondem?
4. **Dores**: Quais problemas eles prometem resolver?

**Gap Analysis (Oportunidade):**
- Suporte ruim? → Diferenciar com atendimento premium
- Software lento? → Diferenciar com performance
- Sem mobile? → Diferenciar com app nativo
- Preço alto? → Diferenciar com modelo freemium

### Fase 3: Definição do ICP (Ideal Customer Profile)

**Quem tem a dor de dente AGORA?**

```markdown
**ICP - [Nome do Segmento]**

- **Cargo/Título:** [Ex: Gerente de Operações de E-commerce]
- **Setor:** [Ex: Varejo online, moda, eletrônicos]
- **Tamanho da empresa:** [Ex: 10-50 funcionários, R$ 1-10M faturamento]
- **Dor Urgente:** [Ex: "Perdemos 20% de vendas por falta de estoque"]
- **Gatilho de compra:** [Ex: Black Friday chegando, precisa de automação]
- **Onde encontram:** [Ex: Grupos de Shopify no Facebook, eventos de e-commerce]
- **Concorrente atual:** [Ex: Planilha Excel + WhatsApp manual]
```

## 📄 Output: The Market Brief

**Arquivo:** `docs/MARKET-[nome-do-nicho].md`

```markdown
# Market Brief: [Nome do Nicho/Mercado]
**Data:** YYYY-MM-DD  
**Analista:** [Agente/Usuário]  
**Status:** 🟢 Go / 🟡 Cuidado / 🔴 No-Go

---

## 1. Resumo Executivo

**Veredito:** [Go / No-Go / Cuidado]  
**Justificativa (1 frase):** [Ex: "Mercado crescente (+40%/ano) com concorrentes lentos e suporte ruim"]

---

## 2. Tamanho do Mercado (TAM/SAM/SOM)

| Métrica | Valor | Fonte/Cálculo |
|:---|:---|:---|
| TAM | R$ X / ano | Dados de [IBGE/ABComm/etc] |
| SAM | R$ Y / ano | [Segmento específico] |
| SOM (3 anos) | R$ Z / ano | 10% do SAM (realista) |

**Tendência:** 📈 Crescendo / 📉 Caindo / ➡️ Estável  
**Evidência:** [Google Trends screenshot, relatório setorial]

---

## 3. Análise Competitiva

### Concorrentes Diretos
| Empresa | Receita Est. | Funcionários | Nossa Vantagem |
|:---|:---|:---|:---|
| [A] | R$ X | Y | [Mais rápido/barato] |
| [B] | R$ X | Y | [Melhor UX] |

### Concorrentes Indiretos (Alternativas)
- [Planilha Excel]: Gratuito, mas manual e propenso a erro
- [Software genérico]: Caro, não especializado no nicho

### Gap de Mercado (Oportunidade)
**O que ninguém faz bem:**
1. [Ex: Integração nativa com WhatsApp Business]
2. [Ex: Previsão de demanda com IA]
3. [Ex: Suporte em português com SLA]

---

## 4. Ideal Customer Profile (ICP)

**Segmento principal:** [Descrição]

| Atributo | Definição |
|:---|:---|
| Cargo | [Ex: Gerente de Ops] |
| Setor | [Ex: E-commerce de moda] |
| Tamanho | [Ex: 20-100 funcionários] |
| Dor urgente | [Ex: "Perdemos vendas por falta de estoque"] |
| Gatilho de compra | [Ex: Black Friday, alta temporada] |
| Budget disponível | [Ex: R$ 500-2000/mês] |

**Citação representativa:**  
*"Eu gasto 4 horas por dia atualizando planilha de estoque. Se der erro, perco a noite toda consertando."*  
— [Fonte: Reclame Aqui / Reddit / Entrevista]

---

## 5. Riscos e Mitigações

| Risco | Probabilidade | Impacto | Mitigação |
|:---|:---:|:---:|:---|
| [Ex: Concorrente grande entrar no nicho] | Média | Alto | Diferenciação local/suporte |
| [Ex: Regulação mudar] | Baixa | Alto | Compliance desde o início |
| [Ex: Dependência de plataforma] | Alta | Médio | Multi-tenant desde o início |

---

## 6. Recomendação Estratégica

### Se GO:
- **Posicionamento:** [Ex: "Automação de estoque para e-commerce de moda"]
- **Diferencial:** [Ex: "Setup em 5 minutos, não 5 dias"]
- **Primeiro passo:** [Ex: Landing page + waitlist para validar demanda]

### Se NO-GO:
- **Motivo principal:** [Ex: "Mercado muito pequeno, SAM < R$ 10M"]
- **Alternativa sugerida:** [Ex: "Pivotar para nicho adjacente: logística"]

### Se CUIDADO:
- **O que precisa validar:** [Ex: "Entrevistar 10 potenciais clientes"]
- **Experimentos rápidos:** [Ex: "Landing page falsa, medir conversão"]

---

## 7. Inputs para Brainstorming

**Insights para `01_brainstorming`:**
- Problema validado: [Sim/Não]
- Concorrentes a vencer: [Lista]
- Diferencial sugerido: [Descrição]
- ICP definido: [Perfil]

**Próxima skill:** `01_brainstorming` (se GO) ou nova análise (se NO-GO)
```

## 🛠️ Scripts de Apoio

### market_research_checklist.sh
```bash
#!/bin/bash
# Checklist rápido de pesquisa de mercado

echo "🔍 Market Research Checklist"
echo "=========================="
echo ""

echo "1. Google Trends"
echo "   Acesse: https://trends.google.com"
echo "   Busque: [termo principal do nicho]"
echo "   Verifique: Últimos 5 anos, região: Brasil"
echo ""

echo "2. Concorrentes (Diretos)"
echo "   Busque no Google: [termo] + 'software' + 'plataforma'"
echo "   Liste os 3 primeiros resultados pagos"
echo ""

echo "3. Reclame Aqui"
echo "   Acesse: https://www.reclameaqui.com.br"
echo "   Busque: [nome do concorrente 1]"
echo "   Anote: 3 reclamações recorrentes"
echo ""

echo "4. Facebook Ad Library"
echo "   Acesse: https://www.facebook.com/ads/library"
echo "   Busque: [nome do concorrente]"
echo "   Anote: Quantos anúncios ativos? Qual a mensagem?"
echo ""

echo "5. LinkedIn"
echo "   Busque: [concorrente] → Sobre → Tamanho da empresa"
echo "   Anote: Funcionários, crescimento, funding"
echo ""

echo "=========================="
echo "Preencha o Market Brief com os dados coletados."
```

### competitor_analysis_template.md
```markdown
## Análise de Concorrente: [Nome]

### Informações Básicas
- **Website:** [URL]
- **Fundação:** [Ano]
- **Funcionários:** [Número - LinkedIn]
- **Funding:** [Se disponível - Crunchbase]

### Oferta
- **Produto principal:** [Descrição]
- **Preço:** [Tier 1 / Tier 2 / Tier 3]
- **Modelo:** [SaaS / Licença / Freemium]

### Análise de Marketing
- **Headline site:** [Texto principal]
- **CTA:** [Botão principal]
- **Diferencial anunciado:** [Promessa única]

### Pontos Fortes
1. [Ex: Marca forte, tempo no mercado]
2. [Ex: Integrações prontas]

### Pontos Fracos (Nossa Oportunidade)
1. [Ex: Suporte lento - demora 2 dias para responder]
2. [Ex: Preço alto - R$ 5k/mês para pequenas empresas]
3. [Ex: Não tem app mobile]

### Screenshots
- [Homepage]
- [Pricing page]
- [Dashboard login]
```

## 🚫 Anti-Padrões

- ❌ "Não tem concorrente" (suspeito, investigar mais)
- ❌ Ignorar concorrente indireto (Excel mata mais SaaS que startups)
- ❌ TAM muito grande (sem foco, não executável)
- ❌ ICP vago ("qualquer empresa" = ninguém)
- ❌ Análise sem dados (só opinião)
- ❌ Não validar com clientes reais (entrevistas)

## ✅ Checklist de Qualidade

- [ ] TAM/SAM/SOM calculados com fontes
- [ ] 3+ concorrentes diretos analisados
- [ ] 3+ concorrentes indiretos mapeados
- [ ] Gap de mercado identificado (oportunidade)
- [ ] ICP definido com dor urgente específica
- [ ] Market Brief preenchido
- [ ] Veredito Go/No-Go/Cuidado justificado
- [ ] Inputs para `01_brainstorming` documentados

## 🔗 Integração

- **Chamada:** Direta pelo ROUTER (quando ideia nova/estratégica)
- **Pré-requisito:** Nenhum (pode ser primeira skill)
- **Próxima (Go):** `01_brainstorming` (transferir insights para SPEC)
- **Próxima (No-Go):** Nova análise ou pivot
- **Próxima (Cuidado):** Experimentos de validação rápida
- **Artefato:** `docs/MARKET-[nicho].md`

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Estrutura integrada com fluxo de discovery
- Template Market Brief padronizado
- Adicionado conexão com `01_brainstorming`
- Scripts de apoio (checklist, template de análise)
- Foco em decisão Go/No-Go/Cuidado

### v3.5.0 (Original)
- Protocolo de inteligência de mercado
- Ferramentas práticas de investigação
- Mentalidade data-driven
- Output acionável (Market Brief)
```


---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
