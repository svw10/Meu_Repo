name: brainstorming
description: O Gerente de Produto (PM). Realiza compressão de entropia para transformar intenções vagas em especificações determinísticas. Define O Que, Por Que e Como antes do Planejamento Técnico.
version: 3.0.0
tags: [produto, discovery, entropia, especificacao, mvp, universal]
author: System Architect
---

# Brainstorming Estruturado (Entropy Compression Protocol)

## 🎯 Quando usar
- O usuário diz: "Quero algo para...", "Preciso melhorar X", "Tenho uma ideia vaga".
- A intenção carece de escopo, métricas ou público definido.
- Há **Alta Entropia Conceitual** (muitas interpretações possíveis para o mesmo pedido).
- Antes de escrever qualquer código ou plano técnico.

> **Regra Obrigatória**: Se a intenção não for clara o suficiente para gerar um plano atômico imediato, esta skill deve ser invocada **antes** de `planejando-solucoes`.

## 🧱 Reality Check (Alinhamento com Stack)

Toda ideia deve ser filtrada pela stack do projeto atual (definida em `project-context.json`):

**Exemplo para SnapFit:**
- "Quero armazenar dados" → **Neon + pgvector**
- "Quero automação de filas" → **Inngest**
- "Quero interface web" → **Next.js + Shadcn**
- "Quero WhatsApp Business" → **Evolution API**

**Exemplo para outro projeto:**
- "Quero armazenar dados" → **Supabase** (se definido no contexto)
- "Quero interface web" → **Vue + Nuxt** (se definido no contexto)

> **Princípio**: A stack é imutável durante o projeto, mas configurável entre projetos.

## ⚙️ Fluxo de Trabalho (Obrigatório)

### Passo 1: Extração da Intenção Bruta (5 min)
- Identificar a dor real por trás do pedido
- Perguntar: "Por que você quer isso?" (5 Whys)
- Documentar: Quem tem o problema? Quando acontece? Qual o impacto?

**Template de captura:**
```
Problema: [Descrição em uma frase]
Quem: [Persona]
Quando: [Contexto/Cenário]
Impacto: [Custo da dor atual]
```

### Passo 2: Compressão de Entropia (10 min)
Gerar **3 caminhos possíveis** para resolver:

| Caminho | Descrição | Quando usar |
|---------|-----------|-------------|
| **MVP (Mínimo)** | Solução mais simples que resolve 80% do problema | Prazo curto, validação rápida |
| **Ideal (Ótimo)** | Solução completa, robusta, escalável | Recursos disponíveis, visão longo prazo |
| **IA-Native (Inovador)** | Solução que só é possível com IA/LLM | Diferencial competitivo, automação total |

**Critério de seleção:** Aderência à stack + Viabilidade técnica + Valor de negócio

### Passo 3: Definição de Critérios Binários (5 min)
Transformar desejos vagos em métricas objetivas:

| Desejo vago | Critério binário (Sim/Não) |
|-------------|---------------------------|
| "Quero que funcione bem" | "Tempo de resposta < 200ms" |
| "Quero que seja fácil" | "Usuário completa em < 3 cliques" |
| "Quero que seja seguro" | "Zero dados sensíveis em logs" |
| "Quero que escale" | "Suporta 1000 req/min sem degradação" |

**Mínimo:** 3 critérios binários por especificação.

### Passo 4: Especificação Canônica (10 min)
Preencher o `docs/SPEC-[nome].md` usando o template.

**Este arquivo é o gatilho obrigatório** para a skill `planejando-solucoes`.

## 📋 Checklist de Saída (DoD)

Antes de finalizar, verifique:

- [ ] Intenção original capturada e documentada?
- [ ] Ambiguidade eliminada (3 caminhos explorados)?
- [ ] Caminho selecionado justificado?
- [ ] Critérios binários definidos (mínimo 3)?
- [ ] Solução viável na stack do projeto?
- [ ] Template SPEC preenchido?
- [ ] Próxima skill definida (`planejando-solucoes`)?
- [ ] Stakeholder validou escopo?

## 🌍 Exemplos por Projeto

### Exemplo 1: SnapFit - "Quero um sistema de créditos"
```
Intenção: Controlar quantas imagens cada lojista pode gerar

Caminho MVP: 
- Campo 'credits' na tabela tenants
- Decrementa a cada geração
- Quando zera, bloqueia

Caminho Ideal:
- Sistema de quotas mensais
- Overage automático (Stripe)
- Alertas em 80% e 100%

Caminho IA-Native:
- Predição de uso com ML
- Upsell automático via agente
- Otimização de preços dinâmica

Selecionado: MVP (validar modelo de negócio primeiro)

Critérios binários:
- [ ] Sistema decrementa 1 crédito por imagem gerada
- [ ] Bloqueia quando credits = 0
- [ ] Mostra créditos restantes no dashboard
```

