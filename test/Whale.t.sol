// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/interfaces/IERC20.sol";

contract WhaleTest is Test {

    IERC20 public dai;

    function setUp() public {
        dai = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    }

    function testDeposit() public {
        address alice = address(1234);

        uint balBefor = dai.balanceOf(alice);
        console.log("Alice's balance before: ", balBefor / 1e18);

        uint totalBefore = dai.totalSupply();
        console.log("total before: ", totalBefore / 1e18);

        // Mint tokens and transfer to Alice
        deal(address(dai), alice, 1e6 * 1e18, true);

        uint balAfter = dai.balanceOf(alice);
        console.log("Alice's balance after: ", balAfter / 1e18);

        uint totalAfter = dai.totalSupply();
        console.log("total after", totalAfter / 1e18);
    }
}