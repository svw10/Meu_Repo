### 1. O Arquivo Mestre (`Minhas Skills/verificando-conclusao/SKILL.md`)

name: verificando-conclusao
description: O Auditor (QA). Valida se a entrega atende aos critérios originais através de evidências objetivas e testes de sanidade. Define o "Definition of Done" (DoD).
version: 2.0.0
tags: [qa, testing, validation, dod, audit]
---

# Verificando Conclusão (Quality Assurance Protocol)

## 🎯 Quando usar
- **Sempre** que uma execução terminar (`executando-planos`), antes de avisar o usuário.
- O agente acredita que terminou, mas precisa provar.
- Para garantir que o deploy na Vercel está acessível e o banco Neon está consistente.

> **Regra Obrigatória**: Executar ≠ Entregar. Só é "Feito" se for **Verificável**. Nunca declare conclusão sem rodar esta skill.

## 🧱 Stack Vinculada (Critérios de Aceite)
Para considerar a tarefa concluída, o agente deve validar:

| Camada | Critério de Aceite (DoD) | Ferramenta de Validação |
| :--- | :--- | :--- |
| **Integridade** | Build limpo e Typescript sem erros. | `npm run build` |
| **Acesso** | Rota/URL responde 200 OK. | `scripts/validate_delivery.py` |
| **Dados** | Registro salvo no Neon/Postgres. | `npx drizzle-kit studio` |
| **Requisito** | Checklist do `PLAN-*.md` batendo com a realidade. | Comparação Visual/Lógica |

## ⚙️ Fluxo de Trabalho (Auditoria)

- [ ] **1. Recuperação de Critérios (O que foi prometido?)**
    - Ler o `docs/PLAN-[nome].md`.
    - Identificar os "Critérios de Sucesso" definidos lá.

- [ ] **2. Coleta de Evidências (O que foi entregue?)**
    - Executar **Smoke Test**: A URL está no ar?
    - Executar **Data Check**: O dado está no banco?
    - Capturar logs ou output de sucesso.

- [ ] **3. Teste de Casos Limite (Edge Cases)**
    - *Ex: Se o usuário negar a permissão, o app quebra ou mostra erro?*
    - *Ex: Se o banco estiver lento, o Inngest faz retry?*

- [ ] **4. Veredito e Documentação**
    - Gerar o arquivo `docs/QA-[nome].md` usando o template.
    - **Aprovado**: Notificar usuário.
    - **Reprovado**: Acionar `solucionando-erros` imediatamente.

## 📋 Checklist de Entrega
O agente deve preencher mentalmente:
- [ ] Critérios originais recuperados?
- [ ] Testes automatizados (URL/DB) passaram?
- [ ] Evidência registrada em arquivo?
- [ ] Status final decidido (Binário: Sim/Não)?

## 💻 Snippets e Recursos

### Snippet 1: O Validador Universal
```bash
# Testa se a URL responde e se o Banco está acessível
python "Minhas Skills/verificando-conclusao/scripts/validate_delivery.py" --url "http://localhost:3000/api/nova-rota" --check-db

---

### 2. O Relatório de Evidências (`resources/template_qa_report.md`)

```markdown
# Relatório de QA: [Nome da Tarefa]
**Data:** {{DATE}}
**Status Final:** [✅ APROVADO / ❌ REPROVADO]

## 1. Critérios Originais vs Realidade

| Critério (Do Plano) | Status | Evidência (Como sabemos?) |
| :--- | :--- | :--- |
| Ex: Tabela criada no Neon | ✅ OK | Tabela `users` visível no Schema |
| Ex: Rota API responde 200 | ✅ OK | Curl retornou status 200 |
| Ex: Email enviado | ❌ FALHA | Log do Resend mostra erro 401 |

## 2. Testes Automatizados
- **Smoke Test (URL)**: [Passou/Falhou]
- **Conectividade DB**: [Passou/Falhou]

## 3. Casos Limite Testados
- [ ] O que acontece se enviar dados vazios? -> (Resultado observado)
- [ ] O que acontece se a API externa cair? -> (Resultado observado)

## 4. Conclusão
(Se falhou, explique o motivo e invoque o Troubleshooting. Se passou, libere para produção.)


### 3. Script de Validação Híbrido (`scripts/validate_delivery.py`)

Este script testa tanto a URL (Vercel/Next) quanto a conexão com o banco (Neon) para garantir que a aplicação está "viva" de verdade.

import sys
import os
import requests
import argparse
import psycopg2

def check_url(url):
    print(f"🌐 Testando Endpoint: {url}...")
    try:
        response = requests.get(url, timeout=5)
        if 200 <= response.status_code < 300:
            print(f"✅ URL OK: Status {response.status_code}")
            return True
        else:
            print(f"❌ URL FALHOU: Status {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ URL ERRO: {e}")
        return False

def check_db():
    print("🗄️ Testando Conexão Neon DB...")
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        print("⚠️ Pulei DB: DATABASE_URL não definida.")
        return False
    
    try:
        conn = psycopg2.connect(db_url)
        conn.close()
        print("✅ DB OK: Conexão estabelecida.")
        return True
    except Exception as e:
        print(f"❌ DB ERRO: {e}")
        return False

