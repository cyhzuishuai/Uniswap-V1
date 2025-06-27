#!/bin/bash

# 加载环境变量
source .env

echo "开始添加USDT流动性..."

# 运行添加USDT流动性脚本
forge script script/AddUSDTLiquidity.s.sol:AddUSDTLiquidity --rpc-url $ETH_RPC_URL --broadcast

echo "USDT流动性添加完成！" 