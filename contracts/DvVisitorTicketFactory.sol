// SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;



import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@devest/contracts/DvFactory.sol";
import "./DvVisitorTicket.sol";

contract DvVisitorTicketFactory is DvFactory {

    /**
     * @dev detach a token from this factory
     */
    function detach(address payable _tokenAddress) external payable onlyOwner {
        DvVisitorTicket token = DvVisitorTicket(_tokenAddress);
        token.detach();
    }

    function issue(string memory name, string memory symbol, uint256 rootId) public payable isActive returns (address)
    {
        // take royalty
        require(msg.value >= _issueFee, "Please provide enough fee");
        if (_issueFee > 0)
            payable(_feeRecipient).transfer(_issueFee);

        // issue token
        DvVisitorTicket token = new DvVisitorTicket(name, symbol, rootId, _msgSender(), address(this));

        emit deployed(_msgSender(), address(token));
        return address(token);
    }

}
