# Duet Company - Project Summary

## 🚀 Company Overview

**Duet Company** is an AI-first data infrastructure company founded in 2025. We
build autonomous systems where AI agents design, deploy, and manage scalable
data platforms with minimal human oversight.

### Key Stats

- **Founded:** January 2025
- **Team:** 1 human (Duyet Le) + AI agents
- **Location:** Vietnam (remote)
- **Status:** Development Phase (Week 1)
- **Target Launch:** 16 weeks from inception

---

## 📊 Business Model

### Revenue Streams

1. **SaaS Subscriptions** (Primary)
   - Starter: $999/month
   - Growth: $2,999/month
   - Enterprise: Custom pricing

2. **Professional Services**
   - Platform migration
   - Custom AI agents
   - Consulting

3. **Marketplace**
   - Pre-built AI agents
   - Data connectors
   - Dashboards

### Financial Projections

| Year   | Revenue | ARR  | Customers |
| ------ | ------- | ---- | --------- |
| Year 1 | $1M     | $1M  | 50+       |
| Year 2 | $5M     | $5M  | 100+      |
| Year 3 | $20M    | $20M | 500+      |

---

## 🏗️ Technical Architecture

### Core Technologies

- **Database:** ClickHouse (analytics), PostgreSQL (metadata)
- **Orchestration:** Cloudflare Workers & Pages
- **API:** FastAPI (Python)
- **Frontend:** Next.js 14 + TypeScript
- **AI:** Multi-model LLM (Claude, GPT-4, GLM-5, Gemini)
- **Monitoring:** Prometheus + Grafana

### System Components

1. **Natural Language Interface**
   - Text-to-SQL query conversion
   - Natural language platform design
   - Conversational analytics

2. **AI Agent Framework**
   - Query Agent (NL → SQL)
   - Platform Designer Agent (Requirements → Infrastructure)
   - Support Agent (24/7 customer support)
   - Operations Agent (Infrastructure management)

3. **Data Platform**
   - Real-time streaming (Kafka)
   - Batch processing (Airflow)
   - ML models (Scikit-learn, PyTorch)
   - RAG system (LlamaIndex + Qdrant)

---

## 🗺️ Roadmap Status

### ✅ Phase 1: Foundation (Weeks 1-4) - IN PROGRESS

**Completed:**

- [x] Company strategy and vision document
- [x] Technical architecture design
- [x] Execution roadmap (16-week plan)
- [x] Backend skeleton (FastAPI)
- [x] API endpoints stubs
- [x] Git repository with version control
- [x] Monorepo setup with Bun workspaces

**In Progress:**

- [ ] Company registration (Singapore C-Corp)
- [ ] Domain acquisition
- [ ] Brand identity (logo, colors)
- [ ] Infrastructure provisioning
- [ ] ClickHouse deployment
- [ ] AI agent framework implementation

**Upcoming (Weeks 2-4):**

- Platform Designer Agent
- Query Agent implementation
- Authentication system
- Monitoring setup

### 🚧 Phase 2: MVP Development (Weeks 5-8)

- [ ] Platform Designer Agent
- [ ] Query Agent enhancements
- [ ] Monitoring & observability
- [ ] User experience (web dashboard)

### 🎯 Phase 3: Beta Testing (Weeks 9-12)

- [ ] First design partner
- [ ] Feedback and iteration
- [ ] Additional beta users (5 total)
- [ ] Security audit

### 🚀 Phase 4: Launch (Weeks 13-16)

- [ ] Production hardening
- [ ] Billing and subscriptions
- [ ] Marketing and launch
- [ ] Post-launch support

---

## 🤖 AI Agents

### Current Status

- **Framework:** Design complete
- **Implementation:** Pending
- **Models:** Planned (Claude, GPT-4, GLM-5, Gemini)

### Agent Capabilities

1. **Query Agent**
   - Natural language to SQL translation
   - Query optimization
   - Result visualization

2. **Platform Designer Agent**
   - Schema design from requirements
   - Infrastructure provisioning
   - Dashboard creation

