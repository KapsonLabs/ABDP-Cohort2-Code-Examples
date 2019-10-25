/*

The public version of the file used for testing can be found here: https://gist.github.com/ConsenSys-Academy/ce47850a8e2cba6ef366625b665c7fba

This test file has been updated for Truffle version 5.0. If your tests are failing, make sure that you are
using Truffle version 5.0. You can check this by running "trufffle version"  in the terminal. If version 5 is not
installed, you can uninstall the existing version with `npm uninstall -g truffle` and install the latest version (5.0)
with `npm install -g truffle`.

*/
const { time, expectEvent, expectRevert } = require('@openzeppelin/test-helpers');
var Bank = artifacts.require("./SimpleLendingBank.sol")

contract('SimpleLendingBank', function(accounts) {

  const owner = accounts[0]
  const alice = accounts[1]
  const bob = accounts[2]
  const deposit = web3.utils.toBN(2)
  const lendingBlockCount = web3.utils.toBN(100)
  const lendingAmount = web3.utils.toBN(50)

  beforeEach(async () => {
    instance = await Bank.new(lendingBlockCount)
  })

  it("should mark addresses as enrolled", async () => {
    await instance.enroll({from: alice})

    const aliceEnrolled = await instance.enrolled(alice, {from: alice})
    assert.equal(aliceEnrolled, true, 'enroll balance is incorrect, check balance method or constructor')
  });

  it("should not mark unenrolled users as enrolled", async() =>{
    const ownerEnrolled = await instance.enrolled(owner, {from: owner})
    assert.equal(ownerEnrolled, false, 'only enrolled users should be marked enrolled')
  })

  it("should deposit correct amount", async () => {
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    const balance = await instance.getBalance({from: alice})

    assert.equal(deposit.toString(), balance, 'deposit amount incorrect, check deposit method')
  })

  it("should log a deposit event when a deposit is made", async() => {
    await instance.enroll({from: alice})
    const result  = await instance.deposit({from: alice, value: deposit})

    const expectedEventResult = {accountAddress: alice, amount: deposit}

    const logAccountAddress = result.logs[0].args.accountAddress
    const logDepositAmount = result.logs[0].args.amount.toNumber()

    assert.equal(expectedEventResult.accountAddress, logAccountAddress, "LogDepositMade event accountAddress property not emitted, check deposit method");
    assert.equal(expectedEventResult.amount, logDepositAmount, "LogDepositMade event amount property not emitted, check deposit method")
  })

  it("should withdraw correct amount", async () => {
    const initialAmount = 0
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await instance.withdraw(deposit, {from: alice})
    const balance = await instance.getBalance({from: alice})

    assert.equal(balance.toString(), initialAmount.toString(), 'balance incorrect after withdrawal, check withdraw method')
  })

  it("should not be able to withdraw more than has been deposited", async() => {
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await expectRevert(instance.withdraw(deposit + 1, {from: alice}),"User has insufficient funds")
  })

  it("should emit the appropriate event when a withdrawal is made", async()=>{
    const initialAmount = 0
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    var result = await instance.withdraw(deposit, {from: alice})

    const accountAddress = result.logs[0].args.accountAddress
    const newBalance = result.logs[0].args.newBalance.toNumber()
    const withdrawAmount = result.logs[0].args.withdrawAmount.toNumber()

    const expectedEventResult = {accountAddress: alice, newBalance: initialAmount, withdrawAmount: deposit}

    assert.equal(expectedEventResult.accountAddress, accountAddress, "LogWithdrawal event accountAddress property not emitted, check deposit method")
    assert.equal(expectedEventResult.newBalance, newBalance, "LogWithdrawal event newBalance property not emitted, check deposit method")
    assert.equal(expectedEventResult.withdrawAmount, withdrawAmount, "LogWithdrawal event withdrawalAmount property not emitted, check deposit method")
  })

  it("should add correct lending amount", async () => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    const lendableBalance = await instance.getLendableAmount()

    assert.equal(lendingAmount.toString(), lendableBalance, 'lendable amount incorrect, check addLendableFunds method')
  })

  it("should log a funds added event when a new lendable funds deposit is made", async() => {
    result = await instance.addLendableFunds({from: owner, value: lendingAmount})

    const expectedEventResult = {amount: lendingAmount, newLendableBalance: lendingAmount}

    const logAmount = result.logs[0].args.amount.toNumber()
    const logNewBalance = result.logs[0].args.newLendableBalance.toNumber()

    assert.equal(expectedEventResult.amount, logAmount, "LogLoanFundsAdded event amount property not emitted, check deposit method");
    assert.equal(expectedEventResult.newLendableBalance, logNewBalance, "LogLoanFundsAdded event newLendableBalance property not emitted, check deposit method")
  })

  it("should not be able to add lendable funds if not owner", async() => {
    await expectRevert(instance.addLendableFunds({from: alice, value: lendingAmount}),"Unathorised user")
  })

  it("should lend correct amount", async () => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await instance.borrow(lendingAmount,{from: alice})

    const expectedBalance = deposit.add(lendingAmount);
    const balance = await instance.getBalance({from: alice})
    const debtAmount = await instance.getDebtAmount({from: alice})

    assert.equal(lendingAmount.toString(), debtAmount, 'debtAmount incorrect, check borrow method')
    assert.equal(expectedBalance.toString(), balance, 'balance incorrect, check borrow method')
  })

  it("should log a loan made event when a funds lent", async() => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    result =  await instance.borrow(lendingAmount,{from: alice})

    const expectedBalance = deposit.add(lendingAmount);
    const currentBlock = await time.latestBlock();

    expectEvent(result, 'LogLoanMade', {
      accountAddress: alice,
      amount: lendingAmount,
      blockNumber: currentBlock,
      newBalance: expectedBalance,
    });
  })

  it("should not allow you to borrow with an existing debt", async() => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await instance.borrow(web3.utils.toBN(10),{from: alice})
    await expectRevert(instance.borrow(web3.utils.toBN(10),{from: alice}),"User already has a debt")
  })

  it("should not allow you to borrow more than the available lendable amount", async() => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await expectRevert(instance.borrow(web3.utils.toBN(60),{from: alice}),"Bank has insufficient funds")
  })

  it("should not allow withdrawl if you have an overdue debt", async() => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await instance.borrow(web3.utils.toBN(10),{from: alice})
    for(let i=0; i<lendingBlockCount; i++)
    {
      await time.advanceBlock();
    }
    await expectRevert(instance.withdraw(deposit, {from: alice}),"Overdue debt")
  })

  it("should use deposit to repay debt if you have an overdue debt", async() => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await instance.borrow(web3.utils.toBN(10),{from: alice})
    for(let i=0; i<lendingBlockCount; i++)
    {
      await time.advanceBlock();
    }
    result = await instance.deposit({from: alice, value: deposit});
    const expectedDebtAmount = web3.utils.toBN(10).sub(deposit);
    expectEvent(result, 'LogRepayment', {
      accountAddress: alice,
      amount: deposit,
      newDebtAmount: expectedDebtAmount,
    });
  })

  it("should use deposit to repay debt if you have an overdue debt and should deposit remainder", async() => {
    await instance.addLendableFunds({from: owner, value: lendingAmount})
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: deposit})
    await instance.borrow(web3.utils.toBN(10),{from: alice})
    for(let i=0; i<lendingBlockCount; i++)
    {
      await time.advanceBlock();
    }
    result = await instance.deposit({from: alice, value: web3.utils.toBN(20)});
    expectEvent(result, 'LogRepayment', {
      accountAddress: alice,
      amount: web3.utils.toBN(10),
      newDebtAmount: web3.utils.toBN(0),
    });

    expectEvent(result, 'LogDepositMade', {
      accountAddress: alice,
      amount: web3.utils.toBN(10),
    });
  })
})
