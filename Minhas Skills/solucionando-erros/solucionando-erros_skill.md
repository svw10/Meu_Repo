### 📂 Estrutura de Diretórios

Minhas Skills/
└── solucionando-erros/
    ├── SKILL.md
    ├── scripts/
    │   ├── diagnostico_auto.py    # Analisador que gera o relatório estruturado
    │   └── health_check.py        # Valida conexões (Neon, OpenRouter, APIs)
    └── resources/
        ├── template_diagnostico.md # O formulário de autópsia
        └── guia_de_sobrevivencia.md # Erros conhecidos da Stack


### 1. O Cérebro (`Minhas Skills/solucionando-erros/SKILL.md`)

---
name: solucionando-erros
description: O Médico Forense. Realiza diagnóstico sistemático de falhas na Stack Antigravity (Next.js/Neon/Inngest). Gera hipóteses testáveis, validação empírica e recuperação.
version: 2.0.0
tags: [debug, troubleshooting, logs, inngest, neon]
---

# Solucionando Erros (Scientific Debug Protocol)

## 🎯 Quando usar
- **Falha de Operação**: API retornou 500, Build quebrou, Função Inngest travou.
- **Inconsistência**: O dado foi salvo mas não aparece na tela (Cache vs Banco).
- **Loop de Erro**: O agente tentou corrigir 2x e falhou.
- **Sempre que**: O output esperado de um plano não for atingido.

> **Regra Suprema**: Nunca assuma ("Acho que é X"). **Valide** ("Rodei Y e o retorno foi Z"). Se não há evidência, não há correção.

## ⚙️ Fluxo de Trabalho (O Ciclo de Evidência)

- [ ] **1. Congelamento e Coleta**
    - Pare a execução. Não tente "tentar de novo" cegamente.
    - Capture: `Stack Trace`, `Logs do Inngest`, `Logs da Vercel`.

- [ ] **2. Health Check (Sinais Vitais)**
    - Execute `./scripts/health_check.py` para descartar o óbvio.
    - O Banco (Neon) está acessível? As chaves de API expiraram?

- [ ] **3. Formulação de Hipóteses (Ranking)**
    - Liste 3 possíveis causas ordenadas por probabilidade + facilidade de teste.
    - *Ex: 1. Schema do Neon desatualizado (Alta/Fácil). 2. Bug no código (Média/Médio). 3. Vercel fora do ar (Baixa/Difícil).*

- [ ] **4. Teste de Hipótese (Validação Empírica)**
    - Para cada hipótese, execute um comando de prova.
    - *Hipótese*: "Migration pendente". -> *Teste*: `npx drizzle-kit check`.

- [ ] **5. Aplicação de Correção e Fallback**
    - Aplicar correção. Se falhar, aplicar Fallback (ex: Cache -> Mock -> Erro Gracioso).
    - Preencher o `template_diagnostico.md`.

## 📋 Checklist de Recuperação
O agente deve marcar isso mentalmente:
- [ ] Contexto da falha capturado em log.
- [ ] Hipóteses geradas e validadas.
- [ ] Correção aplicada.
- [ ] O sistema voltou ao estado estável?

## 💻 Snippets e Recursos

### Snippet 1: O Diagnóstico Automático
```bash
# Cole o erro no terminal para gerar o relatório de autópsia
python "Minhas Skills/solucionando-erros/scripts/diagnostico_auto.py"


### Snippet 2: Validação de Infra


# Verifica se Neon, Inngest e APIs estão respondendo
python "Minhas Skills/solucionando-erros/scripts/health_check.py"


---

### 2. O Relatório de Autópsia (`resources/template_diagnostico.md`)

Este template força o agente a estruturar o pensamento antes de codar.

```markdown
# Diagnóstico de Falha: [ID ou Nome do Erro]
**Data:** {{DATE}}
**Componente Afetado:** [Ex: Inngest Function / Next.js Page / Neon DB]

---

## 1. O Sintoma (Fatos)
- **Ação Executada**: `[Comando ou Ação do Usuário]`
- **Erro Observado**: 
  ```text
  [Cole o Stack Trace ou Mensagem de Erro aqui]


## 2. Hipóteses e Validação

*(Ordene da mais provável para a menos provável)*

1. **Hipótese A**: [Descrição]
* **Teste**: `[Comando para validar, ex: npx drizzle-kit check]`
* **Resultado**: [Confirmado / Refutado]


2. **Hipótese B**: [Descrição]
* **Teste**: `[Comando]`
* **Resultado**: [Confirmado / Refutado]



## 3. Solução Aplicada

* **Correção**: [O que foi alterado no código]
* **Commit**: `fix: [descrição]`

## 4. Plano de Fallback (Se a correção falhar)

* Se o erro persistir, o sistema deve: [Ex: Exibir toast de erro e salvar log no Neon]


### 3. O Guia de Sobrevivência (`resources/guia_de_sobrevivencia.md`)
(Mantido e expandido com regras da Stack Imutável)

```markdown
# Guia de Sobrevivência: Stack Antigravity

