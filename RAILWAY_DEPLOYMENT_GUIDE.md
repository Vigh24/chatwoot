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

### Database Connection Issues

If you encounter database connection errors during deployment:

1. Check that the PostgreSQL service is running properly
2. Verify that Railway has automatically set the `DATABASE_URL`, `PGHOST`, and `PGPORT` variables
3. You can manually set these variables if needed

### Shell Command Execution Issues

If you see errors like `sh: exec: line 0: illegal option -c` or `multirun: one or more of the provided commands ended abnormally`:

1. This is likely due to shell compatibility issues in the Alpine Linux container
2. The Dockerfile has been updated to use a startup script instead of direct shell commands
3. If you're still encountering issues, check that the startup script has proper permissions and line endings

#### Startup Script Not Found

If you encounter errors like `sh: exec: line 0: /startup.sh: not found`:

1. This indicates that the startup script was not properly created during the Docker build process
2. The latest version of the Dockerfile uses `printf` instead of `echo` for more reliable script creation
3. It also includes verification steps to ensure the script exists and has proper permissions
4. If you're still having issues, you can try modifying the Dockerfile to create the script in a different location or using a different approach

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