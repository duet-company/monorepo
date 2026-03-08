# Infrastructure Configuration

Cloudflare infrastructure for Duet Company deployment.

## 📁 Structure

```
infrastructure/
└── cloudflare/
    ├── workers/         # Cloudflare Workers (API)
    ├── pages/           # Cloudflare Pages (Frontend)
    ├── d1/              # D1 Database (SQLite at edge)
    └── wrangler.toml    # Cloudflare configuration
```

## 🚀 Deployment

### Cloudflare Workers

```bash
# Build the worker
cd infrastructure/cloudflare/workers
bun build api-worker.ts --outfile=api-worker.js --target=browser

# Deploy to Cloudflare Workers
wrangler deploy api-worker.js
```

### Cloudflare Pages

```bash
# Build the Next.js app
cd apps/web
bun run build

# Deploy to Cloudflare Pages
wrangler pages deploy .next --project-name=duet-company-web
```

### D1 Database

```bash
# Create D1 database
wrangler d1 create duet-company-prod

# Run migrations
wrangler d1 execute duet-company-prod --file=infrastructure/cloudflare/d1/schema.sql

# Query the database
wrangler d1 execute duet-company-prod --command="SELECT * FROM users LIMIT 10"
```

## 🔗 Links

- **Cloudflare Dashboard:** https://dash.cloudflare.com
- **Wrangler Docs:** https://developers.cloudflare.com/workers/wrangler/
- **D1 Docs:** https://developers.cloudflare.com/d1/

## Environment Variables

Configure these in `infrastructure/cloudflare/wrangler.toml` or via `wrangler secret`:

```bash
wrangler secret put OPENAI_API_KEY
wrangler secret put ANTHROPIC_API_KEY
wrangler secret put JWT_SECRET
```

## Monitoring

View logs and metrics:
```bash
# Tail worker logs
wrangler tail --format pretty

# View analytics
# Visit Cloudflare Dashboard > Analytics
```
