# Chatwoot on Railway with pgvector Support

This guide provides detailed instructions for deploying Chatwoot v4.0+ on Railway with proper pgvector extension support to enable all AI features.

## Why pgvector is Required

Chatwoot v4.0+ uses PostgreSQL's vector extension (pgvector) for several AI-powered features:

1. AI-powered responses
2. Knowledge base embeddings
3. Captain AI features
4. Semantic search capabilities

Without the pgvector extension, these features will not be available.

## Prerequisites

- Railway account
- Git installed on your local machine
- Basic knowledge of PostgreSQL and Docker

## Deployment Steps

### Step 1: Fork or Clone the Repository

If you haven't already, fork or clone the Chatwoot repository:

```bash
git clone https://github.com/Vigh24/chatwoot.git
cd chatwoot
```

### Step 2: Set Up Railway Project

1. Create a new project on Railway
2. Connect your GitHub repository to Railway
3. Railway will automatically detect the `railway.json` file and use it for deployment

### Step 3: Verify railway.json Configuration

Make sure your `railway.json` file includes the following configuration for PostgreSQL:

```json
"services": {
  "postgres": {
    "image": "pgvector/pgvector:pg16",
    "envs": {
      "POSTGRES_DB": "chatwoot",
      "POSTGRES_USER": "postgres",
      "POSTGRES_PASSWORD": "${POSTGRES_PASSWORD}"
    }
  }
}
```

### Step 4: Configure Environment Variables

Set the following environment variables in your Railway project:

- `SECRET_KEY_BASE`: Generate with `rails secret` or use a secure random string
- `FRONTEND_URL`: Your Railway app URL (e.g., https://your-app-name.up.railway.app)
- `INSTALLATION_ENV`: Set to `railway`
- `RAILS_ENV`: Set to `production`
- `NODE_ENV`: Set to `production`
- `RAILS_LOG_TO_STDOUT`: Set to `true`
- `POSTGRES_PASSWORD`: A secure password for your PostgreSQL database
- `REDIS_PASSWORD`: A secure password for your Redis instance

### Step 5: Deploy Your Application

Deploy your application using the Railway dashboard or CLI:

```bash
railway up
```

### Step 6: Verify pgvector Extension

After deployment, check the logs to verify that the pgvector extension is available:

1. Go to your Railway dashboard
2. Select your Chatwoot service
3. Click on the "Logs" tab
4. Look for the message: "PostgreSQL vector extension is available"

If you see this message, the pgvector extension is properly installed and configured.

## Troubleshooting

### Issue: PostgreSQL Service Not Using pgvector Image

If your PostgreSQL service is not using the pgvector image:

1. Delete the current PostgreSQL service
2. Create a new PostgreSQL service using the pgvector/pgvector:pg16 image
3. Configure the environment variables as described in Step 4
4. Restart your Chatwoot service

### Issue: Database Migration Errors

If you encounter database migration errors:

1. Check the logs for specific error messages
2. Try running the migrations manually:
   ```bash
   railway run bundle exec rails db:migrate
   ```

### Issue: Vector Extension Not Available

If the vector extension is still not available after following all steps:

1. Connect to your PostgreSQL database:
   ```bash
   railway connect postgres
   ```
2. Check if the vector extension is installed:
   ```sql
   SELECT * FROM pg_available_extensions WHERE name = 'vector';
   ```
3. If not installed, try installing it manually:
   ```sql
   CREATE EXTENSION vector;
   ```

## Updating Your Deployment

When updating Chatwoot to a newer version:

1. Pull the latest changes from the Chatwoot repository
2. Push the changes to your GitHub repository
3. Railway will automatically redeploy your application

## Additional Resources

- [Chatwoot v4.0 Migration Guide](https://chwt.app/v4/migration)
- [Railway Documentation](https://docs.railway.app/)
- [pgvector Documentation](https://github.com/pgvector/pgvector)

For more detailed instructions, refer to the PGVECTOR_FIX_INSTRUCTIONS.md file in this repository. 