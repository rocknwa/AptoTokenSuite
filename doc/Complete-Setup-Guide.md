# 🚀 Aptos Scaffold - Fungible Token Template

A comprehensive scaffold for building on Aptos blockchain, similar to Scaffold-ETH. This template provides a complete fungible token implementation with tests, deployment scripts, and detailed customization instructions.

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Prerequisites](#-prerequisites)
- [Installation & Setup](#-installation--setup)
- [Project Structure](#-project-structure)
- [Customizing Your Project](#-customizing-your-project)
- [Testing](#-testing)
- [Deployment](#-deployment)
- [Available Commands](#-available-commands)
- [Troubleshooting](#-troubleshooting)

## 🚀 Quick Start

```bash
# Clone the scaffold
git clone <your-repo-url>
cd aptos-scaffold

# Install Aptos CLI (see detailed instructions below)
# For macOS:
brew install aptos

# Initialize your Aptos account
aptos init --network testnet

# Compile the contract
aptos move compile

# Run tests
aptos move test

# Deploy to testnet
aptos move publish
```

## 📋 Prerequisites

- **Aptos CLI**: Command-line interface for Aptos blockchain
- **Petra Wallet**: Browser extension for account management
- **Git**: For version control
- **Code Editor**: VS Code recommended with Move syntax support

## 🛠 Installation & Setup

### Step 1: Setup Petra Wallet

1. **Download Petra Wallet**
   - Install the [Petra Aptos Wallet Chrome extension](https://chrome.google.com/webstore/detail/petra-aptos-wallet/ejjladinnckdgjemekebdpeokbikhfci)
   - Click "Create New Wallet"
   - Create a secure password
   - **⚠️ IMPORTANT**: Save your recovery phrase securely - never share it!

2. **Switch to Testnet**
   - Go to Settings → Network → Select "Testnet"

3. **Copy Essential Information**
   - Go to Settings → Manage Account
   - Copy and save your **Wallet Address**
   - Copy and save your **Private Key** (keep this secret!)

4. **Fund Your Wallet**
   - Click "Faucet" button to get test APT tokens
   - You'll receive 1 APT for testing

### Step 2: Install Aptos CLI

Choose your operating system:

#### macOS
```bash
# Install Homebrew if you don't have it
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Aptos CLI
brew update
brew install aptos

# Verify installation
aptos help
```

#### Linux (Ubuntu/Debian)
```bash
# Install dependencies
sudo apt-get update
sudo apt-get install curl python3

# Install Aptos CLI
curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3

# Or using wget
sudo apt-get install wget
wget -qO- "https://aptos.dev/scripts/install_cli.py" | python3

# Verify installation
aptos help
```

#### Windows
```powershell
# Install Python from https://python.org first
# Then run in PowerShell:
iwr "https://aptos.dev/scripts/install_cli.py" -useb | Select-Object -ExpandProperty Content | python3

# Verify installation
aptos help
```

### Step 3: Initialize Aptos CLI

```bash
# Initialize in your project directory
aptos init --network testnet

# When prompted:
# - Choose network: testnet
# - Enter your private key from Petra wallet
```

## 📁 Project Structure

```
aptos-scaffold/
├── sources/
│   └── my_token.move          # Main fungible token contract
├── tests/
│   └── my_token_tests.move    # Comprehensive test suite
├── Move.toml                  # Project configuration
├── README.md                  # This file
└── scripts/                   # Deployment and interaction scripts
    ├── deploy.sh
    ├── initialize.sh
    └── interact.sh
```

## 🎨 Customizing Your Project

### 1. Update Move.toml Configuration

Edit `Move.toml` to customize your project:

```toml
[package]
name = "your_project_name"           # Change this to your project name
version = "1.0.0"
authors = ["Your Name <your@email.com>"]  # Add your information
license = "Apache-2.0"
upgrade_policy = "compatible"

[addresses]
your_project_name = "YOUR_WALLET_ADDRESS"  # Replace with your wallet address
std = "0x1"
aptos_std = "0x1"
aptos_framework = "0x1"

[dev-addresses]
your_project_name = "0xCAFE"  # Keep this for testing
```

**⚠️ Important Steps:**
1. Replace `fungible_token` with your project name throughout the file
2. Replace `YOUR_WALLET_ADDRESS` with your actual wallet address from Petra
3. Update the author information

### 2. Customize the Token Contract

Edit `sources/my_token.move`:

#### A. Change Module Declaration
```move
// FROM:
module fungible_token::my_token {

// TO:
module your_project_name::your_token_name {
```

#### B. Customize Token Properties
```move
// In the initialize function, you can set:
public entry fun initialize(
    admin: &signer,
    name: vector<u8>,        // e.g., b"My Awesome Token"
    symbol: vector<u8>,      // e.g., b"MAT"
    decimals: u8,           // e.g., 8 (most tokens use 6-8)
    monitor_supply: bool,    // true to track total supply
) {
    // ... rest of the function
}
```

#### C. Add Custom Functions (Examples)
```move
// Add a maximum supply cap
const MAX_SUPPLY: u64 = 1000000000; // 1 billion tokens

// Add minting with supply cap
public entry fun mint_with_cap(
    admin: &signer,
    to: address,
    amount: u64,
) acquires TokenCapabilities {
    let current_supply = option::extract(&mut supply());
    assert!(current_supply + (amount as u128) <= (MAX_SUPPLY as u128), E_EXCEEDS_MAX_SUPPLY);
    
    // Call existing mint function
    mint(admin, to, amount);
}
```

### 3. Update Test File

Edit `tests/my_token_tests.move`:

#### A. Update Module References
```move
// FROM:
module fungible_token::my_token_tests {
    use fungible_token::my_token;

// TO:
module your_project_name::your_token_tests {
    use your_project_name::your_token_name;
```

#### B. Update Test Account Addresses
```move
// FROM:
let admin = account::create_account_for_test(@fungible_token);

// TO:
let admin = account::create_account_for_test(@your_project_name);
```

#### C. Add Custom Tests
```move
#[test]
fun test_your_custom_function() {
    // Your custom test logic here
}
```

### 4. Advanced Customizations

#### A. Add Token Metadata
```move
struct TokenMetadata has key {
    website: string::String,
    description: string::String,
    logo_url: string::String,
}

public entry fun set_metadata(
    admin: &signer,
    website: vector<u8>,
    description: vector<u8>,
    logo_url: vector<u8>,
) {
    let metadata = TokenMetadata {
        website: string::utf8(website),
        description: string::utf8(description),
        logo_url: string::utf8(logo_url),
    };
    move_to(admin, metadata);
}
```

#### B. Add Pausable Functionality
```move
struct PauseState has key {
    is_paused: bool,
}

public entry fun pause(admin: &signer) acquires PauseState {
    let pause_state = borrow_global_mut<PauseState>(signer::address_of(admin));
    pause_state.is_paused = true;
}

public entry fun unpause(admin: &signer) acquires PauseState {
    let pause_state = borrow_global_mut<PauseState>(signer::address_of(admin));
    pause_state.is_paused = false;
}
```

#### C. Add Multi-Signature Support
```move
struct MultiSigAdmin has key {
    required_signatures: u8,
    admins: vector<address>,
}
```

## 🧪 Testing

### Run All Tests
```bash
aptos move test
```

### Run Specific Test
```bash
aptos move test --filter test_initialize_token
```

### Run Tests with Coverage
```bash
aptos move test --coverage
```

### Add New Tests

1. Open `tests/my_token_tests.move`
2. Add your test function:
```move
#[test]
fun test_your_feature() {
    let (admin, user1, user2) = setup_test();
    
    // Your test logic here
    
    assert!(condition, error_code);
}
```

## 🚀 Deployment

### 1. Compile Contract
```bash
aptos move compile
```

### 2. Deploy to Testnet
```bash
aptos move publish --named-addresses your_project_name=YOUR_WALLET_ADDRESS
```

### 3. Initialize Your Token
```bash
aptos move run \
  --function-id YOUR_ADDRESS::your_token_name::initialize \
  --args string:"Your Token Name" string:"SYMBOL" u8:8 bool:true
```

### 4. Register and Mint Tokens
```bash
# Register your account
aptos move run \
  --function-id YOUR_ADDRESS::your_token_name::register

# Mint tokens to yourself
aptos move run \
  --function-id YOUR_ADDRESS::your_token_name::mint \
  --args address:YOUR_ADDRESS u64:1000000
```

## 📝 Available Commands

### Development Commands
```bash
# Compile contract
aptos move compile

# Run tests
aptos move test

# Check for compilation errors
aptos move check

# Generate documentation
aptos move document
```

### Deployment Commands
```bash
# Publish contract
aptos move publish

# View published modules
aptos account list --query modules

# Check account resources
aptos account list --query resources
```

### Token Interaction Commands
```bash
# Check token balance
aptos move view \
  --function-id YOUR_ADDRESS::your_token_name::balance \
  --args address:TARGET_ADDRESS

# Transfer tokens
aptos move run \
  --function-id YOUR_ADDRESS::your_token_name::transfer \
  --args address:RECIPIENT_ADDRESS u64:AMOUNT

# Check token supply
aptos move view \
  --function-id YOUR_ADDRESS::your_token_name::supply
```

## 🔧 Common Customization Patterns

### 1. Token with Fixed Supply
```move
const TOTAL_SUPPLY: u64 = 1000000000; // 1B tokens

public entry fun initialize_fixed_supply(admin: &signer) {
    initialize(admin, b"Fixed Token", b"FIXED", 8, true);
    register(admin);
    mint(admin, signer::address_of(admin), TOTAL_SUPPLY);
    
    // Optional: Destroy mint capability to prevent further minting
    // This requires modifying the TokenCapabilities struct
}
```

### 2. Token with Vesting
```move
struct VestingSchedule has key {
    beneficiary: address,
    total_amount: u64,
    released_amount: u64,
    start_time: u64,
    duration: u64,
}

public entry fun create_vesting(
    admin: &signer,
    beneficiary: address,
    amount: u64,
    duration: u64,
) {
    // Implementation here
}
```

### 3. Deflationary Token
```move
const BURN_RATE: u64 = 100; // 1% burn on transfer (100/10000)

public entry fun transfer_with_burn(
    from: &signer,
    to: address,
    amount: u64,
) {
    let burn_amount = amount * BURN_RATE / 10000;
    let transfer_amount = amount - burn_amount;
    
    // Burn tokens
    burn_from(from, burn_amount);
    
    // Transfer remaining
    transfer(from, to, transfer_amount);
}
```

## 🐛 Troubleshooting

### Common Issues

#### 1. "Account doesn't exist" Error
```bash
# Solution: Fund your account first
aptos account fund-with-faucet --account YOUR_ADDRESS
```

#### 2. "Module not found" Error
- Check that addresses in `Move.toml` match your wallet address
- Ensure you've compiled before testing: `aptos move compile`

#### 3. "Insufficient gas" Error
```bash
# Check your account balance
aptos account list --query balance

# Fund account if needed
aptos account fund-with-faucet --account YOUR_ADDRESS
```

#### 4. Test Failures
- Ensure all module names are updated consistently
- Check that test addresses match your configuration
- Verify error codes match your contract

### Getting Help

1. **Aptos Documentation**: [https://aptos.dev/](https://aptos.dev/)
2. **Move Language Guide**: [https://move-language.github.io/move/](https://move-language.github.io/move/)
3. **Aptos Discord**: Join the community for support
4. **GitHub Issues**: Report bugs or request features

## 🎯 Next Steps

1. **Customize the token** according to your project needs
2. **Add additional features** like staking, governance, or NFT integration
3. **Deploy to mainnet** when ready (remember to use mainnet addresses)
4. **Build a frontend** to interact with your token
5. **Integrate with wallets** and other DeFi protocols

## 📄 License

This project is licensed under the Apache License 2.0 - see the LICENSE file for details.

---

**Happy Building! 🚀**

*Remember to always test thoroughly on testnet before deploying to mainnet, and never share your private keys!*