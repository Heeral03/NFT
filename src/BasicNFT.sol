//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
contract BasicNFT is ERC721{

    //tracks the number of nfts minted
    uint256 private tokenCounter;

    constructor() ERC721("Doggie","Dog"){
        tokenCounter=0;
    }

    //Maps each token ID to its IPFS metadata URI 
    mapping(uint256=>string) private s_tokenIdToUri;


    
    function mintNft(string memory tokenUri)public{
        s_tokenIdToUri[tokenCounter]=tokenUri;
        _safeMint(msg.sender,tokenCounter);
        tokenCounter++;
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory) {
        return s_tokenIdToUri[tokenId];
    }

}