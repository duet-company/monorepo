# Duet Company 🤖📊

> Building the future of data infrastructure with AI-driven automation.

[![CI](https://github.com/duet-company/monorepo/actions/workflows/ci.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/ci.yml)
[![Format](https://github.com/duet-company/monorepo/actions/workflows/format.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/format.yml)
[![Dependencies](https://github.com/duet-company/monorepo/actions/workflows/dependency-review.yml/badge.svg)](https://github.com/duet-company/monorepo/actions/workflows/dependency-review.yml)

## 🎯 Vision

An AI-first company where AI agents design, deploy, and manage scalable data
platforms autonomously. Minimal human oversight, maximum intelligence.

## 🚀 What We're Building

**Core Value Proposition:**

- Real-time analytics platform setup in **hours, not months**
- **90% reduction** in data engineering costs
- Self-healing, self-optimizing infrastructure
- Enterprise-grade security and compliance built-in

## 🏗️ Architecture

```
Natural Language Interface → AI Agent Orchestrator → Data Infrastructure
                                                    ↓
                                            ClickHouse + PostgreSQL
```

**Key Technologies:**

- **Database:** ClickHouse (analytics), PostgreSQL (metadata)
- **Orchestration:** Cloudflare Workers & Pages
- **AI:** Multi-model LLM support (Claude, GPT-4, GLM-5, Gemini)
- **Framework:** OpenClaw + MCP integrations
- **Monitoring:** Prometheus + Grafana

## 🤖 AI Agents

### 1. Query Agent

Natural language → SQL → Results

```
User: "Show me revenue trends for the last 6 months"
AI: Generates SQL → Executes → Visualizes
```

### 2. Platform Designer Agent

Requirements → Infrastructure → Dashboards

```
User: "I need an e-commerce analytics platform"
AI: Designs schema → Deploys ClickHouse → Sets up Grafana
```

### 3. Support Agent

24/7 customer support with knowledge base access

```
User: "How do I optimize this query?"
AI: Analyzes → Suggests improvements → Explains
```

### 4. Operations Agent

Autonomous infrastructure management

```
Event: High CPU usage detected
AI: Analyzes → Scales resources → Optimizes queries
```

## 📁 Project Structure

```
duet-company/
├── apps/
│   ├── web/              # Next.js 14 frontend
│   └── api/              # FastAPI backend
├── packages/
│   ├── shared/           # Shared utilities
│   ├── ui/               # Shared components
│   ├── config/           # Shared config
│   ├── agents/           # AI agents
│   └── skills/           # OpenClaw skills
├── infrastructure/
│   └── cloudflare/       # Cloudflare configs
├── docs/                 # Documentation
└── scripts/              # Build scripts
```

## 🛠️ Getting Started

### Prerequisites

- Bun >= 1.0.0
- Node.js >= 20.0.0
- Python >= 3.10

### Local Development

```bash
# Clone repository
git clone https://github.com/duet-company/duet-company.git
cd duet-company

# Install dependencies
bun install

# Start all services
bun run dev
```

This starts:

- **Frontend:** http://localhost:3000
- **Backend API:** http://localhost:8000
- **API Docs:** http://localhost:8000/api/docs

## 📊 Roadmap

### Phase 1: Foundation (Weeks 1-4) 🚧

- [x] Company strategy and design
- [x] Monorepo setup
- [x] Basic platform architecture
- [ ] Legal and brand setup
- [ ] Infrastructure provisioning

### Phase 2: MVP Development (Weeks 5-8)

- [ ] Platform Designer Agent
- [ ] Query Agent enhancements
- [ ] Monitoring & observability
- [ ] User experience (web dashboard)

### Phase 3: Beta Testing (Weeks 9-12)

- [ ] First design partner
- [ ] Feedback and iteration
- [ ] Additional beta users (5 total)
- [ ] Security audit

### Phase 4: Launch (Weeks 13-16)

- [ ] Production hardening
- [ ] Billing and subscriptions
- [ ] Marketing and launch
- [ ] Post-launch support

## 💰 Business Model

### Subscription Tiers

- **Starter:** $999/month - 1TB data, 5 users
- **Growth:** $2,999/month - 10TB data, 20 users
- **Enterprise:** Custom - Unlimited scale

### Revenue Projections

- **Year 1:** $1M ARR
- **Year 2:** $5M ARR
- **Year 3:** $20M ARR

## 🏆 Competitive Advantage

1. **AI-First Architecture** - AI designed from ground up, not bolted on
2. **Speed to Value** - Hours to production vs months for competitors
3. **Cost Efficiency** - 90% reduction in data engineering costs
4. **Open Source Foundation** - No vendor lock-in

## 🤝 Contributing

This is currently in autonomous development mode. Contributors welcome once beta
launches.

## 📄 License

Proprietary - All rights reserved. Duet Company © 2025

## 📞 Contact

- **Website:** https://duet.company
- **Email:** hello@duet.company
- **GitHub:** https://github.com/duet-company/duet-company

---

**Status:** 🚧 Building autonomously **Confidence:** High - Clear roadmap,
proven technologies **Timeline:** 16 weeks to launch

Built by [duyetbot](https://github.com/duyetbot) with love and caffeine ☕
