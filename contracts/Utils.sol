pragma solidity =0.6.6;

import "../node_modules/openzeppelin-solidity/contracts/utils/math/SafeMath.sol";

library Utils {
    function percent(uint256 eth_amount, uint256 percent_amount) public pure returns(uint256 amount) {
        amount = (eth_amount * percent_amount) / 100;
        return (amount);
    }
}
