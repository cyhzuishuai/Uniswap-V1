// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Script.sol";
import "../src/Factory.sol";
import "../src/Exchange.sol";
import "../src/Token.sol";


contract AddLiquidity is Script {
    
    function run() public {
        // 从环境变量读取私钥
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        // 从环境变量读取Factory地址
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        
        // 从环境变量读取代币地址
        address[] memory tokenAddresses = new address[](4);
        tokenAddresses[0] = vm.envAddress("TOKEN_ADDRESS_1");  // USDC
        tokenAddresses[1] = vm.envAddress("TOKEN_ADDRESS_2");  // UNI
        tokenAddresses[2] = vm.envAddress("TOKEN_ADDRESS_3");  // ENS
        tokenAddresses[3] = vm.envAddress("TOKEN_ADDRESS_4");  // AAVE
        
        // 每个池子添加的ETH数量（0.2 ETH）
        uint256 ethAmount = 0.2 ether;
        
        // 每个池子添加的代币数量（按照指定比例）
        uint256[] memory tokenAmounts = new uint256[](4);
        tokenAmounts[0] = 500 * 1e18;   // USDC: 500个
        tokenAmounts[1] = 62.5 * 1e18;  // UNI: 62.5个
        tokenAmounts[2] = 25 * 1e18;    // ENS: 25个
        tokenAmounts[3] = 1.89 * 1e18;  // AAVE: 1.89个
        
        vm.startBroadcast(privateKey);
        
        // 获取Factory合约实例
        Factory factory = Factory(factoryAddress);
        
        for(uint256 i = 0; i < tokenAddresses.length; i++) {
            // 获取交易所地址
            address exchangeAddress = factory.getExchange(tokenAddresses[i]);
            
            if(exchangeAddress != address(0)) {
                console.log("Adding liquidity for token:", tokenAddresses[i]);
                console.log("Exchange address:", exchangeAddress);
                console.log("ETH amount:", ethAmount);
                console.log("Token amount:", tokenAmounts[i]);
                
                // 获取代币合约实例
                IERC20 token = IERC20(tokenAddresses[i]);
                
                // 检查代币余额
                uint256 tokenBalance = token.balanceOf(vm.addr(privateKey));
                console.log("Token balance:", tokenBalance);
                
                // 检查交易所当前状态
                Exchange exchange = Exchange(exchangeAddress);
                uint256 currentReserve = exchange.getReserve();
                uint256 currentEthBalance = exchangeAddress.balance;
                
                console.log("Current token reserve:", currentReserve);
                console.log("Current ETH balance:", currentEthBalance);
                
                uint256 requiredTokenAmount;
                
                if(currentReserve == 0) {
                    // 首次添加流动性
                    requiredTokenAmount = tokenAmounts[i];
                    console.log("First time adding liquidity, using provided amount");
                } else {
                    // 计算按比例需要的代币数量
                    requiredTokenAmount = (ethAmount * currentReserve) / currentEthBalance;
                    console.log("Calculated required token amount:", requiredTokenAmount);
                }
                
                if(tokenBalance >= requiredTokenAmount) {
                    // 批准交易所合约使用代币
                    token.approve(exchangeAddress, requiredTokenAmount);
                    console.log("Token approved for amount:", requiredTokenAmount);
                    
                    // 添加流动性
                    uint256 lpTokens = exchange.addLiquidity{value: ethAmount}(requiredTokenAmount);
                    
                    console.log("Liquidity added successfully! LP tokens:", lpTokens);
                } else {
                    console.log("Insufficient token balance, skipping this pool");
                    console.log("Required:", requiredTokenAmount, "Current balance:", tokenBalance);
                }
            } else {
                console.log("Exchange for token", tokenAddresses[i], "does not exist, skipping");
            }
            
            console.log("----------------------------------------");
        }
        
        vm.stopBroadcast();
    }
} 