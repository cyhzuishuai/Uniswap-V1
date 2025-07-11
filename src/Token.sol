// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
//import "UniSwap-V1/lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import  "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  constructor(
    string memory name,
    string memory symbol,
    uint256 initialSupply
  ) ERC20(name, symbol) {
    _mint(msg.sender, initialSupply);
  }
}
