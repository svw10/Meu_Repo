## 1. Logs/schema/log_schema.json

```json
{
  "name": "antigravity-log-schema",
  "version": "3.0.0",
  "description": "Schema unificado de logs para debug, performance e análise de IA",
  
  "log_levels": {
    "DEBUG": { "value": 0, "color": "gray", "use": "Desenvolvimento apenas" },
    "INFO": { "value": 1, "color": "blue", "use": "Informações gerais" },
    "WARN": { "value": 2, "color": "yellow", "use": "Atenção necessária" },
    "ERROR": { "value": 3, "color": "red", "use": "Erro recuperável" },
    "CRITICAL": { "value": 4, "color": "magenta", "use": "Erro fatal" }
  },

  "event_types": {
    "SYSTEM": {
      "description": "Eventos do sistema operacional",
      "fields": ["timestamp", "level", "component", "message", "metadata"]
    },
    "ERROR": {
      "description": "Erros capturados",
      "fields": ["timestamp", "level", "error_type", "message", "stack_trace", "origin", "context", "recovery_action"]
    },
    "PERFORMANCE": {
      "description": "Métricas de performance",
      "fields": ["timestamp", "operation", "duration_ms", "memory_mb", "cpu_percent", "input_size", "output_size"]
    },
    "AI_INTERACTION": {
      "description": "Interações com modelos de IA",
      "fields": ["timestamp", "model", "prompt_tokens", "completion_tokens", "cost_usd", "latency_ms", "skill_used", "success"]
    },
    "SKILL_EXECUTION": {
      "description": "Execução de skills do Antigravity",
      "fields": ["timestamp", "skill_id", "skill_name", "version", "input_summary", "output_summary", "duration_ms", "status", "errors"]
    },
    "USER_ACTION": {
      "description": "Ações do usuário",
      "fields": ["timestamp", "user_id", "action", "target", "result", "session_id"]
    },
    "DEPENDENCY": {
      "description": "Chamadas externas (APIs, DB)",
      "fields": ["timestamp", "service", "operation", "duration_ms", "status_code", "retry_count", "error"]
    }
  },

  "common_fields": {
    "timestamp": { "type": "ISO8601", "required": true },
    "level": { "type": "enum", "values": ["DEBUG", "INFO", "WARN", "ERROR", "CRITICAL"], "required": true },
    "trace_id": { "type": "string", "description": "ID único para rastreamento distribuído", "required": false },
    "session_id": { "type": "string", "description": "ID da sessão do usuário", "required": false },
    "project": { "type": "string", "description": "Nome do projeto", "required": true },
    "environment": { "type": "enum", "values": ["development", "staging", "production"], "required": true }
  },

  "weakness_indicators": {
    "high_error_rate": { "threshold": "5 errors/minute", "severity": "HIGH" },
    "slow_response": { "threshold": "response_time > 2000ms", "severity": "MEDIUM" },
    "memory_leak": { "threshold": "memory_growth > 100MB/hour", "severity": "CRITICAL" },
    "ai_cost_spike": { "threshold": "cost > 10x average", "severity": "MEDIUM" },
    "skill_failure": { "threshold": "3 consecutive failures", "severity": "HIGH" },
    "dependency_timeout": { "threshold": "2 consecutive timeouts", "severity": "MEDIUM" }
  }
}
```

---

## 2. Logs/interceptors/error_interceptor.ts

