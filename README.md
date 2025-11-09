<div align="center">
<img width="1200" height="475" alt="GHBanner" src="https://github.com/user-attachments/assets/0aa67016-6eaf-458a-adb2-6e31a0763ed6" />
</div>

# Run and deploy your AI Studio app

This contains everything you need to run your app locally.

View your app in AI Studio: https://ai.studio/apps/drive/11fGBCY5TvCYgSimd4g6-LNbc-4RrgIFG

## Run Locally

**Prerequisites:**  Node.js

1. Install dependencies:
   `npm install`
2. Set the `GEMINI_API_KEY` in [.env.local](.env.local) to your Gemini API key
3. Run the app:
   `npm run dev`

## Deploy to Render

This project is fully configured for Render deployment with both frontend and backend services.

[![Deploy to Render](https://render.com/images/deploy-to-render-button.svg)](https://render.com/deploy?repo=https://github.com/farhanrafiq/unionrsegistry)

### 🚀 One-Click Deployment (Recommended)

This project uses Render Blueprint (`render.yaml`) to deploy everything automatically:

1. **Create a Neon PostgreSQL database** (free): [console.neon.tech](https://console.neon.tech)
2. **Click the "Deploy to Render" button** above or use Blueprint in Render dashboard
3. **Set environment variables**:
   - `DATABASE_URL`: Your Neon connection string
   - `JWT_SECRET`: Auto-generated or provide your own
4. **Deploy!** Both frontend and backend will be live in ~5-10 minutes

📖 **[Full Deployment Guide →](./DEPLOYMENT.md)**

### Option 1: Automatic Deployment (Recommended)
1. Connect your GitHub repository to Render at https://dashboard.render.com/new/static-site or click the "Deploy to Render" button above
2. Render will automatically detect the `render.yaml` configuration file
3. Your app will be deployed with these settings:
   - **Build Command**: `npm run build`
   - **Publish Directory**: `dist`
   - SPA rewrite to `index.html` is already configured in `render.yaml`

### Option 2: Manual Configuration
If you prefer to configure manually in the Render dashboard:
1. Create a new Static Site on Render
2. Connect your GitHub repository
3. Set the following build settings:
   - **Build Command**: `npm run build`
   - **Publish Directory**: `dist`
   - (Optional) Add environment variable `GEMINI_API_KEY` if your app uses it

### Environment variables
- Local development: create a `.env.local` file with `GEMINI_API_KEY=...` if needed.
- Render: the `render.yaml` includes an env var placeholder for `GEMINI_API_KEY` with `sync: false`. Set its value in the Render dashboard (Static Site -> Environment -> Add Environment Variable) so it's available at build time.

### Build Verification
To verify your build works locally before deploying:
```bash
npm run build
npm run preview
```

The build will create a `dist` folder containing the optimized static files ready for deployment.

## Optional: Shared data across devices (Backend API)

By default, data is stored in the browser (localStorage), which is per-device. To share data across devices, use the included backend API (Express + Prisma + PostgreSQL) in the `server/` folder.

### Quick Start with Neon (Recommended)

Neon PostgreSQL is serverless and has a generous free tier. [Full deployment guide here](./DEPLOYMENT.md).

**For production deployment**:
1. Create free Neon DB at [neon.tech](https://neon.tech)
2. Deploy backend to Render (see [DEPLOYMENT.md](./DEPLOYMENT.md))
3. Deploy frontend to Render with `VITE_API_URL` set to your API
4. Done! Data syncs across all devices.

### Run the API locally

1. Create a Neon database or use local Postgres
2. Create `server/.env` with:
   - `DATABASE_URL=postgres://user:pass@host/dbname?sslmode=require`
   - `JWT_SECRET=a-long-random-string`
3. From `server/` folder:
   - `npm install`
   - `npm run generate`
   - `npm run migrate`
   - `npm run seed` (creates demo dealer: dealer1 / Union@2025)
   - `npm run dev`

### Point the frontend at the API

1. Create `.env.local` in the project root with:
   - `VITE_API_URL=http://localhost:8080`
2. Restart `npm run dev` for the frontend.

When `VITE_API_URL` is set, the app will:
- Log in via the API (dealers)
- Load and create customers/employees via the API (shared across devices)
- Send forgot-password emails (currently mocked to console)
- Fall back to localStorage if the API is not configured

### What syncs across devices

When the API is configured:
- ✅ Dealer authentication (JWT-based)
- ✅ Customers (create, update, terminate)
- ✅ Employees (create, update, terminate)
- ✅ Password reset flows

### Deploy API to Render

See [DEPLOYMENT.md](./DEPLOYMENT.md) for step-by-step instructions with Neon PostgreSQL.
