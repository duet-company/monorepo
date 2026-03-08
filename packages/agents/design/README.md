# Platform Designer Agent

AI-powered infrastructure and schema designer for Duet Company.

## 🎯 Purpose

Automates data platform design from natural language requirements:

- Schema design
- Infrastructure provisioning
- Dashboard creation
- Configuration management

## 🚀 Features

- Requirement parsing and understanding
- Optimal schema design
- Automated infrastructure provisioning
- Template-based dashboard generation

## 🧠 Models

Supports multiple LLM providers:

- Claude (Anthropic)
- GPT-4 (OpenAI)
- GLM-5 (Z.AI)

## 🏗️ Infrastructure

Automates provisioning of:

- ClickHouse clusters
- PostgreSQL databases
- Kubernetes resources
- Monitoring and logging
- Data pipelines

## 🔗 Integration

- **Backend:** https://github.com/duet-company/backend
- **Infrastructure:** https://github.com/duet-company/infrastructure
- **Docs:** https://github.com/duet-company/docs

## 📖 Usage

```python
from agents.design import PlatformDesigner

designer = PlatformDesigner(model="claude-3-opus")

result = designer.design("""
I need an e-commerce analytics platform with:
- Daily sales and revenue tracking
- Customer behavior analysis
- Product performance metrics
- Real-time data ingestion
""")

print(result.schema)  # ClickHouse schema
print(result.infrastructure)  # K8s manifests
print(result.dashboards)  # Grafana dashboard configs
```

## 🧪 Testing

```bash
# Run tests
pytest tests/

# Validate generated infrastructure
terraform validate infrastructure/

# Preview changes
terraform plan infrastructure/
```

## 📚 Resources

- [Infrastructure Guide](../../infrastructure/README.md)
- [ClickHouse Schema Design](../../docs/guides/schema-design.md)
- [Kubernetes Setup](../../infrastructure/kubernetes/README.md)
