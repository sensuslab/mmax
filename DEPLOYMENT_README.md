# 🚀 Kortix/Suna - Server Deployment Package

This package contains everything you need to deploy Kortix/Suna to your virtual server with **Upstash Redis** and **Cloud Supabase**.

---

## 📦 What's Included

```
mmax/
├── server-setup.sh              # Server prerequisites installer
├── deploy.sh                    # One-click deployment script
├── .env.production              # Production environment template
├── docker-compose.production.yaml # Production compose file
├── CUSTOMIZATION_GUIDE.md       # UI & Agent customization guide
├── SERVER_DEPLOYMENT_GUIDE.md   # Detailed deployment instructions
└── DEPLOYMENT_README.md         # This file
```

---

## ⚡ Quick Start (3 Steps)

### Step 1: Setup Your Server
SSH into your server and run:
```bash
chmod +x server-setup.sh
./server-setup.sh
```

### Step 2: Deploy the Application
```bash
chmod +x deploy.sh
./deploy.sh
```

### Step 3: Access Your Application
- **Web UI**: http://your-server-ip:3000
- **API**: http://your-server-ip:8000

**That's it!** Your Kortix/Suna instance is running! 🎉

---

## 🔑 Your Configuration

### ✅ Pre-Configured Services

Your `.env.production` already includes:

- **Database**: ✅ Supabase (Cloud) - Configured
- **Redis**: ✅ Upstash (Cloud) - Configured
- **LLM Providers**:
  - ✅ Anthropic Claude
  - ✅ OpenAI
  - ✅ Groq
  - ✅ Gemini
  - ✅ MiniMax
- **Search**:
  - ✅ Tavily (web search)
  - ✅ Exa (people search)
- **Web Scraping**:
  - ✅ Firecrawl
- **Sandbox**:
  - ✅ Daytona (code execution)
- **Integrations**:
  - ✅ Composio (200+ tools)
- **Messaging**:
  - ✅ QStash

**No additional setup required** - everything is ready to go!

---

## 📋 Server Requirements

- **OS**: Ubuntu 20.04+ / Debian 11+
- **RAM**: 2GB minimum (4GB+ recommended)
- **Storage**: 20GB+ available space
- **Network**: Public IP address
- **Access**: SSH with sudo privileges

---

## 🎨 Customization

### Front Page Customization
**File**: `frontend/src/lib/home.tsx`

**Easy changes:**
- Brand name (hero section)
- Pricing plans
- Company logos
- FAQ content
- Feature descriptions

**See**: `CUSTOMIZATION_GUIDE.md` for complete details

### Agent Configuration
**Access**: http://your-server-ip:3000 → Agents → Configure

**Configure:**
- Instructions & behavior
- Tools (web search, code execution, etc.)
- Integrations (APIs, webhooks)
- Knowledge base (documents, data)
- Triggers (automation)

**See**: `CUSTOMIZATION_GUIDE.md` for detailed instructions

---

## 🛠️ Management Commands

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
git pull
./deploy.sh
```

### Stop Services
```bash
docker compose -f docker-compose.production.yaml down
```

---

## 📊 Monitoring

### Check Status
```bash
docker compose -f docker-compose.production.yaml ps
```

### Resource Usage
```bash
docker stats
```

### Health Checks
```bash
# Backend
curl http://localhost:8000/health

# Frontend
curl http://localhost:3000
```

---

## 🌐 Production Setup (Recommended)

### 1. Setup Domain
Update DNS records to point your domain to your server's IP

### 2. Install Nginx
```bash
sudo apt update
sudo apt install -y nginx
```

### 3. Setup SSL (Let's Encrypt)
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d your-domain.com
```

See `SERVER_DEPLOYMENT_GUIDE.md` for complete Nginx configuration

---

## 📚 Documentation

| Document | Description |
|----------|-------------|
| `SERVER_DEPLOYMENT_GUIDE.md` | Complete deployment instructions with troubleshooting |
| `CUSTOMIZATION_GUIDE.md` | How to customize UI and agent flows |
| This file (`DEPLOYMENT_README.md`) | Quick start guide |

