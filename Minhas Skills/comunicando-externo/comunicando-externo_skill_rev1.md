name: comunicando-externo
description: O Mensageiro Omnichannel. Gerencia comunicação de saída via WhatsApp Business (Evolution API), Email (Resend) e outros canais. Arquitetura de filas resiliente com Inngest para garantia de entrega.
version: 3.0.0
tags: [whatsapp, email, evolution-api, resend, omnichannel, notification, inngest]
---

# Comunicando Externo (Omnichannel Protocol v3.0)

## 🎯 Quando usar
- **Notificações Transacionais**: "Seu pedido foi enviado", "Código de verificação".
- **Alertas de Sistema**: Falha crítica, backup concluído, limite de crédito atingido.
- **Engajamento**: Newsletters, follow-ups, reativação de usuários.
- **Suporte**: Confirmações de agendamento, lembretes de consulta.
- **Emergências**: Sistema fora do ar, notificar admin via múltiplos canais.

> **Princípio**: O canal certo para a mensagem certa. Urgência ≠ Formalidade.

---

## 🧱 Canais Suportados

| Canal | Provider | Caso de Uso Ideal | Formatação | Prioridade |
| :--- | :--- | :--- | :--- | :--- |
| **WhatsApp** | Evolution API v2 | Urgente, interativo, curto | Markdown-like | Alta |
| **Email** | Resend | Formal, longo, anexos | HTML/Markdown | Média |
| **SMS** | Twilio (futuro) | 2FA, offline users | Texto puro | Crítica |
| **Push** | OneSignal (futuro) | App mobile ativo | Rich media | Baixa |

### Matriz de Decisão de Canal

```typescript
function selectChannel(context: MessageContext): Channel {
  // Urgência + Contexto do usuário
  if (context.urgency === 'critical' && context.user.hasWhatsApp) {
    return 'whatsapp';  // + Email como fallback
  }
  
  if (context.content.length > 500 || context.hasAttachments) {
    return 'email';
  }
  
  if (context.user.preferredChannel) {
    return context.user.preferredChannel;
  }
  
  return 'email'; // Default seguro
}
```

---

## 🧱 Stack Técnica

### Evolution API v2 (WhatsApp Business)
- **Instância**: Container Docker ou serviço cloud (Evolution v2).
- **Autenticação**: API Key + Instance Name.
- **Recursos**: Texto, mídia (imagem, vídeo, áudio), botões, listas, localização.
- **Webhooks**: Receber confirmações de entrega/leitura.

### Resend (Email Transacional)
- **Domínio**: Configurado e verificado (SPF, DKIM).
- **Templates**: React Email ou HTML puro.
- **Anexos**: Suporte a PDFs, imagens (base64).

### Inngest (Orquestração)
- **Garantia**: At-least-once delivery.
- **Retries**: Exponential backoff (1s, 2s, 4s, 8s, 16s).
- **Observability**: Dashboard de eventos, métricas de entrega.

---

## ⚙️ Fluxo de Trabalho

### Passo 1: Definição da Mensagem (1 min)

- [ ] **Conteúdo**: Texto final ou template com variáveis `{{nome}}`, `{{pedido}}`.
- [ ] **Canal**: Auto-selecionado ou explícito.
- [ ] **Prioridade**: `normal` | `high` | `critical` (afeta retries e fallback).
- [ ] **Agendamento**: Imediato ou `scheduledFor` (timestamp).

**Template de Mensagem:**

```typescript
interface MessagePayload {
  channel: 'whatsapp' | 'email' | 'both';
  recipient: {
    phone?: string;      // WhatsApp: +5511999999999
    email?: string;      // Email: user@exemplo.com
    userId?: string;     // Para lookup no banco
  };
  content: {
    subject?: string;    // Obrigatório para email
    body: string;        // Texto ou HTML
    variables?: Record<string, string>; // Para templates
  };
  metadata: {
    priority: 'normal' | 'high' | 'critical';
    templateId?: string; // ex: "order-confirmation"
    trackOpens?: boolean; // Email only
    trackClicks?: boolean;
    requireConfirmation?: boolean; // WhatsApp delivery receipt
  };
  scheduling?: {
    sendAt?: Date;       // Agendamento
    timezone?: string;   // "America/Sao_Paulo"
  };
}
```

---

