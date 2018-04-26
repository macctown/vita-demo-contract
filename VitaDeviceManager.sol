pragma solidity ^0.4.11;

import './VitaDataToken.sol';
import './SafeMath.sol';

contract VitaDeviceManager is VitaDataToken {
	
	using SafeMath for uint;

	struct GeneralDevice {
        address deviceId;
        string deviceVersion;
        string deviceType;
    }
	
	uint totalDevice;
	address[] deviceList;
	mapping(address => boolean) devicePermission;
	mapping(address => GeneralDevice) deviceInfos;

	event NewDevice (
      address deviceId
    );

	modifier deviceExist(address deviceId) {
        var device = devicePermission[deviceId];
        assert(device.id != 0x0);
        _;
    }

    modifier deviceNotExist(address deviceId) {
        var device = devicePermission[deviceId];
        assert(device.id == 0x0);
        _;
    }

    modifier allowedDevice(address deviceId) {
        assert(devicePermission[deviceId]);
        _;
    }

    function addDevice(address deviceId, string deviceVersion, string deviceType) deviceNotExist(deviceId) {
        deviceInfos[deviceId] = GeneralDevice(deviceId, deviceVersion, deviceType);
        devicePermission[deviceId] = false;
        totalDevice = totalDevice.add(1);
        deviceList.push(deviceId);
        NewDevice(deviceId);
    }

	function allow(address deviceId) deviceExist(deviceId) public {
		devicePermission[deviceId] = true;
		return devicePermission[deviceId];
	}

	function allow(string deviceType) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.id != 0x0) {
				if (curDevice.deviceType == deviceType) {
					devicePermission[deviceId] = true;
				}
			}
		}
	}

	function allow(string deviceType, string deviceVersion) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.id != 0x0) {
				if (curDevice.deviceType == deviceType && curDevice.deviceVersion == deviceVersion) {
					devicePermission[deviceId] = true;
				}
			}
		}
	}

	function disallow(address deviceId) deviceExist(deviceId) public {
		devicePermission[deviceId] = false;
		return devicePermission[deviceId];
	}

	function disallow(string deviceType) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.id != 0x0) {
				if (curDevice.deviceType == deviceType) {
					devicePermission[deviceId] = false;
				}
			}
		}
	}

	function disallow(string deviceType, string deviceVersion) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.id != 0x0) {
				if (curDevice.deviceType == deviceType && curDevice.deviceVersion == deviceVersion) {
					devicePermission[deviceId] = false;
				}
			}
		}
	}

	function queryDevice(address queryDeviceId) public returns (address deviceId, string deviceType, string deviceVersion) {

        var device = deviceInfos[queryDeviceId];
        address deviceId = queryDeviceId;
        string deviceType = device.deviceType;
        string deviceVersion = device.deviceVersion;

	}

}