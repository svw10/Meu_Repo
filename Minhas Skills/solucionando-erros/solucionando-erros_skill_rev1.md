name: solucionando-erros
description: O Médico Forense. Realiza diagnóstico sistemático de falhas em qualquer stack tecnológica. Gera hipóteses testáveis, validação empírica e recuperação via padrões universais de debugging.
version: 3.0.0
tags: [debug, troubleshooting, logs, generic, observability, recovery]
---

# Solucionando Erros (Scientific Debug Protocol v3.0)

## 🎯 Quando usar
- **Falha de Operação**: API retornou 500, Build quebrou, Worker travou, Container caiu.
- **Inconsistência**: Dado salvo mas não aparece (Cache vs Banco vs Estado).
- **Loop de Erro**: Agente tentou corrigir 2x e falhou.
- **Degradação**: Sistema lento, timeouts, memory leaks.
- **Sempre que**: Output esperado de um plano não for atingido.

> **Regra Suprema**: Nunca assuma ("Acho que é X"). **Valide** ("Rodei Y e o retorno foi Z"). Se não há evidência, não há correção.

---

## 🧱 Detecção de Stack (Agnóstica)

A skill detecta automaticamente o ambiente ou usa `project-context.json`:

```json
{
  "project": "meu-saas",
  "stack": ["nextjs", "neon", "inngest"],
  "debug_config": {
    "log_level": "debug",
    "health_checks": {
      "database": true,
      "cache": true,
      "external_apis": ["openrouter", "stripe"]
    },
    "fallback_strategy": "graceful_degradation"
  }
}
```

### Stacks Suportadas (Auto-detecção)

| Categoria | Detectável Por | Comandos de Diagnóstico |
| :--- | :--- | :--- |
| **Node.js/Next.js** | `package.json`, `next.config.*` | `npm run build`, `npm test`, `node --version` |
| **Python** | `requirements.txt`, `pyproject.toml` | `python -m pytest`, `pip check`, `python --version` |
| **Go** | `go.mod`, `main.go` | `go build`, `go test`, `go version` |
| **Rust** | `Cargo.toml` | `cargo build`, `cargo test`, `rustc --version` |
| **Docker** | `Dockerfile`, `docker-compose.yml` | `docker ps`, `docker logs`, `docker-compose config` |
| **Database** | `DATABASE_URL`, migration files | `pg_isready`, `mysqladmin ping`, connection test |
| **Queues** | `inngest`, `celery`, `bull` config | Dashboard local, CLI status |
| **Infra** | `vercel.json`, `fly.toml`, `k8s/` | `vercel logs`, `fly status`, `kubectl get pods` |

---

## ⚙️ Fluxo de Trabalho (O Ciclo de Evidência)

### Passo 1: Congelamento e Coleta (2 min)

- [ ] **Parar execução**: Não tente "tentar de novo" cegamente
- [ ] **Capturar contexto**:
  - Stack trace completo (últimos 50 frames)
  - Logs recentes (últimos 100 linhas ou desde último deploy)
  - Estado do sistema (memória, CPU, conexões)
  - Última alteração conhecida (git diff, timestamp)

**Comandos por stack:**

```bash
# Node.js/Next.js
npm run build 2>&1 | tee build.log
vercel logs --json > logs.json 2>/dev/null || echo "Vercel CLI não disponível"

# Python
python -c "import traceback; traceback.print_exc()" 2>&1 | tee error.log
pytest -v --tb=short 2>&1 | tee test.log

# Go
go build ./... 2>&1 | tee build.log
go test -v ./... 2>&1 | tee test.log

# Docker
docker-compose logs --tail=100 > container_logs.txt
docker stats --no-stream > container_stats.txt
```

---

### Passo 2: Health Check (Sinais Vitais) (3 min)

Execute `./scripts/health_check.py` para descartar o óbvio:

- [ ] **Ambiente**: Variáveis de ambiente carregadas? (`.env`, secrets)
- [ ] **Build**: Compilação limpa em todas as camadas?
- [ ] **Conectividade**: Banco, Cache, APIs externas respondem?
- [ ] **Recursos**: Disco, memória, CPU dentro do normal?
- [ ] **Dependências**: Todas as versões compatíveis? (lock files)

**Validações universais:**

| Componente | Comando Genérico | Saída Esperada |
| :--- | :--- | :--- |
| Env Vars | `env \| grep -E "(API_KEY\|DATABASE)" \| wc -l` | > 0 |
| Build | Detectado via `project-context.json` | Exit 0 |
| Database | Connection string test | Ping < 100ms |
| HTTP Endpoint | `curl -s -o /dev/null -w "%{http_code}" URL` | 200-299 |
| Disk Space | `df -h . \| tail -1 \| awk '{print $5}'` | < 90% |
| Memory | `free -m \| grep Mem \| awk '{print $7}'` | > 100MB |

---

### Passo 3: Formulação de Hipóteses (Ranking) (5 min)

