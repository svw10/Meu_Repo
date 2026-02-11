name: usando-skills
description: O Supervisor Universal. Garante que o agente consulte e utilize skills especializadas. Se a skill não existir, ordena sua criação. Gatilho universal para toda interação em qualquer projeto.
version: 3.0.0
tags: [core, meta, disciplina, router, consciencia, universal, agnostic]
author: System Architect
---

# Usando Skills (Consciousness Protocol)

## 🎯 Quando usar
- **SEMPRE**. Em absolutamente toda interação com o usuário.
- Antes de responder "Oi".
- Antes de escrever qualquer linha de código.
- Mesmo que a tarefa pareça "simples" ou "óbvia".
- Em qualquer projeto: SaaS, API, Mobile, CLI, ou automação.

> **Regra Absoluta**: A improvisação é inimiga da autonomia. **Nunca execute nada sem uma skill.**

## ⚙️ Fluxo de Pensamento (Obrigatório)

- [ ] **1. Pausa Tática**
    - O usuário falou. **NÃO RESPONDA AINDA.**
    - Analise a intenção: Verbo (Criar, Planejar, Corrigir) + Objeto (Código, Texto, Banco) + Contexto (Qual projeto?).

- [ ] **2. Consulta ao Kernel (`index-skills`)**
    - Varra a lista de skills existentes no projeto atual.
    - *Pergunta*: "Existe uma ferramenta especializada para isso?"

- [ ] **3. Decisão de Roteamento (Bifurcação)**
    - **Cenário A (Skill Existe)**:
        - Carregue o contexto da skill.
        - Anuncie: *"🔧 Estou usando a skill **[Nome]** v[versão] para garantir consistência..."*
        - Execute o checklist da skill.
        - Aplique configurações específicas do projeto se necessário.
    
    - **Cenário B (Skill Não Existe)**:
        - **PROIBIDO IMPROVISAR.**
        - Invoque imediatamente a skill `criando-skills`.
        - Passe contexto: projeto atual, necessidade específica, stack utilizada.
        - Crie a nova capacidade.
        - Volte para o Cenário A.

- [ ] **4. Registro de Auditoria**
    - Logar a decisão no padrão do `observability-playbook`.
    - Estrutura obrigatória:
    ```json
    {
      "timestamp": "2026-02-10T14:30:00Z",
      "event": "skill_routing",
      "skill_invoked": "nome_da_skill",
      "version": "x.x.x",
      "project": "nome_do_projeto",
      "intent": "verbo_objeto",
      "context": "contexto_especifico",
      "status": "success|created|failed",
      "duration_ms": 150
    }
    ```

## 🧩 Configuração por Projeto

Crie um arquivo `project-context.json` na raiz do projeto:

```json
{
  "project_name": "SnapFit",
  "project_type": "saas_b2b",
  "stack": ["nextjs", "neon", "inngest", "clerk", "openrouter"],
  "primary_domain": "virtual_try_on",
  "skills_prefix": "snapfit",
  "default_llm": "openrouter/gemini-flash-1.5",
  "team_size": "solo",
  "priority": "speed_over_perfection"
}
```

A skill `usando-skills` lê este arquivo para adaptar comportamento.

## 🚨 Mapeamento de Intenção (Cheat Sheet Universal)

| Intenção do Usuário | Skill Obrigatória | Contexto Comum |
| :--- | :--- | :--- |
| "Tenho uma ideia..." | `brainstorming` | Produto, feature, negócio |
| "Planeje a arquitetura..." | `planejando-solucoes` | Sistema, API, banco de dados |
| "Escreva o código..." | `executando-planos` | Backend, frontend, infra |
| "Crie a interface..." | `criando-ui` | Componente, página, dashboard |
| "Deu erro..." | `solucionando-erros` | Bug, crash, performance |
| "Está pronto?" | `verificando-conclusao` | QA, deploy, entrega |
| "Como está o projeto?" | `status-report` | Progresso, métricas, riscos |
| "Preciso de IA/RAG..." | `llm-app-blueprint` | Chatbot, embeddings, agentes |
| "Adicionar lib/serviço..." | `architecture-review` | Stack, dependência, ADR |
| "Analisar concorrência..." | `explorando-mercado` | Pricing, features, GTM |
| "Não sei o que fazer" | `brainstorming` | Descoberta, discovery |
| **"Skill não encontrada"** | **`criando-skills`** | Genesis, nova capacidade |

