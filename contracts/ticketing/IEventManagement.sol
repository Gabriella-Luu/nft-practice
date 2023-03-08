// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

interface IEventManagement {

    /**
     * @dev create and event.
     * 
     * Requirements:
     * 
     * - `eventId` cannot already exist.
     * - `organizer` cannot be zero address.
     * - `startTime` cannot be bigger than `endTime`.
     */
    function createEvent(
        uint256 eventId,
        uint startTime,
        uint endTime
    ) external;

    /**
     * @dev create a kind of ticket for an event
     * 
     * Requirements:
     * 
     * - `ticketId` cannot already exist.
     * - `eventId` should exist.
     * - `ability` should be among 'Returnable', 'Resellable', 'Grantable', 'Untransferable'.
     */
    function createTicket(
        uint256 ticketId,
        uint256 eventId,
        string calldata ability,
        uint returnEndTime,
        uint transferEndTime,
        uint price,
        uint sum
    ) external;

    /**
     * @dev Returns number of remaining tickets of a typical kind of ticket.
     * 
     * Requirements:
     * 
     * - `ticketId` should exist.
     */
    function getRemainingTicketNum(uint256 ticketId) external view returns (uint);
    

    /**
     * @dev Returns number of really sold tickets of a typical kind of ticket.
     * 
     * Requirements:
     * 
     * - `ticketId` should exist.     
     */
    function getSoldTicketNum(uint256 ticketId) external view returns (uint);

}