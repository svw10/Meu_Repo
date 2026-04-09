/**
 * Orquestrador Multi-Agente com Inngest
 * 
 * ARQUITETURA: Blackboard Pattern
 * - Cada agente lê/escreve no "quadro negro" compartilhado (AgentThread.sharedContext)
 * - Steps são atômicos e retriable (Inngest garante exactly-once semantics)
 * - Handover assíncrono: Agente B só executa após validação do output do Agente A
 * 
 * RESILIENCE:
 * - Se um step falhar, Inngest tenta novamente com exponential backoff
 * - Estado persiste no Prisma (não perde contexto em caso de crash)
 * - Circuit breaker implícito (após N tentativas, marca thread como FAILED)
 */

import { inngest } from "@/app/api/inngest/client";
import { prisma } from "@/lib/prisma";
import {
    ResearchOutputSchema,
    ContentOutputSchema,
    ValidationOutputSchema,
    type ResearchOutput,
    type ContentOutput,
    type ValidationOutput,
} from "./schemas";

export const multiAgentHandover = inngest.createFunction(
    {
        id: "multi-agent-orchestrator",
        name: "Multi-Agent Workflow Handover",
        retries: 3, // Tentativas automáticas em caso de falha
    },
    { event: "agents/workflow.start" },
    async ({ event, step }) => {
        const { threadId, externalId, prompt, metadata } = event.data;

        // ========================================
        // STEP 0: Inicializar Thread (se nova)
        // ========================================
        const thread = await step.run("initialize-thread", async () => {
            const existing = await prisma.agentThread.findUnique({
                where: { id: threadId },
            });

            if (existing) return existing;

            return await prisma.agentThread.create({
                data: {
                    id: threadId,
                    externalId,
                    status: "BUSY",
                    sharedContext: { prompt, metadata },
                    messages: {
                        create: {
                            role: "system",
                            content: `Workflow iniciado para: ${prompt}`,
                            metadata: { timestamp: new Date().toISOString() },
                        },
                    },
                },
            });
        });

        // ========================================
        // STEP 1: AGENTE PESQUISADOR
        // ========================================
        const research = await step.run("research-phase", async () => {
            // SIMULAÇÃO: Em produção, aqui você chamaria OpenAI SDK
            // const completion = await openai.chat.completions.create({ ... });

            const rawData: ResearchOutput = {
                topic: prompt,
                findings: [
                    "Descoberta 1: Informação relevante sobre o tópico",
                    "Descoberta 2: Insights adicionais baseados em dados",
                    "Descoberta 3: Tendências atuais identificadas",
                ],
                sources: [
                    "https://example.com/source1",
                    "https://example.com/source2",
                ],
                confidenceScore: 0.85,
                timestamp: new Date().toISOString(),
            };

            // VALIDAÇÃO: Fail-fast se LLM retornar dados inválidos
            return ResearchOutputSchema.parse(rawData);
        });

        // ========================================
        // STEP 2: Persistir Resultado da Pesquisa
        // ========================================
        await step.run("persist-research", async () => {
            return await prisma.agentThread.update({
                where: { id: threadId },
                data: {
                    status: "RESEARCH_COMPLETED",
                    sharedContext: {
                        ...(thread.sharedContext as object),
                        research,
                    },
                    messages: {
                        create: {
                            role: "researcher",
                            content: `Pesquisa finalizada sobre: ${research.topic}`,
                            metadata: research,
                        },
                    },
                },
            });
        });

        // ========================================
        // STEP 3: AGENTE REDATOR (Consome output validado do Step 1)
        // ========================================
        const content = await step.run("writing-phase", async () => {
            // O Agente B tem acesso garantido ao output validado do Agente A
            const researchFindings = research.findings.join("\n- ");

            // SIMULAÇÃO: Em produção, passa findings para a LLM
            const rawContent: ContentOutput = {
                title: `Análise Completa: ${research.topic}`,
                body: `Com base na pesquisa realizada, identificamos:\n\n${researchFindings}\n\nConclusão: Os dados indicam alta relevância do tópico com score de confiança de ${research.confidenceScore}.`,
                tags: ["pesquisa", "análise", "insights"],
                wordCount: 120,
                metadata: {
                    tone: "professional",
                    targetAudience: "Técnico",
                },
            };

            // VALIDAÇÃO: Garante estrutura antes de passar ao validador
            return ContentOutputSchema.parse(rawContent);
        });

        // ========================================
        // STEP 4: Persistir Conteúdo Gerado
        // ========================================
        await step.run("persist-content", async () => {
            return await prisma.agentThread.update({
                where: { id: threadId },
                data: {
                    status: "WRITING_COMPLETED",
                    sharedContext: {
                        ...(thread.sharedContext as object),
                        research,
                        content,
                    },
                    messages: {
                        create: {
                            role: "writer",
                            content: `Conteúdo gerado: "${content.title}"`,
                            metadata: content,
                        },
                    },
                },
            });
        });

        // ========================================
        // STEP 5: AGENTE VALIDADOR (QA)
        // ========================================
        const validation = await step.run("validation-phase", async () => {
            // SIMULAÇÃO: Em produção, usa LLM para revisar qualidade
            const rawValidation: ValidationOutput = {
                isApproved: content.wordCount! >= 50, // Regra simples de exemplo
                issues: [],
                qualityScore: 92,
                feedback: "Conteúdo aprovado com alta qualidade estrutural.",
            };

            return ValidationOutputSchema.parse(rawValidation);
        });

        // ========================================
        // STEP 6: Finalizar Workflow
        // ========================================
        const finalThread = await step.run("finalize-workflow", async () => {
            return await prisma.agentThread.update({
                where: { id: threadId },
                data: {
                    status: validation.isApproved ? "COMPLETED" : "FAILED",
                    sharedContext: {
                        ...(thread.sharedContext as object),
                        research,
                        content,
                        validation,
                    },
                    messages: {
                        create: {
                            role: "validator",
                            content: validation.isApproved
                                ? "✅ Workflow concluído com sucesso"
                                : "❌ Workflow rejeitado na validação",
                            metadata: validation,
                        },
                    },
                },
            });
        });

        // ========================================
        // RETORNO FINAL (Para telemetria/dashboard)
        // ========================================
        return {
            success: validation.isApproved,
            threadId,
            outputs: {
                research,
                content,
                validation,
            },
            finalStatus: finalThread.status,
        };
    }
);
