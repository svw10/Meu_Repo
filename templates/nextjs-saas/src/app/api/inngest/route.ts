/**
 * Rota API do Inngest - Next.js App Router
 * 
 * Esta rota expõe 3 métodos HTTP para o Inngest:
 * - GET: Health check
 * - POST: Recebe eventos e dispara funções
 * - PUT: Atualiza configuração (usado pelo Inngest Cloud)
 * 
 * SEGURANÇA:
 * - Validação de assinatura via INNGEST_SIGNING_KEY (previne spoofing)
 * - Rate limiting é gerenciado pelo próprio Inngest
 * - Em produção, adicione IP whitelisting se necessário
 */

import { serve } from "inngest/next";
import { inngest } from "./client";
import { multiAgentHandover } from "@/agents/orchestrator";

// Registre todas as funções de agentes aqui
export const { GET, POST, PUT } = serve({
    client: inngest,
    functions: [
        multiAgentHandover,
        // Adicione novas funções aqui conforme criar novos agentes
        // Exemplo: emailNotificationAgent, slackNotificationAgent, etc.
    ],
    signingKey: process.env.INNGEST_SIGNING_KEY,
});
