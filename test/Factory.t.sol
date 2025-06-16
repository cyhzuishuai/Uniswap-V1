//SPDX-License-Identifier: MIT
// Pseudocode:
// 1. Import Foundry's Test library, Factory and Token contracts.
// 2. In setUp(), deploy a Token with an initial supply and then deploy Factory.
// 3. testCreateExchange:
//    a. Call factory.createExchange(tokenAddress) and ensure the returned address is not zero.
//    b. Assert that factory.getExchange(tokenAddress) returns the same address.
// 4. testCreateExchangeFailsIfExists:
//    a. Call createExchange once for a token.
//    b. Expect a revert when calling createExchange again for the same token.
// 5. testCannotCreateExchangeWithZeroToken:
//    a. Expect a revert when calling createExchange with address(0).

pragma solidity ^0.8.25;

import "../lib/forge-std/src/Test.sol";
import "../src/Factory.sol";
import "../src/Token.sol";

contract FactoryTest is Test {
    Factory public factory;
    Token public token;
    address public owner = address(this);
    uint256 public initialTokenSupply = 10000 * 1e18;

    function setUp() public {
        token = new Token("Test Token", "TT", initialTokenSupply);
        factory = new Factory();
    }

    function testCreateExchange() public {
        address exchangeAddress = factory.createExchange(address(token));
        // Verify that the returned exchange address is non-zero
        assertTrue(exchangeAddress != address(0), "Exchange address should not be zero");
        // Verify that the exchange is correctly registered in the factory mapping
        address registeredExchange = factory.getExchange(address(token));
        assertEq(registeredExchange, exchangeAddress, "Registered exchange does not match created exchange");
    }

    function testCreateExchangeFailsIfExists() public {
        // Create the exchange for the token
        factory.createExchange(address(token));
        // Expect revert when trying to create the exchange again for the same token
        vm.expectRevert("exchange already exists");
        factory.createExchange(address(token));
    }

    function testCannotCreateExchangeWithZeroToken() public {
        // Expect revert when zero address is passed
        vm.expectRevert("invalid token address");
        factory.createExchange(address(0));
    }
}