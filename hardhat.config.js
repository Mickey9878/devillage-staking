require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
const ALCHEMY_API_KEY = "XmJSZPZQY2keSHldnJea5CzubgSpe2qe";
const ROPSTEN_PRIVATE_KEY = "e1f1dbb90182bdad0b6dba3830befff28da71edf556edd308e24bc8a6347be02";

const { privateKey } = require('./private.json');


/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",

  networks: {
    localhost: {
      url:"http://localhost:8545",
      chainId:31337,
      accounts: [privateKey],
    },

    rinkeby: {
      url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts:  [`${ROPSTEN_PRIVATE_KEY}`],
    },

    shibuya: {
      url:"https://rpc.shibuya.astar.network:8545",
      chainId:81,
      accounts: [privateKey],
    }
  }
};
