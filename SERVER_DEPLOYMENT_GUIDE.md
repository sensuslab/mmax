# 🚀 Kortix/Suna Server Deployment Guide

This guide walks you through deploying Kortix/Suna to your virtual server using **Upstash Redis** and **Cloud Supabase**.

---

## 📋 Prerequisites

### Your Server Should Have:
- **OS**: Ubuntu 20.04+ / Debian 11+ / or similar Linux distribution
- **RAM**: Minimum 2GB (4GB+ recommended)
- **Storage**: 20GB+ available space
- **Network**: Public IP address
- **Access**: SSH access with sudo privileges

### What We'll Deploy:
- ✅ **Frontend**: Next.js web application (Port 3000)
- ✅ **Backend**: FastAPI Python API (Port 8000)
- ✅ **Worker**: Background task processor
- ✅ **Database**: Supabase (Cloud - already configured)
- ✅ **Redis**: Upstash (Cloud - already configured)

---

## 🛠️ Step 1: Server Setup

### 1.1 Run the Setup Script

SSH into your server and run:

```bash
# Make the setup script executable
chmod +x server-setup.sh

# Run the setup script
./server-setup.sh
```

This script will install:
- Docker & Docker Compose
- Python 3.11+
- Node.js 20+
- uv (Python package manager)
- mise (tool version manager)
- All system dependencies

**⏱️ Expected Time:** 5-10 minutes

---

## 📁 Step 2: Deploy the Application

### 2.1 Upload Your Code

**Option A: Git Clone** (Recommended)
```bash
# Clone your repository
git clone <your-repo-url>
cd <your-repo-directory>

# Or if you have the code locally, copy it:
# scp -r /path/to/code user@your-server:/home/user/mmax
```

**Option B: SCP Upload**
```bash
# From your local machine
scp -r /path/to/mmax user@your-server:/home/user/
```

### 2.2 Configure Environment Variables

```bash
# Copy the production environment file
cp .env.production backend/.env

# Verify it was created
ls -la backend/.env
```

### 2.3 Build and Start Services

```bash
# Using Docker Compose (Production)
docker compose -f docker-compose.production.yaml up -d

# View logs
docker compose -f docker-compose.production.yaml logs -f

# Check status
docker compose -f docker-compose.production.yaml ps
```

**⏱️ Expected Time:** 10-15 minutes (first build)

---

## 🔍 Step 3: Verify Deployment

### 3.1 Check Service Health

```bash
# Check all containers are running
docker compose -f docker-compose.production.yaml ps

# Expected output:
# NAME                    STATUS
# mmax-frontend-1         Up
# mmax-backend-1          Up
# mmax-worker-1           Up
```

### 3.2 Test Endpoints

```bash
# Test backend API
curl http://localhost:8000/health
# Expected: {"status": "ok"}

# Test frontend (should return HTML)
curl http://localhost:3000
```

### 3.3 View Logs

```bash
# All services
docker compose -f docker-compose.production.yaml logs

# Specific service
docker compose -f docker-compose.production.yaml logs backend
docker compose -f docker-compose.production.yaml logs worker
docker compose -f docker-compose.production.yaml logs frontend

# Follow logs in real-time
docker compose -f docker-compose.production.yaml logs -f
```

---

## 🌐 Step 4: Configure Domain (Optional but Recommended)

### 4.1 Setup Nginx (Reverse Proxy)

Install Nginx:
```bash
sudo apt update
sudo apt install -y nginx
```

Create Nginx configuration:
```bash
sudo nano /etc/nginx/sites-available/kortix
```

