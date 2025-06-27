#!/bin/bash

# 加载环境变量
source .env

echo "开始为所有池子添加流动性..."

# 运行添加流动性脚本
forge script script/AddLiquidity.s.sol:AddLiquidity --rpc-url $ETH_RPC_URL --broadcast

echo "流动性添加完成！" 