# Railway Deployment: Two Approaches Comparison

## Quick Decision Guide

**Use Approach 1 if**: You want the simplest setup and Railway detects your Dockerfiles
**Use Approach 2 if**: Railway fails to find Dockerfiles OR you need access to files outside the service directory

---

## Approach 1: Root Directory

### How it Works
- Sets Root Directory to `/backend` or `/frontend` in Railway UI
- Railway only clones that specific directory
- Automatically detects Dockerfile in that directory

### Configuration
```
Service Settings:
├── Root Directory: /backend (or /frontend)
└── Railway auto-detects Dockerfile

Optional: railway.json in subdirectory
```

### Pros
- ✅ Simpler configuration
- ✅ Smaller deployments (only clones one directory)
- ✅ Cleaner separation of services

### Cons
- ❌ Sometimes fails to detect Dockerfile
- ❌ Can't access files outside the root directory
- ❌ Not ideal for shared monorepo dependencies

### Backend Setup
```
1. Create service from repo
2. Set Root Directory: /backend
3. Add environment variables
```

### Frontend Setup
```
1. Create service from repo
2. Set Root Directory: /frontend
3. Add environment variables
```

---

## Approach 2: RAILWAY_DOCKERFILE_PATH

### How it Works
- Does NOT set Root Directory (leave empty)
- Railway clones the entire repository
- Uses environment variable to specify Dockerfile location

### Configuration
```
Service Settings:
├── Root Directory: (empty/none)
└── Environment Variables:
    └── RAILWAY_DOCKERFILE_PATH=backend/Dockerfile

No railway.json needed
```

### Pros
- ✅ More reliable Dockerfile detection
- ✅ Access to entire repository
- ✅ Better for shared dependencies
- ✅ Explicit Dockerfile location

### Cons
- ❌ Clones entire repo (slightly larger)
- ❌ Requires additional environment variable

### Backend Setup
```
1. Create service from repo
2. DO NOT set Root Directory
3. Add: RAILWAY_DOCKERFILE_PATH=backend/Dockerfile
4. Add other environment variables
```

### Frontend Setup
```
1. Create service from repo
2. DO NOT set Root Directory
3. Add: RAILWAY_DOCKERFILE_PATH=frontend/Dockerfile
4. Add other environment variables
```

---

## Side-by-Side Comparison

| Feature | Approach 1 (Root Dir) | Approach 2 (DOCKERFILE_PATH) |
|---------|----------------------|------------------------------|
| **Root Directory** | `/backend` or `/frontend` | None (empty) |
| **Dockerfile Detection** | Automatic (sometimes fails) | Explicit via env var |
| **Repository Clone** | Only subdirectory | Full repository |
| **Config Files** | Optional railway.json | Not needed |
| **Shared Dependencies** | No access | Full access |
| **Setup Complexity** | Simpler | Slightly more config |
| **Reliability** | Medium | High |
| **Best For** | Isolated services | Shared monorepos |

---

## Environment Variable Summary

### Approach 1: Root Directory
**Backend Variables**:
```bash
ENV_MODE=production
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
# ... other backend vars
```

**Frontend Variables**:
```bash
NEXT_PUBLIC_ENV_MODE=production
NEXT_PUBLIC_BACKEND_URL=https://backend.railway.app/api
# ... other frontend vars
```

### Approach 2: RAILWAY_DOCKERFILE_PATH
**Backend Variables**:
```bash
RAILWAY_DOCKERFILE_PATH=backend/Dockerfile  # ⚠️ ADD THIS FIRST
ENV_MODE=production
SUPABASE_URL=...
SUPABASE_ANON_KEY=...
# ... other backend vars
```

**Frontend Variables**:
```bash
RAILWAY_DOCKERFILE_PATH=frontend/Dockerfile  # ⚠️ ADD THIS FIRST
NEXT_PUBLIC_ENV_MODE=production
NEXT_PUBLIC_BACKEND_URL=https://backend.railway.app/api
# ... other frontend vars
```

---

## Troubleshooting Decision Tree

```
Railway can't find Dockerfile?
│
├─→ Using Approach 1?
│   │
│   ├─→ YES: Switch to Approach 2
│   │   1. Remove Root Directory setting
│   │   2. Add RAILWAY_DOCKERFILE_PATH variable
│   │   3. Redeploy
│   │
│   └─→ NO: Check these:
│       - Dockerfile name has capital 'D'
│       - RAILWAY_DOCKERFILE_PATH is correct
│       - Path is relative to repo root
│
└─→ Build succeeds but service fails?
    Check environment variables and logs
```

---

## Migration Guide

### Switching from Approach 1 to Approach 2

1. Go to Service Settings
2. Remove Root Directory (set to empty)
3. Go to Variables tab
4. Add `RAILWAY_DOCKERFILE_PATH=backend/Dockerfile` (or frontend)
5. Trigger new deployment

### Switching from Approach 2 to Approach 1

1. Go to Variables tab
2. Remove `RAILWAY_DOCKERFILE_PATH` variable
3. Go to Service Settings
4. Set Root Directory to `/backend` (or `/frontend`)
5. Trigger new deployment

---

## Recommendations

### For This Project (mmax)
1. **Try Approach 1 first** - it's simpler
2. **If Dockerfile detection fails** → Switch to Approach 2
3. **Approach 2 is more reliable** for complex monorepos

### General Best Practices
- Use Approach 2 for monorepos with shared code
- Use Approach 1 for completely isolated services
- Keep documentation of which approach you're using
- Test locally with Docker before deploying

---

## Additional Resources

- [Railway Monorepo Guide](https://docs.railway.com/guides/monorepo)
- [Railway Dockerfile Documentation](https://docs.railway.com/guides/dockerfiles)
- [Railway Config-as-Code Reference](https://docs.railway.com/reference/config-as-code)
