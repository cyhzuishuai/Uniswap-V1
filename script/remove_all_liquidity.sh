#!/bin/bash

# Load environment variables
source .env

echo "Starting to remove liquidity from all pools..."

# Check required environment variables
if [ -z "$PRIVATE_KEY" ]; then
    echo "Error: PRIVATE_KEY environment variable not set"
    exit 1
fi

if [ -z "$FACTORY_ADDRESS" ]; then
    echo "Error: FACTORY_ADDRESS environment variable not set"
    exit 1
fi

echo "Factory address: $FACTORY_ADDRESS"
echo "User address: $(cast wallet address --private-key $PRIVATE_KEY)"

# Run the remove all liquidity script
forge script script/RemoveAllLiquidity.s.sol:RemoveAllLiquidity --rpc-url $ETH_RPC_URL --broadcast

echo "All liquidity removal completed!" 