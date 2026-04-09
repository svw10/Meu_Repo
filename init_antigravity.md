import os
import argparse
import shutil
from pathlib import Path
from datetime import datetime

# ============================================================
# CONFIGURAÇÃO - 12 SKILLS v3.0.2 FINAL
# ============================================================

SKILLS_STRUCTURE = {
    "CORE": [
        "00_index_skills.md",
        "12_usando_skills.md"
    ],
    "ESTRATEGIA_DISCOVERY": [
        "01_brainstorming.md",
        "02_planejando_solucoes.md",
        "08_explorando_mercados.md"
    ],
    "EXECUCAO_IMPLEMENTACAO": [
        "03_executando_planos.md",
        "06_codando.md",
        "07_comunicando_externo.md"
    ],
    "QUALIDADE_DEBUG": [
        "04_solucionando_erros.md",
        "05_verificando_conclusao.md"
    ],
    "DOMINIO_ECOMMERCE": [
        "09_gerenciando_memoria.md"
    ],
    "DOMINIO_IA": [
        "10_llm_app_blueprint.md",
        "11_pesquisando_web.md"
    ]
}

# Templates mínimos para cada skill (conteúdo inicial)
SKILL_TEMPLATES = {
    "00_index_skills.md": """---
name: index-skills
description: Kernel Universal v3.0. Índice Canônico das 12 skills do Antigravity OS.
version: 3.0.2
tags: [core, kernel, router, sistema, indice, arquitetura]
---

# 00 - INDEX SKILLS (Kernel Universal v3.0.2)

> ⚠️ **ATENÇÃO**: Este é o índice canônico. Para uso, consulte `12_usando_skills.md`.

## Índice Rápido (12 Skills)

| # | Skill | Camada | Propósito |
|---|-------|--------|-----------|
| 00 | index-skills | CORE | Kernel central |
| 01 | brainstorming | 1 | Discovery de produto |
| 02 | planejando-solucoes | 1 | Arquitetura técnica |
| 03 | executando-planos | 2 | Build Loop |
| 04 | solucionando-erros | 3 | Debug |
| 05 | verificando-conclusao | 3 | QA |
| 06 | codando | 2 | Padrões de código |
| 07 | comunicando-externo | 2 | Comunicação |
| 08 | explorando-mercados | 1 | Validação de mercado |
| 09 | gerenciando-memoria | 4 | RAG/E-commerce |
| 10 | llm-app-blueprint | 4 | Arquitetura LLM |
| 11 | pesquisando-web | 4 | Research |
| 12 | usando-skills | CORE | Entry point |

## Entry Point Universal

Toda interação começa em: `12_usando_skills.md`
""",

    "12_usando_skills.md": """---
name: usando-skills
description: Supervisor Universal. Entry point obrigatório para qualquer interação.
version: 3.0.1
tags: [core, meta, supervisor, router, consciencia, entry-point]
---

# 12 - USANDO SKILLS (Consciousness Protocol)

## 🎯 Regra Absoluta
**NUNCA execute sem skill.** Toda ação deve usar uma skill especializada.

## ⚙️ Fluxo (4 Passos)

1. **Pausa Tática**: Analise Verbo + Objeto + Contexto
2. **Consulta Kernel**: Verifique `00_index_skills.md`
3. **Roteamento**:
   - **A**: Skill existe → Execute
   - **B**: Skill não existe → Use `01_brainstorming` ou `02_planejando_solucoes`
4. **Registro**: Log de auditoria obrigatório

## 🗺️ Mapeamento Rápido

| Intenção | Skill | Camada |
|----------|-------|--------|
| "Tenho ideia..." | 01_brainstorming | 1 |
| "Planeje..." | 02_planejando_solucoes | 1 |
| "Execute..." | 03_executando_planos | 2 |
| "Deu erro..." | 04_solucionando_erros | 3 |
| "Verifique..." | 05_verificando_conclusao | 3 |
| "Crie UI..." | 06_codando | 2 |
| "Notifique..." | 07_comunicando_externo | 2 |
| "Mercado..." | 08_explorando_mercados | 1 |
| "RAG/Memória..." | 09_gerenciando_memoria | 4 |
| "LLM/IA..." | 10_llm_app_blueprint | 4 |
| "Pesquise..." | 11_pesquisando_web | 4 |

## Stack Omega v3.0
Next.js 14+ | Neon | Inngest | Clerk | OpenRouter | Tailwind | Shadcn
"""
}

# Pastas auxiliares (vazias inicialmente, mas necessárias)
AUXILIARY_FOLDERS = [
    "docs",
    "scripts",
    "templates",
    "assets",
    "tests"
]

