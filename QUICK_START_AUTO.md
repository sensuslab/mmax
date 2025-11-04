# 🚀 Kortix/Suna - AUTOMATED DEPLOYMENT (2 Files Only!)

This is the **SIMPLIFIED** deployment method - just transfer 2 small files and run 2 commands!

---

## 📦 What You Need

Only **2 files** to transfer to your server:
1. `server-setup-auto.sh` - Installs everything & clones repo
2. `config.env` - Your configuration (just copy and rename `config.env.template`)

**Everything else is auto-downloaded!**

---

## ⚡ Ultra-Quick Start (3 Steps)

### Step 1: Prepare Config (On Your Local Machine)
```bash
# Copy the template
cp config.env.template config.env

# Edit it (optional - already has all your keys!)
nano config.env
```

### Step 2: Transfer & Run (On Your Server)

**Transfer files:**
```bash
# Method 1: SCP both files
scp server-setup-auto.sh user@SERVER_IP:~/
scp config.env user@SERVER_IP:~/

# Method 2: Or transfer together
tar -czf deploy-auto.tar.gz server-setup-auto.sh config.env.template
scp deploy-auto.tar.gz user@SERVER_IP:~/
```

**SSH into server:**
```bash
ssh user@SERVER_IP
```

**Run setup (one command!):**
```bash
chmod +x server-setup-auto.sh
./server-setup-auto.sh
```

**Run deployment (one command!):**
```bash
chmod +x deploy-with-config.sh
cp config.env.template config.env  # If using template
./deploy-with-config.sh
```

### Step 3: Access Your App! 🎉
- **Web UI**: http://YOUR_SERVER_IP:3000
- **API**: http://YOUR_SERVER_IP:8000

**That's it!** Your Kortix/Suna instance is running!

---

## 📋 Detailed Instructions

### Local Preparation

**1. Copy and edit config:**
```bash
# Copy template
cp config.env.template config.env

# Optionally customize (it's already configured!)
# nano config.env
```

**2. Verify your config has:**
```bash
grep -E "(SUPABASE_|UPSTASH_|ANTHROPIC_|OPENAI_|TAVILY_|FIRECRAWL_|DAYTONA_|COMPOSIO_)" config.env
# Should show all your keys
```

### Server Deployment

**1. Transfer files:**
```bash
# Simple transfer
scp server-setup-auto.sh user@SERVER_IP:~/
scp config.env user@SERVER_IP:~/

# Or create a package
tar -czf kortix-auto.tar.gz server-setup-auto.sh config.env
scp kortix-auto.tar.gz user@SERVER_IP:~/
```

**2. SSH and setup:**
```bash
ssh user@SERVER_IP

# If you used tar
tar -xzf kortix-auto.tar.gz

# Make executable
chmod +x server-setup-auto.sh deploy-with-config.sh

# Run automated setup (installs everything + clones repo)
./server-setup-auto.sh
```

**3. Configure and deploy:**
```bash
# Copy config to repo location
cp config.env suna/config.env

# Deploy
cd suna
chmod +x deploy-with-config.sh
./deploy-with-config.sh
```

**4. Done!** Access at http://SERVER_IP:3000

---

## 🎯 What Happens Automatically

### server-setup-auto.sh does:
1. ✅ Installs Docker & Docker Compose
2. ✅ Installs Python 3.11+
3. ✅ Installs Node.js 20+
4. ✅ Installs uv (Python package manager)
5. ✅ Installs mise (tool version manager)
6. ✅ Clones Kortix/Suna repository
7. ✅ Verifies all installations
8. ✅ Shows next steps

### deploy-with-config.sh does:
1. ✅ Finds or creates config.env
2. ✅ Copies config to backend/.env
3. ✅ Builds Docker images
4. ✅ Starts all services
5. ✅ Waits for services to be ready
6. ✅ Verifies deployment
7. ✅ Shows status and endpoints

---

## 🔧 Single-Command Deploy

