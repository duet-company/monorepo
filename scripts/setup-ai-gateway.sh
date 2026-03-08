#!/bin/bash
# Cloudflare AI Gateway Setup Script
# This script creates and configures the AI Gateway

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Cloudflare AI Gateway Setup ===${NC}\n"

# Check required environment variables
if [ -z "$CLOUDFLARE_API_TOKEN" ]; then
    echo -e "${RED}Error: CLOUDFLARE_API_TOKEN is not set${NC}"
    echo "Set it with: export CLOUDFLARE_API_TOKEN=your_token"
    exit 1
fi

if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
    echo -e "${YELLOW}Warning: CLOUDFLARE_ACCOUNT_ID not set, fetching from Cloudflare...${NC}"
    # Try to get account ID from API
    ACCOUNTS=$(curl -s "https://api.cloudflare.com/client/v4/accounts" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json")

    CLOUDFLARE_ACCOUNT_ID=$(echo "$ACCOUNTS" | jq -r '.result[0].id // empty')

    if [ -z "$CLOUDFLARE_ACCOUNT_ID" ]; then
        echo -e "${RED}Error: Could not fetch account ID${NC}"
        exit 1
    fi
    echo -e "${GREEN}Found Account ID: $CLOUDFLARE_ACCOUNT_ID${NC}"
fi

# Gateway configuration
GATEWAY_NAME="${GATEWAY_NAME:-duet-company-prod}"
GATEWAY_ID="${GATEWAY_ID:-}"

echo -e "${BLUE}Creating AI Gateway: $GATEWAY_NAME${NC}\n"

# Create AI Gateway
if [ -z "$GATEWAY_ID" ]; then
    echo -e "${YELLOW}Creating new gateway...${NC}"

    GATEWAY_RESPONSE=$(curl -s -X POST \
        "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/gateway" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "name": "'"$GATEWAY_NAME"'",
            "type": "ai_gateway"
        }')

    GATEWAY_ID=$(echo "$GATEWAY_RESPONSE" | jq -r '.result.uid // empty')

    if [ -z "$GATEWAY_ID" ]; then
        echo -e "${RED}Failed to create gateway${NC}"
        echo "Response: $GATEWAY_RESPONSE"
        exit 1
    fi

    echo -e "${GREEN}✓ Gateway created with ID: $GATEWAY_ID${NC}\n"
else
    echo -e "${GREEN}Using existing Gateway ID: $GATEWAY_ID${NC}\n"
fi

# Configure providers
echo -e "${BLUE}Configuring AI providers...${NC}\n"

# OpenAI Provider
if [ -n "$OPENAI_API_KEY" ]; then
    echo -e "${YELLOW}Setting up OpenAI provider...${NC}"
    curl -s -X PUT \
        "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/gateway/providers/openai" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "credentials": [
                {
                    "api_token": "'"$OPENAI_API_KEY"'",
                    "type": "openai_api_token",
                    "name": "openai_key"
                }
            ]
        }' > /dev/null

    echo -e "${GREEN}✓ OpenAI configured${NC}"
fi

# Anthropic Provider
if [ -n "$ANTHROPIC_API_KEY" ]; then
    echo -e "${YELLOW}Setting up Anthropic provider...${NC}"
    curl -s -X PUT \
        "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/gateway/providers/anthropic" \
        -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
        -H "Content-Type: application/json" \
        -d '{
            "credentials": [
                {
                    "api_token": "'"$ANTHROPIC_API_KEY"'",
                    "type": "anthropic_api_token",
                    "name": "anthropic_key"
                }
            ]
        }' > /dev/null

    echo -e "${GREEN}✓ Anthropic configured${NC}"
fi

echo -e "\n${BLUE}Configuring caching and rate limits...${NC}\n"

# Set up caching
curl -s -X POST \
    "https://api.cloudflare.com/client/v4/accounts/$CLOUDFLARE_ACCOUNT_ID/ai/gateway/settings" \
    -H "Authorization: Bearer $CLOUDFLARE_API_TOKEN" \
    -H "Content-Type: application/json" \
    -d '{
        "cache_enabled": true,
        "cache_ttl": 3600,
        "rate_limiting": {
            "enabled": true,
            "limits": [
                {
                    "model": "*",
                    "requests_per_minute": 100
                }
            ]
        }
    }' > /dev/null

echo -e "${GREEN}✓ Caching and rate limits configured${NC}"

# Update wrangler.toml with gateway ID
echo -e "\n${BLUE}Updating wrangler.toml...${NC}\n"
sed -i "s/gateway_id = \"YOUR_GATEWAY_ID\"/gateway_id = \"$GATEWAY_ID\"/" infrastructure/cloudflare/wrangler.toml
sed -i "s/CLOUDFLARE_AI_GATEWAY_ID = \"YOUR_GATEWAY_ID\"/CLOUDFLARE_AI_GATEWAY_ID = \"$GATEWAY_ID\"/" infrastructure/cloudflare/wrangler.toml

echo -e "${GREEN}✓ wrangler.toml updated${NC}"

# Test gateway
echo -e "\n${BLUE}Testing AI Gateway...${NC}\n"
TEST_RESPONSE=$(curl -s -X POST \
    "https://gateway.ai.cloudflare.com/v1/openai/gpt-3.5-turbo" \
    -H "Authorization: Bearer $OPENAI_API_KEY" \
    -H "Content-Type: application/json" \
    -H "CF-Gateway-ID: $GATEWAY_ID" \
    -d '{
        "messages": [{"role": "user", "content": "Say AI Gateway configured"}],
        "max_tokens": 10
    }' || echo '{"error": "Test failed"}')

if echo "$TEST_RESPONSE" | jq -e '.choices[0].message.content' > /dev/null 2>&1; then
    echo -e "${GREEN}✓ AI Gateway is working!${NC}"
    echo "Response: $(echo "$TEST_RESPONSE" | jq -r '.choices[0].message.content')"
else
    echo -e "${YELLOW}Warning: Test query failed, but gateway may still be configured${NC}"
fi

# Summary
echo -e "\n${GREEN}=== AI Gateway Setup Complete ===${NC}\n"
echo "Gateway ID: $GATEWAY_ID"
echo "Gateway Name: $GATEWAY_NAME"
echo "Account ID: $CLOUDFLARE_ACCOUNT_ID"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo "1. Add GATEWAY_ID=\"$GATEWAY_ID\" to your GitHub secrets"
echo "2. Deploy the worker: wrangler deploy infrastructure/cloudflare/workers/api-worker.js"
echo "3. Test the API: curl https://api.duet.company/api/v1/health"
echo ""
echo -e "${BLUE}View your gateway:${NC}"
echo "https://dash.cloudflare.com/$CLOUDFLARE_ACCOUNT_ID/ai/gateway"
echo ""
