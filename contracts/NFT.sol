// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract NFT is ERC721,  ERC721Enumerable, ERC721URIStorage  {
    
    using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    address private owner;
    mapping (uint256 => string) private _tokenURIs;
    
    // Base URI
    string private _baseURIextended;

    // vote
    enum Vote {
        NO_VOTE,
        LIKE,
        DISLIKE
    }
    mapping(uint256 => mapping(address => Vote)) public votes;
    mapping(uint256 => uint256) public likeCount;
    mapping(uint256 => uint256) public dislikeCount;

    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol) {
        owner = msg.sender;
    }

    function setBaseURI(string memory baseURI_) external {
        _baseURIextended = baseURI_;
    }
    
    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual 
        override(ERC721URIStorage){
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }
    
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseURIextended;
    }
    
    function tokenURI(uint256 tokenId) public view virtual override(ERC721, ERC721URIStorage) returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
        
        // If there is no base URI, return the token URI.cons
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }
    /*burn
     *
     */
    function burnNFT(
        uint256 tokenId
	) 
        public returns (uint256) {
        require(msg.sender == ownerOf(tokenId),"Only the owner of this Token could Burn It!");
        _burn(tokenId);
	return tokenId;
    }
    function mintNFT(
        address _to,
        string memory tokenURI_
    ) public returns (uint256){
      _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(_to, newItemId);
        _setTokenURI(newItemId, tokenURI_);

        return newItemId;
    }

    function transNFT(
	address _from,
	address _to,
        uint256 tokenId
	) 
        public returns (uint256) {
        require(msg.sender == ownerOf(tokenId),"Only the owner of this Token could transfer It!");
        transferFrom(_from,_to,tokenId);
	return tokenId;
    }

    function destroy() virtual public {
	require(msg.sender == owner,"Only the owner of this Contract could destroy It!");
        selfdestruct(payable(owner));
    }

    function walletOfOwner(address _owner)
        public
        view
        returns (uint256[] memory)
    {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }
    function like(address sender, uint256 tokenId) public returns (uint256){
        require(votes[tokenId][sender] == Vote.NO_VOTE);
        votes[tokenId][sender] = Vote.LIKE;
        likeCount[tokenId] = likeCount[tokenId] + 1;
        return likeCount[tokenId];
    }    

    function deleteLike(address sender, uint256 tokenId) public returns (uint256) {
        require(votes[tokenId][sender] == Vote.LIKE);
        votes[tokenId][sender] = Vote.NO_VOTE;
        likeCount[tokenId] -= 1;
        return likeCount[tokenId];
    }
    
    function dislike(address sender, uint256 tokenId) public returns (uint256) {
        require(votes[tokenId][sender] == Vote.NO_VOTE);
        votes[tokenId][sender] = Vote.DISLIKE;
        dislikeCount[tokenId] += 1;        
        return dislikeCount[tokenId];
    }

    function deleteDislike(address sender, uint256 tokenId) public returns (uint256) {
        require(votes[tokenId][sender] == Vote.DISLIKE);
        votes[tokenId][sender] = Vote.NO_VOTE;
        dislikeCount[tokenId] -= 1;        
        return dislikeCount[tokenId];
    }

}