// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Match721 is ERC721, ERC721URIStorage, Pausable, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    ERC1155 voteNFT ; 

    enum matchStatus
    {
      MatchYetToStart,
      MatchOngoing,
      MatchCompleted
    } 

    enum matchWinner
    {
      A,
      B,
      Draw,
      NoResult,
      TBA
    } 

    struct MatchInfo 
    {
        uint256 tokenIdA;  // tokenId of Team A
        uint256 tokenIdB;  // TokenId of Team B  
        matchStatus status; 
        matchWinner winner; 
    }
    mapping (uint256  => MatchInfo) public matchInfo;

    constructor(address _voteNFT) ERC721("Match721", "M721") {
        VoteNft = ERC1155(_voteNFT);
    }

    function _baseURI() internal pure override returns (string memory) {
        return "sample-uri/";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    // function safeMint(address to, string memory uri) public onlyOwner {
    //     uint256 tokenId = _tokenIdCounter.current();
    //     _tokenIdCounter.increment();
    //     _safeMint(to, tokenId);
    //     _setTokenURI(tokenId, uri);
    // }

    function initiateMatch() external onlyOwner {
        uint256 tokenId = _tokenIdCounter.current();
        _safeMint(owner(), tokenId);
        _setTokenURI(tokenId, uri);

        //Setting Match details
        matchInfo[tokenId] = MatchInfo(
            2*tokenId,
            (2*_tokenIdB)+1, 
            matchStatus.MatchYetToStart, 
            matchWinner.TBA 
        );
        _tokenIdCounter.increment();
    }

    function voteWinner(uint256 matchId, uint256 _voteFor) external onlyOwner {
        require(matchInfo[matchId].status == matchStatus.MatchYetToStart, "Cannot Vote for the Match");
        require(VoteNft.balanceOf(msg.sender, matchInfo[matchId].tokenIdA) == 0,"Can Vote only once");
        require(VoteNft.balanceOf(msg.sender, matchInfo[matchId].tokenIdB) == 0,"Can Vote only once");
        require(_voteFor < 2 , "Error in input");

        uint256 voteTokenId = matchInfo[matchId].tokenIdA;
        if (_voteFor == 1){
            voteTokenId = matchInfo[matchId].tokenIdB;
        }

        VoteNft.mint(msg.sender, voteTokenId, 1, "0x");
  
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId, uint256 batchSize)
        internal
        whenNotPaused
        override
    { 
        super._beforeTokenTransfer(from, to, tokenId, batchSize);
    }

    // The following functions are overrides required by Solidity.

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
}
