/**
 * Duet Company - Cloudflare Pages Middleware
 * Handles API proxying and authentication
 */

export async function onRequest(context: {
  request: Request;
  next: () => Promise<Response>;
  env: Record<string, unknown>;
}): Promise<Response> {
  const url = new URL(context.request.url);
  const path = url.pathname;

  // Proxy API requests to Cloudflare Workers
  if (path.startsWith('/api/')) {
    const apiUrl = `https://api.duet.company${path}${url.search}`;

    // Copy headers and add authentication if needed
    const headers = new Headers(context.request.headers);
    headers.set('X-Forwarded-Host', url.hostname);

    return fetch(apiUrl, {
      method: context.request.method,
      headers,
      body: context.request.body,
    });
  }

  // Handle static assets and pages
  return context.next();
}

// Export for Edge Functions
export default {
  fetch: onRequest,
};
