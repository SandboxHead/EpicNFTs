// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";
import { Base64 } from "./libraries/Base64.sol";



contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    uint8 maxNFTs = 50;
    uint8 numNFTs = 0;

    string svg1 = "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='";
    string svg2 = "' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string[] firstWords = ["Sweaty", "Clingy", "Fuzzy", "Smooth", "Boring", "Bossy", "Nasty", "Lame", "Curious"];
    string[] secondWords = ["Pants", "Socks", "Shirt", "Hat", "Glasses", "Jeans", "Mask", "Gloves", "Shoes", "Slippers"];
    string[] thirdWords = ["Giraffe", "Elephant", "Lion", "Tiger", "Monkey", "Dog", "Cat", "Mouse", "Frog", "Whale", "Shark", "Bear", "Leopard"];
    string[] colorchars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'a', 'b', 'c', 'd', 'e', 'f'];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    constructor() ERC721 ("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract. Whoaa!");
    }

    function pickRandomFirstWord(uint256 tokenId) public view returns (string memory) {
        // I seed the random generator. More on this in the lesson. 
        uint256 rand = random(string(abi.encodePacked(Strings.toString(block.timestamp), Strings.toString(block.difficulty), "FIRST_WORD", Strings.toString(tokenId))));
        // Squash the # between 0 and the length of the array to avoid going out of bounds.
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(Strings.toString(block.timestamp), Strings.toString(block.difficulty), "SECOND_WORD", Strings.toString(tokenId))));
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId) public view returns (string memory) {
        uint256 rand = random(string(abi.encodePacked(Strings.toString(block.timestamp), Strings.toString(block.difficulty), "THIRD_WORD", Strings.toString(tokenId))));
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function pickRandomColor(uint256 tokenId) public view returns (string memory) {
        uint r1 = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, tokenId))) % 16;
        uint r2 = uint256(keccak256(abi.encodePacked(r1, block.timestamp, block.difficulty, tokenId))) % 16;
        uint g1 = uint256(keccak256(abi.encodePacked(r2, block.timestamp, block.difficulty, tokenId))) % 16;
        uint g2 = uint256(keccak256(abi.encodePacked(g1, block.timestamp, block.difficulty, tokenId))) % 16;
        uint b1 = uint256(keccak256(abi.encodePacked(g2, block.timestamp, block.difficulty, tokenId))) % 16;
        uint b2 = uint256(keccak256(abi.encodePacked(b1, block.timestamp, block.difficulty, tokenId))) % 16;
        string memory output = "#";
        return string(abi.encodePacked(output, colorchars[r1], colorchars[r2], colorchars[g1], colorchars[g2], colorchars[b1], colorchars[b2]));

        // return string(bytes.concat("#", bytes(colorchars[r1]), bytes(colorchars[r2]), bytes(colorchars[g1]), bytes(colorchars[g2]), bytes(colorchars[b1]), bytes(colorchars[b2])));
    }


    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function makeAnEpicNFT() public {
        require(numNFTs < maxNFTs, "Maximum number of NFTs reached");
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory randomColor = pickRandomColor(newItemId);
        string memory combinedWord = string(abi.encodePacked(first, second, third));
        
        string memory finalSvg = string(abi.encodePacked(svg1, randomColor, svg2, combinedWord, "</text></svg>"));


        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log("An NFT w/ ID %s has been minted to %s", newItemId, msg.sender);
        _tokenIds.increment();
        numNFTs += 1;
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }

    function getMintedNFTs() public view returns (uint8) {
        return numNFTs;
    }
    
    function getMaxNFTs() public view returns (uint8) {
        return maxNFTs;
    }

}