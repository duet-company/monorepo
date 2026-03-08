# Quick Start Guide

Get Duet Company running locally in minutes.

## Prerequisites

Ensure you have:

- **Bun** >= 1.0.0
- **Node.js** >= 20.0.0
- **Python** >= 3.10

## Installation

```bash
# Clone the repository
git clone https://github.com/duet-company/duet-company.git
cd duet-company

# Install dependencies
bun install
```

## Start Development

```bash
# Start all apps
bun run dev
```

This starts:

- Frontend: http://localhost:3000
- Backend API: http://localhost:8000
- API Docs: http://localhost:8000/api/docs

## Environment Setup

### Frontend (.env.local)

```bash
cp apps/web/.env.example apps/web/.env.local
```

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

### Backend (.env)

```bash
cp apps/api/.env.example apps/api/.env
```

```env
DATABASE_URL=postgresql://user:password@localhost:5432/duet
OPENAI_API_KEY=your_key_here
```

## Python Setup

```bash
cd apps/api
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

## Verify Installation

```bash
# Health check
curl http://localhost:8000/health

# Type check
bun run typecheck

# Lint
bun run lint
```

## Development Commands

| Command             | Description        |
| ------------------- | ------------------ |
| `bun run dev`       | Start all apps     |
| `bun run build`     | Build all packages |
| `bun run test`      | Run tests          |
| `bun run lint`      | Run linter         |
| `bun run typecheck` | Type check         |

## Project Structure

```
duet-company/
├── apps/
│   ├── web/          # Next.js frontend
│   └── api/          # FastAPI backend
├── packages/         # Shared packages
├── docs/             # Documentation
└── scripts/          # Build scripts
```

## Next Steps

- [Full Documentation](./docs/getting-started/quick-start.md)
- [API Reference](./docs/api/rest-api.md)
- [Deployment Guide](./docs/guides/deployment.md)
- [Agents Guide](./docs/guides/agents.md)

## Troubleshooting

### Port already in use

```bash
lsof -i :3000  # or :8000
kill -9 <PID>
```

### Dependencies issues

```bash
rm -rf node_modules bun.lockb
bun install
```

## Support

- **Documentation:** /docs
- **API Docs:** /api/docs
- **Email:** hello@duet.company
- **GitHub:** https://github.com/duet-company/duet-company

---

**Happy building! 🚀**
