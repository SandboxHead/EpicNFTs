require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config({path : ".env"});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.1",
  networks: {
    rinkeby : {
      url : process.env.RINKEBY_NODE_URL,
      accounts : [process.env.RINKYBY_PRIVATE_KEY]
    }
  }
};

