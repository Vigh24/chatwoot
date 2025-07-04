# Deploying Chatwoot to Railway

This guide will help you deploy Chatwoot to Railway using the official Chatwoot Docker image.

## Prerequisites

- Railway account
- Railway CLI installed (optional, but recommended)
- GitHub repository for your Chatwoot codebase

## Files Added for Railway Deployment

1. `railway.json` - Configuration file for Railway deployment
2. `Dockerfile.railway` - Custom Dockerfile for deploying Chatwoot on Railway
3. `.github/workflows/deploy_to_railway.yml` - GitHub Actions workflow for deploying to Railway
4. `.github/workflows/build_and_push_docker.yml` - GitHub Actions workflow for building and pushing Docker image to GitHub Container Registry

## Deployment Steps

### Option 1: Using Railway CLI (Recommended)

1. Login to Railway CLI:
   ```
   railway login
   ```

2. Initialize a new Railway project in your Chatwoot directory (if not already done):
   ```
   railway init
   ```

3. Link to an existing project (if you've already created one on Railway):
   ```
   railway link
   ```

4. Add PostgreSQL and Redis services to your project:
   ```
   railway add
   ```
   Select PostgreSQL and Redis from the list of services.

5. Deploy your application:
   ```
   railway up
   ```

6. Set up required environment variables:
   ```
   railway variables set SECRET_KEY_BASE=your_secret_key_base
   railway variables set FRONTEND_URL=https://your-railway-app-url
   ```
   
   You can also set variables through the Railway dashboard.

### Option 2: Using Railway Dashboard

1. Push your code to a GitHub repository

2. Go to [Railway Dashboard](https://railway.app/dashboard)

3. Create a new project and select "Deploy from GitHub repo"

4. Select your Chatwoot repository

5. Railway will automatically detect the `railway.json` file and use the specified Dockerfile

6. Add PostgreSQL and Redis services to your project

7. Set up the required environment variables in the Railway dashboard

## Required Environment Variables

Make sure to set the following environment variables in your Railway project:

- `SECRET_KEY_BASE`: A secure random string (generate with `rails secret`)
- `FRONTEND_URL`: The URL of your Railway deployment
- `INSTALLATION_ENV`: Set to `railway`
- `RAILS_ENV`: Set to `production`
- `NODE_ENV`: Set to `production`
- `RAILS_LOG_TO_STDOUT`: Set to `true`

Railway will automatically set up the following variables for you:

- `DATABASE_URL`: Connection string for PostgreSQL
- `REDIS_URL`: Connection string for Redis
- `PORT`: The port your application should listen on

## Troubleshooting

- If you encounter build errors, check the build logs in the Railway dashboard
- Make sure all required environment variables are set
- If database migrations fail, you may need to manually run them using the Railway CLI:
  ```
  railway run bundle exec rails db:migrate
  ```
- If the deployment times out, try deploying through the Railway dashboard instead of the CLI

## Updating Your Deployment

When you make changes to your code, simply push the changes to your GitHub repository (if using GitHub deployment) or run `railway up` again (if using CLI deployment).

## GitHub Actions Workflows

Two GitHub Actions workflows have been set up to automate the deployment process:

### 1. Build and Push Docker Image

The `build_and_push_docker.yml` workflow builds your Chatwoot Docker image using the `Dockerfile.railway` and pushes it to GitHub Container Registry (GHCR). This workflow runs automatically when you push to the `main` branch.

To use this workflow, you need to:

1. Ensure your repository has permission to create packages
2. The workflow uses the built-in `GITHUB_TOKEN` secret for authentication

### 2. Deploy to Railway

The `deploy_to_railway.yml` workflow deploys your Chatwoot application to Railway using the Railway CLI. This workflow runs automatically when you push to the `main` branch.

To use this workflow, you need to:

1. Create a Railway API token in the Railway dashboard
2. Add the token as a secret named `RAILWAY_TOKEN` in your GitHub repository settings

With these workflows in place, your Chatwoot application will be automatically deployed to Railway whenever you push changes to the `main` branch.