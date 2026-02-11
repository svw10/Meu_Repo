### 📂 Estrutura de Diretórios

Minhas Skills/
└── executando-planos/
    ├── SKILL.md
    ├── scripts/
    │   ├── update_progress.py     # Atualiza o checklist do plano (marca [x])
    │   └── git_checkpoint.py      # Cria commits atômicos após cada passo
    └── resources/
        └── template_log_execucao.md



### 1. O Cérebro (`Minhas Skills/executando-planos/SKILL.md`)

---
name: executando-planos
description: O Engenheiro. Executa planos atômicos (gerados por planning-plans) com rigor militar. Implementa código, valida builds e gerencia commits.
version: 1.0.0
tags: [execução, código, git, deploy]
---

# Executando Planos no Antigravity

## 🎯 Quando usar
- O usuário diz: "Execute o plano X" ou "Implemente a feature Y".
- Já existe um arquivo `docs/PLAN-*.md` aprovado.
- É hora de escrever código (Next.js, Drizzle, Inngest) e rodar comandos.

> **Regra de Ouro**: Nunca escreva uma linha de código sem ter um **Passo Atômico** ativo no plano. Sem plano, sem código.

## ⚙️ Fluxo de Trabalho (The Build Loop)

- [ ] **1. Bootstrapping**
    - Ler o arquivo de plano (`docs/PLAN-[nome].md`).
    - Criar um arquivo de **Log de Execução** (`docs/RUN-[nome].md`) baseado no template.

- [ ] **2. Ciclo de Execução Atômica (Repetir para cada passo)**
    - **A. Pré-Validação**: Verificar se os arquivos necessários existem.
    - **B. Implementação**: Escrever o código ou rodar o comando (ex: `npx drizzle-kit push`).
    - **C. Validação de Build**: Rodar verificação rápida (ex: `tsc --noEmit` ou ver se o servidor não quebrou).
    - **D. Checkpoint (Git)**: Se funcionou, commitar imediatamente: `git commit -m "feat: [passo X] concluído"`.
    - **E. Atualizar Log**: Marcar `[x]` no arquivo de log usando o script.

- [ ] **3. Tratamento de Erros (Fallback)**
    - Se o passo falhar (erro de build/lint):
        - **Não avance**.
        - Leia o erro.
        - Tente corrigir até 3 vezes.
        - Se falhar 3x, reverta para o último commit (`git reset --hard`) e peça ajuda.

- [ ] **4. Finalização**
    - Deploy de preview na Vercel (se aplicável).
    - Notificar usuário da conclusão.

## 🧱 Stack Binding (Comandos de Validação)
Para considerar um passo "Concluído", use estes validadores da stack:

| Componente Alterado | Comando de Validação Sugerido |
| :--- | :--- |
| **Banco de Dados (Neon)** | `npx drizzle-kit studio` (Verificar schema visualmente) |
| **Backend/Types** | `npm run type-check` (Zero erros de TS) |
| **Inngest Functions** | Verificar dashboard local (`http://localhost:8288`) |
| **Frontend/UI** | Verificar `localhost:3000` sem erros no console |

## 💻 Snippets e Recursos

### Snippet 1: Atualizador de Progresso
```bash
# Marca o passo 3 como concluído no log
python "Minhas Skills/executando-planos/scripts/update_progress.py" --file "docs/RUN-feature.md" --step 3


### Snippet 2: Checkpoint Seguro


# Valida e commita apenas se não houver erros graves
python "Minhas Skills/executando-planos/scripts/git_checkpoint.py" --msg "feat: adiciona tabela users"

---

### 2. O Template de Log (`Minhas Skills/executando-planos/resources/template_log_execucao.md`)

Diferente do plano (que é teórico), este arquivo é o "Diário de Bordo" da execução real.

```markdown
# Log de Execução: [Nome da Feature]
**Plano Base:** `docs/PLAN-[nome].md`
**Inicio:** {{DATE}}

---

## Status da Execução

| Passo | Descrição Atômica | Status | Commit Hash |
| :--- | :--- | :--- | :--- |
| 01 | Configurar Schema Drizzle | [ ] Pendente | - |
| 02 | Rodar Migration Neon | [ ] Pendente | - |
| 03 | Criar Rota Inngest | [ ] Pendente | - |
| ... | ... | ... | ... |

## Diário de Erros e Recuperações
*(O agente deve registrar aqui se algo deu errado e como corrigiu)*

- [Hora]: Erro ao rodar migration. Motivo: Variável DATABASE_URL ausente. Correção: Adicionei ao .env.local.

---

### 3. Scripts Auxiliares

#### `Minhas Skills/executando-planos/scripts/update_progress.py`

(Mantém o arquivo de log atualizado para você não se perder)


import sys
import os
import re

def update_step(file_path, step_number):
    if not os.path.exists(file_path):
        print("❌ Arquivo de log não encontrado.")
        return

    with open(file_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()

    new_lines = []
    updated = False
    
    # Procura a linha que começa com "| 0X |" ou "| X |"
    step_pattern = re.compile(rf"\|\s*0?{step_number}\s*\|")

    for line in lines:
        if step_pattern.match(line) and "[ ] Pendente" in line:
            line = line.replace("[ ] Pendente", "✅ Concluído")
            updated = True
        new_lines.append(line)

    if updated:
        with open(file_path, 'w', encoding='utf-8') as f:
            f.writelines(new_lines)
        print(f"✅ Passo {step_number} marcado como concluído em {file_path}")
    else:
        print(f"⚠️ Passo {step_number} não encontrado ou já concluído.")

if __name__ == "__main__":
    # Uso simples: python update_progress.py --file X --step Y
    try:
        f_idx = sys.argv.index("--file") + 1
        s_idx = sys.argv.index("--step") + 1
        update_step(sys.argv[f_idx], sys.argv[s_idx])
    except ValueError:
        print("Uso: python update_progress.py --file path/to/log.md --step 1")



#### `Minhas Skills/executando-planos/scripts/git_checkpoint.py`

(Garante que o agente faça commits pequenos e frequentes, evitando perda de trabalho)

import sys
import subprocess

def git_checkpoint(message):
    print("🛡️ Iniciando Checkpoint de Segurança...")
    
    # 1. Tenta adicionar arquivos
    try:
        subprocess.run(["git", "add", "."], check=True)
    except subprocess.CalledProcessError:
        print("❌ Falha ao adicionar arquivos ao Git.")
        return

    # 2. Executa commit
    try:
        subprocess.run(["git", "commit", "-m", message], check=True)
        print(f"✅ Checkpoint salvo: '{message}'")
    except subprocess.CalledProcessError:
        print("⚠️ Nada a commitar ou erro no Git.")

if __name__ == "__main__":
    if len(sys.argv) < 3 or sys.argv[1] != "--msg":
        print("Uso: python git_checkpoint.py --msg \"feat: descricao\"")
    else:
        git_checkpoint(sys.argv[2])

