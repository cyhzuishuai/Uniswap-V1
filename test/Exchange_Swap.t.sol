// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "../src/Token.sol";
import "../src/Exchange.sol";

/**
 * Full swap-path test-suite for the Uniswap-V1-style Exchange contract.
 * Covers:
 *   - ETH → Token swap (happy-path and slippage protection)
 *   - Token → ETH swap (happy-path and slippage protection)
 *   - Failure cases when min-out parameters are set too high
 *
 * All comments in English per user preference.
 */
contract ExchangeSwapTest is Test {
    /* -------------------------------------------------------------------------- */
    /*                                  Fixtures                                  */
    /* -------------------------------------------------------------------------- */

    Token    internal token;
    Exchange internal exchange;
    address  internal owner = address(this);

    uint256 internal constant INITIAL_TOKEN_SUPPLY    = 10_000 * 1e18;
    uint256 internal constant INITIAL_TOKEN_LIQUIDITY = 500   * 1e18;
    uint256 internal constant INITIAL_ETH_LIQUIDITY   = 1 ether;

    function setUp() public {
        // Deploy ERC-20 and Exchange
        token    = new Token("Test Token", "TT", INITIAL_TOKEN_SUPPLY);
        exchange = new Exchange(address(token));

        // Give the pool an unlimited allowance from this test contract
        token.approve(address(exchange), type(uint256).max);

        // Seed initial liquidity (first-mint branch)
        exchange.addLiquidity{value: INITIAL_ETH_LIQUIDITY}(INITIAL_TOKEN_LIQUIDITY);
    }

    /// @notice Enables this contract to receive ETH during token → ETH swaps
    receive() external payable {}

    /* -------------------------------------------------------------------------- */
    /*                                  Helpers                                   */
    /* -------------------------------------------------------------------------- */

    /**
     * Quotes expected output and min-out with 1 % slippage tolerance.
     * @param amountIn      Amount being sold
     * @param isEthIn       true  → ETH → Token
     *                      false → Token → ETH
     */
    function _quoteOut(
        uint256 amountIn,
        bool    isEthIn
    ) internal view returns (uint256 expectedOut, uint256 minOut) {
        expectedOut = isEthIn
            ? exchange.getTokenAmount(amountIn)
            : exchange.getEthAmount(amountIn);

        // Allow 1 % slippage to avoid off-by-wei rounding issues
        minOut = (expectedOut * 997) / 1000;
    }

    /* -------------------------------------------------------------------------- */
    /*                                  Happy-path                                */
    /* -------------------------------------------------------------------------- */

    /// Swap ETH for tokens
    function testEthToTokenSwap() public {
        uint256 ethIn = 0.1 ether;

        (uint256 expectedTokens, uint256 minTokens) = _quoteOut(ethIn, true);

        uint256 before = token.balanceOf(owner);

        exchange.ethToTokenSwap{value: ethIn}(minTokens);

        uint256 gained = token.balanceOf(owner) - before;

        assertGe(gained, minTokens, "token gain < minTokens");
        assertEq(gained, expectedTokens, "token gain != quote");
    }

    /// Swap tokens for ETH
    function testTokenToEthSwap() public {
        uint256 tokensIn = 10 * 1e18;

        (uint256 expectedEth, uint256 minEth) = _quoteOut(tokensIn, false);

        uint256 before = owner.balance;

        exchange.tokenToEthSwap(tokensIn, minEth);

        uint256 gained = owner.balance - before;

        assertGe(gained, minEth, "ETH gain < minEth");
        assertEq(gained, expectedEth, "ETH gain != quote");
    }

    /* -------------------------------------------------------------------------- */
    /*                                Failure paths                               */
    /* -------------------------------------------------------------------------- */

    /// Expect revert if minTokens is set above the obtainable amount
    function test_RevertWhen_EthToToken_minTokensTooHigh() public {
        uint256 ethIn     = 0.05 ether;
        uint256 minTokens = exchange.getTokenAmount(ethIn) + 1;
        vm.expectRevert("insufficient output amount");
        exchange.ethToTokenSwap{value: ethIn}(minTokens); // must revert
    }

    /// Expect revert if minEth is set above the obtainable amount
    function test_RevertWhen_TokenToEth_minEthTooHigh() public {
        uint256 tokensIn = 5 * 1e18;
        uint256 minEth   = exchange.getEthAmount(tokensIn) + 1;
        vm.expectRevert("insufficient output amount");
        exchange.tokenToEthSwap(tokensIn, minEth); // must revert
    }
}
