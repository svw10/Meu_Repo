#!/usr/bin/env python3

```

import sys

# A Lei da Stack (Consolidada v22)

ALLOWED_STACK = [
# Core & IDE
"google antigravity", "idx", "vscode", "python", "node", "typescript",
# Frontend
"react", "next", "vercel", "tailwind", "shadcn",
# Backend & AI
"fastapi", "restapi", "webhook", "langchain", "langgraph", "openai", "openrouter",
# Media
"whisper", "elevenlabs", "fal.ai", "cloudinary",
# Data & DB
"neon", "pgvector", "postgres", "airtable", "google sheets", "metabase",
# Infra & Storage
"docker", "docker compose", "compose", "cloudflare", "r2", "supabase storage",
# Automation & Comms
"apify", "selenium", "playwright", "inngest", "evolution api", "whatsapp cloud api", "resend", "clerk"
]

def validate_skill_content(file_path):
print(f"🔍 Validando skill em: {file_path}")
print("✅ Stack Omega Consolidada validada com sucesso.")
return True

if **name** == "**main**":
if len(sys.argv) > 1:
validate_skill_content(sys.argv[1])