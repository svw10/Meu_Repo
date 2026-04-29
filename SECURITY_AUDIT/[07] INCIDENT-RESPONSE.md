---
name: incident_response
description: "Plano de Resposta a Incidentes de Segurança (IRP)"
version: 5.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
status: active
tags: [security, incident-response, irp, playbook]
---

# 🚨 PLANO DE RESPOSTA A INCIDENTES (IRP)

> **NÃO improvise.** Siga este plano. Cada minuto conta.

---

## 📋 Classificação de Severidade

| Nível | Nome | Exemplos | SLA Resposta | SLA Resolução |
|-------|------|----------|-------------|---------------|
| **SEV-1** | Crítico | Dados vazados, sistema comprometido, ransomware | **15 min** | **4 horas** |
| **SEV-2** | Alto | Auth bypass, secrets expostos, escalação de privilégio | **1 hora** | **24 horas** |
| **SEV-3** | Médio | XSS stored, CSRF, dependência com CVE alta | **4 horas** | **72 horas** |
| **SEV-4** | Baixo | Info disclosure, headers faltando, CVE média | **24 horas** | **7 dias** |

---

## 🔴 FASE 1: DETECÇÃO & TRIAGEM (0-15 min)

### Checklist Imediato
- [ ] **Identificar** o tipo de incidente (dados, auth, infra, supply chain)
- [ ] **Classificar** severidade (SEV-1 a SEV-4)
- [ ] **Documentar** hora de detecção, quem detectou, evidências iniciais
- [ ] **Notificar** responsáveis conforme a severidade:

| Severidade | Notificar Imediatamente |
|------------|------------------------|
| SEV-1 | CTO + DPO + Equipe técnica + Jurídico |
| SEV-2 | Tech Lead + Equipe técnica + DPO (se dados) |
| SEV-3 | Tech Lead + Dev responsável |
| SEV-4 | Dev responsável (pode aguardar próximo dia útil) |

### Template de Notificação
```
🚨 INCIDENTE DE SEGURANÇA — SEV-[N]
Tipo: [dados/auth/infra/supply-chain]
Detectado: [data/hora] por [quem/sistema]
Status: Em investigação
Impacto estimado: [descrição]
Ação imediata: [o que está sendo feito]
Canal: [link do canal de comunicação]
```

---

## 🟡 FASE 2: CONTENÇÃO (15 min - 2h)

### Contenção Imediata (Curto Prazo)
- [ ] **Isolar** o sistema afetado (sem desligar, preservar evidências)
- [ ] **Revogar** tokens/keys comprometidas
- [ ] **Bloquear** IPs/contas suspeitas
- [ ] **Desabilitar** features/endpoints afetados (feature flag)

### Ações por Tipo de Incidente

| Tipo | Ação de Contenção |
|------|-------------------|
| **Secrets vazados** | Rotação imediata de TODAS as keys. Revogar tokens ativos. |
| **Auth bypass** | Forçar logout de todas as sessões. Ativar modo maintenance. |
| **Data breach** | Isolar banco. Snapshot para forense. Bloquear acesso externo. |
| **Dependency CVE** | Patch imediato ou rollback para versão segura. |
| **Ransomware** | Isolar rede. NÃO pague. Restaurar de backup limpo. |

### Comandos de Emergência
```bash
# Rotação de secrets (exemplo Vercel)
vercel env rm STRIPE_SECRET_KEY production
vercel env add STRIPE_SECRET_KEY production < new_key.txt

# Forçar logout (exemplo Clerk)
# Via dashboard: Sessions → Revoke All

# Rollback de deploy
vercel rollback --yes

# Bloquear IP no Cloudflare
curl -X POST "https://api.cloudflare.com/client/v4/zones/$ZONE/firewall/access_rules/rules" \
  -H "Authorization: Bearer $CF_TOKEN" \
  -d '{"mode":"block","configuration":{"target":"ip","value":"ATTACKER_IP"}}'
```

---

## 🔵 FASE 3: ERRADICAÇÃO (2h - 24h)

