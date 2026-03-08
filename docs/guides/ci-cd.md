# CI/CD Documentation

This document describes the GitHub Actions CI/CD workflows for the Duet Company
monorepo.

## Overview

The CI/CD pipeline automates:

- **Linting** - Code quality checks
- **Type Checking** - TypeScript type validation
- **Testing** - Unit and integration tests
- **Building** - Package and app compilation
- **Security** - Vulnerability scanning
- **Formatting** - Code style consistency
- **Deployment** - Cloudflare Pages & Workers deployment

## Workflows

### 1. CI Workflow (`.github/workflows/ci.yml`)

Runs on every push and pull request to `main` and `develop` branches.

**Jobs:**

- `lint` - Runs ESLint on all packages
- `typecheck` - Validates TypeScript types
- `build` - Builds all packages and apps
- `test` - Runs test suites
- `security` - Security audit and vulnerability scan

**Status Badge:**

```markdown
[![CI](https://github.com/duet-company/monorepo/actions/workflows/ci.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/ci.yml)
```

### 2. Format Check Workflow (`.github/workflows/format.yml`)

Validates code formatting with Prettier.

**Status Badge:**

```markdown
[![Format](https://github.com/duet-company/monorepo/actions/workflows/format.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/format.yml)
```

### 3. Auto Format Workflow (`.github/workflows/auto-format.yml`)

Automatically fixes formatting issues on pull requests.

### 4. Deploy Web Workflow (`.github/workflows/deploy-web.yml`)

Deploys the frontend to Cloudflare Pages.

**Triggers:**

- Push to `main` or `develop`
- Changes in `apps/web/**` or `packages/**`

**Environments:**

- `production` - Deployed from `main` branch
- `preview` - Deployed from `develop` branch

### 5. Deploy API Workflow (`.github/workflows/deploy-api.yml`)

Deploys the API to Cloudflare Workers.

**Triggers:**

- Push to `main` or `develop`
- Changes in `apps/api/**` or `infrastructure/cloudflare/workers/**`

### 6. Deploy D1 Workflow (`.github/workflows/deploy-d1.yml`)

Runs D1 database migrations.

**Triggers:**

- Push to `main`
- Changes in `infrastructure/cloudflare/d1/migrations/**`
- Manual workflow dispatch

### 7. Dependency Review Workflow (`.github/workflows/dependency-review.yml`)

Reviews dependencies for security vulnerabilities on pull requests.

### 8. Release Workflow (`.github/workflows/release.yml`)

Creates GitHub releases and deploys production builds.

**Triggers:**

- Push to version tag (e.g., `v1.0.0`)
- Manual workflow dispatch

## Required Secrets

Configure these secrets in your GitHub repository settings
(`Settings > Secrets and variables > Actions`):

| Secret                  | Description                | Required For    |
| ----------------------- | -------------------------- | --------------- |
| `CLOUDFLARE_API_TOKEN`  | Cloudflare API token       | All deployments |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID      | All deployments |
| `DATABASE_URL`          | Database connection string | API deployment  |
| `OPENAI_API_KEY`        | OpenAI API key             | API deployment  |
| `ANTHROPIC_API_KEY`     | Anthropic API key          | API deployment  |

### Creating a Cloudflare API Token

1. Visit https://dash.cloudflare.com/profile/api-tokens
2. Click "Create Token"
3. Use the "Edit Cloudflare Workers" template
4. Configure permissions:
   - Account - Cloudflare Pages - Edit
   - Account - Workers Scripts - Edit
   - Account - D1 - Edit
5. Copy the token and add to GitHub secrets

## Local Development

### Running CI Checks Locally

```bash
# Install dependencies
bun install

# Run all CI checks
bun run ci

# Individual checks
bun run lint
bun run typecheck
bun run test
bun run build
bun run format:check
```

### Auto-formatting Code

```bash
# Format all files
bun run format

# Check formatting without modifying
bun run format:check
```

## Deployment Process

### Automatic Deployment

1. **Push to `develop`**: Deploys to preview environments
2. **Push to `main`**: Runs CI checks, then deploys to production
3. **Pull Request**: Runs CI checks and auto-formats code

### Manual Deployment

#### Deploy Web App

```bash
bun run build
wrangler pages deploy apps/web/.next --project-name=duet-company-web
```

#### Deploy API Worker

```bash
cd infrastructure/cloudflare/workers
bun build api-worker.ts --outfile=api-worker.js
wrangler deploy api-worker.js --name=duet-company-api
```

#### Run D1 Migrations

```bash
wrangler d1 execute duet-company-prod --file=infrastructure/cloudflare/d1/migrations/001_initial.sql
```

## Workflow Status Badges

Add these to your README.md:

```markdown
# CI/CD Status

[![CI](https://github.com/duet-company/monorepo/actions/workflows/ci.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/ci.yml)
[![Format](https://github.com/duet-company/monorepo/actions/workflows/format.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/format.yml)
[![Dependencies](https://github.com/duet-company/monorepo/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/dependency-review.yml)
```

## Troubleshooting

### Workflow Failures

1. **Lint Errors**

   ```bash
   bun run lint:fix
   git add -A
   git commit -m "fix: resolve linting issues"
   ```

2. **Type Errors**

   ```bash
   bun run typecheck
   # Review errors and fix TypeScript issues
   ```

3. **Build Failures**

   ```bash
   bun run clean
   bun install
   bun run build
   ```

4. **Format Check Failures**
   ```bash
   bun run format
   git add -A
   git commit -m "style: auto-format code"
   ```

### Deployment Failures

1. **Authentication Errors**
   - Verify `CLOUDFLARE_API_TOKEN` is set correctly
   - Check token has required permissions
   - Regenerate token if expired

2. **Build Errors**
   - Check build logs in GitHub Actions
   - Test build locally: `bun run build`
   - Verify all dependencies are installed

3. **Migration Failures**
   - Verify D1 database exists
   - Check migration file syntax
   - Test migration locally first

## Best Practices

1. **Branch Protection**
   - Enable branch protection on `main`
   - Require PR reviews before merge
   - Require status checks to pass

2. **Commit Messages**
   - Use conventional commit format
   - Examples: `feat: add new feature`, `fix: resolve bug`,
     `docs: update documentation`

3. **Pull Requests**
   - Keep PRs focused and small
   - Update documentation with changes
   - Respond to review comments promptly

4. **Testing**
   - Write tests for new features
   - Maintain test coverage above 80%
   - Run tests locally before pushing

## Monitoring

- **GitHub Actions Dashboard**: https://github.com/duet-company/monorepo/actions
- **Cloudflare Dashboard**: https://dash.cloudflare.com
- **Application Logs**: Available in Cloudflare Workers dashboard

## Related Documentation

- [Deployment Guide](./deployment.md)
- [API Documentation](../api/rest-api.md)
- [Contributing Guide](../company/contributing.md)
