pragma solidity ^0.5.0;

interface Bank {
  enum testEnum {
    ONE, TWO, THREE
  }

  struct testStruct {
    uint number;
    address addr;
  }

  function getBalance() external view returns (uint);
  function deposit() external payable returns (uint);
  function withdraw(uint withdrawAmount) external returns (uint);
  function enroll() external returns (bool);

}
