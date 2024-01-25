// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {Auction} from "../src/Time.sol";

contract TimeTest is Test {

    Auction public auction;
    uint256 private startAt;

    function setUp() public {
        auction = new Auction();
        startAt = block.timestamp;
    }

    // vm.wrap - set block.timestamp to future timestamp
    // vm.roll - set block.number
    // skip - increment current timestamp
    // rewind - decrement current timestamp

    function testBidFAils() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

     function testFails_bid() public {
        // vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }
}