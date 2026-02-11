# NEURO SEMANTIC ROUTER (AGENTE DE ROTEAMENTO)
> **FUNÇÃO:** Este documento serve como mapa de decisão para o Agente THETA.
> **USO:** Consulte esta tabela para converter a "Intenção do Usuário" no "Agente Especialista" correto.

---

## 🧭 TABELA DE ROTEAMENTO (INTENÇÃO -> AGENTE)

| INTENÇÃO DO USUÁRIO (O que ele quer?) | PALAVRAS-CHAVE (Gatilhos) | AGENTE DESTINO (Quem resolve?) | COMPETÊNCIA FÍSICA (Onde ler?) |
| :--- | :--- | :--- | :--- |
| **Criar Projeto do Zero** | `Novo`, `Criar`, `Iniciar`, `Setup`, `Bootstrap` | **ALPHA (Genesis)** | `Agentes\ALPHA_Genesis.md` |
| **Planejar Arquitetura** | `Planejar`, `Estrutura`, `Banco de Dados`, `Schema` | **BETA (Architect)** | `Agentes\BETA_Architect.md` |
| **Escrever Código / UI** | `Codar`, `Criar tela`, `Componente`, `API`, `Script` | **GAMMA (Builder)** | `Agentes\GAMMA_Builder.md` |
| **Revisar / Validar** | `Revisar`, `Auditar`, `Validar`, `Check` | **DELTA (Auditor)** | `Agentes\DELTA_Auditor.md` |
| **Estratégia / SEO** | `Ideia`, `Mercado`, `SEO`, `Growth`, `Ranking` | **EPSILON (Growth)** | `Agentes\EPSILON_Growth.md` |
| **Otimizar / Performance** | `Lento`, `Otimizar`, `Melhorar`, `Refatorar` | **ZETA (Optimizer)** | `Agentes\ZETA_Optimizer.md` |
| **Corrigir Erro / Bug** | `Erro`, `Bug`, `Quebrou`, `Falha`, `Não funciona` | **ETA (Investigator)** | `Agentes\ETA_Investigator.md` |
| **Orquestrar / Gerenciar** | `Status`, `Quem faz o que?`, `Ajuda`, `Contexto` | **THETA (Orchestrator)** | `Agentes\THETA_Orchestrator.md` |

---

## 🚨 REGRAS DE CONFLITO
Se a intenção do usuário parecer misturada (ex: "Planeje e crie uma tela"):

1.  **Prioridade 1:** O Planejamento (BETA) vem sempre antes da Execução (GAMMA).
2.  **Prioridade 2:** A Correção (ETA) vem sempre antes da Otimização (ZETA).
3.  **Ação do Roteador:** Quebre o pedido em passos. Chame o primeiro agente, espere, depois chame o segundo.

---

## 🗺️ MAPEAMENTO DE PASTAS FÍSICAS (CRÍTICO)
Se o Agente selecionado precisar de recursos, aponte para estes caminhos reais:

* **Skills:** `C:\projetos\Antigravity\Minhas Skills\`
* **Regras:** `C:\projetos\Antigravity\Minhas_Rules\`
* **Snippets:** `C:\projetos\Antigravity\Snippets\`
* **Terraform:** `C:\projetos\Antigravity\terraform\`

---

**FIM DO ROTEAMENTO.**