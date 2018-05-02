pragma solidity ^0.4.23;

import "./VitaDataManager.sol";

contract VitaCore is VitaDataManager{

function upload(string vitaData, string metaData, address deviceId, string deviceType, string deviceVersion, string flags) allowedDevice(deviceId) public {

        string memory dataPrefix = "{\"vitaData\":{".toSlice().concat(vitaData.toSlice());
        string memory dataPostFix = "}, \"metaData\":{".toSlice().concat(metaData.toSlice()).toSlice().concat("}".toSlice());
        string memory dataRes = dataPrefix.toSlice().concat(dataPostFix.toSlice());

        if (!isFlagsExist(flags)) {
            flagList.push(flags);
            totalFlags = totalFlags.safeAdd(1);
            flagToDataMap[flags] = new string[](0);
        }
        flagToDataMap[flags].push(dataRes);

        string memory flagDeviceType = flags.toSlice().concat(deviceType.toSlice());
        if (!isFlagsExist(flagDeviceType)) {
            flagList.push(flagDeviceType);
            totalFlags = totalFlags.safeAdd(1);
            flagToDataMap[flagDeviceType] = new string[](0);
        }
        flagToDataMap[flagDeviceType].push(dataRes);

        string memory flagDeviceTypeDeviceVersion = flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deviceVersion.toSlice());
        if (!isFlagsExist(flagDeviceTypeDeviceVersion)) {
            flagList.push(flagDeviceTypeDeviceVersion);
            totalFlags = totalFlags.safeAdd(1);
            flagToDataMap[flagDeviceTypeDeviceVersion] = new string[](0);
        }
        flagToDataMap[flagDeviceTypeDeviceVersion].push(dataRes);

        /* solium-disable-next-line */
        emit DataUploaded(deviceId, now);

        reward(deviceId, 1 wei);
    }
}
