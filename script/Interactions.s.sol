//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {Script} from "../lib/forge-std/src/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DevOpsTools }from "../lib/foundry-devops/src/DevOpsTools.sol";

//work with most recently deployed nft-->use foundry devops

contract MintBasicNft is Script{
    string public constant PUG="ipfs://QmbGrX9X8ePa9C1D7iRymzRtDADAkwzv4ZC3tXyBZhV3hy";
    function run() external{
        address mostRecentlyDeployed= DevOpsTools.get_most_recent_deployment("BasicNFT",block.chainid);
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNFT(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
} 