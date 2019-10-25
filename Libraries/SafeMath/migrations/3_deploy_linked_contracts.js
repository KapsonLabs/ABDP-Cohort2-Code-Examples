let SafeMathLinked = artifacts.require("SafeMathLinked");
let SimpleBankLinked = artifacts.require("SimpleBankLinked");
let SimpleBankLinkedUsing = artifacts.require("SimpleBankLinkedUsing");

module.exports = function(deployer) {
  deployer.deploy(SafeMathLinked);
  deployer.link(SafeMathLinked, [SimpleBankLinked,SimpleBankLinkedUsing]);
  deployer.deploy(SimpleBankLinked);
  deployer.deploy(SimpleBankLinkedUsing);
};
