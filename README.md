# DvTicket Contracts

## Overview
The DvTicket Contracts are part of a blockchain-based system designed to issue and manage digital assets, specifically focusing on tickets as assets. Built on the Ethereum blockchain, these contracts leverage the ERC-721 Non-Fungible Token (NFT) standard for creating unique, identifiable assets with specific properties. The system is designed with DeFi and vesting mechanisms in mind, providing a robust platform for asset management.

## Contracts

### `DvFactory`
This abstract contract serves as a foundation for creating contracts that issue DvVest extended contracts. It provides mechanisms for managing ownership, fees, and the active status of the factory, ensuring secure and controlled creation of new contracts.

### `DvVisitorTicketFactory`
Inherits from `DvFactory`, this contract focuses on issuing `DvVisitorTicket` assets. It allows the deployment of new tickets with specific attributes and manages the associated fees for issuing these assets.

### `DvTicket`
Implements the ERC-721 standard, including metadata and enumeration extensions. This contract is designed to manage the lifecycle of each ticket, from creation to ownership management. It is noteworthy that the `DvTicket` contract provides the foundational functionalities such as minting new assets and querying asset data.

### `DvVisitorTicket`
Extends `DvTicket` with specific functionalities for a unique type of asset referred to as "visitor tickets". These tickets are associated with a root ID and URI, providing a hierarchical structure to the assets. This contract allows only the owner (publisher) to issue new visitor tickets, ensuring controlled distribution of these assets.

## Key Features
- **Asset Issuance**: Secure and controlled issuance of visitor tickets with unique identifiers and metadata.
- **Ownership Management**: Tracks the ownership of each asset, allowing for the verification of asset holders.
- **Metadata and Enumeration**: Each asset is associated with metadata for additional information and supports enumeration for querying and listing.

## Limitations
- **Non-Transferability**: Currently, the `DvVisitorTicket` and its base contract `DvTicket` do not implement functionality for transferring tickets between addresses. Assets (tickets) issued through these contracts are therefore non-transferable post-issuance. This design choice is intentional to meet specific use cases where assets remain with their original owner until they are redeemed or expire.

## Setup and Deployment
To deploy these contracts, you will need a development environment set up for Ethereum smart contract development, such as Truffle or Hardhat, along with access to an Ethereum network (mainnet, testnet, or a local development network).

1. Install dependencies:
   ```shell
   npm install @openzeppelin/contracts
   npm install @devest/contracts
   ```

2. Compile the contracts:
   ```shell
   truffle compile
   ```
3. Deploy the contracts using your chosen development framework and Ethereum network.

## Security Considerations
- Ensure that the ownership of the contracts is securely managed and transferred only under intended circumstances.
- Regularly audit and test the contracts for potential vulnerabilities or logic errors.
- Consider implementing additional functionality or controls for asset management based on specific use cases and requirements.

## Conclusion
The DvTicket Contracts offer a robust platform for issuing and managing digital assets with specific use cases in mind. While currently focused on non-transferable visitor tickets, the system's design allows for future expansions and adaptations to meet a wide range of needs within the digital asset space.