### Exemplo 2: AprenderIA - "Quero matchmaking melhor"
```
Intenção: Empresas encontrarem prestadores de serviço

Caminho MVP:
- Matching por keywords (ILike no Postgres)
- Score simples: skills + experiência

Caminho Ideal:
- Embeddings de perfis (pgvector)
- Similaridade de cosseno
- Ranking ponderado

Caminho IA-Native:
- LLM analisa descrição do projeto
- Gera queries complexas automaticamente
- Explica por que recomendou cada match

Selecionado: Ideal (diferencial competitivo é a qualidade do match)

Critérios binários:
- [ ] Match retorna em < 500ms
- [ ] Precisão > 70% (avaliação humana)
- [ ] Suporta 1000 perfis sem degradação
```

### Exemplo 3: Novo Projeto - "Quero um blog"
```
Intenção: Publicar conteúdo técnico

Caminho MVP:
- Markdown no GitHub
- Geração estática (Next.js)

Caminho Ideal:
- CMS headless (Sanity/Strapi)
- Preview, drafts, SEO

Caminho IA-Native:
- Geração automática de posts (LLM)
- Otimização de títulos (A/B test)
- Personalização por leitor

Selecionado: MVP (começar simples, escalar depois)

Critérios binários:
- [ ] Post publicado em < 5 min
- [ ] SEO score > 90 (Lighthouse)
- [ ] Build < 3 min
```

## 🛠️ Scripts e Utilitários

### Gerar ideias com contexto:
```bash
python skills/brainstorming/scripts/generate_ideas.py \
  --context "Sistema de notificações para e-commerce" \
  --project SnapFit \
  --stack nextjs,neon,inngest
```

### Validar especificação:
```bash
python skills/brainstorming/scripts/validate_spec.py \
  --file docs/SPEC-credit-system.md
```

### Comparar caminhos:
```bash
python skills/brainstorming/scripts/compare_paths.py \
  --mvp "Simples" \
  --ideal "Completo" \
  --ia-native "Inovador"
```

## 💻 Código de Exemplo

### Script: generate_ideas.py
```python
#!/usr/bin/env python3
"""
Gera caminhos de solução baseados no contexto do projeto.
"""

import argparse
import json
from pathlib import Path

def load_project_context(project: str) -> dict:
    """Carrega contexto do projeto."""
    context_file = Path(f"projects/{project}/context.json")
    if context_file.exists():
        return json.loads(context_file.read_text())
    return {"stack": ["nextjs", "neon", "inngest"], "type": "saas"}

def generate_paths(context: str, project: str) -> dict:
    """Gera 3 caminhos: MVP, Ideal, IA-Native."""
    
    project_ctx = load_project_context(project)
    stack = project_ctx.get("stack", ["nextjs", "neon"])
    
    return {
        "mvp": {
            "description": f"Solução mínima usando {stack[0]}",
            "pros": ["Rápido", "Barato", "Valida hipótese"],
            "cons": ["Limitado", "Dívida técnica"],
            "when": "Prazo curto ou validação"
        },
        "ideal": {
            "description": f"Solução robusta com {', '.join(stack)}",
            "pros": ["Escalável", "Manutenível", "Completo"],
            "cons": ["Mais tempo", "Mais custo"],
            "when": "Produto principal ou longo prazo"
        },
        "ia_native": {
            "description": "Solução impossível sem IA/LLM",
            "pros": ["Diferencial", "Automação total", "Inovador"],
            "cons": ["Complexo", "Custo IA", "Risco técnico"],
            "when": "Diferencial competitivo claro"
        }
    }

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--context", required=True)
    parser.add_argument("--project", default="default")
    parser.add_argument("--stack", help="Override stack (comma-separated)")
    args = parser.parse_args()
    
    print(f"🧠 Brainstorming para: {args.context}")
    print(f"📋 Projeto: {args.project}")
    print("=" * 50)
    
    paths = generate_paths(args.context, args.project)
    
    for name, data in paths.items():
        print(f"\n{'='*20} {name.upper()} {'='*20}")
        print(f"Descrição: {data['description']}")
        print(f"Prós: {', '.join(data['pros'])}")
        print(f"Contras: {', '.join(data['cons'])}")
        print(f"Quando usar: {data['when']}")

if __name__ == "__main__":
    main()
```

