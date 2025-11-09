#!/usr/bin/env bash
# Start script for Render deployment

set -e  # Exit on error

echo "🚀 Starting application..."

# Run database migrations
echo "📊 Running database migrations..."
npx prisma migrate deploy

# Seed database if SEED_DATABASE is set
if [ "$SEED_DATABASE" = "true" ]; then
  echo "🌱 Seeding database..."
  npm run seed
fi

# Start the server
echo "▶️  Starting server..."
npm run start
