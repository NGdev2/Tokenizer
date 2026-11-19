// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {AidarFteganChain42} from "../code/AidarFteganChain42.sol";
import {console} from "hardhat/console.sol";

/// @dev The test runner's cheatcodes, reached through this fixed address. Only the
///      ones used below are declared.
interface Vm {
    function prank(address sender) external;
    function startPrank(address sender) external;
    function stopPrank() external;
    function expectRevert() external;
    function expectEmit() external;
}

/// @dev Every public function whose name starts with "test" is a test case. It passes
///      unless it reverts. setUp() runs again before each one, so tests never share state.
///      console.log lines are printed by the test runner, so each test shows what it checked.
contract TokenTest {
    Vm constant vm = Vm(address(uint160(uint256(keccak256("hevm cheat code")))));

    AidarFteganChain42 token;
    address owner = address(0xA11CE);
    address alice = address(0xB0B);
    address bob = address(0xCAFE);

    uint256 constant SUPPLY = 4_242 * 10 ** 18;

    // Same signatures as the events ERC20 requires, so the tests can emit the expected ones.
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    function setUp() public {
        token = new AidarFteganChain42(owner);
    }

    function test_Metadata() public view {
        console.log("name:    ", token.name());
        console.log("symbol:  ", token.symbol());
        console.log("decimals:", token.decimals());

        require(keccak256(bytes(token.name())) == keccak256("AidarFteganChain42"), "name");
        require(keccak256(bytes(token.symbol())) == keccak256("AFC42"), "symbol");
        require(token.decimals() == 18, "decimals");
    }

    function test_WholeSupplyGoesToOwner() public view {
        console.log("totalSupply:     ", token.totalSupply());
        console.log("balanceOf(owner):", token.balanceOf(owner));
        console.log("getOwner():      ", token.getOwner());

        require(token.totalSupply() == SUPPLY, "totalSupply");
        require(token.balanceOf(owner) == SUPPLY, "owner balance");
        require(token.getOwner() == owner, "getOwner");
    }

    function test_Transfer() public {
        console.log("owner -> alice: 100");
        vm.prank(owner); // the next call is sent from `owner`
        token.transfer(alice, 100);

        console.log("alice balance:", token.balanceOf(alice));
        console.log("owner balance:", token.balanceOf(owner));
        require(token.balanceOf(alice) == 100, "alice balance");
        require(token.balanceOf(owner) == SUPPLY - 100, "owner balance");
    }

    function test_TransferMoreThanBalanceReverts() public {
        console.log("alice balance:", token.balanceOf(alice));
        console.log("alice -> bob: 1 (must revert)");
        vm.expectRevert(); // the next call must revert
        vm.prank(alice);
        token.transfer(bob, 1);
        console.log("reverted as expected");
    }

    function test_TransferToZeroAddressReverts() public {
        console.log("owner -> address(0): 1 (must revert)");
        vm.expectRevert();
        vm.prank(owner);
        token.transfer(address(0), 1);
        console.log("reverted as expected");
    }

    function test_ApproveAndTransferFrom() public {
        console.log("owner approves alice for 50");
        vm.prank(owner);
        token.approve(alice, 50);
        console.log("allowance(owner, alice):", token.allowance(owner, alice));
        require(token.allowance(owner, alice) == 50, "allowance");

        console.log("alice moves 30 from owner to bob");
        vm.prank(alice);
        token.transferFrom(owner, bob, 30);

        console.log("bob balance:            ", token.balanceOf(bob));
        console.log("allowance left:         ", token.allowance(owner, alice));
        require(token.balanceOf(bob) == 30, "bob balance");
        require(token.allowance(owner, alice) == 20, "allowance left");
    }

    function test_TransferFromAboveAllowanceReverts() public {
        console.log("owner approves alice for 10");
        vm.prank(owner);
        token.approve(alice, 10);

        console.log("alice moves 11 from owner to bob (must revert)");
        vm.expectRevert();
        vm.prank(alice);
        token.transferFrom(owner, bob, 11);
        console.log("reverted as expected");
    }

    function test_ApproveOverwritesAllowance() public {
        console.log("owner approves alice for 50, then for 7");
        vm.startPrank(owner);
        token.approve(alice, 50);
        token.approve(alice, 7);
        vm.stopPrank();

        console.log("allowance(owner, alice):", token.allowance(owner, alice));
        require(token.allowance(owner, alice) == 7, "allowance");
    }

    function test_FunctionsReturnTrue() public {
        vm.prank(owner);
        bool transferred = token.transfer(alice, 10);
        console.log("transfer returned:    ", transferred);

        vm.prank(alice);
        bool approved = token.approve(bob, 5);
        console.log("approve returned:     ", approved);

        vm.prank(bob);
        bool transferredFrom = token.transferFrom(alice, bob, 5);
        console.log("transferFrom returned:", transferredFrom);

        require(transferred && approved && transferredFrom, "returned false");
    }

    function test_MintEmitsTransferFromZero() public {
        console.log("expect Transfer(address(0), owner, SUPPLY) on deployment");
        vm.expectEmit(); // the next event must match the one emitted right after
        emit Transfer(address(0), owner, SUPPLY);
        new AidarFteganChain42(owner);
        console.log("event matched");
    }

    function test_TransferEmitsTransfer() public {
        console.log("expect Transfer(owner, alice, 100)");
        vm.expectEmit();
        emit Transfer(owner, alice, 100);
        vm.prank(owner);
        token.transfer(alice, 100);
        console.log("event matched");
    }

    function test_TransferFromEmitsTransfer() public {
        vm.prank(owner);
        token.approve(alice, 50);

        console.log("expect Transfer(owner, bob, 30)");
        vm.expectEmit();
        emit Transfer(owner, bob, 30);
        vm.prank(alice);
        token.transferFrom(owner, bob, 30);
        console.log("event matched");
    }

    function test_ApproveEmitsApproval() public {
        console.log("expect Approval(owner, alice, 50)");
        vm.expectEmit();
        emit Approval(owner, alice, 50);
        vm.prank(owner);
        token.approve(alice, 50);
        console.log("event matched");
    }

    function test_BurnEmitsTransferToZero() public {
        console.log("expect Transfer(owner, address(0), 400)");
        vm.expectEmit();
        emit Transfer(owner, address(0), 400);
        vm.prank(owner);
        token.burn(400);
        console.log("event matched");
    }

    function test_BurnReducesSupply() public {
        console.log("totalSupply before:", token.totalSupply());
        console.log("owner burns 400");
        vm.prank(owner);
        token.burn(400);

        console.log("totalSupply after: ", token.totalSupply());
        console.log("owner balance:     ", token.balanceOf(owner));
        require(token.totalSupply() == SUPPLY - 400, "totalSupply");
        require(token.balanceOf(owner) == SUPPLY - 400, "owner balance");
    }

    function test_OwnershipTransferNeedsAcceptance() public {
        console.log("owner offers ownership to alice");
        vm.prank(owner);
        token.transferOwnership(alice);
        console.log("getOwner() before accept:", token.getOwner());
        console.log("pendingOwner():          ", token.pendingOwner());
        require(token.getOwner() == owner, "changed before accept");

        console.log("alice accepts");
        vm.prank(alice);
        token.acceptOwnership();
        console.log("getOwner() after accept: ", token.getOwner());
        require(token.getOwner() == alice, "not changed after accept");
    }

    function test_StrangerCannotTransferOwnership() public {
        console.log("bob tries to take ownership (must revert)");
        vm.expectRevert();
        vm.prank(bob);
        token.transferOwnership(bob);
        console.log("reverted as expected");
    }
}
