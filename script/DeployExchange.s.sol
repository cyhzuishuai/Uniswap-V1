// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
import "forge-std/Script.sol";
import "../src/Exchange.sol";
import "../src/Factory.sol";

contract DeployExchange is Script {
    function run() public {
        uint256 privateKey = 0xb5d3740da94e3f1f4bd23e714247a55223c6cc1a7599d0d1e5eeef999ff79909;
        address [] memory tokenAddresses = new address[](4);
        tokenAddresses[0] = 0xB65D7BEB87f57cC725E5f829D7fd23e2A0a7A59f;
        tokenAddresses[1] = 0x75841C57EE004474aDA7e2D1e6c20b5f8b00E1c1;
        tokenAddresses[2] = 0x16E7Fc1922C8baf21E5176276273885e6DaBfF09;
        tokenAddresses[3] = 0xE17a3C8fBe4519d4d5347082F77589EA23336a9C;

        address factoryAddress = 0xFf62a37e69322adD8090c65c4961BAB98899089B;
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