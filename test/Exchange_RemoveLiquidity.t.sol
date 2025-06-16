// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "../src/Token.sol";
import "../src/Exchange.sol";

contract ExchangeRemoveLiquidityTest is Test {
    Token    internal token;
    Exchange internal exchange;
    address  internal owner = address(this);

    uint256 internal constant INIT_TOKEN_SUPPLY    = 10_000e18;
    uint256 internal constant INIT_TOKEN_LIQUIDITY = 500e18;
    uint256 internal constant INIT_ETH_LIQUIDITY   = 1 ether;

    function setUp() public {
        token    = new Token("Test Token", "TT", INIT_TOKEN_SUPPLY);
        exchange = new Exchange(address(token));

        token.approve(address(exchange), type(uint256).max);
        exchange.addLiquidity{value: INIT_ETH_LIQUIDITY}(INIT_TOKEN_LIQUIDITY);
    }

    /* ------------ 关键：允许本测试合约接收返还的 ETH ------------ */
    receive() external payable {}

    /* ------------------------------------------------------------ */
    /*                      失败路径（边界值）                       */
    /* ------------------------------------------------------------ */

    /// Expect revert when LP amount is zero
    function test_RevertWhen_RemoveZeroLiquidity() public {
        vm.expectRevert("invalid amount");
        exchange.removeLiquidity(0);
    }

    /* ------------------------------------------------------------ */
    /*                       Happy Path 测试                         */
    /* ------------------------------------------------------------ */

    /// Remove ALL liquidity
    function testRemoveAllLiquidity() public {
        uint256 lpBalance = exchange.totalSupply(); // == 1e18 (初次 mint == ETH)
        uint256 ethBefore = owner.balance;
        uint256 tokBefore = token.balanceOf(owner);

        (uint256 ethOut, uint256 tokOut) = exchange.removeLiquidity(lpBalance);

        // 余额断言
        assertEq(owner.balance, ethBefore + ethOut, "ETH not received");
        assertEq(token.balanceOf(owner), tokBefore + tokOut, "Token not received");
        assertEq(exchange.totalSupply(), 0, "LP supply not burned");
    }

    /// Remove HALF of the liquidity
    function testRemovePartialLiquidity() public {
        uint256 lpTotal   = exchange.totalSupply();
        uint256 lpRemove  = lpTotal / 2;

        uint256 ethBefore = owner.balance;
        uint256 tokBefore = token.balanceOf(owner);

        (uint256 ethOut, uint256 tokOut) = exchange.removeLiquidity(lpRemove);

        // 余额断言
        assertEq(owner.balance, ethBefore + ethOut, "ETH not received");
        assertEq(token.balanceOf(owner), tokBefore + tokOut, "Token not received");
        assertEq(
            exchange.totalSupply(),
            lpTotal - lpRemove,
            "LP supply wrong after burn"
        );
    }
}
