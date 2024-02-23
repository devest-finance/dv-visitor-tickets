// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Context.sol";
import "@devest/contracts/DeVest.sol";
import "./DvTicket.sol";

// DeVest Investment Model One
// Bid & Offer
contract DvVisitorTicket is DvTicket {

    uint256 _rootId;
    string _rootUri;

    constructor(string memory name, string memory symbol, uint256 __rootId, string memory __rootUri, address owner, address factory) DvTicket(name, symbol, owner, factory) {
        _rootId = __rootId;
        _rootUri = __rootUri;
    }

    function rootId() public view returns (uint256) {
        return _rootId;
    }

    function rootUri() public view returns (string memory) {
        return _rootUri;
    }

    // Only publisher can issue a ticket
    function issueNFT(address to, uint256 tokenId, string memory uri)
        public payable 
        onlyOwner
    {
        _mint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

}


