//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {Test} from "../../lib/forge-std/src/Test.sol";
import {BasicNFT} from "../../src/BasicNFT.sol";
import {DeployBasicNft}from "../../script/DeployBasicNft.s.sol";
contract TestNft is Test{
    DeployBasicNft public deployer;
    BasicNFT public basicNft;
    address public USER=makeAddr("USER");
    string public constant PUG="ipfs://QmbGrX9X8ePa9C1D7iRymzRtDADAkwzv4ZC3tXyBZhV3hy";
    function setUp() public{
        deployer=new DeployBasicNft();
        basicNft=deployer.run();
    }
    function testNameIsCorrect() public {
        string memory expectedName="Doggie";
        string memory actualName=basicNft.name();

       assertEq(expectedName,actualName);
    }

    function testCanMintAndHaveBalance() public{
        vm.prank(USER);
        basicNft.mintNft(PUG);
        //checks if user now owns 1NFT
        assert(basicNft.balanceOf(USER)==1);

        //tokenURI(0) should return the same IPFS link PUG that was used during minting.
        //This ensures the metadata (image, traits, etc.) is linked correctly to token ID 0.
        assert(keccak256(abi.encodePacked(PUG))==keccak256(abi.encodePacked(basicNft.tokenURI(0))));
    }
}