## 🌍 Exemplos por Projeto

### Exemplo 1: SnapFit (SaaS de Provador Virtual)
```
Usuário: "Crie o upload de imagens para o catálogo"
↓
Pausa Tática: Verbo=criar, Objeto=componente UI, Contexto=SnapFit/catalogo
↓
Consulta index-skills: Existe criando-ui? Sim v1.0.0
↓
Anúncio: "🔧 Estou usando a skill criando-ui v1.0.0 para gerar o componente de upload..."
↓
Config específica: Stack=Next.js+Shadcn, tipo=upload-imagem, preview=sim
↓
Executar checklist criando-ui
```

### Exemplo 2: AprenderIA (Matchmaking Técnico)
```
Usuário: "A API de matching está lenta"
↓
Pausa Tática: Verbo=analisar/corrigir, Objeto=performance API, Contexto=AprenderIA
↓
Consulta index-skills: Existe solucionando-erros? Sim v2.0.0
↓
Anúncio: "🔧 Estou usando a skill solucionando-erros v2.0.0 para diagnosticar a lentidão..."
↓
Config específica: Stack=Go+Neon, métricas=p95_latency, threshold=200ms
↓
Executar checklist solucionando-erros
```

### Exemplo 3: Novo Projeto - Sistema de Assinaturas
```
Usuário: "Crie um sistema de assinaturas com Stripe"
↓
Pausa Tática: Verbo=criar, Objeto=sistema de pagamento, Contexto=NovoProjeto
↓
Consulta index-skills: Existe billing-subscription-system? Não
↓
Ação: Invocar criando-skills
↓
Parâmetros: {
  "project": "NovoProjeto",
  "need": "sistema de assinaturas recorrentes",
  "stack": ["nextjs", "stripe", "neon"],
  "features": ["trial", "upgrade", "cancelamento"]
}
↓
Pausar execução até skill ser criada
```

## 🔗 Integrações e Dependências

### Skills que esta skill CHAMA:
- `index-skills` (consulta de disponibilidade)
- `criando-skills` (quando não existe)
- `observability-playbook` (registro de auditoria)

### Skills que CHAMAM esta skill:
- **TODAS**. Esta é a skill de entrada universal.

### Configurações externas:
- `project-context.json` (opcional, mas recomendado)
- Variável de ambiente: `PROJECT_NAME` (fallback se JSON não existir)

## ✅ Checklist de Conformidade (DoD)

Antes de qualquer ação, verifique:

- [ ] Pausa tática realizada (intenção clara: verbo + objeto + contexto)
- [ ] Arquivo `project-context.json` lido (se existir)
- [ ] `index-skills` consultado e resposta obtida
- [ ] Decisão de roteamento documentada (Cenário A ou B)
- [ ] Se Cenário A: Skill correta identificada e versão verificada
- [ ] Se Cenário B: `criando-skills` invocado com parâmetros completos
- [ ] Execução anunciada ao usuário com nome e versão da skill
- [ ] Log de auditoria estruturado registrado
- [ ] Configurações específicas do projeto aplicadas

## 🎛️ Snippets e Comandos

### Atualizar índice de skills do projeto:
```bash
python skills/index-skills/scripts/update_index.py
```

### Verificar versão de skill específica:
```bash
python skills/usando-skills/scripts/check_version.py --skill nome-da-skill
```

### Criar novo contexto de projeto:
```bash
python skills/usando-skills/scripts/init_project.py --name "NomeDoProjeto" --type saas_b2b
```

