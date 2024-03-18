// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@devest/contracts/DeVest.sol";
import "./interfaces/IERC721.sol";
import "./interfaces/IERC165.sol";
import "./interfaces/IERC721Metadata.sol";
import "./interfaces/IERC721TokenReceiver.sol";

/**
 * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
 * the Metadata extension and including the Enumerable extension {ERC721Enumerable}
 */
contract DvTicket is DeVest, IERC165, IERC721, IERC721Metadata {


    // Token name
    string private _name;

    // Token symbol
    string private _symbol;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping of token URIs
    mapping(uint256 => string) private _tokenURIs;




    // Mapping from owner to list of owned token IDs
    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    // Mapping from token ID to index of the owner tokens list
    mapping(uint256 => uint256) private _ownedTokensIndex;

    // Array with all token ids, used for enumeration
    uint256[] private _allTokens;

    // Mapping from token id to position in the allTokens array
    mapping(uint256 => uint256) private _allTokensIndex;





    constructor(string memory name_, string memory symbol_, address _owner, address _factory) DeVest(_owner, _factory) {
        _name = name_;
        _symbol = symbol_;
    }




    // Returns the number of owned tickets
    function balanceOf(address owner) public view virtual returns (uint256) {
        require(owner != address(0), "ERC721: address zero is not a valid owner");
        return _balances[owner];
    }
    // Returns the owner of the asset
    function ownerOf(uint256 tokenId) public view virtual returns (address) {
        address owner = _ownerOf(tokenId);
        require(owner != address(0), "ERC721: invalid token ID");
        return owner;
    }





    function name() public view virtual returns (string memory) {
        return _name;
    }

    function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        _requireMinted(tokenId);
        return _tokenURIs[tokenId];
    }

    function _setTokenURI(uint256 tokenId, string memory uri) internal {
        _tokenURIs[tokenId] = uri;
    }





    // Creates a new ticket
    function _mint(address to, uint256 tokenId) internal virtual takeFee() {
        require(to != address(0), "ERC721: mint to the zero address");
        require(!_exists(tokenId), "ERC721: token already minted");


        _owners[tokenId] = to;

        addToOwnedAndAllTokens(to, tokenId);

        unchecked {
            _balances[to] += 1;
        }


        emit Transfer(address(0), to, tokenId);
    }

    // Transfers ownership of a ticket
    function _transfer(address from, address to, uint256 tokenId) internal virtual {
        require(_ownerOf(tokenId) == from, "ERC721: transfer from incorrect owner");
        require(to != address(0), "ERC721: transfer to the zero address");
        require(to != from, "ERC721: cannot transfer to the same owner");

        removeFromOwnedTokens(from, tokenId);
        removeFromAllTokens(tokenId);

        addToOwnedAndAllTokens(to, tokenId);
        
        unchecked {
            _balances[from] -= 1;
            _balances[to] += 1;
        }

        _owners[tokenId] = to;
        

        emit Transfer(from, to, tokenId);
    }







    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256) {
        require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
        return _ownedTokens[owner][index];
    }


    function totalSupply() public view virtual returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public view virtual returns (uint256) {
        require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
        return _allTokens[index];
    }






    function addToOwnedAndAllTokens(address to, uint256 tokenId) internal virtual {
        // Map tokenId to owner
        uint256 length = balanceOf(to);
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
        
        // Map 
        _allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function removeFromOwnedTokens(address from, uint256 tokenId) internal virtual {
        uint256 lastTokenIndex = balanceOf(from) - 1;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        // When the token to delete is the last token, the swap operation is unnecessary
        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
            _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
        }

        // This also deletes the contents at the last position of the array
        delete _ownedTokensIndex[tokenId];
        delete _ownedTokens[from][lastTokenIndex];
    }

    function removeFromAllTokens(uint256 tokenId) internal virtual {
        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = _allTokensIndex[tokenId];

        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
        _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index

        // This also deletes the contents at the last position of the array
        delete _allTokensIndex[tokenId];
        _allTokens.pop();
    }    





    function _requireMinted(uint256 tokenId) internal view virtual {
        require(_exists(tokenId), "ERC721: invalid token ID");
    }

    function _ownerOf(uint256 tokenId) internal view virtual returns (address) {
        return _owners[tokenId];
    }

    function _exists(uint256 tokenId) internal view virtual returns (bool) {
        return _ownerOf(tokenId) != address(0);
    }

    function _isOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
        return (spender == _ownerOf(tokenId));
    }






    function transferFrom(address from, address to, uint256 tokenId) public virtual payable {}

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external virtual payable {}

    function safeTransferFrom(address from, address to, uint256 tokenId) external virtual payable{}

    function approve(address to, uint256 tokenId) external virtual payable{}

    function setApprovalForAll(address operator, bool approved) virtual external{}

    function getApproved(uint256 tokenId) virtual external view returns (address operator){}

    function isApprovedForAll(address owner, address operator) virtual external view returns (bool) {}

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC721Metadata).interfaceId;
    }

}
