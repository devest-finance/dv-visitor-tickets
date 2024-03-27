// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "@openzeppelin/contracts/utils/Context.sol"; // Importing Context for basic execution context utilities (e.g., msg.sender).
import "./DvTicket.sol"; // Importing the DvTicket contract as a base for the ticketing system.

/**
 * @title DvVisitorTicket
 * @dev Extends the DvTicket contract to implement a specific use case of NFTs (Non-Fungible Tokens),
 * representing visitor tickets with unique identifiers and metadata.
 * 
 * Each ticket (NFT) is associated with a root ID and URI, indicating a common origin or category
 * for the tickets. This can be used to group tickets by event, location, or other criteria.
 */
contract DvVisitorTicket is DvTicket {
    // The root ID for a group of tickets, used to associate individual tickets with a common origin.
    uint256 private _rootId;
    
    // The root URI for the group of tickets, providing base metadata or information about the common origin.
    string private _rootUri;

    /**
     * @dev Constructor to create a DvVisitorTicket instance.
     * @param name The name of the ticket category.
     * @param symbol The symbol representing the ticket category.
     * @param __rootId The root ID shared by all tickets in this category.
     * @param __rootUri The root URI containing base information or metadata for the tickets.
     * @param owner The owner of the ticket category, typically the contract deployer.
     * @param factory The factory or contract that is responsible for managing this category.
     */
    constructor(string memory name, string memory symbol, uint256 __rootId, string memory __rootUri, address owner, address factory) 
    DvTicket(name, symbol, owner, factory) {
        _rootId = __rootId;
        _rootUri = __rootUri;
    }

    /**
     * @dev Retrieves the root ID associated with this ticket collection.
     * @return The root ID as a uint256.
     */
    function rootId() public view returns (uint256) {
        return _rootId;
    }

    /**
     * @dev Retrieves the root URI containing base metadata or information for the ticket collection.
     * @return The root URI as a string.
     */
    function rootUri() public view returns (string memory) {
        return _rootUri;
    }

    /**
     * @notice Issues a new Visitor ticket (NFT) to a specified address.
     * @dev Mints a new ticket with a unique ID and associates it with a specific URI. Can only be called by the collection owner.
     * @param to The address to which the new ticket will be issued.
     * @param tokenId The unique identifier for the new ticket.
     * @param uri The URI containing metadata for the new ticket.
     */
    function issueNFT(address to, uint256 tokenId, string memory uri)
        public payable 
        onlyOwner // Restricting this function to the collection owner.
    {
        _mint(to, tokenId); // Minting a new ticket.
        _setTokenURI(tokenId, uri); // Setting the URI for the new ticket.
    }
}