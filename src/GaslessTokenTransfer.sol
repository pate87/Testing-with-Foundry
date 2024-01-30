// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./interfaces/IERC20Permit.sol";

contract GaslessTokenTransfer {
    function send(
        address token,
        address sender,
        address receiver,
        uint256 amount,
        uint256 fee,
        // inputs for permit function
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external {
        // permit - sender approves this contract to spend amount + fee
        IERC20Permit(token).permit(
            sender, // = owner
            address(this), // = spender
            amount + fee, // = amount + fee
            deadline,
            v,
            r,
            s
        );

        // transferFrom - (sender, receiver, amount)
        IERC20Permit(token).transferFrom(sender, receiver, amount);

        // transferFrom(sender, msg.sender, fee)
        IERC20Permit(token).transferFrom(sender, msg.sender, fee);
    }
}
