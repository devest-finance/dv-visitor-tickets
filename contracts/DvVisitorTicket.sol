// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Context.sol";
import "@devest/contracts/DeVest.sol";
import "./DvTicket.sol";

// DeVest Investment Model One
// Bid & Offer
contract DvVisitorTicket is DvTicket {

    uint256 _rootId;

    constructor(string memory name, string memory symbol, uint256 rootId, address owner, address factory) DvTicket(name, symbol, owner, factory) {
        _rootId = rootId;
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


