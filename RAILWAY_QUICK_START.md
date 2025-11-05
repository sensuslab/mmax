# Railway Quick Start Checklist

## Prerequisites
- [ ] Railway account created
- [ ] Repository pushed to GitHub
- [ ] Required API keys ready (see environment variables below)

## Step 1: Deploy Backend Service

1. **Create Backend Service**
   - [ ] Go to Railway dashboard
   - [ ] Click "New" → "GitHub Repo"
   - [ ] Select this repository
   - [ ] **Set Root Directory: `/backend`** ⚠️ IMPORTANT
   - [ ] Railway will detect `railway.json` and `Dockerfile`

2. **Configure Backend Environment Variables**

   Minimum required variables:
   - [ ] `ENV_MODE=production`
   - [ ] `SUPABASE_URL`
   - [ ] `SUPABASE_ANON_KEY`
   - [ ] `SUPABASE_SERVICE_ROLE_KEY`
   - [ ] `REDIS_HOST` / `UPSTASH_REDIS_REST_URL`
   - [ ] At least one LLM API key (`ANTHROPIC_API_KEY`, `OPENAI_API_KEY`, etc.)
   - [ ] `TAVILY_API_KEY`
   - [ ] `FIRECRAWL_API_KEY`
   - [ ] `DAYTONA_API_KEY`

3. **Wait for Backend Deployment**
   - [ ] Wait for build to complete
   - [ ] Copy the backend public URL (e.g., `https://backend-production-xxxx.railway.app`)

## Step 2: Deploy Frontend Service

1. **Create Frontend Service**
   - [ ] In Railway, click "New" → "GitHub Repo"
   - [ ] Select the SAME repository
   - [ ] **Set Root Directory: `/frontend`** ⚠️ IMPORTANT
   - [ ] Railway will detect `railway.json` and `Dockerfile`

2. **Configure Frontend Environment Variables**

   Required variables:
   - [ ] `NEXT_PUBLIC_ENV_MODE=production`
   - [ ] `NEXT_PUBLIC_BACKEND_URL=<your-backend-url>/api` (use URL from Step 1)
   - [ ] `NEXT_PUBLIC_URL=<your-frontend-url>` (will get after first deploy)
   - [ ] `NEXT_PUBLIC_SUPABASE_URL`
   - [ ] `NEXT_PUBLIC_SUPABASE_ANON_KEY`

3. **Update Frontend URL**
   - [ ] After first deployment, copy frontend URL
   - [ ] Update `NEXT_PUBLIC_URL` with the actual frontend URL
   - [ ] Trigger redeploy if needed

## Step 3: Verify Deployment

- [ ] Backend health check: `https://your-backend.railway.app/health` (or similar)
- [ ] Frontend loads: `https://your-frontend.railway.app`
- [ ] Frontend can connect to backend (check browser console for errors)

## Common Issues

### "Dockerfile not found"
**Solution**: Make sure Root Directory is set correctly:
- Backend: `/backend`
- Frontend: `/frontend`

### "Frontend can't connect to backend"
**Solution**:
1. Verify `NEXT_PUBLIC_BACKEND_URL` is set correctly
2. Make sure it includes `/api` path
3. Ensure backend is deployed and accessible

### "Build fails"
**Solution**:
1. Check Railway build logs
2. Verify all required environment variables are set
3. Test Docker build locally first

## Testing Locally

Before deploying, test the Dockerfiles locally:

```bash
# Test backend
cd backend
docker build -t backend-test .
docker run -p 8000:8000 --env-file .env backend-test

# Test frontend
cd frontend
docker build -t frontend-test .
docker run -p 3000:3000 --env-file .env frontend-test
```

## Environment Variables Reference

See `RAILWAY_SETUP.md` for complete environment variable documentation.

### Quick Copy (Backend Minimum)
```bash
ENV_MODE=production
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
REDIS_HOST=
UPSTASH_REDIS_REST_URL=
UPSTASH_REDIS_REST_TOKEN=
ANTHROPIC_API_KEY=
TAVILY_API_KEY=
FIRECRAWL_API_KEY=
DAYTONA_API_KEY=
DAYTONA_SERVER_URL=https://app.daytona.io/api
DAYTONA_TARGET=us
```

### Quick Copy (Frontend Minimum)
```bash
NEXT_PUBLIC_ENV_MODE=production
NEXT_PUBLIC_BACKEND_URL=https://your-backend.railway.app/api
NEXT_PUBLIC_URL=https://your-frontend.railway.app
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
```

## Next Steps

- [ ] Set up custom domain (optional)
- [ ] Configure Railway health checks
- [ ] Set up monitoring and alerts
- [ ] Configure auto-scaling if needed

## Support

For Railway-specific issues, see:
- [Railway Documentation](https://docs.railway.app/)
- [Railway Discord](https://discord.gg/railway)

For application issues, check the project documentation.
