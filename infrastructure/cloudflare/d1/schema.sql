-- Duet Company - D1 Database Schema
-- Cloudflare D1 SQLite database schema

-- Users table
CREATE TABLE IF NOT EXISTS users (
  id TEXT PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT NOT NULL DEFAULT 'user',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Platforms table
CREATE TABLE IF NOT EXISTS platforms (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'provisioning',
  config TEXT, -- JSON config
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Agents table
CREATE TABLE IF NOT EXISTS agents (
  id TEXT PRIMARY KEY,
  platform_id TEXT NOT NULL,
  type TEXT NOT NULL, -- 'query', 'design', 'support', 'operations'
  config TEXT, -- JSON config
  status TEXT NOT NULL DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (platform_id) REFERENCES platforms(id) ON DELETE CASCADE
);

-- Queries table (for Query Agent history)
CREATE TABLE IF NOT EXISTS queries (
  id TEXT PRIMARY KEY,
  platform_id TEXT NOT NULL,
  user_id TEXT NOT NULL,
  natural_language TEXT NOT NULL,
  sql_query TEXT,
  result TEXT, -- JSON result
  execution_time_ms INTEGER,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (platform_id) REFERENCES platforms(id) ON DELETE CASCADE,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Indexes for performance
CREATE INDEX IF NOT EXISTS idx_platforms_user_id ON platforms(user_id);
CREATE INDEX IF NOT EXISTS idx_agents_platform_id ON agents(platform_id);
CREATE INDEX IF NOT EXISTS idx_queries_platform_id ON queries(platform_id);
CREATE INDEX IF NOT EXISTS idx_queries_user_id ON queries(user_id);
CREATE INDEX IF NOT EXISTS idx_queries_created_at ON queries(created_at DESC);

-- Sessions table (for authentication)
CREATE TABLE IF NOT EXISTS sessions (
  id TEXT PRIMARY KEY,
  user_id TEXT NOT NULL,
  token_hash TEXT NOT NULL,
  expires_at DATETIME NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

CREATE INDEX IF NOT EXISTS idx_sessions_user_id ON sessions(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_token_hash ON sessions(token_hash);
