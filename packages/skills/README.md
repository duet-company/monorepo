# Duet Company - Skills

AI agent skills and documentation for autonomous operations.

## 📁 Skills Structure

This repository contains OpenClaw-compatible AI agent skills (.md files).

### Skills Available

- **query-skill.md** - Natural language to SQL translation
- **design-skill.md** - Platform design and infrastructure automation
- **support-skill.md** - Customer support and troubleshooting
- **ops-skill.md** - Operations and monitoring automation
- **data-skill.md** - Data engineering and pipeline management

## 🧩 Skill Format

Each skill follows the OpenClaw SKILL.md format:

```markdown
# Skill Name

Short description of what this skill does.

## 🎯 Purpose

What problem does this skill solve?

## 🚀 Usage

How to use this skill with code examples.

## 📚 Dependencies

What other skills/tools are needed?

## 🔧 Configuration

Any required configuration or environment variables.

## 📖 Examples

Real-world usage examples.

## 🐛 Troubleshooting

Common issues and solutions.
```

## 🔗 Integration

- **Platform:** https://github.com/duet-company/platform
- **Backend:** https://github.com/duet-company/backend
- **Frontend:** https://github.com/duet-company/frontend

## 📖 Documentation

- [OpenClaw Skills Guide](https://docs.openclaw.ai/skills)
- [Skill Development](https://docs.openclaw.ai/developing-skills)
- [AI Agent Architecture](https://github.com/duet-company/vision/blob/main/ARCHITECTURE.md)

## 🧪 Testing

```bash
# Test all skills
./scripts/test-skills.sh

# Test specific skill
./scripts/test-skill.sh query-skill
```

## 🤝 Contributing

1. Follow the SKILL.md format
2. Include usage examples
3. Document dependencies
4. Add troubleshooting section
5. Test before submitting

---

**Maintainer:** AI Engineering Team **Last Updated:** 2026-02-16
