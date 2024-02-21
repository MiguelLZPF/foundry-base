// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";

contract Test is Script {
  function run() external {
    string memory deployments = "deployments";
    vm.serializeUint(deployments, "ChainId", block.chainid);
    string memory contractInfo = "contractInfo";
    string memory cIByAddr = "cIByAddr";
    string memory cIByAddrByName = "cIByAddrByName";
    vm.serializeString(contractInfo, "name", "StorageTestss");
    string memory serContractInfo = vm.serializeString(contractInfo, "address", "0x1234");
    string memory serCIByAddress = vm.serializeString(cIByAddr, "0x1234", serContractInfo);
    string memory serCIByAddressByName = vm.serializeString(
      cIByAddrByName,
      "StorageTestss",
      serCIByAddress
    );

    string memory result = vm.serializeString(deployments, "contracts", serCIByAddressByName);

    vm.writeJson(result, "./deployments.json");
  }
}
