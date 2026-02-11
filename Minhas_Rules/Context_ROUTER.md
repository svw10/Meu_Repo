# ROUTER - Antigravity OS

## Regra
Carregar SÓ o necessário para a tarefa atual.

## Mapeamento Rápido
- planejar, arquitetura, schema → BETA + planejando-solucoes
- codar, implementar, criar → GAMMA + executando-planos  
- design, ui, landing page → GAMMA + designer-ui + design-cinematic
- bug, erro, fix → ETA + solucionando-erros
- revisar, audit, segurança → DELTA + verificando-conclusao

## Checklist
- [ ] Verificar CURRENT_AGENT.md
- [ ] Carregar Agente indicado
- [ ] Carregar Skill completa da tarefa
- [ ] IGNORAR todo o resto
```

---

## 2. `context/CURRENT_AGENT.md`

```markdown
---
agent: THETA
task: "aguardando"
status: "idle"
---

## Ativo Agora
- Agente: THETA_Orchestrator
- Desde: 2026-02-11T00:00:00Z

## Próximo
Aguardando comando do usuário.
```

---

## 3. Adicionar no início do seu `.cursorrules`:

```markdown
# ANTIGRAVITY OS v2.1

## ROTEAMENTO (Sempre primeiro)
1. Ler: context/ROUTER.md
2. Ler: context/CURRENT_AGENT.md  
3. Carregar SÓ o que for indicado para esta tarefa
4. IGNORAR todo o resto do repositório

## [resto do seu .cursorrules atual continua aqui...]
```

