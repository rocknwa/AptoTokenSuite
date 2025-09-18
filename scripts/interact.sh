#!/bin/bash

# Token Interaction Script
# Usage: ./scripts/interact.sh [command] [args...]

set -e

ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}' | tr -d '"')
MODULE_ID="${ACCOUNT_ADDRESS}::my_token"

show_help() {
    echo "🔗 Aptos Token Interaction Script"
    echo ""
    echo "Usage: $0 [command] [args...]"
    echo ""
    echo "Available commands:"
    echo "  balance <address>              - Check token balance of an address"
    echo "  transfer <to_address> <amount> - Transfer tokens to another address"
    echo "  mint <to_address> <amount>     - Mint new tokens (admin only)"
    echo "  burn <amount>                  - Burn tokens from admin account"
    echo "  register <address>             - Register an address to receive tokens"
    echo "  info                           - Show token information"
    echo "  supply                         - Show token supply"
    echo "  help                           - Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 info"
    echo "  $0 balance $ACCOUNT_ADDRESS"
    echo "  $0 transfer 0x123...abc 1000"
    echo "  $0 mint 0x123...abc 500"
}

check_balance() {
    local address=${1:-$ACCOUNT_ADDRESS}
    echo "💰 Checking balance for: $address"
    aptos move view --function-id ${MODULE_ID}::balance --args address:$address
}

transfer_tokens() {
    local to_address=$1
    local amount=$2
    
    if [ -z "$to_address" ] || [ -z "$amount" ]; then
        echo "❌ Usage: transfer <to_address> <amount>"
        exit 1
    fi
    
    echo "📤 Transferring $amount tokens to $to_address"
    aptos move run \
        --function-id ${MODULE_ID}::transfer \
        --args address:$to_address u64:$amount
    
    echo "✅ Transfer completed!"
}

mint_tokens() {
    local to_address=$1
    local amount=$2
    
    if [ -z "$to_address" ] || [ -z "$amount" ]; then
        echo "❌ Usage: mint <to_address> <amount>"
        exit 1
    fi
    
    echo "💎 Minting $amount tokens to $to_address"
    aptos move run \
        --function-id ${MODULE_ID}::mint \
        --args address:$to_address u64:$amount
    
    echo "✅ Minting completed!"
}

burn_tokens() {
    local amount=$1
    
    if [ -z "$amount" ]; then
        echo "❌ Usage: burn <amount>"
        exit 1
    fi
    
    echo "🔥 Burning $amount tokens from admin account"
    aptos move run \
        --function-id ${MODULE_ID}::burn \
        --args u64:$amount
    
    echo "✅ Burning completed!"
}

register_account() {
    local address=${1:-$ACCOUNT_ADDRESS}
    
    echo "📝 Registering account: $address"
    
    if [ "$address" = "$ACCOUNT_ADDRESS" ]; then
        # Register current account
        aptos move run --function-id ${MODULE_ID}::register
    else
        echo "❌ Can only register your own account directly"
        echo "ℹ️  The target account ($address) needs to run this command themselves:"
        echo "   aptos move run --function-id ${MODULE_ID}::register"
        exit 1
    fi
    
    echo "✅ Account registered!"
}

show_token_info() {
    echo "📊 Token Information:"
    echo "===================="
    
    echo -n "Name: "
    aptos move view --function-id ${MODULE_ID}::name | grep -o '"[^"]*"' | sed 's/"//g' 2>/dev/null || echo "Error fetching name"
    
    echo -n "Symbol: "
    aptos move view --function-id ${MODULE_ID}::symbol | grep -o '"[^"]*"' | sed 's/"//g' 2>/dev/null || echo "Error fetching symbol"
    
    echo -n "Decimals: "
    aptos move view --function-id ${MODULE_ID}::decimals 2>/dev/null || echo "Error fetching decimals"
    
    echo -n "Admin Address: "
    echo $ACCOUNT_ADDRESS
    
    echo -n "Admin Balance: "
    aptos move view --function-id ${MODULE_ID}::balance --args address:$ACCOUNT_ADDRESS 2>/dev/null || echo "Error fetching balance"
}

show_supply() {
    echo "📈 Token Supply Information:"
    echo "============================"
    
    echo -n "Total Supply: "
    aptos move view --function-id ${MODULE_ID}::supply 2>/dev/null || echo "Supply monitoring not enabled"
}

# Check if module exists
check_module() {
    echo "🔍 Checking if token contract is deployed..."
    aptos account list --query modules --account $ACCOUNT_ADDRESS | grep -q "my_token" || {
        echo "❌ Token contract not found. Please deploy first with: ./scripts/deploy.sh"
        exit 1
    }
    echo "✅ Token contract found"
}

# Main command handling
COMMAND=${1:-help}

case $COMMAND in
    "balance")
        check_module
        check_balance $2
        ;;
    "transfer")
        check_module
        transfer_tokens $2 $3
        ;;
    "mint")
        check_module
        mint_tokens $2 $3
        ;;
    "burn")
        check_module
        burn_tokens $2
        ;;
    "register")
        check_module
        register_account $2
        ;;
    "info")
        check_module
        show_token_info
        ;;
    "supply")
        check_module
        show_supply
        ;;
    "help")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $COMMAND"
        echo ""
        show_help
        exit 1
        ;;
esac