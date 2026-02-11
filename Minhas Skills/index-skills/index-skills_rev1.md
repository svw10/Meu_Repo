name: index-skills
description: O Kernel Universal. Mantém o Índice Canônico e a hierarquia de execução do ecossistema de skills. Router central para qualquer projeto.
version: 4.0.0
tags: [core, router, system, map, universal, kernel]
author: System Architect
---

# Índice Canônico de Skills – Kernel Universal

Ecossistema de skills modulares, observáveis e compatíveis com SLA >99.9%.
Todas as skills seguem o padrão definido em `criando-skills`.

> **Princípio Central**: Autonomia sem disciplina é caos. Toda skill existe para eliminar a improvisação.
> **Escopo**: Esta skill é agnóstica de projeto. Funciona para SnapFit, AprenderIA, ou qualquer novo sistema.

---

## 🛡️ Camada Meta (Governança & Estrutura)
*Skills que definem as regras do jogo e a evolução do sistema.*

| Skill | Descrição | Gatilho |
|-------|-----------|---------|
| **`usando-skills`** | O Supervisor. Garante que toda ação use uma skill especializada. | SEMPRE - toda interação |
| **`criando-skills`** | Fábrica de novas capacidades. Cria skills seguindo padrões universais. | "Preciso de uma skill que não existe" |
| **`index-skills`** | O Kernel (esta skill). Mapa e router do ecossistema. | "O que eu sei fazer?" ou "Qual skill usar?" |
| **`architecture-review`** | O CTO. Define padrões técnicos, ADRs, e stack. | Nova feature, trade-off técnico, ou dívida técnica |
| **`observability-playbook`** | O Sentinela. Logs, métricas, alertas, e telemetria. | Novo componente em produção ou incidente |

---

## 💡 Camada de Produto & Estratégia
*Skills que transformam intenções vagas em planos concretos.*

| Skill | Descrição | Gatilho |
|-------|-----------|---------|
| **`brainstorming`** | O PM. Comprime entropia e define specs funcionais. | Ideia vaga, "Quero melhorar X", ou discovery |
| **`planejando-solucoes`** | O Arquiteto. Cria planos atômicos e técnicos executáveis. | Spec aprovada ou ADR definido |
| **`llm-app-blueprint`** | O Engenheiro de IA. Arquitetura de RAG, agentes, e guardrails. | Projeto envolvendo LLM ou IA generativa |
| **`explorando-mercado`** | O Growth Hacker. Análise de concorrência, pricing, e GTM. | Antes de construir, validar mercado |

---

## ⚙️ Camada de Execução (Engenharia)
*Skills que colocam a mão na massa (Código e Infra).*

| Skill | Descrição | Gatilho |
|-------|-----------|---------|
| **`executando-planos`** | O Engenheiro. Coda, builda, testa, e commita. | Plano atômico pronto ou task definida |
| **`criando-ui`** | O Frontend. Gera interfaces com design system (Shadcn/Tailwind). | Necessidade visual, componente, ou página |
| **`gerenciando-memoria`** | O Bibliotecário. RAG com embeddings e busca semântica. | Salvar conhecimento ou recuperar contexto |
| **`pesquisando-web`** | O Espião. Scraping e inteligência de mercado. | Falta de dados externos ou análise competitiva |
| **`comunicando-externo`** | O Mensageiro. WhatsApp, Email, e notificações via filas. | Notificar usuário ou integração externa |

---

## ✅ Camada de Qualidade & Resiliência
*Skills que garantem que o sistema não quebre ou minta.*

| Skill | Descrição | Gatilho |
|-------|-----------|---------|
| **`verificando-conclusao`** | O Auditor (QA). Valida DoD, testes, e evidências. | Fim da execução ou "está pronto?" |
| **`solucionando-erros`** | O Médico. Diagnóstico científico de falhas e recovery. | Erro, timeout, exceção, ou comportamento inesperado |

---

