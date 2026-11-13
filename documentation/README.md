# Installation Process
**OpenZeppelin** is a company and publisher of open-source smart contracts.

Using **OpenZeppelin** as auditing tool that helps to have standard ERC-20 code thanks to their provided standard functions. 

Sepolia is a 


_mint in the constructor initializes the wallet and, using _update, changes the value from 0 to TOTAL_SUPPLY - my constant. It can be any value. It regulates the total amount of tokens for this contract.

The burn function destroys tokens of your wallet and the TOTAL_SUPPLY. So you don't just decline ownership of tokens, you make the tokens lost forever (in code you literally transfer them to the zero address, kind of the black hole of all numbers). Burn can be used to make other tokens more valuable.

Using @title, @notice, @dev is not required, but it provides metadata for the contract. Useful for having self explaining contract documentation.
It works by NatSpec (Ethereum Natural Language Specification).

- @title is visible to everyone and provides the name of the contract.
- @notice is for users. 
- @dev is for developers. Explains how the contract works.
- @param / @return for users and devs. Describes each logical point of the contract.<br>
Documentation will be visible in Etherscan.

Hardhat is a development toolbox that compiles the contract, runs tests, connects to the blockchain and deploys it to networks like Sepolia. 

Ignition is Hardhat's deployment plugin that is responsible for deploying the contract and controls the deploy runs and checks of deploying/redeploying.

...



## Deployment
Creating and launching the contract, we will get the chain id for ***Ethereum Sepolia testnet***, and the folder with this chain id will be created automatically in the folder `deployment/deployments/...`

Inside we will have ***deployed_addresses.json*** that contains the contract address. Example after test run: `0x970B8D7885E0B587E8373Ed114ab8EB762905B7e` 
and by it we can get the full address of our token in Etherscan by adding the contract address to:
`https://sepolia.etherscan.io/address/`

- Network: Ethereum Sepolia testnet (chain id 11155111)
- Contract address: `0x970B8D7885E0B587E8373Ed114ab8EB762905B7e`
- Etherscan: https://sepolia.etherscan.io/address/0x970B8D7885E0B587E8373Ed114ab8EB762905B7e


## Functions used
- Ownable2Step - ownership must be accepted. Transferring ownership of * can't be given by mistake to a nonexistent address.
- burn() - destroy your own tokens. for security reasons I don't use burnFrom() that can destroy tokens from wallet of another person.
- getOwner() -  


...

## Additional information
- Redeploying the contract with the same name is possible. contract is identified by its **address**, not its name.
- To deploy after changing the contract, we need to add a new deployment ID.
```npx hardhat ignition deploy deployment/modules/AidarFteganChain42Test.js --network sepolia --deployment-id final-v1```

"*purpose of the standard is having the minimum functionalities we can all agree so that tokens can be stored and transferred in a wallet. Any other functionality can be solved by creating further functions and implementing a Ðapp to manage them.*" - **Alex van de Sande** in ethereum group in reddit in the topic with the coin standard proposal.


## Resources
- https://docs.openzeppelin.com/contracts/5.x/erc20
- https://eips.ethereum.org/EIPS/eip-20
- 