var VitaDataManager = artifacts.require("./VitaDataManager.sol");

module.exports = function(deployer) {
  deployer.deploy(VitaDataManager);
};
