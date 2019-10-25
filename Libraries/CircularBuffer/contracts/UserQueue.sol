pragma solidity ^0.5.0;

import "./CircularBufferFIFOBytes32.sol";

contract UserQueue {

    using CircularBufferFIFOBytes32 for CircularBufferFIFOBytes32.StateStruct;

    mapping (address => CircularBufferFIFOBytes32.StateStruct) queues;
    bytes32 lastPopped;

    function pushData(bytes32 data) external {
        queues[msg.sender].push(data);
    }
    function popData() external returns (bytes32) {
        lastPopped = queues[msg.sender].pop();
        return lastPopped;
    }

    function getLastPopped() external view returns (bytes32) {
      return lastPopped;
    }
    
    function queueDepth() public view returns (uint) {
        return queues[msg.sender].queueDepth();
    }
}
