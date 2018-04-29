pragma solidity ^0.4.11;

import './VitaDeviceManager.sol';
import './SafeMath.sol';
import './strings.sol';

contract VitaDataManager is VitaDeviceManager {
	
	using SafeMath for uint;
	using strings for *;

	address[] deviceList;
	uint totalFlags;
	string[] flagList;
	mapping(string => string[]) flagToDataMap;
	mapping(address => string[]) deviceToDataMap;

    function isFlagsExist(string flags) returns (bool isExist){
        for (uint i=0;i<totalFlags;i++) {
            if (keccak256(flagList[i]) == keccak256(flags)) {
                return true;
            }
        }
        return false;
    }

	function upload(string vitaData, string metaData, address deviceId, string deviceType, string deviceVersion, string flags) allowedDevice(deviceId) public {
 
		string memory dataPrefix = '{"vitaData":{'.toSlice().concat(vitaData.toSlice());
		string memory dataPostFix = '}, "metaData":{'.toSlice().concat(metaData.toSlice()).toSlice().concat('}}'.toSlice());
		string memory dataRes = dataPrefix.toSlice().concat(dataPostFix.toSlice());
		if (!isFlagsExist(flags)) {
		    flagList.push(flags);
		    flagToDataMap[flags] = new string[](0);
		}
		flagToDataMap[flags].push(dataRes);
		
		string memory flagDeviceType = flags.toSlice().concat(deviceType.toSlice());
		if (!isFlagsExist(flagDeviceType)) {
		    flagList.push(flagDeviceType);
		    flagToDataMap[flagDeviceType] = new string[](0);
		}
		flagToDataMap[flagDeviceType].push(dataRes);
		
		string memory flagDeviceTypeDeviceVersion = flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deviceVersion.toSlice());
		if (!isFlagsExist(flagDeviceTypeDeviceVersion)) {
		    flagList.push(flagDeviceTypeDeviceVersion);
		    flagToDataMap[flagDeviceTypeDeviceVersion] = new string[](0);
		}
		flagToDataMap[flagDeviceTypeDeviceVersion].push(dataRes);
		
		deviceToDataMap[deviceId].push(dataRes);
	}

    function querySummary(string flags, string deviceType, string deivceVersion) returns(uint count) {
		return flagToDataMap[flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deivceVersion.toSlice())].length;
	}

	function queryData(string flags, string deviceType, string deivceVersion) returns(string dataInJson) {
		string memory flagConcate = flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deivceVersion.toSlice());
		for (uint i=0;i<totalFlags;i++) {
		    if (keccak256(flagConcate) == keccak256(flagList[i])) {
		        return jsonFactory(flagToDataMap[flagList[i]], flagConcate);
		    }
		}
	    return jsonFactory(new string[](0), flagConcate);
	}

	function querySummary(string flags, string deviceType) returns(uint count) {
		return flagToDataMap[flags.toSlice().concat(deviceType.toSlice())].length;
	}

	function queryData(string flags, string deviceType) returns(string dataInJson) {
		
		for (uint i=0;i<totalFlags;i++) {
		    if (keccak256(flags.toSlice().concat(deviceType.toSlice())) == keccak256(flagList[i])) {
		        return jsonFactory(flagToDataMap[flagList[i]], flags.toSlice().concat(deviceType.toSlice()));
		    }
		}
	    return jsonFactory(new string[](0), flags.toSlice().concat(deviceType.toSlice()));
	}
	
	function querySummary(string flags) returns(uint count) {
		return flagToDataMap[flags].length;
	}

	function queryData(string flags) returns(string dataInJson) {
		
		for (uint i=0;i<totalFlags;i++) {
		    if (keccak256(flags) == keccak256(flagList[i])) {
		        return jsonFactory(flagToDataMap[flagList[i]], flagList[i]);
		    }
		}
	    return jsonFactory(new string[](0), flags);
	}

     //format:
    // 1. status: 200, 404, 500
    // 2. flags
    // 3. data
    function jsonFactory(string[] rawResult, string flags) internal returns(string dataInJson){
        if(rawResult.length == 0) {
            dataInJson = '{ "result":{"status":404, "flags":"'.toSlice().concat(flags.toSlice()).toSlice().concat( '", "data":""}}'.toSlice());
        } else {
            dataInJson = '{ "result":{"status":200, "flags":"'.toSlice().concat(flags.toSlice()).toSlice().concat( '", "data":"'.toSlice());
            for (uint i=0;i<rawResult.length;i++) {
                dataInJson.toSlice().concat(rawResult[i].toSlice());
            }
        }
        return dataInJson;
    }
}