Liste 3 possíveis causas ordenadas por:
1. **Probabilidade** (quão comum é nesta stack)
2. **Facilidade de teste** (quão rápido validar)
3. **Impacto** (quão crítico se for verdade)

**Template de Hipóteses:**

```markdown
| Rank | Hipótese | Prob. | Teste | Tempo |
| :--- | :--- | :--- | :--- | :--- |
| 1 | [Causa provável] | Alta | [Comando específico] | 30s |
| 2 | [Causa secundária] | Média | [Comando específico] | 2min |
| 3 | [Edge case] | Baixa | [Comando específico] | 5min |
```

**Exemplos por categoria de erro:**

**Erro: "Connection refused"**
1. Serviço não está rodando (porta fechada) → `lsof -i :PORTA`
2. Firewall/rede bloqueando → `telnet host porta`
3. DNS mal resolvido → `nslookup host`

**Erro: "Timeout"**
1. Query lenta no banco → `EXPLAIN ANALYZE` ou logs de query
2. API externa lenta → `curl -w "@curl-format.txt"` (time_total)
3. Deadlock/Lock → `SHOW PROCESSLIST` (MySQL) ou `pg_locks`

**Erro: "Memory exhausted"**
1. Memory leak em loop → Heap dump analysis
2. Dataset muito grande para RAM → Streaming/pagination
3. Configuração de limite baixa → `ulimit -a`

---

### Passo 4: Teste de Hipótese (Validação Empírica) (5 min)

Para cada hipótese, execute **um comando de prova**:

- [ ] **Hipótese 1**: Comando → Resultado → Conclusão (Confirmado/Refutado)
- [ ] **Hipótese 2**: Comando → Resultado → Conclusão
- [ ] **Hipótese 3**: Comando → Resultado → Conclusão

**Regras:**
- Se confirmada: Pare, vá para Passo 5
- Se refutada: Documente o que aprendeu, vá para próxima
- Se inconclusiva: Refinar hipótese (mais específica)

---

### Passo 5: Aplicação de Correção e Fallback (5 min)

- [ ] **Aplicar correção mínima**: Menor mudança que resolve
- [ ] **Testar localmente**: Reproduzir cenário de falha
- [ ] **Preparar fallback**: Estratégia se correção falhar

**Estratégias de Fallback (ordem de preferência):**

1. **Graceful Degradation**: Desativar feature não-crítica, manter core
2. **Circuit Breaker**: Parar de chamar serviço falho, retornar default
3. **Retry com Backoff**: Tentar novamente (exponencial: 1s, 2s, 4s, 8s)
4. **Mock/Stub**: Retornar dados simulados temporariamente
5. **Modo Offline**: Funcionar com cache local
6. **Fail Fast**: Parar tudo e notificar (último recurso)

**Preencher**: `template_diagnostico.md` com toda a jornada.

---

## 📋 Checklist de Recuperação

- [ ] Contexto da falha capturado (logs, stack trace, estado)
- [ ] Health check executado (ambiente saudável?)
- [ ] Hipóteses geradas e priorizadas (top 3)
- [ ] Validação empírica realizada (evidências)
- [ ] Correção aplicada e testada
- [ ] Fallback documentado e pronto
- [ ] Sistema retornou ao estado estável
- [ ] Relatório de autópsia preenchido
- [ ] Prevenção futura identificada (monitoramento, teste)

---

## 💻 Scripts e Recursos

### Snippet 1: Diagnóstico Automático
```bash
# Gera relatório de autópsia estruturado
python "Minhas Skills/solucionando-erros/scripts/diagnostico_auto.py" \
  --project-path "." \
  --error-log "logs/error.log" \
  --output "docs/DIAGNOSTIC-001.md"
```

### Snippet 2: Health Check Universal
```bash
# Valida todo o ambiente detectado automaticamente
python "Minhas Skills/solucionando-erros/scripts/health_check.py" \
  --project-path "." \
  --strict  # Falha se qualquer check não passar
```

### Snippet 3: Análise de Logs
```bash
# Extrai padrões de erro de qualquer log
python "Minhas Skills/solucionando-erros/scripts/log_analyzer.py" \
  --file "app.log" \
  --pattern "ERROR|FATAL|Exception" \
  --context 5  # linhas de contexto
```

---

## 🗂️ Estrutura de Recursos

```
Minhas Skills/solucionando-erros/
├── SKILL.md                          # Este protocolo
├── scripts/
│   ├── diagnostico_auto.py           # Gera relatório de autópsia
│   ├── health_check.py               # Valida ambiente (universal)
│   └── log_analyzer.py               # Extrai padrões de logs
└── resources/
    ├── template_diagnostico.md       # Template de autópsia
    ├── guia_de_erros_comuns.md       # Erros frequentes por stack
    └── fallback_strategies.md        # Catálogo de recuperação
```

---

## 📄 Templates

### Template de Diagnóstico (`resources/template_diagnostico.md`)

