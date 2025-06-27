forge script script/TransferERC20.s.sol:BatchTransferERC20 --rpc-url $ETH_RPC_URL --broadcast

forge script script/DeployToken.s.sol:DeployToken --rpc-url $ETH_RPC_URL --broadcast

forge script script/DeployExchange.s.sol:DeployExchange --rpc-url $ETH_RPC_URL --broadcast 

forge script script/DeployFactory.s.sol:DeployFactory --rpc-url $ETH_RPC_URL --broadcast

# 添加流动性到所有池子
forge script script/AddLiquidity.s.sol:AddLiquidity --rpc-url $ETH_RPC_URL --broadcast