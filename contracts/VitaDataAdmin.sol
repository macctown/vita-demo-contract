pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

contract VitaDataAdmin {

    address public cooAddress;
    address public ceoAddress;
    address public cfoAddress;

    modifier onlyCLevel() {
        require(
            msg.sender == cooAddress || msg.sender == ceoAddress || msg.sender == cfoAddress
        );
        _;
    }

}
