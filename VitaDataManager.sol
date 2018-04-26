pragma solidity ^0.4.11;

import './VitaDeviceManager.sol';
import './SafeMath.sol';

contract VitaDataManager is VitaDeviceManager {
	
	using SafeMath for uint;

	struct VitaDataDTO {
        string vitaData;
        string metaData;
    }

	uint totalVitaData;
	address[] vitaDataList;
	uint totalFalgs;
	string[] flagList;
	mapping(string => VitaDTO[]) flagToDataMap;
	mapping(address => VitaDTO[]) deviceToDataMap;

	function upload(string vitaData, string metaData, address deviceId, string flags) allowedDevice(deviceId) public {



	}

}