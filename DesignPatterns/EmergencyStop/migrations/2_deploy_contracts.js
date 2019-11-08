let SimpleBank = artifacts.require("SimpleBankEmergencyStop");

module.exports = function(deployer) {
  deployer.deploy(SimpleBank);
};