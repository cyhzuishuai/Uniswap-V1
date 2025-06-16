forge script script/TransferERC20.s.sol:BatchTransferERC20 
--rpc-url https://eth-sepolia.g.alchemy.com/v2/AX0JipCwRGT_e633AvpHaqlIucHaQFpz 
--broadcast

forge script script/DeployToken.s.sol:DeployToken --rpc-url https://eth-sepolia.g.alchemy.com/v2/AX0JipCwRGT_e633AvpHaqlIucHaQFpz --broadcast

forge script script/DeployExchange.s.sol:DeployExchange --rpc-url https://eth-sepolia.g.alchemy.com/v2/AX0JipCwRGT_e633AvpHaqlIucHaQFpz --broadcast 

forge script script/DeployFactory.s.sol:DeployFactory --rpc-url https://eth-sepolia.g.alchemy.com/v2/AX0JipCwRGT_e633AvpHaqlIucHaQFpz --broadcast