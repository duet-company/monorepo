# REST API Documentation

Duet Company API provides endpoints for managing platforms, agents, and data.

## Base URL

```
Production: https://api.duet.company
Development: http://localhost:8000
```

## Authentication

Most endpoints require authentication via Bearer token:

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/platforms
```

### Getting a Token

```bash
curl -X POST https://api.duet.company/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "password123"
  }'
```

## Health Check

### GET /health

Check API health status.

```bash
curl https://api.duet.company/health
```

**Response:**

```json
{
  "status": "healthy",
  "version": "0.1.0",
  "service": "Duet Company API",
  "timestamp": "2025-01-15T10:30:00Z"
}
```

## Platforms

### GET /api/v1/platforms

List all platforms for the authenticated user.

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/platforms
```

**Response:**

```json
{
  "platforms": [
    {
      "id": "platform_123",
      "name": "E-commerce Analytics",
      "description": "Sales and customer analytics",
      "status": "active",
      "created_at": "2025-01-01T00:00:00Z"
    }
  ]
}
```

### POST /api/v1/platforms

Create a new platform.

```bash
curl -X POST https://api.duet.company/api/v1/platforms \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Analytics Platform",
    "description": "Customer analytics dashboard"
  }'
```

**Response:**

```json
{
  "id": "platform_456",
  "name": "My Analytics Platform",
  "status": "provisioning"
}
```

### GET /api/v1/platforms/{id}

Get platform details.

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/platforms/platform_123
```

### DELETE /api/v1/platforms/{id}

Delete a platform.

```bash
curl -X DELETE -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/platforms/platform_123
```

## Agents

### GET /api/v1/agents

List available agents.

```bash
curl https://api.duet.company/api/v1/agents
```

**Response:**

```json
{
  "agents": [
    {
      "id": "query",
      "name": "Query Agent",
      "description": "Natural language to SQL",
      "status": "active"
    },
    {
      "id": "design",
      "name": "Platform Designer",
      "description": "Design data platforms",
      "status": "active"
    }
  ]
}
```

### POST /api/v1/agents/query

Execute a natural language query.

```bash
curl -X POST https://api.duet.company/api/v1/agents/query \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "platform_id": "platform_123",
    "query": "Show me revenue trends for the last 6 months"
  }'
```

**Response:**

```json
{
  "sql": "SELECT date, sum(revenue) as daily_revenue FROM orders WHERE date >= now() - INTERVAL 6 MONTH GROUP BY date ORDER BY date",
  "result": [
    { "date": "2025-01-01", "daily_revenue": 1234.56 },
    { "date": "2025-01-02", "daily_revenue": 2345.67 }
  ],
  "execution_time_ms": 123
}
```

### POST /api/v1/agents/design

Design a platform from requirements.

```bash
curl -X POST https://api.duet.company/api/v1/agents/design \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "requirements": "E-commerce analytics platform with order tracking"
  }'
```

**Response:**

```json
{
  "schema": {
    "tables": [
      {
        "name": "orders",
        "columns": [
          { "name": "id", "type": "UUID" },
          { "name": "customer_id", "type": "UUID" },
          { "name": "amount", "type": "Decimal(10,2)" }
        ]
      }
    ]
  },
  "dashboards": ["orders_overview", "customer_analytics"]
}
```

## Data

### POST /api/v1/data/query

Execute a SQL query (authenticated only).

```bash
curl -X POST https://api.duet.company/api/v1/data/query \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "platform_id": "platform_123",
    "sql": "SELECT * FROM orders LIMIT 10"
  }'
```

### GET /api/v1/data/schema

Get platform schema.

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/data/schema?platform_id=platform_123
```

## Monitoring

### GET /api/v1/monitoring/metrics

Get platform metrics.

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/monitoring/metrics?platform_id=platform_123
```

**Response:**

```json
{
  "cpu_usage_percent": 45.2,
  "memory_usage_percent": 62.1,
  "query_latency_ms": 234,
  "queries_per_minute": 15
}
```

### GET /api/v1/monitoring/alerts

Get active alerts.

```bash
curl -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.duet.company/api/v1/monitoring/alerts
```

## Error Responses

All endpoints may return error responses:

```json
{
  "error": "Error message",
  "code": "ERROR_CODE",
  "details": {}
}
```

### Common Error Codes

| Code                | Description                       |
| ------------------- | --------------------------------- |
| UNAUTHORIZED        | Invalid or missing authentication |
| FORBIDDEN           | Insufficient permissions          |
| NOT_FOUND           | Resource not found                |
| VALIDATION_ERROR    | Invalid request data              |
| RATE_LIMIT_EXCEEDED | Too many requests                 |
| INTERNAL_ERROR      | Server error                      |

## Rate Limits

| Plan       | Requests per minute | Requests per day |
| ---------- | ------------------- | ---------------- |
| Starter    | 60                  | 10,000           |
| Growth     | 200                 | 50,000           |
| Enterprise | Unlimited           | Unlimited        |

## SDKs

Official SDKs are available for:

- **JavaScript/TypeScript** - `@duet-company/sdk`
- **Python** - `duet-company-python`
- **Go** - `github.com/duet-company/go-sdk`

## WebSocket API

Real-time updates are available via WebSocket:

```javascript
const ws = new WebSocket('wss://api.duet.company/ws');

ws.onmessage = (event) => {
  const data = JSON.parse(event.data);
  console.log('Update:', data);
};
```

## Interactive Documentation

Interactive API documentation is available when running locally:

```
http://localhost:8000/api/docs
```

## Next Steps

- [Agents Guide](../guides/agents.md) - Learn about AI agents
- [Deployment Guide](../guides/deployment.md) - Deploy the API
