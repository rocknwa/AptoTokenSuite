# ⚡ Quick Start - 5 Minutes to Your First Token

Get your Aptos token up and running in just 5 minutes!

## 🚀 Prerequisites (2 minutes)

1. **Install Aptos CLI** (choose your platform):
   ```bash
   # macOS
   brew install aptos
   
   # Linux
   curl -fsSL "https://aptos.dev/scripts/install_cli.py" | python3
   
   # Windows PowerShell
   iwr "https://aptos.dev/scripts/install_cli.py" -useb | Select-Object -ExpandProperty Content | python3
   ```

2. **Install Petra Wallet**: [Chrome Extension](https://chrome.google.com/webstore/detail/petra-aptos-wallet/ejjladinnckdgjemekebdpeokbikhfci)

## 🎯 Quick Deploy (3 minutes)

### Step 1: Setup (30 seconds)
```bash
# Clone and setup
git clone <your-scaffold-repo>
cd aptos-scaffold

# Make scripts executable
make setup-dev

# Or manually:
chmod +x scripts/*.sh
```

### Step 2: Configure (30 seconds)
```bash
# Initialize Aptos CLI (will prompt for network and private key)
aptos init --network testnet

# Quick customize (optional)
make customize
```

### Step 3: Deploy (2 minutes)
```bash
# All-in-one deployment
make quick-deploy

# Or step-by-step:
make compile    # Compile contract
make test      # Run tests  
make deploy    # Deploy to testnet
make initialize # Setup your token
```

## 🎉 You're Done!

Your token is now live on Aptos testnet! 

### Quick Commands
```bash
# Check your token info
make info

# Check your balance  
make balance

# Transfer tokens
make transfer TO=0x123...abc AMOUNT=1000

# Mint new tokens
make mint TO=0x123...abc AMOUNT=500

# Monitor your token
make monitor
```

## 🔧 Customization (Optional)

### Change Token Details
Edit these values in `scripts/initialize.sh`:
```bash
TOKEN_NAME="My Awesome Token"
TOKEN_SYMBOL="MAT"
TOKEN_DECIMALS=8
INITIAL_MINT_AMOUNT=1000000
```

### Update Contract
1. Edit `sources/my_token.move`
2. Update tests in `tests/my_token_tests.move`
3. Run `make upgrade` to deploy changes

## 📚 Next Steps

- Read the full [Complete-Setup-Guide](Complete-Setup-Guide.md) for detailed documentation
- Check [SECURITY.md](SECURITY.md) for security best practices
- Explore contract customization options
- Build a frontend interface
- Deploy to mainnet when ready

## 🆘 Troubleshooting

### Common Issues

**"Command not found: aptos"**
```bash
# Make sure Aptos CLI is installed and in PATH
aptos help
```

**"Account doesn't exist"**
```bash
# Fund your testnet account
make fund-account
```

**"Module not found"**
```bash
# Make sure contract is deployed
make deploy
```

**"Compilation failed"**
```bash
# Check for syntax errors
make check
```

### Getting Help
- 📖 Full documentation: [README.md](README.md)
- 💬 Aptos Discord: [https://discord.gg/aptoslabs](https://discord.gg/aptoslabs)
- 📚 Aptos Docs: [https://aptos.dev](https://aptos.dev)

---

**That's it! You now have a fully functional Aptos token in under 5 minutes! 🚀**