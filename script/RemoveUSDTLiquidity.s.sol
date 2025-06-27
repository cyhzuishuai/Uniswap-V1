// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Script.sol";
import "../src/Factory.sol";
import "../src/Exchange.sol";


contract RemoveUSDTLiquidity is Script {
    
    function run() public {
        // 从环境变量读取私钥
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        // 从环境变量读取Factory地址
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        
        // USDT地址
        address usdtAddress = vm.envAddress("TOKEN_ADDRESS_0");
        
        vm.startBroadcast(privateKey);
        
        // 获取Factory合约实例
        Factory factory = Factory(factoryAddress);
        
        // 获取USDT交易所地址
        address exchangeAddress = factory.getExchange(usdtAddress);
        
        if(exchangeAddress != address(0)) {
            console.log("Removing USDT liquidity from exchange:", exchangeAddress);
            
            // 获取交易所合约实例
            Exchange exchange = Exchange(exchangeAddress);
            
            // 获取当前账户的LP代币余额
            uint256 lpBalance = exchange.balanceOf(vm.addr(privateKey));
            console.log("Current LP token balance:", lpBalance);
            
            if(lpBalance > 0) {
                // 移除所有流动性
                (uint256 ethReceived, uint256 tokenReceived) = exchange.removeLiquidity(lpBalance);
                
                console.log("Liquidity removed successfully!");
                console.log("ETH received:", ethReceived);
                console.log("USDT received:", tokenReceived);
                console.log("LP tokens burned:", lpBalance);
            } else {
                console.log("No LP tokens to remove");
            }
        } else {
            console.log("USDT exchange not found");
        }
        
        vm.stopBroadcast();
    }
} 