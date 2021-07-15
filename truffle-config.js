var infuraEndpoint = "https://goerli.infura.io/v3/0706a68d827741d68795befea84d4205";
const HDWalletProvider = require('truffle-hdwallet-provider');
const privateKeys = ["0xf2309708661390b28b35b1368de0b317953a3e08262e08a6a7c19dafd4e33eb5"];

module.exports = {
  plugins:[
    'truffle-plugin-verify'
  ],
  api_keys:{
    etherscan:'7V8SH8383TNV3QIMNBUUETVEJYFEDHN335'
  },
 networks: {
matic: {
  provider: () => new HDWalletProvider(privateKeys, `https://matic-mainnet.chainstacklabs.com`),
  network_id: 137,
  chain_id: 137,
  confirmations: 2,
  timeoutBlocks: 200,
  skipDryRun: true
},
goerli: {
  provider:() =>new HDWalletProvider(privateKeys, infuraEndpoint),
  network_id: 5,
  skipDryRun: true
 },
 bsc: {
  provider: () => new HDWalletProvider(privateKeys, `https://data-seed-prebsc-2-s3.binance.org:8545/`),
      network_id: 97,
      confirmations: 1,
      timeoutBlocks: 100,
      skipDryRun: true
 }
 },
 compilers: {
    solc: {
      version: "0.6.6",
      settings: {
        optimizer: {
          enabled: true
        }
      }
    }
  }
};