### Passo 2: Sanitização e Validação (1 min)

**WhatsApp:**
- [ ] Telefone: apenas números, formato internacional (`55` + DDD + número).
- [ ] Remover caracteres de controle (exceto quebras de linha).
- [ ] Limitar a 4096 caracteres (fragmentar se necessário).
- [ ] Escape de markdown: `*bold*`, `_italic_`, `~strikethrough~`, `` `code` ``.

**Email:**
- [ ] Validar formato de email (RFC 5322 simplificado).
- [ ] Sanitizar HTML (remover scripts, permitir apenas tags seguras).
- [ ] Codificação UTF-8 garantida.
- [ ] Assunto: máx 78 caracteres (RFC), ideal < 50.

```typescript
// Validações
function sanitizePhone(phone: string): string {
  const cleaned = phone.replace(/\D/g, '');
  if (!/^55\d{10,11}$/.test(cleaned)) {
    throw new Error('Telefone deve estar no formato 55+DDD+Número');
  }
  return cleaned;
}

function sanitizeEmail(email: string): string {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    throw new Error('Formato de email inválido');
  }
  return email.toLowerCase().trim();
}
```

---

### Passo 3: Despacho via Inngest (Resiliência)

**NUNCA** chame APIs diretamente. Sempre use o workflow:

```typescript
// No seu código (Server Action, API Route, etc.)
import { inngest } from "@/inngest/client";

await inngest.send({
  name: "app/notify.send",
  data: {
    channel: "whatsapp", // ou "email", "both"
    recipient: {
      phone: "5511999999999",
      email: "cliente@exemplo.com"
    },
    content: {
      subject: "Seu pedido foi enviado! 🚚",
      body: "Olá {{nome}}, seu pedido #{{pedido}} saiu para entrega.",
      variables: { nome: "Maria", pedido: "12345" }
    },
    metadata: {
      priority: "high",
      templateId: "shipping-confirmation"
    }
  }
});
```

**Por que Inngest?**
- **Retries automáticos**: Se Evolution API retornar 500, tenta novamente.
- **Rate limiting**: Evita ban por spam (WhatsApp especialmente sensível).
- **Observabilidade**: Veja no dashboard se a mensagem foi entregue.
- **Fallback**: Se WhatsApp falhar após 3 tentativas, envia Email automaticamente.

---

### Passo 4: Processamento e Entrega

O workflow Inngest executa:

```typescript
// Minhas Skills/comunicando-externo/snippets/inngest_notify.ts
import { inngest } from "@/inngest/client";
import { sendWhatsAppText, sendWhatsAppMedia, sendWhatsAppButtons } from "./evolution_whatsapp";
import { sendEmail, sendEmailWithAttachment } from "./resend_email";

export const notifyWorkflow = inngest.createFunction(
  { 
    id: "omnichannel-notify",
    retries: 3,  // Tentativas antes de falhar
    concurrency: 10,  // Evitar rate limits
  },
  { event: "app/notify.send" },
  async ({ event, step }) => {
    const { channel, recipient, content, metadata } = event.data;
    const results: any = {};

    // Estratégia de Fallback: WhatsApp -> Email -> Log
    const tryWhatsApp = async () => {
      if (!recipient.phone) throw new Error("Telefone não fornecido");
      
      const phone = sanitizePhone(recipient.phone);
      const text = interpolateTemplate(content.body, content.variables);
      
      // Escolhe método baseado no conteúdo
      if (metadata.buttons) {
        return await sendWhatsAppButtons(phone, text, metadata.buttons);
      } else if (metadata.mediaUrl) {
        return await sendWhatsAppMedia(phone, metadata.mediaUrl, text);
      } else {
        return await sendWhatsAppText(phone, text);
      }
    };

    const tryEmail = async () => {
      if (!recipient.email) throw new Error("Email não fornecido");
      if (!content.subject) throw new Error("Assunto obrigatório para email");
      
      const html = markdownToHtml(interpolateTemplate(content.body, content.variables));
      
      if (metadata.attachments) {
        return await sendEmailWithAttachment(
          recipient.email, 
          content.subject, 
          html,
          metadata.attachments
        );
      }
      return await sendEmail(recipient.email, content.subject, html);
    };

    // Execução com fallback
    if (channel === 'whatsapp' || channel === 'both') {
      try {
        results.whatsapp = await step.run("send-whatsapp", tryWhatsApp);
      } catch (error) {
        results.whatsapp = { error: error.message };
        
        // Fallback para email se crítico
        if (metadata.priority === 'critical' && recipient.email) {
          results.fallback = await step.run("fallback-email", tryEmail);
        }
      }
    }

    if (channel === 'email' || (channel === 'both' && !results.whatsapp)) {
      try {
        results.email = await step.run("send-email", tryEmail);
      } catch (error) {
        results.email = { error: error.message };
      }
    }

    // Log de entrega no Neon (opcional)
    await step.run("log-delivery", async () => {
      await saveDeliveryLog({
        eventId: event.id,
        recipient,
        channelsAttempted: Object.keys(results),
        results,
        timestamp: new Date(),
      });
    });

    return results;
  }
);
```

