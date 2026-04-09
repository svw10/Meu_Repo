# [00] PRD BUSINESS TEMPLATE — Documento de Requisitos de Produto

## ⚠️ Regra de Ouro: Foco Exclusivo no Negócio
Este documento **NÃO deve conter código, nomes de tabelas, endpoints ou decisões de stack**.
Seu objetivo é definir **O QUE** será feito e **POR QUE**, validado pelo Agente BETA (Arquiteto) antes de passar para a SPEC Técnica (GAMMA).

---

## 1. Visão Geral do Produto
- **Problema:** Qual dor do usuário ou lacuna de mercado estamos resolvendo?
- **Objetivo:** O que define o sucesso deste produto/feature?
- **Público-Alvo:** Quem são os usuários finais? (Personas principais)
- **Integração:** Relacionado a `Nucleo/FABRICA_SOFTWARE.md` e `Minhas_Skills/ESTRATEGIA_DISCOVERY/`.

## 2. Regras de Negócio Críticas
- Liste apenas restrições funcionais (ex: "Usuário free não pode exportar relatórios", "Pagamento deve ser confirmado em até 5min").
- Defina prioridades: [MoSCoW: Must have, Should have, Could have, Won't have].

## 3. User Stories & Fluxos Principais
- Use o formato: "Como [perfil], eu quero [ação], para que [benefício]."
- Descreva o fluxo ideal (Caminho Feliz) e fluxos alternativos (ex: recuperação de senha, cancelamento).

## 4. Critérios de Aceite (Formato BDD/Gherkin)
A IA deve validar a implementação contra estes cenários:
```gherkin
Cenário: [Nome do Cenário]
  Dado que [condição inicial]
  Quando [ação do usuário]
  Então [resultado esperado]
  E [validação secundária]
```