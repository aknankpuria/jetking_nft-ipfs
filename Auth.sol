//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract AuthNFT is ERC721, Ownable{

    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    mapping(address => bool) _verfied;


    constructor() ERC721("AuthNFT", "AUTH") {

    }

    function verify(address _address) external onlyOwner {
        _verfied[_address] = true;
    }

    function revoke (address _address) external onlyOwner {
        _verfied[_address] = false;
    }

    function checkVerfiedOrNot(address _addr) external view returns (bool) {
        return _verfied[_addr];
    }

    function safeMint (address _to) public onlyOwner {
        _tokenIds.increment();
        uint256 tokenID = _tokenIds.current();

        require(!_exists(tokenID));

        _safeMint(_to, tokenID);

    }

    function _beforeTokenTransfer (address from , address to , uint256 tokenId , uint256 batchSize) internal override(ERC721){
            
            super._beforeTokenTransfer(from, to, tokenId, batchSize);


            if(from !=address(0) && to != address(0)){
                _verfied[from] = false;
                _verfied[to] = false;
            }


            else if (from == address(0) && to != address(0)){
                _verfied[to] = false;
            }

    }
     
     








}