## 📊 Camada de Gestão & Visibilidade
*Skills que fecham o ciclo com stakeholders.*

| Skill | Descrição | Gatilho |
|-------|-----------|---------|
| **`status-report`** | O Gerente. Relatórios executivos de progresso, risco, e métricas. | Fim de ciclo, sprint, ou risco crítico identificado |

---

## 🧬 Stack de Referência (Stack Omega)

As skills assumem esta stack como padrão, mas são adaptáveis:

| Camada | Tecnologia | Quando usar alternativa |
|--------|-----------|------------------------|
| Frontend | Next.js 14 (App Router) | React puro, Vue, ou Svelte |
| Estilos | Tailwind CSS + Shadcn/UI | Styled-components, MUI |
| Backend | Next.js API Routes / Go | Node/Express, Python/FastAPI |
| Database | Neon PostgreSQL (pgvector) | Supabase, PlanetScale |
| Auth | Clerk | Auth0, Firebase Auth |
| Queue | Inngest | Bull, RabbitMQ, SQS |
| AI/LLM | OpenRouter | Direct OpenAI, Anthropic |
| Comms | Evolution API + Resend | Twilio, SendGrid, N8N |
| Storage | Cloudflare R2 | AWS S3, Google Cloud Storage |
| Observability | Vercel Logs + Neon | Datadog, New Relic |

---

## 🎯 Como Usar Este Índice

### Para desenvolvedores (você):
```bash
# 1. Sempre comece consultando o índice
python skills/index-skills/scripts/search.py --intent "criar componente de upload"

# 2. O sistema retorna a skill recomendada
# Resultado: criando-ui v1.0.0

# 3. Execute a skill com contexto
python skills/criando-ui/scripts/generate.py --type upload --project SnapFit
```

### Para o agente IA:
```python
# Pseudocódigo do router interno

def route_intent(intent: str, context: dict) -> Skill:
    """
    Roteia intenção para skill apropriada.
    """
    # Mapeamento do índice
    mapping = {
        "criar código": "executando-planos",
        "criar interface": "criando-ui",
        "planejar arquitetura": "planejando-solucoes",
        "resolver erro": "solucionando-erros",
        "analisar mercado": "explorando-mercado",
        # ... etc
    }
    
    # Encontrar match
    for pattern, skill_name in mapping.items():
        if pattern in intent.lower():
            return load_skill(skill_name)
    
    # Fallback: brainstorming para descoberta
    return load_skill("brainstorming")
```

---

## 📋 Estrutura de Diretórios

Toda skill segue esta estrutura obrigatória:

```
skills/
├── [nome-da-skill]/
│   ├── SKILL.md              # Definição, versão, checklist
│   ├── README.md             # Documentação detalhada (opcional)
│   ├── scripts/              # Automações e utilitários
│   │   ├── *.py
│   │   └── *.ts
│   ├── resources/            # Templates e exemplos
│   │   ├── *.md
│   │   └── *.json
│   ├── lib/                  # Código reutilizável
│   │   ├── *.py
│   │   └── *.ts
│   └── snippets/             # Trechos de código rápidos
│       ├── *.ts
│       └── *.py
```

---

## 🔄 Ciclo de Vida de uma Skill

```
1. NECESSIDADE IDENTIFICADA
   ↓
2. using-skills detecta que não existe skill adequada
   ↓
3. criando-skills é invocado
   ↓
4. Nova skill criada seguindo padrões do índice
   ↓
5. index-skills atualizado (este arquivo)
   ↓
6. Skill disponível para todos os projetos
   ↓
7. Observability-playbook monitora uso e métricas
   ↓
8. architecture-review avalia evolução ou deprecação
```

---

## 🛠️ Scripts e Utilitários

### Atualizar índice após nova skill:
```bash
python skills/index-skills/scripts/update_index.py
```

### Buscar skill por intenção:
```bash
python skills/index-skills/scripts/search.py --intent "criar API REST"
# Retorna: planejando-solucoes, executando-planos
```

