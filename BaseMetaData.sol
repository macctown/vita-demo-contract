pragma solidity ^0.4.0;

import './MetaData';
contract BaseMetaData is MetaData{
  
  string flags;
  address deviceId;
  string deviceType;
  string deviceVersion;
  
  function BaseMetaData(string flags) public {
    
  }
  
  
}
