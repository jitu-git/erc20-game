const price = artifacts.require("GetPrice");

// Game contarct address
const  price_contract_address = '0x07fEA270Dea5C77856df61296007f8FF72cfe0B9';

module.exports = async function(callback) {

  let accounts = await web3.eth.getAccounts()
  const instance = await contract.at(price_contract_address);
  

  await instance.getThePrice({
    from: accounts[0],
  }).then(function(res) {
    console.log(JSON.stringify(res, null, 4));
    callback();
  });



};
