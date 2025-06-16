//SPDX-License-Identifier: MIT
// Pseudocode:
// 1. Deploy Token and Exchange contracts in setUp(), add initial liquidity to the Exchange.
//    - For initial liquidity, call exchange.addLiquidity() with a specified token amount and ETH value.
//    - Approve token spending from the test contract before adding liquidity.
// 2. Test getPrice:
//    a. Call exchange.getPrice(a, b) with valid nonzero reserves and compare with expected value.
//    b. Verify that calling getPrice with zero reserves reverts.
// 3. Test getTokenAmount:
//    a. With the liquidity added, call exchange.getTokenAmount(_ethSold) and compare with independently computed expected value.
// 4. Test getEthAmount:
//    a. Similarly, call exchange.getEthAmount(_tokenSold) and compare with the expected value computed through the pricing formula.
// 5. Use the same pricing formula as in Exchange.getAmount:
//       inputAmountWithFee = inputAmount * 997
//       numerator = inputAmountWithFee * outputReserve
//       denominator = (inputReserve * 1000) + inputAmountWithFee
//       result = numerator / denominator

pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "../src/Exchange.sol";
import "../src/Token.sol";

contract GetPricesTest is Test {
    Token public token;
    Exchange public exchange;
    address public owner = address(this);
    
    // Use 500 tokens and 1 ether as initial liquidity
    uint256 public initialTokenAmount = 500 * 1e18;
    uint256 public initialEthAmount = 1 ether;
    uint256 public initialTokenSupply = 10000 * 1e18;

    // Pricing helper replicating Exchange.getAmount logic
    function calcOutput(
        uint256 inputAmount, 
        uint256 inputReserve, 
        uint256 outputReserve
    ) internal pure returns (uint256) {
        uint256 inputAmountWithFee = inputAmount * 997;
        uint256 numerator = inputAmountWithFee * outputReserve;
        uint256 denominator = (inputReserve * 1000) + inputAmountWithFee;
        return numerator / denominator;
    }

    function setUp() public {
        // Deploy token and exchange
        token = new Token("Test Token", "TT", initialTokenSupply);
        exchange = new Exchange(address(token));
        
        // Approve exchange to spend tokens for adding liquidity
        token.approve(address(exchange), initialTokenSupply);

        // Add initial liquidity
        // For first liquidity add, tokenAmount provided is taken directly.
        exchange.addLiquidity{value: initialEthAmount}(initialTokenAmount);
    }

    function testGetPrice_valid() public view {
        // Test getPrice with arbitrary nonzero reserves.
        uint256 inputReserve = 200 * 1e18;
        uint256 outputReserve = 100 * 1e18;
        uint256 expectedPrice = (inputReserve * 1000) / outputReserve; // (200*1000)/100 = 2000
        uint256 price = exchange.getPrice(inputReserve, outputReserve);
        assertEq(price, expectedPrice, "Price calculation mismatch");
        // expectedPrice; // Silence unused variable warning
    }

    function testGetPrice_invalidZeroInput() public {
        // Expect revert when one reserve is zero.
        vm.expectRevert("invalid reserves");
        exchange.getPrice(0, 100 * 1e18);
    }

    function testGetPrice_invalidZeroOutput() public {
        vm.expectRevert("invalid reserves");
        exchange.getPrice(100 * 1e18, 0);
    }

    function testGetTokenAmount() public view {
        // Get current reserves from exchange
        uint256 tokenReserve = exchange.getReserve();
        uint256 ethReserve = address(exchange).balance; // should equal initialEthAmount

        // Define an ETH amount to sell
        uint256 ethSold = 0.1 ether;

        // Expected token output via calcOutput:
        // Note: getTokenAmount uses: getAmount(ethSold, exchange ETH balance, tokenReserve)
        uint256 expectedTokens = calcOutput(ethSold, ethReserve, tokenReserve);

        uint256 tokensOut = exchange.getTokenAmount(ethSold);
        assertEq(tokensOut, expectedTokens, "Token amount output mismatch");
    }

    function testGetEthAmount() public view {
        // Get current reserves: tokenReserve from exchange and current ETH balance.
        uint256 tokenReserve = exchange.getReserve();
        uint256 ethReserve = address(exchange).balance; // should equal initialEthAmount

        // Define a token sold amount (choose a value less than tokenReserve)
        uint256 tokensSold = 10 * 1e18;

        // Expected ETH output using calcOutput:
        // getEthAmount uses: getAmount(tokensSold, tokenReserve, ethReserve)
        uint256 expectedEth = calcOutput(tokensSold, tokenReserve, ethReserve);

        uint256 ethOut = exchange.getEthAmount(tokensSold);
        assertEq(ethOut, expectedEth, "ETH amount output mismatch");
    }
}