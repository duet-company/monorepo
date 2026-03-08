# Sales Skill

Sales operations, lead management, deal tracking, and revenue forecasting for
Duet Company.

## 🎯 Purpose

Automates sales processes including lead generation, pipeline management, deal
tracking, revenue forecasting, customer relationship management (CRM), and sales
performance analytics.

## 🚀 Usage

```bash
# Via OpenClaw
@duyetbot Generate a sales forecast for Q2"

# Direct invocation
sales-skill "Create a new opportunity for enterprise deal"
```

## 📚 Dependencies

- CRM system (Salesforce, HubSpot, or custom)
- Lead database (ClickHouse, PostgreSQL)
- Email marketing tools
- Calendar integration (Google Calendar, Outlook)
- LLM provider (Claude, GPT-4, or GLM-5)
- Analytics platform (company dashboards)

## 🔧 Configuration

### Environment Variables

```bash
# CRM
CRM_PROVIDER=salesforce|hubspot|custom
CRM_API_KEY=***
CRM_DEFAULT_STAGE=prospecting

# Lead Scoring
LEAD_SCORING_ENABLED=true
LEAD_SCORE_THRESHOLD=70
LEAD_QUALITY_SCORE=80

# Deal Management
DEAL_STAGES=prospecting,qualified,proposal,negiation,closed-won,closed-lost
DEFAULT_DEAL_VALUE=50000

# Pipeline Management
PIPELINE_STAGES=discovery,qualification,presentation,proposal,negiation,closing
AVG_SALES_CYCLE=45
WIN_RATE_TARGET=25%

# Forecasting
FORECASTING_HORIZON_MONTHS=12
FORECASTING_MODEL=linear_trend
REVENUE_TREND_ANALYSIS=true

# Email & Calendar
EMAIL_PROVIDER=sendgrid|mailgun|ses
EMAIL_API_KEY=***
CALENDAR_PROVIDER=google|outlook
CALENDAR_API_KEY=***

# LLM
LLM_PROVIDER=claude|openai|zai
LLM_MODEL=claude-3-opus
LLM_API_KEY=***

# Analytics
ANALYTICS_URL=https://analytics.duet.ai
ANALYTICS_API_KEY=***
```

### Skill Configuration

```yaml
sales:
  crm:
    provider: ${CRM_PROVIDER}
    api_key: ${CRM_API_KEY}
    default_stage: ${CRM_DEFAULT_STAGE}

  lead_scoring:
    enabled: ${LEAD_SCORING_ENABLED}
    score_threshold: ${LEAD_SCORE_THRESHOLD}
    quality_threshold: ${LEAD_QUALITY_SCORE}

  pipeline:
    stages: ${PIPELINE_STAGES}
    avg_cycle_days: ${AVG_SALES_CYCLE}
    win_rate_target: ${WIN_RATE_TARGET}

  deal_management:
    stages: ${DEAL_STAGES}
    default_value: ${DEFAULT_DEAL_VALUE}

  forecasting:
    horizon_months: ${FORECASTING_HORIZON_MONTHS}
    model: ${FORECASTING_MODEL}
    revenue_trend_analysis: ${REVENUE_TREND_ANALYSIS}

  email:
    provider: ${EMAIL_PROVIDER}
    api_key: ${EMAIL_API_KEY}

  calendar:
    provider: ${CALENDAR_PROVIDER}
    api_key: ${CALENDAR_API_KEY}

  llm:
    provider: ${LLM_PROVIDER}
    model: ${LLM_MODEL}
    api_key: ${LLM_API_KEY}

  analytics:
    url: ${ANALYTICS_URL}
    api_key: ${ANALYTICS_API_KEY}
```

## 📖 Examples

### Lead Generation and Scoring

```markdown
User Request: "Score this lead from website signup"

Lead Scoring:

- Source: Website organic
- Industry: Technology/Software
- Company Size: 50-200 employees
- Role: Decision maker (CTO, VP Engineering)

Score Calculation:

- Industry match: +15
- Company size: +10
- Role authority: +20
- Website engagement: +5
- Email domain: +10
- Previous interactions: +0

**Total Score: 60/100**

Action: "Add lead to CRM with status: 'Qualified - Medium Priority'"
```

### Sales Pipeline Management

