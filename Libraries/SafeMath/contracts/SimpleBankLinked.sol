/*
    This exercise has been updated to use Solidity version 0.5
    Breaking changes from 0.4 to 0.5 can be found here:
    https://solidity.readthedocs.io/en/v0.5.0/050-breaking-changes.html
*/

pragma solidity ^0.5.0;

import "./SafeMathLinked.sol";

contract SimpleBankLinked {

    //
    // State variables
    //

    /* Fill in the keyword. Hint: We want to protect our users balance from other contracts*/
    mapping (address => uint) private balances;

    /* Fill in the keyword. We want to create a getter function and allow contracts to be able to see if a user is enrolled.  */
    mapping (address => bool) public enrolled;

    /* Let's make sure everyone knows who owns the bank. Use the appropriate keyword for this*/
    address public owner;

    //
    // Events - publicize actions to external listeners
    //

    /* Add an argument for this event, an accountAddress */
    event LogEnrolled(address indexed accountAddress);

    /* Add 2 arguments for this event, an accountAddress and an amount */
    event LogDepositMade(address indexed accountAddress, uint amount);

    /* Create an event called LogWithdrawal */
    /* Add 3 arguments for this event, an accountAddress, withdrawAmount and a newBalance */
    event LogWithdrawal(address indexed accountAddress, uint  withdrawAmount, uint newBalance);

    //
    // modifiers
    //
    modifier isEnrolled(){
      require(enrolled[msg.sender] == true, "User not enrolled");
      _;
    }

    modifier hasFunds(uint withdrawAmount){
      require (balances[msg.sender] >= withdrawAmount, "User has insufficient funds");
      _;
    }

    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        /* Set the owner to the creator of this contract */
        owner = msg.sender;
    }

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract
    function() external payable {
        // if (msg.value > 0) {
        //    emit Deposit(msg.sender, msg.value);
	    //     }
        revert();
    }

    /// @notice Get balance
    /// @return The balance of the user
    // A SPECIAL KEYWORD prevents function from editing state variables;
    // allows function to run locally/off blockchain
    function getBalance() public view returns (uint) {
        /* Get the balance of the sender of this transaction */
        return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
        enrolled[msg.sender] = true;
        emit LogEnrolled(msg.sender);
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    // Add the appropriate keyword so that this function can receive ether
    // Use the appropriate global variables to get the transaction sender and value
    // Emit the appropriate event
    // Users should be enrolled before they can make deposits
    function deposit() public payable isEnrolled() returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */

        balances[msg.sender] = SafeMathLinked.add(balances[msg.sender],msg.value);
        emit LogDepositMade(msg.sender, balances[msg.sender]);
        return balances[msg.sender];

    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    // Emit the appropriate event

    //Feedback where has the accont holders ETHER gone? Have you sent the ETHER to the account holder?
    function withdraw(uint withdrawAmount) public payable hasFunds(withdrawAmount) returns (uint) { //Feedback why is this payable?
        /* If the sender's balance is at least the amount they want to withdraw,
           Subtract the amount from the sender's balance, and try to send that amount of ether
           to the user attempting to withdraw.
           return the user's balance.*/
        balances[msg.sender] = SafeMathLinked.sub(balances[msg.sender],withdrawAmount);
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return  balances[msg.sender];
    }

}
