#!/bin/bash

# Add the new files to git
git add PGVECTOR_FIX_INSTRUCTIONS.md PGVECTOR_WORKAROUND.md RAILWAY_PGVECTOR_SETUP.md

# Commit the changes
git commit -m "Add pgvector fix instructions and setup guide for Railway deployment"

# Push to GitHub repository
git push origin main

echo "Changes committed and pushed to GitHub repository: https://github.com/Vigh24/chatwoot.git" 