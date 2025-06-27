// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Script.sol";
import "../src/Factory.sol";
contract DeployFactory is Script {

    function run() public returns (Factory) {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        Factory factory = new Factory();

        vm.stopBroadcast();

        console.log("Factory deployed at", address(factory));
        return factory;
    }
}