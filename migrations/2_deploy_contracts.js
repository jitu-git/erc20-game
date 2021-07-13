const Game = artifacts.require("Game");
const Utils = artifacts.require("Utils");
const Investors = artifacts.require("Investors");
const GetPrice = artifacts.require("GetPrice");

module.exports = async function(deployer) {
  deployer.deploy(Utils);
  //let accounts = await web3.eth.getAccounts()
  // deploying contract
  deployer.link(Utils, Game);
  deployer.link(Utils, Investors);
  const inv_instance = await deployer.deploy(Investors);
  const game_instance = await deployer.deploy(Game, "0x8fDB9C332Cc8FdDe376b9d9C53E273F557Aa869F");
  const price_instance = await deployer.deploy(GetPrice);
};
