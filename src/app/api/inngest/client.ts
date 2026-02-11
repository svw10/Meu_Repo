/**
 * Cliente Inngest - Configuração Central
 * 
 * O Inngest atua como orquestrador de filas assíncronas para handover de agentes.
 * Vantagens sobre implementação manual:
 * - Retry automático com exponential backoff
 * - Persistência de estado entre steps
 * - Observabilidade via dashboard oficial
 * - Anti-vendor lock-in (easy migration para BullMQ/Temporal se necessário)
 */

import { Inngest } from "inngest";

export const inngest = new Inngest({
    id: "meu-repo-agents",
    name: "Multi-Agent Orchestrator",
    eventKey: process.env.INNGEST_EVENT_KEY,
});

// ===========================
// TIPOS DE EVENTOS (Type-safe event triggers)
// ===========================
export type InngestEvents = {
    "agents/workflow.start": {
        data: {
            threadId: string;
            externalId: string;
            prompt: string;
            metadata?: Record<string, unknown>;
        };
    };
    "agents/research.completed": {
        data: {
            threadId: string;
            findings: string[];
        };
    };
    "agents/writing.completed": {
        data: {
            threadId: string;
            content: string;
        };
    };
    "agents/validation.completed": {
        data: {
            threadId: string;
            isApproved: boolean;
        };
    };
};
