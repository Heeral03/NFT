//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {Script} from "../lib/forge-std/src/Script.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
contract DeployBasicNft is Script{
    BasicNFT basicNft;
    function run() external returns (BasicNFT){
        vm.startBroadcast();
        basicNft=new BasicNFT();
        vm.stopBroadcast();
        return basicNft;
    }
}