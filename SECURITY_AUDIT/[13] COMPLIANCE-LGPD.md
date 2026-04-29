---
name: compliance_lgpd
description: "Checklist de compliance LGPD para projetos"
version: 5.0.0
framework: "Antigravity OS v3.1"
status: active
tags: [security, lgpd, compliance, privacy, gdpr]
---

# 🇧🇷 COMPLIANCE LGPD — Checklist Específico

> Lei Geral de Proteção de Dados (Lei 13.709/2018)
> Aplicável a TODOS os projetos que tratam dados de pessoas no Brasil.

---

## 📋 Princípios LGPD (Art. 6)

| Princípio | Verificação | Status |
|-----------|------------|--------|
| **Finalidade** | Dados coletados apenas para finalidade informada? | [ ] |
| **Adequação** | Tratamento compatível com a finalidade? | [ ] |
| **Necessidade** | Coleta limitada ao mínimo necessário? | [ ] |
| **Livre Acesso** | Titular pode consultar seus dados gratuitamente? | [ ] |
| **Qualidade** | Dados mantidos atualizados e corretos? | [ ] |
| **Transparência** | Titular informado sobre o tratamento? | [ ] |
| **Segurança** | Medidas técnicas de proteção implementadas? | [ ] |
| **Prevenção** | Medidas para prevenir danos aos titulares? | [ ] |
| **Não Discriminação** | Dados não usados para discriminação? | [ ] |
| **Responsabilização** | Agente demonstra adoção de medidas eficazes? | [ ] |

---

## Checklist Técnico

### 1. Consentimento e Base Legal
- [ ] Base legal definida para cada tipo de tratamento (consentimento, contrato, legítimo interesse, etc.)
- [ ] Consentimento coletado de forma explícita e granular
- [ ] Opção de revogação do consentimento acessível
- [ ] Registro de consentimentos (quem, quando, para quê)
- [ ] Termos de Uso e Política de Privacidade atualizados

### 2. Direitos do Titular (Art. 18)
- [ ] **Confirmação** de tratamento
- [ ] **Acesso** aos dados pessoais
- [ ] **Correção** de dados incompletos/incorretos
- [ ] **Anonimização/Bloqueio/Eliminação** de dados desnecessários
- [ ] **Portabilidade** dos dados (export em formato aberto)
- [ ] **Eliminação** dos dados (direito ao esquecimento)
- [ ] **Informação** sobre compartilhamento com terceiros
- [ ] **Revogação** do consentimento
- [ ] Endpoint/interface para exercício dos direitos
- [ ] SLA de resposta: máximo 15 dias

### 3. Proteção Técnica de Dados
- [ ] Criptografia em trânsito (TLS 1.2+)
- [ ] Criptografia em repouso (AES-256 para dados sensíveis)
- [ ] PII mascarada em logs (CPF, email, telefone)
- [ ] PII nunca em URLs, query params ou error messages
- [ ] Backup criptografado
- [ ] Acesso a dados pessoais auditado (audit trail)

### 4. Minimização e Retenção
- [ ] Política de retenção documentada por tipo de dado
- [ ] Dados deletados automaticamente após período
- [ ] Dados sensíveis com TTL explícito
- [ ] `SELECT` com projeção mínima (nunca `SELECT *`)
- [ ] Dados de teste/dev nunca contêm dados reais

### 5. Compartilhamento com Terceiros
- [ ] DPA (Data Processing Agreement) com cada fornecedor
- [ ] Lista de sub-processadores documentada
- [ ] Dados transferidos para exterior? Base legal documentada
- [ ] Webhook/API: dados mínimos necessários compartilhados

### 6. Incidentes (Art. 48)
- [ ] Plano de Resposta a Incidentes documentado
- [ ] Notificação à ANPD em 2 dias úteis
- [ ] Notificação aos titulares afetados
- [ ] Post-mortem obrigatório

### 7. Governança
- [ ] DPO (Encarregado) nomeado e publicado
- [ ] RIPD (Relatório de Impacto) para tratamentos de alto risco
- [ ] Registro de atividades de tratamento (Art. 37)
- [ ] Treinamento da equipe sobre LGPD

---

## Implementação Técnica

### Mascaramento de PII em Logs

```typescript
// lib/security/pii-masker.ts
const PII_PATTERNS = [
  { name: 'CPF', regex: /\d{3}\.\d{3}\.\d{3}-\d{2}/g, mask: '[CPF_REDACTED]' },
  { name: 'CNPJ', regex: /\d{2}\.\d{3}\.\d{3}\/\d{4}-\d{2}/g, mask: '[CNPJ_REDACTED]' },
  { name: 'Email', regex: /[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}/g, mask: '[EMAIL_REDACTED]' },
  { name: 'Phone', regex: /\(\d{2}\)\s?\d{4,5}-?\d{4}/g, mask: '[PHONE_REDACTED]' },
  { name: 'Card', regex: /\d{4}[\s-]?\d{4}[\s-]?\d{4}[\s-]?\d{4}/g, mask: '[CARD_REDACTED]' },
]

export function maskPII(text: string): string {
  let masked = text
  for (const pattern of PII_PATTERNS) {
    masked = masked.replace(pattern.regex, pattern.mask)
  }
  return masked
}
```

### API de Direitos do Titular

```typescript
// app/api/lgpd/route.ts
export async function GET(req: AuthenticatedRequest) {
  const userId = req.user.id
  
  // Direito de acesso — retorna todos os dados do titular
  const userData = await db.user.findUnique({
    where: { id: userId },
    select: { name: true, email: true, phone: true, createdAt: true }
  })
  
  return Response.json({ data: userData })
}

export async function DELETE(req: AuthenticatedRequest) {
  const userId = req.user.id
  
  // Direito ao esquecimento — anonimiza dados
  await db.$transaction([
    db.user.update({
      where: { id: userId },
      data: { name: 'ANONIMIZADO', email: `deleted_${userId}@removed.com`, phone: null }
    }),
    db.auditLog.create({
      data: { action: 'LGPD_DELETE', userId, timestamp: new Date() }
    })
  ])
  
  return Response.json({ success: true, message: 'Dados removidos com sucesso' })
}
```

### Registro de Consentimento

```typescript
const consentSchema = z.object({
  purpose: z.enum(['marketing', 'analytics', 'essential', 'third_party']),
  granted: z.boolean(),
  version: z.string(), // Versão da política de privacidade aceita
})

async function recordConsent(userId: string, consent: z.infer<typeof consentSchema>) {
  await db.consent.create({
    data: {
      userId,
      purpose: consent.purpose,
      granted: consent.granted,
      policyVersion: consent.version,
      ipAddress: maskPII(req.ip), // IP mascarado
      userAgent: req.headers['user-agent'],
      timestamp: new Date(),
    }
  })
}
```

---

## 📊 Métricas LGPD

| Métrica | Meta | Frequência |
|---------|------|------------|
| Solicitações de titulares respondidas no prazo | 100% | Mensal |
| Dados com política de retenção definida | 100% | Trimestral |
| PII em logs de produção | 0 | Contínuo |
| DPAs com fornecedores atualizados | 100% | Semestral |
| Treinamentos LGPD realizados | 100% da equipe | Anual |

---

## 🔗 Referências

- LGPD (Lei 13.709/2018): https://www.planalto.gov.br/ccivil_03/_ato2015-2018/2018/lei/l13709.htm
- ANPD: https://www.gov.br/anpd/
- OWASP Privacy: https://owasp.org/www-project-top-10-privacy-risks/
