const SimpleBankERC20 = artifacts.require("SimpleBankERC20");

module.exports = function(deployer) {
  deployer.deploy(SimpleBankERC20);
};