**Combine everything into ONE command:**
```bash
# On your server, after uploading files:
tar -xzf kortix-auto.tar.gz \
  && chmod +x server-setup-auto.sh deploy-with-config.sh \
  && ./server-setup-auto.sh \
  && cd suna && cp ../config.env config.env \
  && ./deploy-with-config.sh
```

---

## 📊 File Sizes (Tiny!)

```
server-setup-auto.sh       ~15 KB
config.env                 ~5 KB
TOTAL TO TRANSFER          ~20 KB
```

Compared to transferring the entire repository (~100 MB) - **99% smaller!**

---

## 🎨 After Deployment

### Customize Front Page
```bash
cd suna
nano frontend/src/lib/home.tsx
# Edit lines 83-299 (hero, pricing, logos, FAQ)
# Then rebuild:
docker compose -f docker-compose.production.yaml up -d --build frontend
```

### Configure Agents
1. Visit http://YOUR_SERVER_IP:3000
2. Sign up/login
3. Go to Agents → New Agent
4. Configure:
   - Instructions
   - Tools (web search, code execution, etc.)
   - Integrations (APIs, webhooks)
   - Knowledge (documents)
   - Triggers (automation)

---

## 🔄 Update Process

```bash
cd suna
git pull
./deploy-with-config.sh
```

**That's it!** Updates and redeploys automatically.

---

## 📚 Complete File List

```
YOUR LOCAL MACHINE:
├── server-setup-auto.sh      (Transfer to server)
├── config.env                (Transfer to server, edit if needed)
└── deploy-with-config.sh     (Already in repo, auto-downloaded)

YOUR SERVER (after setup):
├── server-setup-auto.sh
├── config.env
└── suna/                     (Auto-cloned)
    ├── deploy-with-config.sh
    ├── frontend/
    ├── backend/
    ├── docker-compose.production.yaml
    └── ...
```

---

## 🆘 Troubleshooting

### Config Not Found
```bash
# Make sure config.env is in the right place
ls -la suna/config.env
# If not found, copy it:
cp config.env suna/config.env
```

### Services Won't Start
```bash
# Check logs
cd suna
docker compose -f docker-compose.production.yaml logs

# Common fix: rebuild
docker compose -f docker-compose.production.yaml down
docker system prune -a
./deploy-with-config.sh
```

### Permission Denied
```bash
# Make scripts executable
chmod +x server-setup-auto.sh deploy-with-config.sh
```

---

## ✅ Deployment Checklist

**Local:**
- [ ] Copied config.env.template to config.env
- [ ] Verified all API keys are present
- [ ] Transferred server-setup-auto.sh to server
- [ ] Transferred config.env to server

**Server:**
- [ ] Ran ./server-setup-auto.sh
- [ ] Repository cloned successfully
- [ ] All prerequisites installed
- [ ] Ran ./deploy-with-config.sh
- [ ] Services running (docker compose -f docker-compose.production.yaml ps)
- [ ] Frontend accessible at http://SERVER_IP:3000
- [ ] Backend health check passed (curl http://localhost:8000/health)

---

## 🎉 Success!

Your Kortix/Suna instance is now running with:

- ✅ **Upstash Redis** (cloud)
- ✅ **Supabase** (cloud database)
- ✅ **Multiple LLM providers** (Claude, OpenAI, Groq, Gemini, MiniMax)
- ✅ **Search & Scraping** (Tavily, Firecrawl)
- ✅ **Code Execution** (Daytona sandbox)
- ✅ **Integrations** (Composio - 200+ tools)
- ✅ **Auto-updating** (git pull && deploy)

**Time to launch your AI workforce!** 🚀

---

## 📞 Support

- **Issues**: https://github.com/Kortix-ai/Suna/issues
- **Discord**: https://discord.gg/Py6pCBUUPw
- **Full Docs**: See CUSTOMIZATION_GUIDE.md

---

**Happy deploying!** ✨
