pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./VitaDeviceManager.sol";
import "./SafeMath.sol";
import "./strings.sol";

contract VitaDataManager is VitaDeviceManager {

    using SafeMath for uint;
    using strings for *;

    uint public totalFlags;
    string[] public flagList;
    mapping(string => string[]) flagToDataMap;

    event DataUploaded(
        address deviceId,
        uint timstamp
    );

    function isFlagsExist(string flags) public view returns (bool isExist) {

        for (uint i = 0; i < totalFlags; i++) {
            if (keccak256(flagList[i]) == keccak256(flags)) {
                return true;
            }
        }
        return false;
    }



    function querySummary(string flags, string deviceType, string deivceVersion) external view returns(uint count) {
        return flagToDataMap[flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deivceVersion.toSlice())].length;
    }

    function queryData(string flags, string deviceType, string deivceVersion) external view returns(string dataInJson)  {
        string memory flagConcate = flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deivceVersion.toSlice());
        for (uint i = 0; i < totalFlags; i++) {
            if (keccak256(flagConcate) == keccak256(flagList[i])) {
                return jsonFactory(flagToDataMap[flagList[i]], flagConcate);
            }
        }
        return jsonFactory(new string[](0), flagConcate);
    }

    function querySummary(string flags, string deviceType) external view returns(uint count) {
        return flagToDataMap[flags.toSlice().concat(deviceType.toSlice())].length;
    }

    function queryData(string flags, string deviceType) external view returns(string dataInJson)  {

        for (uint i = 0; i < totalFlags; i++) {
            if (keccak256(flags.toSlice().concat(deviceType.toSlice())) == keccak256(flagList[i])) {
                return jsonFactory(flagToDataMap[flagList[i]], flags.toSlice().concat(deviceType.toSlice()));
            }
        }
        return jsonFactory(new string[](0), flags.toSlice().concat(deviceType.toSlice()));
    }

    function querySummary(string flags) external view returns(uint count)  {
        return flagToDataMap[flags].length;
    }

    function queryData(string flags) external view returns(string dataInJson)  {

        for (uint i = 0; i < totalFlags; i++) {
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
    function jsonFactory(string[] rawResult, string flags) internal pure returns(string dataInJson){

        if(rawResult.length == 0) {
            /* solium-disable-next-line */
            dataInJson = "{ \"result\":{\"status\":404, \"flags\":\"".toSlice().concat(flags.toSlice()).toSlice().concat( "\", \"data\":\"\"".toSlice());
        } else {
            /* solium-disable-next-line */
            dataInJson = "{ \"result\":{\"status\":200, \"flags\":\"".toSlice().concat(flags.toSlice()).toSlice().concat( "\", \"data\":\"".toSlice());
            for (uint i = 0; i < rawResult.length; i++) {
                dataInJson = dataInJson.toSlice().concat(rawResult[i].toSlice()).toSlice().concat(",".toSlice());
            }
        }
        dataInJson = dataInJson.toSlice().concat("}}".toSlice());
    }
}