---

## 📋 Checklist de Templates

### WhatsApp Business

**Formatação suportada:**
```text
*Negrito* com asteriscos
_Itálico_ com underscores
~Tachado~ com tils
`Código` com crases
```

**Boas práticas:**
- [ ] Saudação personalizada: "Olá {{nome}}!"
- [ ] Quebras de linha para legibilidade (máx 4 linhas por bloco).
- [ ] Call-to-action claro: "Clique aqui: {{link}}" ou responda "1" para confirmar.
- [ ] Evitar spam: máx 1 mensagem a cada 24h para não ser bloqueado.

**Templates aprovados pela Meta (obrigatório para iniciativa):**
- `order_confirmation`: "Seu pedido {{pedido}} foi confirmado."
- `shipping_update`: "Seu pedido saiu para entrega."
- `payment_reminder`: "Lembrete: pagamento pendente."
- `appointment_reminder`: "Consulta amanhã às {{hora}}."

### Email

**Estrutura:**
- [ ] Assunto claro e curto (< 50 caracteres).
- [ ] Preview text (primeiras 100 caracteres do body).
- [ ] Header com logo, footer com unsubscribe.
- [ ] Responsivo (mobile-first).
- [ ] Alt text em imagens.

---

## 💻 Snippets de Produção

### evolution_whatsapp.ts (Cliente Completo)

```typescript
// lib/evolution/client.ts
const EVO_BASE_URL = process.env.EVOLUTION_API_URL; // https://api.evolution.com/v2
const EVO_API_KEY = process.env.EVOLUTION_API_KEY;
const EVO_INSTANCE = process.env.EVOLUTION_INSTANCE_NAME; // "snapfit-prod"

interface EvolutionResponse {
  status: string;
  message?: string;
  messageId?: string;
}

class EvolutionClient {
  private baseUrl: string;
  private headers: Record<string, string>;

  constructor() {
    this.baseUrl = `${EVO_BASE_URL}/message`;
    this.headers = {
      "Content-Type": "application/json",
      "apikey": EVO_API_KEY!,
    };
  }

  private async request(endpoint: string, body: any): Promise<EvolutionResponse> {
    const url = `${this.baseUrl}/${endpoint}/${EVO_INSTANCE}`;
    
    const response = await fetch(url, {
      method: "POST",
      headers: this.headers,
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Evolution API Error ${response.status}: ${error}`);
    }

    return response.json();
  }

  // Texto simples
  async sendText(phone: string, text: string, options?: {
    delay?: number;
    presence?: 'composing' | 'recording';
    linkPreview?: boolean;
  }) {
    return this.request("sendText", {
      number: phone,
      options: {
        delay: options?.delay || 1200,
        presence: options?.presence || "composing",
        linkPreview: options?.linkPreview ?? true,
      },
      textMessage: { text },
    });
  }

  // Imagem/Vídeo/Áudio/Documento
  async sendMedia(phone: string, mediaUrl: string, caption?: string, type: 'image' | 'video' | 'audio' | 'document' = 'image') {
    return this.request("sendMedia", {
      number: phone,
      options: {
        delay: 1200,
        presence: "composing",
      },
      mediaMessage: {
        [type]: { url: mediaUrl, caption },
      },
    });
  }

  // Botões interativos (lista de opções)
  async sendButtons(phone: string, text: string, buttons: Array<{id: string; text: string}>) {
    return this.request("sendButtons", {
      number: phone,
      options: { delay: 1200 },
      buttonMessage: {
        text,
        footer: "Escolha uma opção",
        buttons: buttons.map(b => ({
          buttonId: b.id,
          buttonText: { displayText: b.text },
          type: 1,
        })),
      },
    });
  }

  // Lista de seleção (mais de 3 opções)
  async sendList(phone: string, title: string, description: string, sections: any[]) {
    return this.request("sendList", {
      number: phone,
      listMessage: {
        title,
        description,
        buttonText: "Ver opções",
        sections,
      },
    });
  }

  // Localização
  async sendLocation(phone: string, latitude: number, longitude: number, name?: string) {
    return this.request("sendLocation", {
      number: phone,
      options: { delay: 1200 },
      locationMessage: {
        latitude,
        longitude,
        name: name || "Localização",
        address: "Endereço",
      },
    });
  }

  // Status da instância
  async getInstanceStatus() {
    const url = `${EVO_BASE_URL}/instance/connectionState/${EVO_INSTANCE}`;
    const response = await fetch(url, { headers: this.headers });
    return response.json();
  }
}

