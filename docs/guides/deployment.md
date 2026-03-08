# Deployment Guide

Deploy Duet Company to Cloudflare Pages and Workers.

## Overview

Duet Company is designed to deploy to Cloudflare's edge network:

- **Cloudflare Pages** - Next.js frontend
- **Cloudflare Workers** - API edge functions
- **Cloudflare D1** - SQLite database at the edge
- **Cloudflare KV** - Key-value storage for caching
- **Cloudflare AI Gateway** - LLM observability and rate limiting

## Prerequisites

1. **Cloudflare Account** - Sign up at https://dash.cloudflare.com/
2. **Domain Name** - Configure your domain (e.g., `duet.company`)
3. **Wrangler CLI** - Install Cloudflare's CLI tool

```bash
bun install -g wrangler
wrangler login
```

## Initial Setup

### 1. Create D1 Database

```bash
# Create production database
wrangler d1 create duet-company-prod

# Note the database_id from the output
# Update infrastructure/cloudflare/wrangler.toml with the ID
```

### 2. Create KV Namespace

```bash
# Create KV namespace for caching
wrangler kv:namespace create CACHE

# Note the namespace ID from the output
# Update infrastructure/cloudflare/wrangler.toml with the ID
```

### 3. Setup AI Gateway

```bash
# Create AI Gateway (via Cloudflare Dashboard)
# Visit: https://dash.cloudflare.com/ai/gateway

# Create a new gateway with:
# - Gateway Name: duet-company-prod
# - Providers: OpenAI, Anthropic
# - Rate Limits: 100 requests/minute per user
# - Caching: Enabled with 1 hour TTL

# Note the gateway_id from the dashboard
# Update infrastructure/cloudflare/wrangler.toml with the ID
```

### 4. Configure AI Provider Keys

```bash
# Set secrets for AI providers
wrangler secret put OPENAI_API_KEY
wrangler secret put ANTHROPIC_API_KEY
```

### 5. Run Database Migrations

```bash
# Apply schema to D1 database
wrangler d1 execute duet-company-prod --file=infrastructure/cloudflare/d1/schema.sql
```

## Deploying

### Option 1: GitHub Actions (Recommended)

1. **Fork the repository** to your GitHub account
2. **Configure secrets** in GitHub repository settings:
   - `CLOUDFLARE_API_TOKEN` - Create at Cloudflare Dashboard > My Profile > API
     Tokens
   - `CLOUDFLARE_ACCOUNT_ID` - Found in Cloudflare URL
   - `CLOUDFLARE_AI_GATEWAY_ID` - Your AI Gateway ID
   - `OPENAI_API_KEY` - OpenAI API key
   - `ANTHROPIC_API_KEY` - Anthropic API key
3. **Push to main branch** - CI/CD will automatically deploy

### Option 2: Manual Deployment with Wrangler

#### Deploy API Worker

```bash
# Build the worker
cd infrastructure/cloudflare/workers
bun build api-worker.ts --outfile=api-worker.js --target=browser

# Deploy to Cloudflare Workers
wrangler deploy api-worker.js
```

#### Deploy Web App

```bash
# Build the Next.js app
cd apps/web
bun run build

# Deploy to Cloudflare Pages
wrangler pages deploy .next --project-name=duet-company-web
```

## Domain Configuration

### Configure DNS Records

Add these records in your Cloudflare DNS settings:

| Type  | Name | Content                  | Proxy   |
| ----- | ---- | ------------------------ | ------- |
| A     | duet | Your server IP           | Proxied |
| CNAME | api  | duet.company.workers.dev | Proxied |
| CNAME | www  | duet.company             | Proxied |

### Configure Custom Domains in Wrangler

Update `infrastructure/cloudflare/wrangler.toml`:

```toml
routes = [
  { pattern = "api.duet.company/*", zone_name = "duet.company" }
]
```

## Environment Variables

### Production Environment

Set these in your Cloudflare Workers dashboard or via `wrangler secret`:

```bash
# AI Gateway
wrangler secret put CLOUDFLARE_AI_GATEWAY_ID
wrangler secret put OPENAI_API_KEY
wrangler secret put ANTHROPIC_API_KEY

# Database
wrangler secret put DATABASE_URL
wrangler secret put JWT_SECRET

# Application
wrangler secret put ENVIRONMENT
```

## AI Gateway Configuration

### Gateway Settings

