# Quick Start Guide with Your API Keys

You've provided all the necessary API keys! Here's how to get started:

## ✅ Step 1: Create Backend Environment File

Run this command to create `backend/.env` with your credentials:

```bash
python create_env.py
```

This will:
- Create `backend/.env` with all your API keys
- Generate a secure `ENCRYPTION_KEY` automatically
- Preserve your existing file if you want to keep it

## ✅ Step 2: Create Frontend Environment File

Create `frontend/.env.local` with these values:

```bash
cat > frontend/.env.local << 'EOF'
NEXT_PUBLIC_ENV_MODE=local
NEXT_PUBLIC_SUPABASE_URL=https://db.rtwcwwfpwahnpdeggoku.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0d2N3d2Zwd2FobnBkZWdnb2t1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxMzMwODYsImV4cCI6MjA3NzcwOTA4Nn0.6y7Xuh2mESxbEFoQOjNOrLf0Fa3bRsmKbSxltC848w0
NEXT_PUBLIC_BACKEND_URL=http://localhost:8000/api
NEXT_PUBLIC_URL=http://localhost:3000
EOF
```

Or create it manually:

```env
NEXT_PUBLIC_ENV_MODE=local
NEXT_PUBLIC_SUPABASE_URL=https://db.rtwcwwfpwahnpdeggoku.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0d2N3d2Zwd2FobnBkZWdnb2t1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIxMzMwODYsImV4cCI6MjA3NzcwOTA4Nn0.6y7Xuh2mESxbEFoQOjNOrLf0Fa3bRsmKbSxltC848w0
NEXT_PUBLIC_BACKEND_URL=http://localhost:8000/api
NEXT_PUBLIC_URL=http://localhost:3000
```

## 🚀 Step 3: Start the Application

### Option A: Using Docker Compose (Easier)

```bash
python start.py
```

Or manually:
```bash
docker compose up -d
```

### Option B: Manual Setup (More Control)

Start each service in a separate terminal:

**Terminal 1 - Redis:**
```bash
docker compose up redis -d
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm install  # First time only
npm run dev
```

**Terminal 3 - Backend:**
```bash
cd backend
uv run api.py
```

**Terminal 4 - Background Worker:**
```bash
cd backend
uv run dramatiq --processes 4 --threads 4 run_agent_background
```

## 🌐 Access the Application

Once all services are running:
- **Frontend**: http://localhost:3000
- **Backend API**: http://localhost:8000

## 📝 Important Notes

### About QSTASH
You've provided QSTASH credentials, but according to the codebase:
- QSTASH-based scheduling has been **replaced with Supabase Cron**
- Your QSTASH credentials are saved but may not be actively used
- This is fine - they're included in your `.env` file in case they're needed

### About Redis
- The project uses **local Redis** (via Docker) for development
- Your QSTASH credentials are separate from Redis
- Redis is used for task queuing and caching

### Missing Values
You may need to generate these if they're not set:
- `MCP_CREDENTIAL_ENCRYPTION_KEY` - Auto-generated if missing
- `TRIGGER_WEBHOOK_SECRET` - Auto-generated if missing  
- `KORTIX_ADMIN_API_KEY` - Auto-generated if missing
- `SUPABASE_JWT_SECRET` - **Important!** Get this from Supabase dashboard if not set

### Supabase JWT Secret
If you haven't set `SUPABASE_JWT_SECRET`, get it from:
1. Go to your Supabase project dashboard
2. Settings → API → JWT Settings
3. Copy the JWT Secret

Add it to `backend/.env`:
```env
SUPABASE_JWT_SECRET=your-jwt-secret-here
```

## 🔍 Verify Your Setup

Check that services are running:

```bash
# Check Docker containers
docker compose ps

# Check backend health
curl http://localhost:8000/api/health

# Check frontend
curl http://localhost:3000
```

## 🐛 Troubleshooting

**Backend won't start:**
- Check `backend/.env` exists and has all required keys
- Verify Redis is running: `docker compose ps redis`
- Check logs: `docker compose logs backend`

**Frontend won't connect:**
- Verify `frontend/.env.local` has correct `NEXT_PUBLIC_BACKEND_URL`
- Make sure backend is running on port 8000
- Check browser console for errors

**Database connection errors:**
- Verify Supabase URL and keys in `.env`
- Check if migrations are applied (run `python setup.py` if needed)

## 📚 Next Steps

1. ✅ Run `python create_env.py` to create backend/.env
2. ✅ Create frontend/.env.local (see above)
3. ✅ Start services with `python start.py` or manually
4. ✅ Access at http://localhost:3000

For more details, see [LOCAL_DEV_GUIDE.md](./LOCAL_DEV_GUIDE.md)

