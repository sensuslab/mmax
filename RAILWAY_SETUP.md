# Railway Deployment Setup Guide

This repository is configured for Railway deployment with separate frontend and backend services.

## Architecture

- **Frontend**: Next.js application (port 3000)
- **Backend**: FastAPI application with Gunicorn (port 8000)

## Deployment Steps

### 1. Create Backend Service

1. In Railway, click **"New"** → **"GitHub Repo"**
2. Select this repository
3. **IMPORTANT**: Set **Root Directory** to `/backend`
4. Railway will automatically detect the `railway.json` and `Dockerfile` in the backend directory
5. Configure environment variables (see Backend Environment Variables below)

### 2. Create Frontend Service

1. Click **"New"** → **"GitHub Repo"** again
2. Select the same repository
3. **IMPORTANT**: Set **Root Directory** to `/frontend`
4. Railway will automatically detect the `railway.json` and `Dockerfile` in the frontend directory
5. Configure environment variables (see Frontend Environment Variables below)

### 3. Link Services

After both services are deployed, connect them:

1. Copy the backend service's public URL (e.g., `https://your-backend.railway.app`)
2. Add this URL to the frontend service as `NEXT_PUBLIC_API_URL` environment variable
3. Redeploy the frontend service

## Environment Variables

### Backend Environment Variables

Copy these from your `.env.production` or set them in Railway dashboard:

#### Required - Core Configuration
```bash
# Environment Mode
ENV_MODE=production

# Gunicorn Configuration (pre-configured in Dockerfile)
WORKERS=7
THREADS=2
WORKER_CONNECTIONS=2000
```

#### Required - Database (Supabase)
```bash
SUPABASE_URL=your-supabase-url
SUPABASE_ANON_KEY=your-anon-key
SUPABASE_SERVICE_ROLE_KEY=your-service-role-key
```

#### Required - Redis (Upstash or Railway Redis)
```bash
# For Upstash Redis
REDIS_HOST=your-redis-host
REDIS_PORT=6379
REDIS_PASSWORD=your-redis-password
REDIS_SSL=true

# Upstash REST API
UPSTASH_REDIS_REST_URL=https://your-redis.upstash.io
UPSTASH_REDIS_REST_TOKEN=your-token
```

#### Required - LLM Providers (at least one)
```bash
ANTHROPIC_API_KEY=your-anthropic-key
OPENAI_API_KEY=your-openai-key
GROQ_API_KEY=your-groq-key
GEMINI_API_KEY=your-gemini-key
XAI_API_KEY=your-xai-key
OPENROUTER_API_KEY=your-openrouter-key
```

#### Required - Search & Data
```bash
TAVILY_API_KEY=your-tavily-key
EXA_API_KEY=your-exa-key
FIRECRAWL_API_KEY=your-firecrawl-key
FIRECRAWL_URL=https://api.firecrawl.dev
```

#### Required - Agent Sandbox (Daytona)
```bash
DAYTONA_API_KEY=your-daytona-key
DAYTONA_SERVER_URL=https://app.daytona.io/api
DAYTONA_TARGET=us
```

#### Optional - Integrations
```bash
COMPOSIO_API_KEY=your-composio-key
COMPOSIO_WEBHOOK_SECRET=your-webhook-secret
COMPOSIO_API_BASE=https://backend.composio.dev
```

#### Optional - Observability
```bash
LANGFUSE_PUBLIC_KEY=your-public-key
LANGFUSE_SECRET_KEY=your-secret-key
LANGFUSE_HOST=https://cloud.langfuse.com
```

#### Optional - Billing
```bash
STRIPE_SECRET_KEY=your-stripe-key
STRIPE_WEBHOOK_SECRET=your-webhook-secret
STRIPE_DEFAULT_PLAN_ID=your-plan-id
STRIPE_DEFAULT_TRIAL_DAYS=14
```

#### Optional - Security & Webhooks
```bash
MCP_CREDENTIAL_ENCRYPTION_KEY=your-encryption-key
TRIGGER_WEBHOOK_SECRET=your-webhook-secret
KORTIX_ADMIN_API_KEY=your-admin-key
```

#### Optional - QStash (Serverless messaging)
```bash
QSTASH_URL=https://qstash.upstash.io
QSTASH_TOKEN=your-qstash-token
QSTASH_CURRENT_SIGNING_KEY=your-current-key
QSTASH_NEXT_SIGNING_KEY=your-next-key
```

### Frontend Environment Variables

#### Required - Core Configuration
```bash
# Environment Mode
NEXT_PUBLIC_ENV_MODE=production

# Backend API URL (IMPORTANT: Set this to your Railway backend URL)
NEXT_PUBLIC_BACKEND_URL=https://your-backend.railway.app/api

# Frontend URL (your Railway frontend URL)
NEXT_PUBLIC_URL=https://your-frontend.railway.app

# Supabase
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
```

#### Optional - Integrations
```bash
# Google OAuth
NEXT_PUBLIC_GOOGLE_CLIENT_ID=your-google-client-id

# PostHog Analytics
NEXT_PUBLIC_POSTHOG_KEY=your-posthog-key

# Admin
KORTIX_ADMIN_API_KEY=your-admin-key
```

### Quick Environment Variable Setup

1. **Backend**: Copy from `/backend/.env.example` or use your existing `.env.production`
2. **Frontend**: Copy from `/frontend/.env.example` or use your existing configuration
3. **Important**: Update `NEXT_PUBLIC_BACKEND_URL` after backend is deployed

## Configuration Files

### Backend Configuration (`/backend/railway.json`)

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "Dockerfile"
  },
  "deploy": {
    "numReplicas": 1,
    "sleepApplication": false,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

### Frontend Configuration (`/frontend/railway.json`)

```json
{
  "$schema": "https://railway.app/railway.schema.json",
  "build": {
    "builder": "DOCKERFILE",
    "dockerfilePath": "Dockerfile"
  },
  "deploy": {
    "numReplicas": 1,
    "sleepApplication": false,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  }
}
```

## Troubleshooting

### Issue: Railway doesn't detect Dockerfile

**Solution**: Make sure you've set the **Root Directory** correctly:
- Backend service: `/backend`
- Frontend service: `/frontend`

The `dockerfilePath` in `railway.json` is relative to the root directory.

### Issue: Frontend can't connect to backend

**Solution**:
1. Ensure backend is deployed and has a public URL
2. Add `NEXT_PUBLIC_API_URL` to frontend environment variables
3. Redeploy frontend service

### Issue: Build fails

**Solution**:
1. Check Railway build logs for specific errors
2. Verify all required environment variables are set
3. Ensure Dockerfiles are building correctly locally first

## Local Development

For local development, see `LOCAL_DEV_GUIDE.md` in the root directory.

## Additional Resources

- [Railway Documentation](https://docs.railway.app/)
- [Railway Dockerfile Deployment](https://docs.railway.app/deploy/dockerfiles)
- [Railway Monorepo Support](https://docs.railway.app/deploy/monorepo)
