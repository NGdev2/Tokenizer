# Tokenizer

For the token name I chose my name, nickname and the School 42 abbreviation.

```
AidarFteganChain42
```

*We must respect the ERC20 for ETH (or BEP-20 for BSC)*

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

## Deployment

- Network: Ethereum Sepolia testnet (chain id 11155111)
- Contract address: `0x970B8D7885E0B587E8373Ed114ab8EB762905B7e`
- Etherscan: https://sepolia.etherscan.io/token/0x970B8D7885E0B587E8373Ed114ab8EB762905B7e

> [!IMPORTANT]
> This address is a test deployment of an earlier version (AidarFteganChain42Test, 1,000 tokens, Solidity 0.8.28). The final version will be deployed and its address added here.

> [!NOTE]
> <sub>**Faucet** - a website that sends free test ETH to your wallet so you can pay gas on a testnet. Faucets limit how much you get (for example once a day, or only if your address holds a little real ETH on mainnet) to stop bots from draining them. Example: Google Cloud Web3 faucet for Sepolia.</sub>

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

The deployer's private key and the Etherscan API key are never written in the project files. Store them in the encrypted Hardhat keystore (asks for a password):

```bash
npx hardhat keystore set SEPOLIA_PRIVATE_KEY
npx hardhat keystore set ETHERSCAN_API_KEY
```

or put them in `.env` (ignored by git) and load it into the terminal before running Hardhat:

```bash
set -a && source .env && set +a
```

### Deploy to Sepolia

```bash
npx hardhat ignition deploy deployment/modules/AidarFteganChain42.js --network sepolia --deployment-id <id>
```

`--deployment-id` names the deployment and its folder in `deployment/deployments/<id>/`. Running the same id again continues that deployment; a changed contract needs a new id.

```bash
npx hardhat ignition deployments          # list all deployment ids
npx hardhat ignition status <id>          # show the deployed contract address
npx hardhat ignition verify <id>          # verify the source code on Etherscan
```

### Use the deployed token from the terminal

```bash
npx hardhat console --network sepolia
```

Inside the console (replace the `0x...` addresses):

```js
const { ethers } = await network.getOrCreate();
const [me] = await ethers.getSigners();
const token = await ethers.getContractAt("AidarFteganChain42", "0x...TOKEN_ADDRESS");

await token.name();
ethers.formatUnits(await token.totalSupply(), 18);
ethers.formatUnits(await token.balanceOf(me.address), 18);

// send 10 tokens
const tx1 = await token.transfer("0x...RECIPIENT", ethers.parseUnits("10", 18));
await tx1.wait();

// destroy 1 of my tokens
const tx2 = await token.burn(ethers.parseUnits("1", 18));
await tx2.wait();

// send 0.01 Sepolia ETH (not the token)
const tx3 = await me.sendTransaction({ to: "0x...RECIPIENT", value: ethers.parseEther("0.01") });
await tx3.wait();

.exit
```

## ERC-20 standard

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