```typescript
// Logs/interceptors/error_interceptor.ts
// Intercepta e enriquece erros para análise posterior

interface ErrorContext {
  component: string;
  operation: string;
  inputs?: Record<string, any>;
  userId?: string;
  sessionId?: string;
}

interface EnrichedError {
  timestamp: string;
  level: "ERROR" | "CRITICAL";
  error_type: string;
  message: string;
  stack_trace: string;
  origin: {
    file: string;
    line: number;
    column: number;
    function: string;
  };
  context: ErrorContext;
  system_context: {
    memory_usage: number;
    cpu_load: number;
    uptime_seconds: number;
  };
  recovery_action: string | null;
  similar_errors_count: number;
}

export class ErrorInterceptor {
  private errorHistory: Map<string, number> = new Map();
  private readonly SIMILARITY_THRESHOLD = 5;

  intercept(error: Error, context: ErrorContext): EnrichedError {
    const enriched = this.enrichError(error, context);
    this.trackError(enriched);
    this.log(enriched);
    
    // Detectar padrão de erro recorrente
    if (this.isRecurringError(enriched)) {
      this.alertRecurringError(enriched);
    }

    return enriched;
  }

  private enrichError(error: Error, context: ErrorContext): EnrichedError {
    const stackLines = error.stack?.split('\n') || [];
    const originLine = stackLines[1] || '';
    
    // Parse do stack trace para extrair origem exata
    const originMatch = originLine.match(/at\s+(.*?)\s+\((.*?):(\d+):(\d+)\)/);
    
    return {
      timestamp: new Date().toISOString(),
      level: this.classifySeverity(error),
      error_type: error.constructor.name,
      message: error.message,
      stack_trace: error.stack || '',
      origin: {
        file: originMatch?.[2] || 'unknown',
        line: parseInt(originMatch?.[3] || '0'),
        column: parseInt(originMatch?.[4] || '0'),
        function: originMatch?.[1] || 'anonymous',
      },
      context,
      system_context: this.captureSystemContext(),
      recovery_action: this.suggestRecovery(error),
      similar_errors_count: this.getSimilarCount(error),
    };
  }

  private classifySeverity(error: Error): "ERROR" | "CRITICAL" {
    // Erros críticos: falta de memória, conexão DB, autenticação
    const criticalPatterns = [
      'OutOfMemory',
      'DatabaseConnectionError',
      'AuthenticationError',
      'PaymentGatewayError',
    ];
    
    return criticalPatterns.some(p => error.message.includes(p)) 
      ? "CRITICAL" 
      : "ERROR";
  }

  private captureSystemContext() {
    // Node.js apenas
    const usage = process.memoryUsage();
    
    return {
      memory_usage: Math.round(usage.heapUsed / 1024 / 1024),
      cpu_load: 0, // Requer implementação específica
      uptime_seconds: process.uptime(),
    };
  }

  private suggestRecovery(error: Error): string | null {
    const recoveryMap: Record<string, string> = {
      'DatabaseConnectionError': 'Tentar reconexão com exponential backoff',
      'TimeoutError': 'Aumentar timeout ou verificar serviço externo',
      'ValidationError': 'Retornar 400 com detalhes do erro ao cliente',
      'RateLimitError': 'Aguardar 60s antes de nova tentativa',
    };

    const errorType = error.constructor.name;
    return recoveryMap[errorType] || 'Investigar logs e notificar equipe';
  }

  private trackError(enriched: EnrichedError): void {
    const key = `${enriched.origin.file}:${enriched.origin.line}:${enriched.error_type}`;
    const count = this.errorHistory.get(key) || 0;
    this.errorHistory.set(key, count + 1);
  }

  private getSimilarCount(error: Error): number {
    const key = `${error.stack?.split('\n')[1]}:${error.constructor.name}`;
    return this.errorHistory.get(key) || 0;
  }

  private isRecurringError(enriched: EnrichedError): boolean {
    return enriched.similar_errors_count >= this.SIMILARITY_THRESHOLD;
  }

  private alertRecurringError(enriched: EnrichedError): void {
    console.warn(`[WEAKNESS DETECTED] Erro recorrente: ${enriched.error_type}`);
    console.warn(`Localização: ${enriched.origin.file}:${enriched.origin.line}`);
    console.warn(`Ocorrências: ${enriched.similar_errors_count}`);
    
    // Aqui poderia enviar alerta para Slack, PagerDuty, etc.
  }

  private log(enriched: EnrichedError): void {
    // Enviar para storage (arquivo, DB, ou serviço externo)
    const logEntry = JSON.stringify(enriched);
    
    // Desenvolvimento: console
    if (process.env.NODE_ENV === 'development') {
      console.error(`[${enriched.level}] ${enriched.error_type}: ${enriched.message}`);
      console.error(`  → ${enriched.origin.file}:${enriched.origin.line}`);
    }
    
    // Produção: arquivo ou serviço
    // fs.appendFileSync('Logs/storage/production/errors.jsonl', logEntry + '\n');
  }
}

// Uso:
// const interceptor = new ErrorInterceptor();
// try { ... } catch (e) { interceptor.intercept(e, { component: 'AuthService', operation: 'login' }); }
```

