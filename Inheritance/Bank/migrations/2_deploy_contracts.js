let SimpleLendingBank = artifacts.require("SimpleLendingBank");

module.exports = function(deployer) {
    deployer.deploy(SimpleLendingBank,web3.utils.toBN(100));
};