### Script: validate_spec.py
```python
#!/usr/bin/env python3
"""
Valida se especificação segue padrão canônico.
"""

import re
import sys
from pathlib import Path

def validate_spec(file_path: str) -> bool:
    """Valida estrutura do SPEC."""
    
    content = Path(file_path).read_text()
    errors = []
    
    # Check 1: Título presente
    if not re.search(r'^# .+', content, re.MULTILINE):
        errors.append("❌ Título (H1) não encontrado")
    
    # Check 2: Seção "O Problema"
    if "## 1. O Problema" not in content:
        errors.append("❌ Seção 'O Problema' não encontrada")
    
    # Check 3: Critérios binários
    if "Critérios de Sucesso" not in content:
        errors.append("❌ Seção 'Critérios de Sucesso' não encontrada")
    
    # Check 4: User Stories
    stories = re.findall(r'-\s*\[.*\]\s*\*\*US-\d+\*\*', content)
    if len(stories) < 1:
        errors.append("❌ Mínimo 1 User Story não encontrado")
    
    # Check 5: Restrições/Fallbacks
    if "## 5. Restrições & Fallbacks" not in content:
        errors.append("❌ Seção de restrições não encontrada")
    
    if errors:
        print(f"Erros em {file_path}:")
        for error in errors:
            print(f"  {error}")
        return False
    
    print(f"✅ {file_path} válido!")
    return True

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Uso: validate_spec.py <arquivo.md>")
        sys.exit(1)
    
    success = validate_spec(sys.argv[1])
    sys.exit(0 if success else 1)
```

## 📄 Template de Especificação

**Arquivo:** `docs/SPEC-[nome].md`

```markdown
# Especificação Funcional: [Nome da Iniciativa]
**Status:** 🟡 Discovery  
**Projeto:** [Nome do Projeto]  
**Data:** [YYYY-MM-DD]  
**Autor:** [Nome]

## 1. O Problema (Contexto)
[Descrição da dor atual em 2-3 parágrafos. Quem sofre? Quando acontece? Qual o custo?]

## 2. A Solução (Caminho Selecionado)
Vamos construir um sistema utilizando **[Stack do Projeto]** que...

**Caminho escolhido:** [MVP / Ideal / IA-Native]  
**Justificativa:** [Por que este caminho?]

## 3. Alternativas Consideradas
| Caminho | Por que não escolhemos? |
|---------|------------------------|
| [Alternativa 1] | [Razão] |
| [Alternativa 2] | [Razão] |

## 4. Critérios de Sucesso (Binários)
*Só consideraremos sucesso se:*

- [ ] [Critério 1 - mensurável]
- [ ] [Critério 2 - mensurável]
- [ ] [Critério 3 - mensurável]

## 5. User Stories (Escopo do MVP)
- [ ] **US-01**: Como [persona], quero [ação], para [benefício].
  - Critério de aceite: [Definição de pronto]
  
- [ ] **US-02**: Como [sistema], devo [reação], quando [gatilho].
  - Critério de aceite: [Definição de pronto]

## 6. Restrições & Fallbacks
- Se [condição de risco] -> [ação de contingência]
- Se [condição de risco] -> [ação de contingência]

## 7. Próximos Passos
- [ ] Revisão com stakeholders
- [ ] Aprovação para `planejando-solucoes`
- [ ] Estimativa de esforço

## 8. Notas e Referências
[Links, inspirações, research, etc]
```

## 🚫 Anti-Padrões

- ❌ Especificação sem critérios binários (subjetiva)
- ❌ Apenas 1 caminho explorado (sem análise de trade-offs)
- ❌ User Stories sem critérios de aceite
- ❌ Sem restrições ou fallbacks definidos
- ❌ Especificação muito grande (>2 páginas) ou muito pequena (<meia página)
- ❌ Hardcode de stack sem verificar `project-context.json`

## ✅ Checklist de Qualidade

- [ ] Problema bem definido (5 Whys aplicado)
- [ ] 3 caminhos explorados e documentados
- [ ] Justificativa clara da escolha
- [ ] Critérios binários mensuráveis
- [ ] Mínimo 1 User Story com critério de aceite
- [ ] Restrições e fallbacks documentados
- [ ] Stack validada contra contexto do projeto
- [ ] Stakeholder revisou e aprovou

## 🔗 Integrações

- **Chama:** `usando-skills` (para validar se deve ser invocada)
- **É chamada por:** Qualquer intenção vaga ou ambígua
- **Chama:** `planejando-solucoes` (após SPEC aprovado)
- **Depende de:** `project-context.json` (para stack)

## 📝 Changelog

### v3.0.0 (2026-02-10)
- **BREAKING**: Tornada agnóstica de projeto e stack
- **ADD**: Exemplos de múltiplos projetos (SnapFit, AprenderIA, genérico)
- **ADD**: Configuração via `project-context.json`
- **ADD**: Scripts de validação de SPEC
- **ADD**: Checklist de qualidade detalhado
- **ADD**: Template de SPEC expandido (8 seções)
- **REMOVE**: Referências específicas a "Antigravity OS"
- **IMPROVE**: Estrutura de critérios binários
- **IMPROVE**: Documentação de anti-padrões

### v2.0.0 (Original)
- Protocolo de compressão de entropia
- 3 caminhos (MVP, Ideal, IA-Native)
- Template SPEC funcional
- Integração com stack fixa

### v1.0.0 (Prototype)
- Brainstorming básico
- Captura de requisitos
- Validação manual

