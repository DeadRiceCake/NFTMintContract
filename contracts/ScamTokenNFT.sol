// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract ScamToken is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    
    bool public paused = true;
    bool public whitelistMintEnabled = false;

    uint public price = 1000000 gwei;
    uint public maxSupply;
    uint public lastTokenId = 0;

    mapping(address => bool) private _whiteList;
    
    constructor(uint _maxSupply) ERC721("ScamToken", "ScamNFT") {
        maxSupply = _maxSupply;
    }

    modifier mintCompliance() {
        require(lastTokenId + 1 <= maxSupply, "Max supply exceeded!");
        _;
    }

    modifier mintPriceCompliance() {
        require(msg.value >= price, "Insufficient funds!");
        _;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function withdraw() public onlyOwner nonReentrant {
        (bool os, ) = payable(owner()).call{value: address(this).balance}('');
        require(os);
    }

    function safeMint(address _to, string memory _uri)
        public
        payable
        onlyOwner
        mintCompliance
        mintPriceCompliance
    {
        lastTokenId++;
        _safeMint(_to, lastTokenId);
        _setTokenURI(lastTokenId, _uri);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function setPrice(uint _price) public onlyOwner {
        price = _price;
    }

    function setWhiteList(address _address, bool _isWhiteList) public onlyOwner {
        _whiteList[_address] = _isWhiteList;
    }
}