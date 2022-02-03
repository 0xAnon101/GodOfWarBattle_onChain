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
        uint32 superAttackDamage;
        uint32 defense;
        string name;
        string imageURI;
    }

    struct BigBoss {
        uint32 hp;
        uint32 maxHp;
        uint32 attackDamage;
        string name;
        string imageURI;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // relates the nftholder with the tokenId they own
    mapping(address => uint256) public nftHolders;
    // relates tokenId with the character attributes
    mapping(uint256 => CharacterAttributes) public nftHoldersAttributes;

    CharacterAttributes[] defaultCharacters;
    BigBoss public bigBoss;

    event CharacterNFTMinted(
        address sender,
        uint256 tokenId,
        uint256 characterIndex
    );
    event AttackComplete(uint256 newBossHp, uint256 newPlayerHp);

    // Initialize the contract with default character attributes and NFT name
    constructor(
        string[] memory _names,
        string[] memory _imageURI,
        uint32[] memory _hp,
        uint32[] memory _attackDamage,
        uint32[] memory _superAttackDamage,
        uint32[] memory _defense,
        string memory bossName,
        string memory bossImageURI,
        uint32 bossHp,
        uint32 bossAttackDamage
    ) ERC721("GodOfWarBattle", "GODB") {
        bigBoss = BigBoss({
            hp: bossHp,
            maxHp: bossHp,
            attackDamage: bossAttackDamage,
            name: bossName,
            imageURI: bossImageURI
        });
        console.log("BigBoss Initialized");

        for (uint32 i = 0; i < _names.length; i++) {
            defaultCharacters.push(
                CharacterAttributes({
                    characterIndex: i,
                    attackDamage: _attackDamage[i],
                    superAttackDamage: _superAttackDamage[i],
                    defense: _defense[i],
                    name: _names[i],
                    imageURI: _imageURI[i],
                    hp: _hp[i],
                    maxHp: _hp[i]
                })
            );
            console.log("defaultCharacters Initialized: ", _names[i]);
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
            superAttackDamage: defaultCharacters[_characterIndex]
                .superAttackDamage,
            defense: defaultCharacters[_characterIndex].defense,
            name: defaultCharacters[_characterIndex].name,
            imageURI: defaultCharacters[_characterIndex].imageURI,
            hp: defaultCharacters[_characterIndex].hp,
            maxHp: defaultCharacters[_characterIndex].maxHp
        });
        // assigning the caller it's minted newItemId
        nftHolders[msg.sender] = newItemId;
        emit CharacterNFTMinted(msg.sender, newItemId, _characterIndex);

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex,
            nftHoldersAttributes[newItemId].imageURI
        );

        _tokenIds.increment();
    }

    function checkIfUserHasNFT()
        public
        view
        returns (CharacterAttributes memory)
    {
        uint256 userNftTokenId = nftHolders[msg.sender];
        if (userNftTokenId > 0) {
            return nftHoldersAttributes[userNftTokenId];
        } else {
            CharacterAttributes memory emptyData;
            return emptyData;
        }
    }

    function getAllDefaultCharacters()
        public
        view
        returns (CharacterAttributes[] memory)
    {
        return defaultCharacters;
    }

    function getBoss() public view returns (BigBoss memory) {
        return bigBoss;
    }

    function attackBoss() public {
        require(bigBoss.hp > 0, "Big boss hp is below zero!");
        // fetch the character NFT attributes
        CharacterAttributes storage player = nftHoldersAttributes[
            nftHolders[msg.sender]
        ];

        require(player.hp > 0, "Character HP is less than or equal to zero!");
        console.log(
            "\nPlayer w/ character %s about to attack. Has %s HP and %s AD",
            player.name,
            player.hp,
            player.attackDamage
        );
        console.log(
            "Boss %s has %s HP and %s AD",
            bigBoss.name,
            bigBoss.hp,
            bigBoss.attackDamage
        );

        // reduce the bigBoss hp when player makes a damage
        if (bigBoss.hp < player.attackDamage) {
            bigBoss.hp = 0;
            console.log("you have successfully defeated the boss");
        } else {
            bigBoss.hp -= player.attackDamage;
        }

        // reduce the player hp when bigBoss makes a damage
        if (player.hp < bigBoss.attackDamage) {
            player.hp = 0;
            console.log("Boss actually killed you. You can't revive now!");
        } else {
            player.hp = player.hp - bigBoss.attackDamage;
        }

        console.log("Player attacked boss. New boss hp: %s", bigBoss.hp);
        console.log("Boss attacked player. New player hp: %s\n", player.hp);
        emit AttackComplete(bigBoss.hp, player.hp);
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        CharacterAttributes memory cAttributes = nftHoldersAttributes[_tokenId];
        string memory strHp = Strings.toString(cAttributes.hp);
        string memory strMaxHp = Strings.toString(cAttributes.maxHp);
        string memory strAttackDamage = Strings.toString(
            cAttributes.attackDamage
        );
        string memory strSuperAttackDamage = Strings.toString(
            cAttributes.superAttackDamage
        );
        string memory strDefense = Strings.toString(cAttributes.defense);

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                cAttributes.name,
                " -- NFT #: ",
                Strings.toString(_tokenId),
                '", "description": "This is an NFT that lets people play in the game Metaverse Slayer!", "image": "',
                cAttributes.imageURI,
                '", "attributes": [ { "trait_type": "Health Points", "value": ',
                strHp,
                ', "max_value":',
                strMaxHp,
                '}, { "trait_type": "Attack Damage", "value": ',
                strAttackDamage,
                '}, { "trait_type": "Super Attack Damage", "value": ',
                strSuperAttackDamage,
                '}, { "trait_type": "Defense", "value": ',
                strDefense,
                "} ]}"
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }
}
