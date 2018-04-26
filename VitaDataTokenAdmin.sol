pragma solidity ^0.4.11;

contract VitaDataTokenAdmin {
    
	address public cooAddress;
	address public ceoAddress;
	address public cfoAddress;

	modifier onlyCLevel() {
        require(
            msg.sender == cooAddress ||
            msg.sender == ceoAddress ||
            msg.sender == cfoAddress
        );
        _;
    }

}