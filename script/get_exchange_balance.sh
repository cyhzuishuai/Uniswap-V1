#!/bin/bash

echo "Starting USDT exchange balance query..."

# Run USDT exchange balance query script
forge script script/GetExchangeBalance.s.sol:GetExchangeBalance --rpc-url $ETH_RPC_URL

echo "USDT exchange balance query completed!" 