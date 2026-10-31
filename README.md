# Tokenizer

For Token I choosed my name, nickname and school 42 abbreviature.

```
AidarFteganChain42
```

*We must respect the ERC20 for ETH (or BEP-20 for BSC)*

## ERC20
### Mandatory Functions

A smart contract must implement six core functions to be a valid ERC-20 token:
• totalSupply: Returns the total number of tokens that exist.
• balanceOf: Returns the token balance of a specific wallet address. <br>
• transfer: Sends a given amount of tokens directly from the caller's address to a recipient.<br>
• transferFrom: Moves a given amount of tokens from a sender's address to a recipient using an allowance.
• approve: Authorizes a third-party address (like a smart contract or exchange) to spend up to a specific number of tokens on the owner's behalf.
• allowance: Returns the remaining number of tokens an approved spender is allowed to use.

### Optional Functions

• name: The full name of the token (e.g., Tether USD).
• symbol: The short ticker symbol (e.g., USDT).
• decimals: The decimal precision of the token (commonly set to 18, matching Ether).

### 
Required Events

The standard requires two events to be emitted during actions so external apps and block explorers can track activity:
• Transfer: Logged whenever tokens move from one address to another.
• Approval: Logged whenever an allowance is set via approve.


Test Token deployed:

```https://sepolia.etherscan.io/token/0x970B8D7885E0B587E8373Ed114ab8EB762905B7e```