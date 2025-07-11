# Fixing pgvector Extension in Your Current Railway Deployment

Based on your deployment logs, the pgvector extension is not available in your PostgreSQL service. This guide provides specific steps to fix this issue.

## Step 1: Access Your Railway Dashboard

1. Go to your Railway dashboard: https://railway.app/project/10ab4d26-b0af-43b7-a4e9-deaa6eb3e681
2. Log in if necessary

## Step 2: Delete Your Current PostgreSQL Service

1. In your project, locate the PostgreSQL service
2. Click on it to open its details
3. Click on the "Settings" tab
4. Scroll down to the bottom and click "Delete Service"
5. Confirm the deletion

## Step 3: Create a New PostgreSQL Service with pgvector Support

1. In your project, click "New Service"
2. Select "Empty Service"
3. Set the service name to "postgres" (this exact name is important)
4. Click on the new service to open its details
5. Click on the "Settings" tab
6. Find the "Image" section and click "Override"
7. Enter `pgvector/pgvector:pg16` as the image name
8. Click "Save"

## Step 4: Configure the New PostgreSQL Service

1. Click on the "Variables" tab of your new PostgreSQL service
2. Add the following environment variables:
   - `POSTGRES_DB`: chatwoot
   - `POSTGRES_USER`: postgres
   - `POSTGRES_PASSWORD`: [use the same password as in your main Chatwoot service]

## Step 5: Restart Your Chatwoot Service

1. Go back to your Chatwoot service
2. Click on the "Settings" tab
3. Find the "Restart" button and click it
4. Wait for the service to restart

## Step 6: Verify the Fix

After the restart, check the logs of your Chatwoot service. Look for:
- "PostgreSQL vector extension is available" (success)
- "ERROR: PostgreSQL 'vector' extension is not available on the server" (still failing)

## Alternative Method: Redeploy Using railway.json

If the above steps don't work, try redeploying your entire project:

1. Make sure your repository has the correct railway.json file (which it already does)
2. In your Railway dashboard, go to the project settings
3. Click on "Delete Project" to remove the current deployment
4. Create a new project
5. Connect it to your GitHub repository
6. Railway should automatically detect and use the railway.json file
7. Set up the required environment variables:
   - `SECRET_KEY_BASE`: [generate a new one or use your existing one]
   - `FRONTEND_URL`: [your Railway app URL]
   - `INSTALLATION_ENV`: railway
   - `RAILS_ENV`: production
   - `NODE_ENV`: production
   - `RAILS_LOG_TO_STDOUT`: true
   - `POSTGRES_PASSWORD`: [a secure password]
   - `REDIS_PASSWORD`: [a secure password]

## Troubleshooting Common Issues

### Issue: Services Not Connecting

If your Chatwoot service can't connect to PostgreSQL:
1. Check that the PostgreSQL service name is exactly "postgres"
2. Verify the environment variables are correctly set
3. Check the logs for connection errors

### Issue: Database Migration Errors

If you encounter database migration errors:
1. Connect to the Railway CLI: `railway login`
2. Run migrations manually: `railway run bundle exec rails db:migrate`

### Issue: Vector Extension Still Not Available

If the vector extension is still not available:
1. Verify that your PostgreSQL service is using the correct image
2. Try connecting to PostgreSQL and checking available extensions:
   ```
   railway connect postgres
   \dx
   ```
   You should see "vector" in the list of extensions

### Issue: Data Loss After Recreation

If you had important data in your previous database:
1. Consider setting up a temporary database to hold your data
2. Export data from the old database before deleting it
3. Import data into the new database after setup

## Need More Help?

If you continue to experience issues, please provide:
1. Updated deployment logs
2. Screenshots of your Railway dashboard showing the services
3. Any error messages you're seeing 