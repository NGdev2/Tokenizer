// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Ownable2Step} from "@openzeppelin/contracts/access/Ownable2Step.sol";

/**
 * @title AidarFteganChain42
 * @author NGdev2
 * @notice ERC-20 token for the 42 School "Tokenizer" project, deployed on Ethereum Sepolia Testnet.
 * @dev The supply is fixed: it is minted once in the constructor and no mint function
 *      exists, so no address can ever create another token. There is no onlyOwner
 *      function either - the owner role only labels the issuer, exposed through owner()
 *      and the BEP-20 style getOwner(), so the same code also works as a BEP-20 on BSC.
 */
contract AidarFteganChain42 is ERC20, Ownable2Step {
    /// @notice The complete supply, minted once at deployment: 4,242 tokens.
    /// @dev A constant is inlined into the bytecode, so this number can never change.
    uint256 public constant TOTAL_SUPPLY = 4_242 * 10 ** 18;

    /// @param initialOwner Receives the whole supply and the owner role. Explicit rather
    ///        than msg.sender, so the key paying for the deployment and the owner do not
    ///        have to be the same account.
    constructor(address initialOwner) ERC20("AidarFteganChain42", "AFC42") Ownable(initialOwner) {
        _mint(initialOwner, TOTAL_SUPPLY);
    }

    /// @notice Permanently destroys `value` tokens from the caller's own balance.
    /// @dev The burner is msg.sender, so no allowance and no third account is involved.
    ///      OpenZeppelin's ERC20Burnable is deliberately not used: it would also add
    ///      burnFrom(), which this token has no use for.
    /// @param value Amount to destroy, in the smallest unit.
    function burn(uint256 value) external {
        _burn(_msgSender(), value);
    }

    /// @notice The account that issued this token.
    /// @dev Not part of ERC-20: BEP-20 (BSC) requires it, ERC-20 tools simply ignore it.
    ///      Same value as Ownable's owner(). The role carries no privileges.
    /// @return The current owner of the contract.
    function getOwner() external view returns (address) {
        return owner();
    }
}
