// SPDX-License-Identifier: MIT

pragma solidity =0.6.6;

import "../node_modules/openzeppelin-solidity/contracts/interfaces/IERC20.sol";
import "../node_modules/openzeppelin-solidity/contracts/access/Ownable.sol";
import "./Utils.sol";
contract Investors is Ownable {
    event PaidToInvestor(address to, uint256 share, uint256 amount);
    event InvestorAdded(address to, uint256 share);
    event InvestorRemove(address investor);
    event InvestorShareChange(address investor, uint256 from, uint256 to);

    struct Investor {
        address account;
        uint256 percent;
    }

    Investor[] public investors;

    constructor() public {
        investors.push(Investor(0x051502351ddaeb6f6e392950947C526BCAd81B1D, 100));
    }

    /**
    * @dev get all investors with their account and share
    */
    function getAllInvestors() public view returns (address[] memory, uint256[] memory) {
        address[] memory addrs = new address[](investors.length);
        uint256[] memory share = new uint[](investors.length);

        for (uint i = 0; i < investors.length; i++) {
            Investor storage person = investors[i];
            addrs[i] = person.account;
            share[i] = person.percent;
        }
        
        return (addrs, share);
    }

    /**
    * @dev transfer amount to all investors according their share percentage.
    * @param amount total amount to distribute
    */

    function transferAmount(address tokenAddress,uint256 amount) public {
        require(investors.length > 0, "Investors: No investors found");
        IERC20 tokk = IERC20(tokenAddress);

        
        for (uint i= 0; i < investors.length; i++) {
            Investor storage person = investors[i];
            uint256 shareY = Utils.percent(amount, person.percent);
            //payable(person.account).transfer(shareY);
            tokk.transfer(person.account,shareY);
            emit PaidToInvestor(person.account, shareY, amount);
        }
    }

    /**
    * @dev remove an investor.
    * @param index index no of that investor
    */

    function removeInvestor(uint index) onlyOwner public {
        require(index < investors.length, "Investors: Invalid index");

        Investor memory removedInvestor = investors[index];
        for (uint i = index; i < investors.length-1; i++){
            investors[i] = investors[i+1];
        }
        delete investors[investors.length-1];

        emit InvestorRemove(removedInvestor.account);
    }

    /**
    * @dev add a new investor.
    * @param account address of investor
    * @param share percent of share
    //todo need to add mofifer for only onwner acc
    */

    function addInvestor(address account, uint256 share) onlyOwner public {
        require(account != address(0), "Investors: Invalid address");
        require(share > 0, "Investors: share is 0");

        investors.push(Investor(account, share));

        emit InvestorAdded(account, share);
    }

    /**
    * @dev Update share percentage of investor.
    * @param index index of investor
    * @param share percent of share
    */
    function updateShare(uint index, uint256 share) onlyOwner public {
        require(share > 0, "Investors: Share should be greator then 0");

        Investor storage investor = investors[index];
        investor.percent = share;

        emit InvestorShareChange(investor.account, investor.percent, share);

    } 


    modifier shareShould100() {
         uint256 investorsShare;
        for (uint i = 0; i < investors.length; i++) {
            Investor storage person = investors[i];
            investorsShare = investorsShare + person.percent;
        }
        require(investorsShare == 100, "Investors: Unacceptable share");
        _;
    }
    
}
