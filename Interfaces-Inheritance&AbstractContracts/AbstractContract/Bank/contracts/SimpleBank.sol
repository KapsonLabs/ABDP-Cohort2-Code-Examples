/*
    This exercise has been updated to use Solidity version 0.5
    Breaking changes from 0.4 to 0.5 can be found here:
    https://solidity.readthedocs.io/en/v0.5.0/050-breaking-changes.html
*/

pragma solidity ^0.5.0;

import './Bank.sol';

contract SimpleBank is Bank {


    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event
    // Users should be enrolled before they can make deposits
    function deposit() public payable isEnrolled() returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */

        balances[msg.sender] = balances[msg.sender].add(msg.value); //balances[msg.sender] is auto passed in as first argument
        emit LogDepositMade(msg.sender, msg.value);
        return balances[msg.sender];

    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event

    function withdraw(uint withdrawAmount) public hasFunds(withdrawAmount) returns (uint) {
        balances[msg.sender] = balances[msg.sender].sub(withdrawAmount); //balances[msg.sender] is auto passed in as first argument
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return  balances[msg.sender];
    }

}