---

## 3. Logs/interceptors/performance_interceptor.ts

```typescript
// Logs/interceptors/performance_interceptor.ts
// Monitora performance de operações críticas

interface PerformanceEntry {
  timestamp: string;
  operation: string;
  duration_ms: number;
  memory_before_mb: number;
  memory_after_mb: number;
  cpu_percent: number;
  input_size?: number;
  output_size?: number;
  metadata?: Record<string, any>;
}

export class PerformanceInterceptor {
  private measurements: Map<string, number[]> = new Map();

  async measure<T>(
    operation: string,
    fn: () => Promise<T>,
    metadata?: Record<string, any>
  ): Promise<T> {
    const startTime = performance.now();
    const startMemory = process.memoryUsage().heapUsed / 1024 / 1024;
    
    try {
      const result = await fn();
      
      const entry: PerformanceEntry = {
        timestamp: new Date().toISOString(),
        operation,
        duration_ms: Math.round(performance.now() - startTime),
        memory_before_mb: Math.round(startMemory),
        memory_after_mb: Math.round(process.memoryUsage().heapUsed / 1024 / 1024),
        cpu_percent: 0, // Implementar se necessário
        metadata,
      };

      this.track(entry);
      this.detectAnomaly(entry);
      
      return result;
    } catch (error) {
      // Logar erro com contexto de performance
      throw error;
    }
  }

  private track(entry: PerformanceEntry): void {
    const history = this.measurements.get(entry.operation) || [];
    history.push(entry.duration_ms);
    
    // Manter apenas últimas 100 medições
    if (history.length > 100) history.shift();
    
    this.measurements.set(entry.operation, history);
  }

  private detectAnomaly(entry: PerformanceEntry): void {
    const history = this.measurements.get(entry.operation) || [];
    if (history.length < 10) return;

    const avg = history.reduce((a, b) => a + b, 0) / history.length;
    const threshold = avg * 3; // 3x acima da média

    if (entry.duration_ms > threshold) {
      console.warn(`[PERFORMANCE ANOMALY] ${entry.operation}`);
      console.warn(`  Duração: ${entry.duration_ms}ms (média: ${Math.round(avg)}ms)`);
      console.warn(`  Memória: +${entry.memory_after_mb - entry.memory_before_mb}MB`);
    }
  }

  getStats(operation: string): { avg: number; p95: number; count: number } {
    const history = this.measurements.get(operation) || [];
    const sorted = [...history].sort((a, b) => a - b);
    
    return {
      avg: Math.round(history.reduce((a, b) => a + b, 0) / history.length) || 0,
      p95: sorted[Math.floor(sorted.length * 0.95)] || 0,
      count: history.length,
    };
  }
}
```

---

## 4. Logs/analyzers/weakness_detector.py

