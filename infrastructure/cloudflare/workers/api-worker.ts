/**
 * Duet Company - Cloudflare Worker API
 * Edge functions with AI Gateway integration
 */

interface Env {
  DB: D1Database;
  CACHE: KVNamespace;
  AI: any; // AI Gateway binding
  ENVIRONMENT: string;
  LOG_LEVEL: string;
  CLOUDFLARE_AI_GATEWAY_ID?: string;
  OPENAI_API_KEY?: string;
  ANTHROPIC_API_KEY?: string;
}

interface Context {
  waitUntil: (promise: Promise<unknown>) => void;
}

export default {
  async fetch(request: Request, env: Env, ctx: Context): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // Handle CORS preflight
    if (request.method === 'OPTIONS') {
      return corsResponse();
    }

    // Health check endpoint
    if (path === '/health' || path === '/') {
      return jsonResponse({
        status: 'healthy',
        version: '0.1.0',
        service: 'Duet Company API',
        environment: env.ENVIRONMENT,
        ai_gateway: !!env.CLOUDFLARE_AI_GATEWAY_ID,
        timestamp: new Date().toISOString(),
      });
    }

    // API v1 endpoints
    if (path.startsWith('/api/v1/')) {
      return handleApiV1(request, env, ctx);
    }

    // 404 for unknown routes
    return jsonResponse({ error: 'Not found' }, 404);
  },
};

async function handleApiV1(request: Request, env: Env, ctx: Context): Promise<Response> {
  const url = new URL(request.url);
  const path = url.pathname.replace('/api/v1', '');

  switch (path) {
    case '/platforms':
      if (request.method === 'GET') {
        return handleListPlatforms(env);
      }
      if (request.method === 'POST') {
        return handleCreatePlatform(request, env);
      }
      break;

    case '/agents':
      if (request.method === 'GET') {
        return handleListAgents(env);
      }
      break;

    case '/agents/query':
      if (request.method === 'POST') {
        return handleQueryAgent(request, env, ctx);
      }
      break;

    case '/agents/design':
      if (request.method === 'POST') {
        return handleDesignAgent(request, env, ctx);
      }
      break;

    default:
      return jsonResponse({ error: 'Endpoint not found' }, 404);
  }

  return jsonResponse({ error: 'Method not allowed' }, 405);
}

/**
 * Query Agent - Natural language to SQL
 */
async function handleQueryAgent(request: Request, env: Env, ctx: Context): Promise<Response> {
  try {
    const body = (await request.json()) as { query?: string; platform_id?: string };

    if (!body.query) {
      return jsonResponse({ error: 'Query is required' }, 400);
    }

    // Check cache first
    const cacheKey = `query:${body.platform_id || 'default'}:${hashString(body.query)}`;
    const cached = await env.CACHE.get(cacheKey, 'json');
    if (cached) {
      return jsonResponse({ ...cached, cached: true });
    }

    // Use AI Gateway for query generation
    const systemPrompt = `You are a SQL expert. Convert natural language queries to optimized SQL.
Focus on ClickHouse syntax. Return only the SQL query without explanation.`;

    const userPrompt = `Convert this natural language query to SQL: "${body.query}"
${body.platform_id ? `Platform schema: standard e-commerce schema (orders, customers, products)` : ''}`;

    const sqlQuery = await callAIGateway(env, {
      model: 'gpt-4-turbo-preview',
      provider: 'openai',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: userPrompt },
      ],
      maxTokens: 500,
    });

    // Cache the result for 1 hour
    ctx.waitUntil(
      env.CACHE.put(cacheKey, JSON.stringify({ sql: sqlQuery }), { expirationTtl: 3600 })
    );

    return jsonResponse({
      query: body.query,
      sql: sqlQuery,
      cached: false,
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Query agent error:', error);
    return jsonResponse({ error: 'Failed to process query' }, 500);
  }
}

/**
 * Design Agent - Platform design from requirements
 */
async function handleDesignAgent(request: Request, env: Env, ctx: Context): Promise<Response> {
  try {
    const body = (await request.json()) as { requirements?: string };

    if (!body.requirements) {
      return jsonResponse({ error: 'Requirements are required' }, 400);
    }

    // Use AI Gateway for platform design
    const systemPrompt = `You are a data platform architect. Design schemas and infrastructure based on requirements.
Return a JSON response with schema, tables, and recommended technologies.`;

    const design = await callAIGateway(env, {
      model: 'claude-3-opus-20240229',
      provider: 'anthropic',
      messages: [
        { role: 'system', content: systemPrompt },
        { role: 'user', content: `Design a data platform for: ${body.requirements}` },
      ],
      maxTokens: 2000,
    });

    return jsonResponse({
      requirements: body.requirements,
      design: JSON.parse(design),
      timestamp: new Date().toISOString(),
    });
  } catch (error) {
    console.error('Design agent error:', error);
    return jsonResponse({ error: 'Failed to generate design' }, 500);
  }
}

