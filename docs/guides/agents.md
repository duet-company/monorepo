# AI Agents Guide

Duet Company's AI agents provide autonomous data infrastructure management.

## Overview

The platform includes several specialized AI agents:

- **Query Agent** - Natural language to SQL translation
- **Design Agent** - Platform design from requirements
- **Support Agent** - 24/7 customer assistance
- **Operations Agent** - Infrastructure monitoring and optimization

## Query Agent

The Query Agent converts natural language questions into SQL queries.

### Capabilities

- Natural language understanding
- SQL query generation
- Query optimization
- Result visualization suggestions

### Usage

```bash
curl -X POST http://localhost:8000/api/v1/agents/query \
  -H "Content-Type: application/json" \
  -d '{
    "platform_id": "platform_123",
    "query": "Show me revenue trends for the last 6 months"
  }'
```

### Example Queries

- "What's our total revenue this month?"
- "Show me the top 10 products by sales"
- "Compare user retention between cohorts"
- "Find unusual patterns in our data"

## Design Agent

The Design Agent creates data platforms from natural language requirements.

### Capabilities

- Schema design from requirements
- Infrastructure provisioning
- Dashboard creation
- Data connector setup

### Usage

```bash
curl -X POST http://localhost:8000/api/v1/agents/design \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "I need an e-commerce analytics platform with order tracking, customer segmentation, and inventory management"
  }'
```

### Design Process

1. **Analyze requirements** - Parse natural language description
2. **Design schema** - Generate ClickHouse table definitions
3. **Create dashboards** - Suggest Grafana dashboard layouts
4. **Provision infrastructure** - Deploy to Kubernetes/Cloudflare

## Support Agent

The Support Agent provides 24/7 customer assistance.

### Capabilities

- Documentation search
- Issue diagnosis
- Solution recommendations
- Knowledge base access

### Usage

```bash
curl -X POST http://localhost:8000/api/v1/agents/support \
  -H "Content-Type: application/json" \
  -d '{
    "question": "How do I optimize slow queries?"
  }'
```

### Features

- Context-aware responses
- Multi-language support
- Code examples
- Links to documentation

## Operations Agent

The Operations Agent manages infrastructure autonomously.

### Capabilities

- Performance monitoring
- Auto-scaling
- Query optimization
- Self-healing

### Monitored Metrics

- CPU and memory usage
- Query performance
- Database health
- Error rates

### Auto-Scaling Rules

| Metric             | Threshold  | Action      |
| ------------------ | ---------- | ----------- |
| CPU > 80%          | 5 minutes  | Add replica |
| Memory > 85%       | 5 minutes  | Add replica |
| Query latency > 5s | 10 minutes | Investigate |
| Error rate > 5%    | 5 minutes  | Alert       |

## Agent Configuration

Agents are configured via environment variables and config files:

```json
{
  "agents": {
    "query": {
      "model": "claude-3-opus-20240229",
      "max_tokens": 4000,
      "temperature": 0.1
    },
    "design": {
      "model": "claude-3-opus-20240229",
      "max_tokens": 8000,
      "temperature": 0.3
    },
    "support": {
      "model": "claude-3-sonnet-20240229",
      "max_tokens": 2000,
      "temperature": 0.5
    }
  }
}
```

## Supported LLM Models

| Provider  | Model           | Best For                     |
| --------- | --------------- | ---------------------------- |
| Anthropic | Claude 3 Opus   | Complex reasoning            |
| Anthropic | Claude 3 Sonnet | Balance of speed and quality |
| OpenAI    | GPT-4 Turbo     | General purpose              |
| Google    | Gemini Pro      | Long context                 |
| X.AI      | Grok            | Real-time knowledge          |

## Agent Performance

### Benchmarks

| Agent      | Response Time | Accuracy | Cost per 1k calls |
| ---------- | ------------- | -------- | ----------------- |
| Query      | 2-5s          | 94%      | $0.15             |
| Design     | 5-15s         | 89%      | $0.45             |
| Support    | 1-3s          | 91%      | $0.08             |
| Operations | <1s           | N/A      | $0.02             |

## Extending Agents

### Custom Agent Development

Create a new agent in `packages/agents/`:

```typescript
// packages/agents/my-agent/index.ts
export interface MyAgentConfig {
  model: string;
  parameters: Record<string, unknown>;
}

export async function myAgent(
  input: string,
  config: MyAgentConfig
): Promise<string> {
  // Implementation
  return response;
}
```

## Troubleshooting

### Agent Not Responding

1. Check API keys are configured
2. Verify LLM provider is available
3. Check rate limits
4. Review logs in Cloudflare Dashboard

### Poor Query Quality

1. Provide more context in the query
2. Try rephrasing the question
3. Ensure database schema is documented
4. Consider using a different model

## Roadmap

- [ ] Multi-agent collaboration
- [ ] Agent marketplace
- [ ] Custom model fine-tuning
- [ ] Agent versioning and rollback

## Next Steps

- [API Documentation](../api/rest-api.md) - Agent API endpoints
- [Company Vision](../company/vision.md) - Our AI-first approach
