// SPDX-License-Identifier: MIT
// learn from OpenZeppelin Contracts (last updated v4.6.0) (utils/structs/DoubleEndedQueue.sol)

pragma solidity ^0.8.4;

import "../../node_modules/@openzeppelin/contracts/utils/structs/EnumerableMap.sol";

library TakeANumber {
    using EnumerableMap for EnumerableMap.UintToUintMap;

    /**
     * @dev An operation (e.g. {callANumber}) couldn't be completed due to the queue being empty.
     */
    error Empty();

    /**
     * @dev An operation (e.g. {leaveQueue}) couldn't find the number provided.
     */
    error NumberNotFound();

    /**
     * @dev They are 128 bits so begin and end are packed in a single storage slot for efficient access. 
     * Since the items are added one at a time we can safely assume that these 128-bit indices will not overflow, 
     * and use unchecked arithmetic.
     * Struct members have an underscore prefix indicating that they are "private" and should not be read or written to
     * directly. Use the functions provided below instead. Modifying the struct manually may violate assumptions and
     * lead to unexpected behavior.
     * Values in the waiting line can repeat. Please constrain values when you call functions in this library if you need.
     *
     * Indices are in the range [begin, end) which means the first item is at data[begin] and the last item is at
     * data[end - 1].
     */
    struct Queue {
        uint128 _begin;
        uint128 _end;
        EnumerableMap.UintToUintMap _waitingLine;
    }

    /**
     * @dev Take a number.
     */
    function takeANumber(Queue storage queue, uint256 value) internal returns (uint128 number) {
        number = queue._end;
        EnumerableMap.set(queue._waitingLine, number, value);
        unchecked {
            queue._end = number + 1;
        }
    }

    /**
     * @dev Call a number.
     *
     * Reverts with `Empty` if the queue is empty.
     */
    function callANumber(Queue storage queue) internal returns (uint256 value) {
        if (empty(queue)) revert Empty();
        uint128 frontIndex = queue._begin;
        while (EnumerableMap.contains(queue._waitingLine, frontIndex) == false) {
            unchecked {
                frontIndex += 1;
            } 
        }
        value = EnumerableMap.get(queue._waitingLine, frontIndex);
        EnumerableMap.remove(queue._waitingLine, frontIndex);
        unchecked {
            queue._begin = frontIndex + 1;
        }    
    }

    function leaveQueue(Queue storage queue, uint128 number) internal {
        if (EnumerableMap.contains(queue._waitingLine, number) == false) revert NumberNotFound();
        EnumerableMap.remove(queue._waitingLine, number);
    }

    /**
     * @dev Returns the number of items in the queue.
     */
    function length(Queue storage queue) internal view returns (uint256) {
        return EnumerableMap.length(queue._waitingLine);
    }

    /**
     * @dev Returns true if the queue is empty.
     */
    function empty(Queue storage queue) internal view returns (bool) {
        return EnumerableMap.length(queue._waitingLine) == 0;
    }
}