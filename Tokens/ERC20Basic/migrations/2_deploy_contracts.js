const ERC20Basic = artifacts.require("ERC20Basic");

module.exports = function(deployer) {
  deployer.deploy(ERC20Basic);
};