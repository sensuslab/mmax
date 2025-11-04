# Railway Deployment Guide

This repository contains two separate services that can be deployed independently to Railway:

1. **Backend** - Python FastAPI application (`/backend`)
2. **Frontend** - Next.js React application (`/frontend`)

## Prerequisites

- [Railway](https://railway.app/) account
- [GitHub](https://github.com/) account
- Git repository (GitHub)
- Supabase account for database
- Redis instance (Railway provides Redis addon)

## Architecture

- **Frontend**: Next.js (port 3000)
- **Backend**: FastAPI (port 8000)
- **Database**: Supabase (PostgreSQL)
- **Cache**: Redis
- **Storage**: Railway ephemeral or external (S3, etc.)

## Deployment Strategy

You can deploy both services from the same repository by:

1. Creating two separate Railway projects
2. Each project points to the same repository but different directories
3. Use different branches for different environments (optional)

---

## 🔧 Backend Deployment

### 1. Prepare Backend Repository Structure

The backend should be in the `/backend` directory with the following structure:

```
/backend
├── api.py                 # FastAPI entrypoint
├── pyproject.toml         # Python dependencies
├── Dockerfile             # Railway deployment
├── railway.json          # Railway config
├── .dockerignore
├── .env.example          # Environment variables template
└── core/                 # Application code
    ├── services/
    ├── utils/
    └── ...
```

### 2. Deploy to Railway

#### Option A: Deploy from GitHub (Recommended)

1. **Push to GitHub**:
   ```bash
   git init
   git add .
   git commit -m "Initial commit"
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

2. **Create New Railway Project**:
   - Go to [Railway](https://railway.app/)
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository
   - **Important**: In the deploy settings, set the **Root Directory** to `backend`

3. **Configure Build Settings**:
   - Railway will auto-detect Dockerfile
   - Build Command: (automatic from Dockerfile)
   - Start Command: (automatic from Dockerfile)

#### Option B: Direct Upload

1. Zip the `/backend` directory
2. Deploy directly to Railway

### 3. Set Environment Variables

In Railway dashboard, go to your backend service → Variables and add:

#### Required Variables:

```env
# Environment
ENV_MODE=production

# Database
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# Redis
REDIS_HOST=your_redis_host_from_railway_addon
REDIS_PORT=6379
REDIS_PASSWORD=your_redis_password
REDIS_SSL=true

# LLM Providers (at least one required)
ANTHROPIC_API_KEY=your_anthropic_key
OPENAI_API_KEY=your_openai_key
# OR any other provider...

# Required Services
RAPID_API_KEY=your_rapid_api_key
TAVILY_API_KEY=your_tavily_key
FIRECRAWL_API_KEY=your_firecrawl_key
DAYTONA_API_KEY=your_daytona_key
```

#### Optional Variables:

```env
# Security
MCP_CREDENTIAL_ENCRYPTION_KEY=your_encryption_key
TRIGGER_WEBHOOK_SECRET=your_webhook_secret

# Billing
STRIPE_SECRET_KEY=your_stripe_key
STRIPE_WEBHOOK_SECRET=your_webhook_secret

# Observability
LANGFUSE_PUBLIC_KEY=your_langfuse_key
LANGFUSE_SECRET_KEY=your_secret
LANGFUSE_HOST=https://cloud.langfuse.com

# Admin
KORTIX_ADMIN_API_KEY=your_admin_key

# Integrations
COMPOSIO_API_KEY=your_key
```

### 4. Add Redis Addon

1. In Railway dashboard, go to your backend service
2. Click "New" → "Database" → "Add Redis"
3. Copy the connection details to your environment variables

### 5. Verify Deployment

Once deployed, check the health endpoint:
```
https://your-backend-url.railway.app/api/health
```

---

## 🌐 Frontend Deployment

### 1. Prepare Frontend Repository Structure

The frontend should be in the `/frontend` directory with the following structure:

```
/frontend
├── package.json           # Node.js dependencies
├── next.config.ts         # Next.js configuration
├── Dockerfile             # Railway deployment
├── railway.json          # Railway config
├── .dockerignore
├── .env.example          # Environment variables template
└── app/                  # Next.js app
    ├── lib/
    ├── components/
    └── ...
```

### 2. Deploy to Railway

#### Option A: Deploy from GitHub (Recommended)

1. **Ensure GitHub is Updated**:
   ```bash
   git add .
   git commit -m "Update for Railway deployment"
   git push
   ```

2. **Create New Railway Project**:
   - Go to [Railway](https://railway.app/)
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose the **same repository**
   - **Important**: In the deploy settings, set the **Root Directory** to `frontend`

3. **Configure Build Settings**:
   - Railway will auto-detect Dockerfile
   - Build Command: (automatic from Dockerfile)
   - Start Command: (automatic from Dockerfile)

#### Option B: Direct Upload

1. Zip the `/frontend` directory
2. Deploy directly to Railway

### 3. Set Environment Variables

In Railway dashboard, go to your frontend service → Variables and add:

#### Required Variables:

```env
# Environment
NEXT_PUBLIC_ENV_MODE=production

# Database
NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key

# Backend API
NEXT_PUBLIC_BACKEND_URL=https://your-backend-url.railway.app/api

# Application
NEXT_PUBLIC_URL=https://your-frontend-url.railway.app
```

#### Optional Variables:

```env
# Google OAuth
NEXT_PUBLIC_GOOGLE_CLIENT_ID=your_google_client_id

# Analytics
NEXT_PUBLIC_POSTHOG_KEY=your_posthog_key

# Admin
KORTIX_ADMIN_API_KEY=your_admin_key

# Edge Config
EDGE_CONFIG=your_edge_config_url
```

### 4. Verify Deployment

Once deployed, visit:
```
https://your-frontend-url.railway.app
```

---

## 🔗 Connecting Frontend to Backend

### Update Environment Variables

After both services are deployed:

1. **Get Backend URL**: From Railway backend service dashboard
2. **Update Frontend Variables**:
   - Set `NEXT_PUBLIC_BACKEND_URL` to your backend URL
   - Set `NEXT_PUBLIC_URL` to your frontend URL
3. **Restart Frontend**: Trigger a redeploy in Railway

### CORS Configuration

The backend is pre-configured to accept requests from:
- `https://www.kortix.com`
- `https://kortix.com`
- `https://www.suna.so`
- `https://suna.so`
- Railway domains (auto-detected)

For production, update the CORS origins in `backend/api.py` (lines 135-154) to include your Railway frontend URL.

---

## 📦 Repository Structure for Railway

Your final GitHub repository should look like:

```
/your-repo
├── README.md
├── backend/                 # Backend service
│   ├── api.py
│   ├── pyproject.toml
│   ├── Dockerfile
│   ├── railway.json
│   ├── .dockerignore
│   ├── .env.example
│   └── core/
├── frontend/                # Frontend service
│   ├── package.json
│   ├── next.config.ts
│   ├── Dockerfile
│   ├── railway.json
│   ├── .dockerignore
│   ├── .env.example
│   ├── app/
│   └── public/
└── RAILWAY_DEPLOYMENT.md    # This file
```

---

## 🚀 Quick Start Commands

### Backend Local Development

```bash
cd backend
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
cp .env.example .env
# Edit .env with your values
uvicorn api:app --reload --host 0.0.0.0 --port 8000
```

### Frontend Local Development

```bash
cd frontend
npm install
cp .env.example .env.local
# Edit .env.local with your values
npm run dev
```

---

## 🔐 Environment Variables Checklist

### Backend (.env)
- [ ] ENV_MODE=production
- [ ] SUPABASE_URL
- [ ] SUPABASE_ANON_KEY
- [ ] SUPABASE_SERVICE_ROLE_KEY
- [ ] REDIS_HOST
- [ ] REDIS_PORT
- [ ] REDIS_PASSWORD
- [ ] At least one LLM API key (ANTHROPIC_API_KEY, OPENAI_API_KEY, etc.)
- [ ] RAPID_API_KEY
- [ ] TAVILY_API_KEY
- [ ] FIRECRAWL_API_KEY
- [ ] DAYTONA_API_KEY

### Frontend (.env)
- [ ] NEXT_PUBLIC_ENV_MODE=production
- [ ] NEXT_PUBLIC_SUPABASE_URL
- [ ] NEXT_PUBLIC_SUPABASE_ANON_KEY
- [ ] NEXT_PUBLIC_BACKEND_URL
- [ ] NEXT_PUBLIC_URL

---

## 🐛 Troubleshooting

### Backend Issues

1. **Port Issues**: Ensure `EXPOSE 8000` in Dockerfile
2. **Environment Variables**: All required vars must be set
3. **Database Connection**: Verify Supabase credentials
4. **Redis Connection**: Check Redis addon is active
5. **Health Check**: Visit `/api/health` endpoint

### Frontend Issues

1. **Build Fails**: Check `npm install` in logs
2. **Environment Variables**: Must start with `NEXT_PUBLIC_`
3. **Backend Connection**: Verify `NEXT_PUBLIC_BACKEND_URL` is correct
4. **CORS Errors**: Check backend CORS settings

### Common Fixes

1. **Redeploy**: Trigger redeploy after changing env vars
2. **Check Logs**: Use Railway's logs tab
3. **Restart Services**: Use Railway's restart button
4. **Verify URLs**: Ensure URLs are publicly accessible

---

## 📚 Additional Resources

- [Railway Documentation](https://docs.railway.app/)
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [Next.js Documentation](https://nextjs.org/docs)
- [Supabase Documentation](https://supabase.com/docs)

---

## 🎯 Next Steps

After successful deployment:

1. **Set up custom domain** (optional):
   - Backend: railway.app → yourdomain.com/api
   - Frontend: railway.app → yourdomain.com

2. **Set up monitoring**:
   - Railway provides basic metrics
   - Add Sentry for error tracking

3. **Set up CI/CD**:
   - Use GitHub branches
   - Configure Railway auto-deploy from main branch

4. **Scale services**:
   - Adjust replica count in Railway
   - Monitor usage and scale accordingly

---

## 📝 Notes

- Both services are configured to run as Docker containers on Railway
- Environment variables are crucial for deployment
- Frontend and Backend should be deployed as separate Railway services
- Use the same GitHub repository but different root directories
- Redis and Supabase should be configured before backend deployment

---

**Happy Deploying! 🚀**
