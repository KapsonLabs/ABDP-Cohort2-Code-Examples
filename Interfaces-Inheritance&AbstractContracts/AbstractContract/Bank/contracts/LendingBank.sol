pragma solidity ^0.5.0;

interface LendingBank {

  function addLendableFunds() external payable returns (uint);
  function getLendableAmount() external view returns (uint);
  function getDebtAmount() external view returns (uint);
  function borrow(uint borrowAmount) external returns (uint);

}
