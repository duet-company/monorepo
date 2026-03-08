/**
 * Duet Company - Cloudflare Worker API
 * Edge functions for handling API requests
 */

interface Env {
  DB: D1Database;
  CACHE: KVNamespace;
  ENVIRONMENT: string;
  LOG_LEVEL: string;
}

interface Context {
  waitUntil: (promise: Promise<unknown>) => void;
}

export default {
  async fetch(request: Request, env: Env, ctx: Context): Promise<Response> {
    const url = new URL(request.url);
    const path = url.pathname;

    // Health check endpoint
    if (path === '/health' || path === '/') {
      return jsonResponse({
        status: 'healthy',
        version: '0.1.0',
        service: 'Duet Company API',
        environment: env.ENVIRONMENT,
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
        return jsonResponse({ platforms: [] });
      }
      break;

    case '/agents':
      if (request.method === 'GET') {
        return jsonResponse({
          agents: [
            { id: 'query', name: 'Query Agent', status: 'active' },
            { id: 'design', name: 'Platform Designer Agent', status: 'active' },
            { id: 'support', name: 'Support Agent', status: 'active' },
          ],
        });
      }
      break;

    default:
      return jsonResponse({ error: 'Endpoint not found' }, 404);
  }

  return jsonResponse({ error: 'Method not allowed' }, 405);
}

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