/**
 * Call Cloudflare AI Gateway
 */
async function callAIGateway(
  env: Env,
  options: {
    model: string;
    provider: 'openai' | 'anthropic' | 'google-vertex-ai' | 'cohere' | 'mistral';
    messages: Array<{ role: string; content: string }>;
    maxTokens?: number;
    temperature?: number;
  }
): Promise<string> {
  const { model, provider, messages, maxTokens = 1000, temperature = 0.7 } = options;

  // Get API key for provider
  const apiKey = provider === 'openai' ? env.OPENAI_API_KEY : env.ANTHROPIC_API_KEY;
  if (!apiKey) {
    throw new Error(`API key not found for provider: ${provider}`);
  }

  // Build gateway URL
  const gatewayId = env.CLOUDFLARE_AI_GATEWAY_ID;
  const baseUrl = 'https://gateway.ai.cloudflare.com/v1';
  const endpoint = `${baseUrl}/${provider}/${model}`;

  // Prepare request body
  const requestBody = {
    model,
    messages,
    max_tokens: maxTokens,
    temperature,
  };

  // Add provider-specific headers
  const headers: Record<string, string> = {
    'Content-Type': 'application/json',
    Authorization: `Bearer ${apiKey}`,
  };

  if (gatewayId) {
    headers['CF-Gateway-ID'] = gatewayId;
  }

  // Make request
  const response = await fetch(endpoint, {
    method: 'POST',
    headers,
    body: JSON.stringify(requestBody),
  });

  if (!response.ok) {
    const error = await response.text();
    throw new Error(`AI Gateway error: ${response.status} ${error}`);
  }

  const data = await response.json();

  // Extract content based on provider response format
  if (provider === 'anthropic') {
    return data.content?.[0]?.text || '';
  }
  return data.choices?.[0]?.message?.content || '';
}

/**
 * List platforms
 */
async function handleListPlatforms(env: Env): Promise<Response> {
  try {
    const result = await env.DB.prepare('SELECT * FROM platforms ORDER BY created_at DESC').all();
    return jsonResponse({ platforms: result.results || [] });
  } catch (error) {
    console.error('Database error:', error);
    return jsonResponse({ platforms: [] });
  }
}

/**
 * Create platform
 */
async function handleCreatePlatform(request: Request, env: Env): Promise<Response> {
  try {
    const body = await request.json();
    const { name, description } = body;

    if (!name) {
      return jsonResponse({ error: 'Name is required' }, 400);
    }

    const id = crypto.randomUUID();
    const result = await env.DB.prepare(
      'INSERT INTO platforms (id, user_id, name, description, status) VALUES (?, ?, ?, ?, ?)'
    )
      .bind(id, 'user_1', name, description || '', 'provisioning')
      .run();

    return jsonResponse({ id, name, description, status: 'provisioning' }, 201);
  } catch (error) {
    console.error('Create platform error:', error);
    return jsonResponse({ error: 'Failed to create platform' }, 500);
  }
}

/**
 * List agents
 */
async function handleListAgents(env: Env): Promise<Response> {
  return jsonResponse({
    agents: [
      {
        id: 'query',
        name: 'Query Agent',
        description: 'Natural language to SQL translation',
        status: 'active',
        model: 'gpt-4-turbo-preview',
      },
      {
        id: 'design',
        name: 'Platform Designer Agent',
        description: 'Design data platforms from requirements',
        status: 'active',
        model: 'claude-3-opus-20240229',
      },
      {
        id: 'support',
        name: 'Support Agent',
        description: '24/7 customer support',
        status: 'active',
        model: 'claude-3-sonnet-20240229',
      },
    ],
  });
}

/**
 * Utility functions
 */
function jsonResponse(data: unknown, status = 200): Response {
  return new Response(JSON.stringify(data), {
    status,
    headers: {
      'Content-Type': 'application/json',
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  });
}

function corsResponse(): Response {
  return new Response(null, {
    status: 204,
    headers: {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
      'Access-Control-Allow-Headers': 'Content-Type, Authorization',
    },
  });
}

function hashString(str: string): string {
  let hash = 0;
  for (let i = 0; i < str.length; i++) {
    const char = str.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash = hash & hash;
  }
  return hash.toString(16);
}
