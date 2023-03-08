// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

interface TicketManagement {
   /**
    * @dev Mints a ticket and set LIFEInfo. If these's a ticket to be resold, burn the ticket
    * and mint a new one without editing the RemainingTicketsNumMap.
    * 
    * Requirements:
    *
    * - `ticketId` should exist.
    * - These's a remaining ticket.
    */
    function mintLIFE(uint256 ticketId, address[] calldata grantableAddressList) external returns (uint256);

    /**
     * @dev Makes a ticket on resale.
     * 
     * Requirements: 
     * 
     * - Only ticket owner can call this.
     */
    function resellLIFE(uint256 LIFEId) external returns (uint128 num);

    /**
     * @dev Returns a ticket.
     * 
     * Requirements: 
     * 
     * - Only ticket owner can call this.
     */
    function returnLIFE(uint256 LIFEId) external;

    /**
     * @dev Grants a ticket to a user in grantableAddressList.
     * 
     * Requirements:
     * 
     * - Only ticket owner can call this.
     * - `to` cannot be zero address.   
     */
    function grantLIFE(uint256 LIFEId, address to) external;

}