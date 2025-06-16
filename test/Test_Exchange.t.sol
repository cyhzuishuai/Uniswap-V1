// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "lib/forge-std/src/Test.sol";
import "../src/Token.sol";
import "../src/Exchange.sol";

contract ExchangeIntegrationTest is Test {
    Token    internal token;
    Exchange internal exchange;

    address internal liquidityProvider = address(this);
    address internal trader            = address(0xBEEF);

    uint256 internal constant INIT_SUPPLY   = 10_000e18;
    uint256 internal constant INIT_TOKEN_LQ = 500e18;
    uint256 internal constant INIT_ETH_LQ   = 1 ether;

    /* -------------------------------------------------------------------------- */
    /*                                   Setup                                    */
    /* -------------------------------------------------------------------------- */
    function setUp() public {
        token    = new Token("Test Token", "TT", INIT_SUPPLY);
        exchange = new Exchange(address(token));

        token.approve(address(exchange), type(uint256).max);
        exchange.addLiquidity{value: INIT_ETH_LQ}(INIT_TOKEN_LQ);

        token.transfer(trader, 1_000e18);

        /* -------- fund trader with native ETH so swaps won't revert -------- */
        vm.deal(trader, 2 ether);
    }

    /* -------------------------------------------------------------------------- */
    /*                           Full integration flow                            */
    /* -------------------------------------------------------------------------- */
    function testIntegration() public {
        /* ───── 1. Trader: ETH → Token ───── */
        uint256 ethIn      = 0.1 ether;
        uint256 minTokens  = exchange.getTokenAmount(ethIn);

        vm.prank(trader);
        exchange.ethToTokenSwap{value: ethIn}(minTokens);

        assertGe(
            token.balanceOf(trader),
            1_000e18 + minTokens,
            "Trader token gain too small"
        );

        /* ───── 2. Trader: Token → ETH ───── */
        uint256 tokensIn = 50e18;

        vm.startPrank(trader);
        token.approve(address(exchange), tokensIn);
        uint256 minEth  = exchange.getEthAmount(tokensIn);
        uint256 ethBefore = trader.balance;
        exchange.tokenToEthSwap(tokensIn, minEth);
        vm.stopPrank();

        assertGe(
            trader.balance,
            ethBefore + minEth,
            "Trader ETH gain too small"
        );

        /* ───── 3. LP removes half liquidity ───── */
        uint256 totalLP  = exchange.totalSupply();
        uint256 lpRemove = totalLP / 2;

        uint256 poolEthBefore   = address(exchange).balance;
        uint256 poolTokenBefore = exchange.getReserve();

        (uint256 ethOut, uint256 tokOut) = exchange.removeLiquidity(lpRemove);

        // 期望值需基于 **最新储备** 计算
        uint256 expEth = (poolEthBefore   * lpRemove) / totalLP;
        uint256 expTok = (poolTokenBefore * lpRemove) / totalLP;

        assertEq(ethOut, expEth,  "ETH out mismatch");
        assertEq(tokOut, expTok,  "Token out mismatch");

        // LP 份额燃烧检查
        assertEq(
            exchange.balanceOf(liquidityProvider),
            totalLP - lpRemove,
            "LP token burn mismatch"
        );
    }

    /* Allow this contract to receive ETH */
    receive() external payable {}
}
