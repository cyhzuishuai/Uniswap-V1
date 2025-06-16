// SPDX-License-Identifier: MIT
import "forge-std/Script.sol";

import "../src/Token.sol";

contract DeployToken is Script {
    function run() public {
        uint256 privateKey = 0xb5d3740da94e3f1f4bd23e714247a55223c6cc1a7599d0d1e5eeef999ff79909;
        vm.startBroadcast(privateKey);

        string memory name = "TestToken";
        string memory symbol = "TT";
        uint256 initialSupply = 10000 * 1e18;
        Token token = new Token(name, symbol, initialSupply);

        vm.stopBroadcast();

        console.log("Token deployed at", address(token));
    }
}