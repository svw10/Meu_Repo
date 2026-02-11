name: executando-planos
description: O Engenheiro. Executa planos atômicos com rigor militar. Implementa código, valida builds, gerencia commits e rastreia progresso. Agnóstico de stack e projeto.
version: 2.0.0
tags: [execução, código, git, deploy, universal, build-loop]
author: System Architect
---

# Executando Planos (Build Loop Protocol)

## 🎯 Quando usar
- O usuário diz: "Execute o plano X" ou "Implemente a feature Y"
- Já existe um arquivo `docs/PLAN-*.md` aprovado e validado
- É hora de escrever código e transformar especificação em realidade
- Qualquer tipo de tarefa: código, infra, configuração, migração

> **Regra de Ouro**: Nunca escreva uma linha de código sem ter um **Passo Atômico** ativo no plano. Sem plano, sem código.

> **Regra de Platina**: Se o plano não existe, invoque `planejando-solucoes` primeiro.

## 🧱 Stack do Projeto (Configurável)

Os comandos de validação são determinados pelo `project-context.json`:

**Exemplo SnapFit (Next.js + Neon + Inngest):**
| Componente | Comando de Validação |
| :--- | :--- |
| Banco de Dados | `npx drizzle-kit studio` |
| Types/Backend | `npm run type-check` |
| Inngest Functions | Dashboard em `localhost:8288` |
| Frontend/UI | `localhost:3000` sem erros |

**Exemplo AprenderIA (Go + Neon):**
| Componente | Comando de Validação |
| :--- | :--- |
| Banco de Dados | `go run cmd/migrate/main.go` |
| Backend | `go build ./...` |
| Tests | `go test ./... -v` |
| API | `curl localhost:8080/health` |

**Exemplo Genérico (Python + Django):**
| Componente | Comando de Validação |
| :--- | :--- |
| Banco | `python manage.py migrate` |
| Backend | `python manage.py check` |
| Tests | `pytest` |
| Admin | `localhost:8000/admin` |

## ⚙️ Fluxo de Trabalho (The Build Loop)

### Passo 1: Bootstrapping (2 min)
- [ ] Ler o arquivo de plano (`docs/PLAN-[nome].md`)
- [ ] Carregar `project-context.json` para entender a stack
- [ ] Criar arquivo de **Log de Execução** (`docs/RUN-[nome].md`) baseado no template
- [ ] Identificar passo atual (primeiro não concluído)

### Passo 2: Ciclo de Execução Atômica (Repetir para cada passo)

#### A. Pré-Validação (1 min)
- [ ] Verificar se arquivos necessários existem
- [ ] Confirmar que dependências do passo anterior estão satisfeitas
- [ ] Validar ambiente (variáveis de ambiente, conexões)

#### B. Implementação (5-10 min)
- [ ] Executar ação descrita no plano (código, comando, config)
- [ ] Seguir exatamente o que está no plano, sem improvisar
- [ ] Se plano estiver ambíguo, pausar e solicitar clarificação

#### C. Validação de Build (2 min)
- [ ] Rodar verificação rápida específica da stack
- [ ] Zero erros de compilação/type-check
- [ ] Zero erros de lint
- [ ] Servidor/ambiente não quebrou

#### D. Checkpoint (Git) (1 min)
- [ ] `git add .` (apenas arquivos relevantes)
- [ ] `git commit -m "feat: [passo X] - [descrição curta]"`
- [ ] Anotar hash do commit no log de execução

#### E. Atualizar Progresso (30 seg)
- [ ] Marcar `[x]` no `docs/RUN-[nome].md`
- [ ] Registrar tempo gasto
- [ ] Anotar observações (erros encontrados, soluções aplicadas)

### Passo 3: Tratamento de Erros (Fallback)

**Se o passo falhar (erro de build/lint/execução):**

1. **NÃO AVANCE** para o próximo passo
2. **Leia o erro** cuidadosamente (não ignore stack trace)
3. **Tente corrigir** (máximo 3 tentativas):
   - Tentativa 1: Corrigir sintaxe/typo óbvio
   - Tentativa 2: Verificar documentação/oficial
   - Tentativa 3: Buscar padrões similares no código existente
