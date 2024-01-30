// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// Declare token contract interface and functions of ERC-20 standard
interface IWETH {
    function balanceOf(address) external view returns (uint256);
    function deposit() external payable;
}

contract ForkTest is Test {
    IWETH private weth;

    function setUp() public {
        weth = IWETH(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
    }

    function testWeth() public {
        uint256 balBefor = weth.balanceOf(address(this));
        console.log("balance before: ", balBefor);

        weth.deposit{value: 100}();

        uint256 balAfter = weth.balanceOf(address(this));
        console.log("balance after: ", balAfter);
    }
}
