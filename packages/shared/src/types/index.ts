// Shared TypeScript types
export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'user' | 'viewer';
}

export interface Platform {
  id: string;
  name: string;
  description?: string;
  status: 'active' | 'inactive' | 'provisioning';
  createdAt: Date;
  updatedAt: Date;
}

export interface AgentResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: string;
  metadata?: Record<string, unknown>;
}
