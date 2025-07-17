#!/bin/bash

# CONFIG ----------------------
REPO_NAME="auto-git-$(date +%s)"
DESCRIPTION="THIS IS FULLY AUTOMATED REPO CREATED"
PRIVATE=true
GIT_USERNAME="DEVENDRA-5470"
GIT_EMAIL="ysdevn@gmail.com"

# INSTALL GITHUB CLI ----------
if ! command -v gh &>/dev/null; then
    echo "GitHub CLI not found...❌"
    echo "Installing GitHub CLI..."

    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        sudo apt update
        sudo apt install curl -y

        # Import the GitHub CLI GPG key
        curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
        sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

        sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

        # Add GitHub CLI repo
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
        sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

        sudo apt update
        sudo apt install gh -y

    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then
        echo "Windows WSL detected"
        echo "Please install GitHub CLI manually from: https://cli.github.com/"
        exit 1
    else
        echo "Unsupported OS: $OSTYPE"
        exit 1
    fi
else
    echo "GitHub CLI already installed ✅"
fi


# AUTHENTICATION -----------------------------------

if ! gh auth status &>/dev/null;then
	echo "GIT NOT LOGIN"
	echo "Authenticating....."
	gh auth login
else
	echo "Git already logined "
fi

# CREATE REPOS---------------------------------------
gh repo create "$REPO_NAME" --description "$DESCRIPTION" --private --confirm

mkdir "$REPO_NAME"
cd "$REPO_NAME" || exit
git init

git config user.name "$GIT_USERNAME"
git config user.email "$GIT_EMAIL"

echo "$REPO_NAME" > README.md
git add .
git commit -m "first commit"
git branch -M main

USERNAME=$(gh api user --jq .login)

git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
git push -u origin main

echo "Done Repo Created..."

echo "https://github.com/$USERNAME/$REPO_NAME"
