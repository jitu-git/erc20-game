const Utils = artifacts.require("Utils")
// const Investors = artifacts.require("Investors");
const Game = artifacts.require("Game");

module.exports = async function (deployer) {
 await deployer.deploy(Utils);
//  await deployer.link(Utils,Investors);
//  await deployer.deploy(Investors);
 await deployer.link(Utils,Game);
 await deployer.deploy(Game,'0xBbe3d6530960b67240f7C1b0106d977880278cCe','0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984')
};