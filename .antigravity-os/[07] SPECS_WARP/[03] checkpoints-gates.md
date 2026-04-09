# [03] CHECKPOINTS & GATES — Portões de Qualidade Obrigatórios

## Propósito
Definir pontos de parada obrigatórios onde a IA deve validar critérios antes de avançar para a próxima fase, prevenindo retrabalho em cascata e garantindo conformidade.

---

## 🚦 Mapa de Gates do Fluxo
[PRD Rascunho]
↓
[GATE 1: PRD Review] ← BETA + Humano
↓
[PRD Aprovado]
↓
[GATE 2: SPEC Generation] ← Validação Zod + THETA
↓
[SPEC Técnica]
↓
[GATE 3: Sprint Approval] ← DELTA (Security/Performance Check)
↓
[Execução GAMMA]
↓
[GATE 4: Acceptance Test] ← Testes automatizados + DELTA
↓
[Deploy/Commit]
↓
[GATE 5: Post-Mortem] ← Registro em MEMORY_DNA


---

## 📋 Detalhamento dos Gates

### GATE 1: PRD Review (Negócio)
**Responsável:** BETA (Architect) + Validação Humana  
**Critérios de Passagem:**
- [ ] User Stories no formato correto (Como/Quero/Para)
- [ ] Critérios de aceite em BDD/Gherkin definidos
- [ ] "Fora do Escopo" explicitamente listado
- [ ] KPIs mensuráveis definidos
- [ ] Sem termos técnicos de implementação

**Ação se Falhar:** Retornar para refinamento com BETA. Não gerar SPEC.

---

### GATE 2: SPEC Generation (Técnica)
**Responsável:** THETA (Orchestrator) + Validação Zod  
**Critérios de Passagem:**
- [ ] Schema `SpecTechnicalSchema` validado com sucesso
- [ ] `linked_prd_id` presente e válido
- [ ] Sprints divididas atomicamente (<15k tokens cada)
- [ ] Stack e constraints alinhadas com `Minhas_Rules/`
- [ ] Budget de tokens definido por sprint

**Ação se Falhar:** Solicitar correção da SPEC. Não iniciar codificação.

---

### GATE 3: Sprint Approval (Pré-Execução)
**Responsável:** DELTA (Auditor)  
**Critérios de Passagem:**
- [ ] Nenhum secret/PII nos arquivos alvo
- [ ] Dependências declaradas e disponíveis
- [ ] Critérios de aceite testáveis automatizadamente
- [ ] Fallback definido se budget estourar

**Ação se Falhar:** Bloquear execução do GAMMA. Acionar ETA para investigação.

---

### GATE 4: Acceptance Test (Pós-Execução)
**Responsável:** DELTA + Testes Automatizados  
**Critérios de Passagem:**
- [ ] Todos os `acceptance_criteria` da sprint passaram
- [ ] Lint/TypeScript sem erros
- [ ] Testes unitários/integração criados e passando
- [ ] Telemetria registrada em `TOKENOMICS/[03] cost-telemetry.json`

**Ação se Falhar:** Acionar loop de correção com ETA. Se >3 retries, escalar para humano.

---

### GATE 5: Post-Mortem (Aprendizado)
**Responsável:** THETA + MEMORY_DNA  
**Critérios de Passagem:**
- [ ] Erros encontrados registrados em `error-dna-registry.json`
- [ ] `prevention_prompt` gerado para erros recorrentes
- [ ] Métricas de custo/tempo atualizadas
- [ ] Sprint marcada como `done` no tracker

**Ação se Falhar:** Não considerar sprint concluída. Revisar processo de registro.

---

## ⚙️ Integração com Agentes

| Gate | Agente Primário | Ação Automática |
|------|----------------|-----------------|
| 1 | BETA | Gera checklist de validação de PRD |
| 2 | THETA | Executa `zod.parse()` na SPEC |
| 3 | DELTA | Roda scanner de segurança pré-execução |
| 4 | DELTA + GAMMA | Executa testes e valida outputs |
| 5 | THETA | Atualiza MEMORY_DNA e TOKENOMICS |

## 🚨 Regra de Escape
Se um gate falhar 2x consecutivas no mesmo tipo de erro:
1. Pausar execução
2. Notificar usuário: "⚠️ Gate [X] falhou repetidamente. Intervenção necessária."
3. Sugerir revisão manual ou ajuste de especificação

## 📝 Instrução para IA
Sempre que atingir um gate listado acima, execute a validação correspondente ANTES de prosseguir. Nunca pule gates, mesmo sob pressão de tempo.
