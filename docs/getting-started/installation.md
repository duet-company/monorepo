# Installation

## Prerequisites

Before you begin, ensure you have the following installed:

- **Bun** >= 1.0.0 - JavaScript runtime and package manager
- **Node.js** >= 20.0.0 - For Next.js compatibility
- **Python** >= 3.10 - For FastAPI backend
- **Git** - For version control

### Installing Bun

```bash
curl -fsSL https://bun.sh/install | bash
```

### Installing Node.js

Using `nvm` (recommended):

```bash
nvm install 20
nvm use 20
```

Or using your system package manager.

### Installing Python

```bash
# Ubuntu/Debian
sudo apt update && sudo apt install python3.11 python3.11-venv

# macOS
brew install python@3.11

# Verify installation
python --version
```

## Clone the Repository

```bash
git clone https://github.com/duet-company/duet-company.git
cd duet-company
```

## Install Dependencies

The monorepo uses Bun workspaces. Install all dependencies with:

```bash
bun install
```

This will install dependencies for all apps and packages:

- `apps/web` - Next.js frontend
- `apps/api` - FastAPI backend
- `packages/*` - Shared packages

## Environment Variables

Create environment files for each app:

### Frontend (`apps/web/.env.local`)

```bash
cp apps/web/.env.example apps/web/.env.local
```

```env
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_APP_URL=http://localhost:3000
```

### Backend (`apps/api/.env`)

```bash
cp apps/api/.env.example apps/api/.env
```

```env
DATABASE_URL=postgresql://user:password@localhost:5432/duet
CLICKHOUSE_URL=clickhouse://localhost:9000/default
OPENAI_API_KEY=your_openai_api_key
ANTHROPIC_API_KEY=your_anthropic_api_key
JWT_SECRET=your_jwt_secret_here
ENVIRONMENT=development
LOG_LEVEL=debug
```

## Python Virtual Environment

Set up the Python virtual environment for the backend:

```bash
cd apps/api
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

## Verify Installation

Run the following to verify everything is set up correctly:

```bash
# Check Bun version
bun --version

# Check Node version
node --version

# Check Python version
python --version

# Run type check
bun run typecheck

# Run linter
bun run lint
```

## Next Steps

- [Quick Start Guide](./quick-start.md) - Get the development servers running
- [Deployment Guide](../guides/deployment.md) - Deploy to production
- [API Documentation](../api/rest-api.md) - API endpoints and usage
