# 📦 Kortix/Suna - Deployment Package Summary

## 🎯 What This Package Contains

### AUTOMATED DEPLOYMENT FILES (New!)

These files enable **one-command deployment** with minimal file transfer:

| File | Size | Purpose |
|------|------|---------|
| `server-setup-auto.sh` | ~15 KB | Installs prerequisites + clones repo |
| `deploy-with-config.sh` | ~8 KB | Deploys application with config |
| `config.env.template` | ~5 KB | Environment configuration template |
| `QUICK_START_AUTO.md` | - | Automated deployment guide |

**Total transfer size: ~28 KB** (vs ~100 MB for full repo!)

---

### STANDARD DEPLOYMENT FILES (Alternative)

These are the original files for manual deployment:

| File | Purpose |
|------|---------|
| `server-setup.sh` | Prerequisites installer |
| `deploy.sh` | Standard deployment script |
| `.env.production` | Production environment config |
| `docker-compose.production.yaml` | Production compose file |
| `CUSTOMIZATION_GUIDE.md` | UI & agent customization |
| `SERVER_DEPLOYMENT_GUIDE.md` | Detailed deployment guide |
| `DEPLOYMENT_README.md` | Quick start overview |

---

## 🚀 Quick Start Options

### Option A: AUTOMATED (Recommended) - 2 Files Only!

**Transfer these 2 files to your server:**
1. `server-setup-auto.sh`
2. `config.env` (copy from `config.env.template`)

**Then run:**
```bash
./server-setup-auto.sh
cd suna
cp ../config.env config.env
./deploy-with-config.sh
```

**See**: `QUICK_START_AUTO.md` for complete instructions

---

### Option B: Standard - Upload Full Package

**Transfer all files to your server:**
- `server-setup.sh`
- `deploy.sh`
- `.env.production`
- `docker-compose.production.yaml`
- `CUSTOMIZATION_GUIDE.md`
- `SERVER_DEPLOYMENT_GUIDE.md`
- `DEPLOYMENT_README.md`

**Then run:**
```bash
./server-setup.sh
cp .env.production backend/.env
./deploy.sh
```

**See**: `DEPLOYMENT_README.md` for instructions

---

## 📋 Server Requirements

- **OS**: Ubuntu 20.04+ / Debian 11+ / similar Linux
- **RAM**: 2GB minimum (4GB+ recommended)
- **Storage**: 20GB+ available space
- **Network**: Public IP address
- **Access**: SSH with sudo privileges

---

## ✅ Pre-Configured Services

Your configuration includes:

### Databases & Caching
- ✅ **Supabase** (Cloud PostgreSQL) - URL & keys configured
- ✅ **Upstash Redis** (Cloud Redis) - URL & token configured

### LLM Providers
- ✅ **Anthropic Claude** - API key configured
- ✅ **OpenAI** - API key configured
- ✅ **Groq** - API key configured
- ✅ **Google Gemini** - API key configured
- ✅ **MiniMax** - API key & model configured
- ✅ **xAI (Grok)** - Ready to add key
- ✅ **OpenRouter** - Ready to add key

### Search & Data
- ✅ **Tavily** (web search) - API key configured
- ✅ **Exa** (people search) - API key configured

### Web & Content
- ✅ **Firecrawl** (web scraping) - API key configured
- ✅ **Daytona** (code sandbox) - API key configured

### Integrations
- ✅ **Composio** (200+ tools) - API key configured
- ✅ **QStash** (messaging) - Configured

### Billing & Analytics
- ✅ **Stripe** - Ready to add keys
- ✅ **Langfuse** - Ready to add keys

**Everything is ready - just deploy!** 🎉

---

## 🎨 What You Can Customize

### Front Page
**File**: `frontend/src/lib/home.tsx` (after deployment)

**Sections:**
- Hero title & description (lines 83-116)
- Pricing plans (lines 117-299)
- Company logos (lines 300-500)
- Features (lines 501-581)
- FAQ (lines 1179-1221)
- Footer links (lines 1232-1273)