```markdown
# Diagnóstico de Falha: [ID-ÚNICO]
**Data:** {{DATE}}
**Projeto:** {{PROJECT_NAME}}
**Stack Detectada:** {{STACK}}
**Severidade:** [🔴 Crítica / 🟠 Alta / 🟡 Média / 🟢 Baixa]

---

## 1. Contexto da Falha (Fatos)

**Ação Executada:**
```bash
[Comando ou ação que disparou o erro]
```

**Erro Observado:**
```text
[Stack trace completo ou mensagem de erro]
```

**Ambiente:**
- OS: {{OS}}
- Runtime: {{RUNTIME_VERSION}}
- Último deploy: {{TIMESTAMP}}
- Git commit: {{COMMIT_HASH}}

**Logs Relevantes:**
```text
[Últimas 20 linhas de log ou trecho específico]
```

---

## 2. Health Check (Sinais Vitais)

| Componente | Status | Detalhes |
| :--- | :--- | :--- |
| Build | [✅/❌] | [Saída do build] |
| Database | [✅/❌] | [Latência/Conexão] |
| Cache | [✅/❌] | [Hit/Miss rate] |
| APIs Externas | [✅/❌] | [Status codes] |
| Recursos | [✅/❌] | [CPU/Mem/Disco] |

---

## 3. Hipóteses e Validação

### Hipótese 1: [Título descritivo]
- **Descrição:** [O que se suspeita]
- **Probabilidade:** [Alta/Média/Baixa]
- **Teste Executado:**
  ```bash
  [Comando exato]
  ```
- **Resultado:** [Saída do comando]
- **Status:** [✅ Confirmada / ❌ Refutada / ⏳ Inconclusiva]

### Hipótese 2: [Título descritivo]
- **Descrição:** ...
- **Teste Executado:** ...
- **Resultado:** ...
- **Status:** ...

### Hipótese 3: [Título descritivo]
- **Descrição:** ...
- **Teste Executado:** ...
- **Resultado:** ...
- **Status:** ...

---

## 4. Solução Aplicada

**Causa Raiz Identificada:**
[Explicação clara do porquê do erro]

**Correção Implementada:**
```diff
[Diff ou descrição da mudança]
```

**Commit:** `fix: [descrição curta]`

**Teste de Regressão:**
```bash
[Comando que prova que o erro não volta]
```

---

## 5. Plano de Fallback (Se falhar)

**Estratégia:** [Graceful Degradation / Circuit Breaker / Retry / Mock]

**Implementação:**
```python
# Código de fallback
```

**Gatilho de Ativação:** [Quando usar o fallback]

---

## 6. Prevenção Futura

- [ ] Adicionar teste automatizado para este cenário
- [ ] Configurar alerta de monitoramento
- [ ] Atualizar documentação
- [ ] Revisar arquitetura (se recorrente)

---

**Resolvido por:** {{AGENT_NAME}}
**Data Resolução:** {{RESOLUTION_DATE}}
**Tempo Total:** {{DURATION}}
```

---

### Guia de Erros Comuns (`resources/guia_de_erros_comuns.md`)

```markdown
# Guia de Sobrevivência: Erros Universais por Stack

## 🔴 Erros de Conexão (Todas as Stacks)

**Sintoma:** `ECONNREFUSED`, `Connection refused`, `No connection could be made`

**Diagnóstico:**
```bash
# Verificar se porta está aberta
nc -zv HOST PORTA
# ou
telnet HOST PORTA

# Verificar processo usando a porta
lsof -i :PORTA
ss -tlnp | grep PORTA
```

**Causas Comuns:**
1. Serviço não iniciado → `docker-compose up` ou `systemctl start`
2. Porta errada → Verificar config (env var vs código)
3. Firewall → `ufw status`, `iptables -L`

---

## 🟠 Erros de Banco de Dados

### PostgreSQL/Neon
**Sintoma:** `relation "X" does not exist`, `column Y does not exist`

**Diagnóstico:**
```bash
# Verificar schema atual
psql $DATABASE_URL -c "\dt"
psql $DATABASE_URL -c "\d nome_tabela"

# Verificar migrations pendentes
npx drizzle-kit check  # Se usar Drizzle
alembic current        # Se usar Alembic
```

**Solução:** Aplicar migrations pendentes ou sincronizar schema

### MongoDB
**Sintoma:** `E11000 duplicate key error`

**Diagnóstico:**
```bash
# Verificar índices
db.collection.getIndexes()
```

---

## 🟡 Erros de Build/Compilação

### Node.js/TypeScript
**Sintoma:** `Cannot find module`, `TS2307`, `Build failed`

**Diagnóstico:**
```bash
# Limpar e reinstalar
rm -rf node_modules package-lock.json
npm install

# Verificar types faltantes
npm run type-check 2>&1 | grep "error TS"

