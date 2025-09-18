#!/bin/bash

# Contract Upgrade Script
# Usage: ./scripts/upgrade.sh [--force]

set -e

FORCE_FLAG=""
if [ "$1" = "--force" ]; then
    FORCE_FLAG="--assume-yes"
fi

ACCOUNT_ADDRESS=$(aptos config show-profiles --profile default | grep "account" | awk '{print $2}' | tr -d '"')

echo "🔄 Contract Upgrade Process"
echo "============================"
echo "Account: $ACCOUNT_ADDRESS"
echo ""

# Function to check upgrade policy
check_upgrade_policy() {
    echo "📋 Checking upgrade policy..."
    
    local upgrade_policy=$(grep "upgrade_policy" Move.toml | awk -F'"' '{print $2}')
    echo "Current upgrade policy: $upgrade_policy"
    
    if [ "$upgrade_policy" = "immutable" ]; then
        echo "❌ Contract is marked as immutable and cannot be upgraded!"
        echo "To enable upgrades, change upgrade_policy to 'compatible' in Move.toml"
        exit 1
    fi
    
    echo "✅ Contract can be upgraded"
}

# Function to backup current state
backup_current_state() {
    echo ""
    echo "💾 Creating backup of current state..."
    
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_dir="backups/${timestamp}"
    
    mkdir -p "$backup_dir"
    
    # Backup contract information
    echo "Backing up contract information..."
    aptos account list --query modules --account $ACCOUNT_ADDRESS > "${backup_dir}/modules.json" 2>/dev/null || echo "Could not backup modules"
    aptos account list --query resources --account $ACCOUNT_ADDRESS > "${backup_dir}/resources.json" 2>/dev/null || echo "Could not backup resources"
    
    # Backup token state if accessible
    echo "Backing up token state..."
    {
        echo "Token Name: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::name 2>/dev/null)"
        echo "Token Symbol: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::symbol 2>/dev/null)"
        echo "Token Decimals: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::decimals 2>/dev/null)"
        echo "Total Supply: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::supply 2>/dev/null)"
        echo "Admin Balance: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::balance --args address:$ACCOUNT_ADDRESS 2>/dev/null)"
    } > "${backup_dir}/token_state.txt"
    
    # Backup current code
    cp -r sources/ "${backup_dir}/"
    cp Move.toml "${backup_dir}/"
    
    echo "✅ Backup created in: $backup_dir"
}

# Function to run pre-upgrade checks
pre_upgrade_checks() {
    echo ""
    echo "🔍 Running pre-upgrade checks..."
    
    # Check compilation
    echo "Checking compilation..."
    if aptos move compile; then
        echo "✅ Code compiles successfully"
    else
        echo "❌ Compilation failed! Please fix errors before upgrading."
        exit 1
    fi
    
    # Run tests
    echo "Running tests..."
    if aptos move test; then
        echo "✅ All tests pass"
    else
        echo "❌ Tests failed! Please fix issues before upgrading."
        echo "Use --force flag to skip test verification (not recommended)"
        if [ "$FORCE_FLAG" = "" ]; then
            exit 1
        fi
    fi
    
    # Check account balance for gas
    echo "Checking account balance..."
    local balance=$(aptos account list --query balance --account $ACCOUNT_ADDRESS 2>/dev/null | grep -o '[0-9]*' || echo "0")
    if [ "$balance" -lt 1000000 ]; then  # Less than 0.01 APT
        echo "⚠️  Low account balance ($balance octas). You might need more APT for gas."
        echo "Consider funding your account before upgrading."
    else
        echo "✅ Sufficient balance for upgrade"
    fi
}

# Function to show upgrade diff
show_upgrade_diff() {
    echo ""
    echo "📊 Upgrade Summary:"
    echo "-------------------"
    
    # This is a simplified diff - in practice, you'd want more sophisticated analysis
    echo "Files to be updated:"
    find sources/ -name "*.move" -type f | while read file; do
        echo "  📄 $file"
    done
    
    echo ""
    echo "⚠️  Important Notes:"
    echo "  • This upgrade will modify the deployed contract"
    echo "  • Existing data and state will be preserved"
    echo "  • Make sure you've tested all changes thoroughly"
    echo "  • Consider the impact on existing users and integrations"
}

# Function to perform the upgrade
perform_upgrade() {
    echo ""
    echo "🚀 Performing upgrade..."
    
    local start_time=$(date +%s)
    
    # Publish the upgraded contract
    if [ "$FORCE_FLAG" = "" ]; then
        echo "About to upgrade contract. Do you want to continue? (y/N)"
        read -r response
        if [[ ! "$response" =~ ^[Yy]$ ]]; then
            echo "Upgrade cancelled."
            exit 0
        fi
    fi
    
    echo "Publishing upgraded contract..."
    if aptos move publish $FORCE_FLAG; then
        local end_time=$(date +%s)
        local duration=$((end_time - start_time))
        echo "✅ Upgrade completed successfully in ${duration} seconds!"
    else
        echo "❌ Upgrade failed!"
        echo ""
        echo "Troubleshooting tips:"
        echo "1. Check that your account has sufficient APT for gas"
        echo "2. Ensure the upgrade is compatible with the existing contract"
        echo "3. Verify that all dependencies are correctly specified"
        echo "4. Check network connectivity"
        exit 1
    fi
}

# Function to verify upgrade
verify_upgrade() {
    echo ""
    echo "🔍 Verifying upgrade..."
    
    # Check if basic functions still work
    echo "Testing basic contract functions..."
    
    if aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::name >/dev/null 2>&1; then
        echo "✅ Contract is accessible and functioning"
    else
        echo "❌ Contract may have issues after upgrade"
        return 1
    fi
    
    # Display current contract state
    echo ""
    echo "📊 Post-upgrade contract state:"
    echo "Token Name: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::name 2>/dev/null | grep -o '"[^"]*"' | sed 's/"//g')"
    echo "Token Symbol: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::symbol 2>/dev/null | grep -o '"[^"]*"' | sed 's/"//g')"
    echo "Admin Balance: $(aptos move view --function-id ${ACCOUNT_ADDRESS}::my_token::balance --args address:$ACCOUNT_ADDRESS 2>/dev/null)"
    
    echo ""
    echo "✅ Upgrade verification completed"
}

# Function to show post-upgrade recommendations
show_post_upgrade_recommendations() {
    echo ""
    echo "📝 Post-Upgrade Recommendations:"
    echo "================================"
    echo "1. Test all contract functions thoroughly"
    echo "2. Monitor the contract for any issues"
    echo "3. Update any frontend or integration code if needed"
    echo "4. Notify users of any breaking changes"
    echo "5. Keep the backup in case rollback is needed"
    echo ""
    echo "Useful commands:"
    echo "  ./scripts/monitor.sh     # Monitor contract health"
    echo "  ./scripts/interact.sh    # Test contract functions"
    echo "  aptos move test          # Run test suite"
}

# Main execution flow
main() {
    check_upgrade_policy
    backup_current_state
    pre_upgrade_checks
    show_upgrade_diff
    perform_upgrade
    verify_upgrade
    show_post_upgrade_recommendations
    
    echo ""
    echo "🎉 Contract upgrade process completed successfully!"
    echo "Your contract has been upgraded and is ready for use."
}

# Check if this is being run from the correct directory
if [ ! -f "Move.toml" ]; then
    echo "❌ Error: Move.toml not found. Please run this script from the project root directory."
    exit 1
fi

# Run main function
main