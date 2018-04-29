pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./VitaDataAdmin.sol";
import "./ERC20Basic.sol";
import "./SafeMath.sol";

contract VitaDataToken is ERC20Basic, VitaDataAdmin {
    using SafeMath for uint256;

    uint public _totalSupply = 50000000000000000000000000;

    string public constant symbol = "VDT";
    string public constant name = "VitaData";
    uint8 public constant decimals = 18;

    //1 Ether = 10000 VDT token
    uint256 public constant RATE = 10000;

    address public owner;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    function ()  payable external {
        createTokens();
    }

    function Constructor() public {
        owner = msg.sender;
    }

    function createTokens() payable  public {
        require(
            msg.value > 0
            );
        uint256 tokens = msg.value.safeMul(RATE);
        balances[msg.sender] = balances[msg.sender].safeAdd(tokens);
        _totalSupply = _totalSupply.safeSub(tokens);
        owner.transfer(msg.value);
    }

    function totalSupply() external  view returns (uint256 totalSupply) {
        return _totalSupply;
    }

    function balanceOf(address _owner) external  view  returns (uint256 balance) {

        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool success) {
        require(
            balances[msg.sender] >= _value && _value > 0
            );
        balances[msg.sender] = balances[msg.sender].safeSub(_value);
        balances[_to] = balances[_to].safeAdd(_value);
        emit Transfer(msg.sender, _to, _value);
        return true;
    }



    event Transfer(address indexed _from, address indexed _to, uint256 _value);
}