### Verificar se skill existe antes de usar (Python):
```python
#!/usr/bin/env python3
# skills/usando-skills/scripts/check_skill.py

import sys
import json
from pathlib import Path

def skill_exists(skill_name: str) -> bool:
    """Verifica se uma skill existe no índice."""
    index_path = Path("skills/index-skills/INDEX.json")
    
    if not index_path.exists():
        return False
    
    with open(index_path) as f:
        index = json.load(f)
    
    return skill_name in index.get("skills", {})

def get_skill_version(skill_name: str) -> str:
    """Retorna a versão de uma skill."""
    skill_path = Path(f"skills/{skill_name}/SKILL.md")
    
    if not skill_path.exists():
        return "0.0.0"
    
    with open(skill_path) as f:
        for line in f:
            if line.startswith("version:"):
                return line.split(":")[1].strip()
    
    return "0.0.0"

if __name__ == "__main__":
    skill = sys.argv[1]
    
    if skill_exists(skill):
        version = get_skill_version(skill)
        print(f"✅ Skill '{skill}' encontrada (v{version})")
        sys.exit(0)
    else:
        print(f"❌ Skill '{skill}' não encontrada")
        print("💡 Execute: python skills/criando-skills/scripts/create_skill.py")
        sys.exit(1)
```

### Verificar se skill existe antes de usar (TypeScript):
```typescript
// skills/usando-skills/lib/skill-registry.ts

import { readFileSync, existsSync } from 'fs';
import { join } from 'path';

interface SkillInfo {
  name: string;
  version: string;
  description: string;
  exists: boolean;
}

export class SkillRegistry {
  private indexPath = 'skills/index-skills/INDEX.json';
  
  async find(skillName: string): Promise<SkillInfo | null> {
    const skillPath = join('skills', skillName, 'SKILL.md');
    
    if (!existsSync(skillPath)) {
      return null;
    }
    
    const content = readFileSync(skillPath, 'utf-8');
    const version = this.extractVersion(content);
    const description = this.extractDescription(content);
    
    return {
      name: skillName,
      version,
      description,
      exists: true
    };
  }
  
  async invoke(skillName: string, context: Record<string, any>): Promise<void> {
    const skill = await this.find(skillName);
    
    if (!skill) {
      console.log(`❌ Skill '${skillName}' não encontrada`);
      console.log('💡 Invocando criando-skills...');
      
      // Invocar criação
      await this.createSkill(skillName, context);
      return;
    }
    
    console.log(`🔧 Usando skill ${skill.name} v${skill.version}`);
    // Executar skill...
  }
  
  private extractVersion(content: string): string {
    const match = content.match(/version:\s*(\d+\.\d+\.\d+)/);
    return match?.[1] || '0.0.0';
  }
  
  private extractDescription(content: string): string {
    const match = content.match(/description:\s*(.+)/);
    return match?.[1] || '';
  }
  
  private async createSkill(name: string, context: Record<string, any>): Promise<void> {
    // Delegar para criando-skills
    const { createSkill } = await import('../criando-skills/lib/factory');
    await createSkill({ name, ...context });
  }
}
```

### Uso em código de produção:
```typescript
// Exemplo real em um API route Next.js

import { SkillRegistry } from '@/skills/usando-skills/lib/skill-registry';
import { withSkillGuard } from '@/skills/usando-skills/lib/guard';

export default withSkillGuard(async function handler(req, res) {
  const registry = new SkillRegistry();
  
  // Tentar usar skill de criação de UI
  const uiSkill = await registry.find('criando-ui');
  
  if (!uiSkill) {
    // Cenário B: Skill não existe
    await registry.invoke('criando-skills', {
      need: 'criando-ui',
      reason: 'Componente de upload necessário',
      stack: ['nextjs', 'shadcn']
    });
    
    return res.status(503).json({
      error: 'Skill sendo criada. Tente novamente em 30 segundos.'
    });
  }
  
  // Cenário A: Skill existe, executar
  const component = await uiSkill.execute({
    type: 'upload',
    props: { accept: 'image/*', multiple: true }
  });
  
  return res.status(200).json({ component });
});
```