## 🔴 Inngest (Orquestração)
- **Sintoma**: "Step timed out" ou função não dispara.
- **Causa Provável**: Função muito longa ou `serve()` não exportado na API Route.
- **Validação**: Verifique o dashboard em `http://localhost:8288`.
- **Solução**: Quebre a lógica em `step.run()` menores.

## 🔵 Neon + Drizzle (Dados)
- **Sintoma**: `Relation "xyz" does not exist`.
- **Causa Provável**: Schema definido no código mas migration não aplicada.
- **Validação**: `npx drizzle-kit check`.
- **Solução**: `npx drizzle-kit push`.

## 🟢 Next.js (Frontend)
- **Sintoma**: Erro 500 em produção, funciona em local.
- **Causa Provável**: Variável de ambiente (`.env`) não adicionada no painel da Vercel.
- **Validação**: Check Vercel Project Settings > Environment Variables.


### 4. Scripts Inteligentes

#### `scripts/diagnostico_auto.py`

Este script usa a LLM para preencher o template de diagnóstico automaticamente baseado no erro colado.

import sys
import os
import datetime
from openai import OpenAI

client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))
TEMPLATE_PATH = os.path.join(os.path.dirname(__file__), "../resources/template_diagnostico.md")

def generate_diagnosis():
    print("🚑 MODO DE DIAGNÓSTICO FORENSE")
    print("Cole o erro/log abaixo (Ctrl+D/Ctrl+Z para enviar):")
    
    try:
        error_log = sys.stdin.read()
    except EOFError:
        return

    if not error_log.strip():
        print("Nenhum erro fornecido.")
        return

    print("\n🧠 Analisando falha e gerando hipóteses...\n")

    prompt = f"""
    Atue como um Engenheiro Sênior especialista em Next.js, Neon, Inngest e Vercel.
    Analise o erro abaixo e preencha o seguinte Template Markdown.
    Seja técnico, direto e ordene hipóteses por probabilidade.
    
    ERRO:
    {error_log}
    
    TEMPLATE:
    (Use o formato padrão de Diagnóstico de Falha, incluindo Hipóteses e Comandos de Teste específicos para a stack citada).
    """

    response = client.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": prompt}]
    )

    report = response.choices[0].message.content
    
    # Salva relatório
    filename = f"DIAGNOSTIC-{datetime.datetime.now().strftime('%Y%m%d-%H%M')}.md"
    with open(filename, "w", encoding="utf-8") as f:
        f.write(report)
    
    print(report)
    print(f"\n✅ Relatório salvo em: {filename}")

if __name__ == "__main__":
    generate_diagnosis()


#### `scripts/health_check.py`

Script rápido para validar se o ambiente está saudável.

import os
import socket
import requests
import psycopg2

def check_port(host, port):
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.settimeout(2)
        return s.connect_ex((host, port)) == 0

def check_db(connection_string):
    try:
        conn = psycopg2.connect(connection_string)
        conn.close()
        return True
    except:
        return False

def run_health_check():
    print("🏥 EXECUTANDO HEALTH CHECK DA STACK...\n")
    
    # 1. Banco de Dados (Neon)
    db_url = os.getenv("DATABASE_URL")
    if db_url and check_db(db_url):
        print("✅ Neon DB: Conectado")
    else:
        print("❌ Neon DB: Falha na conexão ou DATABASE_URL ausente")

    # 2. Inngest Dev Server
    if check_port("localhost", 8288):
        print("✅ Inngest Dev Server: Rodando (Port 8288)")
    else:
        print("⚠️ Inngest Dev Server: Parado (Jobs não rodarão localmente)")

    # 3. Next.js App
    if check_port("localhost", 3000):
        print("✅ Next.js App: Rodando (Port 3000)")
    else:
        print("⚠️ Next.js App: Parado")

    # 4. APIs Externas (Ping simples)
    try:
        if requests.get("https://api.openai.com", timeout=2).status_code >= 200:
            print("✅ Internet/OpenAI: Acessível")
    except:
        print("❌ Internet/OpenAI: Inacessível")

if __name__ == "__main__":
    run_health_check()

