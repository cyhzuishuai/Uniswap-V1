//SPDX-License-Identifier: MIT
// 1. Import Foundry's Test library, Exchange contract, and Token contract.
// 2. Deploy a Token instance with an initial supply.
// 3. Deploy an Exchange contract using the Token's address.
// 4. Approve the Exchange contract to spend tokens from the liquidity provider (owner).
// 5. In testInitialLiquidityAdd:
//    a. Call addLiquidity with a token amount and attach ETH (first liquidity add branch).
//    b. Assert that the returned liquidity equals the ETH sent.
//    c. Assert that the exchange's token reserve equals the token amount provided.
// 6. In testAdditionalLiquidityAdd:
//    a. First add initial liquidity.
//    b. Then add more liquidity: using ETH amount, compute expected token amount by the ratio:
//         expectedTokenAmount = (additionalEth * tokenReserveBefore) / ethReserveBefore.
//    c. Assert that additional liquidity minted equals (totalSupply * additionalEth) / ethReserveBefore.
//    d. Assert that the exchange's token reserve increases by expectedTokenAmount.

pragma solidity ^0.8.25;

import "lib/forge-std/src/Test.sol";
import "../src/Exchange.sol";
import "../src/Token.sol";

contract ExchangeTest is Test {
    Token public token;
    Exchange public exchange;
    address public owner = address(this);

    uint256 public initialTokenSupply = 10000 * 1e18;

    function setUp() public {
        // Deploy Token and Exchange contracts.
        token = new Token("Test Token", "TT", initialTokenSupply);
        exchange = new Exchange(address(token));

        // Approve the Exchange contract to spend tokens on behalf of the liquidity provider.
        token.approve(address(exchange), initialTokenSupply);
    }
    // Test the initial liquidity add and subsequent liquidity adds.
    function testInitialLiquidityAdd() public {
        // Initially, the token reserve should be zero.
        uint256 reserveBefore = exchange.getReserve();
        assertEq(reserveBefore, 0, "Initial reserve must be zero");

        // Define liquidity parameters.
        uint256 tokenAmount = 500 * 1e18;
        uint256 ethAmount = 1 ether;

        // Call addLiquidity with the specified token amount and ETH value.
        uint256 liquidityMinted = exchange.addLiquidity{value: ethAmount}(tokenAmount);

        // For the first liquidity add, liquidity minted equals the sent ETH.
        assertEq(liquidityMinted, ethAmount, "Liquidity minted should equal msg.value");

        // The exchange's token reserve should now equal the provided tokenAmount.
        uint256 reserveAfter = exchange.getReserve();
        assertEq(reserveAfter, tokenAmount, "Token reserve should match the provided token amount");
    }
    // Test adding additional liquidity after the initial liquidity.
    function testAdditionalLiquidityAdd() public {
        // First, add initial liquidity.
        uint256 initialTokenAmount = 500 * 1e18;
        uint256 initialEthAmount = 1 ether;
        exchange.addLiquidity{value: initialEthAmount}(initialTokenAmount);

        // Record state before additional liquidity.
        uint256 tokenReserveBefore = exchange.getReserve();
        uint256 ethReserveBefore = address(exchange).balance; // ETH reserve in Exchange

        // Define additional liquidity parameters.
        uint256 additionalEth = 0.5 ether;
        // Calculate expected token amount required:
        uint256 expectedTokenAmount = (additionalEth * tokenReserveBefore) / ethReserveBefore;

        // Call addLiquidity for additional liquidity.
        uint256 liquidityMinted = exchange.addLiquidity{value: additionalEth}(expectedTokenAmount);

        // Expected liquidity minted = (current totalSupply * additionalEth) / ethReserveBefore.
        // Note: For initial liquidity, totalSupply equals initialEthAmount.
        uint256 expectedLiquidityMinted = (initialEthAmount * additionalEth) / ethReserveBefore;
        assertEq(liquidityMinted, expectedLiquidityMinted, "Additional liquidity minted mismatch");

        // Verify that the token reserve increased correctly.
        uint256 tokenReserveAfter = exchange.getReserve();
        assertEq(
            tokenReserveAfter,
            tokenReserveBefore + expectedTokenAmount,
            "Token reserve should increase by the expected token amount"
        );
    }
}