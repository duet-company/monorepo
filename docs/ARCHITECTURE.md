# Duet Company - Technical Architecture

## System Overview

```
┌─────────────────────────────────────────────────────────────┐
│                     Duet Company Platform                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐       │
│  │   Natural    │  │   AI Agent   │  │  Monitoring  │       │
│  │ Language     │  │ Orchestrator │  │   Dashboard  │       │
│  │  Interface   │  │              │  │              │       │
│  └──────┬───────┘  └──────┬───────┘  └──────┬───────┘       │
│         │                 │                  │               │
│  ┌──────▼─────────────────▼──────────────────▼───────┐      │
│  │              API Gateway & Authentication         │      │
│  └────────────────────────────────────────────────────┘      │
│                              │                                 │
│  ┌───────────────────────────▼───────────────────────────┐  │
│  │                    AI Agent Framework                  │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │  │
│  │  │  Query   │  │ Platform │  │ Support  │  │  Ops   │ │  │
│  │  │  Agent   │  │ Designer │  │  Agent   │  │ Agent  │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                              │                                 │
│  ┌───────────────────────────▼───────────────────────────┐  │
│  │                 Data Orchestration Layer                 │  │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐  ┌────────┐ │  │
│  │  │  Stream  │  │  Batch   │  │   ML     │  │  RAG   │ │  │
│  │  │ Ingestion│  │ Processing│ │  Models  │  │ System │ │  │
│  │  └──────────┘  └──────────┘  └──────────┘  └────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                              │                                 │
│  ┌───────────────────────────▼───────────────────────────┐  │
│  │                  Data Storage Layer                    │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │  │
│  │  │  ClickHouse  │  │  PostgreSQL  │  │   Qdrant     │ │  │
│  │  │  (Analytics) │  │  (Metadata) │  │  (Vectors)   │ │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                              │                                 │
│  ┌───────────────────────────▼───────────────────────────┐  │
│  │              Infrastructure & Orchestration             │  │
│  │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐ │  │
│  │  │ Kubernetes   │  │   Docker     │  │    CI/CD     │ │  │
│  │  │  (microk8s)  │  │  Containers  │  │ GitHub Actions│ │  │
│  │  └──────────────┘  └──────────────┘  └──────────────┘ │  │
│  └───────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

## Component Details

### 1. API Gateway & Authentication

**Technology:**

- Kong or Envoy (API gateway)
- OAuth 2.0 / OpenID Connect
- JWT tokens
- Rate limiting
- Request logging

**Endpoints:**

```bash
# Platform management
POST   /api/v1/platforms              # Create platform
GET    /api/v1/platforms              # List platforms
GET    /api/v1/platforms/{id}         # Get platform details
PUT    /api/v1/platforms/{id}         # Update platform
DELETE /api/v1/platforms/{id}         # Delete platform

# AI agents
POST   /api/v1/agents/query           # Natural language query
POST   /api/v1/agents/design          # Platform design request
POST   /api/v1/agents/optimize        # Query optimization
POST   /api/v1/agents/analyze         # Data analysis

# Data operations
POST   /api/v1/data/ingest            # Ingest data
GET    /api/v1/data/query             # Execute query
POST   /api/v1/data/export            # Export data

# Monitoring
GET    /api/v1/monitoring/metrics     # Platform metrics
GET    /api/v1/monitoring/alerts      # Active alerts
GET    /api/v1/monitoring/logs        # System logs
```

### 2. AI Agent Framework

**Core Components:**

#### Agent Orchestrator

```typescript
interface Agent {
  id: string;
  type: 'query' | 'design' | 'support' | 'ops';
  model: 'claude' | 'gpt4' | 'glm5';
  capabilities: string[];
  tools: Tool[];
}

interface Tool {
  name: string;
  description: string;
  execute: (input: any) => Promise<any>;
  validation: (input: any) => boolean;
}

