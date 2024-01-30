// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";

contract SignTest is Test {
    // private key = 123
    // public key = vm.addr(private key)
    // message = "secret message"
    // message hash = keccak256(message)
    // vm.sign(private key, message hash)

    function testSignature() public {
        // private key = 123
        uint256 privateKey = 123;

        // public key = vm.addr(private key)
        address publicKey = vm.addr(privateKey);

        // message = "secret message"
        string memory message = "secret message";

        // message hash = keccak256(message)
        bytes32 messageHash = keccak256(bytes(message));

        // vm.sign(private key, message hash)
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, messageHash);

        address signer = ecrecover(messageHash, v, r, s);

        assertEq(signer, publicKey);

        /**
         * Test against signaure
         */

        bytes32 invalidMessageHash = keccak256(bytes("Invalid message"));

        address incorrectSigner = ecrecover(bytes32(invalidMessageHash), v, r, s);

        assertTrue(incorrectSigner != publicKey);
    }
}
