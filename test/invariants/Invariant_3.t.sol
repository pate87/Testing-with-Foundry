// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "forge-std/console.sol";

// Test contracts
import {WETH} from "../../src/WETH.sol";
import {Handler} from "./Invariant_2.t.sol";

// - Foundry test libraies
import {CommonBase} from "forge-std/Base.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {StdUtils} from "forge-std/StdUtils.sol";

contract ActorManager is CommonBase, StdCheats, StdUtils {
    Handler[] public handlers;

    constructor(Handler[] memory _handlers) {
        handlers = _handlers;
    }

    function sendToFallback(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].sendToFallback(amount);
    }

    function deposit(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].deposit(amount);
    }

    function withdraw(uint256 handlerIndex, uint256 amount) public {
        uint256 index = bound(handlerIndex, 0, handlers.length - 1);
        handlers[index].withdraw(amount);
    }
}

contract WETH_Multi_Handler_Invariant_Tests is Test {
    WETH public weth;
    ActorManager public manager;
    Handler[] public handlers;

    function setUp() public {
        weth = new WETH();

        // Deploy 3 handler contracts
        for (uint256 i = 0; i < 3; i++) {
            handlers.push(new Handler(weth));
            // Send 100 ETH to each handler contract
            deal(address(handlers[i]), 100 * 1e18); // send funds to handler contract
        }

        manager = new ActorManager(handlers);

        /**
         * - target contract
         */
        targetContract(address(manager)); // allow handler contract to be targeted
    }

    function invariant_eth_balance() public {
        uint256 total = 0;

        for (uint256 i = 0; i < handlers.length - 1; i++) {
            total += handlers[i].wethBalance();
        }
        console.log("Total WETH balance across handlers: ", total / 1e18);
        assertGe(address(weth).balance, total);
    }
}
