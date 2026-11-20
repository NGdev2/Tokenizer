# AidarFteganChain42 - my ERC-20 token on Ethereum

I built this project to learn how a smart contract goes from code to a public network: writing it, testing it, deploying it and publishing its verified source code. I chose an ERC-20 token because it is the most widely used contract standard, so everything I learned applies to real projects.

## What I learned

- **Blockchain basics.** How blockchains, blocks and nodes work, what a smart contract is, and how to build on OpenZeppelin's audited contracts instead of writing everything from scratch.
- **Setting up a toolchain.** Hardhat 3 needs Node.js 22, my system had Node 18. I installed nvm to switch versions instead of fighting install errors. I also learned not to run `npm audit fix --force` blindly: it downgraded my framework to an old major version and brought more vulnerabilities, not fewer.
- **Testing before deploying.** I wrote 17 automated tests: normal use, actions that must fail (overspending, sending to the zero address, a stranger taking ownership) and the events other apps rely on. A deployed contract can't be changed, so tests are the only safety net.
- **Deployment as code.** The deployment is a script (Hardhat Ignition module), and every deployment is recorded in the repository with its address and transactions, so it is reproducible and traceable.
- **Verifying the contract.** I verified the source code on Etherscan and Blockscout.
- **Working with networks.** Testnet vs mainnet, RPC endpoints, chain ids, and paying transaction fees (gas) with test ETH from a faucet.

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

My token follows the ERC-20 standard. It also has `getOwner()`, so the same code works as a BEP-20 token on BNB Smart Chain.

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
- Contract address: `0x3D28630D5E38f7F3da4783A8867f12121777D9c6`
- Etherscan: https://sepolia.etherscan.io/address/0x3D28630D5E38f7F3da4783A8867f12121777D9c6

> <sub>**Faucet** - a website that gives free test ETH to pay gas on Sepolia. Faucets limit how much you get (for example once a day, or only if your address holds a little real ETH on mainnet) to stop bots from draining them. Example: Google Cloud Web3 faucet.</sub>

## Design choices

- Ownable - stores one address - address of the owner in the contract (can be returned by owner()). transferOwnership(newAddr) moves the role immediately, so if newAddr is wrong (a typo, or an address nobody controls), the ownership and any admin rights that come with it are lost forever.
- Ownable2Step - stores address of the owner, same as Ownable but can't be lost by sending to incorrect address, because there is the 2 step. TransferOwnership(newAddr) only saves newAddr as pendingOwner, and ownership moves only when newAddr itself calls acceptOwnership(). A wrong address can never accept, so the current owner keeps the role.

## Project structure

```
code/               the token contract (AidarFteganChain42.sol)
test/               17 Solidity tests (details in documentation/)
deployment/         Ignition deploy module (modules/) and deployment records (deployments/)
documentation/      theory and notes on the concepts used
examples/           early OpenZeppelin ERC20 (2018), kept for learning, not compiled
hardhat.config.js   compiler version, folders, Sepolia network, Etherscan verification
env.example         names of the secrets the project needs (values go in .env)
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

`--deployment-id` names the deployment and its folder in `deployment/deployments/<id>/`. Running the same id again continues that deployment, so after changing the contract I use a new id. My final deployment is `v2`.

```bash
npx hardhat ignition deployments          # list all deployment ids
npx hardhat ignition status <id>          # show the deployed contract address
npx hardhat ignition verify <id> --network sepolia   # verify the source code on Etherscan
```
