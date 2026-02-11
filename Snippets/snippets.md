import os

# Antigravity OS - Pillar 3: SNIPPETS (Industrial Grade v2.0)
# Código atômico, observável e resiliente para a Stack Omega.

def write_snippet(path, content):
    full_path = os.path.join("snippets", path)
    directory = os.path.dirname(full_path)
    
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"📁 Dir criado: {directory}")
    
    with open(full_path, "w", encoding="utf-8") as f:
        f.write(content.strip())
    print(f"🧩 Snippet forjado: {full_path}")

def create_snippets_v2():
    print("🏭 Industrializando o Código (Pilar 3 - Versão Omega)...")

    # =========================================================
    # 1. NEXT.JS (ORQUESTRAÇÃO)
    # =========================================================
    
    # API Route Padrão com Logs JSON
    write_snippet("nextjs/route-handler.ts", """
import { NextRequest } from 'next/server';
import { inngest } from '@/inngest/client'; // Assumes inngest client exists
import { logger } from '@/lib/logger'; // Assumes logger util

export async function POST(req: NextRequest) {
  try {
    const { task, payload } = await req.json();

    // 1. Observabilidade (Structured Log)
    logger.info("task_received", { task_id: payload.id, skill: task });

    // 2. Roteamento (Next.js como Chefe)
    if (task === "qualify-lead") {
      // Dispatch para fila (Async)
      await inngest.send({ name: "lead/qualify", data: payload });
      return Response.json({ status: "queued", id: payload.id });
    }

    return Response.json({ error: "unknown_task" }, { status: 400 });

  } catch (error: any) {
    logger.error("route_handler_error", error);
    return Response.json({ error: "internal_error" }, { status: 500 });
  }
}
""")

    # Cliente Inngest Seguro
    write_snippet("nextjs/inngest-client.ts", """
import { Inngest } from "inngest";

export const inngest = new Inngest({ 
  id: "antigravity-app",
  logger: console, // Inngest usa console padrão, mas podemos injetar custom
});
""")

    # Chat Route com Vercel AI SDK
    write_snippet("nextjs/ai-chat.ts", """
import { openai } from "@ai-sdk/openai";
import { streamText } from "ai";

export const maxDuration = 30;

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = await streamText({
    model: openai("gpt-4o-mini"), // Ou OpenRouter via custom provider
    messages,
    onFinish: (completion) => {
        // Log de custo/uso
        console.log(JSON.stringify({ event: "ai_completion", tokens: completion.usage.totalTokens }));
    }
  });

  return result.toDataStreamResponse();
}
""")

    # =========================================================
    # 2. PYTHON (WORKERS)
    # =========================================================
    
    # Worker FastAPI Padrão
    write_snippet("python/fastapi-worker.py", """
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import os
import logging

# Configuração de Logs JSON
logging.basicConfig(level=logging.INFO, format='%(message)s')

app = FastAPI()

class TaskPayload(BaseModel):
    id: str
    data: dict

@app.post("/process")
def process_task(payload: TaskPayload):
    try:
        logging.info(f'{{"event": "python_task_start", "id": "{payload.id}"}}')
        
        # ... Lógica pesada aqui (Pandas, LangGraph) ...
        result = {"status": "success", "processed": True}
        
        logging.info(f'{{"event": "python_task_done", "id": "{payload.id}"}}')
        return result

    except Exception as e:
        logging.error(f'{{"event": "python_task_fail", "error": "{str(e)}"}}')
        raise HTTPException(status_code=500, detail="Worker failed")
""")

    # RAG Query com Neon (pgvector)
    write_snippet("python/rag-neon.py", """
import os
import psycopg2
from openai import OpenAI

def query_rag(query_text: str):
    conn = psycopg2.connect(os.getenv("DATABASE_URL"))
    client = OpenAI(api_key=os.getenv("OPENROUTER_API_KEY"), base_url="https://openrouter.ai/api/v1")
    
    # 1. Embed Query
    emb = client.embeddings.create(input=query_text, model="text-embedding-3-small").data[0].embedding
    
    # 2. Vector Search (Cosine Similarity)
    cur = conn.cursor()
    sql = "SELECT content FROM documents ORDER BY embedding <=> %s::vector LIMIT 3"
    cur.execute(sql, (emb,))
    results = [row[0] for row in cur.fetchall()]
    
    conn.close()
    return results
""")

    # =========================================================
    # 3. COMMS (EVOLUTION API & RESEND)
    # =========================================================
    
    # Evolution API com Fallback
    write_snippet("comms/evolution-whatsapp.ts", """
const EVO_URL = process.env.EVOLUTION_API_URL;
const EVO_KEY = process.env.EVOLUTION_API_KEY;

export async function sendWhatsApp(phone: string, text: string) {
  if (!EVO_URL || !EVO_KEY) throw new Error("Config Missing");

  try {
    const res = await fetch(`${EVO_URL}/message/sendText/default`, {
      method: "POST",
      headers: { "apikey": EVO_KEY, "Content-Type": "application/json" },
      body: JSON.stringify({ number: phone, textMessage: { text } })
    });

    if (!res.ok) throw new Error(res.statusText);
    return { success: true };

  } catch (error) {
    console.error(JSON.stringify({ event: "whatsapp_failed", error: String(error) }));
    // Aqui você chamaria o fallback de email
    return { success: false, fallback: "email" };
  }
}
""")

    # =========================================================
    # 4. OBSERVABILITY (LOGS & METRICS)
    # =========================================================
    
    # Logger Universal JSON
    write_snippet("observability/logger.ts", """
export const logger = {
  info: (event: string, meta: object = {}) => {
    console.log(JSON.stringify({ 
      level: 'info', 
      timestamp: new Date().toISOString(), 
      event, 
      ...meta 
    }));
  },
  error: (event: string, error: any) => {
    console.error(JSON.stringify({ 
      level: 'error', 
      timestamp: new Date().toISOString(), 
      event, 
      message: error instanceof Error ? error.message : String(error)
    }));
  }
};
""")

    # =========================================================
    # 5. INFRA (DOCKER & VERCEL)
    # =========================================================
    
    # Docker Compose para serviços locais
    write_snippet("infra/docker-compose.yml", """
version: '3.8'
services:
  # Apenas para dev local (Em prod usamos Neon)
  postgres:
    image: ankane/pgvector
    ports:
      - "5432:5432"
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: app
""")

    print("\n✅ Snippets Omega instalados em /snippets")
    print("👉 nextjs/    -> Orquestração e API Routes")
    print("👉 python/    -> Workers e RAG")
    print("👉 comms/     -> WhatsApp e Email")
    print("👉 observability/ -> Logger JSON")
    print("👉 infra/     -> Docker e Configs")

if __name__ == "__main__":
    create_snippets_v2()