4. **Se falhar 3x**:
   - Reverter para último commit: `git reset --hard HEAD`
   - Registrar no log: erro, tentativas, motivo da falha
   - Invocar `solucionando-erros` ou notificar usuário

### Passo 4: Finalização

- [ ] Todos os passos do plano marcados como concluídos
- [ ] Validação final completa (todos os comandos de stack)
- [ ] Deploy de preview (se aplicável: Vercel, Railway, etc)
- [ ] Atualizar `docs/RUN-[nome].md` com resumo final
- [ ] Notificar usuário da conclusão com evidências

## 🛠️ Scripts e Utilitários

### Atualizar progresso de um passo:
```bash
python skills/executando-planos/scripts/update_progress.py \
  --file "docs/RUN-sistema-de-creditos.md" \
  --step 3 \
  --status "concluido" \
  --commit "a1b2c3d"
```

### Criar checkpoint git:
```bash
python skills/executando-planos/scripts/git_checkpoint.py \
  --msg "feat: adiciona tabela de créditos" \
  --validate "npm run type-check"
```

### Iniciar execução de plano:
```bash
python skills/executando-planos/scripts/start_execution.py \
  --plan "docs/PLAN-sistema-de-creditos.md" \
  --project SnapFit
```

### Verificar status atual:
```bash
python skills/executando-planos/scripts/check_status.py \
  --file "docs/RUN-sistema-de-creditos.md"
```

## 💻 Código dos Scripts

### update_progress.py
```python
#!/usr/bin/env python3
"""
Atualiza o progresso de execução no log.
"""

import argparse
import re
from datetime import datetime
from pathlib import Path

def update_progress(file_path: str, step: int, status: str, commit: str = None, notes: str = None):
    """Atualiza status de um passo no log de execução."""
    
    path = Path(file_path)
    if not path.exists():
        print(f"❌ Arquivo não encontrado: {file_path}")
        return False
    
    content = path.read_text()
    lines = content.split('\n')
    
    # Padrão: | 03 | Descrição | [ ] Pendente | - |
    step_pattern = re.compile(rf'^(\|\s*{step:02d}\s*\|.*?\|)\s*\[\s*\]\s*Pendente\s*(\|.*?\|)$')
    
    updated = False
    for i, line in enumerate(lines):
        match = step_pattern.match(line)
        if match:
            timestamp = datetime.now().strftime("%H:%M")
            status_str = f"✅ Concluído ({timestamp})" if status == "concluido" else f"❌ Falhou ({timestamp})"
            commit_str = commit if commit else "-"
            
            lines[i] = f"{match.group(1)} {status_str} | {commit_str} |"
            
            # Adicionar notas se fornecidas
            if notes:
                lines.insert(i + 1, f"| | | Notas: {notes} | |")
            
            updated = True
            break
    
    if not updated:
        print(f"⚠️ Passo {step} não encontrado ou já atualizado")
        return False
    
    path.write_text('\n'.join(lines))
    print(f"✅ Passo {step} atualizado: {status}")
    return True

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--file", required=True, help="Arquivo RUN-*.md")
    parser.add_argument("--step", type=int, required=True, help="Número do passo")
    parser.add_argument("--status", choices=["concluido", "falhou", "em_andamento"], required=True)
    parser.add_argument("--commit", help="Hash do commit (opcional)")
    parser.add_argument("--notes", help="Observações (opcional)")
    args = parser.parse_args()
    
    update_progress(args.file, args.step, args.status, args.commit, args.notes)

if __name__ == "__main__":
    main()
```

