# Local Development Guide

This guide will help you run Kortix/Suna locally for development and testing.

## 🚀 Quick Start

The easiest way to get started:

```bash
python setup.py
```

This interactive wizard will:
1. ✅ Check prerequisites
2. 🔧 Configure environment variables
3. 📦 Install dependencies
4. 🚀 Start services

Then use:
```bash
python start.py  # Start/stop services based on your setup
```

## 📋 Prerequisites

### Required
- **Docker** - For Redis and optionally Supabase
- **Node.js v20+** and npm
- **Python 3.11+** and `uv` (install from https://github.com/astral-sh/uv)
- **Git**

### Recommended Tools
The project uses `mise` for tool management. Required versions are in `mise.toml`:
- Node.js: 20
- Python: 3.11.10
- uv: 0.6.5

Install mise: https://mise.jdx.dev/

## 🎯 Setup Methods

### Method 1: Docker Compose (Easier)

**Pros:**
- Single command to start everything
- Consistent environment
- Less manual configuration

**Cons:**
- Requires **Cloud Supabase** (local Supabase not supported)
- Less control for debugging

**Steps:**
1. Run `python setup.py` and choose "Docker Compose"
2. Choose "Cloud Supabase" when prompted
3. Configure API keys as needed
4. The wizard will start services automatically

**Manage services:**
```bash
python start.py          # Interactive start/stop
docker compose ps        # Check status
docker compose logs -f   # View logs
docker compose down      # Stop all services
```

**Access:**
- Frontend: http://localhost:3000
- Backend: http://localhost:8000

### Method 2: Manual Setup (More Flexible)

**Pros:**
- Supports **Local Supabase** (runs in Docker)
- Better for debugging
- More control over services

**Cons:**
- Need to manage multiple terminals
- More manual steps

**Steps:**

1. **Run setup wizard:**
   ```bash
   python setup.py
   ```
   Choose "Manual" setup and "Local Supabase" when prompted.

2. **Start services in separate terminals:**

   **Terminal 1 - Supabase (if using local):**
   ```bash
   cd backend
   npx supabase start
   ```

   **Terminal 2 - Redis:**
   ```bash
   docker compose up redis -d
   ```

   **Terminal 3 - Frontend:**
   ```bash
   cd frontend
   npm install  # First time only
   npm run dev
   ```

   **Terminal 4 - Backend:**
   ```bash
   cd backend
   uv run api.py
   ```

   **Terminal 5 - Background Worker:**
   ```bash
   cd backend
   uv run dramatiq --processes 4 --threads 4 run_agent_background
   ```

3. **Access the application:**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:8000

## 🔧 Configuration

### Environment Files

After running `setup.py`, these files are created:

- `backend/.env` - Backend configuration
- `frontend/.env.local` - Frontend configuration
- `apps/mobile/.env` - Mobile app configuration (if applicable)

### Required Services

**Supabase (Database & Auth):**
- Cloud: Create project at https://supabase.com/dashboard
- Local: Automatic setup via `npx supabase start` (recommended for dev)

**Optional but Recommended:**
- **LLM Provider**: Anthropic (Claude), OpenAI, Groq, etc.
- **Daytona**: For sandbox/agent execution
- **Search APIs**: Tavily, Firecrawl for web search/scraping

## 🛠️ Development Workflow

### Making Changes

1. **Backend changes:**
   - Edit files in `backend/`
   - The server auto-reloads (if using `uv run api.py`)
   - Restart if changes don't apply

2. **Frontend changes:**
   - Edit files in `frontend/src/`
   - Next.js hot-reloads automatically
   - Check browser console for errors

3. **Database changes:**
   - Add migrations to `backend/supabase/migrations/`
   - For local Supabase: `cd backend && npx supabase db reset`
   - For cloud: `cd backend && npx supabase db push`

### Useful Commands

**Docker Setup:**
```bash
python start.py          # Start/stop services
docker compose logs -f   # Follow all logs
docker compose logs -f backend  # Backend logs only
docker compose logs -f frontend # Frontend logs only
```

**Manual Setup:**
```bash
# Manage Redis
docker compose up redis -d    # Start
docker compose down           # Stop

# Supabase (local)
cd backend
npx supabase start          # Start
npx supabase stop           # Stop
npx supabase status         # Check status
npx supabase db reset       # Reset database

# Backend
cd backend
uv run api.py               # Start API server
uv run dramatiq run_agent_background  # Start worker

# Frontend
cd frontend
npm run dev                 # Development server
npm run build               # Production build
npm run start               # Production server
```

## 🐛 Troubleshooting

### Setup Issues

**"Docker not running"**
- Start Docker Desktop (or Docker daemon)

**"Node.js not found"**
- Install Node.js v20+ from nodejs.org
- Or use `mise` to manage versions

**"uv not found"**
- Install from: https://github.com/astral-sh/uv
- Or use `mise` to manage versions

### Runtime Issues

**Backend won't start:**
- Check `backend/.env` exists and has required keys
- Verify Supabase URL and keys are correct
- Check Redis is running: `docker compose ps`

**Frontend won't connect:**
- Verify `frontend/.env.local` has correct `NEXT_PUBLIC_BACKEND_URL`
- Check backend is running on port 8000
- Check browser console for CORS errors

**Database connection errors:**
- For local Supabase: Ensure `npx supabase start` completed
- For cloud: Verify project URL and keys in dashboard
- Check migrations applied: `cd backend && npx supabase db reset` (local)

**Port already in use:**
- Kill process using port: `lsof -ti:3000 | xargs kill` (Mac/Linux)
- Or change ports in docker-compose.yaml / .env files

## 📚 Additional Resources

- **Main README**: See project overview and architecture
- **Backend README**: `backend/README.md` for backend-specific details
- **Frontend README**: `frontend/README.md` for frontend details
- **Contributing Guide**: `CONTRIBUTING.md` for development guidelines

## 💡 Tips

1. **Use Local Supabase for Development**: Faster, no quotas, better for testing
2. **Keep .env files in .gitignore**: Never commit API keys
3. **Use `python start.py`**: It remembers your setup method and shows the right commands
4. **Check logs first**: Most issues are visible in service logs
5. **Reset if stuck**: For local Supabase, `npx supabase db reset` is your friend

## 🎉 You're Ready!

Once all services are running, access the app at **http://localhost:3000**

Happy coding! 🚀

