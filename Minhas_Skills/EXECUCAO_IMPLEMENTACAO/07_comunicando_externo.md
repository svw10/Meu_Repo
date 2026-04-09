---
name: comunicando_externo
framework: "Antigravity OS v3.1"
owner_agent: GAMMA
trigger: "/communicate"
framework_version: "3.1.0"
integration: "Antigravity Neural Router"
status: active
---

name: comunicando-externo
description: Mensageiro Omnichannel. Gerencia comunicação via WhatsApp (Evolution API), Email (Resend) com filas resilientes (Inngest). Fallback automático, observabilidade completa.
version: 3.0.1
tags: [whatsapp, email, evolution-api, resend, inngest, notificacoes, omnichannel]
---

# 07 - COMUNICANDO EXTERNO (Omnichannel Protocol)

## 🎯 Quando usar
- **Notificações transacionais**: "Pedido enviado", "Código de verificação"
- **Alertas de sistema**: Falha crítica, backup concluído, limite atingido
- **Engajamento**: Newsletters, follow-ups, reativação
- **Suporte**: Confirmações, lembretes de consulta
- **Emergências**: Sistema fora do ar, notificar admin via múltiplos canais

> **Princípio**: Canal certo para a mensagem certa. Urgência ≠ Formalidade.

## 🧱 Canais Suportados (Stack Omega)

| Canal | Provider | Caso de Uso | Formatação | Prioridade |
|:---|:---|:---|:---|:---:|
| **WhatsApp** | Evolution API v2 | Urgente, interativo, curto | Markdown-like | 🔴 Alta |
| **Email** | Resend | Formal, longo, anexos | HTML/Markdown | 🟡 Média |
| **SMS** | Twilio (futuro) | 2FA, offline users | Texto puro | 🔴 Crítica |
| **Push** | OneSignal (futuro) | App mobile ativo | Rich media | 🟢 Baixa |

### Matriz de Decisão

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

## 🛠️ Stack Técnica (Integrações)

| Componente | Tecnologia | Propósito |
|:---|:---|:---|
| **WhatsApp** | Evolution API v2 | Mensagens business, mídia, botões |
| **Email** | Resend | Transacional, templates React |
| **Filas** | Inngest | At-least-once delivery, retries, observability |
| **Logs** | Neon PostgreSQL | Rastreamento de entregas |
| **Schema** | Drizzle ORM | Tipagem de tabelas de log |

## ⚙️ Fluxo de Trabalho

### Passo 1: Definição da Mensagem (1 min)

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
    variables?: Record<string, string>; // {{nome}}, {{pedido}}
  };
  metadata: {
    priority: 'normal' | 'high' | 'critical';
    templateId?: string; // ex: "order-confirmation"
    buttons?: Array<{id: string; text: string}>; // WhatsApp
    mediaUrl?: string;   // Imagem/vídeo WhatsApp
    attachments?: Attachment[]; // Email anexos
  };
  scheduling?: {
    sendAt?: Date;       // Agendamento
  };
}
```

### Passo 2: Sanitização (1 min)

**WhatsApp:**
```typescript
function sanitizePhone(phone: string): string {
  const cleaned = phone.replace(/\D/g, '');
  if (!/^55\d{10,11}$/.test(cleaned)) {
    throw new Error('Formato: 55+DDD+Número (ex: 5511999999999)');
  }
  return cleaned;
}

// Formatação: *negrito*, _itálico_, ~tachado~, `código`
// Limite: 4096 caracteres (fragmentar se necessário)
```

**Email:**
```typescript
function sanitizeEmail(email: string): string {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!emailRegex.test(email)) {
    throw new Error('Email inválido');
  }
  return email.toLowerCase().trim();
}
// Assunto: máx 78 caracteres (RFC), ideal < 50
// HTML: sanitizado (sem scripts, tags seguras apenas)
```

### Passo 3: Despacho via Inngest (Resiliência)

**NUNCA** chame APIs diretamente. Use workflow:

```typescript
// Em Server Action, API Route, ou outro lugar
import { inngest } from "@/inngest/client";

