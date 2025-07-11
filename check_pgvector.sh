#!/bin/bash

# This script checks if the pgvector extension is available in your PostgreSQL database on Railway

echo "Checking for pgvector extension in PostgreSQL..."

# Install Railway CLI if not already installed
if ! command -v railway &> /dev/null; then
    echo "Railway CLI not found. Please install it first:"
    echo "npm i -g @railway/cli"
    exit 1
fi

# Make sure user is logged in
echo "Ensuring you're logged in to Railway..."
railway login

# Connect to PostgreSQL and check for vector extension
echo "Connecting to PostgreSQL and checking for vector extension..."
railway run "psql \$DATABASE_URL -c \"SELECT * FROM pg_available_extensions WHERE name = 'vector';\""

# Check if the extension is enabled
echo "Checking if vector extension is enabled..."
railway run "psql \$DATABASE_URL -c \"SELECT * FROM pg_extension WHERE extname = 'vector';\""

echo "Done checking for pgvector extension." 