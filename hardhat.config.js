require("@nomiclabs/hardhat-ethers");
require("dotenv").config();

module.exports = {
  solidity: {
    version: "0.8.20",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    fhenix: {
      url: "https://api.testnet.fhenix.zone:7747", // Fhenix testnet URL
      accounts: [process.env.PRIVATE_KEY],
    },
  },
};
