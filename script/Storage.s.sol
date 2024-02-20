// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Storage} from "@src/Storage.sol";

contract StorageDeploy is Script {
    // function setUp() external {}

    function run(uint256 initValue) external returns (Storage storageContract) {
        vm.startBroadcast();
        storageContract = new Storage(initValue);
        vm.stopBroadcast();
    }
}
