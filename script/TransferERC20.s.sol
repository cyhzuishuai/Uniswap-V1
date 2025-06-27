// 引入 Foundry 的 Script 库，提供脚本执行相关功能
import "forge-std/Script.sol";


interface IERC20 {
    function transfer(address to, uint256 amount) external returns (bool);
}
// 定义批量转账脚本合约，继承 Script 以便使用 Foundry 的脚本功能
contract BatchTransferERC20 is Script {
    // run() 是 Foundry 脚本的入口函数，forge script 会自动调用
    function run() external {
        // 从环境变量读取私钥（用于签名和发送交易），建议在 .env 文件中配置 PRIVATE_KEY
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        address[] memory tokens = new address [](5);
        address[] memory recipients = new address[](3);

        tokens[0] = vm.envAddress("TOKEN_ADDRESS_0");  // USDT
        tokens[1] = vm.envAddress("TOKEN_ADDRESS_1");  // USDC
        tokens[2] = vm.envAddress("TOKEN_ADDRESS_2");  // uni
        tokens[3] = vm.envAddress("TOKEN_ADDRESS_3");  // ens
        tokens[4] = vm.envAddress("TOKEN_ADDRESS_4"); //aave
        // 设置第一个收款人地址（请替换为实际地址）
        recipients[0] = 0x99D529952a3885C07178C747a5aBA93F03749BC9;
        recipients[1] = 0x8c06679B1E23C4962E8A781495f5DE625238C249;
        recipients[2] = 0x36Aad26065d45aD4B7d67104A6297E8B5835547E;

        // 要转账的代币数量（如 USDT 是18位小数，这里是1 USDT）
        uint256 amount = 10000 * 1e18;

        // 开始广播，后续所有链上操作都会用该私钥签名并发送到链上
        vm.startBroadcast(privateKey);

        // 遍历所有收款人，依次调用 ERC20 的 transfer 方法转账
        for(uint i = 0; i < tokens.length; i++){
            for(uint j = 0; j<recipients.length; j++){
                IERC20(tokens[i]).transfer(recipients[j], amount);
            }
            
        }
        // 停止广播，后续操作不会再发到链上
            vm.stopBroadcast();
    }
}