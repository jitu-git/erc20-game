pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/math/SafeMath.sol";

library Utils {
    function percent(uint256 eth_amount, uint256 percent_amount) public pure returns(uint256 amount) {
        amount = (eth_amount * percent_amount) / 100;
        return (amount);
    }
}
