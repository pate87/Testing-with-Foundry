// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Wallet} from "../src/Wallet.sol";

// Examples of deal and hoax
// deal(address, uint) - Set balance of address
// hoax(address, uint) - deal + prank, Sets up a prank and set balance

contract WalletTest is Test {
    Wallet wallet;

    function setUp() public {
        wallet = new Wallet{value: 1e18}();
    }

    // Helper function
    function _send(uint256 amount) private {
        (bool ok,) = address(wallet).call{value: amount}("");
        require(ok, "Send ETH failed");
    }

    function testEthBalance() public view {
        console.log("ETH balance", address(this).balance / 1e18);
    }

    function testSendETH() public {
        // Store wallet balance
        uint256 bal = address(wallet).balance;

        // deal(address, uint) - Set balance of address
        deal(address(1), 100);
        assertEq(address(1).balance, 100);

        deal(address(1), 10);
        assertEq(address(1).balance, 10);

        // hoax(address, uint) - deal + prank, Sets up a prank and set balance
        // This is the hoax test using deal and prank
        deal(address(1), 123);
        vm.prank(address(1));
        _send(123);

        // Using hoax
        hoax(address(1), 456);
        _send(456);

        // Check wallet balance
        assertEq(address(wallet).balance, bal + 123 + 456);
    }
}
