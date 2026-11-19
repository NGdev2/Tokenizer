# Tokenizer

For the token name I chose my name, nickname and the School 42 abbreviation.

```
AidarFteganChain42
```

## Overview

| | |
|---|---|
| Name | AidarFteganChain42 |
| Symbol | AFC42 |
| Standard | ERC-20 |
| Decimals | 18 |
| Total supply | 4,242 tokens, fixed (minted once at deployment) |
| Network | Ethereum Sepolia testnet (chain id 11155111) |
| Compiler | Solidity 0.8.20 |
| Library | OpenZeppelin Contracts 5.6.1 (ERC20, Ownable2Step) |

## ERC-20 standard

*We must respect the ERC20 for ETH (or BEP-20 for BSC)*

### Mandatory Functions

A smart contract must implement six core functions to be a valid ERC-20 token:
- totalSupply(): Returns the total amount of existing tokens (it decreases when tokens are burned).
- balanceOf(address): Returns the token balance of a specific address (a wallet or a contract).
- transfer(address, value): Sends a given amount of tokens directly from the caller's address to a recipient.
- transferFrom(from, to, value): Moves a given amount of tokens from a sender's address to a recipient using an allowance.
- approve(address, value): Authorizes a third-party address (like a smart contract or exchange) to spend up to a specific number of tokens on the owner's behalf.
- allowance(owner, spender): Returns the remaining number of tokens an approved spender is allowed to use.

View functions only read data (totalSupply, balanceOf, allowance). Calling them from outside, for example from a wallet or Etherscan, is free because no transaction is sent. When another contract calls them inside a transaction, they still cost gas.

### Optional Functions

- name: The full name of the token (e.g., Tether USD).
- symbol: The short ticker symbol (e.g., USDT).
- decimals: The decimal precision of the token (commonly set to 18, matching Ether).

### Required Events

The standard requires two events to be emitted during actions so external apps and block explorers can track activity:
- Transfer: Logged whenever tokens move from one address to another.
- Approval: Logged whenever an allowance is set via approve.

## Deployment

- Network: Ethereum Sepolia testnet (chain id 11155111)
- Contract address: `0x88a1EB33b6D6b80fc6A15E534b3f37147AF06Af0`
- Etherscan: https://sepolia.etherscan.io/address/0x88a1EB33b6D6b80fc6A15E534b3f37147AF06Af0

> <sub>**Faucet** - a website that gives free test ETH to pay gas on Sepolia. Faucets limit how much you get (for example once a day, or only if your address holds a little real ETH on mainnet) to stop bots from draining them. Example: Google Cloud Web3 faucet.</sub>

## Design choices

- Ownable - stores one address - address of the owner in the contract (can be returned by owner()). transferOwnership(newAddr) moves the role immediately, so if newAddr is wrong (a typo, or an address nobody controls), the ownership and any admin rights that come with it are lost forever.
- Ownable2Step - stores address of the owner, same as Ownable but can't be lost by sending to incorrect address, because there is the 2 step. TransferOwnership(newAddr) only saves newAddr as pendingOwner, and ownership moves only when newAddr itself calls acceptOwnership(). A wrong address can never accept, so the current owner keeps the role.

## Project structure

```
code/               the token contract (AidarFteganChain42.sol)
test/               Solidity tests
deployment/         Ignition deploy module (modules/) and deployment records (deployments/)
documentation/      theory and notes on the concepts used
examples/           old OpenZeppelin ERC20 (Solidity 0.4.24), for study only, not compiled
hardhat.config.js   compiler version, folders, Sepolia network, Etherscan verification
```

## How to run

Requires Node.js 22.13 or later.

### Install, build, test

```bash
npm install          # Hardhat, OpenZeppelin and plugins
npx hardhat build    # compile the contract in code/
npx hardhat test     # run the tests in test/
```

### Secrets

My private key and Etherscan API key are never written in the project files. I store them in the encrypted Hardhat keystore (it asks for a password):

```bash
npx hardhat keystore set SEPOLIA_PRIVATE_KEY
npx hardhat keystore set ETHERSCAN_API_KEY
```

or load `.env`:

```bash
set -a && source .env && set +a
```

### Deploy to Sepolia

```bash
npx hardhat ignition deploy deployment/modules/AidarFteganChain42.js --network sepolia --deployment-id <id>
```

`--deployment-id` names the deployment and its folder in `deployment/deployments/<id>/`. Running the same id again continues that deployment, so after changing the contract I use a new id. My final deployment is `final-v1`.

```bash
npx hardhat ignition deployments          # list all deployment ids
npx hardhat ignition status <id>          # show the deployed contract address
npx hardhat ignition verify <id> --network sepolia   # verify the source code on Etherscan
```
