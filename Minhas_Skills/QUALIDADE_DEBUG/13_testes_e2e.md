---
name: testes_e2e
description: Testes E2E e de integração com Playwright + Vitest. Garantia de qualidade automatizada.
version: 1.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
trigger: "/test" ou pré-commit
status: active
tags: [testing, e2e, playwright, vitest, delta, quality]
---

# 13 - TESTES E2E & INTEGRAÇÃO (Quality Gate Automatizado)

## 🎯 Quando usar
- **SEMPRE** antes de merge em `main` ou `develop`
- Após `GAMMA` finalizar feature com impacto em UI ou API
- Quando `05_verificando_conclusao` identificar risco de regressão
- Gatilho manual: `/test` ou `/qa`

> **Regra de Ouro**: Nenhum deploy sem testes passando. "Funciona na minha máquina" não é critério de aceite.

---

## 🧱 Stack de Testing (Stack Omega)

| Tipo | Tecnologia | Propósito | Localização |
|:---|:---|:---|:---|
| **Unit** | Vitest + Testing Library | Lógica pura, funções, hooks | `__tests__/unit/` |
| **Integration** | Vitest + Drizzle Test Utils | API Routes, Server Actions, DB | `__tests__/integration/` |
| **E2E** | Playwright | Fluxos completos do usuário | `__tests__/e2e/` |
| **Visual** | Chromatic / Argos | Regressão visual de componentes | `__tests__/visual/` |
| **Performance** | Lighthouse CI | Core Web Vitals automatizados | `.github/workflows/lighthouse.yml` |
| **Coverage** | Vitest --coverage + codecov | Métricas de qualidade | `coverage/` |

---

## ⚙️ Protocolo de Testes (3 Fases)

### Fase 1: Planejamento (DELTA)
Antes de codar testes, defina:
```typescript
// __tests__/PLAN-[feature].md
## Cenários Críticos
1. [Happy Path] Usuário faz login → acessa dashboard
2. [Error Path] Login com senha errada → mensagem clara
3. [Edge Case] Token expirado → redirect para /login
4. [Security] XSS attempt em input → sanitizado

## Métricas de Sucesso
- Cobertura mínima: 80% lógica de negócio
- Tempo de execução E2E: < 5min
- Zero flaky tests (reprodutibilidade 100%)
```

### Fase 2: Implementação (GAMMA + DELTA)
**Template Vitest (Unit/Integration):**
```typescript
// __tests__/integration/auth/login.test.ts
import { describe, it, expect, beforeEach, vi } from 'vitest';
import { loginUser } from '@/lib/auth/actions';
import { db } from '@/db';

describe('loginUser', () => {
  beforeEach(() => {
    vi.clearAllMocks();
  });

  it('deve autenticar usuário com credenciais válidas', async () => {
    // Arrange
    const mockUser = { id: 'user_123', email: 'teste@example.com' };
    vi.spyOn(db.query.users, 'findFirst').mockResolvedValue(mockUser as any);

    // Act
    const result = await loginUser({ email: 'teste@example.com', password: 'Senha123!' });

    // Assert
    expect(result.success).toBe(true);
    expect(result.data?.userId).toBe('user_123');
    expect(db.query.users.findFirst).toHaveBeenCalledWith(
      expect.objectContaining({ where: expect.anything() })
    );
  });

  it('deve falhar com credenciais inválidas', async () => {
    // Arrange
    vi.spyOn(db.query.users, 'findFirst').mockResolvedValue(null);

    // Act
    const result = await loginUser({ email: 'invalid@example.com', password: 'wrong' });

    // Assert
    expect(result.success).toBe(false);
    expect(result.error?.code).toBe('INVALID_CREDENTIALS');
  });
});
```

**Template Playwright (E2E):**
```typescript
// __tests__/e2e/auth/login.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Login Flow', () => {
  test('deve autenticar usuário e redirecionar para dashboard', async ({ page }) => {
    // Arrange
    await page.goto('/login');
    
    // Act
    await page.fill('[data-testid="email"]', 'teste@example.com');
    await page.fill('[data-testid="password"]', 'Senha123!');
    await page.click('[data-testid="submit"]');
    
    // Assert
    await expect(page).toHaveURL('/dashboard');
    await expect(page.locator('[data-testid="welcome"]')).toBeVisible();
  });

  test('deve exibir erro para credenciais inválidas', async ({ page }) => {
    // Arrange
    await page.goto('/login');
    
    // Act
    await page.fill('[data-testid="email"]', 'invalid@example.com');
    await page.fill('[data-testid="password"]', 'wrong');
    await page.click('[data-testid="submit"]');
    
    // Assert
    await expect(page.locator('[data-testid="error-message"]'))
      .toContainText('Credenciais inválidas');
    await expect(page).toHaveURL('/login'); // Sem redirect
  });

  test('deve proteger rotas privadas sem auth', async ({ page }) => {
    // Act
    await page.goto('/dashboard');
    
    // Assert
    await expect(page).toHaveURL('/login?redirect=/dashboard');
  });
});
```