export const evolution = new EvolutionClient();
```

### resend_email.ts (Cliente Completo)

```typescript
// lib/resend/client.ts
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);
const FROM_EMAIL = process.env.FROM_EMAIL || 'SnapFit <noreply@snapfit.com.br>';

interface Attachment {
  filename: string;
  content: Buffer | string; // base64
  contentType?: string;
}

export async function sendEmail(
  to: string, 
  subject: string, 
  html: string,
  options?: {
    replyTo?: string;
    cc?: string[];
    bcc?: string[];
  }
) {
  const { data, error } = await resend.emails.send({
    from: FROM_EMAIL,
    to: [to],
    subject,
    html,
    replyTo: options?.replyTo,
    cc: options?.cc,
    bcc: options?.bcc,
  });

  if (error) {
    throw new Error(`Resend Error: ${error.message}`);
  }

  return { messageId: data?.id, status: 'sent' };
}

export async function sendEmailWithAttachment(
  to: string,
  subject: string,
  html: string,
  attachments: Attachment[]
) {
  const formattedAttachments = attachments.map(att => ({
    filename: att.filename,
    content: Buffer.isBuffer(att.content) 
      ? att.content.toString('base64') 
      : att.content,
    contentType: att.contentType || 'application/octet-stream',
  }));

  const { data, error } = await resend.emails.send({
    from: FROM_EMAIL,
    to: [to],
    subject,
    html,
    attachments: formattedAttachments,
  });

  if (error) {
    throw new Error(`Resend Error: ${error.message}`);
  }

  return { messageId: data?.id, status: 'sent' };
}

// Template helper
export function compileTemplate(templateId: string, variables: Record<string, string>): string {
  const templates: Record<string, string> = {
    'welcome': `
      <h1>Bem-vindo, {{nome}}!</h1>
      <p>Seu cadastro foi confirmado.</p>
    `,
    'order-confirmation': `
      <h1>Pedido Confirmado #{{pedido}}</h1>
      <p>Obrigado pela compra, {{nome}}!</p>
    `,
    // ... mais templates
  };

  let template = templates[templateId] || templates['welcome'];
  
  Object.entries(variables).forEach(([key, value]) => {
    template = template.replace(new RegExp(`{{${key}}}`, 'g'), value);
  });

  return template;
}
```

### inngest_notify.ts (Workflow Completo)

```typescript
// inngest/functions/notify.ts
import { inngest } from "@/inngest/client";
import { evolution } from "@/lib/evolution/client";
import { sendEmail, compileTemplate } from "@/lib/resend/client";
import { db } from "@/lib/db"; // Drizzle/Prisma

// Função auxiliar de interpolação
function interpolate(template: string, vars: Record<string, string>): string {
  return template.replace(/\{\{(\w+)\}\}/g, (_, key) => vars[key] || '');
}

// Função auxiliar: Markdown para HTML simples
function markdownToHtml(markdown: string): string {
  return markdown
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/\n/g, '<br>');
}

