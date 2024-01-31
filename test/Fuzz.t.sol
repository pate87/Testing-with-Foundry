// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import {Bit} from "../src/Bit.sol";

// Topics
// - fuzz
// - assume and bound
// - stats
//   (runs: 256, μ: 18301, ~: 10819)
//   runs - number of tests
//   μ - mean gas used
//   ~ - median gas used

contract FuzzTest is Test {
    Bit private bit;

    function setUp() public {
        bit = new Bit();
    }

    // Helper function to generate random inputs for fuzz testing
    function testMostSignificantBit(uint256 x) private pure returns (uint256) {
        uint256 i = 0;
        while ((x >>= 1) > 0) {
            i++;
        }
        return i;
    }

    function testMostSignificantBitManual() public {
        assertEq(bit.mostSignificantBit(0), 0);
        assertEq(bit.mostSignificantBit(1), 0);
        assertEq(bit.mostSignificantBit(2), 1);
        assertEq(bit.mostSignificantBit(4), 2);
        assertEq(bit.mostSignificantBit(8), 3);
        assertEq(bit.mostSignificantBit(type(uint256).max), 255);
    }

    function testMostSignificantBitFuzz(uint256 x) public {
        // assume - If false, the fuzzer will discard the current fuzz inputs
        //          and start a new fuzz run with different inputs
        // Skip X = 0
        vm.assume(x > 0);
        assertGt(x, 0);

        // bound(input, min, max) - bound input between min and max
        x = bound(x, 1, 10);
        assertGe(x, 1);
        assertLe(x, 10);

        //
        uint256 i = bit.mostSignificantBit(x);
        assertEq(i, testMostSignificantBit(x));
    }
}
