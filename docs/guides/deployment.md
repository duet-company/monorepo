# Deployment Guide

Deploy Duet Company to Cloudflare Pages and Workers.

## Overview

Duet Company is designed to deploy to Cloudflare's edge network:
- **Cloudflare Pages** - Next.js frontend
- **Cloudflare Workers** - API edge functions
- **Cloudflare D1** - SQLite database at the edge
- **Cloudflare KV** - Key-value storage for caching

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

### 3. Run Database Migrations

```bash
# Apply schema to D1 database
wrangler d1 execute duet-company-prod --file=infrastructure/cloudflare/d1/schema.sql
```

## Deploying

### Option 1: GitHub Actions (Recommended)

1. **Fork the repository** to your GitHub account
2. **Configure secrets** in GitHub repository settings:
   - `CLOUDFLARE_API_TOKEN` - Create at Cloudflare Dashboard > My Profile > API Tokens
   - `CLOUDFLARE_ACCOUNT_ID` - Found in Cloudflare URL
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

| Type | Name | Content | Proxy |
|------|------|---------|-------|
| A | duet | Your server IP | Proxied |
| CNAME | api | duet.company.workers.dev | Proxied |
| CNAME | www | duet.company | Proxied |

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
# API secrets
wrangler secret put OPENAI_API_KEY
wrangler secret put ANTHROPIC_API_KEY
wrangler secret put JWT_SECRET
```

## Monitoring and Logs

### View Worker Logs

```bash
wrangler tail --format pretty
```

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

### Custom Domain Not Working

1. Verify DNS records in Cloudflare Dashboard
2. Check SSL/TLS settings (Full mode recommended)
3. Wait for DNS propagation (up to 24 hours)

## CI/CD Pipeline

The GitHub Actions workflows automate deployment:

- **`.github/workflows/ci.yml`** - Runs on every push/PR
- **`.github/workflows/deploy-web.yml`** - Deploys frontend to Pages
- **`.github/workflows/deploy-api.yml`** - Deploys API to Workers
- **`.github/workflows/deploy-d1.yml`** - Runs D1 migrations

## Security Checklist

- [ ] API tokens are stored as secrets, not in code
- [ ] CORS is properly configured for your domain
- [ ] Rate limiting is enabled
- [ ] Database migrations are tested before production
- [ ] SSL/TLS is enabled (Full mode)
- [ ] Web Application Firewall (WAF) rules are configured

## Cost Estimation

| Service | Free Tier | Paid Usage |
|---------|-----------|------------|
| Pages | Unlimited bandwidth | $0/month |
| Workers | 100k requests/day | $5/month per 10M requests |
| D1 | 5GB storage, 25M reads/day | $0.25/GB-month, $0.50 per 1M reads |
| KV | 100k reads/day, 1k writes/day | $0.50 per 1M reads |

Estimated cost for small production: **$0-20/month**

## Next Steps

- [API Documentation](../api/rest-api.md) - API reference
- [Company Documentation](../company/vision.md) - About Duet Company