**After changes:**
```bash
cd suna
docker compose -f docker-compose.production.yaml up -d --build frontend
```

### Agents
**Access**: http://YOUR_SERVER_IP:3000 → Dashboard → Agents

**Configuration:**
- Instructions (agent behavior)
- Tools (web search, code execution, file processing, etc.)
- Integrations (APIs, webhooks, services)
- Knowledge (documents, data sources)
- Triggers (automation, schedules)

---

## 🔧 Common Commands

### View Status
```bash
docker compose -f docker-compose.production.yaml ps
```

### View Logs
```bash
# All services
docker compose -f docker-compose.production.yaml logs -f

# Specific service
docker compose -f docker-compose.production.yaml logs -f backend
docker compose -f docker-compose.production.yaml logs -f frontend
docker compose -f docker-compose.production.yaml logs -f worker
```

### Restart Services
```bash
docker compose -f docker-compose.production.yaml restart
```

### Update Application
```bash
cd suna
git pull
./deploy-with-config.sh
```

### Stop Services
```bash
docker compose -f docker-compose.production.yaml down
```

---

## 📚 Documentation

| File | Description |
|------|-------------|
| `QUICK_START_AUTO.md` | **START HERE** - Automated deployment (2 files!) |
| `DEPLOYMENT_README.md` | Standard deployment quick start |
| `SERVER_DEPLOYMENT_GUIDE.md` | Complete deployment guide with troubleshooting |
| `CUSTOMIZATION_GUIDE.md` | UI & agent customization guide |
| `README_AUTO_DEPLOYMENT.md` | This file - package summary |

---

## 🆘 Troubleshooting

### Issue: "Repository not found"
**Solution**: Make sure you're in the parent directory of `suna`
```bash
ls -la suna  # Should exist
cd suna
```

### Issue: "Config file not found"
**Solution**: Copy config to right location
```bash
cp config.env suna/config.env
# Or
cp config.env backend/.env
```

### Issue: Services won't start
**Solution**: Check logs and rebuild
```bash
cd suna
docker compose -f docker-compose.production.yaml logs
docker compose -f docker-compose.production.yaml down
docker system prune -a
./deploy-with-config.sh
```

### Issue: Permission denied
**Solution**: Make scripts executable
```bash
chmod +x server-setup-auto.sh deploy-with-config.sh
```

---

## 🎯 Deployment Flow

### Automated Method
```
Local Machine                  Server
    │                              │
    │ 1. Copy config.env           │
    │    template → config.env     │
    │                              │
    │ 2. Transfer:                 │
    │    - server-setup-auto.sh    │
    │    - config.env              │
    │                              │
    │                          3. SSH in
    │                          4. Run:
    │                             ./server-setup-auto.sh
    │                          5. Run:
    │                             ./deploy-with-config.sh
    │                              │
    │                          6. Access:
    │                             http://SERVER_IP:3000
    │                              │
    └──────────────────────────────┘
```

---

## ✨ What You Get

After deployment, you have:

1. **Frontend** (Next.js) - Port 3000
   - Customizable home page
   - User authentication
   - Agent dashboard
   - Real-time chat

2. **Backend** (FastAPI) - Port 8000
   - REST API
   - Agent orchestration
   - Task processing
   - Integration endpoints

3. **Worker** (Dramatiq)
   - Background task processing
   - Async operations
   - Queue management

4. **Database** (Supabase Cloud)
   - User management
   - Agent data
   - Conversations
   - Files & knowledge

5. **Redis** (Upstash Cloud)
   - Caching
   - Task queues
   - Session storage

---

## 🎉 You're Ready!

**Choose your deployment method:**

1. **Automated** (2 files) - See `QUICK_START_AUTO.md` ⭐
2. **Standard** (full package) - See `DEPLOYMENT_README.md`

**Questions?** Check the documentation or join our Discord!

---

**Happy deploying!** 🚀✨🎊
