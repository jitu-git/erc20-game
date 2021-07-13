const HDWalletProvider = require("@truffle/hdwallet-provider");

module.exports = {
  // Uncommenting the defaults below 
  // provides for an easier quick-start with Ganache.
  // You can also follow this format for other networks;
  // see <http://truffleframework.com/docs/advanced/configuration>
  // for more details on how to specify configuration options!
  //
  networks: {
   development: {
     host: "127.0.0.1",
     port: 7545,
     network_id: "*"
   },
   test: {
     host: "127.0.0.1",
     port: 7545,
     network_id: "*"
   },
   kovan : {
    provider: function(){
      return new HDWalletProvider(
        "PRIVATE_KEY",
        'https://kovan.infura.io/v3/INFURA_APP_ID'
      )
    },
    gas: 5000000,
    gasPrice: 25000000000,
    network_id: 42
    }
  },
  

  compilers: {
    solc: {
      version: "^0.8.0"
    }
  },
};
