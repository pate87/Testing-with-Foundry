// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import "../src/GaslessTokenTransfer.sol";
import "../src/ERC20Permit.sol";

contract GaslessTokenTransferTest is Test {
    ERC20Permit private token;
    GaslessTokenTransfer private gasless;

    // Testing parameters
    address sender;
    address receiver;
    uint256 constant privatekey = 123;
    uint256 constant AMOUNT = 1000;
    uint256 constant FEE = 10;

    function setUp() public {
        // Set up accounts
        sender = vm.addr(privatekey);
        receiver = address(2);

        token = new ERC20Permit("Token", "TKN", 18);
        token.mint(sender, AMOUNT + FEE);

        gasless = new GaslessTokenTransfer();
    }

    function testValidSig() public {
        // Helper
        uint256 deadline = block.timestamp + 60;

        // Prepare permit message
        bytes32 permitHash = _getPermitHash(
            sender, // = owner
            address(gasless), // = spender
            AMOUNT + FEE, // = value
            token.nonces(sender),
            deadline
        );

        // vm.sign(private key, message hash)
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privatekey, permitHash);

        // Execute send functtion from GaselssTokenTransfer contract
        gasless.send(
            address(token),
            sender,
            receiver,
            AMOUNT,
            FEE,
            // inputs for permit function
            deadline,
            v,
            r,
            s
        );

        // Check token balances
        assertEq(token.balanceOf(sender), 0, "Sender balance should be 0");
        assertEq(token.balanceOf(receiver), AMOUNT, "Receiver balance should be amount");
        assertEq(token.balanceOf(address(this)), FEE, "Contract fee balance should be fee amount");
    }

    function _getPermitHash(address owner, address spender, uint256 value, uint256 nonce, uint256 deadline)
        private
        view
        returns (bytes32)
    {
        return keccak256(
            abi.encodePacked(
                "\x19\x01",
                token.DOMAIN_SEPARATOR(),
                keccak256(
                    abi.encode(
                        keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"),
                        owner,
                        spender,
                        value,
                        nonce,
                        deadline
                    )
                )
            )
        );
    }
}
