# Aptos Token Scaffold - Makefile
# Provides convenient commands for development workflow

.PHONY: help install compile test deploy initialize interact monitor upgrade clean setup-dev

# Default target
help: ## Show this help message
	@echo "🚀 Aptos Token Scaffold Commands"
	@echo "================================="
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# Installation and Setup
install: ## Install Aptos CLI (macOS only)
	@echo "📦 Installing Aptos CLI..."
	@if command -v brew >/dev/null 2>&1; then \
		brew update && brew install aptos; \
	else \
		echo "❌ Homebrew not found. Please install manually."; \
		echo "See: https://aptos.dev/tools/install-cli/"; \
	fi

setup-dev: ## Setup development environment
	@echo "🔧 Setting up development environment..."
	@chmod +x scripts/*.sh
	@if [ ! -f .aptos/config.yaml ]; then \
		echo "⚙️ Initializing Aptos CLI..."; \
		aptos init --network testnet; \
	fi
	@echo "✅ Development environment ready!"

# Development Commands
compile: ## Compile the Move contract
	@echo "🔨 Compiling contract..."
	@aptos move compile

test: ## Run all tests
	@echo "🧪 Running tests..."
	@aptos move test

test-coverage: ## Run tests with coverage report
	@echo "📊 Running tests with coverage..."
	@aptos move test --coverage

# Deployment Commands
deploy: compile test ## Deploy contract to testnet
	@echo "🚀 Deploying to testnet..."
	@./scripts/deploy.sh testnet

deploy-mainnet: compile test ## Deploy contract to mainnet (use with caution!)
	@echo "⚠️ Deploying to MAINNET..."
	@read -p "Are you sure? This will deploy to mainnet! (y/N): " confirm; \
	if [ "$$confirm" = "y" ] || [ "$$confirm" = "Y" ]; then \
		./scripts/deploy.sh mainnet; \
	else \
		echo "Deployment cancelled."; \
	fi

# Token Operations
initialize: ## Initialize the deployed token
	@echo "🎯 Initializing token..."
	@./scripts/initialize.sh

interact: ## Open interactive CLI for token operations
	@echo "🔗 Starting interactive mode..."
	@./scripts/interact.sh help

# Token-specific commands
balance: ## Check admin token balance
	@./scripts/interact.sh balance

transfer: ## Transfer tokens (interactive)
	@echo "📤 Token Transfer"
	@echo "Usage: make transfer TO=<address> AMOUNT=<amount>"
	@if [ -z "$(TO)" ] || [ -z "$(AMOUNT)" ]; then \
		echo "❌ Please specify TO and AMOUNT"; \
		echo "Example: make transfer TO=0x123...abc AMOUNT=1000"; \
	else \
		./scripts/interact.sh transfer $(TO) $(AMOUNT); \
	fi

mint: ## Mint new tokens (interactive)
	@echo "💎 Token Minting"
	@echo "Usage: make mint TO=<address> AMOUNT=<amount>"
	@if [ -z "$(TO)" ] || [ -z "$(AMOUNT)" ]; then \
		echo "❌ Please specify TO and AMOUNT"; \
		echo "Example: make mint TO=0x123...abc AMOUNT=1000"; \
	else \
		./scripts/interact.sh mint $(TO) $(AMOUNT); \
	fi

info: ## Show token information
	@./scripts/interact.sh info

supply: ## Show token supply information
	@./scripts/interact.sh supply

# Monitoring and Maintenance
monitor: ## Start token monitoring dashboard
	@echo "📊 Starting monitoring dashboard..."
	@./scripts/monitor.sh

upgrade: compile test ## Upgrade the deployed contract
	@echo "🔄 Starting upgrade process..."
	@./scripts/upgrade.sh

upgrade-force: compile ## Force upgrade without tests (dangerous!)
	@echo "⚠️ Force upgrading contract..."
	@./scripts/upgrade.sh --force

# Development Utilities
clean: ## Clean build artifacts
	@echo "🧹 Cleaning build artifacts..."
	@rm -rf build/
	@rm -rf .aptos/config.yaml.bak
	@echo "✅ Clean completed!"

check: ## Check code without compiling
	@echo "🔍 Checking code..."
	@aptos move check

format: ## Format Move code (if formatter available)
	@echo "📝 Formatting code..."
	@if command -v move-fmt >/dev/null 2>&1; then \
		find sources tests -name "*.move" -exec move-fmt {} \; ; \
	else \
		echo "ℹ️ move-fmt not available. Install for automatic formatting."; \
	fi

lint: ## Run linting checks
	@echo "🔍 Running linting checks..."
	@aptos move check
	@echo "✅ Linting completed!"

# Documentation
docs: ## Generate documentation
	@echo "📚 Generating documentation..."
	@aptos move document --output-dir docs/generated/
	@echo "📖 Documentation generated in docs/generated/"

# Security
security-check: ## Run basic security checks
	@echo "🔐 Running security checks..."
	@echo "Checking for common patterns..."
	@grep -r "unwrap\|panic\|abort" sources/ || echo "✅ No unsafe patterns found"
	@echo "Checking for TODO/FIXME comments..."
	@grep -r "TODO\|FIXME\|XXX" sources/ || echo "✅ No pending tasks found"
	@echo "Security check completed. Consider professional audit for production!"

# Git hooks setup
setup-hooks: ## Setup git hooks for development
	@echo "🔗 Setting up git hooks..."
	@mkdir -p .git/hooks
	@echo '#!/bin/bash\nmake test' > .git/hooks/pre-commit
	@chmod +x .git/hooks/pre-commit
	@echo "✅ Git hooks setup completed!"

# Network operations
fund-account: ## Fund account with testnet tokens
	@echo "💰 Funding account with testnet tokens..."
	@aptos account fund-with-faucet --account default

check-balance: ## Check APT balance
	@echo "💰 Checking APT balance..."
	@aptos account list --query balance

# Backup operations
backup: ## Create backup of current contract state
	@echo "💾 Creating backup..."
	@mkdir -p backups/manual_$(shell date +%Y%m%d_%H%M%S)
	@cp -r sources tests Move.toml backups/manual_$(shell date +%Y%m%d_%H%M%S)/
	@echo "✅ Backup created!"

# All-in-one commands
dev-setup: install setup-dev fund-account ## Complete development setup
	@echo "🎉 Development environment fully configured!"

quick-deploy: compile test deploy initialize ## Quick deployment pipeline
	@echo "🚀 Quick deployment completed!"

full-test: clean compile test test-coverage security-check ## Full test suite
	@echo "✅ Full test suite completed!"

# Project customization helpers
customize: ## Interactive project customization
	@echo "🎨 Project Customization Helper"
	@echo "=============================="
	@echo "This will help you customize the scaffold for your project."
	@echo ""
	@read -p "Enter your project name (snake_case): " project_name; \
	read -p "Enter your wallet address: " wallet_addr; \
	read -p "Enter your name: " author_name; \
	read -p "Enter your email: " author_email; \
	echo ""; \
	echo "Customizing project..."; \
	sed -i.bak "s/fungible_token/$$project_name/g" Move.toml; \
	sed -i.bak "s/0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894/$$wallet_addr/g" Move.toml; \
	sed -i.bak "s/Therock Ani <anitherock44@gmail.com>/$$author_name <$$author_email>/g" Move.toml; \
	echo "✅ Basic customization completed!"; \
	echo "Next steps:"; \
	echo "1. Update module names in sources/ and tests/"; \
	echo "2. Update function IDs in scripts/"; \
	echo "3. Run 'make compile' to verify changes";

# Quick reference
commands: help ## Alias for help

# Development workflow examples
.PHONY: workflow-dev workflow-deploy workflow-test

workflow-dev: ## Example development workflow
	@echo "🔄 Development Workflow Example:"
	@echo "1. make setup-dev    # Setup environment"
	@echo "2. make customize    # Customize project" 
	@echo "3. make compile      # Compile contract"
	@echo "4. make test         # Run tests"
	@echo "5. make deploy       # Deploy to testnet"
	@echo "6. make initialize   # Initialize token"
	@echo "7. make monitor      # Monitor contract"

workflow-deploy: ## Example deployment workflow  
	@echo "🚀 Deployment Workflow Example:"
	@echo "1. make full-test    # Complete testing"
	@echo "2. make backup       # Backup current state"
	@echo "3. make deploy       # Deploy contract"
	@echo "4. make initialize   # Initialize token"
	@echo "5. make security-check # Security validation"
	@echo "6. make monitor      # Start monitoring"

workflow-test: ## Example testing workflow
	@echo "🧪 Testing Workflow Example:"
	@echo "1. make compile      # Compile first"
	@echo "2. make test         # Basic tests"
	@echo "3. make test-coverage # Coverage report"
	@echo "4. make security-check # Security checks"
	@echo "5. make lint         # Code quality"