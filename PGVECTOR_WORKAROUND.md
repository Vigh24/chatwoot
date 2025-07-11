# Running Chatwoot Without pgvector Extension (Workaround)

If you prefer to run Chatwoot without the pgvector extension (which will disable AI features), you can use this workaround.

## The Issue

Chatwoot v4.0+ requires PostgreSQL with the pgvector extension for AI features. Your current Railway deployment is using a PostgreSQL service without the pgvector extension.

## Workaround Solution

The Dockerfile.railway file already includes a workaround that allows Chatwoot to run without the pgvector extension. You just need to make sure it's being used correctly.

### Step 1: Verify Your Dockerfile.railway

1. Check that your Dockerfile.railway includes the vector extension workaround code
2. The workaround automatically:
   - Comments out the vector extension line in schema.rb
   - Removes vector-related tables from schema.rb
   - Modifies migration files to disable vector extension requirements

### Step 2: Update Your railway.json (Optional)

If you want to continue using the standard PostgreSQL image without pgvector:

1. Open your railway.json file
2. Update the PostgreSQL service configuration:

```json
"services": {
  "postgres": {
    "image": "postgres:15-alpine",
    "envs": {
      "POSTGRES_DB": "chatwoot",
      "POSTGRES_USER": "postgres",
      "POSTGRES_PASSWORD": "${POSTGRES_PASSWORD}"
    }
  },
  "redis": {
    "image": "redis:alpine",
    "command": "redis-server --requirepass ${REDIS_PASSWORD}"
  }
}
```

### Step 3: Redeploy Your Application

1. Push the changes to your repository
2. Redeploy your application on Railway:
   ```
   railway up
   ```
   
   Or redeploy through the Railway dashboard.

### Step 4: Verify the Workaround

1. After the restart, check the logs of your Chatwoot service
2. Look for messages indicating that the workaround has been applied:
   - "Applying workaround for missing vector extension..."
   - "Modified schema.rb to work without vector extension"
   - "NOTE: AI features will not be available in this deployment"

## Limitations

Using this workaround means that the following features will NOT be available:

1. AI-powered responses
2. Knowledge base embeddings
3. Captain AI features
4. Any other features that rely on the vector extension

All other Chatwoot features will continue to work normally.

## Reverting to Full Functionality

If you later decide to enable AI features, follow the instructions in the PGVECTOR_FIX_INSTRUCTIONS.md file to set up a PostgreSQL service with pgvector support. 