require("@nomicfoundation/hardhat-toolbox");
const dotenv = require("dotenv");
dotenv.config();



/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19",
    settings: {
      optimizer: {
        enabled: true,
        runs: 50,
      },
    },
  }, //replace your own solidity compiler versionhttps://bscscan.com/tx/0x7a4a7e862e3713137e1bb95dc75a8efdd87d8d181c5237a3f31922ce94fad1b0
  networks: {
    chaos: {
      url: "https://staging-v3.skalenodes.com/v1/staging-fast-active-bellatrix",
      chainId: 1351057110, // Replace with the correct chainId for the "opbnb" network
      accounts: [process.env.PK], // Add private keys or mnemonics of accounts to use
    },
    nebula: {
      url: "https://staging-v3.skalenodes.com/v1/staging-faint-slimy-achird",
      chainId: 503129905, // Replace with the correct chainId for the "opbnb" network
      accounts: [process.env.PK], // Add private keys or mnemonics of accounts to use
    },
    calypso: {
      url: "https://staging-v3.skalenodes.com/v1/staging-utter-unripe-menkar",
      chainId: 344106930, // Replace with the correct chainId for the "opbnb" network
      accounts: [process.env.PK], // Add private keys or mnemonics of accounts to use
    },
  },
  etherscan: {
    apiKey: {
      chaos: "abc123",
      nebula: "abc1235",
    },

    customChains: [
      {
        network: "chaos",
        chainId: 1351057110, // Replace with the correct chainId for the "opbnb" network
        urls: {
          apiURL:
            "https://staging-fast-active-bellatrix.explorer.staging-v3.skalenodes.com/api",
          browserURL:
            "https://staging-fast-active-bellatrix.explorer.staging-v3.skalenodes.com/",
        },
      },
      {
        network: "nebula",
        chainId: 503129905, // Replace with the correct chainId for the "opbnb" network
        urls: {
          apiURL:
            "https://staging-faint-slimy-achird.explorer.staging-v3.skalenodes.com/api",
          browserURL:
            "https://staging-faint-slimy-achird.explorer.staging-v3.skalenodes.com/",
        },
      },
    ],
  },
};