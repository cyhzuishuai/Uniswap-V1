# Uniswap v1 智能合约接口设计文档

## 概述

Uniswap v1 是基于以太坊的去中心化交易所（DEX），采用恒定乘积自动做市（AMM）模型，支持 ETH 与 ERC20 代币的兑换以及流动性提供。本文档详细说明前端应用如何与 Uniswap v1 智能合约交互，实现代币兑换、流动性管理等核心功能。

## 核心功能接口

## Exchange合约

### 1. ETH 兑换代币

```
用户支付 ETH 兑换指定代币，支持滑点控制
function: "ethToTokenSwap" public payable
arguments: [
	uint256 min_tokens,   // 最小接收的代币数量
]
return[]
```

### 2.代币兑换 ETH

```
用户支付代币兑换 ETH，支持滑点控制
function: tokenToEthSwap public
arguments:[
	uint256 tokens_sold // 卖出的代币数量
	uint256 min_eth // 最小接收的ETH数量（滑点保护）
]
return: []
```

### 3.代币兑换代币

```
用户支付代币兑换代币，支持滑点控制
function: tokenToTokenSwap public
arguments:[
	uint256 _tokensSold // 卖出的代币数量
	uint256 _minTokensBought // 最小接收的目标代币数量（滑点保护）
	address _tokenAddress // 目标代币的地址
]  
return: []
```

### 4.添加流动性

```
用户添加流动性
function: addLiquidity public payable
arguments:[
	uint256 _tokenAmount // 添加的代币数量
]
return:[
	uint256 liquidlity// 获得的LP代币数量
]
```

### 5.移除流动性

```
用户移除流动性
function: removeLiquidity public
arguments:[
	uint256 _amount // 销毁的LP代币数量
]
return:[
	uint256 ethAmount // 获得的ETH数量
	uint256 tokenAmount // 获得的代币数量
]
```

### 6.获取当前交易所代币储备量

```
获取当前交易所中代币的储备量
function: getReserve public view
arguments: []
return:[
	uint256 // 当前交易所中代币的储备量
]
```

### 7.计算用ETH换取代币的数量

```
计算用ETH换取代币的数量
function: getTokenAmount public view
arguments:
	uint256 _ethSold // 卖出的ETH数量
return:
	uint256 // 可获得的代币数量
```

### 8.计算用代币换取ETH的数量

```
计算用代币换取ETH的数量
function: getEthAmount public view
arguments:
	uint256 _tokenSold // 卖出的代币数量
return:
	uint256 // 可获得的ETH数量
```

### **9.计算价格比率**

```
计算价格比率 比如1个ETH可以换多少DAI
function: getPrice public pure
arguments:[
	uint256 inputReserve // 输入代币的储备量
	uint256 outputReserve // 输出代币的储备量
]
return:
uint256 // 价格比率（放大1000倍）
```

## Factory合约

### 1.创建新的交易所（Exchange）

```
创建新的交易所（Exchange）
function: createExchange public
arguments:
	address _tokenAddress // 需要创建交易所的ERC20代币合约地址
return:
	address // 新创建的交易所（Exchange）合约地址
```

### 2.获取指定代币对应的交易所地址

```
获取指定代币对应的交易所地址
function: getExchange public view
arguments:
	address _tokenAddress // ERC20代币合约地址
return:
	address // 该代币对应的交易所（Exchange）合约地址
```

## 构造函数

### Token 合约构造函数

```
Token 合约构造函数
function: constructor
arguments:
	string memory name // 代币名称
	string memory symbol // 代币符号
	uint256 initialSupply // 初始发行总量
说明：
部署合约时设置代币名称、符号和初始供应量，并将初始代币全部分配给部署者。
```

### Factory 合约构造函数

```
Factory 合约构造函数
function: constructor
arguments: []
说明：
Factory合约没有参数的构造函数，部署时无需传入任何参数。
```

### Exchange 合约构造函数

```
Exchange 合约构造函数
function: constructor
arguments:
address _token // 该交易所对应的ERC20代币合约地址
说明：
部署时指定该交易所服务的ERC20代币地址，并初始化LP代币的名称、符号和小数位数。
```

