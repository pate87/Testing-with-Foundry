// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Error} from "../src/Error.sol";
import {Test} from "forge-std/Test.sol";

contract ErrorTest is Test {
    Error public err;

    function setUp() public {
        err = new Error();
    }

    /**
     * Test for any error using Fail in the function name
     */
    function testFail() public view {
        err.throwError();
    }

    /**
     * Test for any error using Revert in the function name and use vm.expectRevert to test for revert
     */
    function testRevert() public {
        vm.expectRevert();
        err.throwError();
    }

    /**
     * Test reverted message using vm.expectRevert with exact message from contract
     */
    function testRequireMessage() public {
        vm.expectRevert(bytes("Not Authorized"));
        err.throwError();
    }

    /**
     * Test costum error using vm.expectRevert
     */
    function testCostumeError() public {
        vm.expectRevert(Error.NotAuthorized.selector);
        err.throwCustomError();
    }

    /**
     * Test costum error using vm.expectRevert like explained in the Foundry book
     */
    function testRevert_causesCustomError() public {
        vm.expectRevert(abi.encodeWithSelector(Error.NotAuthorized.selector));
        err.throwCustomError();
    }
}