# Verificar imports cíclicos
npx madge --circular src/
```

### Python
**Sintoma:** `ModuleNotFoundError`, `ImportError`, `SyntaxError`

**Diagnóstico:**
```bash
# Verificar ambiente
which python
pip list | grep pacote

# Verificar conflitos
pip check

# Reinstalar dependências
pip install -r requirements.txt --force-reinstall
```

### Go
**Sintoma:** `build constraints exclude all Go files`, `undefined: X`

**Diagnóstico:**
```bash
# Verificar módulos
go mod tidy
go mod verify

# Verificar tags de build
go build -v ./...
```

---

## 🟢 Erros de Runtime/Performance

**Sintoma:** Timeout, Memory Leak, CPU 100%

**Diagnóstico:**
```bash
# Node.js
node --inspect index.js  # Depurar com Chrome DevTools
clinic doctor -- node index.js  # Análise de performance

# Python
python -m memory_profiler script.py
py-spy top --pid $(pgrep -f python)

# Go
go tool pprof http://localhost:6060/debug/pprof/heap
```

---

## 🔵 Erros de Filas/Background Jobs

### Inngest
**Sintoma:** Função não dispara, `step timed out`

**Diagnóstico:**
```bash
# Verificar dashboard local
open http://localhost:8288

# Verificar logs
inngest dev --logs
```

**Solução:** Quebrar em steps menores, aumentar timeout

### Celery
**Sintoma:** Tasks pending, worker não consome

**Diagnóstico:**
```bash
celery -A app inspect active
celery -A app inspect scheduled
```

---

## 🛡️ Erros de Autenticação/Autorização

**Sintoma:** `401 Unauthorized`, `403 Forbidden`, `JWT expired`

**Diagnóstico:**
```bash
# Verificar token
curl -H "Authorization: Bearer $TOKEN" https://api.example.com/verify

# Decodificar JWT (sem verificar assinatura)
echo $TOKEN | cut -d'.' -f2 | base64 -d 2>/dev/null | jq .
```

**Causas:** Token expirado, scope errado, secret rotation pendente
```

---

### Estratégias de Fallback (`resources/fallback_strategies.md`)

```markdown
# Catálogo de Estratégias de Recuperação

## 1. Graceful Degradation

**Quando usar:** Feature não-crítica falhou, core deve continuar

**Implementação:**
```typescript
// Next.js exemplo
try {
  const recommendations = await getAIRecommendations();
} catch (error) {
  console.warn('AI indisponível, usando fallback estático');
  const recommendations = STATIC_RECOMMENDATIONS;
}
```

## 2. Circuit Breaker

**Quando usar:** API externa instável, evitar cascade failure

**Implementação:**
```python
# Python exemplo
from circuitbreaker import circuit

@circuit(failure_threshold=5, recovery_timeout=60)
def call_external_api():
    return requests.get('https://api.external.com')
```

## 3. Retry com Exponential Backoff

**Quando usar:** Falha transitória (network blip, rate limit)

**Implementação:**
```typescript
async function withRetry<T>(
  fn: () => Promise<T>,
  maxRetries = 3,
  baseDelay = 1000
): Promise<T> {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await fn();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await sleep(baseDelay * Math.pow(2, i));
    }
  }
  throw new Error('Unreachable');
}
```

## 4. Mock/Stub

**Quando usar:** Desenvolvimento, testes, ou serviço indisponível temporariamente

## 5. Feature Flag Kill Switch

**Quando usar:** Nova feature com problemas em produção

**Implementação:**
```typescript
if (await flags.isEnabled('new-checkout-flow')) {
  return newCheckout();
} else {
  return legacyCheckout();  // Fallback imediato
}
```
```

---

## 💻 Código dos Scripts

### diagnostico_auto.py

