# Post-Deployment Configuration

After your services are deployed to Render, follow these steps to complete the setup.

## 📝 Required: Link Frontend to Backend

Since Render doesn't automatically link services in the Blueprint, you need to manually set the frontend's API URL.

### Step 1: Get Your Backend URL

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click on `union-registry-api` service
3. Copy the URL (e.g., `https://union-registry-api.onrender.com`)

### Step 2: Update Frontend Environment Variable

1. In Render Dashboard, click on `union-registry-frontend` service
2. Go to **Environment** tab
3. Find or add the `VITE_API_URL` variable
4. Set it to your backend URL: `https://union-registry-api.onrender.com`
5. Click **Save Changes**
6. The frontend will automatically redeploy

### Step 3: Update Backend CORS (Optional but Recommended)

For better security, update the CORS settings:

1. Click on `union-registry-api` service
2. Go to **Environment** tab
3. Find `ALLOWED_ORIGINS` 
4. Change from `*` to your frontend URL: `https://union-registry-frontend.onrender.com`
5. Click **Save Changes**
6. Service will automatically redeploy

## ✅ Verification

After both services redeploy (~2-3 minutes):

1. **Test Backend Health**
   ```
   https://union-registry-api.onrender.com/health
   ```
   Should return: `{"ok": true, "timestamp": "...", "environment": "production"}`

2. **Test Frontend**
   ```
   https://union-registry-frontend.onrender.com
   ```
   Home page should load

3. **Test API Connection**
   - Click "Dealer Login"
   - Try "Forgot Password?" with `dealer1`
   - Check backend logs for password reset message

## 🌱 Optional: Seed Database

To create demo data:

1. Click on `union-registry-api` service
2. Go to **Shell** tab (wait for it to connect)
3. Run:
   ```bash
   npm run seed
   ```
4. Demo dealer created: `dealer1` / `Union@2025`

OR set it to auto-seed on startup:

1. Go to **Environment** tab
2. Add new variable:
   - Key: `SEED_DATABASE`
   - Value: `true`
3. Save (service will restart and seed automatically)

## 🔄 Auto-Deploy Setup

Your app is configured to auto-deploy on git push:

```bash
# Make changes
git add .
git commit -m "Your changes"
git push origin main
```

Render detects the push and deploys within 1-2 minutes! ⚡

## 🎨 Optional: Custom Domain

### For Frontend
1. In `union-registry-frontend` service settings
2. Go to **Settings** → **Custom Domain**
3. Add your domain (e.g., `unionregistry.com`)
4. Update your DNS records as shown
5. SSL certificate is automatically provisioned

### For Backend
1. In `union-registry-api` service settings
2. Add custom domain (e.g., `api.unionregistry.com`)
3. Update frontend's `VITE_API_URL` to use the custom domain
4. Update backend's `ALLOWED_ORIGINS` to allow your frontend domain

## 🔐 Security Hardening (Production)

### 1. Restrict CORS
```
ALLOWED_ORIGINS=https://your-frontend.onrender.com,https://your-custom-domain.com
```

### 2. Use Strong JWT Secret
```bash
# Generate a new one
openssl rand -base64 64
```

### 3. Enable Database Backups
- In Neon console → Settings → Enable automatic backups

### 4. Set Up Monitoring
- Render Dashboard → Service → Metrics tab
- Set up email alerts for downtime

## 📊 Monitoring Your Deployment

### Daily Checks
- [ ] Visit frontend - should load within 2-3 seconds
- [ ] Check backend health endpoint
- [ ] Review Render dashboard for any red alerts

### Weekly Checks
- [ ] Check Neon database size (free tier: 3 GB limit)
- [ ] Review Render logs for errors
- [ ] Test key user flows

### Monthly Checks
- [ ] Review Render usage stats
- [ ] Check if approaching free tier limits
- [ ] Update dependencies: `npm outdated`

## 💡 Performance Tips

### Backend (Free Tier)
- Free tier services sleep after 15 min of inactivity
- First request takes ~30 seconds (cold start)
- Upgrade to $7/month for always-on service

### Frontend
- Static sites don't sleep
- 100 GB bandwidth/month on free tier
- Use Render's CDN (automatic)

### Database
- Use connection pooling (Prisma does this)
- Free tier: 10 concurrent connections
- Monitor query performance in Neon console

## 🚨 Common Issues After Deployment

### Frontend loads but API calls fail
**Solution**: VITE_API_URL not set correctly
- Verify it matches your backend URL exactly
- Must use `https://` not `http://`
- Redeploy frontend after changing

### CORS errors in browser console
**Solution**: Update ALLOWED_ORIGINS
- Set to `*` for testing
- Use specific domains for production
- Include both custom domain and Render URL

### Backend keeps restarting
**Solution**: Check logs for errors
- Usually a DATABASE_URL issue
- Verify Neon database is running
- Check connection string format

### 502 Bad Gateway
**Solution**: Service is starting up
- Free tier takes ~30 seconds on cold start
- Wait a minute and try again
- Check if service is "Running" in dashboard

## 🎓 Next Steps

1. ✅ Complete the configuration above
2. ✅ Test all features thoroughly
3. ✅ Set up custom domain (optional)
4. ✅ Configure monitoring
5. ✅ Invite users!

## 📚 Related Documentation

- [DEPLOYMENT.md](./DEPLOYMENT.md) - Full deployment guide
- [DEPLOYMENT-CHECKLIST.md](./DEPLOYMENT-CHECKLIST.md) - Step-by-step checklist
- [RENDER-READY.md](./RENDER-READY.md) - What was configured

---

**Need help?** Check the [troubleshooting guide](./DEPLOYMENT.md#troubleshooting-common-issues) or open an issue.
