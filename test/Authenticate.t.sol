// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {Wallet} from "../src/Wallet.sol";

contract AuthenticateTest is Test {
    Wallet public authenticate;

    function setUp() public {
        authenticate = new Wallet();
    }

    function test_setOwner() public {
        authenticate.setOwner(address(1));
        assertEq(authenticate.owner(), address(1));
    }

    function testFail_setOwner_notOwner() public {
        vm.prank(address(1));
        authenticate.setOwner(address(1));
        assertEq(authenticate.owner(), address(1));

        assertEq(authenticate.owner(), address(1));
    }

    function testFail_setOwner_wrongOwner() public {
        authenticate.setOwner(address(1));
        vm.startPrank(address(1));
        authenticate.setOwner(address(2));
        authenticate.setOwner(address(1));
        authenticate.setOwner(address(2));
        vm.stopPrank();

        authenticate.setOwner(address(1));
    }
}
