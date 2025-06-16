//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./Exchange.sol";

contract Factory {

    event NewExchange(address indexed token, address indexed exchange);

    // 创建代币地址对交易所地址的映射，地址对地址的映射，属性为公开
    mapping(address => address) public tokenToExchange;

    /**
     * @dev 为指定的ERC20代币创建一个新的交易所（Exchange）合约，并建立映射关系。
     * @param _tokenAddress 需要创建交易所的ERC20代币合约地址
     * @return 新创建的交易所（Exchange）合约地址
     */
    function createExchange(address _tokenAddress) public returns (address) {
        // 检查传入的代币地址不是零地址否则报错"invalid token address"
        require(_tokenAddress != address(0), "invalid token address");
        // 检查传入的代币地址映射的交易所地址不是零地址否则报错"exchange already exists"
        require(tokenToExchange[_tokenAddress] == address(0), "exchange already exists");
        // 建立交易所属性的变量，用new方法使用引入的Exchange并传入代币地址生成交易所赋值给变量
        Exchange exchange = new Exchange(_tokenAddress);
        // 用address函数传入上一行的交易所变量得到变量，再将这个地址赋值给代币地址对交易所的映射
        tokenToExchange[_tokenAddress] = address(exchange);
        // 触发创建事件
        emit NewExchange(_tokenAddress, address(exchange));
        // 用address函数传入上一行的交易所变量并返回
        return address(exchange);
    }

    /**
     * @dev 获取指定ERC20代币对应的交易所（Exchange）合约地址。
     * @param _tokenAddress ERC20代币合约地址
     * @return 该代币对应的交易所（Exchange）合约地址
     */
    function getExchange(address _tokenAddress) public view returns (address) {
        // 返回合约映射中传入代币地址后的交易所地址
        return tokenToExchange[_tokenAddress];
    }

}
