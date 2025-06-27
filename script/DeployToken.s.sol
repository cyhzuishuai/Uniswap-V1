// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

import "../src/Token.sol";

contract DeployToken is Script {
    function run() public {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(privateKey);

        string memory name = "TestToken";
        string memory symbol = "TT";
        uint256 initialSupply = 10000 * 1e18;
        Token token = new Token(name, symbol, initialSupply);

        vm.stopBroadcast();

        console.log("Token deployed at", address(token));
    }
}