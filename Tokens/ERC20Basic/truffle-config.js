const HDWalletProvider = require("truffle-hdwallet-provider");
const privatekey =
  "1D67079F14635DA3D5774BA695AD91B14F8E084E90B1ED6A651D250E9DE91672";

module.exports = {
  // See <http://truffleframework.com/docs/advanced/configuration>
  // to customize your Truffle configuration!
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: function() {
        return new HDWalletProvider(
          privatekey,
          "https://rinkeby.infura.io/v3/a8853810b5054964b0fbe19c8e02e9c1"
        );
      },
      network_id: 4,
      gas: 4698712,
      gasPrice: 25000000000
    }
  }
};