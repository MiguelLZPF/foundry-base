// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Upgrades} from "openzeppelin-foundry-upgrades/Upgrades.sol";
import {StorageUpgr} from "@src/StorageUpgr.sol";

//* Reference: https://github.com/OpenZeppelin/openzeppelin-foundry-upgrades

contract UpgradeStorageUpgr is Script {
  string private constant CONTRACT_FILE_NAME = "StorageUpgr.sol";

  // function setUp() external {}

  function run(address proxy, string memory contractFileName) external {
    vm.startBroadcast();
    Upgrades.upgradeProxy(proxy, contractFileName, "");
    vm.stopBroadcast();
  }
}
