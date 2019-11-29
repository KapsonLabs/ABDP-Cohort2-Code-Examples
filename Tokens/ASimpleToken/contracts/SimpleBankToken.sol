/** 
THIS IS NOT A TOKEN STANDARD
*/

pragma solidity ^0.5.0;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract SimpleBankToken{
    mapping(address => uint256) private balances;
    address private owner;

    using SafeMath for uint256;

    constructor() public{
        owner = msg.sender;
    }

    function buy() external payable returns(bool){
        //Ensure that the user sent with ETH to buy tokens
        require(msg.value!=0, "Must send some ETH to buy tokens");

        //Here we give the user 100 times what they deposit
        balances[msg.sender] = balances[msg.sender] + msg.value.mul(100);

        return true;
    }

    function sell(uint256 _amount) external returns(bool){
        //Check that the user has enough funds to withdraw the amount
        require(balances[msg.sender] > _amount, "insufficient funds");
        //we subtract the amount from their balance
        balances[msg.sender] = balances[msg.sender] - _amount;

        msg.sender.transfer(_amount.div(100));

        return true;
    }
}