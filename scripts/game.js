const contract = artifacts.require("Game");
const investors = artifacts.require("Investors");

// Game contarct address
const  game_contract_address = '0x07fEA270Dea5C77856df61296007f8FF72cfe0B9';
const  inv_contract_address = '0x90b992C10EA4454Cd2076D851E5DFCfd0918A57d';

module.exports = async function(callback) {

  let accounts = await web3.eth.getAccounts()
  const instance = await contract.at(game_contract_address);
  const investor = await investors.at(inv_contract_address);
  
  // send 1 ETH to smart contract
  // console.log("================");
  console.log("Adding 1st investor");
  await instance.addNewInvestor('0x77057e87612c2b2fb5849705edaf08Ee9625232f', 20, {
    from: accounts[0]
  }).then(function(result) {
    // console.log(result);
  });

  // console.log("================");
  // console.log("Adding 2nd investor");

  // await instance.addNewInvestor('0x3313aD49DA763F34c6BA7F9719F091f624e55cE6', 30, {
  //   from: accounts[0]
  // }).then(function(result) {
  //   // console.log(result);
  // });;

  // console.log("================");
  // console.log("get all investors");

  await instance.getInvestors({
    from: accounts[0],
  }).then(function(res) {
    console.log(JSON.stringify(res, null, 4));
    if (res[1]) {
      let BN = web3.utils.BN;
      for(let i=0; i < res[1].length; i++) {
        console.log( new BN(res[1][i]).toString());
      }
    }
    // callback();
  });

  console.log("================");
  console.log("Sending 1 ETH to smart contract");

  await instance.sendTransaction({
    from: accounts[0],
    value: web3.utils.toWei('1', 'ether')
  }).then(function(result) {
    console.log(JSON.stringify(result, null, 4));
    callback();
  });

};