```python
#!/usr/bin/env python3
"""
Gera relatório de diagnóstico estruturado automaticamente.
Detecta stack e sugere hipóteses baseadas em padrões de erro.
"""

import argparse
import json
import re
import subprocess
import sys
import os
from pathlib import Path
from datetime import datetime
from typing import List, Dict, Optional

# Padrões de erro por stack
ERROR_PATTERNS = {
    "node": {
        "module_not_found": r"Error: Cannot find module '([^']+)'",
        "syntax": r"SyntaxError: (.+)",
        "type": r"TypeError: (.+)",
        "connection": r"ECONNREFUSED|ECONNRESET|ETIMEDOUT",
    },
    "python": {
        "import": r"ModuleNotFoundError: No module named '([^']+)'",
        "syntax": r"SyntaxError: (.+)",
        "key": r"KeyError: '([^']+)'",
        "connection": r"ConnectionRefusedError|psycopg2.OperationalError",
    },
    "go": {
        "build": r"build constraint",
        "undefined": r"undefined: (\w+)",
        "import": r"cannot find package \"([^\"]+)\"",
    },
    "database": {
        "connection": r"connection refused|could not connect",
        "timeout": r"timeout|statement timeout",
        "not_found": r"relation \"([^\"]+)\" does not exist",
    }
}

def detect_stack(project_path: str = ".") -> List[str]:
    """Detecta stack do projeto."""
    path = Path(project_path)
    stacks = []
    
    if (path / "package.json").exists():
        stacks.append("node")
        if (path / "next.config.js").exists() or (path / "next.config.ts").exists():
            stacks.append("nextjs")
    
    if (path / "requirements.txt").exists() or (path / "pyproject.toml").exists():
        stacks.append("python")
    
    if (path / "go.mod").exists():
        stacks.append("go")
    
    if (path / "Cargo.toml").exists():
        stacks.append("rust")
    
    if (path / "docker-compose.yml").exists() or (path / "Dockerfile").exists():
        stacks.append("docker")
    
    if (path / "vercel.json").exists():
        stacks.append("vercel")
    
    return stacks if stacks else ["generic"]

def analyze_error(error_log: str, stack: List[str]) -> Dict:
    """Analisa erro e sugere hipóteses."""
    hypotheses = []
    
    # Analisa por padrões conhecidos
    for tech in stack:
        if tech in ERROR_PATTERNS:
            for error_type, pattern in ERROR_PATTERNS[tech].items():
                matches = re.findall(pattern, error_log, re.IGNORECASE)
                if matches:
                    hypotheses.append({
                        "type": error_type,
                        "tech": tech,
                        "matches": matches,
                        "confidence": "high" if len(matches) > 0 else "medium"
                    })
    
    # Hipóteses genéricas se nenhuma específica encontrada
    if not hypotheses:
        hypotheses = [
            {"type": "unknown", "tech": "generic", "confidence": "low", "note": "Erro não categorizado"}
        ]
    
    return {
        "stack": stack,
        "hypotheses": hypotheses,
        "timestamp": datetime.now().isoformat()
    }

def generate_diagnostic_report(error_log: str, project_path: str, output: str) -> str:
    """Gera relatório de diagnóstico completo."""
    
    stack = detect_stack(project_path)
    analysis = analyze_error(error_log, stack)
    
    # Coleta contexto adicional
    context = collect_context(project_path, stack)
    
    report = f"""# Diagnóstico de Falha: AUTO-{datetime.now().strftime('%Y%m%d-%H%M%S')}

**Data:** {analysis['timestamp']}
**Projeto:** {Path(project_path).name}
**Stack Detectada:** {', '.join(stack)}
**Severidade:** 🔴 Crítica (automática)

---

## 1. Contexto da Falha

**Erro Observado:**
```text
{error_log[:2000]}  # Limita tamanho
```

**Ambiente:**
- OS: {os.name}
- Stack: {', '.join(stack)}
- Último commit: {context.get('last_commit', 'N/A')}

---

## 2. Análise Automática

### Hipóteses Geradas ({len(analysis['hypotheses'])}):

"""
    
    for i, hyp in enumerate(analysis['hypotheses'], 1):
        report += f"""
#### Hipótese {i}: {hyp['type'].replace('_', ' ').title()} ({hyp['tech']})
- **Confiança:** {hyp['confidence'].upper()}
- **Evidência:** {hyp.get('matches', ['Padrão detectado no log'])}
- **Teste Sugerido:** {suggest_test(hyp, stack)}

"""
    
    report += f"""
---

## 3. Health Check Rápido

Execute:
```bash
python "Minhas Skills/solucionando-erros/scripts/health_check.py" --project-path "{project_path}"
```

---

## 4. Próximos Passos

1. [ ] Executar health check acima
2. [ ] Validar hipótese 1: {suggest_test(analysis['hypotheses'][0], stack) if analysis['hypotheses'] else 'Investigar logs'}
3. [ ] Se confirmada, aplicar correção
4. [ ] Se refutada, testar hipótese 2

---

*Relatório gerado automaticamente. Valide as hipóteses antes de aplicar correções.*
"""
    
    # Salva relatório
    output_path = Path(output)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(report, encoding='utf-8')
    
    return str(output_path)

def collect_context(project_path: str, stack: List[str]) -> Dict:
    """Coleta contexto do projeto."""
    context = {}
    
    # Último commit
    try:
        result = subprocess.run(
            ["git", "-C", project_path, "log", "-1", "--oneline"],
            capture_output=True, text=True, timeout=5
        )
        if result.returncode == 0:
            context["last_commit"] = result.stdout.strip()
    except:
        pass
    
    # Versões de runtime
    if "node" in stack:
        try:
            result = subprocess.run(["node", "--version"], capture_output=True, text=True, timeout=5)
            context["node_version"] = result.stdout.strip()
        except:
            pass
    
    if "python" in stack:
        try:
            result = subprocess.run(["python", "--version"], capture_output=True, text=True, timeout=5)
            context["python_version"] = result.stdout.strip()
        except:
            pass
    
    return context

def suggest_test(hypothesis: Dict, stack: List[str]) -> str:
    """Sugere teste baseado na hipótese."""
    h_type = hypothesis['type']
    h_tech = hypothesis['tech']
    
    tests = {
        "module_not_found": "npm install [modulo] ou verificar package.json",
        "import": "pip install [pacote] ou verificar requirements.txt",
        "undefined": "Verificar se variável/função foi declarada",
        "syntax": "Verificar linting: npm run lint ou flake8",
        "connection": "Testar conectividade: telnet host porta",
        "not_found": "Aplicar migrations: npx drizzle-kit push",
        "timeout": "Verificar query e índices do banco",
    }
    
    return tests.get(h_type, "Investigar logs detalhadamente")

def main():
    parser = argparse.ArgumentParser(description="Diagnóstico automático de erros")
    parser.add_argument("--error-log", "-e", help="Arquivo com o erro ou - para stdin")
    parser.add_argument("--project-path", "-p", default=".", help="Caminho do projeto")
    parser.add_argument("--output", "-o", default="docs/DIAGNOSTIC-AUTO.md", help="Arquivo de saída")
    
    args = parser.parse_args()
    
    # Lê erro
    if args.error_log == "-" or not args.error_log:
        print("🚑 Modo Diagnóstico Forense")
        print("Cole o erro (Ctrl+D para enviar):")
        error_log = sys.stdin.read()
    else:
        error_log = Path(args.error_log).read_text(encoding='utf-8')
    
    if not error_log.strip():
        print("❌ Nenhum erro fornecido")
        sys.exit(1)
    
    print(f"🔍 Analisando erro em: {args.project_path}")
    print(f"Stack detectada: {', '.join(detect_stack(args.project_path))}")
    print("🧠 Gerando hipóteses...\n")
    
    report_path = generate_diagnostic_report(error_log, args.project_path, args.output)
    
    print(f"✅ Relatório gerado: {report_path}")
    print(f"📋 Próximo passo: Execute o health check e valide as hipóteses")

if __name__ == "__main__":
    main()
```