### Validar estrutura de skill:
```bash
python skills/index-skills/scripts/validate_skill.py --path skills/nova-skill/
# Verifica: SKILL.md, versão, scripts, recursos
```

### Gerar relatório de cobertura:
```bash
python skills/index-skills/scripts/coverage_report.py
# Mostra: skills ativas, obsoletas, faltantes por camada
```

---

## 🧪 Testes do Índice

### Teste: Todas as skills têm SKILL.md
```python
# tests/test_index_integrity.py

import os
import pytest
from pathlib import Path

def test_all_skills_have_definition():
    skills_dir = Path("skills")
    
    for skill_dir in skills_dir.iterdir():
        if skill_dir.is_dir():
            skill_file = skill_dir / "SKILL.md"
            assert skill_file.exists(), f"{skill_dir.name} não tem SKILL.md"
            
            content = skill_file.read_text()
            assert "name:" in content
            assert "version:" in content
            assert "description:" in content
```

### Teste: Versões são semânticas
```python
def test_semantic_versioning():
    import re
    from pathlib import Path
    
    semver_pattern = r'^\d+\.\d+\.\d+$'
    skills_dir = Path("skills")
    
    for skill_dir in skills_dir.iterdir():
        if not skill_dir.is_dir():
            continue
            
        skill_file = skill_dir / "SKILL.md"
        content = skill_file.read_text()
        
        # Extrair versão
        version_line = [l for l in content.split('\n') if 'version:' in l][0]
        version = version_line.split(':')[1].strip()
        
        assert re.match(semver_pattern, version), \
            f"{skill_dir.name} tem versão inválida: {version}"
```

---

## 📊 Métricas do Ecossistema

| Métrica | Target | Como medir |
|---------|--------|-----------|
| Skills ativas | 15+ | Contagem em index-skills |
| Cobertura de camadas | 100% | Todas as 5 camadas populadas |
| Tempo médio de roteamento | <100ms | Log de usando-skills |
| Taxa de acerto de intenção | >95% | Feedback do agente |
| Skills criadas/mês | 1-2 | Criando-skills logs |

---

## 🚫 Anti-Padrões no Índice

- ❌ Skill sem camada definida (Meta, Produto, Execução, Qualidade, Gestão)
- ❌ Skill sem gatilho claro ("quando usar")
- ❌ Skill sem scripts ou recursos (apenas teórica)
- ❌ Duas skills com o mesmo propósito (sobreposição)
- ❌ Skill obsoleta não marcada como deprecated
- ❌ Versão não semântica (x.y.z)

---

## 📝 Changelog do Índice

### v4.0.0 (2026-02-10)
- **BREAKING**: Tornado agnóstico de projeto (universal)
- **ADD**: Coluna "Quando usar alternativa" na Stack Omega
- **ADD**: Seção "Ciclo de Vida de uma Skill"
- **ADD**: Scripts de busca, validação, e cobertura
- **ADD**: Testes de integridade do índice
- **ADD**: Métricas do ecossistema
- **ADD**: Anti-padrões específicos do índice
- **REMOVE**: Referências a "Antigravity OS" (tornadas genéricas)
- **IMPROVE**: Descrições de skills mais detalhadas
- **IMPROVE**: Tabelas por camada com gatilhos explícitos

### v3.0.0 (Original)
- Estrutura de 5 camadas definida
- 15 skills iniciais catalogadas
- Princípios de governança estabelecidos
- Stack Imutável documentada

---

## 🔗 Recursos Relacionados

- `usando-skills`: Como usar este índice na prática
- `criando-skills`: Padrão para adicionar novas skills ao índice
- `architecture-review`: ADRs que afetam o ecossistema de skills
- `observability-playbook`: Métricas de uso das skills

## 📄 Licença

MIT - Livre para uso e modificação em qualquer projeto.

---