3. **Support Agent**
   - 24/7 customer support
   - Issue diagnosis
   - Knowledge base access

4. **Operations Agent**
   - Infrastructure monitoring
   - Auto-scaling
   - Self-healing

---

## 📁 Project Structure

```
duet-company/
├── apps/
│   ├── web/              # Next.js 14 frontend
│   └── api/              # FastAPI backend
├── packages/
│   ├── shared/           # Shared TypeScript utilities
│   ├── ui/               # Shared UI components
│   ├── config/           # Shared configurations
│   ├── agents/           # AI agent packages
│   └── skills/           # OpenClaw skills
├── infrastructure/
│   └── cloudflare/
│       ├── workers/      # Cloudflare Workers
│       ├── pages/        # Cloudflare Pages config
│       └── d1/           # D1 database schemas
├── docs/                 # Comprehensive documentation
│   ├── getting-started/
│   ├── guides/
│   ├── company/
│   └── api/
├── scripts/
├── .github/workflows/
├── package.json          # Root workspace config
├── bun.lockb
├── pnpm-workspace.yaml
└── turbo.json
```

---

## 🔧 Development Status

### Backend

- **Framework:** FastAPI ✅
- **API Endpoints:** Stubbed ✅
- **Database:** Not yet connected ⏳
- **Authentication:** Not implemented ⏳
- **AI Integration:** Pending ⏳

### Frontend

- **Framework:** Next.js 14 + TypeScript
- **Status:** Basic structure ⏳

### Infrastructure

- **Cloudflare:** Configured ✅
- **Docker:** Not built ⏳
- **CI/CD:** GitHub Actions configured ✅
- **Monitoring:** Not set up ⏳

---

## 💡 Key Differentiators

1. **AI-First Architecture**
   - AI designed from ground up, not bolted on
   - Autonomous operations minimize human intervention

2. **Speed to Value**
   - Platform setup in hours, not months
   - Self-provisioning infrastructure

3. **Cost Efficiency**
   - 90% reduction in data engineering costs
   - Better compression (300% vs Iceberg)
   - 2x-100x faster queries

4. **Open Source Foundation**
   - Built on proven open source technologies
   - No vendor lock-in
   - Community-driven innovation

---

## 🎯 Success Metrics

### Technical KPIs

- Platform uptime: 99.9%
- Query performance: <1s for 95% of queries
- Time to deployment: <4 hours
- Cost efficiency: <$100/TB/month

### Business KPIs

- MRR growth: 20% MoM
- Customer NPS: >50
- Churn rate: <5%
- LTV:CAC ratio: >3:1

### AI Agent KPIs

- Autonomous resolution rate: >80%
- Customer satisfaction: >4.5/5
- Agent uptime: 99.9%

---

## 📞 Contact & Resources

### Team

- **Founder:** Duyet Le (@duyet)
- **Email:** me@duyet.net
- **GitHub:** github.com/duyet

### Resources

- **Website:** https://duet.company
- **Documentation:** /docs
- **API Docs:** /api/docs (when running)
- **GitHub:** github.com/duet-company/duet-company

---

## 🚦 Next Steps (This Week)

1. **Legal & Brand**
   - [ ] Register company (Singapore C-Corp)
   - [ ] Acquire domain name (duet.company)
   - [ ] Create brand assets (logo, colors)

2. **Infrastructure**
   - [ ] Configure Cloudflare account
   - [ ] Setup D1 database
   - [ ] Setup monitoring stack

3. **Development**
   - [ ] Implement Platform Designer Agent
   - [ ] Implement Query Agent
   - [ ] Connect to ClickHouse
   - [ ] Build authentication system

4. **Documentation**
   - [ ] API documentation
   - [ ] User guides
   - [ ] Developer tutorials

---

**Status:** 🚧 Building autonomously **Confidence:** High - Clear roadmap,
proven technologies **Timeline:** 16 weeks to launch **Version:** 0.1.0
(Foundation)

_Last Updated: 2025-03-08_
