#!/usr/bin/env bash
# Build script for Render deployment

set -e  # Exit on error

echo "🔨 Starting build process..."

# Install dependencies
echo "📦 Installing dependencies..."
npm ci

# Generate Prisma client
echo "🔧 Generating Prisma client..."
npx prisma generate

# Build TypeScript
echo "🏗️  Building TypeScript..."
npm run build

echo "✅ Build completed successfully!"
