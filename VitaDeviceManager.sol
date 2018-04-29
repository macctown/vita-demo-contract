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
	mapping(address => bool) devicePermission;
	mapping(address => GeneralDevice) deviceInfos;

	event NewDevice (
      address deviceId
    );

	modifier deviceExist(address deviceId) {
        var device = deviceInfos[deviceId];
        assert(device.deviceId != 0x0);
        _;
    }

    modifier deviceNotExist(address deviceId) {
        var device = deviceInfos[deviceId];
        assert(device.deviceId == 0x0);
        _;
    }

    modifier allowedDevice(address deviceId) {
        assert(devicePermission[deviceId]);
        _;
    }

    function addDevice(address deviceId, string deviceVersion, string deviceType) deviceNotExist(deviceId) {
        deviceInfos[deviceId] = GeneralDevice(deviceId, deviceVersion, deviceType);
        devicePermission[deviceId] = false;
        totalDevice = totalDevice.safeAdd(1);
        deviceList.push(deviceId);
        NewDevice(deviceId);
    }

	function allow(address deviceId) deviceExist(deviceId) public {
		devicePermission[deviceId] = true;
	}

	function allow(string deviceType) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.deviceId != 0x0) {
				if (keccak256(curDevice.deviceType) == keccak256(deviceType)) {
					devicePermission[deviceId] = true;
				}
			}
		}
	}

	function allow(string deviceType, string deviceVersion) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.deviceId != 0x0) {
				if (keccak256(curDevice.deviceType) == keccak256(deviceType) && keccak256(curDevice.deviceVersion) == keccak256(deviceVersion)) {
					devicePermission[deviceId] = true;
				}
			}
		}
	}

	function disallow(address deviceId) deviceExist(deviceId) public {
		devicePermission[deviceId] = false;
	}

	function disallow(string deviceType) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.deviceId != 0x0) {
				if (keccak256(curDevice.deviceType) == keccak256(deviceType)) {
					devicePermission[deviceId] = false;
				}
			}
		}
	}

	function disallow(string deviceType, string deviceVersion) public{
		
		for (uint i=0;i<totalDevice;i++) {
			address deviceId = deviceList[i];
			GeneralDevice curDevice = deviceInfos[deviceId];
			if (curDevice.deviceId != 0x0) {
				if (keccak256(curDevice.deviceType) == keccak256(deviceType) && keccak256(curDevice.deviceVersion) == keccak256(deviceVersion)) {
					devicePermission[deviceId] = false;
				}
			}
		}
	}

	function queryDevice(address queryDeviceId) public returns (address deviceId, string deviceType, string deviceVersion) {

        var device = deviceInfos[queryDeviceId];
        deviceId = queryDeviceId;
        deviceType = device.deviceType;
        deviceVersion = device.deviceVersion;

	}

}