export const notifyWorkflow = inngest.createFunction(
  {
    id: "omnichannel-notification",
    name: "Omnichannel Notify",
    retries: 3,
    concurrency: {
      limit: 5,  // Evitar rate limits do WhatsApp
      key: "event.data.channel",
    },
  },
  { event: "app/notify.send" },
  async ({ event, step, logger }) => {
    const { channel, recipient, content, metadata } = event.data;
    const results: Record<string, any> = {};
    const errors: string[] = [];

    // 1. Preparar conteúdo
    const bodyText = interpolate(content.body, content.variables || {});
    const bodyHtml = markdownToHtml(bodyText);

    // 2. Tentar WhatsApp (se solicitado)
    if (channel === 'whatsapp' || channel === 'both') {
      try {
        const phone = recipient.phone?.replace(/\D/g, '');
        if (!phone) throw new Error("Telefone não fornecido");

        const waResult = await step.run("send-whatsapp", async () => {
          // Escolher tipo de mensagem
          if (metadata.buttons && metadata.buttons.length > 0) {
            return await evolution.sendButtons(phone, bodyText, metadata.buttons);
          } else if (metadata.mediaUrl) {
            return await evolution.sendMedia(phone, metadata.mediaUrl, bodyText, metadata.mediaType);
          } else {
            return await evolution.sendText(phone, bodyText, {
              presence: 'composing',
              delay: 1000,
            });
          }
        });

        results.whatsapp = {
          status: 'sent',
          messageId: waResult.messageId,
          timestamp: new Date().toISOString(),
        };
        logger.info(`WhatsApp enviado para ${phone}`);

      } catch (error: any) {
        errors.push(`WhatsApp: ${error.message}`);
        results.whatsapp = { status: 'failed', error: error.message };
        logger.error(`Falha no WhatsApp: ${error.message}`);
      }
    }

    // 3. Tentar Email (se solicitado ou fallback)
    const shouldSendEmail = channel === 'email' || 
                           (channel === 'both' && !results.whatsapp?.status === 'sent') ||
                           (errors.length > 0 && metadata.priority === 'critical');

    if (shouldSendEmail && recipient.email) {
      try {
        const emailResult = await step.run("send-email", async () => {
          const html = metadata.templateId 
            ? compileTemplate(metadata.templateId, content.variables || {})
            : bodyHtml;

          return await sendEmail(recipient.email!, content.subject!, html, {
            replyTo: metadata.replyTo,
          });
        });

        results.email = {
          status: 'sent',
          messageId: emailResult.messageId,
          timestamp: new Date().toISOString(),
        };
        logger.info(`Email enviado para ${recipient.email}`);

      } catch (error: any) {
        errors.push(`Email: ${error.message}`);
        results.email = { status: 'failed', error: error.message };
        logger.error(`Falha no Email: ${error.message}`);
      }
    }

    // 4. Log de entrega no banco
    await step.run("persist-log", async () => {
      await db.insert(deliveryLogs).values({
        eventId: event.id,
        userId: recipient.userId,
        channels: Object.keys(results),
        results,
        errors: errors.length > 0 ? errors : null,
        createdAt: new Date(),
      });
    });

    // 5. Alertar se tudo falhou e é crítico
    if (errors.length === Object.keys(results).length && metadata.priority === 'critical') {
      await step.run("alert-admin", async () => {
        // Enviar alerta para admin via canal alternativo (SMS, Slack, etc.)
        logger.error(`FALHA CRÍTICA: Não foi possível notificar ${recipient.userId}`);
      });
    }

    return {
      success: errors.length < Object.keys(results).length,
      results,
      errors: errors.length > 0 ? errors : undefined,
    };
  }
);
```

---

## 🗂️ Estrutura de Arquivos

```
Minhas Skills/comunicando-externo/
├── SKILL.md                              # Este protocolo
├── snippets/
│   ├── evolution_whatsapp.ts             # Cliente Evolution API completo
│   ├── resend_email.ts                   # Cliente Resend completo
│   ├── inngest_notify.ts                 # Workflow de notificação
│   └── channel_router.ts                 # Lógica de seleção de canal
├── resources/
│   ├── templates_mensagens.md            # Templates de WhatsApp/Email
│   ├── formatacao_whatsapp.md            # Guia de formatação WA
│   └── exemplos_payloads.json            # Exemplos de eventos Inngest
└── scripts/
    ├── validate_credentials.py           # Testa conexões Evolution/Resend
    └── migrate_templates.py              # Importa templates em massa
```

---

