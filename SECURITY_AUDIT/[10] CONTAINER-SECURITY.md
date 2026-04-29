---
name: container_security
description: "Baseline de segurança para Docker/containers"
version: 5.0.0
framework: "Antigravity OS v3.1"
status: active
tags: [security, docker, container, devops]
---

# 🐳 CONTAINER SECURITY BASELINE

---

## Dockerfile Seguro (Modelo)

```dockerfile
# 🔒 Multi-stage build — reduz superfície de ataque
FROM node:20-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production && npm cache clean --force
COPY . .
RUN npm run build

# 🔒 Imagem final mínima
FROM node:20-alpine AS runner
WORKDIR /app

# 🔒 Usuário não-root
RUN addgroup --system --gid 1001 appgroup \
    && adduser --system --uid 1001 appuser

# 🔒 Copiar apenas o necessário
COPY --from=builder --chown=appuser:appgroup /app/dist ./dist
COPY --from=builder --chown=appuser:appgroup /app/node_modules ./node_modules
COPY --from=builder --chown=appuser:appgroup /app/package.json ./

# 🔒 Variáveis de ambiente seguras
ENV NODE_ENV=production
ENV PORT=3000

# 🔒 Não expor portas desnecessárias
EXPOSE 3000

# 🔒 Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/api/health || exit 1

# 🔒 Rodar como não-root
USER appuser

CMD ["node", "dist/server.js"]
```

---

## Checklist de Segurança de Container

### Imagem Base
- [ ] Usar imagem `-alpine` ou `-slim` (menor superfície)
- [ ] Versão fixa (nunca `latest`)
- [ ] Scan de CVEs: `trivy image myapp:latest`
- [ ] Nenhum CVE CRÍTICO ou ALTO

### Build
- [ ] Multi-stage build (builder + runner)
- [ ] `.dockerignore` configurado
- [ ] `npm ci` (não `npm install`)
- [ ] Cache de dependências limpo
- [ ] Nenhum secret no Dockerfile ou na imagem

### Runtime
- [ ] `USER appuser` (nunca root)
- [ ] `NODE_ENV=production`
- [ ] Health check configurado
- [ ] Apenas porta necessária exposta
- [ ] Read-only filesystem quando possível

### Secrets
- [ ] Secrets via Docker secrets ou mount (nunca ENV no Dockerfile)
- [ ] Nenhum `.env` copiado para a imagem
- [ ] ARG para build, não para runtime secrets

---

## .dockerignore

```
node_modules
.git
.gitignore
.env*
*.md
*.log
.next
dist
coverage
.vscode
.idea
Dockerfile
docker-compose*.yml
```

---

## Docker Compose (Desenvolvimento)

```yaml
version: '3.8'
services:
  app:
    build: .
    ports: ["3000:3000"]
    environment:
      - NODE_ENV=development
    env_file: .env.local  # Nunca .env de produção
    volumes:
      - ./src:/app/src:ro  # Read-only
    networks: [app-net]
    # 🔒 Limites de recursos
    deploy:
      resources:
        limits:
          cpus: '1.0'
          memory: 512M

  db:
    image: postgres:16-alpine
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password  # 🔒 Via secret
    volumes:
      - db-data:/var/lib/postgresql/data
    networks: [app-net]
    # 🔒 Não expor porta externamente
    # ports: ["5432:5432"]  # Comentado — só acesso interno

networks:
  app-net:
    driver: bridge

volumes:
  db-data:

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

---

## Scan de Segurança

```bash
# Trivy — scan de vulnerabilidades
trivy image myapp:latest
trivy image --severity HIGH,CRITICAL myapp:latest

# Dockle — best practices de Dockerfile
dockle myapp:latest

# Hadolint — linter de Dockerfile
hadolint Dockerfile

# Grype — scan de SBOMs
grype myapp:latest
```
