pragma solidity ^0.5.0;

import "../node_modules/openzeppelin-solidity/contracts/math/SafeMath.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Roles.sol";

contract SimpleBankEmergencyStop {

    using SafeMath for uint;
    using Roles for Roles.Role;

    Roles.Role private admin;

    /*Boolean value to track emergency mode for circuit breaker pattern */
    bool private emergency;

    mapping (address => uint) internal balances;

    mapping (address => bool) public enrolled;

    address public owner;

    event LogEnrolled(address indexed accountAddress);

    event LogDepositMade(address indexed accountAddress, uint amount);

    event LogWithdrawal(address indexed accountAddress, uint  withdrawAmount, uint newBalance);

    //
    // modifiers
    //
    modifier onlyAdmin {
        require(
            admin.has(msg.sender),
            "Only the admin can call this function"
            );
        _;
    }

    modifier isEnrolled(){
        require(enrolled[msg.sender] == true, "User not enrolled");
        _;
    }

    modifier hasFunds(uint withdrawAmount){
        require (balances[msg.sender] >= withdrawAmount, "User has insufficient funds");
        _;
    }

    /*Circuit breaker pattern modifiers */
    modifier stopInEmergency { 
        require(!emergency, "Contract currently in emergency mode, Function can't be called"); 
        _; 
    }
    
    modifier onlyInEmergency { 
        require(emergency, "Function callable only in emergency mode"); 
        _;
    }

    //
    // Functions
    //

    /* Use the appropriate global variable to get the sender of the transaction */
    constructor() public {
        admin.add(msg.sender);
        emergency = false;
    }

    function() external payable {
        revert();
    }

    /** @dev Lets admin toggle the state of emergency 
     * @return Boolean for testing in solidity
     */
    function toggleEmergency() public onlyAdmin returns (bool) {
        emergency = !emergency;
        return true;
    }

    /// @notice Get balance
    /// @return The balance of the user
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
    function deposit() public payable isEnrolled() stopInEmergency returns (uint) {
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
    function withdraw(uint withdrawAmount) public hasFunds(withdrawAmount) stopInEmergency returns (uint) {
        balances[msg.sender] = balances[msg.sender].sub(withdrawAmount); //balances[msg.sender] is auto passed in as first argument
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return  balances[msg.sender];
    }

    // function emergencyWithdraw() public onlyInEmergency {
    //     // Emergency withdraw happening here
    // }

}