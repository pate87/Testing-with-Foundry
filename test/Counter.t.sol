// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
    }

    /**
     * Test inc function
     */
    function test_inc() public {
        counter.inc();
        assertEq(counter.count(), 1);
    }

    /**
     * It is important to write Fail to testing for failures
     * - This test is testing whether there is an error no matter which one
     * - Works for fast testing but isn't percise
     */
    function testFailDec() public {
        counter.dec();
    }

    /**
     * This test is more percise and expect a revert error
     * However, we don't use a specific argument here so we don't know the exact error
     */
    function test_Revert_CannotSubtract0_dec() public {
        vm.expectRevert();
        counter.dec();
    }

    /**
     * This test is even more percise and the argument shows that we expect an exact Undderflow error.
     * To use stdError it's necessary to import it else there is an error message `Undeclared identifier`
     */
    function test_Reevert_Underflow_dec() public {
        vm.expectRevert(stdError.arithmeticError);
        counter.dec();
    }

    /**
     * Test dec function
     */
    function test_dec() public {
        assertEq(counter.count(), 0);
        counter.inc();
        assertEq(counter.count(), 1);
        counter.inc();
        assertEq(counter.count(), 2);

        counter.dec();
        assertEq(counter.count(), 1);
    }
}
