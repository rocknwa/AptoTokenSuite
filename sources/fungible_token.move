module fungible_token::my_token {
    use std::signer;
    use std::string;
    use std::option;
    use aptos_framework::coin::{Self, Coin, MintCapability, BurnCapability, FreezeCapability};

    /// Error codes
    const E_NOT_ADMIN: u64 = 1;
    const E_INSUFFICIENT_BALANCE: u64 = 2;
    const E_NOT_INITIALIZED: u64 = 3;

    /// Token information struct
    struct MyToken has key {}

    /// Capabilities struct to store mint and burn capabilities
    struct TokenCapabilities has key {
        mint_cap: MintCapability<MyToken>,
        burn_cap: BurnCapability<MyToken>,
        freeze_cap: FreezeCapability<MyToken>,
    }

    /// Initialize the token (should be called by the module publisher)
    public entry fun initialize(
        admin: &signer,
        name: vector<u8>,
        symbol: vector<u8>,
        decimals: u8,
        monitor_supply: bool,
    ) {
        // Initialize the coin
        let (burn_cap, freeze_cap, mint_cap) = coin::initialize<MyToken>(
            admin,
            string::utf8(name),
            string::utf8(symbol),
            decimals,
            monitor_supply,
        );

        // Store capabilities
        move_to(admin, TokenCapabilities {
            mint_cap,
            burn_cap,
            freeze_cap,
        });
    }

    /// Mint new tokens (only admin can call this)
    public entry fun mint(
        admin: &signer,
        to: address,
        amount: u64,
    ) acquires TokenCapabilities {
        let admin_addr = signer::address_of(admin);
        assert!(exists<TokenCapabilities>(admin_addr), E_NOT_INITIALIZED);
        
        let caps = borrow_global<TokenCapabilities>(admin_addr);
        let coins = coin::mint<MyToken>(amount, &caps.mint_cap);
        coin::deposit(to, coins);
    }

    /// Burn tokens from admin's account
    public entry fun burn(
        admin: &signer,
        amount: u64,
    ) acquires TokenCapabilities {
        let admin_addr = signer::address_of(admin);
        assert!(exists<TokenCapabilities>(admin_addr), E_NOT_INITIALIZED);
        
        let caps = borrow_global<TokenCapabilities>(admin_addr);
        let coins = coin::withdraw<MyToken>(admin, amount);
        coin::burn(coins, &caps.burn_cap);
    }

    /// Burn tokens from a specific account (requires the account owner's signature)
    public entry fun burn_from(
        account_owner: &signer,
        amount: u64,
    ) acquires TokenCapabilities {
        // Get admin address (assumes admin deployed the contract at module address)
        let module_addr = @fungible_token;
        assert!(exists<TokenCapabilities>(module_addr), E_NOT_INITIALIZED);
        
        let caps = borrow_global<TokenCapabilities>(module_addr);
        let coins = coin::withdraw<MyToken>(account_owner, amount);
        coin::burn(coins, &caps.burn_cap);
    }

    /// Transfer tokens from one account to another
    public entry fun transfer(
        from: &signer,
        to: address,
        amount: u64,
    ) {
        coin::transfer<MyToken>(from, to, amount);
    }

    /// Deposit tokens to an account (internal function, not entry)
    public fun deposit(
        to: address,
        coins: Coin<MyToken>,
    ) {
        coin::deposit(to, coins);
    }

    /// Deposit tokens from one account to another (entry function)
    public entry fun deposit_from(
        from: &signer,
        to: address,
        amount: u64,
    ) {
        let coins = coin::withdraw<MyToken>(from, amount);
        coin::deposit(to, coins);
    }

    /// Withdraw tokens from an account
    public fun withdraw(
        account: &signer,
        amount: u64,
    ): Coin<MyToken> {
        coin::withdraw<MyToken>(account, amount)
    }

    /// Register an account to hold the token
    public entry fun register(account: &signer) {
        coin::register<MyToken>(account);
    }

    #[view]
    /// Get the balance of an account
    public fun balance(account: address): u64 {
        coin::balance<MyToken>(account)
    }

    #[view]
    /// Get token supply
    public fun supply(): option::Option<u128> {
        coin::supply<MyToken>()
    }

    #[view]
    /// Get token name
    public fun name(): string::String {
        coin::name<MyToken>()
    }

    #[view]
    /// Get token symbol
    public fun symbol(): string::String {
        coin::symbol<MyToken>()
    }

    #[view]
    /// Get token decimals
    public fun decimals(): u8 {
        coin::decimals<MyToken>()
    }

    #[view]
    /// Check if account is registered
    public fun is_registered(account: address): bool {
        coin::is_account_registered<MyToken>(account)
    }

    /// Freeze an account (only admin)
    public entry fun freeze_account(
        admin: &signer,
        account: address,
    ) acquires TokenCapabilities {
        let admin_addr = signer::address_of(admin);
        assert!(exists<TokenCapabilities>(admin_addr), E_NOT_INITIALIZED);
        
        let caps = borrow_global<TokenCapabilities>(admin_addr);
        coin::freeze_coin_store<MyToken>(account, &caps.freeze_cap);
    }

    /// Unfreeze an account (only admin)
    public entry fun unfreeze_account(
        admin: &signer,
        account: address,
    ) acquires TokenCapabilities {
        let admin_addr = signer::address_of(admin);
        assert!(exists<TokenCapabilities>(admin_addr), E_NOT_INITIALIZED);
        
        let caps = borrow_global<TokenCapabilities>(admin_addr);
        coin::unfreeze_coin_store<MyToken>(account, &caps.freeze_cap);
    }

    #[view]
    /// Check if account is frozen (placeholder - actual implementation depends on framework version)
    public fun is_frozen(_account: address): bool {
        // Note: coin::is_frozen might not be available in all framework versions
        // Return false as default or implement custom freeze tracking
        false
    }

}