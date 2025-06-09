// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import { IntentsManager } from "./IntentsManager.sol";
import { CoWMatcher } from "./CoWMatcher.sol";
import { CFMMAdapter } from "./CFMMAdapter.sol";

contract SolverRouter {
    // Reference to your CoWMatcher contract
    CoWMatcher public cowMatcher;
    // Reference to your CFMMAdapter contract
    CFMMAdapter public cfmmAdapter;
    // Reference to IntentsManager to update intent states
    IntentsManager public intentsManager;

    // Entry function for solvers
    function solve(uint256 intentId, uint256 matchedIntentId, uint256 minAmountOut) external {
        // Check if the intents are still open and valid
        require(intentsManager.isPending(intentId), "Intent not pending");
        require(intentsManager.isPending(matchedIntentId), "Matched intent not pending");

        // Try to match using CoWMatcher
        if (cowMatcher.canMatch(intentId, matchedIntentId)) {
            cowMatcher.executeCoWTrade(intentId, matchedIntentId);
        }
        
        else {
            // Fallback to CFMM swap (e.g. Uniswap)
            IntentsManager.Intent memory intent = intentsManager.getIntent(intentId);

            // Approve and call CFMM swap via adapter
            cfmmAdapter.swap(
                intent.tokenIn,
                intent.tokenOut,
                intent.amountIn,
                minAmountOut
            );
        }

        // Mark intents as fulfilled
        intentsManager.markFulfilled(intentId);
        intentsManager.markFulfilled(matchedIntentId);

        // Emit event for off-chain indexers/solvers
        emit TradeExecuted(intentId, matchedIntentId);
    }
}