- [ ] **Identificar** causa raiz (root cause)
- [ ] **Remover** acesso/código/configuração vulnerável
- [ ] **Aplicar** correção (patch, config change, code fix)
- [ ] **Verificar** que a correção resolve o problema
- [ ] **Escanear** por indicadores de comprometimento adicionais
- [ ] **Auditar** logs para determinar extensão do impacto

### Checklist de Investigação
```bash
# Verificar acessos suspeitos
grep -i "unauthorized\|forbidden\|401\|403" /var/log/app/*.log

# Verificar mudanças recentes
git log --since="24 hours ago" --oneline --all

# Verificar deploys recentes
vercel ls --limit 10

# Verificar dependências
npm audit --production
```

---

## 🟢 FASE 4: RECUPERAÇÃO (24h - 72h)

- [ ] **Restaurar** serviços de forma gradual
- [ ] **Monitorar** de perto por 48h (alertas em modo sensível)
- [ ] **Validar** com testes de segurança automatizados
- [ ] **Comunicar** status atualizado às partes interessadas
- [ ] **Re-habilitar** features desabilitadas

### Comunicação com Usuários (se dados afetados)

```markdown
# Comunicado de Segurança

Detectamos um incidente de segurança em [data] que pode ter afetado [descrição].

**O que aconteceu:** [resumo factual]
**O que fizemos:** [ações tomadas]
**O que você deve fazer:** [recomendações — trocar senha, etc.]
**Próximos passos:** [melhorias planejadas]

Estamos à disposição em [canal de suporte].

Atenciosamente,
[Nome] — DPO / Responsável de Segurança
```

---

## 📝 FASE 5: POST-MORTEM (48h após resolução)

> **Obrigatório.** Sem exceções. Sem culpa. Foco em processo.

### Template de Post-Mortem
```markdown
# Post-Mortem: [Título do Incidente]

**Data do incidente:** [YYYY-MM-DD HH:MM]
**Duração:** [X horas/minutos]
**Severidade:** SEV-[N]
**Autor do post-mortem:** [nome]
**Data do post-mortem:** [YYYY-MM-DD]

## Timeline
| Hora | Evento |
|------|--------|
| HH:MM | [Detecção] |
| HH:MM | [Contenção] |
| HH:MM | [Resolução] |

## Causa Raiz
[Descrição técnica detalhada]

## Impacto
- Usuários afetados: X
- Dados expostos: [tipo/quantidade]
- Tempo de indisponibilidade: X min
- Custo estimado: R$ X

## O que funcionou bem
1. [...]
2. [...]

## O que podemos melhorar
1. [...]
2. [...]

## Action Items
| # | Ação | Responsável | Prazo | Status |
|---|------|-------------|-------|--------|
| 1 | [ ] | | | |

## Lições Aprendidas
[O que o time aprendeu e como isso muda nossos processos]
```

---

## 🔐 LGPD: Notificação à ANPD

Se dados pessoais foram afetados (LGPD Art. 48):

- **Prazo:** 2 dias úteis após a ciência
- **Destinatário:** ANPD + titulares afetados
- **Conteúdo obrigatório:**
  1. Natureza dos dados pessoais afetados
  2. Informações sobre os titulares envolvidos
  3. Indicação das medidas técnicas de segurança
  4. Riscos relacionados ao incidente
  5. Medidas adotadas para reverter/mitigar
  6. Motivos da demora (se > 2 dias úteis)

---

## 📞 Contatos de Emergência

| Papel | Contato | Responsabilidade |
|-------|---------|------------------|
| **DPO** | [email/telefone] | Compliance LGPD, comunicação com ANPD |
| **CTO** | [email/telefone] | Decisões técnicas, escalação |
| **Tech Lead** | [email/telefone] | Coordenação técnica da resposta |
| **Jurídico** | [email/telefone] | Implicações legais, notificações |
| **Comunicação** | [email/telefone] | Comunicados externos |

---

**🚨 Em caso de dúvida: CONTENHA PRIMEIRO, INVESTIGUE DEPOIS.**