---

### health_check.py

```python
#!/usr/bin/env python3
"""
Health check universal - detecta stack e valida todos os componentes.
"""

import argparse
import json
import os
import socket
import subprocess
import sys
import time
from pathlib import Path
from typing import Dict, List, Tuple

def load_context(project_path: str) -> Dict:
    """Carrega contexto do projeto."""
    paths = [
        Path(project_path) / "project-context.json",
        Path(project_path) / "context.json",
    ]
    
    for p in paths:
        if p.exists():
            return json.loads(p.read_text())
    
    return {"stack": detect_stack(project_path), "name": Path(project_path).name}

def detect_stack(project_path: str) -> List[str]:
    """Detecta stack automaticamente."""
    path = Path(project_path)
    stacks = []
    
    detectors = {
        "node": ["package.json", "package-lock.json", "yarn.lock", "pnpm-lock.yaml"],
        "python": ["requirements.txt", "pyproject.toml", "Pipfile", "setup.py"],
        "go": ["go.mod", "go.sum"],
        "rust": ["Cargo.toml", "Cargo.lock"],
        "docker": ["Dockerfile", "docker-compose.yml", "compose.yaml"],
        "nextjs": ["next.config.js", "next.config.ts", "next.config.mjs"],
        "vercel": ["vercel.json"],
    }
    
    for stack, files in detectors.items():
        if any((path / f).exists() for f in files):
            stacks.append(stack)
    
    return stacks if stacks else ["generic"]

def check_command(cmd: List[str], timeout: int = 10) -> Tuple[bool, str]:
    """Executa comando e retorna sucesso/saída."""
    try:
        result = subprocess.run(
            cmd,
            capture_output=True,
            text=True,
            timeout=timeout
        )
        return result.returncode == 0, result.stdout + result.stderr
    except subprocess.TimeoutExpired:
        return False, "Timeout"
    except FileNotFoundError:
        return False, "Comando não encontrado"

def check_port(host: str, port: int, timeout: int = 2) -> bool:
    """Verifica se porta está aberta."""
    try:
        with socket.create_connection((host, port), timeout=timeout):
            return True
    except:
        return False

def check_env_vars(required: List[str]) -> Dict[str, bool]:
    """Verifica variáveis de ambiente."""
    return {var: var in os.environ for var in required}

def check_node_health(project_path: str) -> Dict:
    """Valida ambiente Node.js."""
    results = {"status": "unknown", "checks": {}}
    
    # Versão do Node
    ok, out = check_command(["node", "--version"])
    results["checks"]["node_version"] = {"ok": ok, "detail": out.strip() if ok else out}
    
    # Dependências instaladas
    node_modules = Path(project_path) / "node_modules"
    results["checks"]["node_modules"] = {
        "ok": node_modules.exists(),
        "detail": "Presente" if node_modules.exists() else "Execute npm install"
    }
    
    # Build possível
    if (Path(project_path) / "package.json").exists():
        ok, out = check_command(["npm", "run", "build"], timeout=60)
        results["checks"]["build"] = {
            "ok": ok,
            "detail": "OK" if ok else out[:200]
        }
    
    results["status"] = "healthy" if all(c["ok"] for c in results["checks"].values()) else "unhealthy"
    return results

def check_python_health(project_path: str) -> Dict:
    """Valida ambiente Python."""
    results = {"status": "unknown", "checks": {}}
    
    # Versão do Python
    ok, out = check_command(["python", "--version"])
    results["checks"]["python_version"] = {"ok": ok, "detail": out.strip() if ok else out}
    
    # Pip check
    ok, out = check_command(["pip", "check"])
    results["checks"]["pip_deps"] = {"ok": ok, "detail": "OK" if ok else out[:200]}
    
    # Testes passam
    if (Path(project_path) / "pytest.ini").exists() or (Path(project_path) / "setup.cfg").exists():
        ok, out = check_command(["pytest", "-x", "-q"], timeout=60)
        results["checks"]["tests"] = {"ok": ok, "detail": "Passaram" if ok else "Falharam"}
    
    results["status"] = "healthy" if all(c["ok"] for c in results["checks"].values()) else "unhealthy"
    return results

def check_go_health(project_path: str) -> Dict:
    """Valida ambiente Go."""
    results = {"status": "unknown", "checks": {}}
    
    ok, out = check_command(["go", "version"])
    results["checks"]["go_version"] = {"ok": ok, "detail": out.strip() if ok else out}
    
    ok, out = check_command(["go", "build", "./..."], timeout=60)
    results["checks"]["build"] = {"ok": ok, "detail": "OK" if ok else out[:200]}
    
    ok, out = check_command(["go", "test", "./...", "-short"], timeout=60)
    results["checks"]["tests"] = {"ok": ok, "detail": "Passaram" if ok else "Falharam"}
    
    results["status"] = "healthy" if all(c["ok"] for c in results["checks"].values()) else "unhealthy"
    return results

def check_database(context: Dict) -> Dict:
    """Valida conexões de banco."""
    results = {"status": "unknown", "checks": {}}
    
    db_url = os.getenv("DATABASE_URL")
    if not db_url:
        results["checks"]["connection"] = {
            "ok": False,
            "detail": "DATABASE_URL não definida"
        }
        return results
    
    # Testa conexão baseado no tipo
    if "postgres" in db_url or "neon" in db_url:
        try:
            import psycopg2
            conn = psycopg2.connect(db_url, connect_timeout=5)
            conn.close()
            results["checks"]["connection"] = {"ok": True, "detail": "PostgreSQL conectado"}
        except ImportError:
            results["checks"]["connection"] = {
                "ok": False,
                "detail": "psycopg2 não instalado"
            }
        except Exception as e:
            results["checks"]["connection"] = {"ok": False, "detail": str(e)}
    elif "mysql" in db_url:
        # Similar para MySQL
        results["checks"]["connection"] = {"ok": True, "detail": "MySQL check não implementado"}
    else:
        results["checks"]["connection"] = {"ok": True, "detail": "URL presente, tipo não testado"}
    
    results["status"] = "healthy" if results["checks"]["connection"]["ok"] else "unhealthy"
    return results

def check_services(context: Dict) -> Dict:
    """Valida serviços externos configurados."""
    results = {}
    
    services = context.get("debug_config", {}).get("health_checks", {}).get("external_apis", [])
    
    for service in services:
        # Mapeia nomes para URLs de health check
        health_urls = {
            "openrouter": "https://openrouter.ai/api/v1/models",
            "stripe": "https://api.stripe.com/v1/health",  # Exemplo
            "resend": "https://api.resend.com/emails",  # HEAD request
        }
        
        url = health_urls.get(service)
        if url:
            try:
                import requests
                resp = requests.get(url, timeout=5)
                results[service] = {
                    "ok": resp.status_code < 500,
                    "status": resp.status_code
                }
            except Exception as e:
                results[service] = {"ok": False, "error": str(e)}
    
    return results

def main():
    parser = argparse.ArgumentParser(description="Health check universal")
    parser.add_argument("--project-path", "-p", default=".", help="Caminho do projeto")
    parser.add_argument("--strict", action="store_true", help="Falha se qualquer check falhar")
    parser.add_argument("--json", action="store_true", help="Saída em JSON")
    
    args = parser.parse_args()
    
    context = load_context(args.project_path)
    stack = context.get("stack", ["generic"])
    
    report = {
        "timestamp": time.isoformat(),
        "project": context.get("name", "unknown"),
        "stack": stack,
        "checks": {}
    }
    
    # Checks por stack
    if "node" in stack:
        report["checks"]["node"] = check_node_health(args.project_path)
    
    if "python" in stack:
        report["checks"]["python"] = check_python_health(args.project_path)
    
    if "go" in stack:
        report["checks"]["go"] = check_go_health(args.project_path)
    
    # Checks universais
    if context.get("debug_config", {}).get("health_checks", {}).get("database", True):
        report["checks"]["database"] = check_database(context)
    
    report["checks"]["services"] = check_services(context)
    
    # Portas comuns
    ports = {
        "nextjs": 3000,
        "vite": 5173,
        "python": 8000,
        "go": 8080,
    }
    
    for service, port in ports.items():
        if service in stack or f"{service}_dev" in context.get("services", []):
            report["checks"][f"port_{port}"] = {
                "ok": check_port("localhost", port),
                "detail": f"{service} na porta {port}"
            }
    
    # Determina status global
    all_ok = all(
        c.get("status") == "healthy" or c.get("ok") 
        for c in report["checks"].values() 
        if isinstance(c, dict)
    )
    report["overall_status"] = "healthy" if all_ok else "unhealthy"
    
    # Output
    if args.json:
        print(json.dumps(report, indent=2))
    else:
        print(f"🏥 Health Check: {report['project']}")
        print(f"Stack: {', '.join(stack)}")
        print("-" * 50)
        
        for category, result in report["checks"].items():
            if isinstance(result, dict):
                if "status" in result:
                    icon = "✅" if result["status"] == "healthy" else "❌"
                    print(f"{icon} {category}: {result['status']}")
                    for check, detail in result.get("checks", {}).items():
                        status = "✅" if detail.get("ok") else "❌"
                        print(f"   {status} {check}: {detail.get('detail', 'N/A')[:50]}")
                else:
                    icon = "✅" if result.get("ok") else "❌"
                    print(f"{icon} {category}: {result.get('detail', 'N/A')[:50]}")
        
        print("-" * 50)
        icon = "✅" if all_ok else "❌"
        print(f"{icon} Status Geral: {report['overall_status']}")
    
    sys.exit(0 if all_ok else 1)

if __name__ == "__main__":
    main()
```