# Arquivos de configuração na raiz
CONFIG_FILES = {
    "CURRENT_AGENT.md": """# CURRENT_AGENT.md
# Contexto do Projeto Atual
# Última atualização: {timestamp}

project_name: "NomeDoProjeto"
project_type: "saas_b2b"  # ou: api, mobile, cli, automation
stack: ["nextjs", "neon", "inngest", "clerk", "openrouter"]
primary_domain: "ecommerce"  # ou: automation, content, saas_generic
current_phase: "discovery"  # discovery, planning, build, debug, deploy
active_skills: ["01_brainstorming"]
next_actions: ["Definir escopo inicial"]

# Notas:
# - Este arquivo é atualizado automaticamente pelas skills
# - Nunca edite manualmente durante execução
""",

    ".gitignore": """# Antigravity OS v3.0
# Ignorar arquivos sensíveis e temporários

# Ambiente
.env
.env.local
.env.*.local

# Dependências
node_modules/
__pycache__/
*.pyc
.venv/
venv/

# Logs
logs/
*.log
npm-debug.log*

# Sistema
.DS_Store
Thumbs.db

# IDEs
.idea/
.vscode/
*.swp
*.swo

# Build
dist/
build/
.next/
out/

# Dados sensíveis (exceto templates)
data/private/
secrets/
""",

    "README.md": """# {project_name}

Projeto criado com **Antigravity OS v3.0.2**

## Estrutura de Skills
Minhas_Skills/
├── CORE/                    # Kernel + Supervisor
├── ESTRATEGIA_DISCOVERY/    # Camada 1: Discovery
├── EXECUCAO_IMPLEMENTACAO/  # Camada 2: Build
├── QUALIDADE_DEBUG/         # Camada 3: QA
├── DOMINIO_ECOMMERCE/       # Camada 4: E-commerce
└── DOMINIO_IA/              # Camada 4: IA/LLM
plain
Copy

## Como Usar

1. **Sempre comece com**: `Minhas_Skills/CORE/12_usando_skills.md`
2. **Consulte o índice**: `Minhas_Skills/CORE/00_index_skills.md`
3. **Siga o fluxo**: Entry → Discovery → Build → QA → Deploy

## Stack Omega v3.0

- **Frontend**: Next.js 14+ (App Router) + Tailwind + Shadcn
- **Backend**: Next.js API Routes / Server Actions
- **Database**: Neon PostgreSQL + Drizzle ORM
- **Queues**: Inngest
- **Auth**: Clerk
- **AI**: OpenRouter (multi-provider)
- **Comms**: Evolution API + Resend

## Comandos Úteis

```bash
# Verificar estrutura de skills
ls -la Minhas_Skills/CORE/

# Atualizar contexto do agente
echo "project_name: MeuProjeto" > CURRENT_AGENT.md
Gerado em: {timestamp}
"""
}
def create_directory_structure(base_path: Path, force: bool = False):
"""Cria toda a estrutura de diretórios e arquivos."""
plain
Copy
print(f"🚀 Inicializando Antigravity OS v3.0.2 em: {base_path}")
print("=" * 60)

# Criar pasta base se não existir
base_path.mkdir(parents=True, exist_ok=True)

# Criar pasta Minhas_Skills
skills_root = base_path / "Minhas_Skills"

if skills_root.exists() and not force:
    print(f"⚠️  Diretório já existe: {skills_root}")
    response = input("Sobrescrever? (s/N): ")
    if response.lower() != 's':
        print("❌ Cancelado.")
        return False
    
    # Backup se forçar
    backup_path = base_path / f"Minhas_Skills_backup_{datetime.now().strftime('%Y%m%d_%H%M%S')}"
    shutil.move(skills_root, backup_path)
    print(f"💾 Backup criado: {backup_path}")

# Criar estrutura de skills
total_files = 0
for folder, files in SKILLS_STRUCTURE.items():
    folder_path = skills_root / folder
    folder_path.mkdir(parents=True, exist_ok=True)
    print(f"📁 {folder}/")
    
    for filename in files:
        file_path = folder_path / filename
        
        # Usar template se disponível, senão criar vazio com header
        if filename in SKILL_TEMPLATES:
            content = SKILL_TEMPLATES[filename]
        else:
            skill_name = filename.replace('.md', '').replace('_', ' ').title()
            content = f"""---
name: {filename.replace('.md', '')} description: Skill {skill_name} do Antigravity OS version: 3.0.0 tags: [skill]
{filename.replace('.md', '').replace('_', ' ').upper()}
🚧 EM DESENVOLVIMENTO: Esta skill precisa ser completada.
Consulte o template completo em: 00_index_skills.md
🎯 Quando usar
[Definir contexto de uso]
⚙️ Checklist
[ ] Item 1
[ ] Item 2
📝 Notas
Adicionar conteúdo específico da skill aqui.
"""
plain
Copy
        with open(file_path, 'w', encoding='utf-8') as f:
            f.write(content)
        
        print(f"   └─ {filename}")
        total_files += 1

