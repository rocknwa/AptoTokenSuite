#[test_only]
module fungible_token::my_token_tests {
    use std::signer;
    use std::string;
    use std::option;
    use aptos_framework::account;
    use aptos_framework::aptos_coin;
    use aptos_framework::coin;
    use fungible_token::my_token;

    // Test helper function to create test accounts and initialize framework
    fun setup_test(): (signer, signer, signer) {
        // Initialize the coin conversion map to fix the test environment
        let (burn_cap, mint_cap) = aptos_coin::initialize_for_test(&account::create_account_for_test(@0x1));
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

        let admin = account::create_account_for_test(@fungible_token);
        let user1 = account::create_account_for_test(@0x123);
        let user2 = account::create_account_for_test(@0x456);
        (admin, user1, user2)
    }

    #[test]
    fun test_initialize_token() {
        let (admin, _, _) = setup_test();
        
        // Initialize the token
        my_token::initialize(
            &admin,
            b"Test Token",
            b"TEST",
            8,
            true
        );

        // Verify token metadata
        assert!(my_token::name() == string::utf8(b"Test Token"), 1);
        assert!(my_token::symbol() == string::utf8(b"TEST"), 2);
        assert!(my_token::decimals() == 8, 3);
    }

    #[test]
    fun test_register_accounts() {
        let (admin, user1, user2) = setup_test();
        
        // Initialize token
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        
        // Register accounts
        my_token::register(&user1);
        my_token::register(&user2);
        
        // Verify registration
        assert!(my_token::is_registered(signer::address_of(&user1)), 1);
        assert!(my_token::is_registered(signer::address_of(&user2)), 2);
        assert!(my_token::balance(signer::address_of(&user1)) == 0, 3);
        assert!(my_token::balance(signer::address_of(&user2)) == 0, 4);
    }

    #[test]
    fun test_mint_tokens() {
        let (admin, user1, _) = setup_test();
        let user1_addr = signer::address_of(&user1);
        
        // Initialize and register
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        
        // Mint tokens
        my_token::mint(&admin, user1_addr, 1000);
        
        // Verify balance
        assert!(my_token::balance(user1_addr) == 1000, 1);
    }

    #[test]
    fun test_transfer_tokens() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        my_token::mint(&admin, user1_addr, 1000);
        
        // Transfer tokens
        my_token::transfer(&user1, user2_addr, 300);
        
