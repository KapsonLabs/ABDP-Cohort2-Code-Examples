pragma solidity ^0.5.0;

import './LendingBank.sol';
import './SimpleBank.sol';

contract SimpleLendingBank is LendingBank, Bank{

    //
    // State variables
    //
    uint private lendableBalance;

    uint private lendingBlockCount;

    mapping (address => DebtStruct) public debts;

    struct DebtStruct {
        uint lendingBlock;
        uint amount;
    }

    //
    // events
    //

    event LogLoanFundsAdded(uint amount, uint newLendableBalance);

    event LogLoanMade(address indexed accountAddress, uint amount, uint blockNumber, uint newBalance);

    event LogRepayment(address indexed accountAddress, uint amount, uint newDebtAmount);

    //
    // modifiers
    //
    modifier onlyOwner(){
        require(msg.sender == owner, "Unathorised user");
        _;
    }

    modifier canBorrow(uint borrowAmount){
        require(lendableBalance >= borrowAmount, "Bank has insufficient funds");
        require(debts[msg.sender].amount==0, "User already has a debt");
        _;
    }

    modifier noOverdueDebt(){
        require(debts[msg.sender].amount==0 || (debts[msg.sender].lendingBlock+lendingBlockCount) > block.number, "Overdue debt");
        _;
    }

    constructor(uint _lendingBlockCount) public {
        lendingBlockCount = _lendingBlockCount;
    }

    function addLendableFunds() public payable onlyOwner() returns (uint) {
        lendableBalance = lendableBalance.add(msg.value);
        emit LogLoanFundsAdded(msg.value,lendableBalance);
        return lendableBalance;
    }

    function getLendableAmount() public view returns (uint) {
        return lendableBalance;
    }

    function getDebtAmount() public view returns (uint) {
        return debts[msg.sender].amount;
    }

    function borrow(uint borrowAmount) public isEnrolled() canBorrow(borrowAmount) returns (uint) {

        debts[msg.sender].lendingBlock = block.number;
        debts[msg.sender].amount = borrowAmount;
        balances[msg.sender] = balances[msg.sender].add(borrowAmount);
        emit LogLoanMade(msg.sender, borrowAmount,block.number, balances[msg.sender]);
        return balances[msg.sender];
    }

    function deposit() public payable isEnrolled() returns (uint) {
        /* Add the amount to the user's balance, call the event associated with a deposit,
          then return the balance of the user */
        if(debts[msg.sender].amount > 0 && debts[msg.sender].lendingBlock+lendingBlockCount <= block.number)
        {
            uint repaymentAmount = msg.value;
            if(msg.value > debts[msg.sender].amount)
          {
                repaymentAmount = msg.value - debts[msg.sender].amount;
          }
            debts[msg.sender].amount = debts[msg.sender].amount.sub(repaymentAmount);
            emit LogRepayment(msg.sender,repaymentAmount,debts[msg.sender].amount);
            uint depositAmount = msg.value - repaymentAmount;
            if(depositAmount > 0)
          {
                balances[msg.sender] = balances[msg.sender].add(depositAmount);
                emit LogDepositMade(msg.sender, depositAmount);
          }
        }
        else
          {
            balances[msg.sender] = balances[msg.sender].add(msg.value); //balances[msg.sender] is auto passed in as first argument
            emit LogDepositMade(msg.sender, msg.value);
          }
        return balances[msg.sender];
    }

    function withdraw(uint withdrawAmount) public hasFunds(withdrawAmount) noOverdueDebt() returns (uint) {
        balances[msg.sender] = balances[msg.sender].sub(withdrawAmount); //balances[msg.sender] is auto passed in as first argument
        msg.sender.transfer(withdrawAmount);
        emit LogWithdrawal(msg.sender, withdrawAmount, balances[msg.sender]);
        return  balances[msg.sender];
    }
}
