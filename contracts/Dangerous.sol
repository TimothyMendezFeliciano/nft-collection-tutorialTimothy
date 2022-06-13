// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import { Base64 } from "./libraries/Base64.sol";

contract Dangerous is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = ["Man's", "First", "Disobedience", "andThe", "Fruit", "Forbidden", "Tree", "whoseMortalTaste","Brought", "Death"];
    string[] secondWords = ["praiseOfTheProwess", "peopleKings", "spearArmed", "Danes", "days", "long", "sped"];
    string[] thirdWords = ["TheWrathSing", "goddess", "Achilles", "destructiveWrath", "broughtCountlessWoes", "Achaeans", "sentForth", "Hades"];

    constructor() ERC721 ("DangerousNFT", "DANGER"){
        console.log("This is my Dangerous NFT! Beware.");
    }

    function pickFirstWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId))));
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    event NewDangerousNFTMinted(address sender, uint256 tokenId);

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function mintDangerousNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory firstWord = pickFirstWord(newItemId);
        string memory secondWord = pickSecondWord(newItemId);
        string memory thirdWord = pickThirdWord(newItemId);
        string memory combinedWord = string(abi.encodePacked(firstWord, secondWord, thirdWord));
        string memory finalSVG = string(abi.encodePacked(baseSvg, combinedWord, "</text></svg>"));

        string memory json = Base64.encode(
        bytes(
        string (
            abi.encodePacked(
                        '{"name": "',
                    // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                    // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSVG)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUri = string(
        abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, "ipfs://QmVk2EJUDxcMwmHPnSRsxky7dHv9yuQPgb9ea3ihmsy39g");
        _tokenIds.increment();
        console.log("Dangeours NFT minted to ", newItemId, msg.sender);
        emit NewDangerousNFTMinted(msg.sender, newItemId);
    }
}
