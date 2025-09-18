#!/bin/bash

# Token Monitoring Script
# Usage: ./scripts/monitor.sh [interval_seconds]

set -e

INTERVAL=${1:-30}  # Default 30 seconds
ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}' | tr -d '"')
MODULE_ID="${ACCOUNT_ADDRESS}::my_token"

echo "📊 Token Monitoring Dashboard"
echo "=============================="
echo "Account: $ACCOUNT_ADDRESS"
echo "Update Interval: ${INTERVAL}s"
echo "Press Ctrl+C to stop"
echo ""

# Function to get current timestamp
get_timestamp() {
    date '+%Y-%m-%d %H:%M:%S'
}

# Function to fetch and display token stats
show_stats() {
    local timestamp=$(get_timestamp)
    
    echo "🕒 Last Update: $timestamp"
    echo "------------------------------"
    
    # Token Information
    echo "📋 Token Info:"
    echo -n "  Name: "
    aptos move view --function-id ${MODULE_ID}::name 2>/dev/null | grep -o '"[^"]*"' | sed 's/"//g' || echo "N/A"
    
    echo -n "  Symbol: "
    aptos move view --function-id ${MODULE_ID}::symbol 2>/dev/null | grep -o '"[^"]*"' | sed 's/"//g' || echo "N/A"
    
    echo -n "  Decimals: "
    aptos move view --function-id ${MODULE_ID}::decimals 2>/dev/null || echo "N/A"
    
    # Supply Information
    echo ""
    echo "📈 Supply Info:"
    echo -n "  Total Supply: "
    aptos move view --function-id ${MODULE_ID}::supply 2>/dev/null || echo "Monitoring disabled"
    
    # Admin Balance
    echo ""
    echo "💰 Admin Balance:"
    echo -n "  Balance: "
    aptos move view --function-id ${MODULE_ID}::balance --args address:$ACCOUNT_ADDRESS 2>/dev/null || echo "Error"
    
    # Account Information
    echo ""
    echo "🏦 Account Info:"
    echo -n "  APT Balance: "
    aptos account list --query balance --account $ACCOUNT_ADDRESS 2>/dev/null | grep -o '[0-9]*' || echo "Error"
    
    echo -n "  Sequence Number: "
    aptos account list --query sequence_number --account $ACCOUNT_ADDRESS 2>/dev/null || echo "Error"
    
    echo ""
    echo "=============================="
    echo ""
}

# Function to show recent transactions
show_recent_transactions() {
    echo "🔄 Recent Transactions:"
    echo "----------------------"
    
    # This would require additional API calls or indexer access
    # For now, we'll show a placeholder
    echo "  (Transaction history requires indexer API access)"
    echo ""
}

# Function to check contract health
check_contract_health() {
    echo "🏥 Contract Health Check:"
    echo "------------------------"
    
    # Check if contract is deployed
    if aptos account list --query modules --account $ACCOUNT_ADDRESS 2>/dev/null | grep -q "my_token"; then
        echo "  ✅ Contract deployed and accessible"
    else
        echo "  ❌ Contract not found or not accessible"
        return 1
    fi
    
    # Check if basic functions work
    if aptos move view --function-id ${MODULE_ID}::name >/dev/null 2>&1; then
        echo "  ✅ View functions working"
    else
        echo "  ⚠️  View functions may have issues"
    fi
    
    echo ""
}

# Function to show network status
show_network_status() {
    echo "🌐 Network Status:"
    echo "------------------"
    
    # Get current network
    local network=$(aptos config show-profiles --profile default | grep "network" | awk '{print $2}' | tr -d '"')
    echo "  Network: $network"
    
    # Check if we can reach the network
    if aptos node show-epoch-info >/dev/null 2>&1; then
        echo "  ✅ Network connection: OK"
    else
        echo "  ❌ Network connection: Failed"
    fi
    
    echo ""
}

# Trap Ctrl+C to cleanup and exit gracefully
cleanup() {
    echo ""
    echo "🛑 Monitoring stopped"
    exit 0
}
trap cleanup INT

# Initial health check
echo "🔍 Initial Health Check..."
check_contract_health || {
    echo "❌ Contract health check failed. Please ensure your token is deployed."
    exit 1
}

# Main monitoring loop
while true; do
    clear
    echo "📊 Token Monitoring Dashboard"
    echo "=============================="
    echo "Account: $ACCOUNT_ADDRESS"
    echo "Update Interval: ${INTERVAL}s"
    echo "Press Ctrl+C to stop"
    echo ""
    
    show_network_status
    show_stats
    check_contract_health
    show_recent_transactions
    
    echo "⏳ Next update in ${INTERVAL} seconds..."
    sleep $INTERVAL
done