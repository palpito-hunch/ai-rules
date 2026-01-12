#!/bin/bash

echo "🚀 Setting up your Kiro project..."

# Install dependencies
npm install

# Copy environment file
if [ ! -f .env ]; then
    cp .env.example .env
    echo "✅ Created .env file - please update with your values"
fi

# Initialize git hooks (if using husky)
# npm run prepare

echo "✨ Setup complete! Run 'npm run dev' to start developing."