class AgentOrchestrator {
  async route(request: AgentRequest): Promise<AgentResponse> {
    // 1. Analyze request type
    // 2. Select appropriate agent
    // 3. Execute with tools
    // 4. Validate response
    // 5. Return results
  }
}
```

#### Query Agent

**Capabilities:**

- Natural language to SQL translation
- Query optimization
- Result visualization
- Explainable AI (showing generated SQL)

**Tools:**

- SQL generation (ClickHouse SQL)
- Query execution
- Result formatting
- Visualization generation

#### Platform Designer Agent

**Capabilities:**

- Schema design from requirements
- Infrastructure provisioning
- Dashboard creation
- Data connector setup

**Tools:**

- ClickHouse schema generation
- Kubernetes deployment
- Grafana dashboard templates
- Data connector SDK

#### Support Agent

**Capabilities:**

- 24/7 customer support
- Issue diagnosis and resolution
- Knowledge base access
- Ticket management

**Tools:**

- Documentation search (RAG)
- Log analysis
- System health checks
- Ticket creation

#### Ops Agent

**Capabilities:**

- Infrastructure monitoring
- Auto-scaling
- Self-healing
- Cost optimization

**Tools:**

- Prometheus metrics
- Kubernetes API
- Alert management
- Cost calculation

### 3. Data Orchestration Layer

#### Stream Ingestion

```yaml
# Apache Kafka + ClickHouse Kafka Engine
topics:
  - name: events
    partitions: 12
    replication_factor: 3
    retention: 7d

clickhouse_tables:
  - name: events_stream
    engine: MergeTree
    order_by: (timestamp, event_type)
    partition_by: toYYYYMM(timestamp)
```

#### Batch Processing

```python
# Airflow DAGs for batch jobs
from airflow import DAG
from airflow.providers.clickhouse.operators.clickhouse import ClickHouseOperator

dag = DAG(
    'daily_aggregation',
    schedule_interval='0 2 * * *',
    catchup=False
)

aggregate_task = ClickHouseOperator(
    task_id='aggregate_daily',
    sql='''
    INSERT INTO daily_metrics
    SELECT
        toStartOfDay(timestamp) as day,
        event_type,
        count() as events,
        avg(value) as avg_value
    FROM events_stream
    WHERE timestamp >= now() - INTERVAL 1 DAY
    GROUP BY day, event_type
    ''',
    dag=dag
)
```

#### ML Models

```python
# Anomaly detection using Isolation Forest
from sklearn.ensemble import IsolationForest

class AnomalyDetector:
    def __init__(self):
        self.model = IsolationForest(
            contamination=0.1,
            random_state=42
        )
        self.fitted = False

    def fit(self, data):
        self.model.fit(data)
        self.fitted = True

    def detect(self, data):
        return self.model.predict(data)  # -1 = anomaly
```

#### RAG System

```python
# LlamaIndex + Qdrant
from llama_index.core import VectorStoreIndex, Document
from llama_index.vector_stores.qdrant import QdrantVectorStore

class KnowledgeBase:
    def __init__(self):
        self.vector_store = QdrantVectorStore(
            collection_name="docs",
            client=qdrant_client
        )
        self.index = VectorStoreIndex.from_vector_store(
            self.vector_store
        )

    def search(self, query: str, top_k: int = 5):
        query_engine = self.index.as_query_engine(
            similarity_top_k=top_k
        )
        response = query_engine.query(query)
        return response
```

### 4. Data Storage Layer

#### ClickHouse Configuration

```sql
-- ClickHouse configuration for analytics
CREATE DATABASE IF NOT EXISTS analytics;

-- Events table (high write volume)
CREATE TABLE IF NOT EXISTS analytics.events (
    timestamp DateTime64(3),
    event_type String,
    user_id UInt64,
    properties JSON,
    value Float64
)
ENGINE = MergeTree()
ORDER BY (timestamp, event_type)
PARTITION BY toYYYYMM(timestamp)
SETTINGS index_granularity = 8192;

-- Materialized view for real-time aggregates
CREATE MATERIALIZED VIEW IF NOT EXISTS analytics.events_hourly_mv
ENGINE = SummingMergeTree()
ORDER BY (hour, event_type)
AS SELECT
    toStartOfHour(timestamp) as hour,
    event_type,
    count() as events,
    sum(value) as total_value
FROM analytics.events
GROUP BY hour, event_type;

-- Aggregated table for fast queries
CREATE TABLE IF NOT EXISTS analytics.events_hourly (
    hour DateTime,
    event_type String,
    events UInt64,
    total_value Float64
)
ENGINE = SummingMergeTree()
ORDER BY (hour, event_type);
```

#### PostgreSQL (Metadata)

```sql
-- User management
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email VARCHAR(255) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    subscription_tier VARCHAR(50)
);

-- Platform configurations
CREATE TABLE platforms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    config JSONB NOT NULL,
    status VARCHAR(50) DEFAULT 'provisioning'
);

