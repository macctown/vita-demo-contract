pragma solidity ^0.4.23;
pragma experimental "v0.5.0";

import "./VitaDataToken.sol";
import "./lib/SafeMath.sol";
import "./lib/strings.sol";


//TODO add C level check
contract VitaDeviceManager is VitaDataToken {

    using SafeMath for uint;
    using strings for *;

    struct GeneralDevice {
        address deviceId;
        string deviceVersion;
        string deviceType;
    }

    uint totalDevice;
    address[] deviceList;
    mapping(address => bool) public devicePermission;
    mapping(address => GeneralDevice) deviceInfos;

    event NewDevice (
        address deviceId
    );

    event DeviceAllowed (
        address deviceId
    );

    event DeviceDisallowed (
        address deviceId
    );

    modifier deviceExist(address deviceId) {
        require(deviceInfos[deviceId] != address(0x0));
        _;
    }

    modifier deviceNotExist(address deviceId) {
        require(device.deviceId == address(0x0));
        _;
    }

    modifier allowedDevice(address deviceId) {
        require(devicePermission[deviceId]);
        _;
    }

    function addDevice(address deviceId, string deviceVersion, string deviceType) validAddress(deviceId) deviceNotExist(deviceId)  external {
        deviceInfos[deviceId] = GeneralDevice(deviceId, deviceType, deviceVersion);
        devicePermission[deviceId] = true;
        totalDevice = totalDevice.safeAdd(1);
        deviceList.push(deviceId);
        emit NewDevice(deviceId);
    }


    function allow(string deviceType) external {

        for (uint i = 0; i < totalDevice; i++) {
            address deviceId = deviceList[i];
            GeneralDevice curDevice = deviceInfos[deviceId];
            if (curDevice.deviceId != 0x0) {
                if (keccak256(curDevice.deviceType) == keccak256(deviceType)) {
                    devicePermission[deviceId] = true;
                    emit DeviceAllowed(deviceId);
                }
            }
        }
    }

    function allow(address deviceId) validAddress(deviceId) deviceExist(deviceId) external {
        devicePermission[deviceId] = true;
        emit DeviceAllowed(deviceId);
    }

    function allow(string deviceType, string deviceVersion) external {

        for (uint i = 0; i < totalDevice; i++) {
            address deviceId = deviceList[i];
            GeneralDevice curDevice = deviceInfos[deviceId];
            if (curDevice.deviceId != 0x0) {
                if (keccak256(curDevice.deviceType) == keccak256(deviceType) && keccak256(curDevice.deviceVersion) == keccak256(deviceVersion)) {
                    devicePermission[deviceId] = true;
                    emit DeviceAllowed(deviceId);
                }
            }
        }
    }

    function disallow(address deviceId) validAddress(deviceId) deviceExist(deviceId) external {
        devicePermission[deviceId] = false;
        emit DeviceDisallowed(deviceId);
    }

    function disallow(string deviceType) external{

        for (uint i = 0; i < totalDevice; i++) {
            address deviceId = deviceList[i];
            GeneralDevice curDevice = deviceInfos[deviceId];
            if (curDevice.deviceId != 0x0) {
                if (keccak256(curDevice.deviceType) == keccak256(deviceType)) {
                    devicePermission[deviceId] = false;
                    emit DeviceDisallowed(deviceId);
                }
            }
        }
    }

    function disallow(string deviceType, string deviceVersion) external{

        for (uint i = 0; i < totalDevice; i++) {
            address deviceId = deviceList[i];
            GeneralDevice curDevice = deviceInfos[deviceId];
            if (curDevice.deviceId != 0x0) {
                if (keccak256(curDevice.deviceType) == keccak256(deviceType) && keccak256(curDevice.deviceVersion) == keccak256(deviceVersion)) {
                    devicePermission[deviceId] = false;
                    emit DeviceDisallowed(deviceId);
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
