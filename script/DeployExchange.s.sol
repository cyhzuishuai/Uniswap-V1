// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import "../lib/forge-std/src/Script.sol";
import "../src/Exchange.sol";
import "../src/Factory.sol";

contract DeployExchange is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        address [] memory tokenAddresses = new address[](4);
        tokenAddresses[0] = vm.envAddress("TOKEN_ADDRESS_1");
        tokenAddresses[1] = vm.envAddress("TOKEN_ADDRESS_2");
        tokenAddresses[2] = vm.envAddress("TOKEN_ADDRESS_3");
        tokenAddresses[3] = vm.envAddress("TOKEN_ADDRESS_4");

        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        vm.startBroadcast(privateKey);

        //获取Factory合约实例
        Factory factory = Factory(factoryAddress);

        for(uint256 i=0; i<4; i++) {
            //创建Exchange
            address exchange = factory.createExchange(tokenAddresses[i]);
            console.log("Exchange deployed at", address(exchange));
        }

        vm.stopBroadcast();
    }
}