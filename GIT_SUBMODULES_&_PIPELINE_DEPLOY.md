# 📘 GUIA OPERACIONAL: GIT SUBMODULES & PIPELINE DEPLOY

Este documento detalha o fluxo de trabalho para utilização do **Template Antigravity** como motor de inteligência em novos projetos (LPs e SaaS) via Git Submodules.

## 1. O CONCEITO (A "Caixa Preta")

Em vez de copiar e colar os arquivos do `Template_Antigravity` para dentro do projeto novo, criamos um "túnel" (link simbólico).

* **No seu computador:** Você vê a pasta com os arquivos (`Minhas Skills`, `Agentes`, etc.).
* **No GitHub:** Ele vê apenas um "ponteiro" (um link) dizendo: *"Este projeto usa a versão X do Template Antigravity"*.

## 2. CONFIGURAÇÃO INICIAL (Apenas na criação do projeto)

Para conectar o cérebro (Template) ao corpo (Novo Projeto):

```bash
# Na raiz do novo projeto (ex: ponto-do-craque)
git submodule add https://github.com/SEU_USUARIO/Template_Antigravity.git antigravity_core

```

Isso cria a pasta `antigravity_core` e o arquivo oculto `.gitmodules`.

## 3. O FLUXO DE TRABALHO (Dia a Dia)

O ciclo de desenvolvimento e backup funciona assim:

1. **Codificação:** O Antigravity lê as regras dentro de `antigravity_core` e gera código na raiz do projeto (ex: na pasta `LP/` ou `src/`).
2. **Commit & Backup:** Você commita as alterações do projeto normalmente.
```bash
git add .
git commit -m "feat: nova seção hero"

```


3. **Envio (Push):** Ao enviar para o GitHub, você está enviando o código do projeto **+** a referência de qual versão do Template foi usada.
```bash
git push origin main

```


4. **Deploy Automático:** O Vercel detecta o push no GitHub, baixa o projeto, lê o arquivo `.gitmodules`, baixa o conteúdo do Template e compila o site.

## 4. ⚠️ A REGRA DE OURO (Trava de Segurança)

**JAMAIS atualize a inteligência de dentro do projeto filho.**

### 🚫 O QUE NÃO FAZER (Risco de Quebra):

* Entrar na pasta `antigravity_core` dentro do projeto `ponto-do-craque`.
* Editar um arquivo de regra ou skill ali dentro.
* Tentar dar commit nessa pasta interna.
* **Consequência:** Isso cria um "Detached HEAD" (cabeça desconectada), desincroniza os repositórios e pode travar o deploy no Vercel.

### ✅ O JEITO CERTO (Fluxo de Evolução):

Se você percebeu que precisa melhorar uma Skill ou Regra do Antigravity:

1. Feche o projeto atual.
2. Abra o projeto **Template_Antigravity** original separadamente.
3. Faça a melhoria, commit e push lá (`Template_Antigravity`).
4. Volte para o projeto filho (`ponto-do-craque`) e atualize a referência:
```bash
cd antigravity_core
git pull origin main
cd ..
git add antigravity_core
git commit -m "chore: atualiza núcleo do antigravity"
git push

```



---

## RESUMO TÉCNICO PARA O GEM

| Ação | Onde Executar? | Comando/Ação |
| --- | --- | --- |
| **Criar Projeto** | Novo Repo | `git submodule add [URL_TEMPLATE]` |
| **Codar Site/App** | Novo Repo | Edição normal nas pastas `src` ou `LP` |
| **Backup/Versionar** | Novo Repo | `git push origin main` |
| **Deploy** | Automático | Vercel monitora o GitHub e faz o build |
| **Editar Regras/Skills** | **REPO DO TEMPLATE** | Editar no original -> Push no original |
| **Atualizar Inteligência** | Novo Repo | `git pull` dentro da pasta do submodule |