// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "../../node_modules/@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "./TicketingStorage.sol";

contract TicketManagment is ERC721Enumerable, TicketingStorage {
    constructor(
    ) ERC721("Life", "LIFE") {
    }

    modifier onlyLIFEOwner(uint256 LIFEId) {
        require(ownerOf(LIFEId) == msg.sender, "Unauthorized.");
        _;
    }

    /**
     * @dev See {ITicketingManagement-mintLIFE}
     */
    function mintLIFE(uint256 ticketId, address[] calldata grantableAddressList) external returns (uint256){
        require(TicketList[ticketId].eventId != 0, "ticketId doesn't exist.");
        require(RemainingTicketsNumMap[ticketId] > 0, "Sold out.");

        // check if there's a ticket to be resold, if there is, burn it
        if (TakeANumber.empty(ToBeResoldTicketsMap[ticketId])) {
            uint256 TBRLIFEId = TakeANumber.callANumber(ToBeResoldTicketsMap[ticketId]);
            _burn(TBRLIFEId);
            //TODO inform owner of TBRLIFEId
        }

        // mint new LIFE
        uint256 newLIFEId = _getNewLIFEId();
        _safeMint(msg.sender, newLIFEId);
        _setLIFEInfo(newLIFEId, ticketId, TicketStatus.ToBeUsed, TicketList[ticketId].price, grantableAddressList);
        RemainingTicketsNumMap[ticketId] -= 1;

        return newLIFEId;
    }

    /**
     * @dev See {ITicketingManagement-resellLIFE}
     */
    function resellLIFE(uint256 LIFEId) external onlyLIFEOwner(LIFEId) returns (uint128 num) {
        uint256 ticketId = LIFEInfoMap[LIFEId].ticketId;
        num = TakeANumber.takeANumber(ToBeResoldTicketsMap[ticketId], LIFEId);
        RemainingTicketsNumMap[ticketId] += 1;
    }

    /**
     * @dev See {ITicketingManagement-returnlLIFE}
     */
    function returnLIFE(uint256 LIFEId) external onlyLIFEOwner(LIFEId){

    }

    /**
     * @dev See {ITicketingManagement-grantLIFE}
     */
    function grantLIFE(uint256 LIFEId, address to) external onlyLIFEOwner(LIFEId){

    }

    function _getNewLIFEId() internal view returns (uint256) {
        return totalSupply() + 1;
    }

    function _setLIFEInfo(
        uint256 LIFEId,
        uint256 ticketId, 
        TicketStatus status,
        uint price,
        address[] calldata grantableAddressList
    ) internal {
        // require();
        LIFEInfoMap[LIFEId] = LIFEInfo(ticketId, status, price, grantableAddressList);
    }

}