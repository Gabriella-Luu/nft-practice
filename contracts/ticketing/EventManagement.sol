// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "./IEventManagement.sol";
import "./TicketingStorage.sol";
import "../utils/DataProcess.sol";

contract EventManagement is IEventManagement, TicketingStorage{

    /**
     * @dev See {IEventManagement-createEvent}.
     */
    function createEvent(  
        uint256 eventId,
        uint startTime,
        uint endTime
    ) external {
        require(EventList[eventId].organizer == address(0), "eventId already exists");
        require(msg.sender != address(0), "Organizer cannot be zero address");
        require(startTime < endTime, "startTime should be earlier than endTime");

        EventList[eventId] = EventInfo(msg.sender, startTime, endTime);
    }

    /**
     * @dev See {IEventManagement-createTicket}.
     */
    function createTicket(
        uint256 ticketId,
        uint256 eventId,
        string calldata ability,
        uint returnEndTime,
        uint transferEndTime,
        uint price,
        uint sum
    ) external {
        require(TicketList[ticketId].eventId == 0, "ticketId already exists");
        require(EventList[eventId].organizer == msg.sender, "You are not the organizer of the event");
        // require(returnEndTime <= EventList[eventId].endTime, "Return end time cannot be later than event end time.");
        // require(transferEndTime <= EventList[eventId].endTime, "transfer end time cannot be later than event end time.");
        
        TicketAbility ability_enum;
        bool ifMatch;
        (ability_enum, ifMatch) = _getTicketAbility(ability);
        require(ifMatch);

        TicketList[ticketId] = TicketInfo(ticketId, eventId, ability_enum, returnEndTime, transferEndTime, price, sum);
        RemainingTicketsNumMap[ticketId] = sum;
    }

    /**
     * @dev See {IEventManagement-getRemainingTicketNum}
     */
    function getRemainingTicketNum(uint256 ticketId) external view returns (uint) {
        require(TicketList[ticketId].eventId != 0,  "Ticket doesn't exist");

        return RemainingTicketsNumMap[ticketId];
    }

    /**
     * @dev See {IEventManagement-getSoldTicketNum}
     */
    function getSoldTicketNum(uint256 ticketId) external view returns (uint) {
        require(TicketList[ticketId].eventId != 0,  "Ticket doesn't exist");

        return TicketList[ticketId].sum 
             - RemainingTicketsNumMap[ticketId] 
             + TakeANumber.length(ToBeResoldTicketsMap[ticketId]);
    }

    /**
     * @dev Converts string to enum TicketAbility, returns ticket ability and if it matchs one of four ability names.
     */
    function _getTicketAbility(string memory ability_string) internal pure returns (TicketAbility, bool) {
        if (Strings.equal(ability_string, "Returnable")) return (TicketAbility.Returnable, true);
        if (Strings.equal(ability_string, "Resellable")) return (TicketAbility.Resellable, true);
        if (Strings.equal(ability_string, "Grantable")) return (TicketAbility.Grantable, true);
        if (Strings.equal(ability_string, "Untransferable")) return (TicketAbility.Untransferable, true);
        return (_, false);
    }
}