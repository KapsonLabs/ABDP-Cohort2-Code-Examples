let SimpleBankEmbedded = artifacts.require("SimpleBankEmbedded");
let SimpleBankEmbeddedUsing = artifacts.require("SimpleBankEmbeddedUsing");

module.exports = function(deployer) {
    deployer.deploy(SimpleBankEmbedded);
    deployer.deploy(SimpleBankEmbeddedUsing);
};
