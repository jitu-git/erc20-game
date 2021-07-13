// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./Investors.sol";
import "./Utils.sol";

contract Game is Investors {

    event PaidToGame(address to, uint256 amount);
    event GameShareChanged(uint256 from, uint256 to);
    event InvestorsShareChanged(uint256 from, uint256 to);
    event GameShareHolderChanged(address from, address to);


    uint public gameShare = 30;
    uint public investorsShare = 70;
    address public gameShareHolder;


    constructor(address _gameShareHolder) {
        // set address of game share holder
        gameShareHolder = _gameShareHolder;
    }

    receive() payable external shareShould100  {
        uint256 eth_amount = msg.value;

        uint256 shareX = Utils.percent(eth_amount, gameShare);
        uint256 shareY = Utils.percent(eth_amount, investorsShare);

        // transfer amount to game
        payable(gameShareHolder).transfer(shareX);
        emit PaidToGame(gameShareHolder, shareX);

        // transfer remainig amount to all investors
       transferAmount(shareY);

    }


    function percent1(uint numerator, uint denominator, uint precision) 
        public pure returns(uint quotient) {
            // caution, check safe-to-multiply here
            uint _numerator  = numerator * 10 ** (precision+1);
            // with rounding of last digit
            uint _quotient =  ((_numerator / denominator) + 5) / 10;
            return ( _quotient);
    }

    /**
     * @dev change the game share.
     * @param _share new share percent of game
    */

    function updateGameShare(uint256 _share) onlyOwner public {
        require(_share > 0, "Game: game share should be greater then 0");
        require(_share <= 100, "Game: Invalid share");
        
        uint256 oldShare = gameShare;
        uint256 oldInvestorsShare = investorsShare;

        // update game share
        gameShare = _share;

        // update investors share
        investorsShare = (100 - _share);

        emit GameShareChanged(oldShare, _share);
        emit InvestorsShareChanged(oldInvestorsShare, investorsShare);
    }

    /**
     * @dev change the address of game share holder.
     * @param _holder the address of new account
    */
    function changeGameShareHolder(address _holder) onlyOwner public {
        require(_holder != address(0), "Game: Invalid address for game share holder");

        address oldHolder = gameShareHolder;

        // change game share holder address
        gameShareHolder = _holder;

        emit GameShareHolderChanged(oldHolder, _holder);
    }

    /**
    * @dev return share percent of game
    */
    function getGameShare() public view returns (uint256) {
        return gameShare;
    }

    /**
    * @dev return share percent of all investors
    */
    function getInvestorsShare() public view returns (uint256) {
        return investorsShare;
    }

    /**
    * @dev Add new investor
    * @param account the address of new investor
    * @param share the percent of new investor
    */
    function addNewInvestor(address account, uint256 share) onlyOwner public {
        addInvestor(account, share);
    }

    function getInvestors() public view  returns (address[] memory, uint256[] memory) {
        return getAllInvestors();
    }
}