# Support Agent

24/7 AI-powered customer support for Duet Company platform.

## 🎯 Purpose

Provides intelligent, context-aware customer support:
- Answer common questions
- Troubleshoot issues
- Guide users through features
- Escalate complex problems

## 🚀 Features

- Natural language understanding
- Knowledge base integration
- Context-aware responses
- Proactive issue detection
- Human handoff when needed

## 🧠 Models

Supports multiple LLM providers:
- Claude (Anthropic)
- GPT-4 (OpenAI)
- GLM-5 (Z.AI)

## 📚 Knowledge Base

Integrates with:
- [Documentation](../../docs/)
- [Troubleshooting guides](../../playbook/operations/troubleshooting.md)
- [FAQ](../../docs/support/faq.md)
- [Platform features](https://github.com/duet-company/platform)

## 🔗 Integration

- **Backend:** https://github.com/duet-company/backend
- **Docs:** https://github.com/duet-company/docs
- **Playbook:** https://github.com/duet-company/playbook

## 📖 Usage

```python
from agents.support import SupportAgent

agent = SupportAgent(model="claude-3-opus", knowledge_base="./docs")

response = agent.respond("""
How do I connect my PostgreSQL database to the platform?
""")

print(response.answer)  # Detailed answer
print(response.relevant_docs)  # Related documentation links
```

## 🧪 Testing

```bash
# Run tests
pytest tests/

# Test with different knowledge sources
KNOWLEDGE_BASE=docs pytest tests/

# Evaluate response quality
python tests/evaluate_quality.py
```

## 📈 Metrics

Tracks:
- Resolution rate
- Customer satisfaction
- Escalation rate
- Response time
- Knowledge base coverage

## 📚 Resources

- [Support Playbook](../../playbook/agents/support-agent.md)
- [Customer Onboarding](../../playbook/customers/onboarding.md)
- [FAQ](../../docs/support/faq.md)
