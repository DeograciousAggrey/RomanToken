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
}
