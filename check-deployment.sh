#!/usr/bin/env bash
# Quick deployment verification script
# Run this before deploying to catch common issues

set -e

echo "🔍 Union Registry - Pre-Deployment Check"
echo "========================================"
echo ""

# Check if we're in the right directory
if [ ! -f "render.yaml" ]; then
    echo "❌ Error: render.yaml not found. Are you in the project root?"
    exit 1
fi
echo "✅ In project root directory"

# Check render.yaml exists
if [ -f "render.yaml" ]; then
    echo "✅ render.yaml found"
else
    echo "❌ render.yaml missing"
    exit 1
fi

# Check build scripts exist and are executable
if [ -x "server/render-build.sh" ]; then
    echo "✅ server/render-build.sh is executable"
else
    echo "❌ server/render-build.sh missing or not executable"
    echo "   Run: chmod +x server/render-build.sh"
    exit 1
fi

if [ -x "server/render-start.sh" ]; then
    echo "✅ server/render-start.sh is executable"
else
    echo "❌ server/render-start.sh missing or not executable"
    echo "   Run: chmod +x server/render-start.sh"
    exit 1
fi

# Check for .env files in git (they shouldn't be there!)
if git ls-files | grep -q "\.env$"; then
    echo "⚠️  WARNING: .env files found in git!"
    echo "   These should never be committed!"
    echo "   Run: git rm --cached **/.env"
else
    echo "✅ No .env files in git (good!)"
fi

# Check if .gitignore exists
if [ -f ".gitignore" ]; then
    echo "✅ .gitignore found"
else
    echo "⚠️  .gitignore missing (not critical)"
fi

# Check package.json files
if [ -f "package.json" ]; then
    echo "✅ Root package.json found"
else
    echo "❌ Root package.json missing"
    exit 1
fi

if [ -f "server/package.json" ]; then
    echo "✅ Server package.json found"
else
    echo "❌ Server package.json missing"
    exit 1
fi

# Check Prisma schema
if [ -f "server/prisma/schema.prisma" ]; then
    echo "✅ Prisma schema found"
else
    echo "❌ Prisma schema missing"
    exit 1
fi

# Check if git is clean (optional warning)
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  WARNING: Uncommitted changes detected"
    echo "   Commit your changes before deploying!"
else
    echo "✅ Git working directory is clean"
fi

echo ""
echo "========================================"
echo "✅ Pre-deployment checks passed!"
echo ""
echo "Next steps:"
echo "1. Create Neon database: https://console.neon.tech"
echo "2. Deploy to Render: https://dashboard.render.com"
echo "3. Follow DEPLOYMENT.md for detailed instructions"
echo ""
echo "Need help? Check DEPLOYMENT-CHECKLIST.md"