```markdown
User Request: "Create a sales pipeline for our enterprise target accounts"

Pipeline Stages:

1. **Discovery** (Weeks 1-2)
   - Account-based research
   - Identify key stakeholders
   - Map company structure
   - Find entry points
   - Initial outreach (email + LinkedIn)

2. **Qualification** (Weeks 3-4)
   - Need assessment
   - Budget verification
   - Timeline determination
   - Stakeholder identification
   - Technical feasibility study

3. **Proposal** (Weeks 5-8)
   - Solution demonstration
   - Technical presentation
   - Proof of concept
   - Value proposition
   - ROI analysis
   - Pricing discussion

4. **Negotiation** (Weeks 9-12)
   - Contract review
   - Terms discussion
   - Legal review
   - SLA negotiation
   - Procurement process
   - Stakeholder alignment

5. **Closing** (Weeks 13-16)
   - Final terms agreement
   - Contract signing
   - Implementation planning
   - Onboarding process
   - Kickoff meeting
   - First payment

Average Cycle: 16 weeks (4 months) Pipeline Health: 2 deals in progress, 1
stalled
```

### Revenue Forecasting

```markdown
User Request: "Generate a revenue forecast for Q2 2026"

Forecast Input:

- Current MRR: $10,000
- Current customers: 12
- Current churn rate: 3%
- Average deal size: $25,000/year
- Seasonal factors: Q2 typically 20% higher (new budget cycles)

Forecast Model: Linear Trend + Seasonal Adjustment

Q1 Actual: $25,000 Q2 Forecast: $30,000 (+20% seasonal) × 3% churn factor =
$29,100 Q3 Forecast: $32,000 (+7% trend) × 2% churn = $31,360 Q4 Forecast:
$35,000 (+9% trend) × 2% churn = $34,300

Total Q2: $29,100 Confidence: 85%

Breakdown:

- Existing customers: $28,000 (Q1 + growth)
- New deals Q2: $1,100 (estimated 44 prospects × 2.5% win rate × $25k)
- Churn impact: -$300 (12 customers × $25k × 3% × 33% churn)

Key Risks:

- ⚠️ Seasonal variability
- ⚠️ Enterprise deal uncertainty
- ⚠️ Budget timing risk

Actions:

- Focus on upsell to existing accounts (higher conversion)
- Accelerate deal cycle (reduce from 16 to 12 weeks)
- Early pipeline filling (ensure steady deal flow)

Analytics:

- Pipeline velocity: $25k/week average
- Conversion rate: 2.5% lead to qualified, 25% qualified to proposal
- Win rate target: 25% of qualified deals
- Average deal size: $25k

Dashboard: https://analytics.duet.ai/sales/q2-forecast
```

### CRM Integration

```markdown
User Request: "Create a new opportunity in Salesforce"

CRM Action:

Account: Acme Technology Contact: Jane Smith (CTO) Lead: Duet Company Platform -
Enterprise Analytics Value: $50,000/year Stage: Proposal Probability: 60%

Tasks Created:

1. [x] Create account in Salesforce
2. [x] Create contact record
3. [x] Create opportunity
4. [x] Add lead source (Website - Organic)
5. [x] Add scoring details (Score: 60, Priority: Medium)
6. [x] Link opportunity to lead campaign
7. [ ] Schedule follow-up tasks
8. [ ] Create proposal presentation

Next Actions:

- Schedule discovery call with CTO
- Send technical qualification questionnaire
- Prepare demo environment
- Create custom pricing proposal

Timeline: Discovery (2 weeks) → Qualification (1 week) → Proposal (1 week) →
Negotiation (4 weeks)

Revenue Impact: $50k recognized in Q2 if won Probability: 60% × $50k = $30k
expected value
```

### Sales Performance Analytics

```markdown
User Request: "Show me our sales performance this quarter"

Quarterly Metrics (Q1 2026):

Pipeline Metrics:

- Total leads: 234
- Qualified leads: 89 (38%)
- Proposals sent: 47
- Active opportunities: 23
- Pipeline value: $1.2M
- Pipeline velocity: 1.8 months

Deal Metrics:

- Deals won: 7
- Deals lost: 4
- Deals in progress: 12
- Win rate: 32% (7 / (7+4+12))
- Average deal size: $28,500
- Total revenue: $199,500

Sales Team Metrics:

- Active reps: 3
- Activities logged: 1,247
- Calls made: 456
- Demos given: 23
- Avg activities/rep: 416
- Avg calls/rep: 152

Performance vs Targets:

- Revenue target: $250,000
- Revenue actual: $199,500 (80% of target)
- Win rate target: 30%
- Win rate actual: 32% ✅
- Activity target: 500/rep
- Activity actual: 416/rep (83%)

Insights: ✅ Win rate exceeded target by 2% ⚠️ Revenue missed target by 20% ✅
Team activity strong ✅ Pipeline healthy with good velocity

Recommendations:

1. Focus on larger deals (improve avg deal size)
2. Accelerate proposal stage (reduce cycle time)
3. Increase lead qualification rate (better pipeline health)
4. Add more activities to early pipeline stages

Forecast Q2: Based on Q1 performance:

- Expected Q2 revenue: $240,000 (20% growth)
- Pipeline value target: $1.5M
- Win rate target: 30%
- Leads needed: 280

Dashboard: https://analytics.duet.ai/sales/q1-performance
```

