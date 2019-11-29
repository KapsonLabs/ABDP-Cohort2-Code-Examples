const SimpleBankToken = artifacts.require("SimpleBankToken");

module.exports = function(deployer) {
  deployer.deploy(SimpleBankToken);
};