## 📊 Métricas de Sucesso

- Taxa de acerto no roteamento: >99%
- Tempo médio de decisão: <500ms
- Skills criadas sob demanda: rastreadas em `observability-playbook`
- Projetos suportados simultaneamente: ilimitado (via contexto)
- Taxa de improviso proibido: 0%

## 🚫 Anti-Padrões (Proibidos)

- ❌ Responder usuário sem consultar `index-skills`
- ❌ Usar skill desatualizada (sempre verificar versão mínima)
- ❌ Criar código sem skill especializada (improvisar)
- ❌ Ignorar falha de skill e "tentar mesmo assim"
- ❌ Esquecer de registrar log de auditoria
- ❌ Ignorar `project-context.json` quando presente
- ❌ Hardcode de nomes de projeto ou stack específica
- ❌ Assumir contexto sem verificar `project-context.json`

## 🛡️ Regras de Ouro (Golden Rules)

### Regra 1: Universalidade
Toda skill deve funcionar em qualquer projeto que siga a Stack Omega (Next.js, Neon, Inngest, Clerk, etc).

### Regra 2: Configurabilidade
Nunca hardcode. Sempre use `project-context.json` ou variáveis de ambiente para comportamento específico.

### Regra 3: Observabilidade
Toda decisão deve ser logada. Toda skill deve reportar métricas. Tudo deve ser rastreável.

### Regra 4: Evolução Contínua
Skills são código. Código tem versionamento. Versionamento tem changelog. Changelog tem breaking changes documentados.

### Regra 5: Segurança por Padrão
Nunca logar PII. Sempre sanitizar inputs. Sempre validar permissões antes de executar.

## 🧬 Stack Omega (Referência)

A Stack Omega é a base técnica que torna as skills universais:

| Camada | Tecnologia | Propósito |
|--------|-----------|-----------|
| Frontend | Next.js 14 (App Router) | React, SSR, API Routes |
| Estilos | Tailwind CSS + Shadcn/UI | Design system consistente |
| Backend | Next.js API Routes / Go | Serverless, edge, ou Go puro |
| Database | Neon PostgreSQL | Serverless Postgres com pgvector |
| Auth | Clerk | Multitenancy, SSO, organizações |
| Queue | Inngest | Orquestração, retries, scheduling |
| AI/LLM | OpenRouter | Router de modelos (Gemini, GPT, Claude) |
| Comms | Evolution API + Resend | WhatsApp Business + Email transacional |
| Storage | Cloudflare R2 | Egress zero, imagens, assets |
| Observability | Vercel Logs + Neon Analytics | Telemetria, métricas, alertas |

## 📝 Templates de Erro Comuns

### Erro 1: Skill não encontrada
```
❌ ERRO: Skill 'nome-inexistente' não encontrada no índice.

✅ AÇÃO: 
1. Verificar ortografia em index-skills
2. Se não existir, invocar criando-skills
3. Se existir com nome diferente, usar nome correto
```

### Erro 2: Versão incompatível
```
❌ ERRO: Skill 'criando-ui' v1.0.0 requerida, mas v0.9.0 instalada.

✅ AÇÃO:
1. Verificar changelog para breaking changes
2. Atualizar skill se compatível
3. Ou adaptar chamada para versão disponível
```

### Erro 3: Contexto não carregado
```
❌ ERRO: project-context.json não encontrado e PROJECT_NAME não definido.

✅ AÇÃO:
1. Criar project-context.json na raiz
2. Ou definir export PROJECT_NAME="NomeDoProjeto"
3. Reexecutar comando
```

## 🔄 Integração com CI/CD

### Pre-commit hook
```bash
#!/bin/bash
# .git/hooks/pre-commit

# Verifica se todas as skills usadas existem
python skills/usando-skills/scripts/validate_skills.py --staged-files

# Verifica se logs de auditoria estão presentes
python skills/observability-playbook/scripts/check_logs.py --last-commit

exit 0
```

