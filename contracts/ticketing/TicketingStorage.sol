// SPDX-License-Identifier: MIT
pragma solidity ^0.8.1;

import "../../node_modules/@openzeppelin/contracts/utils/structs/DoubleEndedQueue.sol";

contract TicketingStorage {
    enum TicketAbility {
        Returnable, // can be returned, resold and granted
        Resellable, // can be resold and granted
        Grantable, // can be granted
        Untransferable // cannot do anything
    }

    enum TicketStatus {
        ToBeUsed, // before event start time
        Reselling, // to be used
        Used, // after checking in
        Unused // after event end time without checking in
    }

    struct EventInfo {
        address organizer;
        uint startTime;
        uint endTime;
    }

    // shared info of a class of tickets
    struct TicketInfo {
        uint256 eventId;
        TicketAbility ability;
        uint validBefore; // ticket is valid before this time. after this time, ticket status can be used or unused
        uint returnEndTime; // cannot return ticket after this time
        uint transferEndTime; // cannot transfer or resell after this time
        uint saleEndTime; // cannot buy ticket after this time
        uint price; // true 'price' * 100 
        uint sum;
        // uint returnFee;
    }
    
    // individualized ticket info
    struct LTInfo {
        uint256 ticketId;
        TicketStatus status;
        uint priceCap; // return price or resale price should be lower than priceCap
        address[] grantableAddressList;
        // address[] ownersList;
    }

    // Mapping from EventId to EventInfo (like a list)
    mapping(uint256 => EventInfo) public EventList;

    // Mapping from EventId to EventInfo (like a list)
    mapping(uint256 => TicketInfo) public TicketList;

    // // Mapping from organizer address to EventId
    // mapping(address => uint256) public OrganizerEventMap;

    // // Mapping from EventId to TicketId list
    // mapping(uint256 => uint256[]) public EventTicketMap;

    // Mapping from TicketId to remaining tickets num
    mapping(uint256 => uint) public RemainingTicketsNumMap;

    // mapping from TicketId to to-be-resold LTId queue
    mapping(uint256 => DoubleEndedQueue.Bytes32Deque) public ToBeResoldTicketsMap;

    // mapping from LTId to LT info
    mapping(uint256 => LTInfo) private LTInfoMap;

    

}