// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

import {Script, console} from "forge-std/Script.sol";
import "forge-std/StdJson.sol";

struct Deployment {
  bytes32 bytecodeHash;
  uint256 chainId;
  address logicAddr;
  bytes32 logicDeployTxHash;
  string name;
  address proxyAddr;
  string tag;
}

contract Configuration is Script {
  using stdJson for string;

  /**
   * @dev Stores the deployment information in a JSON file.
   * @param deployment The deployment data to be stored.
   */
  function storeDeployment(Deployment calldata deployment) external {
    // Deployment memory deploymentData = Deployment(
    //   bytes32(keccak256("0x1234")),
    //   666,
    //   address(5),
    //   bytes32(keccak256("0x1134")),
    //   "Storage",
    //   address(0),
    //   "StorageTestss"
    // );
    // Serialize the deployment
    string memory toBeDeployment = "deployment";
    vm.serializeString(toBeDeployment, "tag", deployment.tag);
    vm.serializeString(toBeDeployment, "name", deployment.name);
    vm.serializeAddress(toBeDeployment, "proxyAddr", deployment.proxyAddr);
    vm.serializeAddress(toBeDeployment, "logicAddr", deployment.logicAddr);
    vm.serializeUint(toBeDeployment, "chainId", deployment.chainId);
    vm.serializeBytes32(toBeDeployment, "bytecodeHash", deployment.bytecodeHash);
    string memory serializedDeployment = vm.serializeBytes32(
      toBeDeployment,
      "logicDeployTxHash",
      deployment.logicDeployTxHash
    );
    // Serialize the deployment by tag
    string memory deploymentByTag = "serDeploymentByTag";
    string memory serDeploymentByTag = vm.serializeString(
      deploymentByTag,
      deployment.tag,
      serializedDeployment
    );
    // Serialize the deployment by network
    string memory deploymentsByNetwork = "deploymentsByNetwork";
    string memory serDeploymentsByNetwork = vm.serializeString(
      deploymentsByNetwork,
      vm.toString(deployment.chainId),
      serDeploymentByTag
    );
    // Write the deployment to the deployments.json file
    vm.writeJson(serDeploymentsByNetwork, "./deployments.json");
  }

  /**
   * @dev Retrieves a deployment based on the chain ID and tag.
   * @param chainId The chain ID of the deployment.
   * @param tag The tag of the deployment.
   * @return deployment The retrieved deployment.
   */
  function retrieveDeployment(
    uint256 chainId,
    string calldata tag
  ) external view returns (Deployment memory deployment) {
    // Read the deployments.json file
    string memory serializedDeployment = vm.readFile("./deployments.json");
    // Set the filter
    string memory filter = string(abi.encodePacked(".", vm.toString(chainId), ".", tag));
    // Search for the encoded deployment
    bytes memory encDeployment = serializedDeployment.parseRaw(filter);
    // Decode the deployment and return it
    return abi.decode(encDeployment, (Deployment));
  }
}
