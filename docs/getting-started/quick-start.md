# Quick Start

Get Duet Company running locally in a few minutes.

## 1. Clone and Install

```bash
# Clone the repository
git clone https://github.com/duet-company/duet-company.git
cd duet-company

# Install dependencies
bun install
```

## 2. Start Development Servers

### Start All Services

```bash
# Start all apps in development mode
bun run dev
```

This starts:

- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000
- **API Docs**: http://localhost:8000/api/docs

### Start Individual Services

```bash
# Frontend only
bun run --filter './apps/web' dev

# Backend only
cd apps/api
source venv/bin/activate
uvicorn app.main:app --reload
```

## 3. Explore the Application

Once running:

1. **Open the dashboard** at http://localhost:3000
2. **View API documentation** at http://localhost:8000/api/docs
3. **Try a health check**:

```bash
curl http://localhost:8000/health
```

## 4. Create Your First Platform

Using the API:

```bash
curl -X POST http://localhost:8000/api/v1/platforms \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Analytics Platform",
    "description": "E-commerce analytics"
  }'
```

## Development Workflow

### Making Changes

1. Edit files in `apps/web/` or `apps/api/`
2. Changes auto-reload in development mode
3. For shared code, edit files in `packages/`

### Type Checking

```bash
bun run typecheck
```

### Linting

```bash
bun run lint
```

### Building

```bash
bun run build
```

## Useful Commands

| Command             | Description                   |
| ------------------- | ----------------------------- |
| `bun run dev`       | Start all apps in development |
| `bun run build`     | Build all packages and apps   |
| `bun run test`      | Run all tests                 |
| `bun run lint`      | Run linter                    |
| `bun run typecheck` | Run TypeScript type check     |
| `bun run format`    | Format code with Prettier     |

## Troubleshooting

### Port Already in Use

If ports 3000 or 8000 are already in use:

```bash
# Find process using the port
lsof -i :3000  # or :8000

# Kill the process
kill -9 <PID>
```

### Python Dependencies Issues

```bash
cd apps/api
rm -rf venv
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

### Bun Install Issues

```bash
# Clear cache and reinstall
rm -rf node_modules bun.lockb
bun install
```

## Next Steps

- [Deployment Guide](../guides/deployment.md) - Deploy to Cloudflare
- [Agents Guide](../guides/agents.md) - Learn about AI agents
- [API Documentation](../api/rest-api.md) - API reference