# Criar pastas auxiliares
print("\n📂 Pastas auxiliares:")
for folder in AUXILIARY_FOLDERS:
    folder_path = base_path / folder
    folder_path.mkdir(exist_ok=True)
    # Criar .gitkeep para manter no git
    (folder_path / ".gitkeep").touch()
    print(f"   └─ {folder}/")

# Criar arquivos de configuração
print("\n⚙️  Arquivos de configuração:")
timestamp = datetime.now().isoformat()

for filename, template in CONFIG_FILES.items():
    file_path = base_path / filename
    content = template.format(
        timestamp=timestamp,
        project_name=base_path.name
    )
    
    # Não sobrescrever se já existir (exceto se --force)
    if file_path.exists() and not force:
        print(f"   ⏭️  {filename} (já existe)")
        continue
        
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)
    print(f"   ✓ {filename}")

# Criar arquivo de verificação
verify_file = base_path / ".antigravity_v3"
with open(verify_file, 'w') as f:
    f.write(f"Antigravity OS v3.0.2\nCreated: {timestamp}\n")

print("\n" + "=" * 60)
print(f"✅ Estrutura criada com sucesso!")
print(f"📊 Total de skills: {total_files}")
print(f"📍 Local: {base_path.absolute()}")
print("\n🎯 Próximos passos:")
print("   1. Edite CURRENT_AGENT.md com dados do seu projeto")
print("   2. Comece em: Minhas_Skills/CORE/12_usando_skills.md")
print("   3. Siga o fluxo: Discovery → Build → QA")

return True
def validate_structure(base_path: Path):
"""Valida se a estrutura está completa."""
print(f"\n🔍 Validando estrutura em: {base_path}")
plain
Copy
skills_root = base_path / "Minhas_Skills"
if not skills_root.exists():
    print("❌ Pasta Minhas_Skills não encontrada")
    return False

missing = []
for folder, files in SKILLS_STRUCTURE.items():
    folder_path = skills_root / folder
    if not folder_path.exists():
        missing.append(f"Pasta: {folder}")
        continue
    
    for filename in files:
        file_path = folder_path / filename
        if not file_path.exists():
            missing.append(f"Arquivo: {folder}/{filename}")

if missing:
    print("❌ Itens faltantes:")
    for item in missing:
        print(f"   - {item}")
    return False

print("✅ Estrutura válida! Todas as 12 skills presentes.")
return True
def main():
parser = argparse.ArgumentParser(
description="Inicializa estrutura Antigravity OS v3.0.2"
)
parser.add_argument(
"--path",
default=".",
help="Caminho base para criação (padrão: atual)"
)
parser.add_argument(
"--force",
action="store_true",
help="Sobrescreve estrutura existente"
)
parser.add_argument(
"--validate",
action="store_true",
help="Apenas valida estrutura existente"
)
plain
Copy
args = parser.parse_args()
base_path = Path(args.path).resolve()

if args.validate:
    validate_structure(base_path)
else:
    create_directory_structure(base_path, args.force)
if name == "main":
main()
plain
Copy

---

## 3. RESOLUÇÃO DAS PASTAS VAZIAS

As pastas auxiliares são **necessárias** mas podem começar vazias. Aqui está a política:

| Pasta | Propósito | Estado Inicial | Conteúdo Futuro |
|-------|-----------|----------------|-----------------|
| `docs/` | Documentação do projeto | Vazia (apenas `.gitkeep`) | ADRs, diagramas, specs |
| `scripts/` | Automações | Vazia (apenas `.gitkeep`) | Deploy, backups, migrações |
| `templates/` | Templates reutilizáveis | Vazia (apenas `.gitkeep`) | Emails, componentes base |
| `assets/` | Assets estáticos | Vazia (apenas `.gitkeep`) | Imagens, logos, ícones |
| `tests/` | Testes automatizados | Vazia (apenas `.gitkeep`) | Unit, integration, e2e |

**Decisão**: ✅ **Manter pastas vazias com `.gitkeep`** - Isso é padrão Git para preservar estrutura.

---

## 4. CHECKLIST FINAL v3.0.2

- [x] **Kernel** (`00_index_skills.md`) atualizado com 12 skills
- [x] **Supervisor** (`12_usando_skills.md`) como entry point
- [x] **Script de boot** (`init_antigravity_v3.py`) com estrutura completa
- [x] **Pastas auxiliares** definidas (docs, scripts, templates, assets, tests)
- [x] **Arquivos de configuração** (`CURRENT_AGENT.md`, `.gitignore`, `README.md`)
- [x] **Versionamento** consistente (v3.0.2 para sistema, v3.0.1 para supervisor)
- [x] **Matriz de dependências** documentada
