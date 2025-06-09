//SPDX-License-Identifier:MIT
pragma solidity ^0.8.18;
import {ERC721} from "../../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Base64} from "../../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import {Test,console} from "../../lib/forge-std/src/Test.sol";
import {MoodNFT} from "../../src/MoodNFT.sol";
import {DeployMoodNFT} from "../../script/DeployMoodNFT.s.sol";
contract DeployMoodTest is Test{
    DeployMoodNFT deployer;
    MoodNFT moodNFT;
    function setUp() public{
        deployer=new DeployMoodNFT();
    }

function testConvertSVGToUri() public {
    string memory svg = '<svg viewBox="0 0 200 200" width="400" height="400" xmlns="http://www.w3.org/2000/svg"><circle cx="100" cy="100" fill="yellow" r="78" stroke="black" stroke-width="3"/><g class="eyes"><circle cx="70" cy="82" r="12"/><circle cx="127" cy="82" r="12"/></g><path d="m136.81 116.53c.69 26.17-64.11 42-81.52-.73" style="fill:none; stroke: black; stroke-width: 3;"/></svg>';

    string memory expectedURI = string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(bytes(svg))
        )
    );

    string memory actual = deployer.svgToImageURI(svg);

    assertEq(actual, expectedURI); // much better feedback if it fails
}


}