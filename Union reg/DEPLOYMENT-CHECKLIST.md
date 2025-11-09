# Render Deployment Checklist

## ✅ Pre-Deployment Checklist

### 1. Database Setup
- [ ] Create Neon PostgreSQL account at [neon.tech](https://neon.tech)
- [ ] Create new Neon project (choose region closest to users)
- [ ] Copy DATABASE_URL connection string
- [ ] Verify connection string includes `?sslmode=require`

### 2. Repository Setup
- [ ] Code pushed to GitHub
- [ ] Repository is public or Render has access
- [ ] All sensitive data removed from code (no hardcoded secrets)
- [ ] `.env` files are in `.gitignore` (never commit secrets!)

### 3. File Verification
Ensure these files exist in your repository:
- [ ] `render.yaml` - Deployment configuration
- [ ] `server/render-build.sh` - Backend build script (executable)
- [ ] `server/render-start.sh` - Backend start script (executable)
- [ ] `server/.env.example` - Environment variable template
- [ ] `.env.example` - Frontend env template
- [ ] `.gitignore` - Excludes sensitive files

---

## 🚀 Deployment Steps

### Method 1: Blueprint Deployment (Recommended)

1. **Navigate to Render Dashboard**
   - Go to [dashboard.render.com](https://dashboard.render.com)
   - Click **New** → **Blueprint**

2. **Connect Repository**
   - Select your GitHub account
   - Choose repository: `farhanrafiq/unionrsegistry`
   - Render auto-detects `render.yaml`

3. **Configure Environment Variables**
   Required for Backend API:
   - `DATABASE_URL`: Your Neon connection string
   - `JWT_SECRET`: Auto-generated (recommended) or custom
   
   Optional:
   - `SEED_DATABASE`: Set to `true` to auto-seed demo data
   - `ALLOWED_ORIGINS`: Set to `*` or specific domains

4. **Deploy**
   - Click **Apply**
   - Wait 5-10 minutes for initial deployment
   - Monitor logs for any errors

### Method 2: Manual Service Creation

If Blueprint doesn't work, create services manually:

#### Backend API Service
1. **New** → **Web Service**
2. **Settings**:
   - Name: `union-registry-api`
   - Runtime: Node
   - Root Directory: `server`
   - Build Command: `./render-build.sh`
   - Start Command: `./render-start.sh`
   - Plan: Free
3. **Environment Variables**: Same as Blueprint method
4. **Create Service**

#### Frontend Static Site
1. **New** → **Static Site**
2. **Settings**:
   - Name: `union-registry-frontend`
   - Build Command: `npm ci && npm run build`
   - Publish Directory: `dist`
   - Plan: Free
3. **Environment Variables**:
   - `VITE_API_URL`: Your backend service URL (e.g., `https://union-registry-api.onrender.com`)
4. **Create Static Site**

---

## 🔍 Post-Deployment Verification

### 1. Backend Health Check
- [ ] Visit: `https://union-registry-api.onrender.com/health`
- [ ] Should return: `{"ok": true, "timestamp": "...", "environment": "production"}`

### 2. Frontend Access
- [ ] Visit: `https://union-registry-frontend.onrender.com`
- [ ] Home page loads correctly
- [ ] No console errors in browser DevTools

### 3. API Connection
- [ ] Click "Dealer Login" on frontend
- [ ] Try "Forgot Password?" with username: `dealer1`
- [ ] Check backend logs for password reset email (mocked)

### 4. Database Connection
- [ ] Backend logs show: "API listening on port 10000"
- [ ] No Prisma connection errors in logs
- [ ] Migrations completed successfully

### 5. Seed Data (Optional)
If you set `SEED_DATABASE=true`:
- [ ] Try logging in with: `dealer1` / `Union@2025`
- [ ] Create a test employee or customer
- [ ] Refresh page - data should persist

---

## 🐛 Troubleshooting

### Backend Won't Start

**Symptom**: Service stuck in "Deploying" or crashes immediately

**Solutions**:
1. Check Render logs (click service → Logs tab)
2. Verify `DATABASE_URL` is set correctly
3. Ensure Neon database is running (check Neon console)
4. Run Shell command: `npm run migrate` manually
5. Check build script permissions: `chmod +x render-*.sh`

### Frontend Can't Connect to API

**Symptom**: Login fails, "NO_API" error in console

**Solutions**:
1. Verify `VITE_API_URL` environment variable is set
2. Check API URL format: `https://` (not `http://`)
3. Test API health check directly in browser
4. Check CORS settings: `ALLOWED_ORIGINS` in backend
5. Clear browser cache and reload

### Database Connection Errors

**Symptom**: "password authentication failed" or "too many connections"

**Solutions**:
1. Verify connection string format includes `?sslmode=require`
2. Check Neon database status in console
3. Free tier limit: 10 concurrent connections
   - Restart Render service to clear connections
4. Ensure no IP restrictions in Neon settings

### Build Failures

**Symptom**: Build fails with npm/dependency errors

**Solutions**:
1. Verify `package.json` and `package-lock.json` are committed
2. Check Node version (should be ≥18)
3. Try local build: `npm ci && npm run build`
4. Check for missing dependencies in `package.json`
5. Clear Render build cache: Service Settings → Clear Build Cache

### Service Sleeps (Free Tier)

**Symptom**: First request after 15 min takes ~30 seconds

**Expected behavior** on free tier:
- Service "spins down" after 15 min inactivity
- First request "wakes up" the service (cold start)
- Subsequent requests are fast

**Solutions**:
- Upgrade to paid plan for always-on service ($7/mo)
- Or accept cold start delay (normal for free tier)

---

## 📊 Monitoring

### Daily Checks
- [ ] Visit frontend URL - should load within 2-3 seconds
- [ ] Check Render dashboard for service status (all green)
- [ ] Review error logs if any red indicators

### Weekly Checks
- [ ] Check Neon console for database size (free tier: 3 GB limit)
- [ ] Review Render bandwidth usage (free tier: 100 GB/month)
- [ ] Test key user flows (login, create employee, etc.)

### Monthly Checks
- [ ] Review Render usage stats (hours, bandwidth)
- [ ] Check if approaching free tier limits
- [ ] Update dependencies: `npm outdated`

---

## 🔄 Updating Your Deployment

### Code Changes
```bash
# Make changes
git add .
git commit -m "Your changes"
git push origin main
```
Render auto-deploys within 1-2 minutes! ✨

### Environment Variable Changes
1. Go to Render Dashboard
2. Click service (API or Frontend)
3. Go to **Environment** tab
4. Update variable value
5. Service auto-restarts

### Database Schema Changes
```bash
cd server
# Create migration
npx prisma migrate dev --name your_migration_name
# Push to git
git add prisma/migrations/
git commit -m "Add migration: your_migration_name"
git push
```
Render will auto-run migrations on deploy! 🎉

---

## 💰 Cost Management

### Free Tier Limits
- **Neon**: 3 GB storage, 10 connections, 1 branch
- **Render Web Service**: 750 hours/month (sleeps after 15 min)
- **Render Static Site**: 100 GB bandwidth/month

### When to Upgrade
Consider paid plans if you need:
- Always-on backend (no cold starts): $7/mo
- More database storage: Neon Scale plan $19/mo
- Custom domain SSL: Free on Render!
- More bandwidth: Render Pro plans start at $7/mo

---

## 🎉 Success Criteria

Your deployment is successful when:
- ✅ Frontend loads at your Render URL
- ✅ Backend health check returns `{"ok": true}`
- ✅ Can login with demo dealer (if seeded)
- ✅ Can create/view employees and customers
- ✅ Data persists after page refresh
- ✅ No errors in Render logs
- ✅ Works on multiple devices/browsers

---

## 📚 Additional Resources

- [Render Documentation](https://render.com/docs)
- [Render Blueprint Guide](https://render.com/docs/infrastructure-as-code)
- [Neon Documentation](https://neon.tech/docs)
- [Prisma Deployment Guide](https://www.prisma.io/docs/guides/deployment)
- [Full Deployment Guide](./DEPLOYMENT.md)

---

## 🆘 Need Help?

1. Check Render logs (most issues show up here)
2. Review [DEPLOYMENT.md](./DEPLOYMENT.md) troubleshooting section
3. Open an issue: https://github.com/farhanrafiq/unionrsegistry/issues
4. Render Community: https://community.render.com
