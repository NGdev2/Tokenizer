# Theory
**Blockchain** is a distributed ledger technology (DLT).

A ledger is essentially a record of transactions and changes in state.

A **smart contract** is a program deployed on a blockchain. It defines rules and operations that the blockchain executes when the contract is called.

**OpenZeppelin** is a company and publisher of open-source smart contracts.

I use **OpenZeppelin** Contracts, a library of audited smart contracts. It implements code of the standard ERC-20 exactly thanks to their provided standard functions. 

**Sepolia** is an Ethereum testnet: a separate blockchain that works like Ethereum mainnet, but its ETH has no value. Developers use it to test contracts before deploying them to mainnet. It is run by a limited set of validators (mostly Ethereum client and testing teams), so test ETH can't be earned by users; you get it for free from faucets. Faucets limit how much you can take (for example once per day) to stop bots from draining them.

_mint in the constructor initializes the whole supply once. It calls _update, which raises totalSupply from 0 to TOTAL_SUPPLY( my constant) and emits Transfer to raise the balance owner from zero to all tokens.  There is no mint function after deployment, so no more tokens can ever be created after.

The burn function destroys tokens of your wallet and the _totalSupply. So you don't just decline ownership of tokens, you make the tokens lost forever (in code you literally transfer them to the zero address, kind of the black hole of all numbers). Burn can be used to make other tokens more valuable.

Using @title, @notice, @dev is not required, but it provides metadata for the contract. Useful for having self explaining contract documentation.
It works by NatSpec (Ethereum Natural Language Specification).

- @title is visible to everyone and provides the name of the contract.
- @notice is for users. 
- @dev is for developers. Explains how the contract works.
- @param describes a function's input, @return describes what it returns. Both are for users and devs.<br>
Documentation will be visible in Etherscan after the contract is verified.

Hardhat is a development toolbox that compiles the contract, runs tests, connects to the blockchain and deploys it to networks like Sepolia. 

Ignition is Hardhat's deployment plugin that is responsible for deploying the contract and controls the deploy runs and checks of deploying/redeploying.



## Deployment
Creating and launching the contract, Ignition gets id for contract (***Ethereum Sepolia testnet*** id is 11155111), and the folder with this chain id will be created automatically in the folder `deployment/deployments/<deployment id>/`
By default the deployment id is chain-<chain id> (so chain-11155111); with --deployment-id final-v1 the folder is deployment/deployments/final-v1/.


Inside we will have ***deployed_addresses.json*** that contains the contract address. Example: `0x88a1EB33b6D6b80fc6A15E534b3f37147AF06Af0` 
and by it we can get the full address of our token in Etherscan by adding the contract address to:
`https://sepolia.etherscan.io/address/`

- Network: Ethereum Sepolia testnet (chain id 11155111)
- Contract address: `0x88a1EB33b6D6b80fc6A15E534b3f37147AF06Af0`
- Etherscan: https://sepolia.etherscan.io/address/0x88a1EB33b6D6b80fc6A15E534b3f37147AF06Af0


## Functions used
- Ownable2Step -  ownership of the contract (the owner role, not the tokens) must be accepted by the new owner. Transferring ownership can't be given by mistake to a wrong  address.
- burn() - destroys your own tokens. I don't use burnFrom(): it lets an approved spender burn tokens from another wallet, using the same allowance as transferFrom. This token has no use case for it, so I keep the contract smaller
- getOwner() -  


## Additional information
- Redeploying the contract with the same name is possible. contract is identified by its **address**, not its name.
- To deploy after changing the contract, we need to add a new deployment ID.
```npx hardhat ignition deploy deployment/modules/AidarFteganChain42.js --network sepolia --deployment-id final-v1```

"*purpose of the standard is having the minimum functionalities we can all agree so that tokens can be stored and transferred in a wallet. Any other functionality can be solved by creating further functions and implementing a Ðapp to manage them.*" - **Alex van de Sande**, in the r/ethereum discussion ["Let's talk about the coin standard"](https://www.reddit.com/r/ethereum/comments/3n8fkn/lets_talk_about_the_coin_standard).

A node is a computer running blockchain software and participating in the network.
types of nodes:
- Full node - Downloads and independently verifies blockchain data and execution
- Archive node - Maintains historical blockchain states
- Validator - Participates in the consensus mechanism
- Light client - Verifies selected information without maintaining the entire blockchain

Ethereum uses Proof of Stake (PoS).
Validator nodes - they verify and validate operations. They can receive rewards for their participation and get penalties for violations.


SPDX stands for Software Package Data Exchange.<br>
The identifier tells which license applies to the source code.

Some common examples:
- MIT — permissive open-source license.
- GPL-3.0 — copyleft license.
- Apache-2.0 — permissive license with explicit patent provisions.
- UNLICENSED — indicates that the source code is not being released under an open-source license.
It doesn't change the execution of smart contract.

Block - Group of transactions and associated blockchain data
Token - Digital asset managed by a smart contract

4242 tokens are multiplied by 10 ** 18 because ERC-20 uses integer arithmetic. It doesn't directly store decimal numbers.

A block is essentially a container holding:
- A collection of transactions.
- A reference to the previous block.
- A timestamp and other metadata.
- Cryptographic information used by the network.

## Resources
- https://docs.openzeppelin.com/contracts/5.x/erc20
- https://eips.ethereum.org/EIPS/eip-20
- https://www.thebitcoinpaper.org/white-paper/
- https://www.reddit.com/r/ethereum/comments/3n8fkn/lets_talk_about_the_coin_standard
- https://etherscan.io/
