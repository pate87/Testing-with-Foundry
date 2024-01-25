// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, stdError} from "forge-std/Test.sol";
import {EtherWallet} from "../src/Wallet.sol";

contract AuthenticateTest is Test {
    EtherWallet public authenticate;

    function setUp() public {
        authenticate = new EtherWallet();
    }

    function test_changeOwner() public {
        authenticate.changeOwner(address(1));
        assertEq(authenticate.owner(), address(1));
    }

    function testFail_changeOwner_notOwner() public {
        vm.prank(address(1));
        authenticate.changeOwner(address(1));
        assertEq(authenticate.owner(), address(1));

        assertEq(authenticate.owner(), address(1));
    }

    function testFail_changeOwner_wrongOwner() public {
        authenticate.changeOwner(address(1));
        vm.startPrank(address(1));
        authenticate.changeOwner(address(2));
        authenticate.changeOwner(address(1));
        authenticate.changeOwner(address(2));
        vm.stopPrank();

        authenticate.changeOwner(address(1));
    }
}