## 🐛 Troubleshooting

### Issue: Lead scoring not accurate

**Possible causes:**

- Insufficient training data
- Outdated scoring model
- Feature mismatch
- Industry bias in scoring

**Solutions:**

1. Retrain model: `sales-skill --retrain-scoring`
2. Update features: Review and adjust weights
3. A/B test new model: `sales-skill --test-scoring-model`
4. Monitor accuracy: Track conversion by score quintile
5. Add manual overrides: Allow sales reps to adjust scores

### Issue: Pipeline blocked

**Possible causes:**

- Resource constraints (limited sales reps)
- Technical dependencies (waiting on product features)
- Market conditions (budget freezes)
- Stakeholder availability
- Process bottlenecks

**Solutions:**

1. Unblock dependencies: Prioritize with product team
2. Resource allocation: Consider hiring or contractor
3. Process optimization: Remove unnecessary steps
4. Market adaptation: Adjust messaging for budget-conscious buyers
5. Timeline management: Set expectations with customers

### Issue: Forecast accuracy declining

**Possible causes:**

- Market volatility increased
- Competitive landscape changed
- Customer churn higher than expected
- New product pricing
- Sales process changes

**Solutions:**

1. Reduce forecast horizon: `sales-skill --forecast-horizon=6` (from 12 months)
2. Adjust model: `sales-skill --switch-model=arima` (time series)
3. Add external factors: Incorporate market data
4. Increase scenario planning: Best/worst/most likely cases
5. Monitor real-time: Update forecasts based on actuals

## 📊 Sales Metrics

### KPIs We Track

| Category | Metric              | Target | Current | Status |
| -------- | ------------------- | ------ | ------- | ------ |
| Pipeline | Lead Qualification  | > 40%  | 38%     | ⚠️     |
| Pipeline | Proposal Conversion | > 25%  | 18%     | ⚠️     |
| Pipeline | Win Rate            | > 30%  | 32%     | ✅     |
| Revenue  | MRR Growth          | > 20%  | 15%     | ⚠️     |
| Revenue  | Forecast Accuracy   | ± 10%  | 15%     | ⚠️     |
| Deals    | Average Size        | > $30k | $28.5k  | ⚠️     |
| Team     | Activity/Rep        | > 400  | 416     | ✅     |

### Funnel Metrics

```
Website Visitors (10,000/month)
    ↓
    Lead Captures (15%) → 1,500 leads/month
    ↓
    Qualification (38%) → 570 qualified leads
    ↓
    Proposals (18%) → 103 proposals
    ↓
    Negotiation (40%) → 41 opportunities
    ↓
    Closing (50%) → 21 wins
    ↓
    Average Deal Size × Wins = $28.5k × 21 = $598,500/month

Conversion Rates:
- Visitor → Lead: 15%
- Lead → Qualified: 38%
- Qualified → Proposal: 18%
- Proposal → Opp: 43%
- Opp → Win: 50%
- Overall: 0.5% (6% of visitors convert to $598.500/mo)
```

## 🔗 Related Skills

- [Company Operations](./company-skill.md) - Overall company management
- [Project Management](./project-skill.md) - Project tracking
- [Marketing Skill](./marketing-skill.md) - Lead generation and brand
- [GitHub Operations](./github-skill.md) - Repository management

## 📖 References

- [CRM Documentation](https://developer.salesforce.com/)
- [Sales Playbook](https://github.com/duet-company/playbook/blob/main/sales/)
- [Revenue Recognition](https://github.com/duet-company/playbook/blob/main/finance/revenue.md)
- [Sales Training](https://github.com/duet-company/playbook/blob/main/team/training.md)
- [Analytics Dashboard](https://analytics.duet.ai)

---

**Skill Version:** 1.0.0 **Last Updated:** 2026-02-16 **Maintainer:** Duet
Company Sales
