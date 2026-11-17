# Tokenizer

For the token name I chose my name, nickname and the School 42 abbreviation.

```
AidarFteganChain42
```

*We must respect the ERC20 for ETH (or BEP-20 for BSC)*

## ERC20
### Mandatory Functions

A smart contract must implement six core functions to be a valid ERC-20 token:
- totalSupply: Returns the total amount of existing tokens (it decreases when tokens are burned).
- balanceOf: Returns the token balance of a specific address (a wallet or a contract).
- transfer: Sends a given amount of tokens directly from the caller's address to a recipient.
- transferFrom: Moves a given amount of tokens from a sender's address to a recipient using an allowance.
- approve: Authorizes a third-party address (like a smart contract or exchange) to spend up to a specific number of tokens on the owner's behalf.
- allowance: Returns the remaining number of tokens an approved spender is allowed to use.
- Ownable - stores one address - address of the owner in the contract (can be returned by owner()). transferOwnership(newAddr) moves the role immediately, so if newAddr is wrong (a typo, or an address nobody controls), the ownership and any admin rights that come with it are lost forever.
- Ownable2Step - stores address of the owner, same as Ownable but can't be lost by sending to incorrect address, because there is the 2 step. TransferOwnership(newAddr) only saves newAddr as pendingOwner, and ownership moves only when newAddr itself calls acceptOwnership(). A wrong address can never accept, so the current owner keeps the role.

View functions only read data (totalSupply, balanceOf, allowance. Calling them from outside, for example from a wallet or Etherscan, is free because no transaction is sent. When another contract calls them inside a transaction, they still cost gas.

### Optional Functions

- name: The full name of the token (e.g., Tether USD).
- symbol: The short ticker symbol (e.g., USDT).
- decimals: The decimal precision of the token (commonly set to 18, matching Ether).

### Required Events

The standard requires two events to be emitted during actions so external apps and block explorers can track activity:
- Transfer: Logged whenever tokens move from one address to another.
- Approval: Logged whenever an allowance is set via approve.


Test token deployed:

https://sepolia.etherscan.io/token/0x970B8D7885E0B587E8373Ed114ab8EB762905B7e