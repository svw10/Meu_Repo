---
name: 15_antipadroes_vibe_coding
description: "15 Anti-Padrões Específicos de Vibe Coding — falhas sistemáticas de código gerado por IA"
version: 5.0.0
framework: "Antigravity OS v3.1"
owner_agent: DELTA
status: active
tags: [security, anti-patterns, vibe-coding, ai-generated, code-review]
---

# 🚫 15 ANTI-PADRÕES DE VIBE CODING

> **Vibe coding** = pedir código à IA sem revisar criticamente o resultado.
> Estes são os erros **mais comuns** que LLMs introduzem em código de produção.

---

## Tabela Rápida

| Código | Anti-Padrão | Manifestação Típica | Severidade |
|--------|-------------|---------------------|------------|
| **A1** | Segurança só no cliente | Validações/auth apenas no frontend | 🔴 CRÍTICA |
| **A2** | Auth removido para "resolver bug" | Middleware de auth comentado para corrigir erro | 🔴 CRÍTICA |
| **A3** | Secrets hardcoded | API keys/connection strings no código-fonte | 🔴 CRÍTICA |
| **A4** | RLS desabilitado | `DISABLE ROW LEVEL SECURITY` ou `USING (true)` | 🔴 CRÍTICA |
| **A5** | Middleware fantasma | Helmet/CORS/CSRF importados mas não montados | 🟡 ALTA |
| **A6** | Error swallowing | `catch(e){}` ou `console.log(e)` sem tratamento | 🟡 ALTA |
| **A7** | Permissões excessivas | Service role keys onde anon key bastaria; IAM com `*` | 🟡 ALTA |
| **A8** | Validação ausente em Server Actions | Next.js/Remix actions sem validação de input | 🔴 CRÍTICA |
| **A9** | Admin exposto por default | `/api/admin/*`, Swagger, consoles acessíveis sem auth | 🟡 ALTA |
| **A10** | Paginação sem limite | `SELECT *` ou `pageSize=999999` sem validação | 🟡 ALTA |
| **A11** | JWT decode sem verify | Usa `jwt.decode()` sem verificação para decisões de auth | 🔴 CRÍTICA |
| **A12** | Boolean injection via query param | `?admin=true` usado diretamente em condicional | 🔴 CRÍTICA |
| **A13** | Try-catch que retorna sucesso | `catch { return { success: true } }` — falha silenciosa | 🟡 ALTA |
| **A14** | Env vars client-side com segredos | `NEXT_PUBLIC_STRIPE_SECRET_KEY`, `VITE_DATABASE_URL` | 🔴 CRÍTICA |
| **A15** | CORS `*` em produção | `Access-Control-Allow-Origin: *` com credenciais | 🟡 ALTA |

---

## Detalhamento com Exemplos

### A1: Segurança Só no Cliente 🔴
**O que a IA faz:** Coloca validação apenas no `<form>` ou no `onChange` do React.

```typescript
// ❌ A1: Validação só no frontend
function CreatePostForm() {
  const [title, setTitle] = useState('')
  const handleSubmit = () => {
    if (title.length < 3) return alert('Título muito curto') // Só aqui!
    fetch('/api/posts', { method: 'POST', body: JSON.stringify({ title }) })
  }
}

// ✅ CORRETO: Validação server-side obrigatória
// app/api/posts/route.ts
export async function POST(req: Request) {
  const body = await req.json()
  const data = createPostSchema.parse(body) // 🔒 Validação no servidor
  // ...
}
```

**Como detectar:** Busque endpoints sem schema validation: `grep -rn "req.body\|req.query\|req.params" --include="*.ts" src/app/api/`

---

### A2: Auth Removido para "Resolver Bug" 🔴
**O que a IA faz:** Comenta middleware de auth porque estava dando 401 durante o desenvolvimento.

```typescript
// ❌ A2: Auth comentado
// middleware.ts
export default function middleware(req: NextRequest) {
  // const { userId } = auth() // "comentei pra testar"
  return NextResponse.next()
}

// ❌ A2: Matcher vazio
export const config = {
  matcher: [] // Era ['/dashboard/:path*'] mas a IA removeu
}
```

**Como detectar:** `grep -rn "// .*auth\|// .*middleware\|// .*protect" --include="*.ts" src/`

---

### A3: Secrets Hardcoded 🔴
**O que a IA faz:** Cola exemplos com chaves reais ou gera código com valores inline.

```typescript
// ❌ A3: Secret no código
const stripe = new Stripe('sk_live_EXEMPLO_CHAVE_AQUI_NAO_USE')
const supabase = createClient('https://xxx.supabase.co', 'eyJ_EXEMPLO_TOKEN_AQUI')

// ✅ CORRETO: Variáveis de ambiente
const stripe = new Stripe(process.env.STRIPE_SECRET_KEY!)
const supabase = createClient(process.env.SUPABASE_URL!, process.env.SUPABASE_ANON_KEY!)
```

