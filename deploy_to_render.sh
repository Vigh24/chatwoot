#!/bin/bash

# Chatwoot Render Deployment Helper Script
# This script helps prepare your Chatwoot deployment for Render

set -e

echo "🚀 Chatwoot Render Deployment Helper"
echo "===================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if required files exist
check_files() {
    print_info "Checking required files..."
    
    local files=("render.yaml" "Dockerfile.render" "RENDER_DEPLOYMENT_GUIDE.md")
    local missing_files=()
    
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            print_status "$file exists"
        else
            missing_files+=("$file")
            print_error "$file is missing"
        fi
    done
    
    if [[ ${#missing_files[@]} -gt 0 ]]; then
        print_error "Missing required files. Please ensure all deployment files are present."
        exit 1
    fi
}

# Generate SECRET_KEY_BASE if Rails is available
generate_secret() {
    print_info "Checking for SECRET_KEY_BASE..."
    
    if command -v rails &> /dev/null; then
        print_info "Generating new SECRET_KEY_BASE..."
        SECRET_KEY=$(rails secret 2>/dev/null || openssl rand -hex 64)
        echo ""
        print_status "Generated SECRET_KEY_BASE:"
        echo "$SECRET_KEY"
        echo ""
        print_warning "Save this key! You'll need it for your Render environment variables."
        echo ""
    else
        print_warning "Rails not found. You can generate SECRET_KEY_BASE later with:"
        echo "  rails secret"
        echo "  or"
        echo "  openssl rand -hex 64"
        echo ""
    fi
}

# Check Git status
check_git() {
    print_info "Checking Git repository status..."
    
    if [[ ! -d ".git" ]]; then
        print_error "This is not a Git repository. Please initialize Git first:"
        echo "  git init"
        echo "  git add ."
        echo "  git commit -m 'Initial commit'"
        echo "  git remote add origin <your-github-repo-url>"
        echo "  git push -u origin main"
        exit 1
    fi
    
    # Check if there are uncommitted changes
    if [[ -n $(git status --porcelain) ]]; then
        print_warning "You have uncommitted changes. Consider committing them:"
        git status --short
        echo ""
        read -p "Do you want to commit these changes now? (y/N): " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git add .
            read -p "Enter commit message: " commit_message
            git commit -m "${commit_message:-Update for Render deployment}"
            print_status "Changes committed"
        fi
    else
        print_status "Git repository is clean"
    fi
    
    # Check if connected to remote
    if git remote -v | grep -q "origin"; then
        print_status "Git remote 'origin' is configured"
        git remote -v
    else
        print_warning "No Git remote configured. You'll need to add one:"
        echo "  git remote add origin <your-github-repo-url>"
    fi
}

# Validate render.yaml
validate_render_config() {
    print_info "Validating render.yaml configuration..."
    
    if [[ -f "render.yaml" ]]; then
        # Check for required services
        if grep -q "type: web" render.yaml && grep -q "type: worker" render.yaml; then
            print_status "Web and worker services configured"
        else
            print_error "Missing web or worker service in render.yaml"
        fi
        
        # Check for database configuration
        if grep -q "name: chatwoot-postgres" render.yaml; then
            print_status "PostgreSQL database configured"
        else
            print_error "PostgreSQL database not configured in render.yaml"
        fi
        
        # Check for Redis configuration
        if grep -q "name: chatwoot-redis" render.yaml; then
            print_status "Redis service configured"
        else
            print_error "Redis service not configured in render.yaml"
        fi
    fi
}

# Show deployment checklist
show_checklist() {
    echo ""
    print_info "Pre-deployment Checklist:"
    echo "=========================="
    echo ""
    echo "1. ✅ Ensure your code is pushed to GitHub"
    echo "2. ✅ Have your Render account ready"
    echo "3. ✅ Prepare your email service credentials (Gmail, SendGrid, etc.)"
    echo "4. ✅ Consider your domain name (optional)"
    echo ""
    print_info "Deployment Steps:"
    echo "=================="
    echo ""
    echo "1. Go to https://dashboard.render.com"
    echo "2. Click 'New' → 'Blueprint'"
    echo "3. Connect your GitHub repository"
    echo "4. Render will detect render.yaml automatically"
    echo "5. Click 'Apply' to start deployment"
    echo "6. Configure email settings in environment variables"
    echo "7. Wait for deployment to complete (~15 minutes)"
    echo ""
    print_info "After Deployment:"
    echo "=================="
    echo ""
    echo "1. Check logs for '✅ pgvector extension is available!'"
    echo "2. Visit your app URL to verify it's working"
    echo "3. Set up your admin account"
    echo "4. Configure email settings"
    echo "5. Test AI features"
    echo ""
}

# Show environment variables template
show_env_template() {
    echo ""
    print_info "Environment Variables Template:"
    echo "==============================="
    echo ""
    echo "# Copy these to your Render service environment variables"
    echo ""
    echo "# Email Configuration (REQUIRED - Update with your details)"
    echo "MAILER_SENDER_EMAIL=noreply@yourdomain.com"
    echo "SMTP_DOMAIN=yourdomain.com"
    echo "SMTP_ADDRESS=smtp.gmail.com"
    echo "SMTP_PORT=587"
    echo "SMTP_USERNAME=your-email@gmail.com"
    echo "SMTP_PASSWORD=your-app-password"
    echo "SMTP_AUTHENTICATION=plain"
    echo "SMTP_ENABLE_STARTTLS_AUTO=true"
    echo ""
    echo "# Optional Customizations"
    echo "ENABLE_ACCOUNT_SIGNUP=false"
    echo "DEFAULT_LOCALE=en"
    echo ""
    print_warning "Don't forget to update the email settings with your actual credentials!"
    echo ""
}

# Main execution
main() {
    echo ""
    check_files
    echo ""
    generate_secret
    echo ""
    check_git
    echo ""
    validate_render_config
    echo ""
    show_checklist
    echo ""
    show_env_template
    echo ""
    print_status "Your Chatwoot project is ready for Render deployment!"
    echo ""
    print_info "Next step: Go to https://dashboard.render.com and deploy using Blueprint"
    echo ""
    print_info "For detailed instructions, see: RENDER_DEPLOYMENT_GUIDE.md"
    echo ""
}

# Run main function
main