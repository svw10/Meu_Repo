### 📂 Estrutura de Diretórios

```text
Minhas Skills/
└── comunicando-externo/
    ├── SKILL.md
    ├── snippets/
    │   ├── evolution_whatsapp.ts  # Cliente para Evolution API
    │   ├── resend_email.ts        # Cliente para Resend
    │   └── inngest_notify.ts      # Workflow à prova de falhas
    └── resources/
        └── templates_mensagens.md



### 1. O Cérebro (`Minhas Skills/comunicando-externo/SKILL.md`)


---
name: comunicando-externo
description: O Mensageiro. Gerencia toda comunicação de saída (Outbound) via WhatsApp (Evolution API) e Email (Resend). Implementa filas de retentativa via Inngest para garantir entrega.
version: 1.0.0
tags: [whatsapp, email, notification, evolution-api, resend]
---

# Comunicando Externo (Omnichannel Protocol)

## 🎯 Quando usar
- **Notificações de Sistema**: "Avise o usuário que o relatório está pronto".
- **Marketing/Engajamento**: Enviar newsletter ou follow-up de vendas.
- **Alertas de Erro**: O sistema caiu? Mande um Zap para o admin.

## 🧱 Stack Vinculada
Esta skill abstrai a complexidade destas APIs:

| Canal | Ferramenta | Uso Típico |
| :--- | :--- | :--- |
| **WhatsApp** | Evolution API v2 | Mensagens rápidas, áudios, alertas urgentes. |
| **Email** | Resend | Relatórios, Magic Links, conteúdo longo. |
| **Fila** | Inngest | Garante que a mensagem chegue mesmo se a API piscar. |

## ⚙️ Fluxo de Trabalho

- [ ] **1. Escolha do Canal**
    - Urgente/Curto? -> WhatsApp.
    - Formal/Longo/Anexo? -> Email.

- [ ] **2. Sanitização**
    - Email: Validar formato regex.
    - WhatsApp: Remover caracteres inválidos do telefone (apenas números + DDI).

- [ ] **3. Despacho via Inngest (Crucial)**
    - **NUNCA** chame a API direto no frontend ou em um loop síncrono.
    - Dispare um evento `app/notify.send` para o Inngest.
    - O Inngest gerencia retries (backoff exponencial) se a Evolution API der timeout.

## 📋 Checklist de Template
- [ ] O texto do WhatsApp usa formatação correta? (`*bold*`, `_italic_`).
- [ ] O Email tem um Assunto claro?
- [ ] As variáveis `{{nome}}` foram substituídas?

## 💻 Snippets e Recursos

### Snippet 1: Disparo Seguro (Server Action)
```typescript
import { inngest } from "@/inngest/client";

// Use isso no seu código ao invés de chamar a API direto
await inngest.send({
  name: "app/notify.send",
  data: {
    channel: "whatsapp", // ou "email"
    to: "5511999999999",
    content: "Olá! Seu relatório ficou pronto.",
  },
});



### 2. Snippets de Produção (Código Real)

Copie estes arquivos para a pasta `snippets/` da skill. Eles são a implementação de referência para sua stack.

#### `snippets/evolution_whatsapp.ts` (O Wrapper da API)
```typescript
// Utils para falar com sua instância da Evolution API
const EVO_URL = process.env.EVOLUTION_API_URL; // ex: https://evo.minhia.com.br
const EVO_KEY = process.env.EVOLUTION_API_KEY;

export async function sendWhatsAppText(phone: string, text: string) {
  const url = `${EVO_URL}/message/sendText/seu_instance_name`;
  
  const response = await fetch(url, {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      "apikey": EVO_KEY!
    },
    body: JSON.stringify({
      number: phone,
      options: {
        delay: 1200,
        presence: "composing",
        linkPreview: true
      },
      textMessage: {
        text: text
      }
    })
  });

  if (!response.ok) {
    throw new Error(`Erro Evolution API: ${response.statusText}`);
  }

  return response.json();
}



#### `snippets/resend_email.ts` (O Wrapper do Email)


import { Resend } from 'resend';

const resend = new Resend(process.env.RESEND_API_KEY);

export async function sendEmail(to: string, subject: string, html: string) {
  const { data, error } = await resend.emails.send({
    from: 'Seu App <nao-responda@seu-dominio.com>',
    to: [to],
    subject: subject,
    html: html,
  });

  if (error) {
    throw new Error(`Erro Resend: ${error.message}`);
  }

  return data;
}


#### `snippets/inngest_notify.ts` (O Motor de Retentativa)

Este é o arquivo mais importante. Ele garante que seu sistema é resiliente.

import { inngest } from "@/inngest/client";
import { sendWhatsAppText } from "./evolution_whatsapp";
import { sendEmail } from "./resend_email";

export const notifyWorkflow = inngest.createFunction(
  { id: "system-notification-sender" },
  { event: "app/notify.send" },
  async ({ event, step }) => {
    
    const { channel, to, content, subject } = event.data;

    // Passo 1: Enviar mensagem
    await step.run("send-message-api", async () => {
      if (channel === "whatsapp") {
        return await sendWhatsAppText(to, content);
      } 
      
      if (channel === "email") {
        if (!subject) throw new Error("Email requer assunto");
        return await sendEmail(to, subject, content); // content aqui é HTML
      }
    });

    // Passo 2: Logar sucesso (opcional, pode salvar no Neon)
    return { status: "sent", channel, timestamp: new Date() };
  }
);