await inngest.send({
  name: "app/notify.send",
  data: {
    channel: "whatsapp",
    recipient: {
      phone: "5511999999999",
      email: "cliente@exemplo.com" // Fallback
    },
    content: {
      subject: "Pedido enviado! 🚚",
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
- **Retries**: Exponential backoff (1s, 2s, 4s, 8s, 16s)
- **Rate limiting**: Evita ban do WhatsApp
- **Observability**: Dashboard de eventos
- **Fallback**: WhatsApp falhou → Email automático

### Passo 4: Processamento (Workflow Inngest)

```typescript
// src/inngest/functions/notify.ts
import { inngest } from "@/inngest/client";
import { evolution } from "@/lib/evolution/client";
import { sendEmail } from "@/lib/resend/client";
import { db } from "@/db";
import { deliveryLogs } from "@/db/schema";

export const notifyWorkflow = inngest.createFunction(
  { 
    id: "omnichannel-notify",
    retries: 3,
    concurrency: { limit: 5, key: "event.data.channel" }, // Rate limit
  },
  { event: "app/notify.send" },
  async ({ event, step, logger }) => {
    const { channel, recipient, content, metadata } = event.data;
    const results: Record<string, any> = {};
    const errors: string[] = [];

    // Helper: Interpolação de template
    const bodyText = interpolate(content.body, content.variables || {});
    const bodyHtml = markdownToHtml(bodyText);

    // 1. WhatsApp
    if (channel === 'whatsapp' || channel === 'both') {
      try {
        const waResult = await step.run("send-whatsapp", async () => {
          const phone = sanitizePhone(recipient.phone!);
          
          if (metadata.buttons) {
            return await evolution.sendButtons(phone, bodyText, metadata.buttons);
          }
          if (metadata.mediaUrl) {
            return await evolution.sendMedia(phone, metadata.mediaUrl, bodyText);
          }
          return await evolution.sendText(phone, bodyText);
        });

        results.whatsapp = { status: 'sent', messageId: waResult.messageId };
      } catch (error: any) {
        errors.push(`WhatsApp: ${error.message}`);
        results.whatsapp = { status: 'failed', error: error.message };
      }
    }

    // 2. Email (se solicitado ou fallback crítico)
    const shouldEmail = channel === 'email' || 
      (channel === 'both' && results.whatsapp?.status !== 'sent') ||
      (errors.length > 0 && metadata.priority === 'critical');

    if (shouldEmail && recipient.email) {
      try {
        const emailResult = await step.run("send-email", async () => {
          return await sendEmail(
            recipient.email!, 
            content.subject!, 
            bodyHtml
          );
        });
        results.email = { status: 'sent', messageId: emailResult.messageId };
      } catch (error: any) {
        errors.push(`Email: ${error.message}`);
        results.email = { status: 'failed', error: error.message };
      }
    }

    // 3. Persistir log no Neon
    await step.run("persist-log", async () => {
      await db.insert(deliveryLogs).values({
        eventId: event.id,
        userId: recipient.userId,
        channelsAttempted: Object.keys(results),
        results,
        errors: errors.length > 0 ? errors : null,
        createdAt: new Date(),
      });
    });

    // 4. Alertar admin se tudo falhou e é crítico
    if (errors.length === Object.keys(results).length && 
        metadata.priority === 'critical') {
      logger.error(`FALHA CRÍTICA: Não notificado ${recipient.userId}`);
      // Aqui poderia acionar outro canal (SMS, Slack)
    }

    return {
      success: errors.length < Object.keys(results).length,
      results,
      errors: errors.length > 0 ? errors : undefined,
    };
  }
);
```

## 📋 Schema de Banco (Drizzle)

```typescript
// src/db/schema/comms.ts
import { pgTable, uuid, varchar, timestamp, jsonb, index } from "drizzle-orm/pg-core";

export const deliveryLogs = pgTable("delivery_logs", {
  id: uuid("id").defaultRandom().primaryKey(),
  eventId: varchar("event_id", { length: 255 }).notNull(),
  userId: varchar("user_id", { length: 255 }),
  channelsAttempted: varchar("channels_attempted", { length: 50 }).array(),
  results: jsonb("results"),
  errors: jsonb("errors"),
  createdAt: timestamp("created_at").defaultNow().notNull(),
}, (table) => ({
  eventIdx: index("delivery_logs_event_idx").on(table.eventId),
  userIdx: index("delivery_logs_user_idx").on(table.userId),
  createdIdx: index("delivery_logs_created_idx").on(table.createdAt),
}));
```

## 💻 Código de Produção

### Cliente Evolution API (lib/evolution/client.ts)

```typescript
const EVO_BASE_URL = process.env.EVOLUTION_API_URL;
const EVO_API_KEY = process.env.EVOLUTION_API_KEY;
const EVO_INSTANCE = process.env.EVOLUTION_INSTANCE_NAME;

interface EvolutionResponse {
  status: string;
  message?: string;
  messageId?: string;
}

class EvolutionClient {
  private headers = {
    "Content-Type": "application/json",
    "apikey": EVO_API_KEY!,
  };

  private async request(endpoint: string, body: any): Promise<EvolutionResponse> {
    const url = `${EVO_BASE_URL}/message/${endpoint}/${EVO_INSTANCE}`;
    
    const response = await fetch(url, {
      method: "POST",
      headers: this.headers,
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Evolution API ${response.status}: ${error}`);
    }
    return response.json();
  }

  async sendText(phone: string, text: string, options?: {
    delay?: number;
    presence?: 'composing';
  }) {
    return this.request("sendText", {
      number: phone,
      options: {
        delay: options?.delay || 1200,
        presence: options?.presence || "composing",
      },
      textMessage: { text },
    });
  }

  async sendMedia(phone: string, mediaUrl: string, caption?: string) {
    return this.request("sendMedia", {
      number: phone,
      options: { delay: 1200 },
      mediaMessage: {
        image: { url: mediaUrl, caption },
      },
    });
  }

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
}

