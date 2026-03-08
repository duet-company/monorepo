/**
 * Cloudflare AI Gateway Client
 * Provides a unified interface for making LLM requests through Cloudflare AI Gateway
 */

export interface LLMProvider {
  name: 'openai' | 'anthropic' | 'google-vertex-ai' | 'cohere' | 'mistral';
}

export interface LLMModel {
  provider: LLMProvider['name'];
  model: string;
  gatewayId?: string;
}

export interface ChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

export interface ChatCompletionOptions {
  model: LLMModel;
  messages: ChatMessage[];
  maxTokens?: number;
  temperature?: number;
  topP?: number;
  stream?: boolean;
}

export interface GatewayConfig {
  gatewayId?: string;
  accountId?: string;
  apiToken?: string;
}

export class AIGatewayClient {
  private config: GatewayConfig;
  private baseUrl = 'https://gateway.ai.cloudflare.com/v1';

  constructor(config: GatewayConfig = {}) {
    this.config = {
      gatewayId: config.gatewayId || process.env.CLOUDFLARE_AI_GATEWAY_ID,
      accountId: config.accountId || process.env.CLOUDFLARE_ACCOUNT_ID,
      apiToken: config.apiToken || process.env.CLOUDFLARE_API_TOKEN,
    };
  }

  /**
   * Get the gateway URL for a provider/model combination
   */
  private getEndpoint(model: LLMModel): string {
    const { provider, model: modelName } = model;
    return `${this.baseUrl}/${provider}/${modelName}`;
  }

  /**
   * Get the API key for a provider
   */
  private getApiKey(provider: LLMProvider['name']): string {
    const keys: Record<LLMProvider['name'], string> = {
      openai: process.env.OPENAI_API_KEY || '',
      anthropic: process.env.ANTHROPIC_API_KEY || '',
      'google-vertex-ai': process.env.GOOGLE_AI_API_KEY || '',
      cohere: process.env.COHERE_API_KEY || '',
      mistral: process.env.MISTRAL_API_KEY || '',
    };

    const key = keys[provider];
    if (!key) {
      throw new Error(`API key not found for provider: ${provider}`);
    }
    return key;
  }

  /**
   * Make a chat completion request
   */
  async chatCompletion(options: ChatCompletionOptions): Promise<Response> {
    const { model, messages, maxTokens = 1024, temperature = 0.7, stream = false } = options;
    const endpoint = this.getEndpoint(model);
    const apiKey = this.getApiKey(model.provider);

    const body = {
      model: model.model,
      messages,
      max_tokens: maxTokens,
      temperature,
      stream,
    };

    // Add provider-specific fields
    if (model.provider === 'anthropic') {
      body['anthropic_version'] = '2023-06-01';
    }

    const response = await fetch(endpoint, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${apiKey}`,
        'Content-Type': 'application/json',
        ...(this.config.gatewayId && {
          'CF-Gateway-ID': this.config.gatewayId,
        }),
      },
      body: JSON.stringify(body),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`AI Gateway request failed: ${response.status} ${error}`);
    }

    return response;
  }

  /**
   * Make a simple text generation request
   */
  async generateText(
    prompt: string,
    model: LLMModel = { provider: 'openai', model: 'gpt-4' },
    options: Partial<ChatCompletionOptions> = {}
  ): Promise<string> {
    const messages: ChatMessage[] = [{ role: 'user', content: prompt }];

    const response = await this.chatCompletion({
      model,
      messages,
      ...options,
    });

    const data = await response.json();
    return data.choices?.[0]?.message?.content || data.content?.[0]?.text || '';
  }

  /**
   * Stream a chat completion response
   */
  async *streamChatCompletion(options: ChatCompletionOptions): AsyncGenerator<string> {
    const response = await this.chatCompletion({
      ...options,
      stream: true,
    });

    const reader = response.body?.getReader();
    if (!reader) {
      throw new Error('Response body is not readable');
    }

    const decoder = new TextDecoder();
    let buffer = '';

    while (true) {
      const { done, value } = await reader.read();
      if (done) break;

      buffer += decoder.decode(value, { stream: true });
      const lines = buffer.split('\n');
      buffer = lines.pop() || '';

      for (const line of lines) {
        if (line.startsWith('data: ')) {
          const data = line.slice(6);
          if (data === '[DONE]') return;

          try {
            const parsed = JSON.parse(data);
            const content = parsed.choices?.[0]?.delta?.content || parsed.delta?.text;
            if (content) {
              yield content;
            }
          } catch {
            // Skip invalid JSON
          }
        }
      }
    }
  }

  /**
   * Get gateway metrics
   */
  async getMetrics(timeRange: string = '24h'): Promise<any> {
    if (!this.config.apiToken) {
      throw new Error('CF_API_TOKEN is required for metrics');
    }

    const response = await fetch(
      `https://api.cloudflare.com/client/v4/accounts/${this.config.accountId}/ai/gateway/metrics?time_range=${timeRange}`,
      {
        headers: {
          Authorization: `Bearer ${this.config.apiToken}`,
          'Content-Type': 'application/json',
        },
      }
    );

    if (!response.ok) {
      throw new Error(`Failed to fetch metrics: ${response.status}`);
    }

    return response.json();
  }
}

// Pre-configured models
export const MODELS = {
  // OpenAI
  GPT4_TURBO: { provider: 'openai' as const, model: 'gpt-4-turbo-preview' },
  GPT4: { provider: 'openai' as const, model: 'gpt-4' },
  GPT35_TURBO: { provider: 'openai' as const, model: 'gpt-3.5-turbo' },

  // Anthropic
  CLAUDE_3_OPUS: { provider: 'anthropic' as const, model: 'claude-3-opus-20240229' },
  CLAUDE_3_SONNET: { provider: 'anthropic' as const, model: 'claude-3-sonnet-20240229' },
  CLAUDE_2: { provider: 'anthropic' as const, model: 'claude-2.1' },

  // Google
  GEMINI_PRO: { provider: 'google-vertex-ai' as const, model: 'gemini-pro' },

  // Cohere
  COMMAND: { provider: 'cohere' as const, model: 'command' },
  COMMAND_LIGHT: { provider: 'cohere' as const, model: 'command-light' },

  // Mistral
  MISTRAL: { provider: 'mistral' as const, model: 'mistral-tiny' },
  MIXTRAL: { provider: 'mistral' as const, model: 'mixtral-8x7b' },
} as const;

// Export singleton instance
export const aiGateway = new AIGatewayClient();

// Convenience functions
export async function generateText(
  prompt: string,
  model?: LLMModel,
  options?: Partial<ChatCompletionOptions>
): Promise<string> {
  return aiGateway.generateText(prompt, model, options);
}

export async function chatCompletion(
  messages: ChatMessage[],
  model?: LLMModel,
  options?: Partial<ChatCompletionOptions>
): Promise<Response> {
  return aiGateway.chatCompletion({
    model: model || MODELS.GPT4_TURBO,
    messages,
    ...options,
  });
}
