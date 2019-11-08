const bank = artifacts.require("SimpleBankEmergencyStop");
let catchRevert = require("./exceptionsHelpers.js").catchRevert

contract('SimpleBankEmergencyStop', function(accounts) {
    let bankInstance;
  
    beforeEach(async () => {
        bankInstance = await bank.new()
    })

    it("Should permit an admin to pause the contract incase of emergency", async () => {

        assert.ok(await bankInstance.toggleEmergency({from: accounts[0]}));
    
    });

    it("Shouldnot allow a non-admin to pause the contract at all", async () => {

        catchRevert(bankInstance.toggleEmergency({from: accounts[2]}));
    
    });

    it("Shouldnot allow deposits when in emergency mode", async () => {

        await bankInstance.toggleEmergency({from: accounts[0]});
        await bankInstance.enroll({from: accounts[1]})
        await catchRevert(bankInstance.deposit({from: accounts[1], value: 10}))
    
    });

    it("Shouldnot allow deposits when in emergency mode", async () => {

        await bankInstance.toggleEmergency({from: accounts[0]});
        await bankInstance.enroll({from: accounts[1]})
        await catchRevert(bankInstance.deposit({from: accounts[1], value: 10}))
    
    });
});