**Como detectar:** `grep -rn "sk-\|sk_live\|sk_test\|pk_live\|eyJ" --include="*.ts" --include="*.js" src/`

---

### A4: RLS Desabilitado 🔴
**O que a IA faz:** Desabilita RLS para "funcionar mais rápido" durante o desenvolvimento.

```sql
-- ❌ A4: RLS desabilitado
ALTER TABLE users DISABLE ROW LEVEL SECURITY;

-- ❌ A4: Policy que permite tudo
CREATE POLICY "allow_all" ON orders USING (true) WITH CHECK (true);

-- ✅ CORRETO: Policy restritiva
CREATE POLICY "users_own_data" ON orders
  USING (user_id = auth.uid())
  WITH CHECK (user_id = auth.uid());
```

**Como detectar:** `grep -rn "DISABLE ROW LEVEL\|USING (true)\|WITH CHECK (true)" --include="*.sql" supabase/migrations/`

---

### A5: Middleware Fantasma 🟡
**O que a IA faz:** Importa pacotes de segurança mas não os monta no app.

```typescript
// ❌ A5: Importado mas não montado
import helmet from 'helmet'
import cors from 'cors'
import csurf from 'csurf'

const app = express()
app.use(express.json())
// helmet(), cors(), csurf() nunca chamados!

// ✅ CORRETO: Montados
const app = express()
app.use(helmet())
app.use(cors({ origin: ALLOWED_ORIGINS, credentials: true }))
app.use(csurf({ cookie: true }))
```

**Como detectar:** `grep -rn "import.*helmet\|import.*cors\|import.*csrf" src/ | xargs grep -L "app.use"`

---

### A6: Error Swallowing 🟡
**O que a IA faz:** Engole erros silenciosamente ou loga sem tratar.

```typescript
// ❌ A6: Erro engolido
try {
  await processPayment(order)
} catch (e) {} // Pagamento falhou mas ninguém sabe

// ❌ A6: Log sem tratamento
try {
  await processPayment(order)
} catch (e) {
  console.log(e) // Em prod? Sem alertas? Sem retry?
}

// ✅ CORRETO: Tratamento adequado
try {
  await processPayment(order)
} catch (error) {
  logger.error('payment_failed', {
    orderId: order.id,
    error: error instanceof Error ? error.message : 'unknown',
    correlationId
  })
  await markOrderAsFailed(order.id)
  throw new PaymentError('Falha no processamento do pagamento')
}
```

**Como detectar:** `grep -rn "catch.*{}" --include="*.ts" --include="*.js" src/`

---

### A7: Permissões Excessivas 🟡
**O que a IA faz:** Usa a chave mais poderosa disponível "para simplificar".

```typescript
// ❌ A7: Service role no client
const supabase = createClient(url, process.env.SUPABASE_SERVICE_ROLE_KEY!) // Bypass RLS!

// ❌ A7: IAM com wildcard
{
  "Effect": "Allow",
  "Action": "s3:*",
  "Resource": "*"
}

// ✅ CORRETO: Mínimo necessário
const supabase = createClient(url, process.env.SUPABASE_ANON_KEY!) // Respeita RLS

// IAM restrito
{
  "Effect": "Allow",
  "Action": ["s3:GetObject", "s3:PutObject"],
  "Resource": "arn:aws:s3:::my-bucket/uploads/*"
}
```

---

### A8: Validação Ausente em Server Actions 🔴
**O que a IA faz:** Cria Server Actions que confiam no input sem validar.

```typescript
// ❌ A8: Sem validação
'use server'
export async function updateProfile(formData: FormData) {
  const name = formData.get('name') as string // Trust issues
  const role = formData.get('role') as string // Privilege escalation!
  await db.user.update({ where: { id: userId }, data: { name, role } })
}

// ✅ CORRETO: Com validação
'use server'
export async function updateProfile(formData: FormData) {
  const { userId } = auth() // 🔒 L6: ID do token
  if (!userId) throw new AuthError()
  
  const data = updateProfileSchema.parse({
    name: formData.get('name') // 🔒 L2: Schema restrito (sem 'role')
  })
  await db.user.update({ where: { id: userId }, data })
}
```

---

### A9: Admin Exposto por Default 🟡
**O que a IA faz:** Gera rotas admin sem proteção ou deixa ferramentas de debug expostas.

```typescript
// ❌ A9: Swagger em produção
app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec))

// ❌ A9: Rota admin sem auth
app.get('/api/admin/users', async (req, res) => {
  const users = await db.user.findMany()
  res.json(users)
})

// ✅ CORRETO: Protegido e condicional
if (process.env.NODE_ENV !== 'production') {
  app.use('/api-docs', swaggerUi.serve, swaggerUi.setup(swaggerSpec))
}

app.get('/api/admin/users', requireAuth, requireRole('ADMIN'), async (req, res) => {
  const users = await db.user.findMany({ select: { id: true, name: true, role: true } })
  res.json(users)
})
```

