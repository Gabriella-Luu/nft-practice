// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity >=0.7.0 <0.9.0;

contract NFT is ERC721Enumerable, Ownable {
    using Strings for uint256;

    enum Vote {
        NO_VOTE,
        LIKE,
        DISLIKE
    }

    string baseURI;
    string public baseExtension = ".json";
    uint256 public cost = 0 ether;
    mapping(address => Vote) public votes;
    uint256 public likeCount = 0;
    uint256 public dislikeCount = 0;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _initBaseURI
    ) ERC721(_name, _symbol) {
        setBaseURI(_initBaseURI);
    }

    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    function mint() public payable {
        uint256 supply = totalSupply();

        if (msg.sender != owner()) {
            require(msg.value >= cost);
        }

        _safeMint(msg.sender, supply + 1);
    }

    function like() public {
        require(votes[msg.sender] == Vote.NO_VOTE);
        votes[msg.sender] = Vote.LIKE;
        likeCount += 1;
    }    

    function deleteLike() public {
        require(votes[msg.sender] == Vote.LIKE);
        votes[msg.sender] = Vote.NO_VOTE;
        likeCount -= 1;
    }
    
    function dislike() public {
        require(votes[msg.sender] == Vote.NO_VOTE);
        votes[msg.sender] = Vote.DISLIKE;
        dislikeCount += 1;
    }

    function deleteDislike() public {
        require(votes[msg.sender] == Vote.DISLIKE);
        votes[msg.sender] = Vote.NO_VOTE;
        dislikeCount -= 1;
    }

    // internal
    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
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

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        baseExtension
                    )
                )
                : "";
    }

    // Only owner
    function setCost(uint256 _newCost) public onlyOwner {
        cost = _newCost;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(success);
    }
}