### git_checkpoint.py
```python
#!/usr/bin/env python3
"""
Cria commits atômicos com validação prévia.
"""

import argparse
import subprocess
import sys
from pathlib import Path

def run_command(cmd: list, description: str) -> bool:
    """Executa comando e retorna sucesso/falha."""
    print(f"🔄 {description}...")
    try:
        result = subprocess.run(cmd, check=True, capture_output=True, text=True)
        print(f"✅ {description} - OK")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ {description} - FALHOU")
        print(f"   Erro: {e.stderr}")
        return False

def git_checkpoint(message: str, validate_cmd: str = None, dry_run: bool = False):
    """Cria checkpoint git com validações."""
    
    print(f"🛡️ Checkpoint: '{message}'")
    print("=" * 50)
    
    # 1. Verificar se há mudanças
    result = subprocess.run(["git", "status", "--porcelain"], capture_output=True, text=True)
    if not result.stdout.strip():
        print("⚠️ Nada para commitar")
        return False
    
    # 2. Validação opcional
    if validate_cmd:
        if not run_command(validate_cmd.split(), "Validação"):
            print("❌ Validação falhou. Commit abortado.")
            return False
    
    # 3. Dry run (simulação)
    if dry_run:
        print("🔍 Dry run - não commitando")
        print(f"   Mensagem seria: {message}")
        return True
    
    # 4. Git add
    if not run_command(["git", "add", "."], "Stage"):
        return False
    
    # 5. Git commit
    if not run_command(["git", "commit", "-m", message], "Commit"):
        return False
    
    # 6. Obter hash
    result = subprocess.run(["git", "rev-parse", "--short", "HEAD"], 
                          capture_output=True, text=True)
    commit_hash = result.stdout.strip()
    
    print(f"✅ Checkpoint salvo: {commit_hash}")
    return True

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--msg", required=True, help="Mensagem do commit")
    parser.add_argument("--validate", help="Comando de validação (ex: 'npm run type-check')")
    parser.add_argument("--dry-run", action="store_true", help="Simular sem commitar")
    args = parser.parse_args()
    
    success = git_checkpoint(args.msg, args.validate, args.dry_run)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
```

### start_execution.py
```python
#!/usr/bin/env python3
"""
Inicia execução de um plano atômico.
"""

import argparse
import json
import re
from datetime import datetime
from pathlib import Path

def load_project_context(project: str) -> dict:
    """Carrega contexto do projeto."""
    paths = [
        f"projects/{project}/context.json",
        f"{project}/context.json",
        "project-context.json"
    ]
    for p in paths:
        if Path(p).exists():
            return json.loads(Path(p).read_text())
    return {"name": project, "stack": ["generic"]}

def create_run_log(plan_path: str, project: str) -> str:
    """Cria arquivo de log de execução baseado no plano."""
    
    plan_file = Path(plan_path)
    if not plan_file.exists():
        raise FileNotFoundError(f"Plano não encontrado: {plan_path}")
    
    plan_content = plan_file.read_text()
    context = load_project_context(project)
    
    # Extrair nome da feature
    name_match = re.search(r'# Plano Atômico: (.+)', plan_content)
    feature_name = name_match.group(1) if name_match else "Feature"
    
    # Extrair passos (simplificado)
    steps = re.findall(r'(\d+)\. \[ \] \*\*(.+?)\*\*', plan_content)
    
    # Criar log
    log_content = f"""# Log de Execução: {feature_name}
**Plano Base:** `{plan_path}`
**Projeto:** {project}
**Stack:** {', '.join(context.get('stack', ['generic']))}
**Início:** {datetime.now().isoformat()}

---

## Status da Execução

| Passo | Descrição Atômica | Status | Commit Hash | Notas |
| :--- | :--- | :--- | :--- | :--- |
"""
    
    for num, desc in steps:
        log_content += f"| {int(num):02d} | {desc} | [ ] Pendente | - | - |\n"
    
    log_content += """
---

## Diário de Erros e Recuperações
*(Registre aqui problemas encontrados e como resolveu)*

---

## Resumo Final
**Status Geral:** 🟡 Em Execução  
**Passos Concluídos:** 0 / {total}  
**Tempo Total:** -  
**Deploy:** -  
"""
    
    # Salvar
    log_name = plan_file.name.replace("PLAN-", "RUN-")
    log_path = Path("docs") / log_name
    
    log_path.parent.mkdir(exist_ok=True)
    log_path.write_text(log_content)
    
    return str(log_path)

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--plan", required=True, help="Caminho do arquivo PLAN-*.md")
    parser.add_argument("--project", default="default", help="Nome do projeto")
    args = parser.parse_args()
    
    try:
        log_path = create_run_log(args.plan, args.project)
        print(f"✅ Log de execução criado: {log_path}")
        print(f"🚀 Pronto para iniciar o Build Loop")
    except Exception as e:
        print(f"❌ Erro: {e}")

if __name__ == "__main__":
    main()
```

