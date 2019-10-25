pragma solidity ^0.5.0;

interface Bank {

  function getBalance() external view returns (uint);
  function deposit() external payable returns (uint);
  function withdraw(uint withdrawAmount) external returns (uint);
  function enroll() external returns (bool);

}
