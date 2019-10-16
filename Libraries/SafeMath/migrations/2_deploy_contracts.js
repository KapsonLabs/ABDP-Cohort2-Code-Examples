let Shop = artifacts.require("Shop");

module.exports = function(deployer) {
    deployer.deploy(Shop);
};