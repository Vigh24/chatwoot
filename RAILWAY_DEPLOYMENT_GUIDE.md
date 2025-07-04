# Chatwoot Railway Deployment Guide

This guide provides step-by-step instructions for deploying Chatwoot on Railway.app.

## Prerequisites

- A Railway.app account
- Basic understanding of Docker and environment variables

## Deployment Steps

### 1. Fork or Clone the Chatwoot Repository

Make sure you have a copy of the Chatwoot repository with the Railway-specific files:
- `railway.json`
- `Dockerfile.railway`

### 2. Create a New Project on Railway

1. Go to [Railway Dashboard](https://railway.app/dashboard)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Connect your GitHub account and select your Chatwoot repository

### 3. Add Required Services

You need to add the following services to your Railway project:

1. **PostgreSQL**
   - Click "+ New" and select "Database → PostgreSQL"
   - Railway will automatically set up the database and provide connection variables

2. **Redis**
   - Click "+ New" and select "Database → Redis"
   - Railway will automatically set up Redis and provide connection variables

### 4. Configure Environment Variables

In your Railway project settings, add the following environment variables:

#### Required Variables

- `SECRET_KEY_BASE`: Generate a secure random string (use `rails secret` command)
- `FRONTEND_URL`: The URL of your Railway deployment (e.g., https://your-app-name.up.railway.app)
- `INSTALLATION_ENV`: Set to `railway`
- `RAILS_ENV`: Set to `production`
- `NODE_ENV`: Set to `production`
- `RAILS_LOG_TO_STDOUT`: Set to `true`
- `ENABLE_ACCOUNT_SIGNUP`: Set to `true` for the first deployment to create an admin account

#### Optional Variables

- `DEFAULT_LOCALE`: Set your preferred default language (e.g., `en`)
- `MAILER_SENDER_EMAIL`: The email address for outgoing emails
- `SMTP_ADDRESS`, `SMTP_PORT`, `SMTP_USERNAME`, `SMTP_PASSWORD`: Configure if you want to set up email delivery

### 5. Deploy Your Application

1. Railway will automatically detect changes in your repository and deploy them
2. You can also manually trigger a deployment from the Railway dashboard
3. Monitor the deployment logs for any errors

### 6. Access Your Chatwoot Instance

1. Once deployment is successful, click on the generated domain URL to access your Chatwoot instance
2. Create your admin account
3. After creating the admin account, you may want to set `ENABLE_ACCOUNT_SIGNUP` to `false` to prevent unauthorized signups

## Troubleshooting

### Startup Script Issues

If you encounter errors like `sh: exec: line 0: /startup.sh: not found` or `multirun: one or more of the provided commands ended abnormally`, it indicates that the startup script is not being properly created or found during container startup. The Dockerfile has been updated to use a more reliable method for creating the startup script:

1. **Script Creation**: The startup script is now created using the `COPY <<-'EOT'` heredoc syntax in the Dockerfile, which is more reliable than using `printf`.
2. **Script Verification**: The build process now includes verification steps to ensure the script exists and is executable.

If you still encounter this issue:

- Rebuild your container with the latest Dockerfile changes.
- Verify that your Docker build process has sufficient permissions to create files in the root directory.
- Check if any custom Docker configurations or security policies might be preventing script execution.

### Database Connection Issues

If you encounter database connection errors during deployment (such as `no response` errors):

1. Check that the PostgreSQL service is running properly in your Railway project
2. The startup script now automatically extracts connection parameters from `DATABASE_URL` if `PGHOST` and `PGPORT` are not explicitly set
3. The script includes connection retries (up to 30 attempts with 5-second intervals) and prints detailed connection parameters for debugging
4. Make sure the PostgreSQL service is in the same Railway project as your Chatwoot application
5. If using a custom PostgreSQL setup, ensure the database is accessible from the Chatwoot container

#### Enhanced Connection Parameter Handling

The startup script now includes intelligent handling of database connection parameters:

1. **Automatic Extraction**: If `PGHOST` is not set but `DATABASE_URL` is available, the script will automatically extract the host and port from the URL
2. **Default Values**: If parameters cannot be extracted, sensible defaults are used (port 5432 and host 'postgres')
3. **Detailed Logging**: The script logs each step of the connection process, showing extracted values and connection attempts

#### Troubleshooting Connection Failures

If you see logs like this:
```
Checking database connection...
PGHOST is not set, extracting from DATABASE_URL...
Extracted PGHOST from DATABASE_URL: railway
Extracted PGPORT from DATABASE_URL: 5432
Database connection parameters:
PGHOST: railway
PGPORT: 5432
DATABASE_URL is set: yes
Attempting to connect to PostgreSQL at railway:5432...
-p:5432 - no response
Database connection attempt 1/30 failed, retrying in 5 seconds...
```

This indicates that the Chatwoot container cannot reach the PostgreSQL server despite having connection parameters. Possible solutions:

1. **Check Service Status**: Verify the PostgreSQL service is running in your Railway project
2. **Network Connectivity**: Ensure there are no network policies blocking connections between services
3. **Service Names**: Railway may use specific service names for internal networking - check if you need to use a special hostname
4. **Restart Services**: Try restarting both the PostgreSQL service and the Chatwoot service
5. **Manual Configuration**: If automatic extraction isn't working, manually set the `PGHOST` and `PGPORT` variables in your Railway project settings

### PostgreSQL Vector Extension Requirement

Chatwoot v4.0+ requires the PostgreSQL `vector` extension for AI features. If you see errors like:

```
PG::FeatureNotSupported: ERROR: extension "vector" is not available
DETAIL: Could not open extension control file "/usr/share/postgresql/16/extension/vector.control": No such file or directory.
HINT: The extension must first be installed on the system where PostgreSQL is running.
```

This means your PostgreSQL database doesn't have the required extension. To resolve this:

1. **Use a PostgreSQL provider that supports the vector extension**:
   - Railway's default PostgreSQL may not include this extension
   - Consider using a different PostgreSQL add-on or provider that supports the vector extension
   - Some options include Supabase, Neon, or a self-hosted PostgreSQL instance with the extension installed

2. **Automatic Workaround (Improved)**:
   - The updated Dockerfile now includes an automatic workaround that allows Chatwoot to run without the vector extension
   - When the extension is not detected, the startup script will:
     - Create a backup of the schema.rb file
     - Comment out the vector extension requirement
     - Completely remove vector-related tables and indexes from the schema
     - Proceed with database initialization
     - Restore the original schema file after initialization
   - **Note**: This workaround will disable AI features but allow the rest of Chatwoot to function normally
   - The improved implementation ensures there are no syntax errors in the modified schema

3. **For advanced users**:
   - If you have access to the PostgreSQL server, you can install the extension manually:
     ```
     # On the PostgreSQL server
     sudo apt-get install postgresql-14-pgvector  # Adjust version as needed
     ```
   - Then enable it in your database:
     ```
     CREATE EXTENSION vector;
     ```

4. **Expected Behavior with Workaround**:
   - During startup, you'll see messages about the missing vector extension
   - The system will apply the workaround and continue initialization
   - AI-related features (Captain AI, article embeddings) will be unavailable
   - All other Chatwoot features will work normally

For more information, see the Chatwoot documentation at https://chwt.app/v4/migration

### Database Schema Issues

If you see errors like `PG::UndefinedTable: ERROR: relation "installation_configs" does not exist`:

1. This indicates that the database schema hasn't been properly initialized
2. The startup script now includes a more robust database initialization process:
   - First checks database connectivity with retries
   - Runs `db:chatwoot_prepare` to set up the database
   - Loads the schema with `db:schema:load`
   - Applies any pending migrations with `db:migrate`
3. If you're still encountering schema issues, you may need to manually initialize the database:
   ```
   railway run bundle exec rails db:reset
   railway run bundle exec rails db:schema:load
   railway run bundle exec rails db:migrate
   ```
4. Note that `db:reset` will drop and recreate the database, so only use it for fresh installations

### Application Startup Issues

If the application fails to start:

1. Check the deployment logs for specific error messages
2. Verify that all required environment variables are set correctly
3. You may need to manually run migrations using the Railway CLI:
   ```
   railway run bundle exec rails db:migrate
   ```

## Updating Your Deployment

When you make changes to your code:

1. Push the changes to your GitHub repository
2. Railway will automatically detect the changes and redeploy your application

## Additional Resources

- [Chatwoot Documentation](https://www.chatwoot.com/docs/)
- [Railway Documentation](https://docs.railway.app/)
- [Chatwoot GitHub Repository](https://github.com/chatwoot/chatwoot)