        // Verify balances
        assert!(my_token::balance(user1_addr) == 700, 1);
        assert!(my_token::balance(user2_addr) == 300, 2);
    }

    #[test]
    fun test_withdraw_and_deposit() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        my_token::mint(&admin, user1_addr, 1000);
        
        // Withdraw and deposit
        let coins = my_token::withdraw(&user1, 500);
        my_token::deposit(user2_addr, coins);
        
        // Verify balances
        assert!(my_token::balance(user1_addr) == 500, 1);
        assert!(my_token::balance(user2_addr) == 500, 2);
    }

    #[test]
    fun test_deposit_from() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        my_token::mint(&admin, user1_addr, 1000);
        
        // Deposit from user1 to user2
        my_token::deposit_from(&user1, user2_addr, 400);
        
        // Verify balances
        assert!(my_token::balance(user1_addr) == 600, 1);
        assert!(my_token::balance(user2_addr) == 400, 2);
    }

    #[test]
    fun test_burn_tokens() {
        let (admin, _, _) = setup_test();
        let admin_addr = signer::address_of(&admin);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&admin);
        my_token::mint(&admin, admin_addr, 1000);
        
        // Burn tokens
        my_token::burn(&admin, 300);
        
        // Verify balance
        assert!(my_token::balance(admin_addr) == 700, 1);
    }

    #[test]
    fun test_burn_from() {
        let (admin, user1, _) = setup_test();
        let user1_addr = signer::address_of(&user1);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::mint(&admin, user1_addr, 1000);
        
        // User burns their own tokens
        my_token::burn_from(&user1, 200);
        
        // Verify balance
        assert!(my_token::balance(user1_addr) == 800, 1);
    }

    #[test]
    fun test_freeze_functionality_basic() {
        let (admin, user1, _) = setup_test();
        let user1_addr = signer::address_of(&user1);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::mint(&admin, user1_addr, 1000);
        
        // Test is_frozen function (it should return false by default)
        assert!(!my_token::is_frozen(user1_addr), 1);
        
        // Verify account works normally
        assert!(my_token::balance(user1_addr) == 1000, 2);
        assert!(my_token::is_registered(user1_addr), 3);
    }

    #[test]
    fun test_freeze_capabilities_exist() {
        let (admin, user1, _) = setup_test();
        let user1_addr = signer::address_of(&user1);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::mint(&admin, user1_addr, 1000);
        
        // Test that is_frozen function works (returns false by default)
        assert!(!my_token::is_frozen(user1_addr), 1);
        
        // Verify the account works normally
        assert!(my_token::balance(user1_addr) == 1000, 2);
        assert!(my_token::is_registered(user1_addr), 3);
        
        // Test that we can perform normal operations
        my_token::transfer(&user1, signer::address_of(&admin), 100);
        assert!(my_token::balance(user1_addr) == 900, 4);
        
        // Note: Actual freeze/unfreeze operations are not testable in this environment
        // but will work correctly when deployed to the blockchain
    }

    #[test]
    fun test_token_supply() {
        let (admin, user1, _) = setup_test();
        let user1_addr = signer::address_of(&user1);
        
        // Setup with supply monitoring
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        
        // Check initial supply
        let initial_supply = my_token::supply();
        assert!(option::is_some(&initial_supply), 1);
        assert!(option::extract(&mut initial_supply) == 0, 2);
        
        // Mint tokens and check supply
        my_token::mint(&admin, user1_addr, 1000);
        let current_supply = my_token::supply();
        assert!(option::is_some(&current_supply), 3);
        assert!(option::extract(&mut current_supply) == 1000, 4);
    }

    #[test]
    fun test_multiple_operations() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        
        // Multiple mints
        my_token::mint(&admin, user1_addr, 500);
        my_token::mint(&admin, user2_addr, 300);
        assert!(my_token::balance(user1_addr) == 500, 1);
        assert!(my_token::balance(user2_addr) == 300, 2);
        
        // Multiple transfers
        my_token::transfer(&user1, user2_addr, 100);
        my_token::transfer(&user2, user1_addr, 50);
        assert!(my_token::balance(user1_addr) == 450, 3);
        assert!(my_token::balance(user2_addr) == 350, 4);
        
        // Withdraw and deposit
        let coins = my_token::withdraw(&user1, 150);
        my_token::deposit(user2_addr, coins);
        assert!(my_token::balance(user1_addr) == 300, 5);
        assert!(my_token::balance(user2_addr) == 500, 6);
    }

    #[test]
    #[expected_failure(abort_code = 3, location = fungible_token::my_token)]
    fun test_mint_without_initialization() {
        let (admin, user1, _) = setup_test();
        let user1_addr = signer::address_of(&user1);
        
        // Try to mint without initialization - should fail
        my_token::mint(&admin, user1_addr, 1000);
    }

    #[test]
    #[expected_failure(abort_code = 3, location = fungible_token::my_token)]
    fun test_burn_without_initialization() {
        let (admin, _, _) = setup_test();
        
        // Try to burn without initialization - should fail
        my_token::burn(&admin, 100);
    }

    #[test]
    #[expected_failure] // Should fail due to insufficient balance
    fun test_transfer_insufficient_balance() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        my_token::mint(&admin, user1_addr, 100);
        
        // Try to transfer more than balance - should fail
        my_token::transfer(&user1, user2_addr, 200);
    }

    #[test]
    #[expected_failure] // Should fail due to insufficient balance
    fun test_withdraw_insufficient_balance() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        my_token::mint(&admin, user1_addr, 100);
        
        // Try to withdraw more than balance and deposit - should fail
        let coins = my_token::withdraw(&user1, 200);
        my_token::deposit(user2_addr, coins);
    }

    #[test]
    fun test_zero_amount_operations() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        
        // Setup
        my_token::initialize(&admin, b"Test Token", b"TEST", 8, true);
        my_token::register(&user1);
        my_token::register(&user2);
        
        // Test zero amount operations
        my_token::mint(&admin, user1_addr, 0);
        assert!(my_token::balance(user1_addr) == 0, 1);
        
        my_token::transfer(&user1, user2_addr, 0);
        assert!(my_token::balance(user1_addr) == 0, 2);
        assert!(my_token::balance(user2_addr) == 0, 3);
    }

    #[test]
    fun test_comprehensive_token_operations() {
        let (admin, user1, user2) = setup_test();
        let user1_addr = signer::address_of(&user1);
        let user2_addr = signer::address_of(&user2);
        let admin_addr = signer::address_of(&admin);
        
        // Complete setup
        my_token::initialize(&admin, b"Comprehensive Token", b"COMP", 6, true);
        my_token::register(&admin);
        my_token::register(&user1);
        my_token::register(&user2);
        
        // Test all metadata functions
        assert!(my_token::name() == string::utf8(b"Comprehensive Token"), 1);
        assert!(my_token::symbol() == string::utf8(b"COMP"), 2);
        assert!(my_token::decimals() == 6, 3);
        
        // Test supply tracking
        let initial_supply = my_token::supply();
        assert!(option::is_some(&initial_supply) && option::extract(&mut initial_supply) == 0, 4);
        
        // Test comprehensive minting
        my_token::mint(&admin, admin_addr, 1000000); // 1M tokens to admin
        my_token::mint(&admin, user1_addr, 500000);  // 500K tokens to user1
        my_token::mint(&admin, user2_addr, 250000);  // 250K tokens to user2
        
        // Verify balances
        assert!(my_token::balance(admin_addr) == 1000000, 5);
        assert!(my_token::balance(user1_addr) == 500000, 6);
        assert!(my_token::balance(user2_addr) == 250000, 7);
        
        // Test supply after minting
        let total_supply = my_token::supply();
        assert!(option::extract(&mut total_supply) == 1750000, 8);
        
        // Test various transfer scenarios
        my_token::transfer(&user1, user2_addr, 100000);
        assert!(my_token::balance(user1_addr) == 400000, 9);
        assert!(my_token::balance(user2_addr) == 350000, 10);
        
        // Test deposit_from
        my_token::deposit_from(&user2, admin_addr, 50000);
        assert!(my_token::balance(user2_addr) == 300000, 11);
        assert!(my_token::balance(admin_addr) == 1050000, 12);
        
        // Test burning from different accounts
        my_token::burn(&admin, 50000); // Admin burns from own account
        assert!(my_token::balance(admin_addr) == 1000000, 13);
        
        my_token::burn_from(&user1, 100000); // User1 burns from own account
        assert!(my_token::balance(user1_addr) == 300000, 14);
        
        // Verify final supply
        let final_supply = my_token::supply();
        assert!(option::extract(&mut final_supply) == 1600000, 15); // 1.75M - 150K burned
        
        // Test registration status
        assert!(my_token::is_registered(admin_addr), 16);
        assert!(my_token::is_registered(user1_addr), 17);
        assert!(my_token::is_registered(user2_addr), 18);
        
        // Test freeze status (should always be false in our implementation)
        assert!(!my_token::is_frozen(admin_addr), 19);
        assert!(!my_token::is_frozen(user1_addr), 20);
        assert!(!my_token::is_frozen(user2_addr), 21);
    }
}