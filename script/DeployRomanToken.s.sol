//SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {RomanToken} from "../src/RomanToken.sol";

contract DeployRomanToken is Script {
    uint256 public constant INITIAL_SUPPLY = 1000000 ether;

    function run() external returns (RomanToken) {
        vm.startBroadcast();
        RomanToken rt = new RomanToken(INITIAL_SUPPLY);
        vm.stopBroadcast();
        return rt;
    }
}
