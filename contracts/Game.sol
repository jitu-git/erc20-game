// SPDX-License-Identifier: MIT
pragma solidity =0.6.6;

import "./uniSwap/interfaces/IUniswapV2Router02.sol";
import "../node_modules/openzeppelin-solidity/contracts/interfaces/IERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";
import "./Investors.sol";
import "./Utils.sol";

contract Game is Investors {

    event PaidToGame(address to, uint256 amount);
    event GameShareChanged(uint256 from, uint256 to);
    event InvestorsShareChanged(uint256 from, uint256 to);
    event GameShareHolderChanged(address from, address to);


    address internal constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D ;
    IUniswapV2Router02 public uniswapRouter;

    uint public gameShare = 30;
    uint public investorsShare = 70;
    address public gameShareHolder;
    address public tokenAddress;

    constructor(address _gameShareHolder,address _tokenAddress) public {
        // set address of game share holder
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        gameShareHolder = _gameShareHolder;
        tokenAddress = _tokenAddress;
    }
    
    function convertEthToToken(uint tokenAmount,address tokenAdd,uint ethAmount) public {

        uint deadline1 = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
        uniswapRouter.swapExactETHForTokens{ value: ethAmount }(tokenAmount, getPathForETHtoToken(tokenAdd), address(this), deadline1);

    }

    function getPathForETHtoToken(address tokenAdd) private view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = tokenAdd;

        return path;
    }
    
    function getEstimatedETHforToken(uint tokAmount , address tokenAdd) public view returns (uint[] memory) {
        return uniswapRouter.getAmountsOut(tokAmount, getPathForETHtoToken(tokenAdd));
    }
    
    receive() payable external shareShould100 {
        
        IERC20 tokk = IERC20(tokenAddress);

        uint256 eth_amount = msg.value;
        
        convertEthToToken(getEstimatedETHforToken(eth_amount,tokenAddress)[1],tokenAddress,eth_amount);

        uint256 shareX = Utils.percent(eth_amount, gameShare);
        uint256 shareY = Utils.percent(eth_amount, investorsShare);

        // transfer amount to game
        //payable(gameShareHolder).transfer(shareX);
        
        tokk.transfer(gameShareHolder,shareX);
        emit PaidToGame(gameShareHolder, shareX);

        // transfer remainig amount to all investors
       transferAmount(tokenAddress,shareY);

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
    
    function setPairAddress(address _tokenAddress) onlyOwner public {
        tokenAddress = _tokenAddress;
    }
    
}