Configure in Cloudflare Dashboard > AI > Gateway:

```json
{
  "name": "duet-company-prod",
  "providers": [
    {
      "id": "openai",
      "name": "OpenAI",
      "api_key": "OPENAI_API_KEY",
      "models": ["gpt-4", "gpt-4-turbo-preview", "gpt-3.5-turbo"],
      "rate_limit": {
        "requests_per_minute": 100,
        "tokens_per_minute": 100000
      },
      "cache": {
        "enabled": true,
        "ttl": 3600
      }
    },
    {
      "id": "anthropic",
      "name": "Anthropic",
      "api_key": "ANTHROPIC_API_KEY",
      "models": ["claude-3-opus", "claude-3-sonnet", "claude-2"],
      "rate_limit": {
        "requests_per_minute": 50,
        "tokens_per_minute": 50000
      },
      "cache": {
        "enabled": true,
        "ttl": 3600
      }
    }
  ]
}
```

### Gateway Endpoints

```bash
# OpenAI GPT-4
https://gateway.ai.cloudflare.com/v1/openai/gpt-4

# Anthropic Claude 3
https://gateway.ai.cloudflare.com/v1/anthropic/claude-3-opus
```

## Monitoring and Logs

### View Worker Logs

```bash
wrangler tail --format pretty
```

### View AI Gateway Analytics

Visit Cloudflare Dashboard > AI > Gateway > Analytics

#### Key Metrics

- Request volume by model
- Success/error rates
- Latency percentiles (p50, p95, p99)
- Token usage and costs
- Cache hit rates

### View Pages Analytics

Visit Cloudflare Dashboard > Analytics > Pages

## Rollback

If you need to rollback a deployment:

```bash
# List recent deployments
wrangler deployments list

# Rollback to a specific deployment
wrangler rollback <deployment-id>
```

## Troubleshooting

### Deployment Fails

1. Check `wrangler.toml` configuration
2. Verify API token has necessary permissions
3. Check logs with `wrangler tail`

### Database Issues

```bash
# Query D1 database
wrangler d1 execute duet-company-prod --command="SELECT * FROM users"

# Drop and recreate (WARNING: destroys data)
wrangler d1 delete duet-company-prod
```

### AI Gateway Issues

```bash
# Test gateway connection
curl -X POST https://gateway.ai.cloudflare.com/v1/openai/gpt-4 \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"test"}]}'

# Check gateway settings in dashboard
# https://dash.cloudflare.com/ai/gateway
```

### Custom Domain Not Working

1. Verify DNS records in Cloudflare Dashboard
2. Check SSL/TLS settings (Full mode recommended)
3. Wait for DNS propagation (up to 24 hours)

## Security Checklist

- [ ] API tokens are stored as secrets, not in code
- [ ] CORS is properly configured for your domain
- [ ] Rate limiting is enabled in AI Gateway
- [ ] Database migrations are tested before production
- [ ] SSL/TLS is enabled (Full mode)
- [ ] Web Application Firewall (WAF) rules are configured
- [ ] AI Gateway caching is enabled
- [ ] Budget alerts are configured

## Cost Estimation

| Service    | Free Tier                     | Paid Usage                         |
| ---------- | ----------------------------- | ---------------------------------- |
| Pages      | Unlimited bandwidth           | $0/month                           |
| Workers    | 100k requests/day             | $5/month per 10M requests          |
| D1         | 5GB storage, 25M reads/day    | $0.25/GB-month, $0.50 per 1M reads |
| KV         | 100k reads/day, 1k writes/day | $0.50 per 1M reads                 |
| AI Gateway | 100k requests/month           | $5 per 1M requests                 |

Estimated cost for small production: **$0-30/month**

### AI Costs

| Model           | Input (1M tokens) | Output (1M tokens) |
| --------------- | ----------------- | ------------------ |
| GPT-4 Turbo     | $10.00            | $30.00             |
| Claude 3 Opus   | $15.00            | $75.00             |
| Claude 3 Sonnet | $3.00             | $15.00             |
| GPT-3.5 Turbo   | $0.50             | $1.50              |

## Next Steps

- [API Documentation](../api/rest-api.md) - API reference
- [Company Documentation](../company/vision.md) - About Duet Company
- [AI Gateway Guide](../../infrastructure/cloudflare/ai-gateway/README.md) - AI
  Gateway setup
