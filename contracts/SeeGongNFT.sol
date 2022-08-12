// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SeeGongToken is ERC721, ERC721URIStorage, Ownable, ReentrancyGuard {
    
    bool public paused = true;
    bool public whitelistMintEnabled = false;

    uint public maxSupply;
    uint public price;
    uint public lastTokenId = 0;

    mapping(address => bool) private _whiteList;
    
    constructor(uint _maxSupply, uint _price) ERC721("SeeGongToken", "SeegongNFT") {
        maxSupply = _maxSupply;
        price = _price;
    }

    modifier mintMaxSupply() {
        require(lastTokenId + 1 <= maxSupply, "Max supply exceeded");
        _;
    }

    modifier mintPriceCheck() {
        require(msg.value >= price, "Insufficient ETH");
        _;
    }

    modifier whiteListCheck(address _address) {
        require(_whiteList[_address], "Address not exist in whitelist");
        _;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    function withdraw() public onlyOwner nonReentrant {
        (bool os, ) = payable(owner()).call{value: address(this).balance}('');
        require(os);
    }

    function whiteListMint(address _to, string memory _uri)
        public
        payable
        mintMaxSupply
        mintPriceCheck
        whiteListCheck(_to)
    {
        require(paused == false && whitelistMintEnabled == true, "It's not minting period for whitelist members");
        lastTokenId++;
        _safeMint(_to, lastTokenId);
        _setTokenURI(lastTokenId, _uri);
    }

    function safeMint(address _to, string memory _uri)
        public
        payable
        mintMaxSupply
        mintPriceCheck
    {
        require(paused == false, "It's not minting period");
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

    function setPaused(bool _pause) public onlyOwner {
        paused = _pause;
    }

    function setWhitelistMintEnabled(bool _enabled) public onlyOwner {
        whitelistMintEnabled = _enabled;
    }
}
