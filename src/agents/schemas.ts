/**
 * Contratos Zod para Validação de Outputs de Agentes
 * 
 * PRINCÍPIO: Cada agente valida seu output antes de passar ao próximo (fail-fast).
 * Isso previne propagação de dados inválidos no pipeline multi-agente.
 * 
 * Anti-hallucination: Forçar estrutura de dados impede outputs aleatórios da LLM.
 */

import { z } from "zod";

// ===========================
// AGENTE PESQUISADOR (Research Agent)
// ===========================
export const ResearchOutputSchema = z.object({
    topic: z.string().min(3, "Tópico deve ter no mínimo 3 caracteres"),
    findings: z.array(z.string()).min(1, "Pelo menos 1 descoberta é obrigatória"),
    sources: z.array(z.string().url("Deve ser uma URL válida")),
    confidenceScore: z
        .number()
        .min(0, "Score mínimo: 0")
        .max(1, "Score máximo: 1"),
    timestamp: z.string().datetime().optional(),
});

export type ResearchOutput = z.infer<typeof ResearchOutputSchema>;

// ===========================
// AGENTE REDATOR (Content Writer Agent)
// ===========================
export const ContentOutputSchema = z.object({
    title: z.string().min(5, "Título muito curto"),
    body: z.string().min(50, "Conteúdo deve ter no mínimo 50 caracteres"),
    tags: z.array(z.string()).max(10, "Máximo de 10 tags"),
    wordCount: z.number().int().positive().optional(),
    nextSteps: z.string().optional(),
    metadata: z
        .object({
            tone: z.enum(["professional", "casual", "technical"]).optional(),
            targetAudience: z.string().optional(),
        })
        .optional(),
});

export type ContentOutput = z.infer<typeof ContentOutputSchema>;

// ===========================
// AGENTE VALIDADOR (Quality Assurance Agent)
// ===========================
export const ValidationOutputSchema = z.object({
    isApproved: z.boolean(),
    issues: z.array(
        z.object({
            type: z.enum(["grammar", "factuality", "tone", "structure", "seo"]),
            severity: z.enum(["low", "medium", "high", "critical"]),
            description: z.string(),
            suggestedFix: z.string().optional(),
        })
    ),
    qualityScore: z.number().min(0).max(100),
    feedback: z.string().optional(),
});

export type ValidationOutput = z.infer<typeof ValidationOutputSchema>;

// ===========================
// ORQUESTRADOR (Para consolidar status de toda a thread)
// ===========================
export const WorkflowStatusSchema = z.object({
    threadId: z.string().cuid(),
    currentPhase: z.enum([
        "IDLE",
        "RESEARCH",
        "WRITING",
        "VALIDATION",
        "COMPLETED",
        "FAILED",
    ]),
    progress: z.number().min(0).max(100),
    outputs: z.object({
        research: ResearchOutputSchema.optional(),
        content: ContentOutputSchema.optional(),
        validation: ValidationOutputSchema.optional(),
    }),
    errorMessage: z.string().optional(),
});

export type WorkflowStatus = z.infer<typeof WorkflowStatusSchema>;