---

## 🆘 Troubleshooting

### Services Won't Start
```bash
# Check logs
docker compose -f docker-compose.production.yaml logs

# Common fix: Rebuild from scratch
docker compose -f docker-compose.production.yaml down
docker system prune -a
./deploy.sh
```

### Frontend Build Fails
```bash
# Check available disk space
df -h

# Increase if needed
docker system prune -a
```

### Backend API Errors
```bash
# Verify environment variables
cat backend/.env

# Check backend logs
docker compose -f docker-compose.production.yaml logs backend
```

### Need Help?
- **GitHub Issues**: https://github.com/Kortix-ai/Suna/issues
- **Discord**: https://discord.gg/Py6pCBUUPw

---

## ✨ What You Can Do Now

1. **🎨 Customize Branding**
   - Edit `frontend/src/lib/home.tsx`
   - Add your logo
   - Update pricing

2. **🤖 Create Your First Agent**
   - Visit http://your-server-ip:3000
   - Sign up/login
   - Create and configure an agent

3. **🔗 Add Integrations**
   - Connect your APIs
   - Setup webhooks
   - Enable tools

4. **📚 Upload Knowledge**
   - Add documents
   - Connect data sources
   - Build your knowledge base

5. **⚙️ Setup Automation**
   - Create triggers
   - Schedule tasks
   - Automate workflows

---

## 🎯 Architecture Overview

```
┌─────────────────────────────────────────┐
│           Your Server                   │
│                                         │
│  ┌─────────────┐  ┌─────────────┐      │
│  │  Frontend   │  │   Nginx     │      │
│  │  (Port 3000)│  │ (Reverse    │      │
│  └─────────────┘  │  Proxy)     │      │
│         │         └─────────────┘      │
│  ┌─────────────┐         │             │
│  │   Backend   │         │             │
│  │ (Port 8000) │         │             │
│  └─────────────┘         │             │
│         │                │             │
│  ┌─────────────┐         │             │
│  │   Worker    │         │             │
│  │  (Dramatiq) │         │             │
│  └─────────────┘         │             │
└─────────────┬────────────┘             │
              │                          │
    ┌─────────▼─────────┐                │
    │   Upstash Redis   │                │
    │   (Cloud Redis)   │                │
    └─────────┬─────────┘                │
              │                          │
    ┌─────────▼─────────┐                │
    │   Supabase        │                │
    │   (Cloud DB)      │                │
    └───────────────────┘                │
                                         │
    ┌────────────────────────────────────┐
    │ External Services                   │
    │ • Anthropic/OpenAI/Groq (LLMs)     │
    │ • Tavily (Search)                   │
    │ • Firecrawl (Scraping)              │
    │ • Daytona (Sandbox)                 │
    │ • Composio (Integrations)           │
    └────────────────────────────────────┘
```

---

## 🔒 Security Notes

- ✅ Environment variables are in `backend/.env`
- ✅ API keys are encrypted at rest
- ✅ Supabase provides RLS (Row Level Security)
- ✅ Redis connection uses SSL
- ⚠️ For production: Use strong passwords
- ⚠️ For production: Enable firewall (ufw)
- ⚠️ For production: Keep system updated

---

## 📈 Scaling

### Horizontal Scaling
```bash
# Scale workers
docker compose -f docker-compose.production.yaml up -d --scale worker=3
```

### Resource Limits
Edit `docker-compose.production.yaml`:
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 2G
          cpus: '1.0'
```

---

## 🎉 You're Ready!

Your Kortix/Suna deployment is complete with:
- ✅ Production-ready configuration
- ✅ Cloud database (Supabase)
- ✅ Cloud Redis (Upstash)
- ✅ All necessary integrations
- ✅ Docker containerization
- ✅ Easy customization

**Launch your AI workforce now!** 🚀

---

**Questions?** Check the documentation or join our Discord!
