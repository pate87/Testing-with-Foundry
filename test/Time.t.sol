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

    function testRevert_BidFAilsBeforeStartTime_startAt() public {
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testBid() public {
        vm.warp(startAt + 1 days);
        auction.bid();
    }

    function testRevert_BidFailsAfterEndTime_endAt() public {
        vm.warp(startAt + 3 days);
        vm.expectRevert(bytes("cannot bid"));
        auction.bid();
    }

    function testTimestamp() public {
        uint256 t = block.timestamp;

        // skip - increment current timestamp
        skip(100);
        assertEq(block.timestamp, t + 100);

        // rewind - decrement current timestamp
        rewind(10);
        assertEq(block.timestamp, t + 100 - 10);
    }

    function testBlocknumber() public {
        // vm.roll - set block.number
        vm.roll(999);
        assertEq(block.number, 999);
    }
}
