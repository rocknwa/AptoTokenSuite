#!/bin/bash

# Aptos Token Deployment Script
# Usage: ./scripts/deploy.sh [network]

set -e

NETWORK=${1:-testnet}
CONFIG_FILE=".aptos/config.yaml"

echo "🚀 Deploying to $NETWORK..."

# Check if Aptos CLI is installed
if ! command -v aptos &> /dev/null; then
    echo "❌ Aptos CLI not found. Please install it first."
    exit 1
fi

# Check if initialized
if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Aptos not initialized. Run 'aptos init' first."
    exit 1
fi

# Get account address
ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}' | tr -d '"')
echo "📍 Using account: $ACCOUNT_ADDRESS"

# Check account balance
echo "💰 Checking account balance..."
aptos account list --query balance --account $ACCOUNT_ADDRESS

# Compile the contract
echo "🔨 Compiling contract..."
aptos move compile

# Run tests before deployment
echo "🧪 Running tests..."
aptos move test

# Deploy the contract
echo "📦 Publishing contract..."
aptos move publish --assume-yes

echo "✅ Deployment completed!"
echo "📋 Contract deployed at: $ACCOUNT_ADDRESS"
echo ""
echo "Next steps:"
echo "1. Initialize your token: ./scripts/initialize.sh"
echo "2. Interact with your token: ./scripts/interact.sh"