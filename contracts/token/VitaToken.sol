pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "../VitaDataAdmin.sol";
import "./BasicToken.sol";
import "../lib/SafeMath.sol";

contract VitaToken is BasicToken, VitaDataAdmin {

    using SafeMath for uint256;

    function reward(address _add, uint256 _value) internal {

        totalSupply_ = totalSupply_.safeAdd(_value);
        balances[_add] = balances[_add].safeAdd(_value);
        emit Reward(_add, _value);
    }

    event Reward(address indexed add, uint256 _value);

}
