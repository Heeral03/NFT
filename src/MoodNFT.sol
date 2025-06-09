//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {ERC721} from "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
contract MoodNFT is ERC721{
    error MoodNFT__CantFlipIfNotOwner();
    uint256 tokenCounter;
    string private s_sadSVGImageURI;
    string private s_happySVGImageURI;
    
    enum Mood{
        HAPPY,
        SAD
    }
    mapping(uint256=>Mood) private s_tokenIdToMood;

    constructor (string memory sadSVGImageURI,string memory happySVGImageURI) ERC721("MoodNFT","MN"){
        tokenCounter=0;
        s_sadSVGImageURI=sadSVGImageURI;
        s_happySVGImageURI=happySVGImageURI;
    }

    function mintNft() public{
       
        _safeMint(msg.sender,tokenCounter);
        s_tokenIdToMood[tokenCounter]=Mood.HAPPY;
        tokenCounter++;

    }

    function flipMood(uint256 tokenId) public{
        //only nft woner should be able to flip the mood
        //_isApprovedOrOwner-->function in ERC721 standard
        if(getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender){

            revert MoodNFT__CantFlipIfNotOwner();
        }
        
        if(s_tokenIdToMood[tokenId]==Mood.HAPPY){
            s_tokenIdToMood[tokenId]=Mood.SAD;
        }

        else if(s_tokenIdToMood[tokenId]==Mood.SAD){
            s_tokenIdToMood[tokenId]=Mood.HAPPY;
        }

    }

    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64,";
    }
    function tokenURI(uint256 tokenId) public view override returns(string memory){
            string memory imageURI;
            if(s_tokenIdToMood[tokenId]==Mood.HAPPY){
                imageURI=s_happySVGImageURI;
            }
            else{
                imageURI=s_sadSVGImageURI;
            }
    return
        string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                             
                                '{"name: "',
                                    name(),
                                        '", description: "An NFT that reflects your mood!", "attributes": [{"trait_type": "Mood", "value": 100}], "image": ',
                                                imageURI,
                                    '"}'
                            
                    )
                )
            )
        )
    );
}

}