## 📄 Template de Log de Execução

**Arquivo:** `docs/RUN-[nome].md`

```markdown
# Log de Execução: [Nome da Feature]
**Plano Base:** `docs/PLAN-[nome].md`  
**Projeto:** [Nome do Projeto]  
**Stack:** [Ferramentas]  
**Início:** [YYYY-MM-DD HH:MM]

---

## Status da Execução

| Passo | Descrição Atômica | Status | Commit Hash | Notas |
| :--- | :--- | :--- | :--- | :--- |
| 01 | [Descrição do passo 1] | [ ] Pendente | - | - |
| 02 | [Descrição do passo 2] | [ ] Pendente | - | - |
| 03 | [Descrição do passo 3] | [ ] Pendente | - | - |

---

## Diário de Erros e Recuperações

### [HH:MM] - Passo [X]: [Título do erro]
- **Problema:** [Descrição]
- **Causa:** [Root cause]
- **Solução:** [Como resolveu]
- **Prevenção:** [Como evitar no futuro]

---

## Resumo Final

**Status Geral:** [🟡 Em Execução / 🟢 Concluído / 🔴 Bloqueado]  
**Passos Concluídos:** [X] / [Y]  
**Tempo Total:** [Z minutos]  
**Deploy:** [URL ou comando]

### Evidências
- [Screenshot/Link 1]
- [Screenshot/Link 2]

### Lições Aprendidas
- [O que funcionou bem]
- [O que melhorar no próximo plano]
```

## 🚫 Anti-Padrões

- ❌ Executar sem plano aprovado
- ❌ Pular validação de build
- ❌ Commitar sem testar localmente
- ❌ Avançar com erro não resolvido
- ❌ Não registrar erros no diário
- ❌ Commit gigante (múltiplos passos)
- ❌ Ignorar falha de validação da stack
- ❌ Não atualizar o log de execução

## ✅ Checklist de Qualidade

- [ ] Plano existe e está validado
- [ ] Contexto do projeto carregado
- [ ] Log de execução criado
- [ ] Cada passo: implementação → validação → commit
- [ ] Máximo 3 tentativas por erro
- [ ] Rollback se falha persistente
- [ ] Diário de erros atualizado
- [ ] Resumo final preenchido
- [ ] Deploy realizado (se aplicável)

## 🔗 Integrações

- **Chama:** `usando-skills` (para ser invocada)
- **É chamada por:** `planejando-solucoes` (após plano aprovado)
- **Chama:** `solucionando-erros` (em caso de falha persistente)
- **Chama:** `verificando-conclusao` (ao finalizar)
- **Depende de:** `project-context.json` (para comandos de stack)

## 📝 Changelog

### v2.0.0 (2026-02-10)
- **BREAKING**: Stack configurável via `project-context.json`
- **ADD**: Suporte a múltiplas stacks (Next.js, Go, Python, etc)
- **ADD**: Script `start_execution.py` para inicialização
- **ADD**: Script `check_status.py` para acompanhamento
- **ADD**: Campos de notas no log de execução
- **ADD**: Diário de erros estruturado
- **ADD**: Resumo final com lições aprendidas
- **REMOVE**: Stack fixa "Antigravity" (tornada configurável)
- **IMPROVE**: Validação prévia mais robusta
- **IMPROVE**: Tratamento de erro com rollback automático

### v1.0.0 (Original)
- Conceito de Build Loop
- Commits atômicos
- Log de execução básico
- Validação de stack fixa

---