```python
#!/usr/bin/env python3
"""
Weakness Detector - Analisa logs e detecta pontos fracos do sistema
Uso: python weakness_detector.py --logs Logs/storage/production/ --output report.json
"""

import json
import argparse
from datetime import datetime, timedelta
from collections import defaultdict
from typing import Dict, List, Any

class WeaknessDetector:
    def __init__(self, log_path: str):
        self.log_path = log_path
        self.errors: List[Dict] = []
        self.performance: List[Dict] = []
        self.ai_interactions: List[Dict] = []
        
    def load_logs(self):
        """Carrega logs do período analisado"""
        # Implementar leitura de arquivo ou DB
        pass
    
    def detect_error_patterns(self) -> List[Dict]:
        """Detecta padrões de erro recorrentes"""
        patterns = defaultdict(lambda: {"count": 0, "files": set(), "first_seen": None})
        
        for error in self.errors:
            key = f"{error['error_type']}:{error['origin']['file']}"
            patterns[key]["count"] += 1
            patterns[key]["files"].add(f"{error['origin']['file']}:{error['origin']['line']}")
            
            if not patterns[key]["first_seen"]:
                patterns[key]["first_seen"] = error["timestamp"]
        
        # Filtrar apenas padrões críticos (>5 ocorrências)
        critical = [
            {
                "pattern": key,
                "occurrences": data["count"],
                "locations": list(data["files"]),
                "first_seen": data["first_seen"],
                "severity": "HIGH" if data["count"] > 10 else "MEDIUM"
            }
            for key, data in patterns.items()
            if data["count"] > 5
        ]
        
        return sorted(critical, key=lambda x: x["occurrences"], reverse=True)
    
    def detect_performance_bottlenecks(self) -> List[Dict]:
        """Identifica operações lentas"""
        operation_stats = defaultdict(lambda: {"times": [], "memory_spikes": []})
        
        for perf in self.performance:
            op = perf["operation"]
            operation_stats[op]["times"].append(perf["duration_ms"])
            operation_stats[op]["memory_spikes"].append(
                perf["memory_after_mb"] - perf["memory_before_mb"]
            )
        
        bottlenecks = []
        for op, data in operation_stats.items():
            times = data["times"]
            avg_time = sum(times) / len(times)
            p95 = sorted(times)[int(len(times) * 0.95)]
            
            if avg_time > 1000:  # > 1 segundo
                bottlenecks.append({
                    "operation": op,
                    "avg_duration_ms": round(avg_time, 2),
                    "p95_duration_ms": p95,
                    "max_memory_spike_mb": max(data["memory_spikes"]),
                    "calls_count": len(times),
                    "severity": "CRITICAL" if avg_time > 5000 else "HIGH"
                })
        
        return sorted(bottlenecks, key=lambda x: x["avg_duration_ms"], reverse=True)
    
    def detect_ai_inefficiencies(self) -> List[Dict]:
        """Detecta uso ineficiente de IA (custo alto, latência, falhas)"""
        inefficiencies = []
        
        # Agrupar por skill
        skill_stats = defaultdict(lambda: {"calls": 0, "total_cost": 0, "failures": 0})
        
        for interaction in self.ai_interactions:
            skill = interaction.get("skill_used", "unknown")
            skill_stats[skill]["calls"] += 1
            skill_stats[skill]["total_cost"] += interaction.get("cost_usd", 0)
            if not interaction.get("success"):
                skill_stats[skill]["failures"] += 1
        
        for skill, stats in skill_stats.items():
            if stats["total_cost"] > 10:  # > $10
                inefficiencies.append({
                    "skill": skill,
                    "issue": "high_cost",
                    "total_cost_usd": round(stats["total_cost"], 2),
                    "calls": stats["calls"],
                    "avg_cost_per_call": round(stats["total_cost"] / stats["calls"], 4),
                    "recommendation": "Considerar caching ou otimização de prompts"
                })
            
            if stats["failures"] / stats["calls"] > 0.1:  # > 10% falha
                inefficiencies.append({
                    "skill": skill,
                    "issue": "high_failure_rate",
                    "failure_rate": f"{(stats['failures'] / stats['calls'] * 100):.1f}%",
                    "recommendation": "Revisar tratamento de erros na skill"
                })
        
        return inefficiencies
    
    def generate_report(self) -> Dict[str, Any]:
        """Gera relatório completo de fraquezas"""
        return {
            "generated_at": datetime.now().isoformat(),
            "summary": {
                "total_errors_analyzed": len(self.errors),
                "total_operations_analyzed": len(self.performance),
                "critical_issues": 0
            },
            "error_patterns": self.detect_error_patterns(),
            "performance_bottlenecks": self.detect_performance_bottlenecks(),
            "ai_inefficiencies": self.detect_ai_inefficiencies(),
            "recommendations": self.generate_recommendations()
        }
    
    def generate_recommendations(self) -> List[str]:
        """Gera recomendações baseadas nos padrões encontrados"""
        recs = []
        
        # Baseado em erros
        error_patterns = self.detect_error_patterns()
        if error_patterns:
            recs.append(f"Priorizar correção de {error_patterns[0]['pattern']} ({error_patterns[0]['occurrences']} ocorrências)")
        
        # Baseado em performance
        bottlenecks = self.detect_performance_bottlenecks()
        if bottlenecks:
            recs.append(f"Otimizar operação '{bottlenecks[0]['operation']}' (média: {bottlenecks[0]['avg_duration_ms']}ms)")
        
        return recs

def main():
    parser = argparse.ArgumentParser(description="Detecta fraquezas no sistema")
    parser.add_argument("--logs", required=True, help="Caminho para os logs")
    parser.add_argument("--output", default="weakness_report.json", help="Arquivo de saída")
    args = parser.parse_args()
    
    detector = WeaknessDetector(args.logs)
    # detector.load_logs()  # Implementar
    
    report = detector.generate_report()
    
    with open(args.output, 'w') as f:
        json.dump(report, f, indent=2)
    
    print(f"Relatório gerado: {args.output}")
    print(f"Issues críticos encontrados: {len(report['error_patterns']) + len(report['performance_bottlenecks'])}")

if __name__ == "__main__":
    main()
```

