// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Script.sol";
import "../src/Factory.sol";
import "../src/Exchange.sol";

contract RemoveAllLiquidity is Script {
    
    function run() public {
        // 从环境变量读取私钥
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        // 从环境变量读取Factory地址
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        
        // 代币地址
        address usdtAddress = vm.envAddress("TOKEN_ADDRESS_0");
        address usdcAddress = vm.envAddress("TOKEN_ADDRESS_1");
        address uniAddress = vm.envAddress("TOKEN_ADDRESS_2");
        address ensAddress = vm.envAddress("TOKEN_ADDRESS_3");
        address aaveAddress = vm.envAddress("TOKEN_ADDRESS_4");
        
        vm.startBroadcast(privateKey);
        
        // 获取Factory合约实例
        Factory factory = Factory(factoryAddress);
        
        // 移除USDT流动性
        removeLiquidityForToken(factory, usdtAddress, "USDT");
        
        // 移除USDC流动性
        removeLiquidityForToken(factory, usdcAddress, "USDC");
        
        // 移除UNI流动性
        removeLiquidityForToken(factory, uniAddress, "UNI");
        
        // 移除ENS流动性
        removeLiquidityForToken(factory, ensAddress, "ENS");
        
        // 移除AAVE流动性
        removeLiquidityForToken(factory, aaveAddress, "AAVE");
        
        vm.stopBroadcast();
    }
    
    function removeLiquidityForToken(Factory factory, address tokenAddress, string memory tokenName) internal {
        // 获取交易所地址
        address exchangeAddress = factory.getExchange(tokenAddress);
        
        if(exchangeAddress != address(0)) {
            console.log("Removing", tokenName, "liquidity from exchange:", exchangeAddress);
            
            // 获取交易所合约实例
            Exchange exchange = Exchange(exchangeAddress);
            
            // 获取当前账户的LP代币余额
            uint256 lpBalance = exchange.balanceOf(vm.addr(vm.envUint("PRIVATE_KEY")));
            console.log("Current LP token balance:", lpBalance);
            
            if(lpBalance > 0) {
                // 移除所有流动性
                (uint256 ethReceived, uint256 tokenReceived) = exchange.removeLiquidity(lpBalance);
                
                console.log("Liquidity removed successfully!");
                console.log("ETH received:", ethReceived);
                console.log(tokenName, "received:", tokenReceived);
                console.log("LP tokens burned:", lpBalance);
            } else {
                console.log("No LP tokens to remove");
            }
        } else {
            console.log(tokenName, "exchange not found");
        }
        
        console.log("---");
    }
} 