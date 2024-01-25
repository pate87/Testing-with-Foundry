// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Event} from "../src/Event.sol";
import {Test} from "forge-std/Test.sol";

contract EventTest is Test {
    Event public e;

    /**
     * Needs to have the same event included as the actual contract else the test will fail
     */
    event Transfer(address indexed from, address indexed to, uint256 amount);

    function setUp() public {
        e = new Event();
    }

    function testEmitTransferEvent() public {
        /**
         * Explanation of the vm.expectEmit function
         *
         * vm.expectEmit(bool checkTopic1, bool checkTopic2, bool checkTopic3, bool checkData)
         *
         * checkTopic1: check if the first topic matches
         * checkTopic2: check if the second topic matches
         * checkTopic3: check if the third topic matches
         * checkData: check if the data matches
         */

        /**
         * Steps to use vm.expectEmit
         * 1. Tell Foundry which data to check
         * 2. Call the function
         * 3. Tell Foundry what to expect
         */
        // Check index 1, index 2, and data
        vm.expectEmit(true, true, false, true);
        // 2 Emit the expected even
        emit Transfer(address(this), address(1337), 1337);
        // 3 Call the function that should emit the event
        e.transfer(address(this), address(1337), 1337);

        /**
         * Test with only one index to show the other data is not necessary and the test past even by entering wrong index data
         */
        // Check only index one
        vm.expectEmit(true, false, false, false);
        emit Transfer(address(this), address(1337), 1337);
        // Index 2 and data has wrong data but past the test
        e.transfer(address(this), address(7897), 344);
    }

    function testEmitManyTransferEvent() public {
        // Need to create a list of addresses
        address[] memory to = new address[](2);
        to[0] = address(123);
        to[1] = address(789);

        // and a list of amounts
        uint256[] memory amount = new uint256[](2);
        amount[0] = 123;
        amount[1] = 789;

        // Create a loop
        for (uint256 i = 0; i < to.length; i++) {
            // 1 Tell Foundry which data to check
            vm.expectEmit(true, true, false, true);
            // 2 Emit the expected event
            emit Transfer(address(this), to[i], amount[i]);
        }

        // 3 Call the function that should emit the event
        e.transferMany(address(this), to, amount);
    }
}
