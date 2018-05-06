 /*
 * ERC20 interface
 * see https://github.com/ethereum/EIPs/issues/20
 */
pragma solidity ^0.4.23;
pragma experimental "v0.5.0";


interface ERC20Basic {
    function totalSupply() external view returns (uint256);
    function balanceOf(address who) external view returns (uint256);
    function transfer(address to, uint256 value) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
}