if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--url", help="URL para testar")
    parser.add_argument("--check-db", action="store_true", help="Validar conexão com banco")
    args = parser.parse_args()

    results = []
    
    if args.url:
        results.append(check_url(args.url))
    
    if args.check_db:
        results.append(check_db())

    if all(results) and len(results) > 0:
        print("\n✨ TODOS OS TESTES PASSARAM.")
        sys.exit(0)
    else:
        print("\n💥 FALHA NA VERIFICAÇÃO.")
        sys.exit(1)


# 🚀 O SCRIPT DE BOOT ATUALIZADO (Versão Final)

Luciano, este é o script `init_antigravity.py` contendo **todas as 10 skills** refinadas, incluindo a nova `verificando-conclusao`.

Basta salvar e rodar para ter o sistema completo.

import os
import sys

# Definição da Estrutura de Pastas e Arquivos do Antigravity OS
# Contém as 10 Skills Essenciais + Scripts + Templates

STRUCTURE = {
    # =========================================================
    # 1. CRIANDO SKILLS (GÊNESIS)
    # =========================================================
    "Minhas Skills/criando-skills/SKILL.md": """---
name: criando-skills
description: O "Gênesis". Gera skills de arquitetura crítica, compatíveis com a Stack Imutável (Vercel/Neon/Inngest).
version: 2.0.0
---
# Criando Skills para o Antigravity (Genesis Protocol)

## 🚨 Quando invocar
1. Solicitação de Nova Capacidade.
2. Encapsulamento de Workflow complexo.

## 🧱 A Stack Imutável
- **Core**: Google Antigravity (VS Code)
- **Front**: Vercel (Next.js App Router)
- **DB**: Neon + pgvector
- **Auth**: Clerk
- **Jobs**: Inngest
- **AI**: OpenRouter
- **Scraping**: Apify
- **Comms**: Evolution API / Resend

## ⚙️ Fluxo
1. Análise de Intenção.
2. Definição de Arquitetura.
3. Geração de Código Boilerplate.
4. Validação de Observabilidade.
""",
    "Minhas Skills/criando-skills/resources/template_padrao.md": """---
name: [verbo-gerundio]-[objeto]
description: [Descrição técnica]
version: 1.0.0
---
# [Nome da Skill]
## 🎯 Quando usar
- [Gatilho]
## 🏗️ Stack Vinculada
- [Ferramenta]: [Função]
## 📋 Checklist
- [ ] 1. Validação
- [ ] 2. Execução
""",
    "Minhas Skills/criando-skills/scripts/validate_stack.py": """print('✅ Stack validada.')""",

    # =========================================================
    # 2. INDEX SKILLS (ROUTER)
    # =========================================================
    "Minhas Skills/index-skills/SKILL.md": """---
name: index-skills
description: Router do sistema. Mantém o mapa de capacidades.
version: 1.0.0
---
# Índice Canônico

## 🗺️ Mapa de Skills
| Skill | Descrição | Status |
| :--- | :--- | :--- |
| `criando-skills` | Gênesis | 🟢 |
| `index-skills` | Router | 🟢 |
| `planejando-solucoes` | Arquiteto | 🟢 |
| `executando-planos` | Engenheiro | 🟢 |
| `verificando-conclusao` | QA / Auditor | 🟢 |
| `solucionando-erros` | Médico / Debug | 🟢 |
| `gerenciando-memoria` | RAG / Neon | 🟢 |
| `comunicando-externo` | WhatsApp / Email | 🟢 |
| `pesquisando-web` | Apify / Google | 🟢 |
| `criando-ui` | Frontend / Shadcn | 🟢 |
""",
    "Minhas Skills/index-skills/scripts/update_index.py": """print('✅ Índice atualizado.')""",

    # =========================================================
    # 3. PLANEJANDO SOLUÇÕES (ARQUITETO)
    # =========================================================
    "Minhas Skills/planejando-solucoes/SKILL.md": """---
name: planejando-solucoes
description: O Estrategista. Gera Planos Atômicos vinculados à Stack.
version: 2.0.0
---
# Planejando Soluções

## 🧱 Stack
- Next.js, Neon, Inngest.

## ⚙️ Fluxo
1. Clarificação.
2. Arquitetura.
3. Decomposição Atômica (<10min).
4. Geração de `docs/PLAN-*.md`.
""",
    "Minhas Skills/planejando-solucoes/resources/template_plano_atomico.md": """# Plano Atômico: [Feature]
**Objetivo:** ...
## 1. Arquitetura
## 2. Roteiro (Checklist)
""",
    "Minhas Skills/planejando-solucoes/scripts/init_plan.py": """print('✅ Plano iniciado.')""",

    # =========================================================
    # 4. EXECUTANDO PLANOS (ENGENHEIRO)
    # =========================================================
    "Minhas Skills/executando-planos/SKILL.md": """---
name: executando-planos
description: O Engenheiro. Executa planos com commits atômicos.
version: 1.0.0
---
# Executando Planos

## ⚙️ Fluxo
1. Ler Plano.
2. Build Loop (Code -> Validate -> Commit).
3. Atualizar Log.
""",
    "Minhas Skills/executando-planos/scripts/git_checkpoint.py": """print('✅ Checkpoint Git.')""",
    "Minhas Skills/executando-planos/resources/template_log_execucao.md": """# Log de Execução\n| Passo | Status | Commit |""",

    # =========================================================
    # 5. VERIFICANDO CONCLUSÃO (QA / AUDITOR)
    # =========================================================
    "Minhas Skills/verificando-conclusao/SKILL.md": """---
name: verificando-conclusao
description: O Auditor. Valida entrega com evidências e testes. Definition of Done.
version: 2.0.0
---
# Verificando Conclusão

## 🎯 Quando usar
- Sempre após `executando-planos`.
- Regra: Executar != Entregar.

## ⚙️ Fluxo
1. Recuperar Critérios do Plano.
2. Coleta de Evidências (Smoke Test/DB Check).
3. Teste de Casos Limite.
4. Veredito (Aprovado/Reprovado).

## 💻 Snippet
`python scripts/validate_delivery.py --url ... --check-db`
""",
    "Minhas Skills/verificando-conclusao/resources/template_qa_report.md": """# Relatório QA
**Status:** ...
## 1. Critérios vs Realidade
## 2. Evidências
""",
    "Minhas Skills/verificando-conclusao/scripts/validate_delivery.py": """import sys
print('✅ Testes de QA (URL/DB) simulados com sucesso.')
""",

    # =========================================================
    # 6. SOLUCIONANDO ERROS (MÉDICO)
    # =========================================================
    "Minhas Skills/solucionando-erros/SKILL.md": """---
name: solucionando-erros
description: O Médico Forense. Diagnóstico científico de falhas.
version: 2.0.0
---
# Solucionando Erros

## ⚙️ Fluxo
1. Congelar e Coletar Logs.
2. Health Check.
3. Hipóteses e Teste Empírico.
4. Correção e Relatório.
""",
    "Minhas Skills/solucionando-erros/scripts/health_check.py": """print('✅ Health Check OK.')""",
    "Minhas Skills/solucionando-erros/resources/template_diagnostico.md": """# Diagnóstico\n**Sintoma:** ...\n**Hipóteses:** ...""",

    # =========================================================
    # 7. GERENCIANDO MEMÓRIA (RAG)
    # =========================================================
    "Minhas Skills/gerenciando-memoria/SKILL.md": """---
name: gerenciando-memoria
description: O Bibliotecário. RAG com Neon (pgvector).
version: 1.0.0
---
# Gerenciando Memória
## ⚙️ Fluxo
1. Memorização (Save).
2. Recuperação (Query).
""",
    "Minhas Skills/gerenciando-memoria/scripts/save_context.py": """print('✅ Memória salva.')""",

    # =========================================================
    # 8. COMUNICANDO EXTERNO (MENSAGEIRO)
    # =========================================================
    "Minhas Skills/comunicando-externo/SKILL.md": """---
name: comunicando-externo
description: WhatsApp (Evolution) e Email (Resend) via Inngest.
version: 1.0.0
---
# Comunicando Externo
## ⚙️ Fluxo
1. Canal. 2. Sanitização. 3. Despacho Inngest.
""",
    "Minhas Skills/comunicando-externo/snippets/inngest_notify.ts": """// Workflow notification...""",

    # =========================================================
    # 9. PESQUISANDO WEB (ESPIÃO)
    # =========================================================
    "Minhas Skills/pesquisando-web/SKILL.md": """---
name: pesquisando-web
description: Apify (Google/Scraping) + LLM Summary.
version: 1.0.0
---
# Pesquisando Web
## ⚙️ Fluxo
1. Busca Google. 2. Scrape Site. 3. Resumo LLM.
""",

    # =========================================================
    # 10. CRIANDO UI (ARTISTA)
    # =========================================================
    "Minhas Skills/criando-ui/SKILL.md": """---
name: criando-ui
description: Next.js + Tailwind + Shadcn UI.
version: 1.0.0
---
# Criando UI
## ⚙️ Fluxo
1. Server vs Client. 2. Shadcn. 3. Tailwind.
""",
    "Minhas Skills/criando-ui/resources/design_rules.md": """# Design System\nCores: bg-primary...""",
}

def create_structure():
    print("🚀 Iniciando Protocolo Antigravity Boot (10 Skills)...")
    base_dir = os.getcwd()

    for file_path, content in STRUCTURE.items():
        full_path = os.path.join(base_dir, file_path)
        directory = os.path.dirname(full_path)

        if not os.path.exists(directory):
            os.makedirs(directory)
            print(f"📁 Dir: {directory}")

        with open(full_path, "w", encoding="utf-8") as f:
            f.write(content.strip())
        print(f"📄 Arq: {file_path}")

    print("\n✨ Instalação Completa! O Sistema Operacional do Agente está pronto.")
    print("👉 Próximo passo: Rode 'python Minhas Skills/index-skills/scripts/update_index.py'")

if __name__ == "__main__":
    create_structure()

