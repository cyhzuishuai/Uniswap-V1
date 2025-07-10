// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/Exchange.sol";
import "../src/Factory.sol";

contract GetExchangeBalance is Script {
    function run() external {
        // USDT related addresses
        address usdtAddress = 0xEF8fd7e36FA7233C32a953b4c8004C1383f4E49d;
        address usdtExchangeAddress = 0xA931E00664710217cC543a18EAdA487dD55f5aC6;
        
        console.log("=== USDT Exchange Balance Query ===");
        console.log("USDT Token Address:", usdtAddress);
        console.log("USDT Exchange Address:", usdtExchangeAddress);
        
        // Create Exchange contract instance
        Exchange exchange = Exchange(usdtExchangeAddress);
        
        // Get USDT reserve
        uint256 tokenReserve = exchange.getReserve();
        console.log("USDT Reserve:", tokenReserve);
        console.log("USDT Reserve (USDT):", tokenReserve / 1e18);
        
        // Get ETH balance
        uint256 ethBalance = address(exchange).balance;
        console.log("ETH Balance (wei):", ethBalance);
        console.log("ETH Balance (ether):", ethBalance / 1e18);
        
        // Get price ratio
        if (tokenReserve > 0 && ethBalance > 0) {
            uint256 priceRatio = exchange.getPrice(ethBalance, tokenReserve);
            console.log("Price Ratio (ETH/USDT * 1000):", priceRatio);
            console.log("Actual Price Ratio (ETH/USDT):", priceRatio / 1000.0);
            console.log("USDT Price (USDT/ETH):", (tokenReserve * 1e18) / ethBalance);
        }
        
        // Get LP token total supply
        uint256 totalSupply = exchange.totalSupply();
        console.log("LP Token Total Supply:", totalSupply);
        
        // Get token address and factory address
        address tokenAddr = exchange.tokenAddress();
        address factoryAddr = exchange.factoryAddress();
        console.log("Token Address in Exchange:", tokenAddr);
        console.log("Factory Contract Address:", factoryAddr);
        
        console.log("=== Query Completed ===");
    }
} 