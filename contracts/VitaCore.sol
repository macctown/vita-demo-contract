pragma solidity ^0.4.23;

import "./VitaDataManager.sol";

contract VitaCore is VitaDataManager{



    function Constructor() public pure{

    }

    function upload(string vitaData, address deviceId, string flags) allowedDevice(deviceId) public {

        if (!isFlagsExist(flags)) {
            flagList.push(flags);
            totalFlags = totalFlags.safeAdd(1);
            flagToDataMap[flags] = new string[](0);
        }
        flagToDataMap[flags].push(vitaData);


        // GeneralDevice memory device = deviceInfos[deviceId];
        // if(device.deviceType != 0x0){

        // }
        // string memory flagDeviceType = flags.toSlice().concat(deviceType.toSlice());
        // if (!isFlagsExist(flagDeviceType)) {
        //     flagList.push(flagDeviceType);
        //     totalFlags = totalFlags.safeAdd(1);
        //     flagToDataMap[flagDeviceType] = new string[](0);
        // }
        // flagToDataMap[flagDeviceType].push(vitaData);

        // string memory flagDeviceTypeDeviceVersion = flags.toSlice().concat(deviceType.toSlice()).toSlice().concat(deviceVersion.toSlice());
        // if (!isFlagsExist(flagDeviceTypeDeviceVersion)) {
        //     flagList.push(flagDeviceTypeDeviceVersion);
        //     totalFlags = totalFlags.safeAdd(1);
        //     flagToDataMap[flagDeviceTypeDeviceVersion] = new string[](0);
        // }
        // flagToDataMap[flagDeviceTypeDeviceVersion].push(vitaData);

        /* solium-disable-next-line */
        emit DataUploaded(deviceId, now);

        reward(deviceId, 1);
    }
}
