#!/bin/bash

# Token Initialization Script
# Usage: ./scripts/initialize.sh

set -e

# Configuration - Modify these values for your token
TOKEN_NAME="My Awesome Token"
TOKEN_SYMBOL="MAT"
TOKEN_DECIMALS=8
MONITOR_SUPPLY=true
INITIAL_MINT_AMOUNT=1000000  # 1M tokens (adjust based on decimals)

# Get account address
ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}' | tr -d '"')
echo "🎯 Initializing token for account: $ACCOUNT_ADDRESS"

# Initialize the token
echo "🚀 Initializing token: $TOKEN_NAME ($TOKEN_SYMBOL)"
aptos move run \
    --function-id ${ACCOUNT_ADDRESS}::my_token::initialize \
    --args string:"$TOKEN_NAME" string:"$TOKEN_SYMBOL" u8:$TOKEN_DECIMALS bool:$MONITOR_SUPPLY

echo "✅ Token initialized successfully!"

# Register the admin account
echo "📝 Registering admin account..."
aptos move run \
    --function-id ${ACCOUNT_ADDRESS}::my_token::register

echo "✅ Admin account registered!"

# Mint initial tokens to admin
echo "💎 Minting initial tokens ($INITIAL_MINT_AMOUNT)..."
aptos move run \
    --function-id ${ACCOUNT_ADDRESS}::my_token::mint \
    --args address:$ACCOUNT_ADDRESS u64:$INITIAL_MINT_AMOUNT

echo "✅ Initial tokens minted!"

# Check token information
echo ""
echo "📊 Token Information:"
echo "Name: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::name | grep -o '"[^"]*"' | sed 's/"//g')"
echo "Symbol: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::symbol | grep -o '"[^"]*"' | sed 's/"//g')"
echo "Decimals: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::decimals)"
echo "Admin Balance: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::balance --args address:$ACCOUNT_ADDRESS)"

echo ""
echo "🎉 Token initialization completed!"
echo "Your token is ready to use. Try the interact.sh script for common operations."