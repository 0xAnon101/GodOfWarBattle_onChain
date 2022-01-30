//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.4;
import "hardhat/console.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "./libraries/Base64.sol";

contract GodOfWarBattle is ERC721 {
    struct CharacterAttributes {
        uint32 hp;
        uint32 maxHp;
        uint32 characterIndex;
        uint32 attackDamage;
        string name;
        string imageURI;
    }

    // relates the nftholder with the tokenId they own
    mapping(address => uint256) public nftHolders;
    // relates tokenId with the character attributes
    mapping(uint256 => CharacterAttributes) public nftHoldersAttributes;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    CharacterAttributes[] defaultCharacters;

    event NewRareNFTMinted(address indexed owner, uint256 indexed tokenIndex);

    // Initialize the contract with default character attributes and NFT name
    constructor(
        string[] memory _names,
        string[] memory _imageURI,
        uint32[] memory _hp,
        uint32[] memory _attackDamage
    ) ERC721("GodOfWarBattle", "GODB") {
        for (uint32 i = 0; i < _names.length; i++) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    attackDamage: _attackDamage[i],
                    name: _names[i],
                    imageURI: _imageURI[i],
                    hp: _hp[i],
                    maxHp: _hp[i]
                })
            );
            console.log("defaultCharacters Initialized");
        }
        _tokenIds.increment();
    }

    function mintCharacterNFT(uint32 _characterIndex) external {
        uint256 newItemId = _tokenIds.current();
        // safely minting the newItemId to the caller
        _safeMint(msg.sender, newItemId);
        // assigning tokenId with their own set of attributes/powerups
        nftHoldersAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            attackDamage: defaultCharacters[_characterIndex].attackDamage,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp
        });
        // assigning the caller it's minted newItemId
        nftHolders[msg.sender] = newItemId;
        emit NewRareNFTMinted(msg.sender, newItemId);

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        _tokenIds.increment();
    }
}
