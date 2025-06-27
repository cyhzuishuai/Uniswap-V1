// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Script.sol";
import "../src/Factory.sol";
import "../src/Exchange.sol";



contract AddUSDTLiquidity is Script {
    
    function run() public {
        // 从环境变量读取私钥
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        
        // 从环境变量读取Factory地址
        address factoryAddress = vm.envAddress("FACTORY_ADDRESS");
        
        // USDT地址
        address usdtAddress = vm.envAddress("TOKEN_ADDRESS_0");
        
        // 添加的ETH数量（0.2 ETH）
        uint256 ethAmount = 0.2 ether;
        
        // 添加的USDT数量（500个USDT）
        uint256 usdtAmount = 500 * 1e18;
        
        vm.startBroadcast(privateKey);
        
        // 获取Factory合约实例
        Factory factory = Factory(factoryAddress);
        
        // 获取USDT交易所地址
        address exchangeAddress = factory.getExchange(usdtAddress);
        
        if(exchangeAddress != address(0)) {
            console.log("Adding USDT liquidity to exchange:", exchangeAddress);
            console.log("ETH amount:", ethAmount);
            console.log("USDT amount:", usdtAmount);
            
            // 获取USDT合约实例
            IERC20 usdt = IERC20(usdtAddress);
            
            // 检查USDT余额
            uint256 usdtBalance = usdt.balanceOf(vm.addr(privateKey));
            console.log("USDT balance:", usdtBalance);
            
            if(usdtBalance >= usdtAmount) {
                // 批准交易所合约使用USDT
                usdt.approve(exchangeAddress, usdtAmount);
                console.log("USDT approved");
                
                // 添加流动性
                Exchange exchange = Exchange(exchangeAddress);
                uint256 lpTokens = exchange.addLiquidity{value: ethAmount}(usdtAmount);
                
                console.log("USDT liquidity added successfully!");
                console.log("LP tokens received:", lpTokens);
            } else {
                console.log("Insufficient USDT balance");
                console.log("Required:", usdtAmount, "Current balance:", usdtBalance);
            }
        } else {
            console.log("USDT exchange not found");
        }
        
        vm.stopBroadcast();
    }
} 