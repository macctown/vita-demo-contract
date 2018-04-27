pragma solidity ^0.4.11;

import './VitaDeviceManager.sol';
import './SafeMath.sol';

contract VitaDataManager is VitaDeviceManager {
	
	using SafeMath for uint;

	struct VitaData {
		string data;
		uint timestamp;
	}

	struct MetaData {
		string deviceType;
		string deviceVersion;
		address deviceId;
		string flags;
	}

	struct VitaDataDTO {
        VitaData vitaData;
        MetaData metaData;
    }

	uint totalVitaData;
	address[] vitaDataList;
	uint totalFlags;
	string[] flagList;
	mapping(string => VitaDTO[]) flagToDataMap;
	mapping(address => VitaDTO[]) deviceToDataMap;

	function upload(string vitaData, address deviceId, string deviceType, string deviceVersion, string flags) allowedDevice(deviceId) public {

		string flagOnly = flags;
		string flagDeviceType = flags + deviceType;
		string flgsDeviceTypeDeviceVersion = flags + deviceType + deviceVersion;

		MetaData tmpMD = MetaData(deviceId, deviceVersion, deviceType);
		VitaData tmpVD = VitaData(vitaData, now);

		flagList.push(flagOnly);
		totalFlags = totalFlags.add(1);
		flagToDataMap[flagOnly] = VitaDataDTO(tmpVD, tmpMD);

		flagList.push(flagDeviceType);
		totalFlags = totalFlags.add(1);
		flagToDataMap[flagDeviceType] = VitaDataDTO(tmpVD, tmpMD);

		flagList.push(flgsDeviceTypeDeviceVersion);
		totalFlags = totalFlags.add(1);
		flagToDataMap[flgsDeviceTypeDeviceVersion] = VitaDataDTO(tmpVD, tmpMD);

		deviceToDataMap[deviceId] = VitaDataDTO(tmpVD, tmpMD);
	}

	function querySummary(string flags) returns(uint count) {
		return flagToDataMap[flags].array;
	}

	function queryData(String flags) returns(string[] data, uint[] timestamp, address[] deviceId, string[] deviceType, string[] deviceVersion, string[] flags) {

	}

}