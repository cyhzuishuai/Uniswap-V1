#!/bin/bash

# 加载环境变量
source .env

echo "开始移除USDT流动性..."

# 运行移除USDT流动性脚本
forge script script/RemoveUSDTLiquidity.s.sol:RemoveUSDTLiquidity --rpc-url $ETH_RPC_URL --broadcast

echo "USDT流动性移除完成！" 