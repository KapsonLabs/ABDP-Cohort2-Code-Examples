let SimpleBankEmbedded = artifacts.require("SimpleBankEmbedded");
let SimpleBankEmbeddedUsing = artifacts.require("SimpleBankEmbeddedUsing");
let SimpleBankZeppelin = artifacts.require("SimpleBankZeppelin");

module.exports = function(deployer) {
    deployer.deploy(SimpleBankEmbedded);
    deployer.deploy(SimpleBankEmbeddedUsing);
};
