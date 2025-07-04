# Chatwoot v4.0+ on Railway with pgvector Support

## Overview

Chatwoot v4.0+ requires PostgreSQL with the pgvector extension for AI features. This README provides information on how to deploy Chatwoot v4.0+ on Railway with pgvector support.

## Requirements

- Railway account
- PostgreSQL with pgvector extension support

## Quick Setup

1. Fork or clone this repository
2. Create a new project on Railway
3. Deploy the repository to Railway
4. Set up PostgreSQL with pgvector support using the pgvector/pgvector:pg16 image
5. Set up Redis
6. Configure environment variables

## PostgreSQL with pgvector Setup

### Option 1: Using railway.json (Recommended)

The included railway.json file already contains the configuration for PostgreSQL with pgvector support. When you deploy your project, Railway will automatically create a PostgreSQL service using the pgvector/pgvector:pg16 image.

### Option 2: Manual Setup

If you prefer to set up the services manually:

1. Delete the default PostgreSQL service created by Railway
2. Add a new service and select "Empty Service"
3. Set the service name to "postgres"
4. Set the image to "pgvector/pgvector:pg16"
5. Add the following environment variables:
   - `POSTGRES_DB`: chatwoot
   - `POSTGRES_USER`: postgres
   - `POSTGRES_PASSWORD`: your_secure_password (use the same password as in your main service)

## Environment Variables

Make sure to set the following environment variables in your Railway project:

- `SECRET_KEY_BASE`: A secure random string (generate with `rails secret`)
- `FRONTEND_URL`: The URL of your Railway deployment
- `INSTALLATION_ENV`: Set to `railway`
- `RAILS_ENV`: Set to `production`
- `NODE_ENV`: Set to `production`
- `RAILS_LOG_TO_STDOUT`: Set to `true`
- `POSTGRES_PASSWORD`: A secure password for your PostgreSQL database
- `REDIS_PASSWORD`: A secure password for your Redis instance

## Automatic Workaround for Missing pgvector

If you're using a PostgreSQL service without pgvector support, the Chatwoot application will automatically apply a workaround that disables AI features but allows the rest of the application to function normally.

During startup, you'll see messages about the missing vector extension, and the system will apply the workaround and continue initialization. You'll see a message: "NOTE: AI features will not be available in this deployment".

## Troubleshooting

If you encounter issues during deployment, check the following:

1. Make sure your PostgreSQL service is using the pgvector/pgvector:pg16 image
2. Verify that all required environment variables are set correctly
3. Check the deployment logs for specific error messages

For more detailed information, see the following files:
- RAILWAY_DEPLOYMENT.md
- RAILWAY_DEPLOYMENT_GUIDE.md

## Additional Resources

- [Chatwoot v4.0 Migration Guide](https://chwt.app/v4/migration)
- [Railway Documentation](https://docs.railway.app/)
- [pgvector Documentation](https://github.com/pgvector/pgvector)