### GitHub Action
```yaml
# .github/workflows/skills-check.yml
name: Skills Validation

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v5
        with:
          python-version: '3.11'
      
      - name: Validate Skills Usage
        run: |
          python skills/usando-skills/scripts/validate_all.py
          
      - name: Check Audit Logs
        run: |
          python skills/observability-playbook/scripts/validate_logs.py
          
      - name: Report
        if: always()
        run: |
          python skills/status-report/scripts/generate.py --ci
```

## 🧪 Testes

### Teste unitário (Python):
```python
# tests/skills/test_usando_skills.py

import pytest
from pathlib import Path
from skills.usando_skills.lib.registry import SkillRegistry

def test_skill_exists():
    registry = SkillRegistry()
    assert registry.exists("index-skills") is True
    assert registry.exists("skill-inexistente") is False

def test_skill_version():
    registry = SkillRegistry()
    version = registry.get_version("usando-skills")
    assert version.startswith("3.")
```

### Teste unitário (TypeScript):
```typescript
// __tests__/skills/usando-skills.test.ts

import { SkillRegistry } from '@/skills/usando-skills/lib/skill-registry';

describe('SkillRegistry', () => {
  let registry: SkillRegistry;
  
  beforeEach(() => {
    registry = new SkillRegistry();
  });
  
  it('should find existing skill', async () => {
    const skill = await registry.find('index-skills');
    expect(skill).not.toBeNull();
    expect(skill?.exists).toBe(true);
  });
  
  it('should return null for non-existing skill', async () => {
    const skill = await registry.find('nao-existe');
    expect(skill).toBeNull();
  });
});
```

## 📚 Recursos Relacionados

- `index-skills`: Mapa completo do sistema
- `criando-skills`: Fábrica de novas capacidades
- `observability-playbook`: Telemetria e métricas
- `architecture-review`: ADRs e padrões técnicos
- `planejando-solucoes`: Planejamento de arquitetura

## 🔗 Links Úteis

- Documentação Stack Omega: `/docs/stack-omega.md`
- Guia de contribuição: `/CONTRIBUTING.md`
- Changelog do sistema: `/CHANGELOG.md`
- Roadmap: `/ROADMAP.md`

## 👥 Contribuidores

- System Architect: Definição do protocolo
- Community: Feedback e melhorias contínuas

## 📄 Licença

MIT - Livre para uso em qualquer projeto, comercial ou open source.

## 📝 Changelog

### v3.0.0 (2026-02-10)
- **BREAKING**: Tornada agnóstica de projeto (universal)
- **ADD**: Suporte a `project-context.json` para configuração por projeto
- **ADD**: Exemplos específicos de múltiplos projetos (SnapFit, AprenderIA)
- **ADD**: Seção de configuração por projeto
- **ADD**: Tags `universal` e `agnostic`
- **ADD**: Changelog e versionamento semântico explícito
- **ADD**: Seção "Regras de Ouro" (Golden Rules)
- **ADD**: Stack Omega documentada como referência
- **ADD**: Templates de erro comuns
- **ADD**: Integração com CI/CD (pre-commit, GitHub Actions)
- **ADD**: Testes unitários (Python e TypeScript)
- **ADD**: Scripts de verificação (`check_skill.py`, `validate_all.py`)
- **IMPROVE**: Estrutura de log de auditoria mais completa
- **IMPROVE**: Snippets em Python e TypeScript com exemplos reais
- **REMOVE**: Referências específicas a "Antigravity OS" (tornadas genéricas)

### v2.0.0 (Original)
- Protocolo de consciência inicial
- Mapeamento de intenção com cheat sheet
- Proibição de improviso
- Integração com observability-playbook
- Scripts básicos de verificação

### v1.0.0 (Prototype)
- Conceito inicial de skills
- Roteamento básico
- Validação manual
```

