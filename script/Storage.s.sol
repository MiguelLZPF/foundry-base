// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import {Storage} from "@src/Storage.sol";
import {Configuration, Deployment, DeploymentStoreInfo} from "@script/Configuration.s.sol";

/**
 * @title DeployCommand
 * @dev Struct representing a deployment command.
 */
struct DeployCommand {
  uint256 initValue; // Initial value for the deployment.
  DeploymentStoreInfo storeInfo; // Deployment store information.
}

/**
 * @title StorageScript
 * @dev A script contract for deploying the Storage contract and storing its deployment information.
 */
contract StorageScript is Script {
  string private constant CONTRACT_NAME = "Storage";
  string private constant CONTRACT_FILE_NAME = "Storage.sol";
  Configuration config = new Configuration();

  /**
   * @dev Deploys the Storage contract and stores its deployment information.
   * @param command The deploy command containing the initial value for the Storage contract.
   * @return storage_ The deployed Storage contract.
   * @return deployment The deployment information of the Storage contract.
   */
  function deploy(
    DeployCommand calldata command
  ) external returns (Storage storage_, Deployment memory deployment) {
    // Only thing that is executed in the blockchain
    vm.startBroadcast();
    storage_ = new Storage(command.initValue);
    vm.stopBroadcast();
    // Generate deployment data
    deployment = Deployment({
      bytecodeHash: keccak256(vm.getCode(CONTRACT_FILE_NAME)),
      chainId: block.chainid,
      logicAddr: address(storage_),
      name: vm.parseBytes32(CONTRACT_NAME),
      proxyAddr: address(0),
      tag: command.storeInfo.tag
    });
    // Store the deployment
    if (command.storeInfo.store) {
      config.storeDeployment(deployment);
    }
    return (storage_, deployment);
  }
}
