let catchRevert = require("./exceptionsHelpers.js").catchRevert
var UserQueue = artifacts.require("./UserQueue.sol")

contract('UserQueue', function(accounts) {

  const alice = accounts[0]
  const bob = accounts[1]
  const firstDataA = "firstAlice"
  const secondDataA = "secondAlice"
  const thirdDataA = "thirdAlice"
  const firstDataB = "firstBob"
  const secondDataB = "secondBob"

  beforeEach(async () => {
    instance = await UserQueue.new()
  })

  it("should add item to user specific queue", async () => {
    await instance.pushData(web3.utils.asciiToHex(firstDataA),{from: alice})
    await instance.pushData(web3.utils.asciiToHex(secondDataA),{from: alice})
    await instance.pushData(web3.utils.asciiToHex(thirdDataA),{from: alice})
    await instance.pushData(web3.utils.asciiToHex(firstDataB),{from: bob})
    await instance.pushData(web3.utils.asciiToHex(secondDataB),{from: bob})

    const aliceDataCount = await instance.queueDepth({from: alice})
    const bobDataCount = await instance.queueDepth({from: bob})
    assert.equal(aliceDataCount, 3, 'alice queue depth balance is incorrect')
    assert.equal(bobDataCount, 2, 'bob queue depth balance is incorrect')
  });

  it("should pop items in order", async () => {
    await instance.pushData(web3.utils.asciiToHex(firstDataA),{from: alice})
    await instance.pushData(web3.utils.asciiToHex(secondDataA),{from: alice})
    await instance.pushData(web3.utils.asciiToHex(thirdDataA),{from: alice})
    await instance.pushData(web3.utils.asciiToHex(firstDataB),{from: bob})
    await instance.pushData(web3.utils.asciiToHex(secondDataB),{from: bob})

    await instance.popData({from: alice})
    const pop1 = await instance.getLastPopped()
    await instance.popData({from: alice})
    const pop2 = await instance.getLastPopped()
    await instance.popData({from: bob})
    const pop3 = await instance.getLastPopped()
    await instance.popData({from: alice})
    const pop4 = await instance.getLastPopped()

    assert.equal(web3.utils.hexToUtf8(pop1), firstDataA)
    assert.equal(web3.utils.hexToUtf8(pop2), secondDataA)
    assert.equal(web3.utils.hexToUtf8(pop3), firstDataB)
    assert.equal(web3.utils.hexToUtf8(pop4), thirdDataA)

    const aliceDataCount = await instance.queueDepth({from: alice})
    const bobDataCount = await instance.queueDepth({from: bob})

    assert.equal(aliceDataCount, 0, 'alice queue depth balance is incorrect')
    assert.equal(bobDataCount, 1, 'bob queue depth balance is incorrect')
  });

});
