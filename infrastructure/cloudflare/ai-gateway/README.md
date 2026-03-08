# Cloudflare AI Gateway Configuration

## Overview

Cloudflare AI Gateway provides observability, rate limiting, and caching for AI
API calls. All LLM requests are routed through the gateway.

## Supported Providers

- OpenAI (GPT-3.5, GPT-4, GPT-4-turbo)
- Anthropic (Claude, Claude Instant, Claude 2)
- Google (Gemini Pro)
- Cohere (Command, Embed)
- Mistral (Mistral, Mixtral)

## Gateway Endpoints

```
https://gateway.ai.cloudflare.com/v1/{provider}/{model}
```

### Examples

```bash
# OpenAI GPT-4
https://gateway.ai.cloudflare.com/v1/openai/gpt-4

# Anthropic Claude 3
https://gateway.ai.cloudflare.com/v1/anthropic/claude-3-opus

# Google Gemini Pro
https://gateway.ai.cloudflare.com/v1/google-vertex-ai/gemini-pro
```

## Configuration

### Workers (wrangler.toml)

```toml
[ai]
binding = "AI"
gateway_id = "YOUR_GATEWAY_ID"

[[ai.providers]]
name = "openai"
api_key = "OPENAI_API_KEY"

[[ai.providers]]
name = "anthropic"
api_key = "ANTHROPIC_API_KEY"
```

### Environment Variables

```env
CLOUDFLARE_AI_GATEWAY_ID=your_gateway_id
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
```

## Usage

### JavaScript/TypeScript

```typescript
import { env } from 'cloudflare:workers';

export default {
  async fetch(request, env, ctx) {
    const response = await env.AI.run('@cf/meta/llama-2-7b-chat-int8', {
      prompt: 'What is the capital of France?',
    });
    return new Response(response);
  },
};
```

### Python (FastAPI)

```python
import httpx

async def query_llm(prompt: str):
    async with httpx.AsyncClient() as client:
        response = await client.post(
            "https://gateway.ai.cloudflare.com/v1/anthropic/claude-3-opus",
            headers={
                "Authorization": f"Bearer {os.getenv('ANTHROPIC_API_KEY')}",
                "Content-Type": "application/json"
            },
            json={
                "model": "claude-3-opus",
                "messages": [{"role": "user", "content": prompt}],
                "max_tokens": 1024
            }
        )
    return response.json()
```

## Features

### Observability

- Real-time metrics and logs
- Request/response tracking
- Cost analytics
- Error monitoring

### Rate Limiting

- Per-user rate limits
- Per-model rate limits
- Custom rate limiting rules

### Caching

- Response caching
- Semantic caching
- Custom cache rules
- TTL configuration

### Security

- API key management
- Request filtering
- PII redaction
- Compliance logging

## Monitoring

### Dashboard

Visit the Cloudflare Dashboard > AI > Gateway to view:

- Request volume
- Success rates
- Latency metrics
- Cost analysis
- Error tracking

### Metrics API

```bash
curl https://gateway.ai.cloudflare.com/metrics \
  -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN"
```

## Best Practices

1. **Use Gateway IDs** - Create separate gateways for production/staging
2. **Set Rate Limits** - Protect against cost overruns
3. **Enable Caching** - Reduce latency and costs
4. **Monitor Costs** - Track spending by model/user
5. **Log Requests** - Enable audit logging for compliance

## Cost Management

### Estimated Costs per 1K Requests

| Model         | Input (1M tokens) | Output (1M tokens) |
| ------------- | ----------------- | ------------------ |
| GPT-4         | $30.00            | $60.00             |
| Claude 3 Opus | $15.00            | $75.00             |
| Llama 2 7B    | $0.10             | $0.10              |

### Budget Alerts

Set up budget alerts in Cloudflare Dashboard:

```
AI > Gateway > Settings > Budget Alerts
```

## Troubleshooting

### Connection Errors

```bash
# Test gateway connectivity
curl -X POST https://gateway.ai.cloudflare.com/v1/openai/gpt-4 \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"test"}]}'
```

### Rate Limiting

- Check rate limit status in dashboard
- Adjust limits in gateway settings
- Implement exponential backoff

### Caching Issues

- Clear cache in dashboard
- Adjust cache TTL
- Check cache hit rates

## Related Documentation

- [Cloudflare AI Gateway Docs](https://developers.cloudflare.com/ai-gateway/)
- [Workers AI](https://developers.cloudflare.com/workers-ai/)
- [AI Gateway API](https://developers.cloudflare.com/api/resources/ai/subresources/gateway/methods/update/)