export const evolution = new EvolutionClient();
```

### Cliente Resend (lib/resend/client.ts)

```typescript
import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);
const FROM_EMAIL = process.env.FROM_EMAIL || 'SeuApp <noreply@exemplo.com>';

export async function sendEmail(to: string, subject: string, html: string) {
  const { data, error } = await resend.emails.send({
    from: FROM_EMAIL,
    to: [to],
    subject,
    html,
  });

  if (error) throw new Error(`Resend: ${error.message}`);
  return { messageId: data?.id, status: 'sent' };
}

export function markdownToHtml(markdown: string): string {
  return markdown
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/\n/g, '<br>');
}

export function interpolate(template: string, vars: Record<string, string>): string {
  return template.replace(/\{\{(\w+)\}\}/g, (_, key) => vars[key] || '');
}
```

## 🛠️ Variáveis de Ambiente (.env.local)

```bash
# Evolution API (WhatsApp)
EVOLUTION_API_URL=https://api.evolution.com/v2
EVOLUTION_API_KEY=evo_xxxxxxxxxxxxxxxx
EVOLUTION_INSTANCE_NAME=meuapp-prod

# Resend (Email)
RESEND_API_KEY=re_xxxxxxxxxxxxxxxx
FROM_EMAIL="SeuApp <noreply@seuapp.com.br>"

# Opcional: Twilio (SMS futuro)
# TWILIO_ACCOUNT_SID=ACxxxxxxxx
# TWILIO_AUTH_TOKEN=xxxxxxxx
```

## 📝 Templates de Mensagens

### WhatsApp (Markdown-like)
```
*Olá {{nome}}!* 👋

Seu pedido *#{{pedido}}* foi confirmado.

📦 Status: {{status}}
💰 Total: R$ {{valor}}

Acompanhe em: {{link}}

_Dúvidas? Responda aqui._
```

### Email (HTML)
```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>{{subject}}</title>
</head>
<body style="font-family: system-ui, sans-serif; line-height: 1.5; color: #333;">
  <div style="max-width: 600px; margin: 0 auto; padding: 20px;">
    <h1 style="color: #000;">Olá {{nome}},</h1>
    <p>Seu pedido <strong>#{{pedido}}</strong> foi confirmado.</p>
    <!-- ... -->
    <hr style="border: none; border-top: 1px solid #eee; margin: 30px 0;">
    <p style="font-size: 12px; color: #666;">
      Enviado por SeuApp • <a href="{{unsubscribe}}">Cancelar inscrição</a>
    </p>
  </div>
</body>
</html>
```

## 🚫 Anti-Padrões

- ❌ Chamar Evolution/Resend diretamente (sem Inngest)
- ❌ Não sanitizar telefone/email
- ❌ Ignorar erros de entrega (sempre logar)
- ❌ Spam: >1 mensagem/24h para mesmo usuário
- ❌ Dados sensíveis em logs de texto
- ❌ Anexos grandes (>5MB) sem compressão

## ✅ Checklist de Implementação

- [ ] Variáveis de ambiente configuradas
- [ ] Schema `delivery_logs` aplicado no Neon
- [ ] Cliente Evolution testado (`sendText` simples)
- [ ] Cliente Resend testado (envio básico)
- [ ] Workflow Inngest registrado
- [ ] Fallback WhatsApp→Email testado
- [ ] Logs sendo persistidos no banco
- [ ] Dashboard Inngest acessível

## 🔗 Integração

- **Chamada:** Direta por outras skills (ex: após `03_executando_planos` criar pedido)
- **Pré-requisito:** Inngest configurado, Neon conectado
- **Artefatos:** Tabela `delivery_logs`, clients Evolution/Resend
- **Observabilidade:** Dashboard Inngest, query em `delivery_logs`

## 📝 Changelog

### v3.0.1 (2026-02-22)
- Integrado com Stack Omega v3.0 (Neon, Drizzle, Inngest)
- Adicionado schema `delivery_logs` completo
- Simplificada estrutura (ROUTER direto)
- Variáveis de ambiente documentadas
- Código clients otimizado para TypeScript strict

### v3.0.0 (Original)
- Protocolo omnichannel completo
- Clientes Evolution e Resend
- Workflow Inngest com fallback
- Matriz de decisão de canal
- Boas práticas de formatação
```

---

## 🔗 INTEGRAÇÃO COM O SISTEMA v3.1
**Roteamento:** Esta skill é invocada via .antigravity-os/[02] SQUAD_WRAPPERS/ ou Slash Commands.
**Memória:** Erros encontrados aqui devem ser logados em .antigravity-os/[04] MEMORY_DNA/.
**Budget:** Respeite os limites de .antigravity-os/[00] KERNEL/[02] token-budget-controller.json.
**Handoff:** Após execução, atualize context/CURRENT_AGENT.md e retorne ao THETA.

---
