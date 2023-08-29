//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {RomanToken} from "../src/RomanToken.sol";
import {DeployRomanToken} from "../script/DeployRomanToken.s.sol";

contract RomanTest is Test {
    RomanToken public romanToken;
    DeployRomanToken public deployRomanToken;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 1000 ether;

    function setUp() public {
        deployRomanToken = new DeployRomanToken();
        romanToken = deployRomanToken.run();

        vm.prank(msg.sender);
        romanToken.transfer(bob, STARTING_BALANCE);
    }

    function testBobBalance() public {
        assertEq(romanToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testAllowancesWork() public {
        uint256 initialAllowance = 1000 ether;

        //Bob approves Alice to spend tokens on his behalf
        vm.prank(bob);
        romanToken.approve(alice, initialAllowance);

        uint256 transferAmount = 500 ether;

        vm.prank(alice);
        romanToken.transferFrom(bob, alice, transferAmount);

        assertEq(romanToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(romanToken.balanceOf(alice), transferAmount);
    }

    function testTransfers() public {
        address account1 = address(1);
        address account2 = address(2);
        uint256 transferAmount = 50;

        romanToken.transfer(account1, transferAmount);
        assertEq(romanToken.balanceOf(account1), transferAmount);

        // Try transferring from account1 to account2
        romanToken.connect(account1).transfer(account2, transferAmount);
        assertEq(romanToken.balanceOf(account1), 0);
        assertEq(romanToken.balanceOf(account2), transferAmount);

        // Check remaining balance of contract owner (this)
        assertEq(
            romanToken.balanceOf(address(this)),
            deployer.INITIAL_SUPPLY() - transferAmount * 2
        );
    }
}
