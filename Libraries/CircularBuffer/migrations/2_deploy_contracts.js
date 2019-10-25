let UserQueue = artifacts.require("UserQueue");

module.exports = function(deployer) {
    deployer.deploy(UserQueue);
};