---

## 5. Logs/analyzers/error_origin.py

```python
#!/usr/bin/env python3
"""
Error Origin Tracer - Rastreia a origem real dos erros através da stack trace
"""

import json
import re
from typing import Dict, List, Optional, Tuple

class ErrorOriginTracer:
    def __init__(self):
        self.source_map = {}  # Mapeamento de minified -> original (se aplicável)
        
    def parse_stack_trace(self, stack_trace: str) -> List[Dict]:
        """Parseia stack trace em frames estruturados"""
        frames = []
        
        # Regex para diferentes formatos de stack trace
        patterns = [
            # Node.js/V8: at function (file:line:column)
            r'at\s+(?:(.+?)\s+\()?(?:(.+?):(\d+):(\d+))\)?',
            # Python: File "file", line X, in function
            r'File\s+"(.+?)",\s+line\s+(\d+),\s+in\s+(.+)',
        ]
        
        for line in stack_trace.split('\n'):
            for pattern in patterns:
                match = re.search(pattern, line)
                if match:
                    if 'File' in line:  # Python
                        frames.append({
                            'file': match.group(1),
                            'line': int(match.group(2)),
                            'function': match.group(3),
                            'column': None,
                            'type': 'python'
                        })
                    else:  # Node.js
                        frames.append({
                            'function': match.group(1) or 'anonymous',
                            'file': match.group(2),
                            'line': int(match.group(3)),
                            'column': int(match.group(4)),
                            'type': 'nodejs'
                        })
                    break
        
        return frames
    
    def find_root_cause(self, error: Dict) -> Dict:
        """
        Analisa a cadeia de erro e encontra a causa raiz
        Estratégia: ignorar frames de bibliotecas, focar em código do projeto
        """
        frames = self.parse_stack_trace(error.get('stack_trace', ''))
        
        # Filtrar apenas frames do projeto (não node_modules, não libs)
        project_frames = [
            f for f in frames 
            if not any(x in f['file'] for x in ['node_modules', 'site-packages', 'internal'])
        ]
        
        if not project_frames:
            return {
                'type': 'external_dependency',
                'message': 'Erro originado em dependência externa',
                'last_project_frame': frames[0] if frames else None,
                'recommendation': 'Verificar versão da dependência ou reportar issue'
            }
        
        # O frame mais profundo (último) geralmente é a origem
        root_frame = project_frames[-1]
        
        # Analisar tipo de erro para dar contexto
        error_type = error.get('error_type', 'Unknown')
        context_hints = self._get_context_hints(error_type, error.get('message', ''))
        
        return {
            'type': 'project_code',
            'file': root_frame['file'],
            'line': root_frame['line'],
            'function': root_frame['function'],
            'code_context': self._get_code_context(root_frame),
            'likely_cause': context_hints['cause'],
            'fix_suggestion': context_hints['fix'],
            'full_chain': project_frames
        }
    
    def _get_context_hints(self, error_type: str, message: str) -> Dict:
        """Fornece contexto baseado no tipo de erro"""
        hints = {
            'TypeError': {
                'cause': 'Tipo de dado inesperado',
                'fix': 'Verificar tipos de entrada e validação'
            },
            'ReferenceError': {
                'cause': 'Variável não definida',
                'fix': 'Verificar declaração e escopo da variável'
            },
            'DatabaseConnectionError': {
                'cause': 'Falha na conexão com banco',
                'fix': 'Verificar credenciais e disponibilidade do serviço'
            },
            'TimeoutError': {
                'cause': 'Operação excedeu tempo limite',
                'fix': 'Otimizar query ou aumentar timeout'
            }
        }
        
        # Match parcial para erros customizados
        for key, value in hints.items():
            if key in error_type or key in message:
                return value
        
        return {
            'cause': 'Erro não categorizado',
            'fix': 'Investigar stack trace completo'
        }
    
    def _get_code_context(self, frame: Dict, context_lines: int = 3) -> Optional[str]:
        """Tenta ler o código fonte ao redor do erro"""
        try:
            with open(frame['file'], 'r') as f:
                lines = f.readlines()
                start = max(0, frame['line'] - context_lines - 1)
                end = min(len(lines), frame['line'] + context_lines)
                
                context = []
                for i in range(start, end):
                    marker = ">>> " if i == frame['line'] - 1 else "    "
                    context.append(f"{marker}{i+1}: {lines[i].rstrip()}")
                
                return '\n'.join(context)
        except:
            return None
    
    def trace_error_chain(self, errors: List[Dict]) -> Dict:
        """Analisa múltiplos erros para encontrar padrões de origem"""
        origins = [self.find_root_cause(e) for e in errors]
        
        # Agrupar por arquivo:linha
        location_groups = {}
        for origin in origins:
            if origin['type'] == 'project_code':
                key = f"{origin['file']}:{origin['line']}"
                location_groups[key] = location_groups.get(key, 0) + 1
        
        # Encontrar hotspots
        hotspots = sorted(
            location_groups.items(), 
            key=lambda x: x[1], 
            reverse=True
        )[:5]
        
        return {
            'total_errors': len(errors),
            'project_errors': len([o for o in origins if o['type'] == 'project_code']),
            'external_errors': len([o for o in origins if o['type'] == 'external_dependency']),
            'hotspots': [{'location': k, 'count': v} for k, v in hotspots],
            'detailed_origins': origins[:3]  # Top 3 para análise
        }

# Uso:
# tracer = ErrorOriginTracer()
# result = tracer.find_root_cause(error_dict)
# print(json.dumps(result, indent=2))
```

