/*

The public version of the file used for testing can be found here: https://gist.github.com/ConsenSys-Academy/ce47850a8e2cba6ef366625b665c7fba

This test file has been updated for Truffle version 5.0. If your tests are failing, make sure that you are
using Truffle version 5.0. You can check this by running "trufffle version"  in the terminal. If version 5 is not
installed, you can uninstall the existing version with `npm uninstall -g truffle` and install the latest version (5.0)
with `npm install -g truffle`.

*/
var Bank = artifacts.require("./VulnerableBank.sol");
var Malicious = artifacts.require("./Malicious.sol");

contract('VulnerableBank', function(accounts) {

  const owner = accounts[0]
  const alice = accounts[1]
  const attackAcount = accounts[2]
  const aliceDeposit = web3.utils.toBN(20)
  const attackerDeposit = web3.utils.toBN(2)

  beforeEach(async () => {
    instance = await Bank.new()
    attacker = await Malicious.new(instance.address)
  })

  it("should mark addresses as enrolled", async () => {
    await instance.enroll({from: alice})
    await instance.deposit({from: alice, value: aliceDeposit})
    let bankBalance = await web3.eth.getBalance(instance.address)
    console.log(bankBalance)
    let reciept = await attacker.attack({from: attackAcount, value: attackerDeposit})
    bankBalance = await web3.eth.getBalance(instance.address)
    console.log(bankBalance)
    const aliceEnrolled = false;
    assert.equal(aliceEnrolled, true, 'enroll balance is incorrect, check balance method or constructor')
  });

})
