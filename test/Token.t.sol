// SPDX-License-Identifier: MIT
// 1. Import Foundry's Test library and the Token contract.
// 2. Create a TokenTest contract that inherits from Test.
// 3. Declare state variables for the token instance, owner, recipient, and the initial supply.
// 4. In setUp(), deploy the Token contract with the desired name, symbol, and initial supply.
// 5. Write testInitialSupply() to assert that totalSupply and owner's balance equal the initial supply.
// 6. Write testTransfer() to transfer tokens to a recipient and verify both balances.
// 7. Write testApprove() to set and verify an allowance.
// 8. Write testTransferFrom() using vm.prank to simulate a delegated transfer, then assert balances.
// 9. Write testFailsWhenTransferExceedsBalance() to expect a revert when transferring more than the owner’s balance.
//    Note: If this test fails (i.e. does not revert), it indicates an issue in the contract's balance checking.

pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "../src/Token.sol";

contract TokenTest is Test {
    Token public token;
    address public owner;
    address public recipient = address(0xBEEF);
    uint256 public initialSupply = 1000 * 1e18;

    function setUp() public {
        owner = address(this);
        token = new Token("Test Token", "TT", initialSupply);
    }

    // 初始代币供应量测试
    function testInitialSupply() public view {
        // Verify total supply equals initial supply.
        assertEq(token.totalSupply(), initialSupply, "Total supply must equal initial supply");
        // Verify owner's balance equals initial supply.
        assertEq(token.balanceOf(owner), initialSupply, "Owner balance must equal initial supply");
    }
    // 转账测试
    function testTransfer() public {
        uint256 transferAmount = 100 * 1e18;
        token.transfer(recipient, transferAmount);
        // Verify owner's balance decreases correctly.
        assertEq(token.balanceOf(owner), initialSupply - transferAmount, "Owner balance did not decrease correctly");
        // Verify recipient's balance increases correctly.
        assertEq(token.balanceOf(recipient), transferAmount, "Recipient balance did not increase correctly");
    }
    // 授权测试
    function testApprove() public {
        uint256 approvalAmount = 200 * 1e18;
        token.approve(recipient, approvalAmount);
        // Verify allowance.
        assertEq(token.allowance(owner, recipient), approvalAmount, "Allowance was not set correctly");
    }
    // 授权转账测试
    function testTransferFrom() public {
        uint256 approvalAmount = 300 * 1e18;
        token.approve(recipient, approvalAmount);
        // Simulate recipient initiating transferFrom.
        vm.prank(recipient);
        token.transferFrom(owner, recipient, approvalAmount);
        // Verify balances.
        assertEq(token.balanceOf(owner), initialSupply - approvalAmount, "Owner balance did not decrease correctly");
        assertEq(token.balanceOf(recipient), approvalAmount, "Recipient balance did not increase correctly");
    }
    // 测试转账超过余额时的失败情况
    function test_RevertWhen_TransferExceedsBalance() public {
        uint256 excessiveAmount = initialSupply + 1;
        // Expect the transfer to revert due to insufficient balance.
        vm.expectRevert();
        token.transfer(recipient, excessiveAmount);
    }
}