---

### log_analyzer.py

```python
#!/usr/bin/env python3
"""
Analisador universal de logs - extrai padrões de erro de qualquer formato.
"""

import argparse
import re
from pathlib import Path
from collections import Counter
from typing import List, Dict

LOG_PATTERNS = {
    "error": r"\b(ERROR|FATAL|CRITICAL|Exception|Traceback)\b",
    "warning": r"\b(WARN|WARNING|DeprecationWarning)\b",
    "http_error": r"HTTP/\d\.\d\"\s(4\d\d|5\d\d)",
    "database_error": r"(connection refused|timeout|deadlock|lock wait)",
    "memory_error": r"(MemoryError|Java heap space|OutOfMemory)",
}

def analyze_log(file_path: str, pattern: str = None, context: int = 3) -> Dict:
    """Analisa arquivo de log."""
    
    content = Path(file_path).read_text(encoding='utf-8', errors='ignore')
    lines = content.split('\n')
    
    findings = {
        "total_lines": len(lines),
        "errors": [],
        "warnings": [],
        "summary": Counter()
    }
    
    # Regex customizado ou padrões pré-definidos
    patterns = {pattern: re.compile(pattern, re.IGNORECASE)} if pattern else {
        name: re.compile(regex, re.IGNORECASE) 
        for name, regex in LOG_PATTERNS.items()
    }
    
    for i, line in enumerate(lines):
        for name, regex in patterns.items():
            if regex.search(line):
                entry = {
                    "line_number": i + 1,
                    "content": line.strip(),
                    "context": lines[max(0, i-context):min(len(lines), i+context+1)]
                }
                
                if "error" in name or "fatal" in name:
                    findings["errors"].append(entry)
                elif "warn" in name:
                    findings["warnings"].append(entry)
                
                findings["summary"][name] += 1
    
    return findings

def main():
    parser = argparse.ArgumentParser(description="Analisador de logs")
    parser.add_argument("file", help="Arquivo de log")
    parser.add_argument("--pattern", "-p", help="Regex customizado")
    parser.add_argument("--context", "-c", type=int, default=3, help="Linhas de contexto")
    parser.add_argument("--format", choices=["text", "json"], default="text")
    
    args = parser.parse_args()
    
    findings = analyze_log(args.file, args.pattern, args.context)
    
    if args.format == "json":
        import json
        print(json.dumps(findings, indent=2, default=str))
    else:
        print(f"📊 Análise de: {args.file}")
        print(f"Total de linhas: {findings['total_lines']}")
        print(f"Erros encontrados: {len(findings['errors'])}")
        print(f"Avisos encontrados: {len(findings['warnings'])}")
        print("\nResumo por categoria:")
        for category, count in findings["summary"].most_common():
            print(f"  {category}: {count}")
        
        if findings["errors"]:
            print("\n🔴 Últimos 3 erros:")
            for err in findings["errors"][-3:]:
                print(f"  Linha {err['line_number']}: {err['content'][:100]}")

if __name__ == "__main__":
    main()
```

---