-- Audit logs
CREATE TABLE audit_logs (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    platform_id UUID REFERENCES platforms(id),
    agent_id VARCHAR(100),
    action VARCHAR(255),
    details JSONB,
    timestamp TIMESTAMP DEFAULT NOW()
);
```

#### Qdrant (Vectors)

```python
from qdrant_client import QdrantClient
from qdrant_client.models import Distance, VectorParams

client = QdrantClient(url="http://localhost:6333")

client.create_collection(
    collection_name="documentation",
    vectors_config=VectorParams(size=1536, distance=Distance.COSINE)
)
```

### 5. Infrastructure Layer

#### Kubernetes Deployment

```yaml
# ClickHouse deployment
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: clickhouse
spec:
  serviceName: clickhouse
  replicas: 3
  selector:
    matchLabels:
      app: clickhouse
  template:
    metadata:
      labels:
        app: clickhouse
    spec:
      containers:
        - name: clickhouse
          image: clickhouse/clickhouse-server:latest
          ports:
            - containerPort: 8123
            - containerPort: 9000
          volumeMounts:
            - name: data
              mountPath: /var/lib/clickhouse
  volumeClaimTemplates:
    - metadata:
        name: data
      spec:
        accessModes: ['ReadWriteOnce']
        resources:
          requests:
            storage: 100Gi
```

#### CI/CD Pipeline

```yaml
# .github/workflows/deploy.yml
name: Deploy
on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Deploy to Kubernetes
        run: |
          kubectl apply -f k8s/
          kubectl rollout restart deployment/api-gateway
```

## Security Architecture

### Authentication Flow

```
1. User logs in via OAuth (Google/GitHub)
2. JWT token issued with user claims
3. Token stored in HTTP-only cookie
4. All API requests validated via JWT
5. Role-based access control (RBAC)
```

### Data Encryption

- **At rest:** AES-256 encryption (database + volumes)
- **In transit:** TLS 1.3
- **Keys:** Managed via HashiCorp Vault

### Zero-Trust Architecture

- Network segmentation (micro-segments)
- Service mesh (Istio) for mTLS
- Secrets management via Vault
- Regular security audits

## Monitoring & Observability

### Metrics (Prometheus)

```yaml
# ClickHouse metrics
- clickhouse_query_duration_seconds
- clickhouse_rows_read
- clickhouse_rows_written
- clickhouse_memory_usage

# Agent metrics
- ai_agent_requests_total
- ai_agent_duration_seconds
- ai_agent_errors_total

# Business metrics
- platform_active_users
- platform_queries_per_hour
- platform_storage_usage_bytes
```

### Logging

- Structured JSON logs
- Centralized in Loki
- Log retention: 30 days
- Sensitive data redaction

### Tracing (Jaeger)

- Distributed tracing across microservices
- Performance bottleneck identification
- End-to-end request flow visualization

## Scaling Strategy

### Horizontal Scaling

- Stateless API services: Auto-scale based on CPU/memory
- ClickHouse: Add shards for read/write scaling
- Kafka: Add partitions for throughput

### Vertical Scaling

- ClickHouse nodes: Scale up memory for large queries
- Vector databases: Scale up for faster similarity search

### Cost Optimization

- Auto-scale down during low traffic
- Spot instances for non-critical workloads
- Tiered storage (hot/warm/cold)

## Disaster Recovery

### Backup Strategy

- **ClickHouse:** Daily snapshots + continuous binlog
- **PostgreSQL:** Point-in-time recovery (WAL)
- **Qdrant:** Daily backups + replication

### RPO/RTO Targets

- **RPO:** < 1 minute (data loss tolerance)
- **RTO:** < 15 minutes (recovery time)

### Geographic Distribution

- Multi-region deployment
- Active-passive failover
- DNS-based traffic routing

## Performance Benchmarks

### Target Performance

- **Query latency:** P95 < 1s for 1B rows
- **Write throughput:** 1M events/sec
- **Concurrent users:** 10,000+
- **Availability:** 99.9% SLA

### Optimization Techniques

- Materialized views for common queries
- Pre-aggregated tables
- Query result caching (Redis)
- CDN for static assets

---

**Implementation Priority:**

1. Foundation (K8s + ClickHouse)
2. API Gateway + Auth
3. Core agents (Query + Designer)
4. Monitoring + Logging
5. Advanced agents (Support + Ops)
6. ML models + RAG
