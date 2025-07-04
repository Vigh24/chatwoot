# Deploying Chatwoot to Railway

This guide will help you deploy Chatwoot to Railway using the official Chatwoot Docker image.

## Prerequisites

- Railway account
- Railway CLI installed (optional, but recommended)

## Files Added for Railway Deployment

1. `railway.json` - Configuration file for Railway deployment
2. `Dockerfile.railway` - Custom Dockerfile for deploying Chatwoot on Railway

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