### Fase 3: Validação & Relatório (DELTA)
**Checklist de Qualidade:**
- [ ] Testes rodam em CI/CD (GitHub Actions/Vercel)
- [ ] Cobertura ≥ 80% para lógica de negócio crítica
- [ ] Zero `console.log` ou `debugger` em testes
- [ ] Mocks isolados (sem vazamento entre testes)
- [ ] Nomes descritivos: `it('deve fazer X quando Y')`
- [ ] Edge cases cobertos: null, empty, limits, errors
- [ ] Tempo de execução E2E < 5min (paralelização se necessário)

**Relatório de Testes (Output Padrão):**
```markdown
## 📊 Relatório de Testes - [Feature]

### Resumo
- ✅ Passou: X/Y testes
- ⏱️ Tempo total: Z segundos
- 📈 Cobertura: W%

### Falhas (se houver)
| Teste | Erro | Sessão |
|-------|------|--------|
| [nome] | [mensagem] | [link para vídeo/log] |

### Ações Recomendadas
- [ ] Corrigir [teste falho] antes de merge
- [ ] Investigar flakiness em [nome]
- [ ] Adicionar teste para [cenário faltante]
```

---

## 🔄 Integração com Agentes

| Agente | Papel nos Testes |
|--------|-----------------|
| **DELTA** | **Owner** — Planeja, valida e audita testes |
| **GAMMA** | Implementa testes junto com código (TDD) |
| **ETA** | Investiga falhas intermitentes (flaky tests) |
| **ZETA** | Otimiza tempo de execução (parallel, cache) |
| **THETA** | Orquestra execução em CI/CD via Inngest |

**Exemplo de Orquestração:**
```yaml
# .antigravity-os/[04] MEMORY_DNA/test-execution.json
{
  "feature": "auth-login",
  "tests_planned": 4,
  "tests_executed": 4,
  "tests_passed": 4,
  "coverage": 0.87,
  "execution_time_seconds": 42,
  "flaky_detected": false,
  "ci_url": "https://github.com/.../actions/runs/123",
  "status": "approved_for_merge"
}
```

---

## 🚫 Anti-Padrões (Proibidos)

- ❌ Testes que dependem de ordem de execução
- ❌ Mockar tudo (teste vira teste do mock, não do sistema)
- ❌ Ignorar testes de erro/caminhos alternativos
- ❌ Commit sem rodar `npm run test` localmente
- ❌ Cobertura < 80% em lógica de negócio crítica
- ❌ Testes E2E sem data-testid (frágil a mudanças de UI)

---

## ✅ Checklist de Qualidade DELTA

Antes de aprovar PR com testes:

- [ ] **Unit**: Lógica pura testada com Vitest + AAA pattern
- [ ] **Integration**: API/DB testados com mocks controlados
- [ ] **E2E**: Fluxos críticos validados com Playwright
- [ ] **Coverage**: `npm run test -- --coverage` mostra >80% na feature
- [ ] **Isolation**: Testes rodam em qualquer ordem, sem side-effects
- [ ] **Naming**: Nomes legíveis como documentação viva
- [ ] **CI**: Pipeline GitHub Actions/Vercel passa com testes
- [ ] **Performance**: E2E < 5min, unit < 30s

---

## 📊 Métricas de Sucesso

| Métrica | Alvo | Como Medir |
|---------|------|-----------|
| Test Coverage | >80% lógica de negócio | `vitest --coverage` + codecov |
| Test Execution Time | <5min E2E, <30s unit | `vitest --reporter=verbose` |
| Flaky Tests | 0% | CI pipeline histórico |
| Time to Detect Bug | <5min (testes locais) | Feedback loop do desenvolvedor |
| Regression Rate | <1% pós-deploy | Sentry + monitoramento |

---

## 🔗 Integração com Sistema v3.1

**Roteamento:** Invocada via `/test` ou pipeline de CI/CD pré-merge.

**Memória:** Falhas recorrentes registradas em `.antigravity-os/[04] MEMORY_DNA/` para criar regras de pré-commit automáticas.

**Budget:** Testes não consomem budget de desenvolvimento — são investimento obrigatório.

**Handoff:** Após testes aprovados, DELTA libera para merge ou aciona GAMMA para correções.

**Stack Omega:** Vitest + Playwright + Drizzle Test Utils + GitHub Actions.

---

## 🛠️ Comandos Úteis

```bash
# Rodar todos os testes
npm run test

# Rodar com coverage
npm run test -- --coverage

# Rodar apenas E2E
npx playwright test

# Rodar testes em modo watch (desenvolvimento)
npm run test -- --watch

# Gerar relatório HTML
npx playwright show-report

# Validar tipos dos testes
npx tsc --noEmit --project tsconfig.tests.json
```

---

## 🔗 INTEGRAÇÃO COM ANTIGRAVITY OS v3.1

**Roteamento:** Esta skill é invocada via `.antigravity-os/[02] SQUAD_WRAPPERS/` ou Slash Commands.

**Memória:** Erros encontrados devem ser logados em `.antigravity-os/[04] MEMORY_DNA/[00] error-dna-registry.json`.

**Budget:** Respeite os limites de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.

**Handoff:** Após execução, atualize `context/CURRENT_AGENT.md` e retorne ao THETA.

**Stack Omega:** Siga rigorosamente `Minhas_Rules/STACK_OMEGA_RULES.md`.
