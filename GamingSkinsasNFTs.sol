// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract GamingSkinsNFT {
    struct Skin {
        uint256 id;
        string name;
        string metadata;
        address owner;
    }

    mapping(uint256 => Skin) private skins;
    mapping(address => uint256[]) private ownedSkins;
    uint256 private nextSkinId;
    
    event SkinMinted(uint256 indexed id, string name, string metadata, address indexed owner);
    event SkinTransferred(uint256 indexed id, address indexed from, address indexed to);
    event SkinBurned(uint256 indexed id, address indexed owner);

    function mintSkin(string memory _name, string memory _metadata) public {
        uint256 skinId = nextSkinId++;
        skins[skinId] = Skin(skinId, _name, _metadata, msg.sender);
        ownedSkins[msg.sender].push(skinId);
        emit SkinMinted(skinId, _name, _metadata, msg.sender);
    }

    function transferSkin(uint256 _skinId, address _to) public {
        require(skins[_skinId].owner == msg.sender, "Not the owner");
        skins[_skinId].owner = _to;
        ownedSkins[_to].push(_skinId);
        emit SkinTransferred(_skinId, msg.sender, _to);
    }

    function burnSkin(uint256 _skinId) public {
        require(skins[_skinId].owner == msg.sender, "Not the owner");
        delete skins[_skinId];
        emit SkinBurned(_skinId, msg.sender);
    }

    function getSkin(uint256 _skinId) public view returns (Skin memory) {
        return skins[_skinId];
    }
}