Add this configuration:
```nginx
server {
    listen 80;
    server_name your-domain.com www.your-domain.com;

    # Frontend (Next.js)
    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }

    # Backend API
    location /api/ {
        proxy_pass http://localhost:8000/;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

Enable the site:
```bash
sudo ln -s /etc/nginx/sites-available/kortix /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 4.2 Setup SSL (Let's Encrypt)

```bash
# Install Certbot
sudo apt install -y certbot python3-certbot-nginx

# Get SSL certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal (adds to crontab)
sudo crontab -e
# Add this line:
0 12 * * * /usr/bin/certbot renew --quiet
```

---

## 🔧 Step 5: Customize Your Deployment

### 5.1 Front Page Customization

Edit the home page configuration:
```bash
nano frontend/src/lib/home.tsx
```

**Key sections to customize:**
- **Hero Title** (line ~112): Change your brand name
- **Description** (line ~113): Update your value proposition
- **Pricing** (line ~117): Modify plans and pricing
- **Company Logos** (line ~300): Add your logos
- **FAQ** (line ~1179): Update questions and answers

After changes, rebuild:
```bash
# Rebuild frontend
docker compose -f docker-compose.production.yaml up -d --build frontend
```

### 5.2 Agent Configuration

1. **Access the Dashboard**
   - Navigate to `http://your-domain.com` (or `http://your-server-ip`)
   - Sign up/login

2. **Create Your Agent**
   - Go to Agents section
   - Click "New Agent"
   - Configure:
     - **Instructions**: Define agent behavior
     - **Tools**: Enable web search, code execution, etc.
     - **Integrations**: Connect APIs and services
     - **Knowledge**: Upload documents
     - **Triggers**: Set up automation

3. **Test Your Agent**
   - Click "Start Chat"
   - Send test messages
   - Verify tools work correctly

**📖 Full Customization Guide**: See `CUSTOMIZATION_GUIDE.md`

---

## 🔄 Step 6: Maintenance & Updates

### 6.1 Update the Application

```bash
# Pull latest changes
git pull origin main

# Rebuild and restart
docker compose -f docker-compose.production.yaml up -d --build

# Clean old images (optional)
docker image prune -a
```

### 6.2 Backup Configuration

```bash
# Backup environment variables
cp backend/.env ~/backups/.env-$(date +%Y%m%d)

# Backup customizations
git add .
git commit -m "Backup customizations"
git push origin main
```

### 6.3 Monitor Logs

```bash
# Check logs periodically
docker compose -f docker-compose.production.yaml logs --tail=100

# Setup log rotation
sudo nano /etc/logrotate.d/kortix
```

Add:
```
/var/lib/docker/containers/*/*.log {
    rotate 7
    daily
    compress
    size=10M
    missingok
    delaycompress
    copytruncate
}
```

---

## 📊 Step 7: Monitoring

### 7.1 View Resource Usage

```bash
# Docker stats
docker stats

# System resources
htop
df -h
```

### 7.2 Setup Monitoring (Optional)

**Using Uptime Kuma:**
```bash
docker run -d \
  --name uptime-kuma \
  -p 3001:3001 \
  louislam/uptime-kuma
```

Access at: `http://your-server-ip:3001`

---

## 🆘 Troubleshooting

### Backend Won't Start

**Check logs:**
```bash
docker compose -f docker-compose.production.yaml logs backend
```

**Common issues:**
- Missing environment variables: Verify `.env` file
- Port already in use: `sudo lsof -i :8000`
- API key errors: Check all required keys in `.env`

### Frontend Build Fails

**Check logs:**
```bash
docker compose -f docker-compose.production.yaml logs frontend
```

**Common issues:**
- Node.js version: Should be 20+
- Missing dependencies: Rebuild with `--build` flag
- Memory issues: Add swap or use smaller instance

### Worker Not Processing Tasks

**Check logs:**
```bash
docker compose -f docker-compose.production.yaml logs worker
```

**Common issues:**
- Redis connection: Verify Upstash credentials
- Database connection: Check Supabase keys
- Model API keys: Verify LLM provider keys

### Database Connection Errors

**Verify Supabase:**
```bash
# Test connection
curl -H "apikey: YOUR_ANON_KEY" \
     -H "Authorization: Bearer YOUR_ANON_KEY" \
     YOUR_SUPABASE_URL/rest/v1/
```

### Redis Connection Issues

**Verify Upstash:**
```bash
# Test with redis-cli (if installed)
redis-cli -h smiling-monster-25745.upstash.io -p 6379 -a YOUR_TOKEN ping
```

---

## 📞 Support

### Useful Commands

```bash
# Restart all services
docker compose -f docker-compose.production.yaml restart

# Stop all services
docker compose -f docker-compose.production.yaml down

# View service status
docker compose -f docker-compose.production.yaml ps

# Shell into container
docker compose -f docker-compose.production.yaml exec backend bash
docker compose -f docker-compose.production.yaml exec frontend sh

# Check disk usage
docker system df
docker system prune
```

### Getting Help

- **GitHub Issues**: https://github.com/Kortix-ai/Suna/issues
- **Discord**: https://discord.gg/Py6pCBUUPw
- **Documentation**: See `CUSTOMIZATION_GUIDE.md`

---

## ✅ Deployment Checklist

- [ ] Server meets minimum requirements
- [ ] Setup script completed successfully
- [ ] Code uploaded to server
- [ ] `.env` file configured
- [ ] Docker services running
- [ ] Backend health check passed
- [ ] Frontend accessible
- [ ] Domain configured (if using)
- [ ] SSL certificate installed (if using)
- [ ] Custom branding updated
- [ ] First agent created and tested
- [ ] Monitoring set up (optional)
- [ ] Backup strategy implemented

---

## 🎉 You're All Set!

Your Kortix/Suna instance is now running on your virtual server with:

- ✅ **Upstash Redis** for caching and task queues
- ✅ **Cloud Supabase** for database and auth
- ✅ **Docker** for easy deployment
- ✅ **Custom branding** ready to configure

**Next Steps:**
1. Customize your front page (see `CUSTOMIZATION_GUIDE.md`)
2. Configure your agents
3. Add your integrations
4. Launch your AI workforce! 🚀

---

**Happy deploying!** 🎊
