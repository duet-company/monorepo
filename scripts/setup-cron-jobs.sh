#!/bin/bash

# OpenClaw Cron Job Setup Script
# This script sets up all autonomous agent cron jobs

set -e

echo "🚀 Setting up autonomous agent cron jobs..."
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Function to add cron job
add_cron_job() {
    local name="$1"
    local schedule_type="$2"
    local schedule_value="$3"
    local message="$4"
    local enabled="${5:-true}"

    echo "📋 Adding cron job: $name"

    # Construct JSON payload based on schedule type
    if [ "$schedule_type" = "every" ]; then
        schedule_json="{\"kind\":\"every\",\"everyMs\":$schedule_value}"
    elif [ "$schedule_type" = "cron" ]; then
        schedule_json="{\"kind\":\"cron\",\"expr\":\"$schedule_value\",\"tz\":\"Asia/Saigon\"}"
    else
        echo -e "${RED}❌ Invalid schedule type: $schedule_type${NC}"
        return 1
    fi

    # Add cron job using OpenClaw CLI
    openclaw cron add \
        --name "$name" \
        --schedule "$schedule_json" \
        --sessionTarget "isolated" \
        --payload "{\"kind\":\"agentTurn\",\"message\":\"$message\",\"model\":\"zai/glm-4.7\"}" \
        --enabled "$enabled"

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Added: $name${NC}"
    else
        echo -e "${RED}❌ Failed: $name${NC}"
        return 1
    fi
    echo ""
}

# Check if OpenClaw CLI is available
if ! command -v openclaw &> /dev/null; then
    echo -e "${RED}❌ OpenClaw CLI not found${NC}"
    echo "Please install OpenClaw CLI first"
    exit 1
fi

echo "🔧 Daily Jobs"
echo "================================"

# Product Manager - Daily Review
add_cron_job \
    "product-manager-daily-review" \
    "every" \
    "43200000" \
    "=== PRODUCT MANAGER AGENT - DAILY REVIEW ===\n\nTASK: Review and prioritize backlog\n\nSTEPS:\n1. Check kanboard/ backlog column\n2. Review all open issues\n3. Prioritize based on business value and urgency\n4. Move high-priority items to \"Sprint Planning\"\n5. Add appropriate labels (priority, type, sprint)\n6. Update progress on vision/ROADMAP.md"

# Engineering Agent - Task Check
add_cron_job \
    "engineering-agent-task-check" \
    "every" \
    "3600000" \
    "=== ENGINEERING AGENT - TASK CHECK ===\n\nTASK: Check for available tasks\n\nSTEPS:\n1. Query kanboard/ \"Sprint Planning\" column\n2. Filter by: status:ready, not assigned, in current sprint\n3. For each matching task:\n   - Assess if it matches my skills\n   - Self-assign to task\n   - Move to \"In Progress\"\n   - Comment: \"Working on this...\"\n   - Start implementation\n4. Update progress on in-progress tasks\n5. If ready for review, create PR, move to \"Code Review\""

# Documentation Agent - Daily Sync
add_cron_job \
    "documentation-agent-daily-sync" \
    "every" \
    "43200000" \
    "=== DOCUMENTATION AGENT - DAILY SYNC ===\n\nTASK: Sync docs with code changes\n\nSTEPS:\n1. Check recent commits in all repositories\n2. Identify code changes affecting documentation\n3. Update docs/ accordingly\n4. Fix broken links and errors\n5. Respond to documentation issues"

# Content Agent - Daily
add_cron_job \
    "content-agent-daily" \
    "every" \
    "43200000" \
    "=== CONTENT AGENT - DAILY TASKS ===\n\nTASK: Create and manage content\n\nSTEPS:\n1. Research trending topics in AI, tech, industry\n2. Write blog post for company blog\n3. Update website content as needed\n4. Optimize content for SEO\n5. Review and edit content"

echo "📊 Weekly Jobs"
echo "================================"

# Product Manager - Weekly Review
add_cron_job \
    "product-manager-weekly" \
    "cron" \
    "0 9 * * 5" \
    "=== PRODUCT MANAGER AGENT - WEEKLY REVIEW ===\n\nTASK: Sprint review and planning\n\nSTEPS:\n1. Review completed tasks from current sprint\n2. Generate sprint summary\n3. Update vision/OKR.md with progress\n4. Identify tasks for next sprint\n5. Create sprint planning issue in kanboard/\n6. Tag team for input"

# Analytics Agent - Weekly Report
add_cron_job \
    "analytics-agent-weekly" \
    "cron" \
    "0 10 * * 5" \
    "=== ANALYTICS AGENT - WEEKLY REPORT ===\n\nTASK: Generate weekly analytics report\n\nSTEPS:\n1. Collect data from GitHub, infrastructure, business systems\n2. Run analytics queries\n3. Generate weekly report in analytics/reports/weekly.md\n4. Update Grafana dashboards\n5. Identify trends and anomalies\n6. Create actionable recommendations"

echo "🚨 Continuous Monitoring"
echo "================================"

# Operations Agent - Monitoring
add_cron_job \
    "operations-agent-monitoring" \
    "every" \
    "300000" \
    "=== OPERATIONS AGENT - SYSTEM MONITOR ===\n\nTASK: Monitor system health\n\nSTEPS:\n1. Check Prometheus/Grafana alerts\n2. Review system metrics\n3. Check service health\n4. Review recent logs for errors\n5. If issues found, create incident issue and resolve"

# Security Agent - Monitoring
add_cron_job \
    "security-agent-monitoring" \
    "every" \
    "1800000" \
    "=== SECURITY AGENT - SECURITY MONITOR ===\n\nTASK: Monitor security posture\n\nSTEPS:\n1. Review security logs and alerts\n2. Check for unauthorized access attempts\n3. Review recent PRs for security issues\n4. Check dependency vulnerabilities\n5. If issues found, create security issue and resolve"

echo "📅 Monthly Jobs"
echo "================================"

# Security Agent - Monthly Audit
add_cron_job \
    "security-agent-monthly-audit" \
    "cron" \
    "0 9 1 * *" \
    "=== SECURITY AGENT - MONTHLY AUDIT ===\n\nTASK: Perform comprehensive security audit\n\nSTEPS:\n1. Review all security configurations\n2. Audit access controls and permissions\n3. Review secrets management\n4. Perform security scan on all code\n5. Generate security report\n6. Identify vulnerabilities and risks\n7. Create remediation issues"

# Analytics Agent - Monthly Report
add_cron_job \
    "analytics-agent-monthly" \
    "cron" \
    "0 10 1 * *" \
    "=== ANALYTICS AGENT - MONTHLY REPORT ===\n\nTASK: Generate comprehensive monthly report\n\nSTEPS:\n1. Collect and analyze all monthly data\n2. Generate monthly report in analytics/reports/monthly.md\n3. Analyze trends and patterns\n4. Compare to previous months\n5. Identify key insights and recommendations\n6. Update all dashboards\n7. Track OKR progress"

echo ""
echo "================================"
echo "✅ All cron jobs configured!"
echo "================================"
echo ""
echo "📋 To list all cron jobs:"
echo "   openclaw cron list"
echo ""
echo "📊 To view job runs:"
echo "   openclaw cron runs <job-id>"
echo ""
echo "🚀 To run a job immediately:"
echo "   openclaw cron run <job-id>"
echo ""
