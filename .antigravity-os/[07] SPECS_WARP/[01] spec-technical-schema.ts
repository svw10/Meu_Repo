import { z } from 'zod';

// ---------------------------------------------------------
// SCHEMA DE VALIDAÇÃO TÉCNICA (Zod)
// Garante que a SPEC esteja completa, tipada e pronta para o GAMMA codar.
// ---------------------------------------------------------

// 1. Critérios de Aceite (Vinculados ao PRD)
export const AcceptanceCriterionSchema = z.object({
  id: z.string().describe("ID único (ex: AC-001)"),
  scenario: z.string().describe("Descrição do cenário (Gherkin ou direto)"),
  type: z.enum(['functional', 'security', 'performance', 'edge_case']),
  automated_test: z.boolean().describe("Se deve gerar teste automatizado"),
  status: z.enum(['pending', 'validated', 'failed']).default('pending')
});

// 2. Alterações de Arquivo (Mapeamento Técnico)
export const FileChangeSchema = z.object({
  path: z.string().describe("Caminho relativo (ex: src/app/auth/route.ts)"),
  action: z.enum(['create', 'update', 'delete', 'move']),
  description: z.string().describe("Resumo técnico da alteração"),
  dependencies: z.array(z.string()).optional().describe("Arquivos impactados")
});

// 3. Sprint Técnica (Unidade de Execução)
export const SprintSchema = z.object({
  id: z.string(),
  title: z.string(),
  description: z.string(),
  estimated_tokens: z.number().min(500).max(15000).describe("Budget de tokens para esta sprint"),
  files: z.array(FileChangeSchema),
  acceptance_criteria: z.array(AcceptanceCriterionSchema).min(1),
  agent_assigned: z.enum(['GAMMA', 'DELTA', 'ETA']).default('GAMMA'),
  status: z.enum(['queued', 'in_progress', 'review', 'done']).default('queued')
});

// 4. Schema Raiz da SPEC Técnica
export const SpecTechnicalSchema = z.object({
  version: z.literal('1.0'),
  project_name: z.string(),
  linked_prd_id: z.string().describe("ID do PRD aprovado (obrigatório)"),
  stack: z.array(z.string()).describe("Stack obrigatória (ex: Next.js 14, Prisma, Tailwind)"),
  global_constraints: z.object({
    max_context_tokens: z.number().default(8000),
    security_rules: z.array(z.string()),
    performance_targets: z.array(z.string())
  }),
  sprints: z.array(SprintSchema).min(1).describe("Divisão obrigatória em sprints atômicas"),
  created_at: z.string().datetime(),
  approved_by: z.string().describe("Agente ou humano responsável")
});

export type SpecTechnical = z.infer<typeof SpecTechnicalSchema>;

// ---------------------------------------------------------
// INSTRUÇÃO DE EXECUÇÃO PARA A IA
// ---------------------------------------------------------
/*
1. Antes de gerar código, valide os dados da SPEC contra `SpecTechnicalSchema`.
2. Se inválido (ex: sem sprints ou sem linked_prd_id), solicite correção ao BETA (Arquiteto).
3. Só permita execução do GAMMA se `sprints.length > 0` e o budget de cada sprint estiver dentro de `.antigravity-os/[00] KERNEL/[02] token-budget-controller.json`.
4. Atualize o status das sprints conforme a entrega avança.
*/