---

### A10: Paginação sem Limite 🟡
```typescript
// ❌ A10: Sem limite
const posts = await db.post.findMany({
  take: req.query.pageSize // Atacante: ?pageSize=999999
})

// ✅ CORRETO: Limite forçado
const pageSize = Math.min(Number(req.query.pageSize) || 20, 100) // Max 100
const posts = await db.post.findMany({ take: pageSize })
```

---

### A11: JWT Decode sem Verify 🔴
```typescript
// ❌ A11: Decode sem verificação
import jwt from 'jsonwebtoken'
const payload = jwt.decode(token) // NÃO VERIFICA assinatura!
if (payload.role === 'admin') { /* ... */ }

// ✅ CORRETO: Verify com secret
const payload = jwt.verify(token, process.env.JWT_SECRET!, { algorithms: ['RS256'] })
```

---

### A12: Boolean Injection via Query Param 🔴
```typescript
// ❌ A12: Query param direta
if (req.query.admin === 'true') {
  return getAdminData() // ?admin=true no browser = admin!
}

// ✅ CORRETO: Role do token
if (session.user.role === 'ADMIN') {
  return getAdminData()
}
```

---

### A13: Try-Catch que Retorna Sucesso 🟡
```typescript
// ❌ A13: Falha silenciosa
export async function processOrder(orderId: string) {
  try {
    await chargeCustomer(orderId)
    await sendConfirmation(orderId)
  } catch {
    return { success: true } // 💀 Pagamento falhou mas retorna sucesso!
  }
  return { success: true }
}
```

---

### A14: Env Vars Client-Side com Segredos 🔴
```bash
# ❌ A14: Segredos expostos no bundle
NEXT_PUBLIC_STRIPE_SECRET_KEY=sk_live_xxx     # 💀 No bundle JS!
NEXT_PUBLIC_DATABASE_URL=postgresql://...       # 💀 String de conexão!
VITE_SUPABASE_SERVICE_KEY=eyJhbGciOi...        # 💀 Service role key!

# ✅ CORRETO: Sem prefixo público
STRIPE_SECRET_KEY=sk_live_xxx
DATABASE_URL=postgresql://...
SUPABASE_SERVICE_ROLE_KEY=eyJhbGciOi...
```

---

### A15: CORS `*` em Produção 🟡
```typescript
// ❌ A15: Permite qualquer origem
app.use(cors({ origin: '*', credentials: true }))

// ✅ CORRETO: Allowlist
const ALLOWED_ORIGINS = ['https://myapp.com', 'https://admin.myapp.com']
app.use(cors({
  origin: (origin, callback) => {
    if (!origin || ALLOWED_ORIGINS.includes(origin)) {
      callback(null, true)
    } else {
      callback(new Error('CORS não permitido'))
    }
  },
  credentials: true
}))
```

---

## 📊 Comandos de Detecção Rápida

```bash
# Scan completo para anti-padrões
echo "=== A1: Endpoints sem validação ===" 
grep -rn "req.body\b" --include="*.ts" src/app/api/ | grep -v "parse\|validate\|schema"

echo "=== A2: Auth comentado ==="
grep -rn "// .*auth()\|// .*protect\|// .*middleware" --include="*.ts" src/

echo "=== A3: Secrets hardcoded ==="
grep -rn "sk-\|sk_live\|sk_test\|pk_live\|password.*=" --include="*.ts" --include="*.js" src/

echo "=== A4: RLS desabilitado ==="
grep -rn "DISABLE ROW LEVEL\|USING (true)" --include="*.sql" .

echo "=== A6: Error swallowing ==="
grep -rn "catch.*{}\|catch.*console.log" --include="*.ts" --include="*.js" src/

echo "=== A10: SELECT sem limit ==="
grep -rn "findMany()\|SELECT \*" --include="*.ts" src/ | grep -v "take:\|LIMIT\|select:"

echo "=== A11: JWT decode sem verify ==="
grep -rn "jwt.decode\b" --include="*.ts" --include="*.js" src/

echo "=== A14: Secrets em NEXT_PUBLIC ==="
grep -rn "NEXT_PUBLIC_.*SECRET\|NEXT_PUBLIC_.*KEY\|VITE_.*SECRET" .env*
```

---

## 🔗 Referências

- GitGuardian State of Secrets (2025): https://www.gitguardian.com/state-of-secrets
- Veracode State of Software Security (2025): https://www.veracode.com/state-of-software-security
- OWASP AI Security: https://owasp.org/www-project-ai-security/
