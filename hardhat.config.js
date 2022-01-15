require("@nomiclabs/hardhat-waffle");
require("solidity-coverage");
require('@nomiclabs/hardhat-ethers');
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();
require("hardhat-deploy");

module.exports = {
    solidity: {
        version: "0.8.11",
        settings: {
            optimizer: {
                enabled: true,
                runs: 200
            }
        }
    },
    networks: {
        rinkeby: {
            url: process.env.ETHEREUM_RINKEBY_URL,
            accounts: [process.env.PRIVATE_KEY],
            gasPrice: 5000000001, // 5 GWei
        },
        mainnet: {
            url: process.env.ETHEREUM_MAINNET_URL,
            accounts: [process.env.PRIVATE_KEY],
            gasPrice: 50000000001, // 50 GWei
        }
    },
    etherscan: {
        apiKey: process.env.SCAN_API_KEY
    }
};
