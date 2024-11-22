#!/bin/bash

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo "Error: .env file not found"
    exit 1
fi

# Function to handle errors
handle_error() {
    echo "Error: $1"
    exit 1
}

# Get the current date and time for the commit message
current_datetime=$(date "+%Y-%m-%d %H:%M:%S")

# Configure git globally
echo "Configuring git..."
git config --global user.name "$GIT_USER_NAME" || handle_error "Failed to set git username"
git config --global user.email "$GIT_USER_EMAIL" || handle_error "Failed to set git email"

# Store credentials helper (for macOS)
git config --global credential.helper osxkeychain

# Set default branch name to main
git config --global init.defaultBranch main

# Initialize git if not already initialized
if [ ! -d ".git" ]; then
    echo "Initializing git repository..."
    git init || handle_error "Failed to initialize git"
    
    # Configure the credential helper to store the token
    git config credential.helper store
    
    # Add repository URL with token authentication
    git remote add origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/queryit-admin/experimental.git || handle_error "Failed to add remote"
else
    # Check if remote exists, if not add it
    if ! git remote | grep -q "^origin$"; then
        git remote add origin https://$GITHUB_USERNAME:$GITHUB_TOKEN@github.com/queryit-admin/experimental.git || handle_error "Failed to add remote"
    fi
fi

# Test authentication
echo "Testing GitHub authentication..."
curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user > /dev/null 2>&1 || handle_error "GitHub authentication failed"

# Fetch remote branches
echo "Fetching remote branches..."
git fetch origin || handle_error "Failed to fetch from remote"

# Add all changes first to track them
echo "Adding changes..."
echo $SUDO_PASSWORD | sudo -S git add . || handle_error "Failed to add changes"

# Commit any existing changes before switching branches
if ! git diff-index --quiet HEAD 2>/dev/null; then
    echo "Committing existing changes..."
    echo $SUDO_PASSWORD | sudo -S git commit -m "Auto-commit: Updates as of $current_datetime" || handle_error "Failed to commit changes"
fi

# Check if main branch exists locally
if ! git rev-parse --verify main >/dev/null 2>&1; then
    # Check if main branch exists on remote
    if git ls-remote --heads origin main | grep -q main; then
        # Main exists on remote, check it out
        echo "Checking out main branch from remote..."
        git checkout main || git checkout -b main origin/main || handle_error "Failed to checkout main branch"
    else
        # Main doesn't exist anywhere, create it
        echo "Creating main branch..."
        git checkout -b main || handle_error "Failed to create main branch"
    fi
else
    # Switch to main branch if not already on it
    echo "Switching to main branch..."
    git checkout main || handle_error "Failed to switch to main branch"
fi

# Pull latest changes first to avoid conflicts
echo "Pulling latest changes..."
git pull origin main --no-rebase || true  # Don't fail if this is first push

# Check if there are new changes to commit
if git diff-index --quiet HEAD 2>/dev/null; then
    echo "No new changes to commit"
else
    # Commit with a default message including timestamp
    echo "Committing new changes..."
    echo $SUDO_PASSWORD | sudo -S git add . || handle_error "Failed to add new changes"
    echo $SUDO_PASSWORD | sudo -S git commit -m "Auto-commit: Updates as of $current_datetime" || handle_error "Failed to commit changes"
fi

# Push to the main branch using token authentication
echo "Pushing changes..."
if ! git push -u origin main --force; then
    echo "Error: Failed to push changes"
    exit 1
fi

echo "Changes have been committed and pushed successfully!"
