// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Script.sol";
import "../src/Factory.sol";
contract DeployFactory is Script {

    function run() public returns (Factory) {
        uint256 privateKey = 0xb5d3740da94e3f1f4bd23e714247a55223c6cc1a7599d0d1e5eeef999ff79909;
        vm.startBroadcast(privateKey);

        Factory factory = new Factory();

        vm.stopBroadcast();

        console.log("Factory deployed at", address(factory));
        return factory;
    }
}