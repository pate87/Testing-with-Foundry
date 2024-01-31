// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import { exp } from "../src/Exp.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

contract DifferentialTest is Test {
    using Strings for uint256;

    function ffi_exp(int128 x) private returns (int128) {
        string[] memory inputs = new string[](3);
        inputs[0] = "python"; // name of the interpreter
        inputs[1] = "exp.py"; // name of the python file containing exp function
        inputs[2] = uint256(int256(x)).toString(); // input argument passed as string

        bytes memory res = vm.ffi(inputs);

        int128 y = abi.decode(res, (int128));
        return y;
    }

    function test_exp(int128 x) public {
        vm.assume(x >= 2 ** 64);
        vm.assume(x <= 20 * 2 ** 64);

        int128 y0 = ffi_exp(x);
        int128 y1 = exp(x);

        // Check |y0 - y1| <= 1
        uint256 DELTA = 2 ** 64;
        assertApproxEqAbs(uint256(int256(y0)), uint256(int256(y1)), DELTA);
    }
}