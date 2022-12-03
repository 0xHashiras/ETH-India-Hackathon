// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";


contract Vote1155 is ERC1155Supply, Ownable {
    using Strings for uint256;
    
    // Contract name
    string public name;
    
    // Contract symbol
    string public symbol;

    constructor() ERC1155("https://api.coolcatsnft.com/cat/") {
        name = "Vote1155";
        symbol = "V1155";
        // mint(msg.sender,1, 10, '0x');
    }

    function uri(uint256 _id) public view override returns (string memory) {
        require(exists(_id),"URI Query for Non-Existent Token");
        return string.concat(super.uri(_id), _id.toString());
    }

    function mint(address to, uint256 id, uint256 amount, bytes memory data) external {
        _mint(to, id, amount, data);        
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        external
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC1155) returns (bool){
        return super.supportsInterface(interfaceId);
    }
}