---

## 6. Logs/README.md

```markdown
# Logs - Sistema de Observabilidade Antigravity

## Visão Geral

Sistema inteligente de logging para detectar pontos fracos, rastrear origem de erros e otimizar performance.

## Estrutura

```
Logs/
├── schema/              # Definição de estrutura de dados
├── interceptors/        # Captura automática de eventos
├── analyzers/           # Análise e detecção de padrões
└── storage/             # Armazenamento (local/produção)
```

## Uso Rápido

### 1. Capturar Erros (TypeScript)

```typescript
import { ErrorInterceptor } from './interceptors/error_interceptor';

const interceptor = new ErrorInterceptor();

try {
  await riskyOperation();
} catch (error) {
  interceptor.intercept(error, {
    component: 'PaymentService',
    operation: 'processPayment',
    userId: 'user_123'
  });
}
```

### 2. Medir Performance

```typescript
import { PerformanceInterceptor } from './interceptors/performance_interceptor';

const perf = new PerformanceInterceptor();

const result = await perf.measure(
  'databaseQuery',
  () => db.query('SELECT * FROM users'),
  { table: 'users', filters: 3 }
);
```

### 3. Analisar Fraquezas (Python)

```bash
python analyzers/weakness_detector.py \
  --logs Logs/storage/production/ \
  --output relatorio.json
```

## Detecções Automáticas

| Problema | Detecção | Ação |
|----------|----------|------|
| Erro recorrente | >5x mesmo arquivo:linha | Alerta + priorização |
| Latência alta | >3x média histórica | Investigação automática |
| Custo IA spike | >10x média | Revisão de prompts |
| Memory leak | Crescimento >100MB/h | Alerta crítico |
| Falha em cascata | Múltiplos serviços | Circuit breaker |

## Integração com Skills

As skills do Antigravity logam automaticamente:

- `01_brainstorming` → Ideias geradas, tempo de análise
- `03_executando_planos` → Execuções, sucesso/falha
- `04_solucionando_erros` → Erros encontrados, soluções aplicadas
- `10_llm_app_blueprint` → Tokens usados, custo, latência

## Dashboard (futuro)

```bash
# Gerar relatório visual
python analyzers/generate_dashboard.py --period 24h
```
