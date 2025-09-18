
<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token"></a>

# Module `0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894::my_token`



-  [Resource `MyToken`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_MyToken)
-  [Resource `TokenCapabilities`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_TokenCapabilities)
-  [Constants](#@Constants_0)
-  [Function `initialize`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_initialize)
-  [Function `mint`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_mint)
-  [Function `burn`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_burn)
-  [Function `burn_from`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_burn_from)
-  [Function `transfer`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_transfer)
-  [Function `deposit`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_deposit)
-  [Function `deposit_from`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_deposit_from)
-  [Function `withdraw`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_withdraw)
-  [Function `register`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_register)
-  [Function `balance`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_balance)
-  [Function `supply`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_supply)
-  [Function `name`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_name)
-  [Function `symbol`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_symbol)
-  [Function `decimals`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_decimals)
-  [Function `is_registered`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_is_registered)
-  [Function `freeze_account`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_freeze_account)
-  [Function `unfreeze_account`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_unfreeze_account)
-  [Function `is_frozen`](#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_is_frozen)


<pre><code><b>use</b> <a href="">0x1::coin</a>;
<b>use</b> <a href="">0x1::option</a>;
<b>use</b> <a href="">0x1::signer</a>;
<b>use</b> <a href="">0x1::string</a>;
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_MyToken"></a>

## Resource `MyToken`

Token information struct


<pre><code><b>struct</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_MyToken">MyToken</a> <b>has</b> key
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_TokenCapabilities"></a>

## Resource `TokenCapabilities`

Capabilities struct to store mint and burn capabilities


<pre><code><b>struct</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_TokenCapabilities">TokenCapabilities</a> <b>has</b> key
</code></pre>



<a id="@Constants_0"></a>

## Constants


<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_E_INSUFFICIENT_BALANCE"></a>



<pre><code><b>const</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_E_INSUFFICIENT_BALANCE">E_INSUFFICIENT_BALANCE</a>: u64 = 2;
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_E_NOT_ADMIN"></a>

Error codes


<pre><code><b>const</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_E_NOT_ADMIN">E_NOT_ADMIN</a>: u64 = 1;
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_E_NOT_INITIALIZED"></a>



<pre><code><b>const</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_E_NOT_INITIALIZED">E_NOT_INITIALIZED</a>: u64 = 3;
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_initialize"></a>

## Function `initialize`

Initialize the token (should be called by the module publisher)


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_initialize">initialize</a>(admin: &<a href="">signer</a>, name: <a href="">vector</a>&lt;u8&gt;, symbol: <a href="">vector</a>&lt;u8&gt;, decimals: u8, monitor_supply: bool)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_mint"></a>

## Function `mint`

Mint new tokens (only admin can call this)


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_mint">mint</a>(admin: &<a href="">signer</a>, <b>to</b>: <b>address</b>, amount: u64)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_burn"></a>

## Function `burn`

Burn tokens from admin's account


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_burn">burn</a>(admin: &<a href="">signer</a>, amount: u64)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_burn_from"></a>

## Function `burn_from`

Burn tokens from a specific account (requires the account owner's signature)


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_burn_from">burn_from</a>(account_owner: &<a href="">signer</a>, amount: u64)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_transfer"></a>

## Function `transfer`

Transfer tokens from one account to another


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_transfer">transfer</a>(from: &<a href="">signer</a>, <b>to</b>: <b>address</b>, amount: u64)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_deposit"></a>

## Function `deposit`

Deposit tokens to an account (internal function, not entry)


<pre><code><b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_deposit">deposit</a>(<b>to</b>: <b>address</b>, coins: <a href="_Coin">coin::Coin</a>&lt;<a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_MyToken">my_token::MyToken</a>&gt;)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_deposit_from"></a>

## Function `deposit_from`

Deposit tokens from one account to another (entry function)


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_deposit_from">deposit_from</a>(from: &<a href="">signer</a>, <b>to</b>: <b>address</b>, amount: u64)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_withdraw"></a>

## Function `withdraw`

Withdraw tokens from an account


<pre><code><b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_withdraw">withdraw</a>(<a href="">account</a>: &<a href="">signer</a>, amount: u64): <a href="_Coin">coin::Coin</a>&lt;<a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_MyToken">my_token::MyToken</a>&gt;
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_register"></a>

## Function `register`

Register an account to hold the token


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_register">register</a>(<a href="">account</a>: &<a href="">signer</a>)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_balance"></a>

## Function `balance`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_balance">balance</a>(<a href="">account</a>: <b>address</b>): u64
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_supply"></a>

## Function `supply`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_supply">supply</a>(): <a href="_Option">option::Option</a>&lt;u128&gt;
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_name"></a>

## Function `name`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_name">name</a>(): <a href="_String">string::String</a>
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_symbol"></a>

## Function `symbol`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_symbol">symbol</a>(): <a href="_String">string::String</a>
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_decimals"></a>

## Function `decimals`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_decimals">decimals</a>(): u8
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_is_registered"></a>

## Function `is_registered`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_is_registered">is_registered</a>(<a href="">account</a>: <b>address</b>): bool
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_freeze_account"></a>

## Function `freeze_account`

Freeze an account (only admin)


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_freeze_account">freeze_account</a>(admin: &<a href="">signer</a>, <a href="">account</a>: <b>address</b>)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_unfreeze_account"></a>

## Function `unfreeze_account`

Unfreeze an account (only admin)


<pre><code><b>public</b> entry <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_unfreeze_account">unfreeze_account</a>(admin: &<a href="">signer</a>, <a href="">account</a>: <b>address</b>)
</code></pre>



<a id="0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_is_frozen"></a>

## Function `is_frozen`



<pre><code>#[view]
<b>public</b> <b>fun</b> <a href="fungible_token.md#0xdffbb0f2a817c9e3ed7ec6670b24f4a4abc588b694082fd2be6e3fc0ea0ad894_my_token_is_frozen">is_frozen</a>(_account: <b>address</b>): bool
</code></pre>
